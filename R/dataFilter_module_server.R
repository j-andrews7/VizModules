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
#' @param col.visibility Logical. When `TRUE`, adds a DT "Columns" button
#'   (Buttons extension `colvis`) so users can show/hide individual columns.
#'   Defaults to `FALSE`.
#' @param hide.columns Character vector of column names (or a numeric vector of
#'   column positions) to hide when the table is first drawn. Hidden columns get
#'   no filter box, which keeps the interface focused on the columns that matter.
#'   They are still present in the returned data, so plotting modules can use
#'   them. Set `col.visibility = TRUE` if users should be able to bring them
#'   back; otherwise they stay hidden. Names that do not occur in `data` are
#'   ignored with a warning. Defaults to `NULL` (show every column).
#'
#' @return A `reactive` expression that evaluates to the filtered subset of
#'   `data` based on the current DT selection/filter state. All columns are
#'   retained, including any hidden via `hide.columns`. Pass this reactive to a
#'   plotting module's `data` argument to keep the plot in sync with the table
#'   filters.
#'
#' @import shiny
#'
#' @export
#' @author Jacob Martin
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
#'     # Petal columns are hidden on load, but the "Columns" button lets users
#'     # bring them back, and they remain in the returned data either way.
#'     filtered <- dataFilterServer("filter", data,
#'         factor.char.cols = TRUE,
#'         hide.columns = c("Petal.Length", "Petal.Width"),
#'         col.visibility = TRUE
#'     )
#'     output$rows <- renderPrint(nrow(filtered()))
#' }
#'
#' if (interactive()) shinyApp(ui, server)
dataFilterServer <- function(id, data, factor.char.cols = TRUE, page.length = 10,
                             col.visibility = FALSE, hide.columns = NULL) {
    stopifnot(is.reactive(data))
    if (!is.null(hide.columns) && !is.character(hide.columns) && !is.numeric(hide.columns)) {
        stop("'hide.columns' must be a character vector of column names or a ",
            "numeric vector of column positions.",
            call. = FALSE
        )
    }

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
            d <- prepared_data()
            dt_opts <- list(pageLength = page.length, scrollX = TRUE)
            dt_ext <- character(0)
            if (isTRUE(col.visibility)) {
                dt_ext <- "Buttons"
                dt_opts$dom <- "Blfrtip"
                dt_opts$buttons <- list(list(extend = "colvis", text = "Columns"))
            }
            hidden <- .resolve_hidden_cols(names(d), hide.columns)
            if (length(hidden) > 0) {
                dt_opts$columnDefs <- list(list(visible = FALSE, targets = hidden))
            }
            DT::datatable(
                d,
                filter = "top",
                selection = "none",
                rownames = FALSE,
                extensions = dt_ext,
                options = dt_opts
            )
        })

        # Return a reactive with only the filtered rows
        filtered_data <- reactive({
            d <- prepared_data()
            rows <- input$table_rows_all
            if (is.null(rows)) {
                return(d)
            }
            d <- d[rows, , drop = FALSE]
            droplevels(d) # Drop un unused levels so that they dont get plotted
        })

        return(filtered_data)
    })
}


#' Translate hidden column names/positions into DT column targets
#'
#' Maps the `hide.columns` argument of [dataFilterServer()] onto the
#' zero-based `targets` indices DataTables expects in a `columnDefs` entry.
#' Zero-based because the table is rendered with `rownames = FALSE`, so the
#' first data column is column 0.
#'
#' @param cols Character vector of the column names currently in the data.
#' @param hide.columns `NULL`, a character vector of column names, or a
#'   numeric vector of one-based column positions.
#'
#' @return An integer vector of zero-based column indices, possibly empty.
#'   Entries that do not match a column are dropped with a warning.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_resolve_hidden_cols
.resolve_hidden_cols <- function(cols, hide.columns) {
    if (length(hide.columns) == 0) {
        return(integer(0))
    }

    if (is.numeric(hide.columns)) {
        idx <- as.integer(hide.columns)
        unmatched <- is.na(idx) | idx < 1L | idx > length(cols)
    } else {
        idx <- match(as.character(hide.columns), cols)
        unmatched <- is.na(idx)
    }

    if (any(unmatched)) {
        warning(
            "'hide.columns' entries not found in the data, ignoring: ",
            paste(hide.columns[unmatched], collapse = ", "),
            call. = FALSE
        )
    }

    unique(idx[!unmatched]) - 1L
}
