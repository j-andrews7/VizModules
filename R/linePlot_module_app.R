#' Create an example Modular linePlot Shiny Application
#'
#' This function generates a Shiny application with modular [VizModules::linePlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which linePlot modules will be created.
#'   That is, UI inputs and a line plot will be generated for each.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#'
#' @seealso [VizModules::linePlot()], [VizModules::linePlotInputsUI()],
#' [VizModules::linePlotOutputUI()], [VizModules::linePlotServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' data_list <- list("sales" = example_sales, "population" = example_population)
#' app <- linePlotApp(data_list)
#' if (interactive()) runApp(app)
linePlotApp <- function(data_list) {
    # Validate input (unchanged)
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })
    ui <- navbarPage(  # Remove fluidPage + titlePanel wrapper
        title = "Modular linePlots",  # title here instead
        useShinyjs(),  # moves to navbarPage

        tabPanel("Filter",
            mainPanel(
                lapply(names(data_list), function(name) {
                    tagList(dataFilterUI(paste0("filter_", name)))
                })
            )
        ),
        
        # Plots tab
        tabPanel("Plots",  
                sidebarLayout(
                    sidebarPanel(
                        lapply(names(data_list), function(name) {
                            tagList(
                                linePlotInputsUI(name, data_list[[name]], 
                                                title = h3(paste(name, "Settings"))),
                                hr()
                            )
                        })
                    ),
                    mainPanel(
                        lapply(names(data_list), function(name) {
                            tagList(linePlotOutputUI(name), br())
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
            linePlotServer(name, data = filtered_list[[name]])
        })
    }

    shinyApp(ui, server)
}
