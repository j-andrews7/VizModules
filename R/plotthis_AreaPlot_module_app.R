#' Create an example Modular AreaPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::AreaPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which AreaPlot modules will be created.
#'   That is, UI inputs and an area plot will be generated for each.
#' @return A Shiny app object.
#' 
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jacob Martin, Jared Andrews
#'
#' @examples
#' library(VizModules)
#' # Create sample data with time series and multiple groups
#' set.seed(7)
#' months <- rep(month.abb, each = 4)
#' regions <- rep(c("North", "South", "East", "West"), 12)
#' sales <- data.frame(
#'     month = factor(months, levels = month.abb),
#'     region = factor(regions),
#'     revenue = round(runif(48, 50, 200) + rep(seq(0, 55, 5), each = 4), 1),
#'     units = sample(100:500, 48, replace = TRUE)
#' )
#'
#' # Population data across age groups over time
#' years <- rep(2015:2024, each = 5)
#' age_groups <- rep(c("0-17", "18-34", "35-54", "55-74", "75+"), 10)
#' population <- data.frame(
#'     year = factor(years),
#'     age_group = factor(age_groups, levels = c("0-17", "18-34", "35-54", "55-74", "75+")),
#'     count = round(rnorm(50, mean = 5000, sd = 800) + rep(seq(0, 900, 100), each = 5))
#' )
#'
#' data_list <- list("sales" = sales, "population" = population)
#' app <- plotthis_AreaPlotApp(data_list)
#' if (interactive()) runApp(app)
plotthis_AreaPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular AreaPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        plotthis_AreaPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(plotthis_AreaPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            plotthis_AreaPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
