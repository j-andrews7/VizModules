#' Create a standalone Shiny app for the volcanoPlot module
#'
#' @param df A data frame to plot. Must contain effect size (e.g., log2FoldChange)
#'   and significance (e.g., padj) columns.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#'
#' @seealso [VizModules::volcanoPlotInputsUI()], [VizModules::volcanoPlotOutputUI()],
#' [VizModules::volcanoPlotServer()], [VizModules::airway_deseq2]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(VizModules)
#' data(airway_deseq2)
#' if (interactive()) {
#'     volcanoPlotApp(airway_deseq2)
#' }
volcanoPlotApp <- function(df) {
    # Validate input
    stopifnot(is.data.frame(df))

    ui <- navbarPage(
        title = "Modular Volcano Plot",
        useShinyjs(),

        tabPanel("Filter",
            mainPanel(
                dataFilterUI("filter_volc")
            )
        ),

        tabPanel("Plots",
            sidebarLayout(
                sidebarPanel(
                    # Add the module inputs UI for each data frame
                    volcanoPlotInputsUI("volc", df)
                ),
                mainPanel(
                    # Add the module output UI for each data frame
                    volcanoPlotOutputUI("volc")
                )
            )
        )
    )

    server <- function(input, output, session) {
        filtered_data <- dataFilterServer("filter_volc", reactive(df))
        # Add the module server for each data frame
        volcanoPlotServer("volc", data = filtered_data)
    }

    shinyApp(ui, server)
}
