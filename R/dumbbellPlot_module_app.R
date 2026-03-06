#' Create a Shiny App for Dumbbell Plots
#'
#' This function generates a Shiny application for interactive dumbbell plots.
#' The app features a **Data Import** section for uploading Excel spreadsheets,
#' a **Data Table** for viewing and editing the active dataset, and a **Plot** area
#' for configuring and displaying an interactive dumbbell plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' `iris` and `mtcars` as example datasets. Uploaded Excel files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   `list("iris" = iris, "mtcars" = mtcars)` is used as example data.
#' @return A Shiny app object.
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjs useShinyjs
#' @importFrom readxl read_excel
#'
#' @export
#' @author Jacob Martin
#' @seealso [VizModules::dumbbellPlot()], [VizModules::dumbbellPlotInputsUI()],
#' [VizModules::dumbbellPlotOutputUI()], [VizModules::dumbbellPlotServer()]
#'
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- dumbbellPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' data <- data.frame(
#'   School = c("MIT", "Stanford", "Harvard"),
#'   Women = c(94, 96, 112),
#'   Men = c(152, 151, 165),
#'   Group = c("A", "B", "A")
#' )
#' app2 <- dumbbellPlotApp(list("School Earnings" = data))
#' if (interactive()) runApp(app2)
dumbbellPlotApp <- function(data_list = NULL) {
    # Use default example data when none is provided
    if (is.null(data_list)) {
        data_list <- list("iris" = iris, "mtcars" = mtcars)
    }

    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        title = "Modular dumbbellPlots",
        useShinyjs(),

        sidebarLayout(
            sidebarPanel(

                # --- Data Import ---
                h4("Data Import"),
                fileInput("file_upload", "Upload Excel File",
                    accept = c(".xlsx", ".xls")
                ),
                actionButton("load_data", "Load Data", class = "btn-primary"),
                hr(),

                # --- Plot Settings ---
                h4("Plot Settings"),
                selectInput("plot_select", "Select Dataset:", choices = names(data_list)),
                helpText("Plot settings reset when switching datasets."),
                uiOutput("plot_inputs_ui")

            ),
            mainPanel(

                # --- Plot ---
                dumbbellPlotOutputUI("active_plot"),
                hr(),

                # --- Table ---
                h4("Data Table"),
                p("Filtering or editing the data table will update the plot.",
                    style = "color: grey; font-size: 12px;"),
                dataFilterUI(paste0("table"))

            )
        )
    )

    server <- function(input, output, session) {

        rv <- reactiveValues(datasets = data_list)

        # Update active_data whenever the selected dataset changes
        observeEvent(input$plot_select, {
            req(input$plot_select)
        })

        # ---- Data Import ----
        observeEvent(input$load_data, {
            req(input$file_upload)
            tryCatch({
                new_data <- as.data.frame(
                    readxl::read_excel(input$file_upload$datapath)
                )
                name <- tools::file_path_sans_ext(input$file_upload$name)
                rv$datasets[[name]] <- new_data
                showNotification(
                    paste0("Loaded '", name, "' (", nrow(new_data), " rows, ", ncol(new_data), " cols)"),
                    type = "message"
                )
            }, error = function(e) {
                showNotification(
                    paste("Could not read the uploaded file.",
                        "Please ensure it is a valid Excel (.xlsx/.xls) file."),
                    type = "error"
                )
            })
        })
        filtered_data <- dataFilterServer("table", reactive(rv$datasets[[input$plot_select]]))
        # Keep dataset selector in sync when new datasets are loaded
        observe({
            updateSelectInput(session, "plot_select", choices = names(rv$datasets))
        })

        # ---- Plot Settings UI ----
        output$plot_inputs_ui <- renderUI({
            req(rv$datasets[[input$plot_select]])
            dumbbellPlotInputsUI("active_plot", rv$datasets[[input$plot_select]],
                title = h3(paste(input$plot_select, "Settings"))
            )
        })

        # ---- Plot Module ----
        dumbbellPlotServer("active_plot", data = filtered_data)
    }
    shinyApp(ui, server)
}
