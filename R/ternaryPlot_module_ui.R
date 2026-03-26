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
#' @importFrom shinyBS tipify
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

    selected <- list(
        "a", "b", "c", "group", "sum", "mode",
        "marker.size", "marker.symbol", "marker.line.width", "marker.line.color",
        "line.width", "line.dash", "opacity",
        "a.title", "b.title", "c.title",
        "a.titlefont.size", "b.titlefont.size", "c.titlefont.size",
        "a.gridcolor", "b.gridcolor", "c.gridcolor",
        "title.font.size", "title.font.family", "title.font.color",
        "show.legend", "legend.orientation", "legend.font.family",
        "legend.font.size", "legend.font.color", "bgcolor"
    )

    documentParameters <- get_documentation(
        package_name = "VizModules::ternaryPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("a"), "A-axis column:",
                selected = .get_default(defaults, "a", default_a),
                choices = num.choices
            ), documentParameters$a, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("b"), "B-axis column:",
                selected = .get_default(defaults, "b", default_b),
                choices = num.choices
            ), documentParameters$b, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("c"), "C-axis column:",
                selected = .get_default(defaults, "c", default_c),
                choices = num.choices
            ), documentParameters$c, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("group"), "Colour By:",
                selected = .get_default(defaults, "group", ""),
                choices = all.choices
            ), documentParameters$group, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("sum"), "Sum:",
                value = .get_default(defaults, "sum", 100, is.numeric),
                min = 0
            ), documentParameters$sum, placement = "top", options = list(container = "body"))
        ),
        "Trace Style" = tagList(
            tipify(selectInput(ns("mode"), "Mode:",
                choices = c(
                    "Markers" = "markers",
                    "Lines + Markers" = "lines+markers"
                ),
                selected = .get_default(defaults, "mode", "markers")
            ), documentParameters$mode, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("marker.size"), "Marker size:",
                value = .get_default(defaults, "marker.size", 8, is.numeric),
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
            tipify(numericInput(ns("marker.line.width"), "Marker border width:",
                value = .get_default(defaults, "marker.line.width", 0, is.numeric),
                min = 0,
                step = 0.5
            ), documentParameters$marker.line.width, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("marker.line.color"), "Marker border color:",
                value = .get_default(defaults, "marker.line.color", "#000000")
            ), documentParameters$marker.line.color, placement = "top", options = list(container = "body")),
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
            tipify(sliderInput(ns("opacity"), "Opacity:",
                min = 0, max = 1,
                value = .get_default(defaults, "opacity", 1),
                step = 0.05
            ), documentParameters$opacity, placement = "top", options = list(container = "body")),
            uiOutput(ns("color.picker"))
        ),
        "Axes" = tagList(
            tipify(textInput(ns("a.title"), "A-axis title:",
                value = .get_default(defaults, "a.title", "")
            ), documentParameters$a.title, placement = "top", options = list(container = "body")),
            tipify(textInput(ns("b.title"), "B-axis title:",
                value = .get_default(defaults, "b.title", "")
            ), documentParameters$b.title, placement = "top", options = list(container = "body")),
            tipify(textInput(ns("c.title"), "C-axis title:",
                value = .get_default(defaults, "c.title", "")
            ), documentParameters$c.title, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("a.titlefont.size"), "A-axis title size:",
                value = .get_default(defaults, "a.titlefont.size", 16, is.numeric),
                min = 0
            ), documentParameters$a.titlefont.size, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("b.titlefont.size"), "B-axis title size:",
                value = .get_default(defaults, "b.titlefont.size", 16, is.numeric),
                min = 0
            ), documentParameters$b.titlefont.size, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("c.titlefont.size"), "C-axis title size:",
                value = .get_default(defaults, "c.titlefont.size", 16, is.numeric),
                min = 0
            ), documentParameters$c.titlefont.size, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("a.gridcolor"), "A-axis grid color:",
                value = .get_default(defaults, "a.gridcolor", "#EEEEEE")
            ), documentParameters$a.gridcolor, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("b.gridcolor"), "B-axis grid color:",
                value = .get_default(defaults, "b.gridcolor", "#EEEEEE")
            ), documentParameters$b.gridcolor, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("c.gridcolor"), "C-axis grid color:",
                value = .get_default(defaults, "c.gridcolor", "#EEEEEE")
            ), documentParameters$c.gridcolor, placement = "top", options = list(container = "body"))
        ),
        "Title & Legend" = tagList(
            tipify(numericInput(ns("title.font.size"), "Title font size:",
                value = .get_default(defaults, "title.font.size", 18, is.numeric),
                min = 0
            ), documentParameters$title.font.size, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("title.font.family"), "Title font:",
                choices = font.choices,
                selected = .get_default(
                    defaults, "title.font.family", "Arial",
                    function(x) x %in% font.choices
                )
            ), documentParameters$title.font.family, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("title.font.color"), "Title font color:",
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
                selected = .get_default(
                    defaults, "legend.font.family", "Arial",
                    function(x) x %in% font.choices
                )
            ), documentParameters$legend.font.family, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("legend.font.size"), "Legend font size:",
                value = .get_default(defaults, "legend.font.size", 12, is.numeric),
                min = 1,
                step = 1
            ), documentParameters$legend.font.size, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("legend.font.color"), "Legend font color:",
                value = .get_default(defaults, "legend.font.color", "#000000")
            ), documentParameters$legend.font.color, placement = "top", options = list(container = "body"))
        ),
        "Background" = tagList(
            tipify(colourInput(ns("bgcolor"), "Background color:",
                value = .get_default(defaults, "bgcolor", "#FFFFFF")
            ), documentParameters$bgcolor, placement = "top", options = list(container = "body"))
        ),
        "Plotly" = .uniform_plotly_inputs_ui(ns, defaults)
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
