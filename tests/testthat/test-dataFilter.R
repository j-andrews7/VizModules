# Tests for the dataFilter module's default column hiding.

test_that(".resolve_hidden_cols maps column names to zero-based DT targets", {
    cols <- c("a", "b", "c")
    expect_equal(.resolve_hidden_cols(cols, "a"), 0L)
    expect_equal(.resolve_hidden_cols(cols, c("c", "b")), c(2L, 1L))
})

test_that(".resolve_hidden_cols accepts one-based column positions", {
    cols <- c("a", "b", "c")
    expect_equal(.resolve_hidden_cols(cols, c(1, 3)), c(0L, 2L))
})

test_that(".resolve_hidden_cols returns nothing when no columns are hidden", {
    cols <- c("a", "b")
    expect_equal(.resolve_hidden_cols(cols, NULL), integer(0))
    expect_equal(.resolve_hidden_cols(cols, character(0)), integer(0))
})

test_that(".resolve_hidden_cols drops unmatched entries with a warning", {
    cols <- c("a", "b")
    expect_warning(out <- .resolve_hidden_cols(cols, c("a", "nope")), "nope")
    expect_equal(out, 0L)

    expect_warning(out <- .resolve_hidden_cols(cols, c(2, 7)), "7")
    expect_equal(out, 1L)
})

test_that(".resolve_hidden_cols de-duplicates repeated targets", {
    expect_equal(.resolve_hidden_cols(c("a", "b"), c("b", "b")), 1L)
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
