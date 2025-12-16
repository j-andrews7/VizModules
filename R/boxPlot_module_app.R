#' Create an example Modular boxPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::BoxPlot] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which boxPlots will be created 
#' @return A Shiny app object.
#' 
#' @importFrom shiny fluidPage titlePanel sidebarLayout sidebarPanel mainPanel shinyApp h3 reactive hr
#' @importFrom shinyjs useShinyjs
#' @export
#' @author Jacob Martin
#' @examples
#' data_list <- list("mtcars" = mtcars, "iris" = iris)
#' app <- createBoxPlotApp(data_list)
#' runApp(app)
createBoxPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    # UI definition
    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular boxPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        boxPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(boxPlotOutputUI(name), br())
                })
            )
        )
    )

    # Server function
    server <- function(input, output, session) {

       # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            boxPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    # Return the Shiny app
    shinyApp(ui, server)
}