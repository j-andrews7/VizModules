#' Create an example Modular yPlot Shiny Application
#'
#' This function generates a Shiny application with modular [dittoViz::yPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which yPlot modules will be created.
#'   That is, UI inputs and a y plot will be generated for each.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jared Andrews
#' @examples
#' library(VizModules)
#' data <- data.frame(
#'     group = rep(LETTERS[1:4], each = 50),
#'     value = c(rnorm(50, mean = 5), rnorm(50, mean = 10), 
#'               rnorm(50, mean = 7), rnorm(50, mean = 12)),
#'     category = sample(c("Type1", "Type2"), 200, replace = TRUE)
#' )
#' data_list <- list("test_data" = data)
#' app <- dittoViz_yPlotApp(data_list)
#' if (interactive()) runApp(app)
dittoViz_yPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular yPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        dittoViz_yPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(dittoViz_yPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            dittoViz_yPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
