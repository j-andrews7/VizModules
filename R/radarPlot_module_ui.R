#' Input UI components for the radarPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `radarPlotServer()` and `radarPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Provide data with columns for categories (theta) and values (r). For multiple traces,
#' include a grouping column.
#' Nearly all parameters for [VizModules::radarPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' @section Plot parameters and defaults:
#' The following [VizModules::radarPlot()] parameters can be accessed via UI inputs
#' and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{theta} - Category column for angular axes
#'     (UI: "Category column (theta)", default: 1st categorical column)
#'   \item \code{r} - Values column for radial distance (UI: "Values column (r)", default: 1st numeric column)
#'   \item \code{group} - Optional grouping column for multiple traces (UI: "Group column", default: NULL)
#'   \item \code{fill} - Fill area under trace (UI: "Fill area", default: "toself")
#'   \item \code{line.width} - Line width (UI: "Line width", default: 2)
#'   \item \code{line.dash} - Line dash style (UI: "Line style", default: "solid")
#'   \item \code{marker.size} - Marker size (UI: "Marker size", default: 5)
#'   \item \code{marker.symbol} - Marker symbol (UI: "Marker symbol", default: "circle")
#'   \item \code{opacity} - Trace opacity (UI: "Opacity", default: 0.6)
#'   \item \code{colors} - Trace colors (UI: color picker, derived from palette)
#'   \item \code{radial.visible} - Show radial axis (UI: "Show radial axis", default: TRUE)
#'   \item \code{radial.range} - Radial axis range (UI: "Radial min" and "Radial max", default: auto)
#'   \item \code{radial.showline} - Show radial axis line (UI: "Show radial line", default: TRUE)
#'   \item \code{radial.linecolor} - Radial axis line color (UI: "Radial line color", default: "#444444")
#'   \item \code{radial.gridcolor} - Radial grid color (UI: "Radial grid color", default: "#EEEEEE")
#'   \item \code{angular.direction} - Angular axis direction (UI: "Angular direction", default: "clockwise")
#'   \item \code{angular.rotation} - Angular axis rotation (UI: "Angular rotation", default: 90)
#'   \item \code{angular.gridcolor} - Angular grid color (UI: "Angular grid color", default: "#EEEEEE")
#'   \item \code{title.x} - Title horizontal position (UI: "Title horizontal position", default: 0.5)
#'   \item \code{title.font.size} - Title font size (UI: "Title font size", default: 18)
#'   \item \code{title.font.family} - Title font (UI: "Title font", default: "Arial")
#'   \item \code{title.font.color} - Title font color (UI: "Title font color", default: "#000000")
#'   \item \code{show.legend} - Show legend (UI: "Show legend", default: TRUE)
#'   \item \code{legend.orientation} - Legend orientation (UI: "Legend orientation", default: "h")
#'   \item \code{legend.font.family} - Legend font (UI: "Legend font", default: "Arial")
#'   \item \code{legend.font.size} - Legend font size (UI: "Legend font size", default: 12)
#'   \item \code{legend.font.color} - Legend font color (UI: "Legend font color", default: "#000000")
#'   \item \code{bgcolor} - Plot background color (UI: "Plot background color", default: "#FFFFFF")
#'   \item \code{polar.bgcolor} - Polar area background color (UI: "Polar area background", default: "#FFFFFF")
#' }
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @import shiny
#' @importFrom colourpicker colourInput
#' @importFrom shinyWidgets materialSwitch
#' @importFrom shinyBS tipify
#'
#' @export
#' @author Jacob Martin
#' @seealso [VizModules::radarPlot()], [VizModules::organize_inputs()],
#' [VizModules::radarPlotOutputUI()], [VizModules::radarPlotServer()], [VizModules::radarPlotApp()]
#' @examples
#' library(VizModules)
#' skills <- data.frame(
#'     category = c("Speed", "Strength", "Defense", "Stamina", "Speed"),
#'     value = c(8, 6, 7, 9, 8)
#' )
#' radarPlotInputsUI("radarPlot", skills)
radarPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variable choices
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    cat.choices <- c("", names(data)[!vapply(data, is.numeric, logical(1))])
    all.choices <- c("", names(data))

    font.choices <- c(
        "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono", "Gravitas One",
        "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman", "Verdana",
        "sans-serif", "serif", "monospace"
    )

    selected <- list("theta", "r", "group", "fill", "line.width", "line.dash",
        "marker.size", "marker.symbol", "opacity", "radial.visible",
        "radial.range", "radial.showline", "radial.linecolor", "radial.gridcolor",
        "angular.direction", "angular.rotation", "angular.gridcolor",
        "title.x", "title.font.size", "title.font.family", "title.font.color",
        "show.legend", "legend.orientation", "legend.font.family",
        "legend.font.size", "legend.font.color", "bgcolor", "polar.bgcolor")

    documentParameters <- get_documentation(
        package_name = "VizModules::radarPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("theta"), "Category column (theta):",
                selected = cat.choices[2],
                choices = all.choices
            ), documentParameters$theta, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("r"), "Values column (r):",
                selected = num.choices[2],
                choices = num.choices
            ), documentParameters$r, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("group"), "Group column (optional):",
                selected = .get_default(defaults, "group", ""),
                choices = all.choices
            ), documentParameters$group, placement = "top", options = list(container = "body"))
        ),
        "Trace Style" = tagList(
            tipify(selectInput(ns("fill"), "Fill area:",
                choices = c(
                    "Fill" = "toself",
                    "No fill" = "none"
                ),
                selected = .get_default(defaults, "fill", "toself")
            ), documentParameters$fill, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("line.width"), "Line width:",
                value = .get_default(defaults, "line.width", 2, is.numeric),
                min = 0,
                step = 0.5
            ), documentParameters$line.width, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("line.dash"), "Line style:",
                choices = c(
                    "Solid" = "solid",
                    "Dot" = "dot",
                    "Dash" = "dash",
                    "Long dash" = "longdash",
                    "Dash-dot" = "dashdot",
                    "Long dash-dot" = "longdashdot"
                ),
                selected = .get_default(defaults, "line.dash", "solid")
            ), documentParameters$line.dash, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("marker.size"), "Marker size:",
                value = .get_default(defaults, "marker.size", 5, is.numeric),
                min = 0,
                step = 1
            ), documentParameters$marker.size, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("marker.symbol"), "Marker symbol:",
                choices = c(
                    "Circle" = "circle",
                    "Square" = "square",
                    "Diamond" = "diamond",
                    "Cross" = "cross",
                    "X" = "x",
                    "Triangle up" = "triangle-up",
                    "Triangle down" = "triangle-down"
                ),
                selected = .get_default(defaults, "marker.symbol", "circle")
            ), documentParameters$marker.symbol, placement = "top", options = list(container = "body")),
            tipify(sliderInput(ns("opacity"), "Opacity:",
                min = 0, max = 1,
                value = .get_default(defaults, "opacity", 0.6),
                step = 0.05
            ), documentParameters$opacity, placement = "top", options = list(container = "body")),
            uiOutput(ns("color.picker"))
        ),
        "Radial Axis" = tagList(
            tipify(checkboxInput(ns("radial.visible"), "Show radial axis",
                value = .get_default(defaults, "radial.visible", TRUE, is.logical)
            ), documentParameters$radial.visible, placement = "top", options = list(container = "body")),
            checkboxInput(ns("auto.radial.range"), "Auto radial range",
                value = .get_default(defaults, "auto.radial.range", TRUE, is.logical)
            ),
            tipify(numericInput(ns("radial.min"), "Radial min:",
                value = .get_default(defaults, "radial.min", 0, is.numeric)
            ), documentParameters$radial.range, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("radial.max"), "Radial max:",
                value = .get_default(defaults, "radial.max", 100, is.numeric),
                min = 0
            ), documentParameters$radial.range, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("radial.showline"), "Show radial line",
                value = .get_default(defaults, "radial.showline", TRUE, is.logical)
            ), documentParameters$radial.showline, placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("radial.linecolor"), "Radial line color:",
                value = .get_default(defaults, "radial.linecolor", "#444444")
            ), documentParameters$radial.linecolor, placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("radial.gridcolor"), "Radial grid color:",
                value = .get_default(defaults, "radial.gridcolor", "#EEEEEE")
            ), documentParameters$radial.gridcolor, placement = "top", options = list(container = "body"))
        ),
        "Angular Axis" = tagList(
            tipify(selectInput(ns("angular.direction"), "Angular direction:",
                choices = c("Clockwise" = "clockwise", "Counterclockwise" = "counterclockwise"),
                selected = .get_default(defaults, "angular.direction", "clockwise")
            ), documentParameters$angular.direction, placement = "top", options = list(container = "body")),
            tipify(sliderInput(ns("angular.rotation"), "Angular rotation (degrees):",
                min = 0, max = 360,
                value = .get_default(defaults, "angular.rotation", 90),
                step = 5
            ), documentParameters$angular.rotation, placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("angular.gridcolor"), "Angular grid color:",
                value = .get_default(defaults, "angular.gridcolor", "#EEEEEE")
            ), documentParameters$angular.gridcolor, placement = "top", options = list(container = "body"))
        ),
        "Title & Legend" = tagList(
            tipify(sliderInput(ns("title.x"), "Title horizontal position:",
                min = 0, max = 1,
                value = .get_default(defaults, "title.x", 0.5),
                step = 0.01
            ), documentParameters$title.x, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("title.font.size"), "Title font size:",
                value = .get_default(defaults, "title.font.size", 18, is.numeric),
                min = 0
            ), documentParameters$title.font.size, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("title.font.family"), "Title font:",
                choices = font.choices,
                selected = .get_default(defaults, "title.font.family", "Arial",
                    function(x) x %in% font.choices)
            ), documentParameters$title.font.family, placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("title.font.color"), "Title font color:",
                value = .get_default(defaults, "title.font.color", "#000000")
            ), documentParameters$title.font.color, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("show.legend"), "Show legend",
                value = .get_default(defaults, "show.legend", TRUE, is.logical)
            ), documentParameters$show.legend, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("legend.orientation"), "Legend orientation:",
                choices = c("Horizontal" = "h", "Vertical" = "v"),
                selected = .get_default(defaults, "legend.orientation", "h")
            ), documentParameters$legend.orientation, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("legend.font.family"), "Legend font:",
                choices = font.choices,
                selected = .get_default(defaults, "legend.font.family", "Arial",
                    function(x) x %in% font.choices)
            ), documentParameters$legend.font.family, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("legend.font.size"), "Legend font size:",
                value = .get_default(defaults, "legend.font.size", 12, is.numeric),
                min = 1,
                step = 1
            ), documentParameters$legend.font.size, placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("legend.font.color"), "Legend font color:",
                value = .get_default(defaults, "legend.font.color", "#000000")
            ), documentParameters$legend.font.color, placement = "top", options = list(container = "body"))
        ),
        "Background" = tagList(
            tipify(colourpicker::colourInput(ns("bgcolor"), "Plot background color:",
                value = .get_default(defaults, "bgcolor", "#FFFFFF")
            ), documentParameters$bgcolor, placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("polar.bgcolor"), "Polar area background:",
                value = .get_default(defaults, "polar.bgcolor", "#FFFFFF")
            ), documentParameters$polar.bgcolor, placement = "top", options = list(container = "body"))
        )
    )

    organize_inputs(
        inputs,
        id = ns("radarPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the radarPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the radarPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
radarPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("radarPlot"))
    )
}
