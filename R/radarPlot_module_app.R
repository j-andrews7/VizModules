#' Create an example Modular radarPlot Shiny Application
#'
#' This function generates a Shiny application with modular radarPlot components.
#' The app features a **Data Import** section for uploading Excel spreadsheets,
#' a **Data Table** for viewing and editing the active dataset, and a **Plot** area
#' for configuring and displaying an interactive radar plot.
#'
#' When `data_list` is not provided (or `NULL`), the app launches with
#' example `skills` and `team_stats` datasets. Uploaded Excel files are added
#' to the available datasets and can be selected for plotting. If an uploaded
#' file shares a name with an existing dataset, the existing one is overwritten
#' with a warning.
#'
#' @param data_list An optional named list of data frames. If `NULL` (the default),
#'   example datasets with categories and values are used. Each data frame should
#'   contain columns for categories (theta) and values (r). For multiple traces, include a
#'   grouping column.
#' @return A Shiny app object.
#'
#' @import shiny
#' @importFrom shinyjs useShinyjs
#' @importFrom readxl read_excel
#'
#' @seealso [VizModules::radarPlot()], [VizModules::radarPlotInputsUI()],
#' [VizModules::radarPlotOutputUI()], [VizModules::radarPlotServer()]
#'
#' @export
#' @author Jacob Martin
#' @examples
#' library(VizModules)
#' # Launch with default example data:
#' app <- radarPlotApp()
#' if (interactive()) runApp(app)
#'
#' # Launch with custom data:
#' skills <- data.frame(
#'     category = c("Speed", "Strength", "Defense", "Stamina", "Speed"),
#'     value = c(8, 6, 7, 9, 8)
#' )
#' app2 <- radarPlotApp(list("skills" = skills))
#' if (interactive()) runApp(app2)
radarPlotApp <- function(data_list = NULL) {
    # Use default example data when none is provided
    if (is.null(data_list)) {
        skills <- data.frame(
            category = c("Speed", "Strength", "Defense", "Stamina", "Speed"),
            value = c(8, 6, 7, 9, 8)
        )
        team_stats <- data.frame(
            category = rep(c("Speed", "Strength", "Defense", "Stamina", "Speed"), 2),
            value = c(8, 6, 7, 9, 8, 5, 9, 8, 6, 5),
            player = rep(c("Player A", "Player B"), each = 5)
        )
        data_list <- list("skills" = skills, "team" = team_stats)
    }

    # Validate input
    stopifnot(is.list(data_list))
    lapply(data_list, function(data) {
        stopifnot(is.data.frame(data))
    })

    ui <- fluidPage(
        title = "Modular radarPlots",
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
                radarPlotOutputUI("active_plot"),
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
            radarPlotInputsUI("active_plot", rv$datasets[[input$plot_select]],
                title = h3(paste(input$plot_select, "Settings"))
            )
        })

        # ---- Plot Module ----
        radarPlotServer("active_plot", data = filtered_data)
    }
    shinyApp(ui, server)
}
