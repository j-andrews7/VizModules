#' Input UI components for the dumbellPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dumbellPlotServer()` and `dumbellPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [VizModules::dumbellPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' @section Plot parameters and defaults:
#' The following [VizModules::dumbellPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis start values (UI: "Select X start values", multiple: TRUE)
#'   \item \code{x_end} - X-axis end values (UI: "Select X end values", multiple: TRUE)
#'   \item \code{y} - Y-axis variable(s) (UI: "Select Y values", multiple: TRUE)
#'   \item \code{group.by} - Grouping variable (UI: "Group by")
#'   \item \code{facet.by} - Faceting variable (UI: "Facet by", default: "")
#'   \item \code{facet.scales} - Facet scale behavior (UI: "Facet scales", default: "fixed")
#'   \item \code{line.colour} - Color of connecting lines (UI: "Colour Of connectors", default: "red")
#'   \item \code{palette.selection} - Color palette (UI: palette picker, derived from palette)
#'   \item \code{axis.*} - Various axis styling options (UI: via .uniform_axes_inputs_ui)
#'   \item \code{flip.x} - Flip X-axis (UI: "Flip X", default: FALSE)
#'   \item \code{flip.y} - Flip Y-axis (UI: "Flip Y", default: FALSE)
#' }
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing plotly-specific features are also available:
#' \itemize{
#'   \item \code{hline.*} - Horizontal reference lines (UI: via .uniform_lines_inputs_ui)
#'   \item \code{vline.*} - Vertical reference lines (UI: via .uniform_lines_inputs_ui)
#'   \item \code{abline.*} - Diagonal reference lines (UI: via .uniform_lines_inputs_ui)
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
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [VizModules::dumbellPlot()], [VizModules::organize_inputs()],
#' [VizModules::dumbellPlotOutputUI()], [VizModules::dumbellPlotServer()], [VizModules::dumbellPlotApp()]
#' @examples
#' library(VizModules)
#' data <- data.frame(
#'   School = c("School A", "School B", "School C"),
#'   Women = c(30, 35, 40),
#'   Men = c(50, 55, 60)
#' )
#' dumbellPlotInputsUI("dumbellPlot", data)
dumbellPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
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
          selectInput(ns("x.value"), "Select X start values:",
          selected = if (length(num.choices) > 1) num.choices[2] else "",
          choices = num.choices, multiple = TRUE
          ),
          selectInput(ns("x_end.value"), "Select X end values:",
          selected = if (length(num.choices) > 2) num.choices[3] else "",
          choices = num.choices, multiple = TRUE
          ),
          selectInput(ns("y.value"), "Select Y values:",
          selected = if (length(cat.choices) > 1) cat.choices[2] else "",
          choices = choices, multiple = TRUE
          ),
          selectInput(ns("group.by"), "Group by:",
            selected = cat.choices[1], choices = cat.choices
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
          uiOutput(ns("palette.selection")),
          colourpicker::colourInput(ns("line.colour"), "Colour Of connectors", value = "red")
        ),

        "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE, include.flip = TRUE),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
        )


    organize_inputs(
        inputs,
        id = ns("dumbellPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}




#' Output UI components for the dumbellPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the dumbellPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
dumbellPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("dumbellPlot"))
    )
}
