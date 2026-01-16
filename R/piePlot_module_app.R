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
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin, Jared Andrews
#'
#' @examples
#' library(vizModules)
#' iris_summary <- as.data.frame(table(iris$Species))
#' names(iris_summary) <- c("Species", "Count")
#' cyl_summary <- as.data.frame(table(mtcars$cyl))
#' names(cyl_summary) <- c("Cylinders", "Count")
#' data_list <- list("mtcars" = cyl_summary, "iris" = iris_summary)
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
