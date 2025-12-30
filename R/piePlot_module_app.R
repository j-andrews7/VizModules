#' Create an example Modular piePlot Shiny Application
#'
#' This function generates a Shiny application with modular piePlot components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which piePlot modules will be created.
#'   That is, UI inputs and a pie plot will be generated for each.
#' @return A Shiny app object.
#'
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin
#'
#' @examples
#' data_list <- list("mtcars" = mtcars, "iris" = iris)
#' app <- createpiePlotApp(data_list)
#' if (interactive()) runApp(app)
createpiePlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular piePlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        piePlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(piePlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            piePlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
