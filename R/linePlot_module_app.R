#' Create an example Modular linePlot Shiny Application
#'
#' This function generates a Shiny application with modular [VizModules::linePlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which linePlot modules will be created.
#'   That is, UI inputs and a line plot will be generated for each.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin, Jared Andrews
#'
#' @examples
#' library(VizModules)
#' data_list <- list("mtcars" = mtcars, "iris" = iris)
#' app <- linePlotApp(data_list)
#' if (interactive()) runApp(app)
linePlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular linePlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        linePlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(linePlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            linePlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
