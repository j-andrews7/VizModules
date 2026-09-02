#' Create an example Modular ComplexHeatmap Shiny Application
#'
#' This function generates a Shiny application with modular
#' [ComplexHeatmap::Heatmap()] components rendered interactively via
#' \pkg{InteractiveComplexHeatmap}. The app features a **Data Import** section for
#' uploading data, a **Data Table** for filtering the active dataset, and a
#' **Plot** area for configuring and displaying the interactive heatmap.
#'
#' When neither `data_list` nor `column_data` is provided, the app launches on the
#' bundled pair — `example_heatmap_matrix` (a simulated gene x sample expression
#' matrix) together with `example_heatmap_column_data` (its per-sample metadata),
#' with `column_key` seeded to `"sample"`. The column-annotation, column-split, and
#' column-filter features are all inert without a metadata table, so this way a bare
#' `ComplexHeatmap_HeatmapApp()` demonstrates the whole module.
#'
#' Either way the app has the usual **Data Import** section for uploading data and a
#' **Data Table** for filtering the active dataset. Filtering applies to the matrix;
#' any companion metadata table rides along untouched. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded file
#' shares a name with an existing dataset, the existing one is overwritten with a
#' warning.
#'
#' Unlike the other modules, this one depends on the Bioconductor packages
#' \pkg{ComplexHeatmap}, \pkg{InteractiveComplexHeatmap}, and \pkg{circlize},
#' which must be installed (e.g. via `BiocManager::install()`).
#'
#' This is a convenience wrapper around [createModuleApp()], which accepts a
#' dataset entry that is a list of tables and filters only the primary one, so
#' the two-table `list(matrix = , column_annotations = )` shape this module's
#' column features need is carried through without a bespoke app (see
#' [ComplexHeatmap_HeatmapServer()]'s `data` parameter).
#'
#' @param data_list An optional named list of data frames. If `NULL` (the
#'   default), `example_heatmap_matrix` is used as example data — paired with
#'   `example_heatmap_column_data` unless `column_data` says otherwise. When
#'   `column_data` is supplied it is attached to the first entry, which becomes
#'   `list(matrix = , column_annotations = )`.
#' @param column_data An optional data frame of per-sample metadata, enabling
#'   column annotations, column splitting, and metadata-aware column filtering.
#'   Defaults to `example_heatmap_column_data` when `data_list` is also `NULL`;
#'   pass `data_list` explicitly to opt out. Attached to the first `data_list`
#'   entry (see [ComplexHeatmap_HeatmapServer()]'s `data`
#'   parameter for the expected shape — a key column matching the matrix's
#'   column names, plus arbitrary annotation columns). When supplied, the app
#'   is a minimal single-dataset `shinyApp()` (no Data Import/Data Table
#'   sections) wiring `data = list(matrix = <first element of data_list, or
#'   example_heatmap_matrix>, column_annotations = column_data)` directly into
#'   the module.
#' @param defaults A named list of input IDs and their default values to apply on startup.
#'   An entry may also be a [shiny::reactive()] or [shiny::reactiveVal()] to have the input
#'   follow the parent app's state; see [setup_reactive_defaults()].
#' @param hide.inputs A character vector of input IDs to hide. Their values are
#'   still initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs
#'   are still initialized and used, but the controls are not shown in the UI.
#' @return A Shiny app object.
#'
#' @import shiny
#'
#' @seealso [ComplexHeatmap::Heatmap()], [VizModules::ComplexHeatmap_HeatmapInputsUI()],
#' [VizModules::ComplexHeatmap_HeatmapOutputUI()], [VizModules::ComplexHeatmap_HeatmapServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch on the bundled matrix + its per-sample metadata, so the column
#' # annotation/split/filter features are all usable:
#' app <- ComplexHeatmap_HeatmapApp()
#' if (interactive()) shiny::runApp(app)
#'
#' # Matrix only, without the per-sample metadata:
#' app2 <- ComplexHeatmap_HeatmapApp(data_list = list(matrix = example_heatmap_matrix))
#' if (interactive()) shiny::runApp(app2)
ComplexHeatmap_HeatmapApp <- function(data_list = NULL, column_data = NULL, defaults = NULL,
                                      hide.inputs = NULL, hide.tabs = NULL) {
    missing_pkgs <- Filter(
        function(pkg) !requireNamespace(pkg, quietly = TRUE),
        c("ComplexHeatmap", "InteractiveComplexHeatmap", "circlize")
    )
    if (length(missing_pkgs) > 0) {
        stop(
            "The ComplexHeatmap module requires the following Bioconductor ",
            "package(s), which are not installed: ",
            paste(missing_pkgs, collapse = ", "), ". Install them with ",
            "BiocManager::install(c(",
            paste(sprintf("'%s'", missing_pkgs), collapse = ", "), ")).",
            call. = FALSE
        )
    }

    # matrix.cols defaults to *every* numeric column, which would sweep
    # example_heatmap_matrix's mean_expression row-annotation column into the
    # heatmap body itself. Point the bundled example at just the sample
    # columns so mean_expression stays available as a row annotation; a
    # caller-supplied data_list/defaults is left alone.
    example_defaults <- function(matrix_df) {
        if (!identical(matrix_df, example_heatmap_matrix)) {
            return(list())
        }
        list(
            matrix.cols = setdiff(names(example_heatmap_matrix), c("gene", "pathway", "mean_expression")),
            rowname.col = "gene",
            # Only meaningful alongside example_heatmap_column_data, which is
            # seeded below on the same "no caller data at all" condition.
            column_key = "sample"
        )
    }

    # With no data supplied at all, open on the bundled pair rather than the
    # matrix alone: the column-annotation, column-split, and column-filter
    # features are inert without a metadata table, so a bare
    # ComplexHeatmap_HeatmapApp() would otherwise demo only half the module.
    # Guarded on data_list being NULL too -- attaching this metadata to a
    # caller's own matrix would join on sample names that do not exist there.
    if (is.null(data_list) && is.null(column_data)) {
        column_data <- example_heatmap_column_data
    }

    if (is.null(data_list)) {
        data_list <- list("matrix" = example_heatmap_matrix)
    }

    matrix_df <- .app_entry_parts(data_list[[1]])$primary
    defaults <- utils::modifyList(example_defaults(matrix_df), defaults %||% list())

    # A column-annotation table rides along beside the matrix; createModuleApp()
    # filters only the primary table and passes the rest through, so this module
    # needs no app of its own.
    if (!is.null(column_data)) {
        data_list[[1]] <- list(matrix = matrix_df, column_annotations = column_data)
    }

    createModuleApp(
        inputs_ui_fn  = ComplexHeatmap_HeatmapInputsUI,
        output_ui_fn  = ComplexHeatmap_HeatmapOutputUI,
        server_fn     = ComplexHeatmap_HeatmapServer,
        data_list     = data_list,
        defaults      = defaults,
        hide.inputs   = hide.inputs,
        hide.tabs     = hide.tabs,
        title         = "Modular ComplexHeatmap",
        primary.table = "matrix",
        # The widget's stock layout puts the original (450px) and the
        # sub-heatmap (400px) side by side, which the default 8/12 cannot fit.
        sidebar.width = 3
    )
}
