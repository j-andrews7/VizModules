#' Create an example Modular piePlot Shiny Application
#'
#' This function generates a Shiny application with modular piePlot components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive pie plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' aggregated `example_sales` and `example_population` datasets. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of summary data frames (one row per slice).
#'   If `NULL` (the default), aggregated example data is used. Each data frame should already
#'   contain a label column and an aggregated numeric value column.
#' @return A Shiny app object.
#'
#' @seealso [VizModules::piePlot()], [VizModules::piePlotInputsUI()],
#' [VizModules::piePlotOutputUI()], [VizModules::piePlotServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- piePlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' sales_summary <- aggregate(revenue ~ region, example_sales, sum)
#' app2 <- piePlotApp(list("sales" = sales_summary))
#' if (interactive()) runApp(app2)
piePlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list(
            "sales_by_region" = aggregate(revenue ~ region, example_sales, sum),
            "pop_by_age"      = aggregate(count ~ age_group, example_population, sum)
        )
    }
    createModuleApp(
        inputs_ui_fn = piePlotInputsUI,
        output_ui_fn = piePlotOutputUI,
        server_fn    = piePlotServer,
        data_list    = data_list,
        title        = "Modular piePlots"
    )
}
