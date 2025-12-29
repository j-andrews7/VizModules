# Minimal example of wrapping scatterPlot module
# This file demonstrates how to build a module (minimalWrapper) on top of scatterPlot.

minimalWrapperUI <- function(id) {
    ns <- NS(id)
    tagList(
        h4("Minimal Wrapper Controls"),
        checkboxInput(ns("filter_setosa"), "Start with Setosa Only", value = FALSE),
        hr(),
        scatterPlotInputsUI(id, iris)
    )
}

minimalWrapperOutput <- function(id) {
    scatterPlotOutputUI(id)
}

minimalWrapperServer <- function(id, data_reactive) {
    # 1. Process data in a moduleServer block to access inputs namespaced to 'id'
    # We return the reactive expression produced by this block.
    # Note: moduleServer returns the return value of the function it runs.
    filtered_data <- moduleServer(id, function(input, output, session) {
        reactive({
            req(data_reactive())
            df <- data_reactive()

            # Custom logic for this module (in addition to scatterPlot): filter based on a checkbox
            if (isTRUE(input$filter_setosa)) {
                if ("Species" %in% names(df)) {
                    df <- df[df$Species == "setosa", ]
                }
            }
            df
        })
    })

    # 2. Call the base module server with the processed data.
    # We call this OUTSIDE the first moduleServer closure so that
    # scatterPlotServer attaches to 'id' relative to the parent,
    # avoiding nested namespace issues (e.g. id-id-input).
    scatterPlotServer(id, filtered_data)
}


# ui <- fluidPage(
#     titlePanel("Minimal Wrapper Example"),
#     sidebarLayout(
#         sidebarPanel(
#             # UI for the wrapper
#             minimalWrapperUI("demo")
#         ),
#         mainPanel(
#             minimalWrapperOutput("demo")
#         )
#     )
# )

# server <- function(input, output, session) {
#     # Data source
#     minimalWrapperServer("demo", reactive({
#         iris
#     }))
# }

# shinyApp(ui, server)
