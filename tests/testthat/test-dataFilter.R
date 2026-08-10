# Tests for resolve_column_targets() and the dataFilter module's column hiding.

test_that("resolve_column_targets maps column names to zero-based DT targets", {
    cols <- c("a", "b", "c")
    expect_equal(resolve_column_targets(cols, "a"), 0L)
    expect_equal(resolve_column_targets(cols, c("c", "b")), c(2L, 1L))
})

test_that("resolve_column_targets takes a data frame as well as column names", {
    expect_equal(
        resolve_column_targets(iris, "Species"),
        resolve_column_targets(names(iris), "Species")
    )
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

test_that("resolve_column_targets accepts one-based column positions", {
    cols <- c("a", "b", "c")
    expect_equal(resolve_column_targets(cols, c(1, 3)), c(0L, 2L))
})

test_that("resolve_column_targets returns nothing when no columns are hidden", {
    cols <- c("a", "b")
    expect_equal(resolve_column_targets(cols, NULL), integer(0))
    expect_equal(resolve_column_targets(cols, character(0)), integer(0))
})

test_that("resolve_column_targets drops unmatched entries with a warning", {
    cols <- c("a", "b")
    expect_warning(out <- resolve_column_targets(cols, c("a", "nope")), "nope")
    expect_equal(out, 0L)

    expect_warning(out <- resolve_column_targets(cols, c(2, 7)), "7")
    expect_equal(out, 1L)
})

test_that("resolve_column_targets de-duplicates repeated targets", {
    expect_equal(resolve_column_targets(c("a", "b"), c("b", "b")), 1L)
})

test_that("dataFilterServer rejects a non-name, non-position hide.columns", {
    expect_error(
        dataFilterServer("f", shiny::reactive(iris), hide.columns = list("a")),
        "hide.columns"
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

test_that("dataFilterServer hides the requested columns in the rendered table", {
    shiny::testServer(
        dataFilterServer,
        args = list(
            data = shiny::reactive(iris),
            hide.columns = c("Sepal.Width", "Species")
        ),
        {
            # The widget arrives as JSON; dig out the DataTables options.
            opts <- jsonlite::fromJSON(output$table, simplifyVector = FALSE)$x$options
            expect_false(opts$columnDefs[[1]]$visible)
            expect_equal(unlist(opts$columnDefs[[1]]$targets), c(1, 4))
        }
    )
})

test_that("dataFilterServer combines hidden columns with the colvis button", {
    shiny::testServer(
        dataFilterServer,
        args = list(
            data = shiny::reactive(iris),
            hide.columns = "Species",
            col.visibility = TRUE
        ),
        {
            opts <- jsonlite::fromJSON(output$table, simplifyVector = FALSE)$x$options
            expect_false(opts$columnDefs[[1]]$visible)
            expect_equal(unlist(opts$columnDefs[[1]]$targets), 4)
            expect_equal(opts$buttons[[1]]$extend, "colvis")
        }
    )
})

test_that("dataFilterServer leaves every column visible by default", {
    shiny::testServer(
        dataFilterServer,
        args = list(data = shiny::reactive(iris)),
        {
            # DT always emits columnDefs for its own name/target mapping, so
            # check that none of them turn a column off.
            opts <- jsonlite::fromJSON(output$table, simplifyVector = FALSE)$x$options
            visible <- vapply(
                opts$columnDefs,
                function(def) is.null(def$visible) || isTRUE(def$visible),
                logical(1)
            )
            expect_true(all(visible))
        }
    )
})
