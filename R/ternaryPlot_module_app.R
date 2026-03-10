#' Create an example Modular ternaryPlot Shiny Application
#'
#' This function generates a Shiny application with modular ternaryPlot components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive ternary plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' example `roles` and `teams` datasets. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   example datasets with three numeric columns are used. Each data frame should
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
        roles <- data.frame(
            journalist = c(75, 70, 75, 5, 10, 10, 20, 10, 15, 10, 20),
            developer = c(25, 10, 20, 60, 80, 90, 70, 20, 5, 10, 10),
            designer = c(0, 20, 5, 35, 10, 0, 10, 70, 80, 80, 70),
            label = c("point 1", "point 2", "point 3", "point 4", "point 5", "point 6",
                       "point 7", "point 8", "point 9", "point 10", "point 11")
        )
        teams <- data.frame(
            journalist = c(75, 70, 75, 5, 10, 10),
            developer = c(25, 10, 20, 60, 80, 90),
            designer = c(0, 20, 5, 35, 10, 0),
            team = rep(c("Team A", "Team B"), each = 3)
        )
        data_list <- list("roles" = roles, "teams" = teams)
    }
    createModuleApp(
        inputs_ui_fn = ternaryPlotInputsUI,
        output_ui_fn = ternaryPlotOutputUI,
        server_fn    = ternaryPlotServer,
        data_list    = data_list,
        title        = "Modular ternaryPlots"
    )
}
