#' Create an Example Module App from Any Module Trio
#'
#' Factory function that generates a standard Shiny application for any
#' VizModules module.
#' The resulting app features a **Data Import** section for uploading
#' data files, a **Data Table** for viewing and editing the active
#' dataset, and a **Plot** area for configuring and displaying an interactive
#' plot.
#'
#' Uploaded files (Excel, CSV, TSV, or tab-delimited text) are added to the
#' available datasets and can be selected for plotting.
#' If an uploaded file shares a name with an existing dataset, the existing
#' one is overwritten with a warning.
#'
#' Every module-specific `*App()` convenience function (e.g.
#' [plotthis_BarPlotApp()], [linePlotApp()]) is a thin wrapper around
#' `createModuleApp()`.
#' You can also call it directly for quick prototyping or to create apps
#' for custom wrapper modules.
#'
#' @param inputs_ui_fn A function with signature
#'   `function(id, data, ...)` that returns module input UI elements
#'   (e.g. [plotthis_BarPlotInputsUI()]).
#' @param output_ui_fn A function with signature `function(id)` that
#'   returns the module's output UI (e.g. [plotthis_BarPlotOutputUI()]).
#' @param server_fn A function with signature
#'   `function(id, data, ...)` that drives the module server logic
#'   (e.g. [plotthis_BarPlotServer()]).
#' @param data_list A named list of data frames.
#'   At least one element is required.
#' @param title A character string used as the page title
#'   (default: `"VizModules App"`).
#' @param defaults A named list of ui ids and their default values that can change the ui default 
#'    settings on startup. 
#' @return A [shiny::shinyApp()] object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @importFrom readxl read_excel
#' @importFrom utils read.csv read.delim
#' @importFrom tools file_ext file_path_sans_ext
#'
#' @export
#' @author Jared Andrews
#' @examples
#' library(VizModules)
#'
#' # Quick-launch a bar plot app with custom data:
#' app <- createModuleApp(
#'     inputs_ui_fn = plotthis_BarPlotInputsUI,
#'     output_ui_fn = plotthis_BarPlotOutputUI,
#'     server_fn    = plotthis_BarPlotServer,
#'     data_list    = list("iris" = iris),
#'     title        = "My Bar Plot",
#'     defaults     = NULL
#' )
#' if (interactive()) runApp(app)
#'
#' # Works with any module trio, including custom wrapper modules:
#' app2 <- createModuleApp(
#'     inputs_ui_fn = dittoViz_scatterPlotInputsUI,
#'     output_ui_fn = dittoViz_scatterPlotOutputUI,
#'     server_fn    = dittoViz_scatterPlotServer,
#'     data_list    = list("iris" = iris),
#'     title        = "Scatter",
#'     defaults    = NULL
#' )
#' if (interactive()) runApp(app2)
createModuleApp <- function(inputs_ui_fn,
                            output_ui_fn,
                            server_fn,
                            data_list,
                            defaults = NULL,
                            title = "VizModules App") {
    # Validate inputs
    stopifnot(is.function(inputs_ui_fn))
    stopifnot(is.function(output_ui_fn))
    stopifnot(is.function(server_fn))
    stopifnot(is.list(data_list), length(data_list) >= 1)
    for (df in data_list) {
        stopifnot(is.data.frame(df))
    }

    ui <- fluidPage(
        title = title,
        useShinyjs(),
        sidebarLayout(
            sidebarPanel(
                h4("Data Import"),
                fileInput("file_upload", "Upload Data File",
                    accept = c(".xlsx", ".xls", ".csv", ".tsv", ".txt")
                ),
                actionButton("load_data", "Load Data",
                    class = "btn-primary"
                ),
                hr(),
                h4("Plot Settings"),
                selectInput("plot_select", "Select Dataset:",
                    choices = names(data_list), selectize = FALSE
                ),
                helpText("Plot settings reset when switching datasets."),
                uiOutput("plot_inputs_ui")
            ),
            mainPanel(
                output_ui_fn("active_plot"),
                hr(),
                h4("Data Table"),
                p("Filtering the data table will update the plot.",
                    style = "color: grey; font-size: 12px;"
                ),
                dataFilterUI("table")
            )
        )
    )

    server <- function(input, output, session) {
        rv <- reactiveValues(datasets = data_list)

        observeEvent(input$load_data, {
            req(input$file_upload)
            tryCatch(
                {
                    filepath <- input$file_upload$datapath
                    ext <- tolower(
                        file_ext(input$file_upload$name)
                    )
                    new_data <- switch(ext,
                        xlsx = as.data.frame(
                            read_excel(filepath)
                        ),
                        xls = as.data.frame(
                            read_excel(filepath)
                        ),
                        csv = read.csv(
                            filepath,
                            stringsAsFactors = TRUE
                        ),
                        tsv = read.delim(
                            filepath,
                            stringsAsFactors = TRUE
                        ),
                        txt = read.delim(
                            filepath,
                            stringsAsFactors = TRUE
                        ),
                        stop("Unsupported file type: .", ext)
                    )

                    new_data <- as.data.frame(new_data)
                    name <- file_path_sans_ext(
                        input$file_upload$name
                    )

                    rv$datasets[[name]] <- new_data
                    showNotification(
                        paste0(
                            "Loaded '", name, "' (",
                            nrow(new_data), " rows, ",
                            ncol(new_data), " cols)"
                        ),
                        type = "message"
                    )
                },
                error = function(e) {
                    showNotification(
                        paste(
                            "Could not read the uploaded file.",
                            "Supported formats: .xlsx, .xls,",
                            ".csv, .tsv, .txt (tab-delimited)."
                        ),
                        type = "error"
                    )
                }
            )
        })

        filtered_data <- dataFilterServer(
            "table",
            reactive(rv$datasets[[input$plot_select]])
        )

        # Keep dataset selector in sync when new datasets are loaded
        observe({
            updateSelectInput(session, "plot_select",
                choices = names(rv$datasets)
            )
        })

        output$plot_inputs_ui <- renderUI({
            req(rv$datasets[[input$plot_select]])
            inputs_ui_fn("active_plot",
                rv$datasets[[input$plot_select]],
                title = h3(paste(input$plot_select, "Settings")), defaults = defaults
            )
        })

        server_fn("active_plot", data = filtered_data)
    }

    shinyApp(ui, server)
}
