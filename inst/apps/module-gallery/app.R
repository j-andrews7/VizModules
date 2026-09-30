library(VizModules)
library(InteractiveComplexHeatmap)

# The gallery's app logic lives in VizModules::moduleGalleryApp() so it can be
# launched directly with moduleGalleryApp(). This file stays as a thin wrapper
# so the gallery can still be deployed (e.g. to shinyapps.io or Posit Connect),
# which needs an app.R ending in a shinyApp() call.
parts <- moduleGalleryApp(return_components = TRUE)
shinyApp(parts$ui, parts$server)
