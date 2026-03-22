#' Input UI components for the dumbbellPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dumbbellPlotServer()` and `dumbbellPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#'
#' @section Plot parameters and defaults:
#' The following [VizModules::dumbbellPlot()] parameters can be accessed via UI inputs:
#' \itemize{
#'   \item \code{x} - X values (UI: "Select X values (max 2)", multiple: TRUE, max 2 enforced)
#'   \item \code{y} - Y value (UI: "Select Y value", single selection)
#'   \item \code{x.adjustment} - X-axis transformation (UI: "X Adjustment")
#'   \item \code{colour.by} - Color by X or Y (UI: "Colour by", options: "X variables", "Y variables")
#'   \item \code{facet.by} - Faceting variable (UI: "Facet by")
#'   \item \code{facet.scales} - Facet scale behavior (UI: "Facet scales", default: "fixed")
#'   \item \code{line.colour} - Color of connecting lines (UI: "Colour Of connectors", default: "red")
#'   \item \code{palette.selection} - Color palette (UI: palette picker)
#'   \item \code{axis.*} - Various axis styling options (UI: via .uniform_axes_inputs_ui)
#'   \item \code{flip.x} - Flip X-axis (UI: "Flip X", default: FALSE)
#'   \item \code{flip.y} - Flip Y-axis (UI: "Flip Y", default: FALSE)
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
#' @importFrom shinyBS tipify
#'
#' @export
#' @author Jacob Martin
#' @seealso [VizModules::dumbbellPlot()], [VizModules::organize_inputs()],
#' [VizModules::dumbbellPlotOutputUI()], [VizModules::dumbbellPlotServer()], [VizModules::dumbbellPlotApp()]
#' @examples
#' library(VizModules)
#' data <- data.frame(
#'     School = c("MIT", "Stanford", "Harvard"),
#'     Women = c(94, 96, 112),
#'     Men = c(152, 151, 165)
#' )
#' dumbbellPlotInputsUI("dumbbellPlot", data)
dumbbellPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    cat.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    adj.choices <- c("", "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt")

    selected <- list(
        "x", "y", "x.adjustment", "colour.by",
        "facet.by", "facet.scales", "line.colour"
    )

    documentParameters <- get_documentation(
        package_name = "VizModules::dumbbellPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("x.value"), "Select X values (max 2):",
                selected = if (length(num.choices) >= 3) num.choices[2:3] else num.choices[2],
                choices = num.choices, multiple = TRUE
            ), documentParameters$x, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.value"), "Select Y value:",
                selected = if (length(cat.choices) > 1) cat.choices[2] else "",
                choices = cat.choices, multiple = FALSE
            ), documentParameters$y, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("x.adjustment"), "X Adjustment:",
                choices = adj.choices,
                selected = .get_default(
                    defaults, "x.adjustment", "",
                    function(x) x %in% adj.choices
                )
            ), documentParameters$x.adjustment, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("colour.by"), "Colour by:",
                choices = c("X variables", "Y variables"),
                selected = "X variables"
            ), documentParameters$colour.by, placement = "top", options = list(container = "body"))
        ),
        "Facet" = tagList(
            tipify(selectInput(ns("facet.by"), "Facet by:",
                selected = "", choices = cat.choices
            ), documentParameters$facet.by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("facet.scales"), "Facet scales",
                choices = c("fixed", "free", "free_x", "free_y"),
                selected = .get_default(
                    defaults, "facet.scales", "fixed",
                    function(x) x %in% c("fixed", "free", "free_x", "free_y")
                )
            ), documentParameters$facet.scales, placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            tipify(colourpicker::colourInput(ns("line.colour"), "Colour of connectors", value = "gray30"),
                documentParameters$line.colour,
                placement = "top", options = list(container = "body")
            )
        ),
        "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE, include.flip = TRUE),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
    )


    organize_inputs(
        inputs,
        id = ns("dumbbellPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the dumbbellPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the dumbbellPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
dumbbellPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("dumbbellPlot"))
    )
}
