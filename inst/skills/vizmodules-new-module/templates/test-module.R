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
# testServer() starts with every input NULL, and the shared tabs' helpers read theirs
# unguarded, so give the figure-building reactive a complete set of inputs. Start from
# what your *InputsUI() initialises and add any you add to the UI.

.<plot>_inputs <- function(...) {
    base <- list(
        x.data = "grp", y.data = "val", group.by = "", alpha = 1,
        auto.update = TRUE, update = 0,
        facet.by = "", facet.scale = "fixed", facet.ncol = NA, facet.nrow = NA, facet.by.row = TRUE,
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        download.format = "svg", legend.show = TRUE, legend.font.family = "Arial",
        legend.font.color = "#000000", legend.title.size = 14, legend.text.size = 12,
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        grid.color = "#CCCCCC", axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 18,
        facet.title.font.color = "#000000", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "", abline.intercepts = "",
        shape.fill = "rgba(0, 0, 0, 0)", shape.line.color = "black", shape.line.width = 4,
        shape.linetype = "solid", shape.opacity = 1,
        margin.l = 70, margin.r = 90, margin.t = 70, margin.b = 70
    )
    utils::modifyList(base, list(...))
}

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
            do.call(session$setInputs, .<plot>_inputs())

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
            do.call(session$setInputs, .<plot>_inputs())
            expect_s3_class(generate_<OUTPUTID>(), "plotly")

            # A Group By column, and a reset back to the defaults.
            do.call(session$setInputs, .<plot>_inputs(group.by = "grp"))
            expect_s3_class(generate_<OUTPUTID>(), "plotly")
            session$setInputs(reset = 1)
        }
    )
})

test_that("<MODULE>InputsUI leaves ID-like columns out of Group By", {
    df <- data.frame(
        grp = rep(c("A", "B"), 30),
        id = paste0("s", seq_len(60)),
        val = seq_len(60),
        stringsAsFactors = FALSE
    )
    # discrete_choices() caps categorical selectors at 50 levels, but a column the
    # app names in `defaults` is still offered.
    expect_false("id" %in% discrete_choices(df))
    expect_true("id" %in% discrete_choices(df, keep = "id"))
    expect_s3_class(<MODULE>InputsUI("plot", df, defaults = list(group.by = "id")), "shiny.tag.list")
})

# --- 3. Multi-instance independence ------------------------------------------
# The example app must use the module twice with different ids and each instance must
# hold its own state. Verify this interactively via <MODULE>App() as well.
