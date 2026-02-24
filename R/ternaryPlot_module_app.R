#' Create an example Modular ternaryPlot Shiny Application
#'
#' This function generates a Shiny application with modular ternaryPlot components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which ternaryPlot modules will be created.
#'   That is, UI inputs and a ternary plot will be generated for each. Each data frame should
#'   contain numeric columns for the three ternary axes (a, b, c). For multiple traces, include a
#'   grouping column.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#'
#' @seealso [VizModules::ternaryPlot()], [VizModules::ternaryPlotInputsUI()],
#' [VizModules::ternaryPlotOutputUI()], [VizModules::ternaryPlotServer()]
#'
#' @export
#' @author Jacob Martin
#' @examples
#' library(VizModules)
#'
#' # Single trace example
#' journalist <- c(75, 70, 75, 5, 10, 10, 20, 10, 15, 10, 20)
#' developer <- c(25, 10, 20, 60, 80, 90, 70, 20, 5, 10, 10)
#' designer <- c(0, 20, 5, 35, 10, 0, 10, 70, 80, 80, 70)
#' label <- c("point 1", "point 2", "point 3", "point 4", "point 5", "point 6",
#'            "point 7", "point 8", "point 9", "point 10", "point 11")
#'
#' df <- data.frame(journalist, developer, designer, label)
#'
#' # Multiple trace example
#' team_data <- data.frame(
#'     journalist = c(75, 70, 75, 5, 10, 10),
#'     developer = c(25, 10, 20, 60, 80, 90),
#'     designer = c(0, 20, 5, 35, 10, 0),
#'     team = rep(c("Team A", "Team B"), each = 3)
#' )
#'
#' data_list <- list("roles" = df, "teams" = team_data)
#' app <- ternaryPlotApp(data_list)
#' if (interactive()) runApp(app)
ternaryPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular ternaryPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        ternaryPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(ternaryPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            ternaryPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
