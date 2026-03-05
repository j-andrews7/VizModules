#' Create an example Modular linePlot Shiny Application
#'
#' This function generates a Shiny application with modular [VizModules::linePlot()] components.
#' The app features three tabs: a **Data Input** tab for uploading Excel spreadsheets,
#' a **Table** tab for viewing and editing the active dataset, and a **Plots** tab
#' for configuring and displaying an interactive line plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `iris` and `mtcars` as example datasets. Any uploaded Excel file is added
#' to the available datasets and can be selected for plotting.
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("iris" = iris, "mtcars" = mtcars)` is used as example data.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @importFrom readxl read_excel
#'
#' @seealso [VizModules::linePlot()], [VizModules::linePlotInputsUI()],
#' [VizModules::linePlotOutputUI()], [VizModules::linePlotServer()]
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(VizModules)
#' # Launch with default example data (iris & mtcars):
#' app <- linePlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' app2 <- linePlotApp(list("cars" = mtcars))
#' if (interactive()) runApp(app2)
linePlotApp <- function(data_list = NULL) {
    # Use default example data when none is provided
    if (is.null(data_list)) {
        data_list <- list("iris" = iris, "mtcars" = mtcars)
    }

    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- navbarPage(
        title = "Modular linePlots",
        useShinyjs(),

        # --- Data Input tab ---
        tabPanel("Data Input",
            sidebarLayout(
                sidebarPanel(
                    fileInput("file_upload", "Upload Excel File",
                        accept = c(".xlsx", ".xls")
                    ),
                    actionButton("load_data", "Load Data", class = "btn-primary")
                ),
                mainPanel(
                    h4("Available Datasets"),
                    uiOutput("dataset_info")
                )
            )
        ),

        # --- Table tab ---
        tabPanel("Table",
            fluidRow(
                column(4,
                    selectInput("table_select", "Select Dataset:", choices = names(data_list))
                )
            ),
            DT::dataTableOutput("data_table")
        ),

        # --- Plots tab ---
        tabPanel("Plots",
            sidebarLayout(
                sidebarPanel(
                    selectInput("plot_select", "Select Dataset:", choices = names(data_list)),
                    uiOutput("plot_inputs_ui")
                ),
                mainPanel(
                    linePlotOutputUI("active_plot")
                )
            )
        )
    )

    server <- function(input, output, session) {
        # Reactive store for all datasets
        rv <- reactiveValues(datasets = data_list)

        # ---- Data Input tab ----
        observeEvent(input$load_data, {
            req(input$file_upload)
            tryCatch({
                new_data <- as.data.frame(
                    readxl::read_excel(input$file_upload$datapath)
                )
                name <- tools::file_path_sans_ext(input$file_upload$name)
                rv$datasets[[name]] <- new_data
                showNotification(
                    paste0("Loaded '", name, "' (", nrow(new_data),
                        " rows, ", ncol(new_data), " cols)"),
                    type = "message"
                )
            }, error = function(e) {
                showNotification(paste("Error reading file:", e$message),
                    type = "error")
            })
        })

        # Keep dataset selectors in sync
        observe({
            dataset_names <- names(rv$datasets)
            updateSelectInput(session, "table_select", choices = dataset_names)
            updateSelectInput(session, "plot_select", choices = dataset_names)
        })

        # Show summary of available datasets
        output$dataset_info <- renderUI({
            dataset_names <- names(rv$datasets)
            if (length(dataset_names) == 0) {
                return(p("No datasets loaded."))
            }
            tags$ul(
                lapply(dataset_names, function(name) {
                    d <- rv$datasets[[name]]
                    tags$li(
                        strong(name),
                        paste0(" — ", nrow(d), " rows, ", ncol(d), " columns")
                    )
                })
            )
        })

        # ---- Table tab ----
        output$data_table <- DT::renderDataTable({
            req(input$table_select)
            d <- rv$datasets[[input$table_select]]
            req(d)
            DT::datatable(d,
                editable = TRUE,
                filter = "top",
                rownames = FALSE,
                options = list(pageLength = 10, scrollX = TRUE)
            )
        })

        # Handle cell edits in the table
        observeEvent(input$data_table_cell_edit, {
            info <- input$data_table_cell_edit
            name <- input$table_select
            # DT uses 0-based column index; row is 1-based
            row_idx <- info$row
            col_idx <- info$col + 1L
            d <- rv$datasets[[name]]
            d[row_idx, col_idx] <- DT::coerceValue(info$value, d[row_idx, col_idx])
            rv$datasets[[name]] <- d
        })

        # ---- Plots tab ----
        # Dynamically render plot inputs when the selected dataset changes
        output$plot_inputs_ui <- renderUI({
            req(input$plot_select)
            d <- rv$datasets[[input$plot_select]]
            req(d)
            linePlotInputsUI("active_plot", d,
                title = h3(paste(input$plot_select, "Settings"))
            )
        })

        # Reactive data for the plot module
        active_data <- reactive({
            req(input$plot_select)
            rv$datasets[[input$plot_select]]
        })

        # Single plot module driven by the active dataset
        linePlotServer("active_plot", data = active_data)
    }

    shinyApp(ui, server)
}
