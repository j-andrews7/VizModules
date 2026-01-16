#' Create an example Modular BarPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::BarPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which BarPlot modules will be created.
#'   That is, UI inputs and a bar plot will be generated for each.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom plotthis BarPlot
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin, Jared Andrews
#
#' @examples
#' data_list <- list("mtcars" = mtcars, "iris" = iris)
#' app <- BarPlotApp(data_list)
#' if (interactive()) runApp(app)
BarPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular BarPlots"),
        sidebarLayout(
            sidebarPanel(
                lapply(names(data_list), function(name) {
                    tagList(
                        BarPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                lapply(names(data_list), function(name) {
                    tagList(BarPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        lapply(names(data_list), function(name) {
            BarPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
