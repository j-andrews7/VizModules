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
        box = list(
            server = plotthis_BoxPlotServer, data = example_demographics, builder = "BoxPlot",
            base = "base_BoxPlot", generate = "generate_BoxPlot",
            inputs = .box_inputs(
                x.data = "job_level", add.points = TRUE, pt.alpha = 0.35,
                stats.enabled = TRUE, stat.display = "symbol"
            ),
            structural = list(pt.alpha = 0.7)
        ),
        freq = list(
            server = dittoViz_freqPlotServer, data = example_composition, builder = "freqPlot",
            base = "base_freqPlot", generate = "generate_freqPlot",
            inputs = .freq_inputs(stats.enabled = TRUE),
            keep = "legend.show",
            structural = list(jitter.size = 2)
        ),
        yplot = list(
            server = dittoViz_yPlotServer, data = example_demographics, builder = "yPlot",
            base = "base_yPlot", generate = "generate_yPlot",
            inputs = .yplot_inputs(stats.enabled = TRUE, annotate.by = "employee_id", highlight.points = "E042"),
            keep = "legend.show",
            structural = list(jitter.size = 2)
        ),
        scatter = list(
            server = dittoViz_scatterPlotServer, data = example_sales, builder = "scatterPlot",
            base = "base_scatterPlot", generate = "generate_scatterPlot",
            inputs = .scatter_inputs(
                color.by = "product_line", linear.model = TRUE,
                marginal.x = "density", marginal.y = "density",
                annotate.by = "sale_id", highlight.points = "Sale_352"
            ),
            keep = "legend.show",
            structural = list(opacity = 0.5)
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
    axis.scientific = TRUE, axis.padding.x = 0, axis.padding.y = 0,
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
        # freqPlot(data.only = TRUE) only summarises the data; it draws nothing.
        if (!isTRUE(list(...)[["data.only"]])) {
            draws <<- draws + 1
        }
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
        # A browser re-sends the inputs the server froze while updating them (the
        # stat pairs, the facet scale, ...); the mock session does not, so do that.
        frozen <- intersect(names(case$inputs), c("stat.pairs", "facet.scale", "vars.use"))
        suppressWarnings(do.call(session$setInputs, case$inputs[frozen]))
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

test_that(".settled_reactive passes on real changes only, and errors as they are", {
    server <- function(id) {
        moduleServer(id, function(input, output, session) {
            source <- reactive({
                validate(need(!identical(input$x, "bad"), "not that"))
                list(even = as.numeric(input$x) %% 2 == 0)
            })
            settled <- .settled_reactive(source)
            count <- new.env()
            count$runs <- 0
            reader <- reactive({
                count$runs <- count$runs + 1
                settled()
            })
        })
    }
    testServer(server, {
        session$setInputs(x = 2)
        expect_identical(reader(), list(even = TRUE))
        expect_identical(count$runs, 1)

        # Its source re-ran, but its value came out the same.
        session$setInputs(x = 4)
        expect_identical(reader(), list(even = TRUE))
        expect_identical(count$runs, 1)

        session$setInputs(x = 3)
        expect_identical(reader(), list(even = FALSE))
        expect_identical(count$runs, 2)

        # A validation failure reaches the reader as itself, and clears.
        session$setInputs(x = "bad")
        expect_error(reader(), "not that", class = "shiny.silent.error")
        session$setInputs(x = 5)
        expect_identical(reader(), list(even = FALSE))
    })
})

test_that("cached_structure() builds the figure it caches", {
    server <- function(id) {
        moduleServer(id, function(input, output, session) {
            data <- reactive(mtcars)
            base <- cached_structure(function(isolate_fn) {
                list(fig = plotly::plot_ly(data(), x = ~wt, y = ~mpg, type = "scatter", mode = "markers"))
            }, input, session, data)
        })
    }
    shiny::testServer(server, args = list(id = "m"), {
        session$setInputs(auto.update = TRUE)
        fig <- base()$fig
        expect_length(fig$x$data, 1)
        expect_identical(fig$x$data[[1]]$type, "scatter")
        expect_match(fig$x$layout$uirevision, "structure", fixed = TRUE)
    })
})

test_that("apply_uniform_styling() can style axis lines itself and place the legend", {
    fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
    input <- list(
        axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "#123456", axis.linewidth = 2,
        show.grid.x = TRUE, show.grid.y = TRUE, grid.color = "#CCCCCC", axis.ticks = "outside",
        axis.tickangle.x = 0, axis.tickangle.y = 0,
        download.format = "svg", legend.show = TRUE
    )

    themed <- plotly::plotly_build(apply_uniform_styling(fig, input, identity))
    expect_null(themed$x$layout$xaxis$linecolor)
    expect_null(themed$x$layout$legend$xanchor)

    styled <- plotly::plotly_build(apply_uniform_styling(
        fig, input, identity,
        ggplot.axis.styling = FALSE, legend.position = c(1.02, "left")
    ))
    expect_identical(styled$x$layout$xaxis$linecolor, "#123456")
    expect_identical(styled$x$layout$yaxis$linewidth, 2)
    expect_identical(styled$x$layout$legend$xanchor, "left")
})
