#' Create a standalone Shiny app for the volcanoPlot module
#'
#' @param df A data frame to plot. Must contain `padj` and `log2FoldChange` columns.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#'
#' @export
#' @author Jared Andrews
#' @seealso [vizModules::volcanoPlotInputsUI()], [vizModules::volcanoPlotOutputUI()],
#' [vizModules::volcanoPlotServer()], [vizModules::airway_deseq2]
#' @examples
#' library(vizModules)
#' data(airway_deseq2)
#' if (interactive()) {
#'     volcanoPlotApp(airway_deseq2)
#' }
volcanoPlotApp <- function(df) {
    # Validate input
    stopifnot(is.data.frame(df))

    ui <- fluidPage(
        useShinyjs(),
        titlePanel("Modular Volcano Plot"),
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

    server <- function(input, output, session) {
        # Add the module server for each data frame
        volcanoPlotServer("volc", data = reactive(df))
    }

    shinyApp(ui, server)
}
