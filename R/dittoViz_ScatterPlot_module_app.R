#' Create an example Modular scatterPlot Shiny Application
#'
#' This function generates a Shiny application with modular [dittoViz::scatterPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which scatterPlot modules will be created.
#'   That is, UI inputs and a scatter plot will be generated for each.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jared Andrews
#'
#' @examples
#' library(VizModules)
#' #' # Create sample data with time series and multiple groups
#' set.seed(7)
#' # Sales data: 10 years × 12 months × 6 regions = 720 rows
#' years_sales <- rep(2015:2024, each = 72)
#' months <- rep(rep(month.abb, each = 6), 10)
#' regions <- rep(c("North", "South", "East", "West", "Central", "International"), 120)
#' sales <- data.frame(
#'     year = factor(years_sales),
#'     month = factor(months, levels = month.abb),
#'     region = factor(regions),
#'     revenue = round(runif(720, 50, 200) + rep(seq(0, 350, length.out = 720)), 1),
#'     units = sample(100:500, 720, replace = TRUE)
#' )
#'
#' # Population data: 50 years × 8 age groups = 400 rows
#' years <- rep(1975:2024, each = 8)
#' age_groups <- rep(c("0-9", "10-17", "18-34", "35-44", "45-54", "55-64", "65-74", "75+"), 50)
#' population <- data.frame(
#'     year = factor(years),
#'     age_group = factor(age_groups, levels = c("0-9", "10-17", "18-34", "35-44", "45-54", "55-64", "65-74", "75+")),
#'     count = round(rnorm(400, mean = 5000, sd = 800) + rep(seq(0, 3900, length.out = 400)))
#' )
#'
#' data_list <- list("sales" = sales, "population" = population)
#' app <- dittoViz_scatterPlotApp(data_list)
#' if (interactive()) runApp(app)
dittoViz_scatterPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular scatterPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        dittoViz_scatterPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(dittoViz_scatterPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            dittoViz_scatterPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
