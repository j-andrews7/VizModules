#' Split an app dataset entry into its primary table and a rebuild function
#'
#' [createModuleApp()] filters one table and shows it in the Data Table, but a
#' module may need more than one: `ComplexHeatmap_Heatmap` takes
#' `list(matrix = , column_annotations = )`, where the matrix is what gets
#' filtered and the per-sample metadata rides along untouched. Rather than give
#' such modules a bespoke app, an entry of `data_list` may be either a plain data
#' frame or a named list of them.
#'
#' @param entry One element of `data_list`: a data frame, or a named list
#'   containing at least one.
#' @param primary Name of the element to treat as the primary table. `NULL`
#'   (the default) takes the first data frame in the list.
#'
#' @return A list with `primary` (the data frame to filter and display) and
#'   `rebuild`, a function taking a replacement primary and returning the entry
#'   in its original shape. `NULL` if the entry holds no data frame at all.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_app_entry_parts
#' @keywords internal
.app_entry_parts <- function(entry, primary = NULL) {
    if (is.data.frame(entry)) {
        return(list(primary = entry, rebuild = function(x) x))
    }
    if (!is.list(entry)) {
        return(NULL)
    }

    is_df <- vapply(entry, is.data.frame, logical(1))
    if (!any(is_df)) {
        return(NULL)
    }

    key <- if (!is.null(primary) && primary %in% names(entry)[is_df]) {
        primary
    } else {
        names(entry)[is_df][1]
    }
    # An unnamed list cannot be rebuilt by name, so fall back to position.
    idx <- if (is.null(key) || !nzchar(key)) which(is_df)[1] else key

    list(
        primary = entry[[idx]],
        rebuild = function(x) {
            out <- entry
            out[[idx]] <- x
            out
        }
    )
}


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
#' @param data_list A named list of datasets. Each element is either a data
#'   frame, or a named list of data frames for a module that needs companion
#'   tables alongside the one being filtered — e.g.
#'   `list(matrix = , column_annotations = )` for `ComplexHeatmap_Heatmap`. Only
#'   the primary table (see `primary.table`) is filtered and shown in the Data
#'   Table; the rest are passed through to the module untouched.
#' @param title A character string used as the page title
#'   (default: `"VizModules App"`).
#' @param defaults A named list of ui ids and their default values that can change the ui default
#'    settings on startup. An entry may also be a [shiny::reactive()] or [shiny::reactiveVal()] to
#'    have the input follow app state; see [setup_reactive_defaults()].
#' @param hide.inputs A character vector of input IDs to hide. These inputs are still
#'   initialized and their values passed to the plot, but are not shown in the UI.
#'   Passed through to `server_fn` when it accepts a `hide.inputs` argument.
#' @param hide.tabs A character vector of tab names to hide. Inputs in these tabs are
#'   still initialized and their values passed to the plot, but are not shown in the UI.
#'   Passed through to `server_fn` when it accepts a `hide.tabs` argument.
#' @param primary.table For a `data_list` entry that is a list of tables, the
#'   name of the one to filter and show in the Data Table. Defaults to the first
#'   data frame in the entry. Ignored for entries that are a plain data frame.
#' @param sidebar.width Bootstrap column width (1-11) for the controls sidebar;
#'   the plot area takes the rest. Raise the plot's share for a module whose
#'   output needs room, e.g. `sidebar.width = 3` for the heatmap.
#' @param show.table Logical. When `TRUE` (default), a filterable DT table is
#'   shown below the plot and its row selection drives the data passed to the
#'   plot module. When `FALSE`, the table and filter controls are hidden and
#'   the full (unfiltered) dataset is passed directly to the plot module.
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
                            hide.inputs = NULL,
                            hide.tabs = NULL,
                            show.table = TRUE,
                            title = "VizModules App",
                            primary.table = NULL,
                            sidebar.width = 4) {
    # Validate inputs
    stopifnot(is.function(inputs_ui_fn))
    stopifnot(is.function(output_ui_fn))
    stopifnot(is.function(server_fn))
    stopifnot(is.list(data_list), length(data_list) >= 1)
    stopifnot(is.numeric(sidebar.width), length(sidebar.width) == 1L,
        sidebar.width >= 1, sidebar.width <= 11)
    # An entry may be a data frame, or a named list of them for a module that
    # needs companion tables alongside the one being filtered.
    entry_parts <- lapply(data_list, .app_entry_parts, primary = primary.table)
    if (any(vapply(entry_parts, is.null, logical(1)))) {
        stop(
            "Every element of 'data_list' must be a data frame, or a list ",
            "containing at least one data frame.",
            call. = FALSE
        )
    }

    ui <- fluidPage(
        title = title,
        useShinyjs(),
        sidebarLayout(
            sidebarPanel(
                width = sidebar.width,
                h4("Data Import"),
                fileInput("file_upload", "Upload Data File",
                    accept = c(".xlsx", ".xls", ".csv", ".tsv", ".txt")
                ),
                actionButton("load_data", "Load Data",
                    class = "btn-primary"
                ),
                hr(),
                h4("Plot Settings"),
                viz_select_input("plot_select", "Select Dataset:",
                    choices = names(data_list)
                ),
                helpText("Plot settings reset when switching datasets."),
                uiOutput("plot_inputs_ui")
            ),
            mainPanel(
                width = 12 - sidebar.width,
                output_ui_fn("active_plot"),
                if (isTRUE(show.table)) tagList(
                    hr(),
                    h4("Data Table"),
                    p("Filtering the data table will update the plot.",
                        style = "color: grey; font-size: 12px;"
                    ),
                    dataFilterUI("table")
                )
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

        # The entry as supplied (data frame, or list of tables) ...
        active_entry <- reactive({
            req(input$plot_select)
            .app_entry_parts(req(rv$datasets[[input$plot_select]]), primary = primary.table)
        })
        # ... of which only the primary table is filtered and shown in the table.
        active_data <- reactive(req(active_entry())$primary)

        filtered_primary <- if (isTRUE(show.table)) {
            dataFilterServer("table", active_data)
        } else {
            active_data
        }

        # Hand the module back the shape it was given, with the filtered rows
        # swapped in; companion tables ride along untouched.
        filtered_data <- reactive(active_entry()$rebuild(filtered_primary()))

        # Keep dataset selector in sync when new datasets are loaded
        observeEvent(names(rv$datasets),
            {
                update_viz_select(session, "plot_select", choices = names(rv$datasets))
            },
            ignoreInit = TRUE
        )

        output$plot_inputs_ui <- renderUI({
            # The whole entry, not just the primary: a module that takes
            # companion tables needs them to build its controls (the heatmap's
            # column-annotation choices come from its metadata table).
            entry <- req(rv$datasets[[input$plot_select]])
            inputs_ui_fn("active_plot",
                entry,
                title = h3(paste(input$plot_select, "Settings")), defaults = defaults
            )
        })

        # Pass hide.inputs/hide.tabs/defaults to the server only when it accepts
        # them, so custom module servers without these arguments still work.
        server_args <- list("active_plot", data = filtered_data)
        server_formals <- names(formals(server_fn))
        if ("defaults" %in% server_formals) {
            server_args[["defaults"]] <- defaults
        }
        if ("hide.inputs" %in% server_formals) {
            server_args[["hide.inputs"]] <- hide.inputs
        }
        if ("hide.tabs" %in% server_formals) {
            server_args[["hide.tabs"]] <- hide.tabs
        }
        do.call(server_fn, server_args)
    }

    shinyApp(ui, server)
}
