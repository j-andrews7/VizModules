#' Create an example Modular ternaryPlot Shiny Application
#'
#' This function generates a Shiny application with modular ternaryPlot components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive ternary plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `example_roles` as an example dataset. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("roles" = example_roles)` is used. Each data frame should
#'   contain numeric columns for the three ternary axes (a, b, c). For multiple traces,
#'   include a grouping column.
#' @return A Shiny app object.
#'
#' @seealso [VizModules::ternaryPlot()], [VizModules::ternaryPlotInputsUI()],
#' [VizModules::ternaryPlotOutputUI()], [VizModules::ternaryPlotServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- ternaryPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' df <- data.frame(
#'     journalist = c(75, 70, 75, 5, 10),
#'     developer = c(25, 10, 20, 60, 80),
#'     designer = c(0, 20, 5, 35, 10)
#' )
#' app2 <- ternaryPlotApp(list("roles" = df))
#' if (interactive()) runApp(app2)
ternaryPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("roles" = example_roles)
    }
    createModuleApp(
        inputs_ui_fn = ternaryPlotInputsUI,
        output_ui_fn = ternaryPlotOutputUI,
        server_fn    = ternaryPlotServer,
        data_list    = data_list,
        title        = "Modular ternaryPlots"
    )
}
