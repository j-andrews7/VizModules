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
#'   free-text search boxes. Note that DT serialises every level of a factor
#'   column into the page, so this is best avoided for columns with very many
#'   distinct values. Defaults to `TRUE`.
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
#' @param filter.max.options Integer. The maximum number of options a factor
#'   column's filter dropdown renders at once. Typing in the box narrows the
#'   list, so a low cap keeps high-cardinality columns usable. Defaults to
#'   `50`.
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
#' @seealso [dataFilterUI()], [resolve_column_targets()]
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
                             col.visibility = FALSE, hide.columns = NULL,
                             filter.max.options = 50) {
    stopifnot(is.reactive(data))
    if (!is.numeric(filter.max.options) || length(filter.max.options) != 1 || filter.max.options < 1) {
        stop("'filter.max.options' must be a single positive number.", call. = FALSE)
    }
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
                dt_opts$dom <- "<'vizmodules-dt-toolbar'Blf>rtip"
                dt_opts$buttons <- list(list(extend = "colvis", text = "Columns"))
            }
            hidden <- resolve_column_targets(d, hide.columns)
            if (length(hidden) > 0) {
                dt_opts$columnDefs <- list(list(visible = FALSE, targets = hidden))
            }
            DT::datatable(
                d,
                filter = list(
                    position = "top",
                    settings = list(select = list(maxOptions = filter.max.options))
                ),
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


#' Translate column names or positions into DT column targets
#'
#' Maps a set of columns onto the zero-based `targets` indices DataTables
#' expects inside a `columnDefs` entry. This is what [dataFilterServer()] uses
#' to honour its `hide.columns` argument, but it is useful for any hand-rolled
#' [DT::datatable()] where columns are referred to by name rather than by
#' position -- hiding them, setting widths, disabling ordering, and so on.
#'
#' Columns that do not exist are dropped with a warning rather than raising an
#' error, so a table fed by a changing data frame keeps rendering when a column
#' comes and goes.
#'
#' @param data A data frame, or a character vector of the column names in the
#'   order they are passed to [DT::datatable()].
#' @param columns `NULL`, a character vector of column names, or a numeric
#'   vector of one-based column positions to resolve.
#' @param rownames Logical. Whether the table is drawn with a row-names column
#'   (the `rownames` argument of [DT::datatable()]). When `TRUE`, row names
#'   occupy column 0 and every data column shifts one to the right, so the
#'   returned targets are shifted to match. Defaults to `FALSE`.
#'
#' @return An integer vector of zero-based column indices, possibly empty.
#'
#' @export
#' @author Jared Andrews
#' @seealso [dataFilterServer()]
#' @examples
#' # Hide two columns of a plain DT table by name.
#' targets <- resolve_column_targets(iris, c("Petal.Length", "Petal.Width"))
#' targets
#'
#' if (interactive()) {
#'     DT::datatable(
#'         iris,
#'         rownames = FALSE,
#'         options = list(
#'             columnDefs = list(list(visible = FALSE, targets = targets))
#'         )
#'     )
#' }
resolve_column_targets <- function(data, columns, rownames = FALSE) {
    if (is.data.frame(data)) {
        data <- names(data)
    }
    stopifnot(is.character(data))
    if (!is.null(columns) && !is.character(columns) && !is.numeric(columns)) {
        stop("'columns' must be a character vector of column names or a ",
            "numeric vector of column positions.",
            call. = FALSE
        )
    }

    if (length(columns) == 0) {
        return(integer(0))
    }

    if (is.numeric(columns)) {
        idx <- as.integer(columns)
        unmatched <- is.na(idx) | idx < 1L | idx > length(data)
    } else {
        idx <- match(as.character(columns), data)
        unmatched <- is.na(idx)
    }

    if (any(unmatched)) {
        warning(
            "Column(s) not found in the data, ignoring: ",
            paste(columns[unmatched], collapse = ", "),
            call. = FALSE
        )
    }

    # DT targets are zero-based, offset by the row-names column when shown.
    unique(idx[!unmatched]) - 1L + isTRUE(rownames)
}
