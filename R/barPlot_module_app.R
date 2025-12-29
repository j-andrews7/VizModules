#' Create an example Modular barPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::BarPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which barPlot modules will be created.
#'   That is, UI inputs and a bar plot will be generated for each.
#' @return A Shiny app object.
#'
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin
#
#' @examples
#' data_list <- list("mtcars" = mtcars, "iris" = iris)
#' app <- createBarPlotApp(data_list)
#' if (interactive()) runApp(app)
createBarPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular barPlots"),
        sidebarLayout(
            sidebarPanel(
                lapply(names(data_list), function(name) {
                    tagList(
                        barPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                lapply(names(data_list), function(name) {
                    tagList(barPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        lapply(names(data_list), function(name) {
            barPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
