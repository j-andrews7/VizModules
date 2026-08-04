#' Create an example Modular ComplexHeatmap Shiny Application
#'
#' This function generates a Shiny application with modular
#' [ComplexHeatmap::Heatmap()] components rendered interactively via
#' \pkg{InteractiveComplexHeatmap}. The app features a **Data Import** section for
#' uploading data, a **Data Table** for filtering the active dataset, and a
#' **Plot** area for configuring and displaying the interactive heatmap.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `example_matrix_df` (a column-scaled `mtcars`) as an example dataset. Uploaded
#' data files are added to the available datasets and can be selected for
#' plotting. If an uploaded file shares a name with an existing dataset, the
#' existing one is overwritten with a warning.
#'
#' Unlike the other modules, this one depends on the Bioconductor packages
#' \pkg{ComplexHeatmap}, \pkg{InteractiveComplexHeatmap}, and \pkg{circlize},
#' which must be installed (e.g. via `BiocManager::install()`).
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the
#'   default), `list("matrix" = example_matrix_df)` is used as example data.
#' @param defaults A named list of input IDs and their default values to apply on startup.
#'   An entry may also be a [shiny::reactive()] or [shiny::reactiveVal()] to have the input
#'   follow the parent app's state; see [setup_reactive_defaults()].
#' @param hide.inputs A character vector of input IDs to hide. Their values are
#'   still initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs
#'   are still initialized and used, but the controls are not shown in the UI.
#' @return A Shiny app object.
#'
#' @seealso [ComplexHeatmap::Heatmap()], [VizModules::ComplexHeatmap_HeatmapInputsUI()],
#' [VizModules::ComplexHeatmap_HeatmapOutputUI()], [VizModules::ComplexHeatmap_HeatmapServer()]
#'
#' @export
#' @author Jacob Martin
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- ComplexHeatmap_HeatmapApp()
#' if (interactive()) shiny::runApp(app)
ComplexHeatmap_HeatmapApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
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
    if (is.null(data_list)) {
        data_list <- list("matrix" = example_matrix_df)
    }
    createModuleApp(
        inputs_ui_fn  = ComplexHeatmap_HeatmapInputsUI,
        output_ui_fn  = ComplexHeatmap_HeatmapOutputUI,
        server_fn     = ComplexHeatmap_HeatmapServer,
        data_list     = data_list,
        defaults      = defaults,
        hide.inputs   = hide.inputs,
        hide.tabs     = hide.tabs,
        title         = "Modular ComplexHeatmap"
    )
}
