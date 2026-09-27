# The plot output cannot be driven from testServer, but the reactive that builds
# the figure can, given a complete set of inputs.
.box_inputs <- function(...) {
    base <- list(
        x.data = "department", y.data = "salary", group.by = "", show.outliers = TRUE,
        boxplot.width = 0.8, sort_x = "", rotate = FALSE, y.min = 0, y.max = NA,
        auto.update = TRUE, update = 0,
        add.points = FALSE, pt.size = 1, pt.alpha = 1, jitter.width = 0.3, pt.color = "#000000",
        highlight = "", highlight.colour = "#000000", highlight.size = 1, highlight.alpha = 1,
        facet.by = "", facet.scale = "fixed", facet.ncol = NA, facet.nrow = NA, facet.by.row = TRUE,
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        stats.enabled = FALSE, stat.test = "wilcox.test", stat.p.adjust = "holm",
        stat.display = "p.adj", stat.sig.threshold = 0.05, stat.hide.ns = FALSE,
        stat.paired = FALSE, stat.pairs = "", stat.per.facet = TRUE,
        stat.bracket.style = "capped", stat.bracket.inset = 0.025,
        stat.step.increase = 0.06, stat.text.bump = 0.04,
        stat.line.color = "#000000", stat.line.width = 1,
        download.format = "svg", legend.title.size = 14, legend.text.size = 12,
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

# The x categories in the order the figure draws them.
.box_x_order <- function(fig) {
    built <- plotly::plotly_build(fig)
    unlist(built$x$layout$xaxis$ticktext)
}

test_that("Sort X By orders the categories by a summary of the data", {
    shiny::testServer(
        plotthis_BoxPlotServer,
        args = list(id = "box", data = shiny::reactive(example_demographics)),
        {
            do.call(session$setInputs, .box_inputs(sort_x = "median(salary)"))
            suppressWarnings(session$flushReact())

            medians <- tapply(example_demographics$salary, example_demographics$department, median)
            expect_equal(.box_x_order(generate_BoxPlot()), names(sort(medians)))
        }
    )
})

test_that("Sort X By never evaluates code", {
    sentinel <- "vizmodules_sort_x_pwned"
    on.exit(if (exists(sentinel, envir = globalenv())) rm(list = sentinel, envir = globalenv()))

    shiny::testServer(
        plotthis_BoxPlotServer,
        args = list(id = "box", data = shiny::reactive(example_demographics)),
        {
            payload <- sprintf("length(assign('%s', TRUE, envir = globalenv()))", sentinel)
            do.call(session$setInputs, .box_inputs(sort_x = payload))
            suppressWarnings(session$flushReact())

            # The rejected key is dropped, so the plot still builds.
            expect_s3_class(generate_BoxPlot(), "plotly")
            expect_false(exists(sentinel, envir = globalenv()))
        }
    )
})

test_that("turning statistics off drops them from the source download", {
    shiny::testServer(
        plotthis_BoxPlotServer,
        args = list(id = "box", data = shiny::reactive(example_demographics)),
        {
            do.call(session$setInputs, .box_inputs(stats.enabled = TRUE))
            suppressWarnings(session$flushReact())
            # The pair list refresh freezes stat.pairs; the mock session never
            # echoes it back, so supply the echo by hand.
            session$setInputs(stat.pairs = "")
            suppressWarnings(session$flushReact())
            expect_s3_class(suppressWarnings(session$returned())$stats, "data.frame")

            session$setInputs(stats.enabled = FALSE)
            suppressWarnings(session$flushReact())
            expect_null(suppressWarnings(session$returned())$stats)
        }
    )
})

test_that("Reset restores the y limits of the column it resets y.data to", {
    # salary is not the first numeric column (age is), which is what the reset
    # used to measure regardless of the default it restored.
    defaults <- list(x.data = "department", y.data = "salary")

    shiny::testServer(
        plotthis_BoxPlotServer,
        args = list(id = "box", data = shiny::reactive(example_demographics), defaults = defaults),
        {
            do.call(session$setInputs, .box_inputs())
            suppressWarnings(session$flushReact())
            session$setInputs(y.max = 1e7)
            expect_equal(y_range_store()$max, 1e7)

            session$setInputs(reset = 1)
            salary <- example_demographics$salary
            expect_equal(y_range_store()$max, max(salary) * .y_axis_scale_factor)
            expect_equal(y_range_store()$min, min(salary))
        }
    )
})

test_that("BarPlot Reset restores per-x summed limits for its default y.data", {
    # Score is not the first numeric column (Values is).
    defaults <- list(x.data = "Group", y.data = "Score")

    shiny::testServer(
        plotthis_BarPlotServer,
        args = list(id = "bar", data = shiny::reactive(example_bar), defaults = defaults),
        {
            session$setInputs(
                auto.update = TRUE, x.data = "Group", y.data = "Score",
                group.by = "", fill.by = "", facet.by = "", y.min = 0, y.max = NA
            )
            suppressWarnings(session$flushReact())
            session$setInputs(y.max = 1e7)
            expect_equal(y_range_store()$max, 1e7)

            session$setInputs(reset = 1)
            sums <- tapply(example_bar$Score, example_bar$Group, sum)
            expect_equal(y_range_store()$max, max(sums) * 1.18)
            expect_equal(y_range_store()$min, 0)
        }
    )
})
