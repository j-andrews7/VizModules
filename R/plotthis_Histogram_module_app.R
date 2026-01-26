#' Standalone Multi-Dataset Histogram Application
#'
#' @description
#' Launches a complete Shiny application that displays interactive histogram modules 
#' for every data frame provided in a list. This is ideal for side-by-side 
#' comparison of different genomic datasets or clinical cohorts.
#'
#' @param data_list \code{list} A named list of data frames. Each list element will 
#' trigger the creation of a separate histogram module instance.
#'
#' @return A Shiny app object that can be run locally or deployed to a server.
#'
#' @author Jacob Martin
#' 
#' @import shiny
#' @import shinyjs
#' @export
#' 
#' @examples
#' library(VizModules)
#' # Needs at least 2 categorical variables for grouping and x-axis
#' mtcars$cyl <- as.factor(mtcars$cyl)
#' mtcars$gear <- as.factor(mtcars$gear)
#' iris$group <- rep(c("A", "B"), each = 75)
#' data_list <- list("mtcars" = mtcars, "iris" = iris)
#' app <- plotthis_HistogramApp(data_list)
#' if (interactive()) runApp(app)
plotthis_HistogramApp <- function(data_list) {
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
                        plotthis_HistogramInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(plotthis_HistogramOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            plotthis_HistogramServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
