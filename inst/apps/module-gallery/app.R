library(shiny)
library(shinyjs)
library(VizModules)

mtcars <- transform(mtcars,
    cyl = factor(cyl),
    gear = factor(gear),
    vs = factor(vs)
)

iris$Group <- c(rep(c("A", "B"), 50), rep(c("C", "D"), 25))

iris_summary <- {
    iris_summary <- as.data.frame(table(iris$Species))
    names(iris_summary) <- c("Species", "Count")
    iris_summary
}

# ---------------------------------------------------------------------------
# Module registry – each entry defines one plot module for the gallery
# ---------------------------------------------------------------------------
module_registry <- list(
    list(
        label      = "Area Plot",
        id         = "area",
        inputs_ui  = plotthis_AreaPlotInputsUI,
        output_ui  = plotthis_AreaPlotOutputUI,
        server_fn  = plotthis_AreaPlotServer
    ),
    list(
        label      = "Bar Plot",
        id         = "bar",
        inputs_ui  = plotthis_BarPlotInputsUI,
        output_ui  = plotthis_BarPlotOutputUI,
        server_fn  = plotthis_BarPlotServer
    ),
    list(
        label      = "Box Plot",
        id         = "box",
        inputs_ui  = plotthis_BoxPlotInputsUI,
        output_ui  = plotthis_BoxPlotOutputUI,
        server_fn  = plotthis_BoxPlotServer
    ),
    list(
        label      = "Density Plot",
        id         = "density",
        inputs_ui  = plotthis_DensityPlotInputsUI,
        output_ui  = plotthis_DensityPlotOutputUI,
        server_fn  = plotthis_DensityPlotServer
    ),
    list(
        label      = "Dumbbell Plot",
        id         = "dumbbell",
        inputs_ui  = dumbbellPlotInputsUI,
        output_ui  = dumbbellPlotOutputUI,
        server_fn  = dumbbellPlotServer
    ),
    list(
        label      = "Histogram",
        id         = "histogram",
        inputs_ui  = plotthis_HistogramInputsUI,
        output_ui  = plotthis_HistogramOutputUI,
        server_fn  = plotthis_HistogramServer
    ),
    list(
        label      = "Line Plot",
        id         = "line",
        inputs_ui  = linePlotInputsUI,
        output_ui  = linePlotOutputUI,
        server_fn  = linePlotServer
    ),
    list(
        label      = "Parallel Coordinates",
        id         = "parallel",
        inputs_ui  = parallelCoordinatesPlotInputsUI,
        output_ui  = parallelCoordinatesPlotOutputUI,
        server_fn  = parallelCoordinatesPlotServer
    ),
    list(
        label      = "Pie Plot",
        id         = "pie",
        inputs_ui  = piePlotInputsUI,
        output_ui  = piePlotOutputUI,
        server_fn  = piePlotServer
    ),
    list(
        label      = "Radar Plot",
        id         = "radar",
        inputs_ui  = radarPlotInputsUI,
        output_ui  = radarPlotOutputUI,
        server_fn  = radarPlotServer
    ),
    list(
        label      = "Scatter Plot",
        id         = "scatter",
        inputs_ui  = dittoViz_scatterPlotInputsUI,
        output_ui  = dittoViz_scatterPlotOutputUI,
        server_fn  = dittoViz_scatterPlotServer
    ),
    list(
        label      = "Split Bar Plot",
        id         = "splitbar",
        inputs_ui  = plotthis_SplitBarPlotInputsUI,
        output_ui  = plotthis_SplitBarPlotOutputUI,
        server_fn  = plotthis_SplitBarPlotServer
    ),
    list(
        label      = "Ternary Plot",
        id         = "ternary",
        inputs_ui  = ternaryPlotInputsUI,
        output_ui  = ternaryPlotOutputUI,
        server_fn  = ternaryPlotServer
    ),
    list(
        label      = "Violin Plot",
        id         = "violin",
        inputs_ui  = plotthis_ViolinPlotInputsUI,
        output_ui  = plotthis_ViolinPlotOutputUI,
        server_fn  = plotthis_ViolinPlotServer
    ),
    list(
        label      = "yPlot",
        id         = "yplot",
        inputs_ui  = dittoViz_yPlotInputsUI,
        output_ui  = dittoViz_yPlotOutputUI,
        server_fn  = dittoViz_yPlotServer
    )
)

default_datasets <- list(
    "sales"      = example_sales,
    "population" = example_population,
    "iris"               = iris,
    "mtcars"             = mtcars
)

# ---------------------------------------------------------------------------
# Helper: build a tab panel for one module
# ---------------------------------------------------------------------------
build_tab <- function(mod) {
    tabPanel(
        mod$label,
        value = mod$id,
        sidebarLayout(
            sidebarPanel(
                width = 4,
                uiOutput(paste0(mod$id, "_inputs_ui"))
            ),
            mainPanel(
                width = 8,
                mod$output_ui(mod$id),
                hr(),
                h4("Data Table"),
                p("Filtering the data table will update the plot.",
                    style = "color: grey; font-size: 12px;"),
                dataFilterUI(paste0(mod$id, "_filter"))
            )
        )
    )
}

# ---------------------------------------------------------------------------
# UI
# ---------------------------------------------------------------------------
gallery_header <- tagList(
    useShinyjs(),
    tags$head(
        tags$style(HTML("
            .data-toolbar {
                background: #f8f9fa;
                border-bottom: 1px solid #dee2e6;
                padding: 8px 15px;
                display: flex;
                align-items: center;
                gap: 12px;
                flex-wrap: wrap;
            }
            .data-toolbar .form-group { margin-bottom: 0; }
            .data-toolbar .selectize-control { min-width: 180px; }
            .data-toolbar .btn-sm { padding: 4px 10px; font-size: 13px; }
            .data-toolbar .data-info {
                color: #6c757d; font-size: 13px; white-space: nowrap;
            }
            #upload_panel {
                background: #f8f9fa;
                border-bottom: 1px solid #dee2e6;
                padding: 8px 15px;
                display: flex;
                align-items: center;
                gap: 12px;
            }
            #upload_panel .form-group { margin-bottom: 0; }
            .navbar { margin-bottom: 0; }
        "))
    ),
    div(class = "data-toolbar",
        tags$strong("Dataset:"),
        selectInput("dataset_select", NULL,
            choices = names(default_datasets),
            width = "200px"
        ),
        span(class = "data-info", textOutput("data_info", inline = TRUE)),
        actionButton("toggle_upload", "Upload...",
            class = "btn-default btn-sm",
            icon = icon("upload")
        )
    ),
    shinyjs::hidden(
        div(id = "upload_panel",
            fileInput("file_upload", NULL,
                accept = c(".xlsx", ".xls", ".csv", ".tsv", ".txt"),
                placeholder = "Choose file...",
                width = "300px"
            ),
            actionButton("load_data", "Load Data",
                class = "btn-primary btn-sm"
            )
        )
    )
)

ui <- do.call(navbarPage, c(
    list(
        title    = "VizModules Gallery",
        id       = "active_tab",
        position = "static-top",
        header   = gallery_header
    ),
    lapply(module_registry, build_tab)
))

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
server <- function(input, output, session) {

    rv <- reactiveValues(datasets = default_datasets)

    observeEvent(input$toggle_upload, {
        shinyjs::toggle("upload_panel", anim = TRUE, animType = "slide",
            time = 0.2)
    })

    observeEvent(input$load_data, {
        req(input$file_upload)
        tryCatch({
            filepath <- input$file_upload$datapath
            ext <- tolower(tools::file_ext(input$file_upload$name))
            new_data <- switch(ext,
                xlsx = as.data.frame(readxl::read_excel(filepath)),
                xls  = as.data.frame(readxl::read_excel(filepath)),
                csv  = read.csv(filepath, stringsAsFactors = TRUE),
                tsv  = read.delim(filepath, stringsAsFactors = TRUE),
                txt  = read.delim(filepath, stringsAsFactors = TRUE),
                stop("Unsupported file type: .", ext)
            )
            new_data <- as.data.frame(new_data)
            name <- tools::file_path_sans_ext(input$file_upload$name)
            rv$datasets[[name]] <- new_data
            showNotification(
                paste0("Loaded '", name, "' (", nrow(new_data),
                    " rows, ", ncol(new_data), " cols)"),
                type = "message"
            )
        }, error = function(e) {
            showNotification(
                paste("Could not read the uploaded file.",
                    "Supported formats: .xlsx, .xls, .csv, .tsv,",
                    ".txt (tab-delimited)."),
                type = "error"
            )
        })
    })

    # -- Keep dataset selector in sync --------------------------------------
    observe({
        updateSelectInput(session, "dataset_select",
            choices = names(rv$datasets)
        )
    })

    output$data_info <- renderText({
        req(input$dataset_select, rv$datasets[[input$dataset_select]])
        d <- rv$datasets[[input$dataset_select]]
        paste0(nrow(d), " rows \u00d7 ", ncol(d), " cols")
    })

    active_data <- reactive({
        req(input$dataset_select)
        rv$datasets[[input$dataset_select]]
    })

    # -- Wire up each module ------------------------------------------------
    # lapply gives each module its own function scope, avoiding the
    # closure-over-loop-variable pitfall that a `for` loop would cause.
    lapply(module_registry, function(m) {
        # Data filter for this module
        filtered_data <- dataFilterServer(
            paste0(m$id, "_filter"),
            active_data
        )

        # Dynamic inputs UI – re-renders when dataset changes
        output[[paste0(m$id, "_inputs_ui")]] <- renderUI({
            req(active_data())
            m$inputs_ui(m$id, active_data(),
                title = h3(paste(m$label, "Settings"))
            )
        })

        # Module server – receives filtered reactive data
        m$server_fn(m$id, data = filtered_data)
    })
}

shinyApp(ui, server)
