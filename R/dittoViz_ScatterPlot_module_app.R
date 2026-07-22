#' Create an example Modular scatterPlot Shiny Application
#'
#' This function generates a Shiny application with modular [dittoViz::scatterPlot()] components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive scatter plot.
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
#'   `list("sales" = gallery_sales)` is used as example data.
#' @param defaults A named list of input IDs and their default values to apply on startup.
#' @param hide.inputs A character vector of input IDs to hide. Their values are still
#'   initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs are
#'   still initialized and used, but the controls are not shown in the UI.
#' @return A Shiny app object.
#'
#' @seealso [dittoViz::scatterPlot()], [VizModules::dittoViz_scatterPlotInputsUI()],
#' [VizModules::dittoViz_scatterPlotOutputUI()], [VizModules::dittoViz_scatterPlotServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- dittoViz_scatterPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' app2 <- dittoViz_scatterPlotApp(list("sales" = example_sales))
#' if (interactive()) runApp(app2)
dittoViz_scatterPlotApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        data_list <- list("sales" = example_sales)
    }
    createModuleApp(
        inputs_ui_fn  = dittoViz_scatterPlotInputsUI,
        output_ui_fn  = dittoViz_scatterPlotOutputUI,
        server_fn     = dittoViz_scatterPlotServer,
        data_list     = data_list,
        defaults      = defaults,
        hide.inputs   = hide.inputs,
        hide.tabs     = hide.tabs,
        title         = "Modular scatterPlots"
    )
}
