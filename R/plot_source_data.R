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
#'   \item{plot_data}{A `data.frame` of the plot's underlying data.}
#'   \item{stats}{A `data.frame` of statistical test results, or `NULL`.}
#'   \item{inputs}{A `data.frame` of UI input names and values, or `NULL`.}
#' }
#'
#' @author Jacob Martin
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
            plot_data <- as.data.frame(plotly_data(plot))
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
    
            inp <- data.frame(
                names  = names(ui_inputs),
                values = unlist(lapply(ui_inputs, function(x) {
                    if (is.null(x)) "NULL"
                    else if (length(x) > 1) paste(x, collapse = ", ")
                    else as.character(x)
            })))
            data_list <- list("plot" = plot, "plot_data" = plot_data, "stats" = stats, "inputs" = inp)
            return(data_list)
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

