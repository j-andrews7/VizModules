#' Input UI components for the linePlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `linePlotServer()` and `linePlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [VizModules::linePlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' @section Plot parameters and defaults:
#' The following [VizModules::linePlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis variable(s) (UI: "Select X values", default: 1st column, multiple: TRUE)
#'   \item \code{y} - Y-axis variable(s) (UI: "Select Y values", default: 2nd column, multiple: TRUE)
#'   \item \code{group.by} - Grouping variable (UI: "Group by", default: 1st categorical variable)
#'   \item \code{order.by} - Order by Y values (UI: "Order by Y", default: FALSE)
#'   \item \code{x.adjustment} - X-axis adjustment function (UI: "X Adjustment", default: "")
#'   \item \code{y.adjustment} - Y-axis adjustment function (UI: "Y Adjustment", default: "")
#'   \item \code{facet.by} - Faceting variable (UI: "Facet by", default: "")
#'   \item \code{facet.scales} - Facet scale behavior (UI: "Facet scales", default: "fixed")
#'   \item \code{plot.mode} - Plot type (UI: "Plot type", default: "lines")
#'   \item \code{line.type} - Line type (UI: "Line type", default: "solid")
#'   \item \code{palette.selection} - Color palette (UI: palette picker, derived from palette)
#'   \item \code{axis.showline} - Show axis lines (UI: via .uniform_axes_inputs_ui, default: TRUE)
#'   \item \code{axis.mirror} - Mirror axis lines (UI: via .uniform_axes_inputs_ui, default: TRUE)
#'   \item \code{axis.linecolor} - Axis line color (UI: via .uniform_axes_inputs_ui, default: "black")
#'   \item \code{axis.linewidth} - Axis line width (UI: via .uniform_axes_inputs_ui, default: 0.5)
#'   \item \code{axis.tickfont.size} - Tick font size (UI: via .uniform_axes_inputs_ui, default: 12)
#'   \item \code{axis.tickfont.color} - Tick font color (UI: via .uniform_axes_inputs_ui, default: "black")
#'   \item \code{axis.tickfont.family} - Tick font family (UI: via .uniform_axes_inputs_ui, default: "Arial")
#'   \item \code{axis.tickangle.x} - X-axis tick angle (UI: via .uniform_axes_inputs_ui, default: 0)
#'   \item \code{axis.tickangle.y} - Y-axis tick angle (UI: via .uniform_axes_inputs_ui, default: 0)
#'   \item \code{axis.ticks} - Tick position (UI: via .uniform_axes_inputs_ui, default: "outside")
#'   \item \code{axis.tickcolor} - Tick color (UI: via .uniform_axes_inputs_ui, default: "black")
#'   \item \code{axis.ticklen} - Tick length (UI: via .uniform_axes_inputs_ui, default: 5)
#'   \item \code{axis.tickwidth} - Tick width (UI: via .uniform_axes_inputs_ui, default: 1)
#'   \item \code{show.grid.x} - Show X-axis gridlines (UI: "Show X Gridlines", default: TRUE)
#'   \item \code{show.grid.y} - Show Y-axis gridlines (UI: "Show Y Gridlines", default: TRUE)
#'   \item \code{title.font.size} - Title font size (UI: via .uniform_axes_inputs_ui, default: 28)
#'   \item \code{title.font.family} - Title font family (UI: "Font", default: "Arial")
#'   \item \code{title.text.color} - Title text color (UI: via .uniform_axes_inputs_ui, default: "#000000")
#'   \item \code{x.title} - X-axis title (auto-calculated from data)
#'   \item \code{y.title} - Y-axis title (auto-calculated from data)
#'   \item \code{flip.x} - Flip X-axis (UI: "Flip X", default: FALSE)
#'   \item \code{flip.y} - Flip Y-axis (UI: "Flip Y", default: FALSE)
#' }
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing plotly-specific features are also available:
#' \itemize{
#'   \item \code{hline.intercepts} - Horizontal line Y-intercepts (UI: via .uniform_lines_inputs_ui, default: "")
#'   \item \code{hline.colors} - Horizontal line colors (UI: via .uniform_lines_inputs_ui, default: "#000000")
#'   \item \code{hline.widths} - Horizontal line widths (UI: via .uniform_lines_inputs_ui, default: "1")
#'   \item \code{hline.linetypes} - Horizontal line types (UI: via .uniform_lines_inputs_ui, default: "dashed")
#'   \item \code{hline.opacities} - Horizontal line opacities (UI: via .uniform_lines_inputs_ui, default: "1")
#'   \item \code{vline.intercepts} - Vertical line X-intercepts (UI: via .uniform_lines_inputs_ui, default: "")
#'   \item \code{vline.colors} - Vertical line colors (UI: via .uniform_lines_inputs_ui, default: "#000000")
#'   \item \code{vline.widths} - Vertical line widths (UI: via .uniform_lines_inputs_ui, default: "1")
#'   \item \code{vline.linetypes} - Vertical line types (UI: via .uniform_lines_inputs_ui, default: "dashed")
#'   \item \code{vline.opacities} - Vertical line opacities (UI: via .uniform_lines_inputs_ui, default: "1")
#'   \item \code{abline.slopes} - Diagonal line slopes (UI: via .uniform_lines_inputs_ui, default: "")
#'   \item \code{abline.intercepts} - Diagonal line Y-intercepts (UI: via .uniform_lines_inputs_ui, default: "")
#'   \item \code{abline.colors} - Diagonal line colors (UI: via .uniform_lines_inputs_ui, default: "#000000")
#'   \item \code{abline.widths} - Diagonal line widths (UI: via .uniform_lines_inputs_ui, default: "1")
#'   \item \code{abline.linetypes} - Diagonal line types (UI: via .uniform_lines_inputs_ui, default: "dashed")
#'   \item \code{abline.opacities} - Diagonal line opacities (UI: via .uniform_lines_inputs_ui, default: "1")
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
#' @author Jacob Martin, Jared Andrews
#' @seealso [VizModules::linePlot()], [VizModules::organize_inputs()],
#' [VizModules::linePlotOutputUI()], [VizModules::linePlotServer()], [VizModules::linePlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' linePlotInputsUI("linePlot", mtcars)
linePlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    cat.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    adj.choices <- c("", "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt")

    selected <- list("x", "y", "colour.group.by", "error.bar", "order.by",
        "x.adjustment", "y.adjustment", "facet.by", "facet.scales",
        "plot.mode", "line.type", "error.colour", "error.width")

    documentParameters <- get_documentation(
        package_name = "VizModules::linePlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("x.value"), "Select X values:",
                selected = .get_default(defaults, "x.value", names(data)[1],
                    function(x) all(x %in% names(data))),
                choices = names(data), multiple = TRUE
            ), paste(documentParameters$x, ".", "If you want error bars the X input must be a category and the Y input must only be length = 1"), placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.value"), "Select Y values:",
                selected = .get_default(defaults, "y.value", names(data)[2],
                    function(x) all(x %in% names(data))),
                choices = names(data), multiple = TRUE
            ), documentParameters$y, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("group.by"), "Group by:",
                selected = .get_default(defaults, "group.by", cat.choices[1],
                    function(x) x %in% cat.choices),
                choices = cat.choices
            ), documentParameters$colour.group.by, placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("errorBar"), "Error Bars:", value = TRUE),
                documentParameters$error.bar, placement = "top", options = list(container = "body")),
            tipify(materialSwitch(ns("order.by"), "Order by Y",
                value = .get_default(defaults, "order.by", FALSE, is.logical),
                status = "success"
            ), documentParameters$order.by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("x.adjustment"), "X Adjustment",
                choices = adj.choices,
                selected = .get_default(defaults, "x.adjustment", "",
                    function(x) x %in% adj.choices)
            ), documentParameters$x.adjustment, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.adjustment"), "Y Adjustment",
                choices = adj.choices,
                selected = .get_default(defaults, "y.adjustment", "",
                    function(x) x %in% adj.choices)
            ), documentParameters$y.adjustment, placement = "top", options = list(container = "body"))
        ),

        "Facet" = tagList(
            tipify(selectInput(ns("facet.by"), "Facet by:",
                selected = "", choices = cat.choices
            ), documentParameters$facet.by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("facet.scales"), "Facet scales",
                choices   = c("fixed", "free", "free_x", "free_y"),
                selected  = .get_default(defaults, "facet.scales", "fixed",
                    function(x) x %in% c("fixed", "free", "free_x", "free_y"))
            ), documentParameters$facet.scales, placement = "top", options = list(container = "body"))
        ),

        "Aesthetics" = tagList(
            tipify(selectInput(ns("plot.type"), "Plot type:",
                selected = "lines",
                choices  = c("lines", "markers", "lines+markers")
            ), documentParameters$plot.mode, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("line.type"), "Line type:",
                selected = "solid",
                choices  = c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot")
            ), documentParameters$line.type, placement = "top", options = list(container = "body")),
            uiOutput(ns("palette.selection")),
            tipify(colourpicker::colourInput(ns("errorBarColour"), "Error Bar Colour", value = "#000000"),
                documentParameters$error.colour, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("errorBarWidth"), "Error Bar Width", value = 1, min = 0.1),
                documentParameters$error.width, placement = "top", options = list(container = "body"))
        ),

        "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE, include.flip = TRUE),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
        )


    organize_inputs(
        inputs,
        id = ns("linePlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the linePlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the linePlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
linePlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("linePlot"))
    )
}
