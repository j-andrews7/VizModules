#' Create an example Modular radarPlot Shiny Application
#'
#' This function generates a Shiny application with modular radarPlot components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which radarPlot modules will be created.
#'   That is, UI inputs and a radar plot will be generated for each. Each data frame should
#'   contain columns for categories (theta) and values (r). For multiple traces, include a
#'   grouping column.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#'
#' @seealso [VizModules::radarPlot()], [VizModules::radarPlotInputsUI()],
#' [VizModules::radarPlotOutputUI()], [VizModules::radarPlotServer()]
#'
#' @export
#' @author Jacob Martin
#' @examples
#' library(VizModules)
#' 
#' # Single trace example
#' skills <- data.frame(
#'     category = c("Speed", "Strength", "Defense", "Stamina", "Speed"),
#'     value = c(8, 6, 7, 9, 8)
#' )
#'
#' # Multiple trace example
#' team_stats <- data.frame(
#'     category = rep(c("Speed", "Strength", "Defense", "Stamina", "Speed"), 2),
#'     value = c(8, 6, 7, 9, 8, 5, 9, 8, 6, 5),
#'     player = rep(c("Player A", "Player B"), each = 5)
#' )
#'
#' data_list <- list("skills" = skills, "team" = team_stats)
#' app <- radarPlotApp(data_list)
#' if (interactive()) runApp(app)
radarPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- navbarPage(
        title = "Modular radarPlots",
        useShinyjs(),

        tabPanel("Filter",
            mainPanel(
                lapply(names(data_list), function(name) {
                    tagList(dataFilterUI(paste0("filter_", name)))
                })
            )
        ),

        tabPanel("Plots",
            sidebarLayout(
                sidebarPanel(
                    # Add the module inputs UI for each data frame
                    lapply(names(data_list), function(name) {
                        tagList(
                            radarPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                            hr()
                        )
                    })
                ),
                mainPanel(
                    # Add the module output UI for each data frame
                    lapply(names(data_list), function(name) {
                        tagList(radarPlotOutputUI(name), br())
                    })
                )
            )
        )
    )

    server <- function(input, output, session) {
        filtered_list <- lapply(names(data_list), function(name) {
            dataFilterServer(paste0("filter_", name), reactive(data_list[[name]]))
        })
        names(filtered_list) <- names(data_list)

        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            radarPlotServer(name, data = filtered_list[[name]])
        })
    }

    shinyApp(ui, server)
}
