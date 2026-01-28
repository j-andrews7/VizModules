#' Create an example Modular BoxPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::BoxPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which BoxPlot modules will be created.
#'   That is, UI inputs and a box plot will be generated for each.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin
#' @examples
#' library(VizModules)
#' data_list <- list("sales" = example_sales, "population" = example_population)
#' app <- plotthis_BoxPlotApp(data_list)
#' if (interactive()) runApp(app)
plotthis_BoxPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular BoxPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        plotthis_BoxPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(plotthis_BoxPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            plotthis_BoxPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
