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
#'
#' @seealso [dittoViz::yPlot()], [VizModules::dittoViz_yPlotInputsUI()],
#' [VizModules::dittoViz_yPlotOutputUI()], [VizModules::dittoViz_yPlotServer()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(VizModules)
#' data_list <- list("sales" = example_sales, "population" = example_population)
#' app <- dittoViz_yPlotApp(data_list)
#' if (interactive()) runApp(app)
dittoViz_yPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- navbarPage(
        title = "Modular yPlots",
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
    )

    server <- function(input, output, session) {
        filtered_list <- lapply(names(data_list), function(name) {
            dataFilterServer(paste0("filter_", name), reactive(data_list[[name]]))
        })
        names(filtered_list) <- names(data_list)

        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            dittoViz_yPlotServer(name, data = filtered_list[[name]])
        })
    }

    shinyApp(ui, server)
}
