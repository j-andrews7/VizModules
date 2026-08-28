#' Find columns referenced by a plotly figure's trace attributes
#'
#' Walks a `plotly` object's `x$attrs` (the per-trace arguments captured at
#' trace-construction time, e.g. `~mpg` formulas or literal vectors/lists such
#' as parcoords `dimensions`) to determine which columns of the plot's source
#' data.frame are actually rendered. This works generically across both
#' `ggplotly()`-converted figures (which encode mappings as `.data[["col"]]`
#' formulas) and figures built directly with `plot_ly()`/`add_trace()` (which
#' may use `~col` formulas, literal `label = "col"` entries, or, as a last
#' resort, raw data vectors matched back to `full_data` by value).
#'
#' @param plot A `plotly` object.
#' @param full_data The `data.frame` returned by `plotly_data(plot)`.
#'
#' @return A character vector of column names in `full_data` referenced by
#'   `plot`.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_plotted_vars_from_attrs
.plotted_vars_from_attrs <- function(plot, full_data) {
    cols <- names(full_data)
    attrs <- tryCatch(plot$x$attrs, error = function(e) NULL)
    if (is.null(attrs) || length(cols) == 0) {
        return(character(0))
    }

    tokens <- character(0)
    literal_vecs <- list()

    # Recurse through formulas/calls/lists, collecting every symbol and string
    # literal encountered (candidate column names) plus any literal data
    # vectors (fallback for values passed with no accompanying name).
    walk <- function(e) {
        if (inherits(e, "formula")) {
            # Quosures are formulas but deprecate `[[` subsetting; strip the
            # class so plain language-object indexing is used instead.
            class(e) <- setdiff(class(e), "quosure")
            walk(e[[length(e)]])
        } else if (is.call(e)) {
            for (a in as.list(e)) walk(a)
        } else if (is.symbol(e)) {
            tokens <<- c(tokens, as.character(e))
        } else if (is.character(e)) {
            tokens <<- c(tokens, e)
        } else if (is.list(e)) {
            for (el in e) walk(el)
        } else if (is.atomic(e) && length(e) > 1) {
            literal_vecs[[length(literal_vecs) + 1]] <<- e
        }
    }
    for (trace_attrs in attrs) {
        for (v in trace_attrs) walk(v)
    }

    found <- intersect(cols, unique(tokens))

    remaining <- setdiff(cols, found)
    if (length(remaining) && length(literal_vecs) && nrow(full_data) > 0) {
        for (vec in literal_vecs) {
            if (length(remaining) == 0) break
            if (length(vec) != nrow(full_data)) next
            for (col in remaining) {
                same <- tryCatch(
                    isTRUE(all.equal(unname(vec), unname(full_data[[col]]), check.attributes = FALSE)),
                    error = function(e) FALSE
                )
                if (same) {
                    found <- c(found, col)
                    remaining <- setdiff(remaining, col)
                }
            }
        }
    }
    unique(found)
}

#' Find columns referenced by module UI inputs
#'
#' Complements [.plotted_vars_from_attrs()] for columns that never make it
#' into the built `plotly` figure, most notably `split.by`/`facet.by`
#' variables (faceting is resolved before the `ggplot`-to-`plotly` conversion,
#' so the facet column name is lost from the figure entirely). All plot
#' modules name their column-selecting inputs with a consistent convention
#' (e.g. `x.by`, `color.by`, `x.value`, `x.data`, `labels`, `theta`, `group`,
#' `dimensions`), so inputs matching that convention are checked against the
#' plot's source columns.
#'
#' @param ui_inputs A named list of UI input values (see `inputs_reactive` in
#'   [collect_source_data()]).
#' @param cols A character vector of the plot's source data.frame column
#'   names.
#'
#' @return A character vector of column names in `cols` referenced by
#'   `ui_inputs`.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_plotted_vars_from_inputs
.plotted_vars_from_inputs <- function(ui_inputs, cols) {
    if (is.null(ui_inputs) || length(ui_inputs) == 0 || length(cols) == 0) {
        return(character(0))
    }
    selector_names <- c("labels", "values", "theta", "r", "group", "dimensions", "var")
    is_selector <- grepl("\\.(by|value|data)$", names(ui_inputs)) | names(ui_inputs) %in% selector_names
    char_inputs <- Filter(function(v) is.character(v) && length(v) > 0, ui_inputs[is_selector])
    intersect(unique(unlist(char_inputs, use.names = FALSE)), cols)
}

#' Collect plot and source data for download
#'
#' Collects the plot object, its underlying data, statistical testing details (if applied),
#' and optional UI input values into a single list for downstream download
#' generation.
#'
#' @param plot_reactive A reactive expression returning a `plotly` plot object.
#' @param stats_reactive Optional. A reactive expression (e.g. a
#'   [shiny::reactiveVal()]) returning a `data.frame` of statistical test results.
#'   When `NULL` or when the reactive returns `NULL`, no statistics data is
#'   included.
#' @param inputs_reactive Optional. A reactive expression returning a named
#'   list of UI input values. When `NULL` or when it returns `NULL`, no UI
#'   input data is included.
#'
#' @return A named list with elements:
#' \describe{
#'   \item{plot}{The `plotly` plot object.}
#'   \item{plot_data}{A `data.frame` of the plot's underlying data, limited to
#'     the columns and rows actually rendered (see Details).}
#'   \item{stats}{A `data.frame` of statistical test results, or `NULL`.}
#'   \item{inputs}{A `data.frame` of UI input names and values, or `NULL`.}
#' }
#'
#' @details `plot_data` is scoped down from the plot's full source data.frame
#'   (as returned by [plotly::plotly_data()]) in two ways:
#'   \itemize{
#'     \item{Columns are limited to those actually mapped in the plot (x, y,
#'       color/fill, shape, size, labels/values, facets, etc.), detected by
#'       inspecting the built `plotly` figure's trace attributes and, for
#'       columns that don't survive conversion to `plotly` (namely
#'       `split.by`/`facet.by`), the UI input values.}
#'     \item{Rows are limited to those with complete data across the detected
#'       columns, since rows with `NA` in a plotted aesthetic are dropped by
#'       the underlying plotting functions.}
#'   }
#'   If no plotted columns can be detected, the full source data.frame is
#'   returned unchanged.
#'
#' @author Jacob Martin, Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Example usage in a Shiny app
#' library(shiny)
#' library(plotly)
#' library(VizModules)
#'
#' ui <- fluidPage(
#'     plotlyOutput("my_plot"),
#'     downloadButton("download_data", "Download Plot and Data")
#' )
#'
#' server <- function(input, output) {
#'     plot_reactive <- reactive({
#'        plot_ly(mtcars, x = ~mpg, y = ~hp, type = "scatter", mode = "markers")
#'     })
#'
#'     data_list <- collect_source_data(plot_reactive)
#'     output$my_plot <- renderPlotly(plot_reactive())
#'     output$download_data <- create_source_download_handler(reactive(data_list))
#' }
#'
#' shinyApp(ui, server)
#' }
collect_source_data <- function(plot_reactive,
                                stats_reactive = NULL,
                                inputs_reactive = NULL) {

    plot <- plot_reactive()
    full_data <- as.data.frame(plotly_data(plot))
    stats <- NULL

    if (!is.null(stats_reactive)) {
        stats_df <- tryCatch(stats_reactive(), error = function(e) NULL)
        if (!is.null(stats_df)) {
            stats <- as.data.frame(stats_df) 
        }
    }

    ui_inputs <- tryCatch(isolate(inputs_reactive), error = function(e) {
        message("ERROR: ", e$message)
        NULL
    })

    plotted_vars <- intersect(
        names(full_data),
        unique(c(
            .plotted_vars_from_attrs(plot, full_data),
            .plotted_vars_from_inputs(ui_inputs, names(full_data))
        ))
    )

    if (length(plotted_vars) > 0) {
        keep_rows <- stats::complete.cases(full_data[, plotted_vars, drop = FALSE])
        plot_data <- full_data[keep_rows, plotted_vars, drop = FALSE]
    } else {
        plot_data <- full_data
    }

    inp <- data.frame(
        names  = names(ui_inputs),
        values = vapply(ui_inputs, function(x) {
            if (is.null(x) || length(x) == 0) ""
            else if (length(x) > 1) paste(x, collapse = ", ")
            else as.character(x)
        }, character(1))
    )

    data_list <- list("plot" = plot, "plot_data" = plot_data, "stats" = stats, "inputs" = inp)
    data_list
}


#' Create download handler for plot with source data
#'
#' Generates a Shiny [downloadHandler()] that bundles the interactive plot and
#' its supporting data into a single `.zip` archive.
#'
#' @param data_list A reactive returning either a single summary list produced
#'   by [collect_source_data()] (with elements `plot`, `plot_data`,
#'   `stats`, and `inputs`), or a named list of such summaries (one per plot).
#'   When a named list of summaries is supplied, each summary is written to its
#'   own set of files (prefixed with the list name) so several plots can be
#'   bundled into a single archive.
#' @param filename_base `character(1)`. Base name for the downloaded `.zip`
#'   file without extension. The final filename takes the form
#'   `<filename_base>_<Sys.Date()>.zip`.
#'
#' @return A `downloadHandler` object suitable for assignment to a Shiny
#' output.
#'
#' @importFrom htmlwidgets saveWidget
#' @importFrom shiny downloadHandler
#' @importFrom shinyjqui jqui_resizable
#' @importFrom zip zip
#' @importFrom utils write.csv
#'
#' @author Jacob Martin
#' @export
#' @examples
#' \dontrun{
#' # Example usage in a Shiny app
#' library(shiny)
#' library(plotly)
#' library(VizModules)
#' ui <- fluidPage(
#'     plotlyOutput("my_plot"),
#'     downloadButton("download_data", "Download Plot and Data")
#' )
#'
#' server <- function(input, output) {
#'     plot_reactive <- reactive({
#'         plot_ly(mtcars, x = ~mpg, y = ~hp, type = "scatter", mode = "markers")
#'     })
#'
#'     data_list <- collect_source_data(plot_reactive)
#'     output$my_plot <- renderPlotly(plot_reactive())
#'     output$download_data <- create_source_download_handler(reactive(data_list))
#' }
#'
#' shinyApp(ui, server)
#' }
create_source_download_handler <- function(data_list, filename_base = "source_data"){
    downloadHandler(
        filename = function() {
            paste0(filename_base, "_", Sys.Date(), ".zip")
        },
        content = function(file) {
            # Use a fresh temporary directory that lives for the duration of the
            # download. Creating it inside `content` (rather than when the
            # handler is built) ensures the directory still exists when the
            # files are written.
            tmp <- tempfile("vizmodules_source_")
            dir.create(tmp)
            on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

            data_list_value <- data_list()

            # A single source (e.g. from one plot) is a flat named list with a
            # top-level "plot" element. Wrap it so a single source and a list
            # of sources (one per panel) can be written by the same loop.
            if ("plot" %in% names(data_list_value)) {
                data_list_value <- list("Data" = data_list_value)
            }

            for (x in names(data_list_value)) {
                object <- data_list_value[[x]]
                if (is.null(object)) {
                    next
                }

                # Sanitise the (possibly user-facing) name so it is safe to use
                # as part of a file path.
                safe <- gsub("[^A-Za-z0-9._-]+", "_", x)

                if (!is.null(object$stats)) {
                    write.csv(object$stats, file.path(tmp, paste0(safe, "_stats_data.csv")), row.names = FALSE)
                }

                if (!is.null(object$plot)) {
                    saveWidget(
                        widget = jqui_resizable(object$plot),
                        file = file.path(tmp, paste0(safe, "_plot.html")),
                        selfcontained = TRUE
                    )
                }

                if (!is.null(object$plot_data)) {
                    write.csv(object$plot_data, file.path(tmp, paste0(safe, "_plot_data.csv")), row.names = FALSE)
                }

                if (!is.null(object$inputs)) {
                    write.csv(object$inputs, file.path(tmp, paste0(safe, "_ui_inputs.csv")), row.names = FALSE)
                }
            }

            files_to_zip <- list.files(tmp, full.names = FALSE)

            if (length(files_to_zip) == 0) {
                stop("No files were created to zip.")
            }

            zip(zipfile = file, files = files_to_zip, root = tmp, mode = "cherry-pick")
        }
    )
}
