#' Create an example Modular AreaPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::AreaPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which AreaPlot modules will be created.
#'   That is, UI inputs and an area plot will be generated for each.
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
#' data_list <- list("sales" = example_sales, "population" = example_population)
#' app <- plotthis_AreaPlotApp(data_list)
#' if (interactive()) runApp(app)
plotthis_AreaPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular AreaPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        plotthis_AreaPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(plotthis_AreaPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            plotthis_AreaPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
