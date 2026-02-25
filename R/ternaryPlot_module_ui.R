#' Input UI components for the ternaryPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `ternaryPlotServer()` and `ternaryPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Provide data with numeric columns for the three ternary axes (a, b, c). For multiple traces,
#' include a grouping column.
#' Nearly all parameters for [VizModules::ternaryPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' @section Plot parameters and defaults:
#' The following [VizModules::ternaryPlot()] parameters can be accessed via UI inputs
#' and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{a} - Column for a-axis (top vertex)
#'     (UI: "A-axis column", default: 1st numeric column)
#'   \item \code{b} - Column for b-axis (bottom-left vertex)
#'     (UI: "B-axis column", default: 2nd numeric column)
#'   \item \code{c} - Column for c-axis (bottom-right vertex)
#'     (UI: "C-axis column", default: 3rd numeric column)
#'   \item \code{group} - Optional grouping column for multiple traces (UI: "Group column", default: NULL)
#'   \item \code{sum} - Constant sum for ternary axes (UI: "Sum", default: 100)
#'   \item \code{mode} - Trace mode (UI: "Mode", default: "markers")
#'   \item \code{marker.size} - Marker size (UI: "Marker size", default: 8)
#'   \item \code{marker.symbol} - Marker symbol (UI: "Marker symbol", default: "circle")
#'   \item \code{marker.line.width} - Marker border width (UI: "Marker border width", default: 0)
#'   \item \code{line.width} - Line width (UI: "Line width", default: 2)
#'   \item \code{line.dash} - Line dash style (UI: "Line style", default: "solid")
#'   \item \code{opacity} - Trace opacity (UI: "Opacity", default: 1)
#'   \item \code{colors} - Trace colors (UI: color picker, derived from palette)
#'   \item \code{a.title} - A-axis title (UI: "A-axis title", default: column name)
#'   \item \code{b.title} - B-axis title (UI: "B-axis title", default: column name)
#'   \item \code{c.title} - C-axis title (UI: "C-axis title", default: column name)
#'   \item \code{a.titlefont.size} - A-axis title font size (UI: "A-axis title size", default: 16)
#'   \item \code{b.titlefont.size} - B-axis title font size (UI: "B-axis title size", default: 16)
#'   \item \code{c.titlefont.size} - C-axis title font size (UI: "C-axis title size", default: 16)
#'   \item \code{a.gridcolor} - A-axis grid color (UI: "A-axis grid color", default: "#EEEEEE")
#'   \item \code{b.gridcolor} - B-axis grid color (UI: "B-axis grid color", default: "#EEEEEE")
#'   \item \code{c.gridcolor} - C-axis grid color (UI: "C-axis grid color", default: "#EEEEEE")
#'   \item \code{title.font.size} - Title font size (UI: "Title font size", default: 18)
#'   \item \code{title.font.family} - Title font (UI: "Title font", default: "Arial")
#'   \item \code{title.font.color} - Title font color (UI: "Title font color", default: "#000000")
#'   \item \code{show.legend} - Show legend (UI: "Show legend", default: TRUE)
#'   \item \code{legend.orientation} - Legend orientation (UI: "Legend orientation", default: "h")
#'   \item \code{legend.font.family} - Legend font (UI: "Legend font", default: "Arial")
#'   \item \code{legend.font.size} - Legend font size (UI: "Legend font size", default: 12)
#'   \item \code{legend.font.color} - Legend font color (UI: "Legend font color", default: "#000000")
#'   \item \code{bgcolor} - Plot background color (UI: "Background color", default: "#FFFFFF")
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
#' @author Jacob Martin
#' @seealso [VizModules::ternaryPlot()], [VizModules::organize_inputs()],
#' [VizModules::ternaryPlotOutputUI()], [VizModules::ternaryPlotServer()], [VizModules::ternaryPlotApp()]
#' @examples
#' library(VizModules)
#' df <- data.frame(
#'     a_val = c(75, 70, 75, 5, 10),
#'     b_val = c(25, 10, 20, 60, 80),
#'     c_val = c(0, 20, 5, 35, 10)
#' )
#' ternaryPlotInputsUI("ternaryPlot", df)
ternaryPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variable choices
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    all.choices <- c("", names(data))

    # Set default selections for a, b, c axes (first 3 numeric columns)
    default_a <- if (length(num.choices) > 1) num.choices[2] else ""
    default_b <- if (length(num.choices) > 2) num.choices[3] else ""
    default_c <- if (length(num.choices) > 3) num.choices[4] else ""

    font.choices <- c(
        "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono", "Gravitas One",
        "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman", "Verdana",
        "sans-serif", "serif", "monospace"
    )

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("a"), "A-axis column:",
                selected = ifelse("a" %in% names(defaults), defaults[["a"]], default_a),
                choices = num.choices
            ),
            selectInput(ns("b"), "B-axis column:",
                selected = ifelse("b" %in% names(defaults), defaults[["b"]], default_b),
                choices = num.choices
            ),
            selectInput(ns("c"), "C-axis column:",
                selected = ifelse("c" %in% names(defaults), defaults[["c"]], default_c),
                choices = num.choices
            ),
            selectInput(ns("group"), "Colour By:",
                selected = ifelse("group" %in% names(defaults),
                    defaults[["group"]],
                    ""
                ),
                choices = all.choices
            ),
            numericInput(ns("sum"), "Sum:",
                value = ifelse("sum" %in% names(defaults),
                    ifelse(is.numeric(defaults[["sum"]]), defaults[["sum"]], 100),
                    100
                ),
                min = 0
            )
        ),
        "Trace Style" = tagList(
            selectInput(ns("mode"), "Mode:",
                choices = c(
                    "Markers" = "markers",
                    "Lines + Markers" = "lines+markers"
                ),
                selected = ifelse("mode" %in% names(defaults),
                    defaults[["mode"]],
                    "markers"
                )
            ),
            numericInput(ns("marker.size"), "Marker size:",
                value = ifelse("marker.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["marker.size"]]), defaults[["marker.size"]], 8),
                    8
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
            numericInput(ns("marker.line.width"), "Marker border width:",
                value = ifelse("marker.line.width" %in% names(defaults),
                    ifelse(is.numeric(defaults[["marker.line.width"]]), defaults[["marker.line.width"]], 0),
                    0
                ),
                min = 0,
                step = 0.5
            ),
            colourpicker::colourInput(ns("marker.line.color"), "Marker border color:",
                value = ifelse("marker.line.color" %in% names(defaults),
                    defaults[["marker.line.color"]],
                    "#000000"
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
            sliderInput(ns("opacity"), "Opacity:",
                min = 0, max = 1,
                value = ifelse("opacity" %in% names(defaults),
                    defaults[["opacity"]],
                    1
                ),
                step = 0.05
            ),
            uiOutput(ns("color.picker"))
        ),
        "Axes" = tagList(
            textInput(ns("a.title"), "A-axis title:",
                value = ifelse("a.title" %in% names(defaults),
                    defaults[["a.title"]],
                    ""
                )
            ),
            textInput(ns("b.title"), "B-axis title:",
                value = ifelse("b.title" %in% names(defaults),
                    defaults[["b.title"]],
                    ""
                )
            ),
            textInput(ns("c.title"), "C-axis title:",
                value = ifelse("c.title" %in% names(defaults),
                    defaults[["c.title"]],
                    ""
                )
            ),
            numericInput(ns("a.titlefont.size"), "A-axis title size:",
                value = ifelse("a.titlefont.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["a.titlefont.size"]]), defaults[["a.titlefont.size"]], 16),
                    16
                ),
                min = 0
            ),
            numericInput(ns("b.titlefont.size"), "B-axis title size:",
                value = ifelse("b.titlefont.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["b.titlefont.size"]]), defaults[["b.titlefont.size"]], 16),
                    16
                ),
                min = 0
            ),
            numericInput(ns("c.titlefont.size"), "C-axis title size:",
                value = ifelse("c.titlefont.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["c.titlefont.size"]]), defaults[["c.titlefont.size"]], 16),
                    16
                ),
                min = 0
            ),
            colourpicker::colourInput(ns("a.gridcolor"), "A-axis grid color:",
                value = ifelse("a.gridcolor" %in% names(defaults),
                    defaults[["a.gridcolor"]],
                    "#EEEEEE"
                )
            ),
            colourpicker::colourInput(ns("b.gridcolor"), "B-axis grid color:",
                value = ifelse("b.gridcolor" %in% names(defaults),
                    defaults[["b.gridcolor"]],
                    "#EEEEEE"
                )
            ),
            colourpicker::colourInput(ns("c.gridcolor"), "C-axis grid color:",
                value = ifelse("c.gridcolor" %in% names(defaults),
                    defaults[["c.gridcolor"]],
                    "#EEEEEE"
                )
            )
        ),
        "Title & Legend" = tagList(
            numericInput(ns("title.font.size"), "Title font size:",
                value = ifelse("title.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["title.font.size"]]), defaults[["title.font.size"]], 18),
                    18
                ),
                min = 0
            ),
            selectInput(ns("title.font.family"), "Title font:",
                choices = font.choices,
                selected = ifelse(
                    "title.font.family" %in% names(defaults) &&
                        defaults[["title.font.family"]] %in% font.choices,
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
                selected = ifelse(
                    "legend.font.family" %in% names(defaults) &&
                        defaults[["legend.font.family"]] %in% font.choices,
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
            colourpicker::colourInput(ns("bgcolor"), "Background color:",
                value = ifelse("bgcolor" %in% names(defaults),
                    defaults[["bgcolor"]],
                    "#FFFFFF"
                )
            )
        )
    )

    organize_inputs(
        inputs,
        id = ns("ternaryPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the ternaryPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the ternaryPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
ternaryPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("ternaryPlot"), height = "100%", width = "100%")
    )
}
