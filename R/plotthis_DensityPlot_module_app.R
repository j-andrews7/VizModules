#' Standalone Multi-Dataset Density Plot Application
#'
#' @description
#' Launches a complete Shiny application that displays interactive density plot modules 
#' for every data frame provided in a list. This is ideal for side-by-side 
#' comparison of different genomic datasets or clinical cohorts.
#'
#' @param data_list \code{list} A named list of data frames. Each list element will 
#' trigger the creation of a separate density plot module instance.
#'
#' @return A Shiny app object that can be run locally or deployed to a server.
#'
#' @author Jacob Martin, Jared Andrews
#' 
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @export
#' 
#' @examples
#' library(VizModules)
#' data_list <- list("sales" = example_sales, "population" = example_population)
#' app <- plotthis_DensityPlotApp(data_list)
#' if (interactive()) runApp(app)
plotthis_DensityPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- navbarPage(
        title = "Modular DensityPlots",
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
                            plotthis_DensityPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                            hr()
                        )
                    })
                ),
                mainPanel(
                    # Add the module output UI for each data frame
                    lapply(names(data_list), function(name) {
                        tagList(plotthis_DensityPlotOutputUI(name), br())
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
            plotthis_DensityPlotServer(name, data = filtered_list[[name]])
        })
    }

    shinyApp(ui, server)
}
