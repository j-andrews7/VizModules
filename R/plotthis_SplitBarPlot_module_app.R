#' Create an example Modular SplitBarPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::SplitBarPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which SplitBarPlot modules will be created.
#'   That is, UI inputs and a split bar plot will be generated for each.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom plotthis SplitBarPlot
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin
#'
#' @examples
#' library(VizModules)
#' data_list <- list("sales" = example_sales, "population" = example_population)
#' app <- plotthis_SplitBarPlotApp(data_list)
#' if (interactive()) runApp(app)
plotthis_SplitBarPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular SplitBarPlots"),
        sidebarLayout(
            sidebarPanel(
                lapply(names(data_list), function(name) {
                    tagList(
                        plotthis_SplitBarPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                lapply(names(data_list), function(name) {
                    tagList(plotthis_SplitBarPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        lapply(names(data_list), function(name) {
            plotthis_SplitBarPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
