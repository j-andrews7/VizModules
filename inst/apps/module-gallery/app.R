library(VizModules)

# Derived summary dataset (pie plot)
sales_by_product <- aggregate(revenue ~ product_line, example_sales, sum)


module_data <- list(
    area     = example_sales,
    bar      = example_bar,
    box      = example_demographics,
    density  = example_demographics,
    dumbbell = example_school_earnings,
    histogram = example_demographics,
    line     = example_sales,
    parallel = example_sales,
    pie      = sales_by_product,
    radar    = example_skills,
    scatter  = example_sales,
    splitbar = example_bar,
    ternary  = example_roles,
    violin   = example_demographics,
    yplot    = example_demographics
)

# Module registry – each entry defines one plot module for the gallery.
module_registry <- list(
    list(
        label     = "Area Plot",
        id        = "area",
        inputs_ui = plotthis_AreaPlotInputsUI,
        output_ui = plotthis_AreaPlotOutputUI,
        server_fn = plotthis_AreaPlotServer,
        defaults  = list("x.data" = "year", "y.data" = "revenue",
                         "group.by" = "product_line")
    ),
    list(
        label     = "Bar Plot",
        id        = "bar",
        inputs_ui = plotthis_BarPlotInputsUI,
        output_ui = plotthis_BarPlotOutputUI,
        server_fn = plotthis_BarPlotServer,
        defaults  = list("x.data" = "Group", "y.data" = "Values",
                         "group.by" = "Type")
    ),
    list(
        label     = "Box Plot",
        id        = "box",
        inputs_ui = plotthis_BoxPlotInputsUI,
        output_ui = plotthis_BoxPlotOutputUI,
        server_fn = plotthis_BoxPlotServer,
        defaults  = list("x.data" = "department", "y.data" = "salary")
    ),
    list(
        label     = "Density Plot",
        id        = "density",
        inputs_ui = plotthis_DensityPlotInputsUI,
        output_ui = plotthis_DensityPlotOutputUI,
        server_fn = plotthis_DensityPlotServer,
        defaults  = list("x.data" = "salary", "group.by" = "department")
    ),
    list(
        label     = "Dumbbell Plot",
        id        = "dumbbell",
        inputs_ui = dumbbellPlotInputsUI,
        output_ui = dumbbellPlotOutputUI,
        server_fn = dumbbellPlotServer,
        defaults  = list()
    ),
    list(
        label     = "Histogram",
        id        = "histogram",
        inputs_ui = plotthis_HistogramInputsUI,
        output_ui = plotthis_HistogramOutputUI,
        server_fn = plotthis_HistogramServer,
        defaults  = list("x.data" = "salary")
    ),
    list(
        label     = "Line Plot",
        id        = "line",
        inputs_ui = linePlotInputsUI,
        output_ui = linePlotOutputUI,
        server_fn = linePlotServer,
        defaults  = list("x.value" = "product_line", "y.value" = "units")
    ),
    list(
        label     = "Parallel Coordinates",
        id        = "parallel",
        inputs_ui = parallelCoordinatesPlotInputsUI,
        output_ui = parallelCoordinatesPlotOutputUI,
        server_fn = parallelCoordinatesPlotServer,
        defaults  = list("color.by" = "product_line")
    ),
    list(
        label     = "Pie Plot",
        id        = "pie",
        inputs_ui = piePlotInputsUI,
        output_ui = piePlotOutputUI,
        server_fn = piePlotServer,
        defaults  = list("labels" = "product_line", "values" = "revenue")
    ),
    list(
        label     = "Radar Plot",
        id        = "radar",
        inputs_ui = radarPlotInputsUI,
        output_ui = radarPlotOutputUI,
        server_fn = radarPlotServer,
        defaults  = list("theta" = "category", "r" = "value",
                         "group" = "player")
    ),
    list(
        label     = "Scatter Plot",
        id        = "scatter",
        inputs_ui = dittoViz_scatterPlotInputsUI,
        output_ui = dittoViz_scatterPlotOutputUI,
        server_fn = dittoViz_scatterPlotServer,
        defaults  = list("x.by" = "revenue", "y.by" = "units",
                         "color.by" = "product_line")
    ),
    list(
        label     = "Split Bar Plot",
        id        = "splitbar",
        inputs_ui = plotthis_SplitBarPlotInputsUI,
        output_ui = plotthis_SplitBarPlotOutputUI,
        server_fn = plotthis_SplitBarPlotServer,
        defaults  = list("x.data" = "Score", "y.data" = "Group")
    ),
    list(
        label     = "Ternary Plot",
        id        = "ternary",
        inputs_ui = ternaryPlotInputsUI,
        output_ui = ternaryPlotOutputUI,
        server_fn = ternaryPlotServer,
        defaults  = list("a" = "journalist", "b" = "developer",
                         "c" = "designer", "group" = "team")
    ),
    list(
        label     = "Violin Plot",
        id        = "violin",
        inputs_ui = plotthis_ViolinPlotInputsUI,
        output_ui = plotthis_ViolinPlotOutputUI,
        server_fn = plotthis_ViolinPlotServer,
        defaults  = list("x.data" = "department", "y.data" = "salary")
    ),
    list(
        label     = "yPlot",
        id        = "yplot",
        inputs_ui = dittoViz_yPlotInputsUI,
        output_ui = dittoViz_yPlotOutputUI,
        server_fn = dittoViz_yPlotServer,
        defaults  = list("var" = "salary", "group.by" = "department")
    )
)


# Helper: build a tab panel for one module
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


server <- function(input, output, session) {

    lapply(module_registry, function(m) {
        # Fixed dataset for this module (wrapped in reactive for dataFilterServer)
        active_data <- reactive(module_data[[m$id]])

        # Data filter feeds the plot module
        filtered_data <- dataFilterServer(
            paste0(m$id, "_filter"),
            active_data
        )

        # Inputs UI rendered once on load with pre-selected data columns.
        # Only data-column defaults are passed; all other inputs use their
        # built-in defaults.
        output[[paste0(m$id, "_inputs_ui")]] <- renderUI({
            m$inputs_ui(
                m$id,
                active_data(),
                defaults = m$defaults,
                title    = h3(paste(m$label, "Settings"))
            )
        })

        m$server_fn(m$id, data = filtered_data)
    })
}

shinyApp(ui, server)
