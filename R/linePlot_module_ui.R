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

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, unlist(lapply(data, is.numeric), use.names = FALSE), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    adj.choices <- c("", "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt")

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.value"), "Select X values:",
            selected = names(data)[1], choices = names(data), multiple = TRUE
            ),
            selectInput(ns("y.value"), "Select Y values:",
            selected = names(data)[2], choices = names(data), multiple = TRUE
            ),
            selectInput(ns("group.by"), "Group by:",
            selected = cat.choices[1], choices = cat.choices
            ),
            materialSwitch(ns("order.by"), "Order by Y",
                value = ifelse("order.by" %in% names(defaults),
                    ifelse(is.logical(defaults[["order.by"]]), defaults[["order.by"]], FALSE),
                    FALSE
                ),
                status = "success"
            ),
            selectInput(ns("x.adjustment"), "X Adjustment",
                choices = adj.choices,
                selected = ifelse("x.adjustment" %in% names(defaults),
                    ifelse(defaults[["x.adjustment"]] %in% adj.choices, defaults[["x.adjustment"]], ""),
                    ""
                )
            ),
            selectInput(ns("y.adjustment"), "Y Adjustment",
                choices = adj.choices,
                selected = ifelse("y.adjustment" %in% names(defaults),
                    ifelse(defaults[["y.adjustment"]] %in% adj.choices, defaults[["y.adjustment"]], ""),
                    ""
                )
            )
        ),

        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by:",
            selected = "", choices = cat.choices
            ),
            selectInput(ns("facet.scales"), "Facet scales",
            choices   = c("fixed", "free", "free_x", "free_y"),
            selected  = ifelse("facet.scales" %in% names(defaults),
                ifelse(defaults[["facet.scales"]] %in% c("fixed", "free", "free_x", "free_y"),
                defaults[["facet.scales"]], "fixed"
                ),
                "fixed"
            )
            )
        ),

        "Aesthetics" = tagList(
            selectInput(ns("plot.type"), "Plot type:",
            selected = "lines",
            choices  = c("lines", "markers", "lines+markers")
            ),
            selectInput(ns("line.type"), "Line type:",
            selected = "solid",
            choices  = c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot")
            ),
            uiOutput(ns("palette.selection"))
        ),

        "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE),
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
