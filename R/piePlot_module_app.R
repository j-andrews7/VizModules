#' Create an example Modular piePlot Shiny Application
#'
#' This function generates a Shiny application with modular piePlot components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of summary data frames (one row per slice) for which piePlot modules will be created.
#'   That is, UI inputs and a pie plot will be generated for each. Each data frame should already contain
#'   a label column and an aggregated numeric value column.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#'
#' @seealso [VizModules::piePlot()], [VizModules::piePlotInputsUI()],
#' [VizModules::piePlotOutputUI()], [VizModules::piePlotServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' sales_summary <- aggregate(revenue ~ region, example_sales, sum)
#' population_summary <- aggregate(count ~ age_group, example_population, sum)
#' data_list <- list("sales" = sales_summary, "population" = population_summary)
#' app <- piePlotApp(data_list)
#' if (interactive()) runApp(app)
piePlotApp <- function(data_list) {
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
