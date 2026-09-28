# Tests for resolve_column_targets() and the dataFilter module's column hiding.

test_that("resolve_column_targets maps names or one-based positions to zero-based DT targets", {
    cols <- c("a", "b", "c")
    expect_equal(resolve_column_targets(cols, "a"), 0L)
    expect_equal(resolve_column_targets(cols, c("c", "b")), c(2L, 1L))
    expect_equal(resolve_column_targets(cols, c(1, 3)), c(0L, 2L))
    # A data frame works as well as its column names.
    expect_equal(resolve_column_targets(iris, "Species"), resolve_column_targets(names(iris), "Species"))
    # Nothing hidden gives nothing; repeats are de-duplicated.
    expect_equal(resolve_column_targets(cols, NULL), integer(0))
    expect_equal(resolve_column_targets(cols, character(0)), integer(0))
    expect_equal(resolve_column_targets(cols, c("b", "b")), 1L)
})

test_that("resolve_column_targets shifts targets when row names occupy column 0", {
    cols <- c("a", "b", "c")
    expect_equal(resolve_column_targets(cols, "a", rownames = TRUE), 1L)
    expect_equal(resolve_column_targets(cols, c(1, 3), rownames = TRUE), c(1L, 3L))
    expect_equal(resolve_column_targets(cols, NULL, rownames = TRUE), integer(0))
})

test_that("resolve_column_targets rejects a non-name, non-position selection", {
    expect_error(resolve_column_targets(c("a", "b"), list("a")), "'columns' must be")
})

test_that("resolve_column_targets drops unmatched entries with a warning", {
    cols <- c("a", "b")
    expect_warning(out <- resolve_column_targets(cols, c("a", "nope")), "nope")
    expect_equal(out, 0L)

    expect_warning(out <- resolve_column_targets(cols, c(2, 7)), "7")
    expect_equal(out, 1L)
})

test_that("dataFilterServer rejects a non-name, non-position hide.columns", {
    expect_error(
        dataFilterServer("f", shiny::reactive(iris), hide.columns = list("a")),
        "hide.columns"
    )
})

test_that("dataFilterServer waits instead of erroring when data is NULL", {
    # A parent app can emit NULL briefly while switching datasets; that must not
    # take the table (and every downstream plot module) down with it.
    data_val <- shiny::reactiveVal(NULL)

    shiny::testServer(
        dataFilterServer,
        args = list(data = data_val),
        {
            session$setInputs(table_rows_all = 1:5)
            expect_error(session$returned(), class = "shiny.silent.error")

            data_val(iris)
            expect_equal(nrow(session$returned()), 5)
        }
    )
})

test_that("dataFilterServer coerces data that is not already a data frame", {
    m <- as.matrix(mtcars)

    shiny::testServer(
        dataFilterServer,
        args = list(data = shiny::reactive(m)),
        {
            session$setInputs(table_rows_all = seq_len(nrow(m)))
            expect_s3_class(session$returned(), "data.frame")
            expect_equal(names(session$returned()), colnames(m))
        }
    )
})

test_that("dataFilterServer keeps hidden columns in the returned data", {
    shiny::testServer(
        dataFilterServer,
        args = list(
            data = shiny::reactive(iris),
            hide.columns = "Species"
        ),
        {
            # Rows the DT filters left visible; hiding is display-only, so the
            # returned data still carries every column.
            session$setInputs(table_rows_all = 1:10)
            expect_equal(nrow(session$returned()), 10)
            expect_equal(names(session$returned()), names(iris))
        }
    )
})

test_that("dataFilterServer renders only the requested columns hidden, with colvis on request", {
    configs <- list(
        list(args = list(hide.columns = c("Sepal.Width", "Species")), hidden = c(1, 4), colvis = FALSE),
        list(args = list(hide.columns = "Species", col.visibility = TRUE), hidden = 4, colvis = TRUE),
        list(args = list(), hidden = NULL, colvis = FALSE)
    )
    for (cfg in configs) {
        shiny::testServer(
            dataFilterServer,
            args = c(list(data = shiny::reactive(iris)), cfg$args),
            {
                # The widget arrives as JSON; dig out the DataTables options. DT
                # always emits columnDefs for its own name/target mapping, so look
                # only at the ones that turn a column off.
                opts <- jsonlite::fromJSON(output$table, simplifyVector = FALSE)$x$options
                off <- Filter(function(def) isFALSE(def$visible), opts$columnDefs)
                expect_equal(unlist(lapply(off, function(def) unlist(def$targets))), cfg$hidden)
                expect_identical(identical(opts$buttons[[1]]$extend, "colvis"), cfg$colvis)
            }
        )
    }
})

test_that("dataFilterServer never applies a previous table's rows to new data", {
    data_val <- shiny::reactiveVal(iris)

    shiny::testServer(
        dataFilterServer,
        args = list(data = data_val),
        {
            session$setInputs(table_rows_all = seq_len(nrow(iris)))
            expect_equal(nrow(session$returned()), nrow(iris))

            # A smaller dataset arrives before DT has redrawn and reported its rows.
            data_val(mtcars)
            session$flushReact()
            out <- session$returned()
            expect_lte(nrow(out), nrow(mtcars))
            expect_false(anyNA(out$mpg))

            # Once DT reports the new table's rows, they apply as usual.
            session$setInputs(table_rows_all = 1:4)
            expect_equal(rownames(session$returned()), rownames(mtcars)[1:4])
        }
    )
})
