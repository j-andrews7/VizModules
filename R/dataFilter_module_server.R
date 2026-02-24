#' Server logic for the dataFilter module
#'
#' Renders an interactive DT table with column-level filters and returns a
#' reactive containing only the currently visible (filtered) rows. This
#' reactive can be passed directly to any plotting module as its `data`
#' argument.
#'
#' @param id The ID for the Shiny module. Must match the `id` used in
#'   [dataFilterUI()].
#' @param data A `reactive` containing the data frame to display and filter.
#' @param factor.char.cols Logical. When `TRUE`, all character columns in
#'   `data` are converted to factors before the table is rendered. This
#'   causes DT to display select-box filters for those columns instead of
#'   free-text search boxes. Defaults to `TRUE`.
#' @param page.length Integer. The default number of rows shown per page.
#'   Defaults to `10`.
#'
#' @return A `reactive` expression that evaluates to the filtered subset of
#'   `data` based on the current DT selection/filter state. Pass this
#'   reactive to a plotting module's `data` argument to keep the plot in
#'   sync with the table filters.
#'
#' @import shiny
#' @importFrom DT renderDataTable datatable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [dataFilterUI()]
#' @examples
#' library(shiny)
#' library(VizModules)
#'
#' ui <- fluidPage(
#'     dataFilterUI("filter"),
#'     verbatimTextOutput("rows")
#' )
#'
#' server <- function(input, output, session) {
#'     data <- reactive(iris)
#'     filtered <- dataFilterServer("filter", data, factor.char.cols = TRUE)
#'     output$rows <- renderPrint(nrow(filtered()))
#' }
#'
#' if (interactive()) shinyApp(ui, server)
dataFilterServer <- function(id, data, factor.char.cols = TRUE, page.length = 10) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Optionally coerce character columns to factors
        prepared_data <- reactive({
            d <- data()
            if (isTRUE(factor.char.cols)) {
                char_cols <- vapply(d, is.character, logical(1))
                d[char_cols] <- lapply(d[char_cols], as.factor)
            }
            d
        })

        output$table <- DT::renderDataTable({
            DT::datatable(
                prepared_data(),
                filter = "top",
                selection = "none",
                rownames = FALSE,
                options = list(
                    pageLength = page.length,
                    scrollX = TRUE
                )
            )
        })

        # Return a reactive with only the filtered rows
        filtered_data <- reactive({
            d <- prepared_data()
            rows <- input$table_rows_all
            if (is.null(rows)) {
                return(d)
            }
            d[rows, , drop = FALSE]
        })

        return(filtered_data)
    })
}
