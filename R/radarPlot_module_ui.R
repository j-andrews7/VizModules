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
#' The following [VizModules::radarPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{theta} - Category column for angular axes (UI: "Category column (theta)", default: 1st categorical column)
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
#'
#' @export
#' @author Jared Andrews
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

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("theta"), "Category column (theta):",
                selected = cat.choices[2],
                choices = all.choices
            ),
            selectInput(ns("r"), "Values column (r):",
                selected = num.choices[2],
                choices = num.choices
            ),
            selectInput(ns("group"), "Group column (optional):",
                selected = ifelse("group" %in% names(defaults),
                    defaults[["group"]],
                    ""
                ),
                choices = all.choices
            )
        ),
        "Trace Style" = tagList(
            selectInput(ns("fill"), "Fill area:",
                choices = c(
                    "Fill to self" = "toself",
                    "Fill to next trace" = "tonext",
                    "No fill" = "none"
                ),
                selected = ifelse("fill" %in% names(defaults),
                    defaults[["fill"]],
                    "toself"
                )
            ),
            numericInput(ns("line.width"), "Line width:",
                value = ifelse("line.width" %in% names(defaults),
                    ifelse(is.numeric(defaults[["line.width"]]), defaults[["line.width"]], 2),
                    2
                ),
                min = 0,
                step = 0.5
            ),
            selectInput(ns("line.dash"), "Line style:",
                choices = c(
                    "Solid" = "solid",
                    "Dot" = "dot",
                    "Dash" = "dash",
                    "Long dash" = "longdash",
                    "Dash-dot" = "dashdot",
                    "Long dash-dot" = "longdashdot"
                ),
                selected = ifelse("line.dash" %in% names(defaults),
                    defaults[["line.dash"]],
                    "solid"
                )
            ),
            numericInput(ns("marker.size"), "Marker size:",
                value = ifelse("marker.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["marker.size"]]), defaults[["marker.size"]], 5),
                    5
                ),
                min = 0,
                step = 1
            ),
            selectInput(ns("marker.symbol"), "Marker symbol:",
                choices = c(
                    "Circle" = "circle",
                    "Square" = "square",
                    "Diamond" = "diamond",
                    "Cross" = "cross",
                    "X" = "x",
                    "Triangle up" = "triangle-up",
                    "Triangle down" = "triangle-down"
                ),
                selected = ifelse("marker.symbol" %in% names(defaults),
                    defaults[["marker.symbol"]],
                    "circle"
                )
            ),
            sliderInput(ns("opacity"), "Opacity:",
                min = 0, max = 1,
                value = ifelse("opacity" %in% names(defaults),
                    defaults[["opacity"]],
                    0.6
                ),
                step = 0.05
            ),
            uiOutput(ns("color.picker"))
        ),
        "Radial Axis" = tagList(
            checkboxInput(ns("radial.visible"), "Show radial axis",
                value = ifelse("radial.visible" %in% names(defaults),
                    isTRUE(defaults[["radial.visible"]]),
                    TRUE
                )
            ),
            checkboxInput(ns("auto.radial.range"), "Auto radial range",
                value = ifelse("auto.radial.range" %in% names(defaults),
                    isTRUE(defaults[["auto.radial.range"]]),
                    TRUE
                )
            ),
            numericInput(ns("radial.min"), "Radial min:",
                value = ifelse("radial.min" %in% names(defaults),
                    ifelse(is.numeric(defaults[["radial.min"]]), defaults[["radial.min"]], 0),
                    0
                )
            ),
            numericInput(ns("radial.max"), "Radial max:",
                value = ifelse("radial.max" %in% names(defaults),
                    ifelse(is.numeric(defaults[["radial.max"]]), defaults[["radial.max"]], 100),
                    100
                ),
                min = 0
            ),
            checkboxInput(ns("radial.showline"), "Show radial line",
                value = ifelse("radial.showline" %in% names(defaults),
                    isTRUE(defaults[["radial.showline"]]),
                    TRUE
                )
            ),
            colourpicker::colourInput(ns("radial.linecolor"), "Radial line color:",
                value = ifelse("radial.linecolor" %in% names(defaults),
                    defaults[["radial.linecolor"]],
                    "#444444"
                )
            ),
            colourpicker::colourInput(ns("radial.gridcolor"), "Radial grid color:",
                value = ifelse("radial.gridcolor" %in% names(defaults),
                    defaults[["radial.gridcolor"]],
                    "#EEEEEE"
                )
            )
        ),
        "Angular Axis" = tagList(
            selectInput(ns("angular.direction"), "Angular direction:",
                choices = c("Clockwise" = "clockwise", "Counterclockwise" = "counterclockwise"),
                selected = ifelse("angular.direction" %in% names(defaults),
                    defaults[["angular.direction"]],
                    "clockwise"
                )
            ),
            sliderInput(ns("angular.rotation"), "Angular rotation (degrees):",
                min = 0, max = 360,
                value = ifelse("angular.rotation" %in% names(defaults),
                    defaults[["angular.rotation"]],
                    90
                ),
                step = 5
            ),
            colourpicker::colourInput(ns("angular.gridcolor"), "Angular grid color:",
                value = ifelse("angular.gridcolor" %in% names(defaults),
                    defaults[["angular.gridcolor"]],
                    "#EEEEEE"
                )
            )
        ),
        "Title & Legend" = tagList(
            sliderInput(ns("title.x"), "Title horizontal position:",
                min = 0, max = 1,
                value = ifelse("title.x" %in% names(defaults),
                    defaults[["title.x"]],
                    0.5
                ),
                step = 0.01
            ),
            numericInput(ns("title.font.size"), "Title font size:",
                value = ifelse("title.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["title.font.size"]]), defaults[["title.font.size"]], 18),
                    18
                ),
                min = 0
            ),
            selectInput(ns("title.font.family"), "Title font:",
                choices = font.choices,
                selected = ifelse("title.font.family" %in% names(defaults) && defaults[["title.font.family"]] %in% font.choices,
                    defaults[["title.font.family"]],
                    "Arial"
                )
            ),
            colourpicker::colourInput(ns("title.font.color"), "Title font color:",
                value = ifelse("title.font.color" %in% names(defaults),
                    defaults[["title.font.color"]],
                    "#000000"
                )
            ),
            checkboxInput(ns("show.legend"), "Show legend",
                value = ifelse("show.legend" %in% names(defaults),
                    isTRUE(defaults[["show.legend"]]),
                    TRUE
                )
            ),
            selectInput(ns("legend.orientation"), "Legend orientation:",
                choices = c("Horizontal" = "h", "Vertical" = "v"),
                selected = ifelse("legend.orientation" %in% names(defaults),
                    defaults[["legend.orientation"]],
                    "h"
                )
            ),
            selectInput(ns("legend.font.family"), "Legend font:",
                choices = font.choices,
                selected = ifelse("legend.font.family" %in% names(defaults) && defaults[["legend.font.family"]] %in% font.choices,
                    defaults[["legend.font.family"]],
                    "Arial"
                )
            ),
            numericInput(ns("legend.font.size"), "Legend font size:",
                value = ifelse("legend.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["legend.font.size"]]), defaults[["legend.font.size"]], 12),
                    12
                ),
                min = 1,
                step = 1
            ),
            colourpicker::colourInput(ns("legend.font.color"), "Legend font color:",
                value = ifelse("legend.font.color" %in% names(defaults),
                    defaults[["legend.font.color"]],
                    "#000000"
                )
            )
        ),
        "Background" = tagList(
            colourpicker::colourInput(ns("bgcolor"), "Plot background color:",
                value = ifelse("bgcolor" %in% names(defaults),
                    defaults[["bgcolor"]],
                    "#FFFFFF"
                )
            ),
            colourpicker::colourInput(ns("polar.bgcolor"), "Polar area background:",
                value = ifelse("polar.bgcolor" %in% names(defaults),
                    defaults[["polar.bgcolor"]],
                    "#FFFFFF"
                )
            )
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
