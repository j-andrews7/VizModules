# Each plot module builds its figure in two steps: a cached structure step
# (base_*) that draws the plot, and a styling step (generate_*) that applies
# the uniform styling inputs to it (see apply_uniform_styling()). These tests
# hold every converted module to that contract:
#   * a styling change re-styles the figure without redrawing the plot;
#   * a structural change redraws it once;
#   * going back to settings already drawn is served from the cache;
#   * with Auto Update off, nothing redraws until Update is pressed;
#   * no styling input changes what the structure step draws, since the cache
#     key leaves them out (a stale plot otherwise).

# One entry per module: its server, data, a complete input set, the plot
# function it calls (counted to see when the plot is drawn), its reactives and a
# structural change to make.
.two_tier_cases <- function() {
    list(
        bar = list(
            server = plotthis_BarPlotServer, data = example_bar, builder = "BarPlot",
            base = "base_BarPlot", generate = "generate_BarPlot",
            inputs = .box_inputs(
                x.data = "Group", y.data = "Values", fill.by = "", width = 0.9, alpha = 1,
                expand = "", palreverse = FALSE, lower.quantile = 0, upper.quantile = 1,
                lower.cutoff = NA, upper.cutoff = NA
            ),
            structural = list(alpha = 0.5)
        ),
        area = list(
            server = plotthis_AreaPlotServer, data = example_population, builder = "AreaPlot",
            base = "base_AreaPlot", generate = "generate_AreaPlot",
            inputs = .box_inputs(x.data = "year", y.data = "count", group.by = "age_group", scale.y = FALSE, alpha = 1),
            structural = list(alpha = 0.5)
        ),
        density = list(
            server = plotthis_DensityPlotServer, data = example_demographics, builder = "DensityPlot",
            base = "base_DensityPlot", generate = "generate_DensityPlot",
            inputs = .box_inputs(
                x.data = "salary", group.by = "job_level", add.bars = FALSE, bar.alpha = 1,
                bar.height = 0.04, bar.width = 1, plot.alpha = 0.5, position = "identity",
                single.fill.color = "#1F77B4"
            ),
            structural = list(plot.alpha = 0.8)
        ),
        histogram = list(
            server = plotthis_HistogramServer, data = example_demographics, builder = "Histogram",
            base = "base_Histogram", generate = "generate_Histogram",
            inputs = .box_inputs(
                x.data = "age", group.by = "job_level", add.bars = FALSE, bar.alpha = 1,
                bar.height = 0.04, bar.width = 1, plot.alpha = 0.55, position = "identity",
                single.fill.color = "#1F77B4", bins = NA, bin.width = NA, use.trend = FALSE,
                add.trend = FALSE, trend.alpha = 1, trend.linewidth = 0.8, trend.pt.size = 1.5,
                trend.skip.zero = FALSE
            ),
            structural = list(bins = 12)
        ),
        splitbar = list(
            server = plotthis_SplitBarPlotServer, data = example_bar, builder = "SplitBarPlot",
            base = "base_SplitBarPlot", generate = "generate_SplitBarPlot",
            inputs = .box_inputs(
                x.data = "Score", y.data = "Group", alpha.by = "", alpha.name = "",
                alpha.reverse = FALSE, axis.scale.factor = 1.2, bar.height = 0.9, fill.by = "",
                gradient.palette = "Spectral", label.on.y.axis = FALSE, text.position = 0,
                lower.quantile = 0, upper.quantile = 1, lower.cutoff = NA, upper.cutoff = NA,
                palreverse = FALSE, x.min = NA, x.max = NA
            ),
            structural = list(bar.height = 0.5)
        ),
        dotplot = list(
            server = plotthis_DotPlotServer, data = example_markers, builder = "DotPlot",
            base = "base_DotPlot", generate = "generate_DotPlot",
            inputs = .dot_inputs(),
            keep = c("legend.show", "legend.title.size", "legend.text.size", "legend.font.family", "legend.font.color"),
            structural = list(alpha = 0.5)
        )
    )
}

# Values to change each styling input to: anything other than the defaults the
# input sets use, of the right type.
.style_changes <- list(
    title.font.family = "Courier New", title.font.color = "#FF0000", title.font.size = 31,
    axis.title.horizontal.position = 0.3,
    axis.title.font.size = 23, axis.title.font.color = "#00FF00", axis.title.font.family = "Courier New",
    facet.title.font.size = 9, facet.title.font.color = "#0000FF", facet.title.font.family = "Courier New",
    axis.tickfont.size = 7, axis.tickfont.color = "#123456", axis.tickfont.family = "Courier New",
    axis.tickangle.x = 45, axis.tickangle.y = 30, axis.ticks = "inside", axis.tickcolor = "#654321",
    axis.ticklen = 9, axis.tickwidth = 3, show.grid.x = FALSE, show.grid.y = FALSE, grid.color = "#ABCDEF",
    hline.intercepts = "1", hline.colors = "#FF00FF", hline.widths = "3", hline.linetypes = "dash",
    hline.opacities = "0.5",
    vline.intercepts = "1", vline.colors = "#FF00FF", vline.widths = "3", vline.linetypes = "dash",
    vline.opacities = "0.5",
    abline.slopes = "1", abline.intercepts = "0", abline.colors = "#FF00FF", abline.widths = "3",
    abline.linetypes = "dash", abline.opacities = "0.5",
    download.format = "png", shape.fill = "#FF0000", shape.line.color = "#00FF00", shape.line.width = 2,
    shape.linetype = "dash", shape.opacity = 0.5,
    margin.t = 11, margin.b = 12, margin.l = 13, margin.r = 14,
    legend.show = FALSE, legend.font.family = "Courier New", legend.font.color = "#FF0000",
    legend.title.size = 21, legend.text.size = 19
)

# Run `code` in a testServer session for `case`, counting calls to its plot
# function. `code` sees `draws()` (calls so far), `base()`, `styled()` and
# `set()`, which sets inputs (ggplotly's warnings about unsupported geoms aside).
.with_two_tier <- function(case, code) {
    draws <- 0
    real <- get(case$builder, envir = asNamespace("VizModules"))
    mock <- list(function(...) {
        draws <<- draws + 1
        real(...)
    })
    names(mock) <- case$builder
    do.call(testthat::local_mocked_bindings, c(mock, list(.package = "VizModules", .env = environment())))

    code <- substitute(code)
    caller <- parent.frame()
    shiny::testServer(case$server, args = list(id = "m", data = shiny::reactive(case$data)), {
        env <- environment()
        base <- function() suppressWarnings(get(case$base, envir = env)())
        styled <- function() suppressWarnings(get(case$generate, envir = env)())
        draws_so_far <- function() draws
        suppressWarnings(do.call(session$setInputs, case$inputs))
        set <- function(...) suppressWarnings(do.call(session$setInputs, c(...)))
        eval(code, list(base = base, styled = styled, draws = draws_so_far, set = set), caller)
    })
}

test_that("a styling change re-styles the figure without redrawing the plot", {
    for (nm in names(.two_tier_cases())) {
        case <- .two_tier_cases()[[nm]]
        .with_two_tier(case, {
            first <- styled()
            n <- draws()
            set(list(title.font.size = 31, hline.intercepts = "1"))
            second <- styled()
            expect_equal(draws(), n, info = nm)
            expect_false(identical(first$x$layout, second$x$layout), info = nm)
        })
    }
})

test_that("a structural change redraws the plot once, and going back is cached", {
    for (nm in names(.two_tier_cases())) {
        case <- .two_tier_cases()[[nm]]
        .with_two_tier(case, {
            styled()
            n <- draws()
            original <- case$inputs[names(case$structural)]
            set(case$structural)
            styled()
            expect_equal(draws(), n + 1, info = nm)

            set(original)
            styled()
            expect_equal(draws(), n + 1, info = nm)
        })
    }
})

test_that("with Auto Update off, nothing redraws until Update is pressed", {
    for (nm in names(.two_tier_cases())) {
        case <- .two_tier_cases()[[nm]]
        .with_two_tier(case, {
            styled()
            set(list(auto.update = FALSE))
            paused <- styled()
            n <- draws()

            set(case$structural, list(title.font.size = 31))
            expect_identical(styled()$x$layout, paused$x$layout, info = nm)
            expect_equal(draws(), n, info = nm)

            set(list(update = 1))
            expect_false(identical(styled()$x$layout, paused$x$layout), info = nm)
            expect_equal(draws(), n + 1, info = nm)
        })
    }
})

test_that("no styling input changes what the structure step draws", {
    withr::local_options(VizModules.cache = FALSE)
    for (nm in names(.two_tier_cases())) {
        case <- .two_tier_cases()[[nm]]
        # Inputs a module's structure step reads on purpose stay in its cache key.
        kept <- case$keep %||% character(0)
        .with_two_tier(case, {
            reference <- base()$fig$x
            for (id in setdiff(VizModules:::.style_input_ids, kept)) {
                original <- case$inputs[[id]]
                set(.style_changes[id])
                expect_identical(base()$fig$x, reference, info = paste(nm, id))
                if (!is.null(original)) {
                    set(stats::setNames(list(original), id))
                }
            }
        })
    }
})
