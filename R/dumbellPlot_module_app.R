#' Create a Shiny App for Dumbbell Plots
#'
#' Creates a Shiny application for generating interactive dumbbell plots.
#' This is a standalone app that demonstrates the dumbellPlot module functionality.
#'
#' @param data_list A named list of data frames to plot. Each data frame will get its own
#'   set of inputs and output in the app.
#'
#' @return A Shiny app object that can be run with `shiny::runApp()` or by calling the function directly.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs useShinyjs
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [VizModules::dumbellPlot()], [VizModules::dumbellPlotInputsUI()],
#' [VizModules::dumbellPlotOutputUI()], [VizModules::dumbellPlotServer()]
#'
#' @examples
#' \dontrun{
#' data <- data.frame(
#'   School = c("MIT", "Stanford", "Harvard"),
#'   Women = c(94, 96, 112),
#'   Men = c(152, 151, 165),
#'   Group = c("A", "B", "A")
#' )
#' dumbellPlotApp(list("School Earnings" = data))
#' }
dumbellPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular dumbellPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        dumbellPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(dumbellPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            dumbellPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
