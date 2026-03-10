#' Create an example Modular radarPlot Shiny Application
#'
#' This function generates a Shiny application with modular radarPlot components.
#' The app features a **Data Import** section for uploading data,
#' a **Data Table** for filtering the active dataset, and a **Plot** area
#' for configuring and displaying an interactive radar plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' example `skills` and `team_stats` datasets. Uploaded data files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' This is a convenience wrapper around [createModuleApp()].
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   example datasets with categories and values are used. Each data frame should
#'   contain columns for categories (theta) and values (r). For multiple traces, include a
#'   grouping column.
#' @return A Shiny app object.
#'
#' @seealso [VizModules::radarPlot()], [VizModules::radarPlotInputsUI()],
#' [VizModules::radarPlotOutputUI()], [VizModules::radarPlotServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- radarPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' skills <- data.frame(
#'     entity = c(
#'        rep("Player A", 6),
#'         rep("Player B", 6),
#'         rep("Player C", 6),
#'         rep("Player D", 6)
#'     ),
#'     category = rep(c("Pace", "Shooting", "Passing", "Dribbling", "Defending", "Physical"), 4),
#'     value = c(
#'         99, 89, 80, 92, 36, 78,
#'         89, 97, 65, 72, 45, 95,
#'         76, 86, 94, 86, 64, 78,
#'         62, 60, 71, 63, 94, 91
#'     )
#' )
#' app2 <- radarPlotApp(list("skills" = skills))
#' if (interactive()) runApp(app2)
radarPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        skills <- data.frame(
            category = c("Speed", "Strength", "Defense", "Stamina", "Speed"),
            value = c(8, 6, 7, 9, 8)
        )
        team_stats <- data.frame(
            category = rep(c("Speed", "Strength", "Defense", "Stamina", "Speed"), 2),
            value = c(8, 6, 7, 9, 8, 5, 9, 8, 6, 5),
            player = rep(c("Player A", "Player B"), each = 5)
        )
        data_list <- list("skills" = skills, "team" = team_stats)
    }
    createModuleApp(
        inputs_ui_fn = radarPlotInputsUI,
        output_ui_fn = radarPlotOutputUI,
        server_fn    = radarPlotServer,
        data_list    = data_list,
        title        = "Modular radarPlots"
    )
}
