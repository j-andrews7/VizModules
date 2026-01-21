#' Create an example Modular ViolinPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::ViolinPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which ViolinPlot modules will be created.
#'   That is, UI inputs and a violin plot will be generated for each.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin
#' @examples
#' library(vizModules)
#' data <- data.frame(
#'     x = rep(LETTERS[1:8], each = 40),
#'     y = c(rnorm(160), rnorm(160, mean = 1)),
#'     group1 = sample(c("g1", "g2"), 320, replace = TRUE),
#'     group2 = sample(c("h1", "h2", "h3", "h4"), 320, replace = TRUE)
#' )
#' data_list <- list("test_data" = data)
#' app <- ViolinPlotApp(data_list)
#' if (interactive()) runApp(app)
ViolinPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular ViolinPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        ViolinPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(ViolinPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            ViolinPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
