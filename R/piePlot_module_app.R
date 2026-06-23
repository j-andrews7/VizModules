#' Create an example Modular piePlot Shiny Application
#'
#' This function generates a Shiny application with modular piePlot components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive pie plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' an aggregated `example_sales` dataset (revenue by product line). Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of summary data frames (one row per slice).
#'   If `NULL` (the default), aggregated example data is used. Each data frame should already
#'   contain a label column and an aggregated numeric value column.
#' @param defaults A named list of input IDs and their default values to apply on startup.
#' @param hide.inputs A character vector of input IDs to hide. Their values are still
#'   initialized and used, but the controls are not shown in the UI.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs are
#'   still initialized and used, but the controls are not shown in the UI.
#' @return A Shiny app object.
#'
#' @seealso [VizModules::piePlot()], [VizModules::piePlotInputsUI()],
#' [VizModules::piePlotOutputUI()], [VizModules::piePlotServer()]
#'
#' @importFrom stats aggregate
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- piePlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' sales_summary <- aggregate(revenue ~ product_line, example_sales, sum)
#' app2 <- piePlotApp(list("sales" = sales_summary))
#' if (interactive()) runApp(app2)
piePlotApp <- function(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL) {
    if (is.null(data_list)) {
        data_list <- list(
            "sales_by_product" = aggregate(revenue ~ product_line, example_sales, sum)
        )
    }
    createModuleApp(
        inputs_ui_fn = piePlotInputsUI,
        output_ui_fn = piePlotOutputUI,
        server_fn    = piePlotServer,
        data_list    = data_list,
        defaults     = defaults,
        hide.inputs  = hide.inputs,
        hide.tabs    = hide.tabs,
        title        = "Modular piePlots"
    )
}
