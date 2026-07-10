library(VizModules)

# Demonstrates using the Figure Builder as a namespaced Shiny module (rather than
# via figureBuilderApp()). The module can be dropped into any page and even used
# more than once; here we embed a single instance under the "figure_builder" id.
ui <- fluidPage(
    figureBuilderUI("figure_builder")
)

server <- function(input, output, session) {
    figureBuilderServer("figure_builder")
}

shinyApp(ui, server)
