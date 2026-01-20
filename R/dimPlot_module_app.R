#' Create an example Modular DimPlot Shiny Application
#'
#' This function generates a Shiny application with modular [plotthis::DimPlot()] components.
#' A module is created for each data frame provided in the named list of data frames.
#'
#' @param data_list A named list of data frames for which DimPlot modules will be created.
#'   That is, UI inputs and a dimension plot will be generated for each.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom plotthis DimPlot
#' @importFrom shinyjs useShinyjs
#' @export
#'
#' @author Jared Andrews
#'
#' @examples
#' library(vizModules)
#' # Create example data with dimension reduction coordinates
#' set.seed(123)
#' df1 <- data.frame(
#'     UMAP1 = rnorm(100),
#'     UMAP2 = rnorm(100),
#'     cluster = sample(c("A", "B", "C"), 100, replace = TRUE),
#'     celltype = sample(c("Type1", "Type2"), 100, replace = TRUE)
#' )
#' df2 <- data.frame(
#'     PC1 = rnorm(150),
#'     PC2 = rnorm(150),
#'     group = sample(c("Group1", "Group2", "Group3"), 150, replace = TRUE)
#' )
#' data_list <- list("UMAP" = df1, "PCA" = df2)
#' app <- DimPlotApp(data_list)
#' if (interactive()) runApp(app)
DimPlotApp <- function(data_list) {
    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular DimPlots"),
        sidebarLayout(
            sidebarPanel(
                # Add the module inputs UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(
                        DimPlotInputsUI(name, data_list[[name]], title = h3(paste(name, "Settings"))),
                        hr()
                    )
                })
            ),
            mainPanel(
                # Add the module output UI for each data frame
                lapply(names(data_list), function(name) {
                    tagList(DimPlotOutputUI(name), br())
                })
            )
        )
    )

    server <- function(input, output, session) {
        # Add the module server for each data frame
        lapply(names(data_list), function(name) {
            DimPlotServer(name, data = reactive(data_list[[name]]))
        })
    }

    shinyApp(ui, server)
}
