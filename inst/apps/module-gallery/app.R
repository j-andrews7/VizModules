library(shiny)
library(VizModules)

# ---------------------------------------------------------------------------
# Prepare example datasets
# ---------------------------------------------------------------------------
mtcars_f <- transform(mtcars,
    cyl = factor(cyl),
    gear = factor(gear),
    vs = factor(vs)
)

iris_g <- iris
iris_g$Group <- c(rep(c("A", "B"), 50), rep(c("C", "D"), 25))

# Specialised datasets for modules that need specific structures
school_earnings <- data.frame(
    School = c("MIT", "Stanford", "Harvard", "Yale", "Princeton", "Columbia"),
    Women = c(94, 96, 112, 188, 91, 129),
    Men = c(52, 101, 165, 145, 148, 155),
    Group = c("STEM-heavy", "STEM-heavy", "Liberal Arts", "Liberal Arts",
              "Liberal Arts", "STEM-heavy")
)

skills <- data.frame(
    category = rep(c("Speed", "Strength", "Defense", "Stamina", "Agility"), 3),
    value = c(8, 6, 7, 9, 7, 5, 9, 8, 6, 4, 7, 7, 5, 8, 9),
    player = rep(c("Player A", "Player B", "Player C"), each = 5)
)

roles <- data.frame(
    journalist = c(75, 70, 75, 5, 10, 10, 20, 10, 15, 10, 20),
    developer = c(25, 10, 20, 60, 80, 90, 70, 20, 5, 10, 10),
    designer = c(0, 20, 5, 35, 10, 0, 10, 70, 80, 80, 70),
    label = paste("point", seq_len(11)),
    team = c(rep("Team A", 6), rep("Team B", 5))
)

sales_summary <- aggregate(revenue ~ region, example_sales, sum)
pop_summary <- aggregate(count ~ age_group, example_population, sum)

# ---------------------------------------------------------------------------
# Per-module data lists
# ---------------------------------------------------------------------------
standard_data <- list("sales" = example_sales, "population" = example_population)
iris_mtcars_data <- list("iris" = iris_g, "mtcars" = mtcars_f)

module_data <- list(
    area      = standard_data,
    bar       = standard_data,
    box       = standard_data,
    density   = standard_data,
    dumbbell  = list("school_earnings" = school_earnings, "iris" = iris_g,
                     "mtcars" = mtcars_f),
    histogram = standard_data,
    line      = list("sales" = example_sales, "iris" = iris_g),
    parallel  = list("mtcars" = mtcars_f, "iris" = iris_g),
    pie       = list("sales_by_region" = sales_summary,
                     "pop_by_age" = pop_summary),
    radar     = list("skills" = skills),
    scatter   = list("sales" = example_sales, "mtcars" = mtcars_f),
    splitbar  = standard_data,
    ternary   = list("roles" = roles),
    violin    = standard_data,
    yplot     = standard_data
)

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
                selectInput(
                    paste0(mod$id, "_dataset"), "Dataset",
                    choices = names(module_data[[mod$id]])
                ),
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
ui <- do.call(navbarPage, c(
    list(
        title    = "VizModules Gallery",
        id       = "active_tab",
        position = "static-top",
        header   = tags$head(tags$style(HTML(
            ".navbar { margin-bottom: 0; }"
        )))
    ),
    lapply(module_registry, build_tab)
))

# ---------------------------------------------------------------------------
# Server
# ---------------------------------------------------------------------------
server <- function(input, output, session) {

    # -- Wire up each module ------------------------------------------------
    lapply(module_registry, function(m) {
        # Reactive data based on per-module dataset selector
        active_data <- reactive({
            req(input[[paste0(m$id, "_dataset")]])
            module_data[[m$id]][[input[[paste0(m$id, "_dataset")]]]]
        })

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
