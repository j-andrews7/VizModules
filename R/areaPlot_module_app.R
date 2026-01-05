#' Create an example Modular areaPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::AreaPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which areaPlot modules will be created.
#'   That is, UI inputs and an area plot will be generated for each.
#' @return A Shiny app object.
#'
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin
#'
#' @examples
#' library(vizModules)
#' # Needs at least 2 categorical variables for grouping and x-axis
#' mtcars$cyl <- as.factor(mtcars$cyl)
#' mtcars$gear <- as.factor(mtcars$gear)
#' iris$group <- rep(c("A", "B"), each = 75)
#' data_list <- list("mtcars" = mtcars, "iris" = iris)
#' app <- createAreaPlotApp(data_list)
#' if (interactive()) runApp(app)
createAreaPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular areaPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        areaPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(areaPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            areaPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
