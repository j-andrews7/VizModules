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

# Start the module on `inputs` with statistics on, supplying the stat.pairs echo
# the mock session never sends back.
.box_stats_figure <- function(df, inputs) {
    fig <- NULL
    stats <- NULL
    shiny::testServer(
        plotthis_BoxPlotServer,
        args = list(id = "box", data = shiny::reactive(df)),
        {
            suppressWarnings({
                do.call(session$setInputs, inputs)
                session$flushReact()
                session$setInputs(stat.pairs = "")
                session$flushReact()
            })
            fig <<- suppressWarnings(generate_BoxPlot())
            stats <<- last_stats_df()
        }
    )
    list(fig = fig, stats = stats)
}

test_that("significance brackets stay within the axis they are drawn on", {
    out <- .box_stats_figure(example_demographics, .box_inputs(stats.enabled = TRUE))
    expect_brackets_within_axes(out$fig, min.count = 3)
})

test_that("a rotated box plot tests but draws no brackets over its values", {
    out <- .box_stats_figure(example_demographics, .box_inputs(stats.enabled = TRUE, rotate = TRUE))
    built <- plotly::plotly_build(out$fig)
    brackets <- Filter(function(s) identical(s$type, "line") && .data_ref(s$yref), built$x$layout$shapes)
    expect_length(brackets, 0)
    expect_s3_class(out$stats, "data.frame")
    expect_gt(nrow(out$stats), 0)
})

test_that("under a free y facet scale each panel's brackets sit on its own data", {
    set.seed(7)
    df <- data.frame(
        grp = rep(rep(c("A", "B"), each = 10), 2),
        panel = rep(c("small", "large"), each = 20),
        value = c(rnorm(10, 5), rnorm(10, 7), rnorm(10, 500, 20), rnorm(10, 700, 20)),
        stringsAsFactors = FALSE
    )
    out <- .box_stats_figure(df, .box_inputs(
        x.data = "grp", y.data = "value", facet.by = "panel", facet.scale = "free_y",
        stats.enabled = TRUE, y.min = NA
    ))
    built <- expect_brackets_within_axes(out$fig, min.count = 2)
    y_axes <- grep("^yaxis[0-9]*$", names(built$x$layout), value = TRUE)
    tops <- vapply(y_axes, function(a) max(unlist(built$x$layout[[a]]$range)), numeric(1))
    expect_lt(min(tops), 50)
    expect_gt(max(tops), 700)
})

# The y-limit tests run the same scenario on the BoxPlot and the BarPlot: the
# module, its data, the inputs that start it, and the range its data gives a
# y column. The BarPlot sums bars per x, and pads by its server's own factor.
.bar_axis_scale <- 1.18
.limit_cases <- list(
    box = list(
        server = plotthis_BoxPlotServer, data = example_demographics, x = "department",
        start = function(...) .box_inputs(...),
        range = function(col) {
            v <- example_demographics[[col]]
            list(min = min(v), max = max(v) * .y_axis_scale_factor)
        }
    ),
    bar = list(
        server = plotthis_BarPlotServer, data = example_bar, x = "Group",
        start = function(...) {
            utils::modifyList(list(
                auto.update = TRUE, x.data = "Group", y.data = "Values",
                group.by = "", fill.by = "", facet.by = "", y.min = 0, y.max = NA
            ), list(...))
        },
        range = function(col) {
            list(min = 0, max = max(tapply(example_bar[[col]], example_bar$Group, sum)) * .bar_axis_scale)
        }
    )
)

test_that("Reset restores the y limits of the column it resets y.data to", {
    # The default y column is not the first numeric one (age / Values is), which
    # is what Reset used to measure regardless of the default it restored.
    for (nm in names(.limit_cases)) {
        case <- .limit_cases[[nm]]
        y_col <- if (nm == "box") "salary" else "Score"
        shiny::testServer(
            case$server,
            args = list(id = nm, data = shiny::reactive(case$data), defaults = list(x.data = case$x, y.data = y_col)),
            {
                suppressWarnings(do.call(session$setInputs, case$start(y.data = y_col)))
                suppressWarnings(session$flushReact())
                session$setInputs(y.max = 1e7)
                expect_equal(y_range_store()$max, 1e7, info = nm)

                suppressWarnings(session$setInputs(reset = 1))
                expect_equal(y_range_store(), case$range(y_col), info = nm)
            }
        )
    }
})

test_that("the comparisons named in defaults are selected on load and again on Reset", {
    calls <- new.env()
    calls$pairs <- list()
    local_mocked_bindings(update_viz_select = function(session, inputId, choices = NULL, selected = NULL, ...) {
        if (identical(inputId, "stat.pairs")) {
            calls$pairs[[length(calls$pairs) + 1]] <- selected
        }
        invisible(NULL)
    })

    defaults <- list(
        x.data = "job_level", y.data = "salary",
        stat.pairs = c("Mid vs Entry", "Senior vs Lead")
    )

    shiny::testServer(
        plotthis_BoxPlotServer,
        args = list(id = "box", data = shiny::reactive(example_demographics), defaults = defaults),
        {
            suppressWarnings(do.call(session$setInputs, .box_inputs(x.data = "job_level", stats.enabled = TRUE)))
            suppressWarnings(session$flushReact())
            expect_equal(calls$pairs[[length(calls$pairs)]], c("Entry vs Mid", "Senior vs Lead"))

            n <- length(calls$pairs)
            suppressWarnings(session$setInputs(reset = 1))
            expect_gt(length(calls$pairs), n)
            expect_equal(calls$pairs[[length(calls$pairs)]], c("Entry vs Mid", "Senior vs Lead"))
        }
    )
})

test_that(".seed_axis_limits keeps seeded limits for the starting columns only", {
    seed <- .seed_axis_limits(list(y.max = 50), "y.min", "y.max")
    data_range <- list(min = 1, max = 10)

    # Only the limit given is seeded; the other comes from the data.
    expect_equal(seed(data_range, "a"), list(min = 1, max = 50))
    # Recomputed for the same columns (a second observer, an unrelated input).
    expect_equal(seed(data_range, "a"), list(min = 1, max = 50))
    # New columns: the data's range, and for good, even back on the old ones.
    expect_equal(seed(data_range, "b"), data_range)
    expect_equal(seed(data_range, "a"), data_range)
    expect_null(seed(NULL, "a"))

    # Nothing seeded: always the data's range.
    expect_equal(.seed_axis_limits(NULL, "y.min", "y.max")(data_range, "a"), data_range)
})

test_that("y.min/y.max defaults survive startup until y.data changes", {
    for (nm in names(.limit_cases)) {
        case <- .limit_cases[[nm]]
        start_y <- if (nm == "box") "salary" else "Values"
        new_y <- if (nm == "box") "age" else "Score"
        defaults <- list(x.data = case$x, y.data = start_y, y.min = -10, y.max = 3e5)
        shiny::testServer(
            case$server,
            args = list(id = nm, data = shiny::reactive(case$data), defaults = defaults),
            {
                suppressWarnings(do.call(session$setInputs, case$start(y.data = start_y, y.min = -10, y.max = 3e5)))
                suppressWarnings(session$flushReact())
                expect_equal(y_range_store(), list(min = -10, max = 3e5), info = nm)

                suppressWarnings(session$setInputs(y.data = new_y))
                expect_equal(y_range_store()$max, case$range(new_y)$max, info = nm)
            }
        )
    }
})

test_that("SplitBarPlot x.min/x.max defaults survive startup until the columns change", {
    sent <- new.env()
    local_mocked_bindings(updateNumericInput = function(session, inputId, label = NULL, value = NULL, ...) {
        if (inputId %in% c("x.min", "x.max")) {
            sent[[inputId]] <- value
        }
        invisible(NULL)
    })
    defaults <- list(x.data = "Score", y.data = "Group", x.min = -40, x.max = 40)

    shiny::testServer(
        plotthis_SplitBarPlotServer,
        args = list(id = "sb", data = shiny::reactive(example_bar), defaults = defaults),
        {
            suppressWarnings(session$setInputs(
                auto.update = TRUE, x.data = "Score", y.data = "Group", fill.by = "Group",
                axis.scale.factor = 1.2, x.min = -40, x.max = 40
            ))
            suppressWarnings(session$flushReact())
            expect_equal(sent[["x.max"]], 40)
            expect_equal(sent[["x.min"]], -40)

            # A new value column gets limits from its own data.
            suppressWarnings(session$setInputs(x.data = "Numbers"))
            expect_equal(sent[["x.max"]], axis_range()$max)
            expect_equal(sent[["x.min"]], -axis_range()$max)
        }
    )
})
