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
#' library(VizModules)
#' data_list <- list("sales" = example_sales, "population" = example_population)
#' app <- plotthis_ViolinPlotApp(data_list)
#' if (interactive()) runApp(app)
plotthis_ViolinPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- navbarPage(
        title = "Modular ViolinPlots",
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
                            plotthis_ViolinPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                            hr()
                        )
                    })
                ),
                mainPanel(
                    # Add the module output UI for each data frame
                    lapply(names(data_list), function(name) {
                        tagList(plotthis_ViolinPlotOutputUI(name), br())
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
            plotthis_ViolinPlotServer(name, data = filtered_list[[name]])
        })
    }

    shinyApp(ui, server)
}
