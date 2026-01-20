#' Create an example Modular histogramPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::histogramPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which histogramPlot modules will be created.
#'   That is, UI inputs and an histogram plot will be generated for each.
#' @return A Shiny app object.
#' 
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin, Jared Andrews
#'
#' @examples
#' library(vizModules)
#' # Needs at least 2 categorical variables for grouping and x-axis
#' mtcars$cyl <- as.factor(mtcars$cyl)
#' mtcars$gear <- as.factor(mtcars$gear)
#' iris$group <- rep(c("A", "B"), each = 75)
#' data_list <- list("mtcars" = mtcars, "iris" = iris)
#' app <- histogramPlotApp(data_list)
#' if (interactive()) runApp(app)
histogramPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular histogramPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        histogramPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(histogramPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            histogramPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
