library(VizModules)

# The Figure Builder app logic lives in VizModules::figureBuilderApp() so it can
# be launched as a function and reused with custom datasets/modules. We request
# the UI and server components here and hand them to shinyApp() so deployment
# tooling (e.g. Posit Connect) still sees an explicit shinyApp() call.
parts <- figureBuilderApp(return.components = TRUE)
shinyApp(parts$ui, parts$server)
