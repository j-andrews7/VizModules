#' Create an example Modular parallelCoordinatesPlot Shiny Application
#'
#' This function generates a Shiny application with modular
#' [VizModules::parallelCoordinatesPlot()] components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive parallel coordinates plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `gallery_sales` as an example dataset. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("sales" = example_sales)` is used as example data. Each data frame
#'   should contain at least two numeric or categorical columns.
#' @param defaults A named list of input IDs and their default values to apply on startup.
#' @param hide.inputs A character vector of input IDs to hide. Their values are still
#'   initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs are
#'   still initialized and used, but the controls are not shown in the UI.
#' @return A Shiny app object.
#'
#' @seealso [VizModules::parallelCoordinatesPlot()], [VizModules::parallelCoordinatesPlotInputsUI()],
#' [VizModules::parallelCoordinatesPlotOutputUI()], [VizModules::parallelCoordinatesPlotServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- parallelCoordinatesPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' app2 <- parallelCoordinatesPlotApp(list("sales" = example_sales))
#' if (interactive()) runApp(app2)
parallelCoordinatesPlotApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        data_list <- list("sales" = example_sales)
    }
    createModuleApp(
        inputs_ui_fn = parallelCoordinatesPlotInputsUI,
        output_ui_fn = parallelCoordinatesPlotOutputUI,
        server_fn    = parallelCoordinatesPlotServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular Parallel Coordinates Plots"
    )
}
