# TEMPLATE: tests/testthat/test-<plot>.R
#
# Two kinds of coverage are expected:
#   1. If you added a NEW plotting function, test it directly: happy paths, argument
#      handling, invalid input. Build the figure and inspect plotly::plotly_build().
#   2. Test the module server with shiny::testServer() wherever feasible.
#
# Tests must run headless and deterministically -- seed anything random.

# --- 1. The plotting function (only if you added one) ------------------------

test_that("<plotfn> produces the expected trace", {
    df <- data.frame(
        category = c("A", "B", "C"),
        count = c(5, 10, 15),
        stringsAsFactors = FALSE
    )

    fig <- <plotfn>(df = df, x = "category", y = "count")

    expect_s3_class(fig, "plotly")

    built <- plotly::plotly_build(fig)
    expect_equal(as.numeric(built$x$data[[1]]$y), df$count)
})

test_that("<plotfn> rejects invalid input", {
    df <- data.frame(category = c("A", "B"), count = c(1, 2))

    expect_error(<plotfn>(df = df, x = "not_a_column", y = "count"))
})

# --- 2. The module server ----------------------------------------------------

test_that("<MODULE>Server seeds inputs from defaults", {
    df <- data.frame(
        grp = rep(c("A", "B", "C"), each = 2),
        val = c(1, 2, 3, 4, 5, 6),
        stringsAsFactors = FALSE
    )

    shiny::testServer(
        <MODULE>Server,
        args = list(
            id = "plot",
            data = shiny::reactive(df),
            defaults = list(palette.colours = c(A = "red", B = "#00FF00"))
        ),
        {
            session$setInputs(x.data = "grp", y.data = "val", group.by = "", auto.update = TRUE)

            resolved <- palette_store()
            expect_equal(resolved[["A"]], "#FF0000")
            expect_equal(resolved[["B"]], "#00FF00")
            # C is unnamed by the defaults, so it falls back to the stock palette.
            expect_false(resolved[["C"]] %in% c("#FF0000", "#00FF00"))
        }
    )
})

test_that("<MODULE>Server builds a plotly figure", {
    df <- data.frame(
        grp = rep(c("A", "B"), each = 3),
        val = c(1, 2, 3, 4, 5, 6),
        stringsAsFactors = FALSE
    )

    shiny::testServer(
        <MODULE>Server,
        args = list(id = "plot", data = shiny::reactive(df)),
        {
            session$setInputs(x.data = "grp", y.data = "val", group.by = "", auto.update = TRUE)
            expect_s3_class(generate_<OUTPUTID>(), "plotly")
        }
    )
})

# --- 3. Multi-instance independence ------------------------------------------
# The example app must use the module twice with different ids and each instance must
# hold its own state. Verify this interactively via <MODULE>App() as well.
