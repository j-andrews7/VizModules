#' Create an example Modular parallelCoordinatesPlot Shiny Application
#'
#' This function generates a Shiny application with modular
#' [VizModules::parallelCoordinatesPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which parallelCoordinatesPlot modules
#'   will be created. That is, UI inputs and a parallel coordinates plot will be generated
#'   for each. Each data frame should contain at least two numeric or categorical columns.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#'
#' @seealso [VizModules::parallelCoordinatesPlot()], [VizModules::parallelCoordinatesPlotInputsUI()],
#' [VizModules::parallelCoordinatesPlotOutputUI()], [VizModules::parallelCoordinatesPlotServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' data_list <- list("mtcars" = mtcars, "iris" = iris)
#' app <- parallelCoordinatesPlotApp(data_list)
#' if (interactive()) runApp(app)
parallelCoordinatesPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- navbarPage(
        title = "Modular Parallel Coordinates Plots",
        useShinyjs(),

        tabPanel("Filter",
            mainPanel(
                lapply(names(data_list), function(name) {
                    tagList(dataFilterUI(paste0("filter_", name)))
                })
            )
        ),

        tabPanel("Plots",
            sidebarLayout(
                sidebarPanel(
                    # Add the module inputs UI for each data frame
                    lapply(names(data_list), function(name) {
                        tagList(
                            parallelCoordinatesPlotInputsUI(
                                name, data_list[[name]],
                                title = h3(paste(name, "Settings"))
                            ),
                            hr()
                        )
                    })
                ),
                mainPanel(
                    # Add the module output UI for each data frame
                    lapply(names(data_list), function(name) {
                        tagList(parallelCoordinatesPlotOutputUI(name), br())
                    })
                )
            )
        )
    )

    server <- function(input, output, session) {
        filtered_list <- lapply(names(data_list), function(name) {
            dataFilterServer(paste0("filter_", name), reactive(data_list[[name]]))
        })
        names(filtered_list) <- names(data_list)

        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            parallelCoordinatesPlotServer(name, data = filtered_list[[name]])
        })
    }

    shinyApp(ui, server)
}
