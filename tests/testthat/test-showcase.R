# The showcase registry (R/module_showcase.R) is what the module gallery, the
# Figure Builder, and every *App() open on. These tests keep its two halves in
# step: the defaults must name things that exist in their datasets and be
# accepted by the controls they seed, and the bundled data must still give the
# showcased features something to show.

# Defaults whose values are column names of the entry's dataset.
.column_keys <- c(
    "x.data", "y.data", "group.by", "fill.by", "size.by", "facet.by", "alpha.by",
    "x.by", "y.by", "color.by", "annotate.by", "var", "sample.by",
    "x.value", "y.value", "labels", "values", "theta", "r", "group", "dimensions",
    "rowname.col", "matrix.cols", "row_split_cols", "column_split_cols", "column_key"
)

.all_columns <- function(entry) {
    if (is.data.frame(entry)) names(entry) else unlist(lapply(entry, names), use.names = FALSE)
}

test_that("every showcase entry names a bundled dataset and columns that exist in it", {
    showcase <- .module_showcase()
    datasets <- .example_datasets()

    for (id in names(showcase)) {
        entry <- showcase[[id]]
        expect_true(entry$dataset %in% names(datasets), info = id)
        cols <- .all_columns(datasets[[entry$dataset]])

        for (key in intersect(names(entry$defaults), .column_keys)) {
            expect_true(all(entry$defaults[[key]] %in% cols), info = paste(id, key))
        }
    }
})

test_that("every showcase default is accepted by the control it seeds", {
    showcase <- .module_showcase()
    datasets <- .example_datasets()

    # get_default() quietly falls back when a value fails its check, so a typo'd
    # column or a wrongly typed value would just vanish from the demo.
    original <- get_default
    rejected <- character(0)
    local_mocked_bindings(get_default = function(defaults, key, fallback, validator = NULL) {
        if (!is.null(validator) && !is.null(defaults) && key %in% names(defaults) &&
            !isTRUE(validator(defaults[[key]]))) {
            rejected <<- c(rejected, key)
        }
        original(defaults, key, fallback, validator)
    })

    for (id in names(showcase)) {
        entry <- showcase[[id]]
        rejected <- character(0)
        expect_no_error(entry$inputs_ui(id, datasets[[entry$dataset]], defaults = entry$defaults))
        expect_identical(unique(rejected), character(0), info = id)
    }
})

test_that("the Figure Builder registry is the showcase registry", {
    showcase <- .module_showcase()
    registry <- .figure_builder_registry()

    expect_named(registry, names(showcase))
    for (id in names(registry)) {
        expect_identical(registry[[id]]$defaults, showcase[[id]]$defaults, info = id)
        expect_identical(registry[[id]]$dataset, showcase[[id]]$dataset, info = id)
        expect_null(registry[[id]]$tab_label)
        expect_null(registry[[id]]$static_output_ui)
    }
})

test_that("every module's *App() opens on its showcase dataset and defaults", {
    apps <- list(
        area = plotthis_AreaPlotApp, bar = plotthis_BarPlotApp, box = plotthis_BoxPlotApp,
        density = plotthis_DensityPlotApp, dotplot = plotthis_DotPlotApp,
        dumbbell = dumbbellPlotApp, freq = dittoViz_freqPlotApp, histogram = plotthis_HistogramApp,
        line = linePlotApp, parallel = parallelCoordinatesPlotApp, pie = piePlotApp,
        radar = radarPlotApp, scatter = dittoViz_scatterPlotApp,
        splitbar = plotthis_SplitBarPlotApp, yplot = dittoViz_yPlotApp
    )
    showcase <- .module_showcase()
    expect_setequal(names(apps), setdiff(names(showcase), "heatmap"))

    for (id in names(apps)) {
        app <- apps[[id]]()
        expect_s3_class(app, "shiny.appobj")
        env <- environment(app$serverFuncSource())
        expect_named(get("data_list", envir = env), showcase[[id]]$dataset)
        expect_identical(get("defaults", envir = env), showcase[[id]]$defaults, info = id)
    }

    # A caller's defaults are layered over the showcase ones rather than replacing them.
    env <- environment(plotthis_BoxPlotApp(defaults = list(y.data = "age"))$serverFuncSource())
    merged <- get("defaults", envir = env)
    expect_equal(merged$y.data, "age")
    expect_true(merged$stats.enabled)

    # And a caller's own data gets none of them.
    env <- environment(plotthis_BoxPlotApp(data_list = list(iris = iris))$serverFuncSource())
    expect_null(get("defaults", envir = env))
})

test_that("moduleGalleryApp builds one tab per module plus the Figure Builder", {
    expect_s3_class(moduleGalleryApp(), "shiny.appobj")

    parts <- moduleGalleryApp(return_components = TRUE)
    expect_named(parts, c("ui", "server"))
    expect_true(is.function(parts$server))

    html <- as.character(parts$ui)
    expect_true(grepl("figure_builder-pb_canvas", html))
    for (id in c(names(.module_showcase()), "about", "figure_builder")) {
        expect_true(grepl(sprintf('data-value="%s"', id), html, fixed = TRUE), info = id)
    }
})

# --- The data behind the showcased features -----------------------------------

test_that("the BoxPlot's showcased comparisons are all significant", {
    defaults <- .module_showcase()$box$defaults
    stats <- compute_pairwise_stats(
        example_demographics,
        x = defaults$x.data, y = defaults$y.data,
        pairs = parse_pair_strings(defaults$stat.pairs)
    )
    expect_equal(nrow(stats), length(defaults$stat.pairs))
    expect_true(all(stats$p.adj < 0.05))

    # The highlight picks out a handful of points, not none and not most.
    hits <- safe_eval_filter(defaults$highlight, example_demographics)
    expect_true(sum(hits) >= 3 && sum(hits) <= 50)
})

test_that("the yPlot's Office vs Remote comparison holds in every department", {
    defaults <- .module_showcase()$yplot$defaults
    stats <- compute_pairwise_stats(
        example_demographics,
        x = defaults$group.by, y = defaults$var, group.by = defaults$color.by
    )
    expect_equal(nrow(stats), nlevels(example_demographics$department))
    expect_true(all(stats$p.adj < 0.05))
})

test_that("the freqPlot's disease effect survives multiple-testing correction", {
    defaults <- .module_showcase()$freq$defaults
    summ <- .freq_summary(
        example_composition,
        var = defaults$var, sample.by = defaults$sample.by, group.by = defaults$group.by
    )
    stats <- compute_pairwise_stats(summ, x = "grouping", y = "percent", facet.by = "label")
    significant <- stats$facet_level[stats$p.adj < 0.05]
    expect_true(all(c("Monocyte", "CD4 T") %in% significant))
})

test_that("the showcased highlights name points that exist", {
    showcase <- .module_showcase()
    datasets <- .example_datasets()

    for (id in c("scatter", "yplot", "freq")) {
        defaults <- showcase[[id]]$defaults
        column <- datasets[[showcase[[id]]$dataset]][[defaults$annotate.by]]
        values <- parse_highlight_values(defaults$highlight.points, column)
        expect_gt(length(values), 0)
        expect_true(all(values %in% as.character(column)), info = id)
    }
})

test_that("the scatter plot's sales show one clear slope per product line", {
    fits <- lapply(split(example_sales, example_sales$product_line), function(d) {
        stats::lm(revenue ~ units, data = d)
    })
    slopes <- vapply(fits, function(f) unname(stats::coef(f)[2]), numeric(1))
    r2 <- vapply(fits, function(f) summary(f)$r.squared, numeric(1))

    expect_true(all(r2 > 0.8))
    # Distinct slopes, so the per-group fit lines visibly fan out.
    expect_gt(min(diff(sort(slopes))), 0.1)
})
