# The example datasets and the "showcase" defaults each module opens on.
#
# One registry feeds the module gallery (moduleGalleryApp()), the Figure Builder
# (.figure_builder_registry()), and every module's *App() function, so a module
# opens on the same figure wherever it is demonstrated. The defaults go beyond
# picking columns: they switch on the features a module is worth reaching for
# (significance brackets, highlights, fit lines, annotations, splits), and the
# bundled data in data-raw/generate_example_data.R is built so each of them has
# something real to show. tests/testthat/test-showcase.R checks both halves.
#
# Adding a module to the package means adding its entry here; the gallery,
# the Figure Builder, and the module's *App() then all pick it up.


#' Bundled datasets offered by the gallery, the Figure Builder, and `*App()`s
#'
#' The bundled example datasets, plus `sales_by_region` (an `example_sales`
#' summary suited to the pie plot) and `example_heatmap`, a two-table entry
#' pairing `example_heatmap_matrix` with its per-sample metadata so the
#' `ComplexHeatmap` module's column annotations, splits and filters work.
#'
#' @return A named list of data frames, and of lists of data frames for
#'   multi-table entries.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_example_datasets
#' @keywords internal
.example_datasets <- function() {
    list(
        "example_sales"           = example_sales,
        "example_bar"             = example_bar,
        "example_demographics"    = example_demographics,
        "example_markers"         = example_markers,
        "example_school_earnings" = example_school_earnings,
        "example_skills"          = example_skills,
        "example_rnaseq"          = example_rnaseq,
        "example_iris"            = example_iris,
        "example_mtcars"          = example_mtcars,
        "example_population"      = example_population,
        "example_composition"     = example_composition,
        "sales_by_region"         = stats::aggregate(revenue ~ region, example_sales, sum),
        # Only the matrix is filtered and shown in a table; the metadata rides along.
        "example_heatmap"         = list(
            matrix = example_heatmap_matrix,
            column_annotations = example_heatmap_column_data
        )
    )
}


#' Whether the ComplexHeatmap module's Bioconductor dependencies are installed
#'
#' @return A single logical.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_available
#' @keywords internal
.heatmap_available <- function() {
    all(vapply(
        c("ComplexHeatmap", "InteractiveComplexHeatmap", "circlize"),
        requireNamespace, logical(1),
        quietly = TRUE
    ))
}


#' The showcase registry: each module, its example dataset, and its defaults
#'
#' @details
#' Each entry is a list with:
#' \itemize{
#'   \item `label` - The module's name in the Figure Builder's picker.
#'   \item `tab_label` - The shorter name on its module gallery tab.
#'   \item `dataset` - The [.example_datasets()] entry its `defaults` are written for.
#'   \item `inputs_ui`, `output_ui`, `server_fn` - The module's three functions.
#'   \item `defaults` - The input defaults it opens on.
#'   \item `primary.table`, `static_output_ui` - Heatmap only: the table of its
#'     two-table dataset that gets filtered, and the plain output the Figure
#'     Builder uses in place of the interactive widget.
#' }
#'
#' The heatmap entry is present only when its Bioconductor dependencies are
#' installed, since its server stops outright without them.
#'
#' @return A named list of module entries, keyed by module id.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_module_showcase
#' @keywords internal
.module_showcase <- function() {
    registry <- list(
        area = list(
            label = "Area Plot", tab_label = "Area", dataset = "example_population",
            inputs_ui = plotthis_AreaPlotInputsUI,
            output_ui = plotthis_AreaPlotOutputUI,
            server_fn = plotthis_AreaPlotServer,
            # Each age group's share of the total, so the ageing population
            # reads straight off the plot. Fifty year labels only fit upright.
            defaults = list(
                "x.data" = "year", "y.data" = "count", "group.by" = "age_group",
                "scale.y" = TRUE, "axis.tickfont.size" = 9, "axis.tickangle.x" = -90
            )
        ),
        bar = list(
            label = "Bar Plot", tab_label = "Bar", dataset = "example_bar",
            inputs_ui = plotthis_BarPlotInputsUI,
            output_ui = plotthis_BarPlotOutputUI,
            server_fn = plotthis_BarPlotServer,
            defaults = list("x.data" = "Group", "y.data" = "Values", "group.by" = "Type")
        ),
        box = list(
            label = "Box Plot", tab_label = "Box", dataset = "example_demographics",
            inputs_ui = plotthis_BoxPlotInputsUI,
            output_ui = plotthis_BoxPlotOutputUI,
            server_fn = plotthis_BoxPlotServer,
            # Brackets between neighbouring job levels only, rather than all six
            # pairs, and the top performers picked out among the points.
            defaults = list(
                "x.data" = "job_level", "y.data" = "salary",
                "add.points" = TRUE, "pt.alpha" = 0.35,
                "stats.enabled" = TRUE, "stat.display" = "symbol",
                "stat.pairs" = c("Entry vs Mid", "Mid vs Senior", "Senior vs Lead"),
                "highlight" = "performance >= 9",
                "highlight.colour" = "#D55E00", "highlight.size" = 2.5
            )
        ),
        density = list(
            label = "Density Plot", tab_label = "Density", dataset = "example_demographics",
            inputs_ui = plotthis_DensityPlotInputsUI,
            output_ui = plotthis_DensityPlotOutputUI,
            server_fn = plotthis_DensityPlotServer,
            # A rug beneath the curves and a line at the overall median salary.
            defaults = list(
                "x.data" = "salary", "group.by" = "job_level", "add.bars" = TRUE,
                "vline.intercepts" = as.character(stats::median(example_demographics$salary)),
                "vline.colors" = "#555555"
            )
        ),
        dotplot = list(
            label = "Dot Plot", tab_label = "Dot", dataset = "example_markers",
            inputs_ui = plotthis_DotPlotInputsUI,
            output_ui = plotthis_DotPlotOutputUI,
            server_fn = plotthis_DotPlotServer,
            # Dotted lines between each cell type's block of marker genes.
            defaults = list(
                "x.data" = "gene", "y.data" = "cell_type",
                "size.by" = "pct_expressed", "fill.by" = "avg_expression",
                "vline.intercepts" = "2.5, 4.5, 6.5, 8.5, 10.5, 11.5, 12.5",
                "vline.colors" = "#AAAAAA", "vline.linetypes" = "dotted"
            )
        ),
        dumbbell = list(
            label = "Dumbbell Plot", tab_label = "Dumbbell", dataset = "example_school_earnings",
            inputs_ui = dumbbellPlotInputsUI,
            output_ui = dumbbellPlotOutputUI,
            server_fn = dumbbellPlotServer,
            defaults = list(
                "x.value" = c("Women", "Men"), "y.value" = "School",
                "facet.by" = "Group", "facet.scales" = "free_y",
                "vline.intercepts" = "100", "vline.colors" = "#888888",
                "palette.colours" = c("Women" = "#CC79A7", "Men" = "#0072B2")
            )
        ),
        freq = list(
            label = "Frequency Plot", tab_label = "Frequency", dataset = "example_composition",
            inputs_ui = dittoViz_freqPlotInputsUI,
            output_ui = dittoViz_freqPlotOutputUI,
            server_fn = dittoViz_freqPlotServer,
            # Each donor is a point in every cell type's panel; P07, with the
            # largest monocyte expansion, is labelled in each.
            defaults = list(
                "var" = "cell_type", "sample.by" = "sample", "group.by" = "condition",
                "stats.enabled" = TRUE,
                "annotate.by" = "sample", "highlight.points" = "P07",
                "palette.colours" = c("Healthy" = "#0072B2", "Disease" = "#D55E00")
            )
        ),
        histogram = list(
            label = "Histogram", tab_label = "Histogram", dataset = "example_demographics",
            inputs_ui = plotthis_HistogramInputsUI,
            output_ui = plotthis_HistogramOutputUI,
            server_fn = plotthis_HistogramServer,
            defaults = list(
                "x.data" = "age", "group.by" = "job_level",
                "position" = "identity", "plot.alpha" = 0.55, "add.trend" = TRUE
            )
        ),
        line = list(
            label = "Line Plot", tab_label = "Line", dataset = "example_sales",
            inputs_ui = linePlotInputsUI,
            output_ui = linePlotOutputUI,
            server_fn = linePlotServer,
            # Error bars (on by default) show each year's spread across months and regions.
            defaults = list(
                "x.value" = "year", "y.value" = "revenue", "group.by" = "product_line",
                "plot.mode" = "lines+markers"
            )
        ),
        parallel = list(
            label = "Parallel Coordinates", tab_label = "Parallel Coordinates", dataset = "example_sales",
            inputs_ui = parallelCoordinatesPlotInputsUI,
            output_ui = parallelCoordinatesPlotOutputUI,
            server_fn = parallelCoordinatesPlotServer,
            defaults = list(
                "dimensions" = c("region", "product_line", "units", "revenue", "profit"),
                "color.by" = "profit"
            )
        ),
        pie = list(
            label = "Pie Plot", tab_label = "Pie", dataset = "sales_by_region",
            inputs_ui = piePlotInputsUI,
            output_ui = piePlotOutputUI,
            server_fn = piePlotServer,
            defaults = list(
                "labels" = "region", "values" = "revenue",
                "hole" = 0.4, "textinfo" = c("label", "percent")
            )
        ),
        radar = list(
            label = "Radar Plot", tab_label = "Radar", dataset = "example_skills",
            inputs_ui = radarPlotInputsUI,
            output_ui = radarPlotOutputUI,
            server_fn = radarPlotServer,
            # The ratings' full 0-10 scale, rather than whatever range the data spans.
            defaults = list(
                "theta" = "category", "r" = "value", "group" = "player",
                "auto.radial.range" = FALSE, "radial.min" = 0, "radial.max" = 10
            )
        ),
        scatter = list(
            label = "Scatter Plot", tab_label = "Scatter", dataset = "example_sales",
            inputs_ui = dittoViz_scatterPlotInputsUI,
            output_ui = dittoViz_scatterPlotOutputUI,
            server_fn = dittoViz_scatterPlotServer,
            # One fit per product line, and the two planted outliers labelled:
            # a promotion (Sale_352) and a clearance sale (Sale_540).
            defaults = list(
                "x.by" = "units", "y.by" = "revenue", "color.by" = "product_line",
                "linear.model" = TRUE,
                "annotate.by" = "sale_id", "highlight.points" = "Sale_352, Sale_540"
            )
        ),
        splitbar = list(
            label = "Split Bar Plot", tab_label = "Split Bar", dataset = "example_bar",
            inputs_ui = plotthis_SplitBarPlotInputsUI,
            output_ui = plotthis_SplitBarPlotOutputUI,
            server_fn = plotthis_SplitBarPlotServer,
            defaults = list(
                "x.data" = "Score", "y.data" = "Group",
                "facet.by" = "Type", "alpha.by" = "Values"
            )
        ),
        yplot = list(
            label = "yPlot", tab_label = "yPlot", dataset = "example_demographics",
            inputs_ui = dittoViz_yPlotInputsUI,
            output_ui = dittoViz_yPlotOutputUI,
            server_fn = dittoViz_yPlotServer,
            # Office vs Remote within every department, and two employees who
            # buck their group's trend (see data-raw/generate_example_data.R).
            defaults = list(
                "var" = "satisfaction", "group.by" = "department", "color.by" = "work_mode",
                "plots" = c("boxplot", "jitter"),
                "stats.enabled" = TRUE,
                "annotate.by" = "employee_id", "highlight.points" = "E042, E137"
            )
        )
    )

    if (.heatmap_available()) {
        registry$heatmap <- list(
            label = "Heatmap", tab_label = "Heatmap", dataset = "example_heatmap",
            primary.table = "matrix",
            inputs_ui = ComplexHeatmap_HeatmapInputsUI,
            output_ui = ComplexHeatmap_HeatmapOutputUI,
            # The Figure Builder's panel: the InteractiveComplexHeatmap widget
            # carries a border, a control strip and a fixed pixel width that do
            # not belong on a figure. See ComplexHeatmap_HeatmapStaticOutputUI().
            static_output_ui = ComplexHeatmap_HeatmapStaticOutputUI,
            server_fn = ComplexHeatmap_HeatmapServer,
            # matrix.cols defaults to every numeric column, which would sweep the
            # mean_expression annotation column into the heatmap body.
            defaults = list(
                "rowname.col" = "gene",
                "matrix.cols" = setdiff(names(example_heatmap_matrix), c("gene", "pathway", "mean_expression")),
                "column_key" = "sample",
                "scale" = "Rows",
                # 30 gene names have to fit the widget's default height.
                "row_names_fontsize" = 7,
                "row_split_by" = "Annotation", "row_split_cols" = "pathway",
                "column_split_by" = "Annotation", "column_split_cols" = "condition",
                "row_annotations" = list(r1 = list(column = "pathway", side = "Left")),
                "column_annotations" = list(
                    c1 = list(column = "condition", side = "Top"),
                    c2 = list(column = "batch", side = "Top")
                )
            )
        )
    }

    registry
}


#' A module's example dataset and showcase defaults, for its `*App()`
#'
#' @param id A module id in [.module_showcase()].
#'
#' @return A list with `data_list` (a one-entry named list holding the module's
#'   example dataset) and `defaults`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_module_example
#' @keywords internal
.module_example <- function(id) {
    entry <- .module_showcase()[[id]]
    if (is.null(entry)) {
        stop("No showcase entry for module '", id, "'.", call. = FALSE)
    }
    list(
        data_list = .example_datasets()[entry$dataset],
        defaults = entry$defaults
    )
}
