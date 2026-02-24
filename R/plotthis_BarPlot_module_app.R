#' Create an example Modular BarPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::BarPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which BarPlot modules will be created.
#'   That is, UI inputs and a bar plot will be generated for each.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom plotthis BarPlot
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin, Jared Andrews
#
#' @examples
#' library(VizModules)
#' data_list <- list("sales" = example_sales, "population" = example_population)
#' app <- plotthis_BarPlotApp(data_list)
#' if (interactive()) runApp(app)
plotthis_BarPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- navbarPage(
        title = "Modular BarPlots",
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
                    lapply(names(data_list), function(name) {
                        tagList(
                            plotthis_BarPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                            hr()
                        )
                    })
                ),
                mainPanel(
                    lapply(names(data_list), function(name) {
                        tagList(plotthis_BarPlotOutputUI(name), br())
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

        lapply(names(data_list), function(name) {
            plotthis_BarPlotServer(name, data = filtered_list[[name]])
        })
    }

    shinyApp(ui, server)
}
