.onLoad <- function(libname, pkgname) {
    # Register shinyBS resource path so that tipify() tooltips work.
    # shinyBS registers its "sbs" resource path in .onAttach(), but since
    # VizModules only imports (not attaches) shinyBS, .onAttach() never fires.
    shiny::addResourcePath("sbs", system.file("www", package = "shinyBS"))
}
