#' Input UI components for the BoxPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `plotthis_BoxPlotServer()` and `plotthis_BoxPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::BoxPlot()] can be set via these inputs, so see the help
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
#' @seealso [plotthis::BoxPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_BoxPlotOutputUI()], [VizModules::plotthis_BoxPlotServer()], [VizModules::plotthis_BoxPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' plotthis_BoxPlotInputsUI("BoxPlot", mtcars)
plotthis_BoxPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11 # Y axis scale factor ( Allows the top of the graph to not reach the top of the axes)
    min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "X data", choices = cat.choices, selected = cat.choices[2]),
            selectInput(ns("y.data"), "Y data", choices = num.choices, selected = num.choices[2]),
            selectInput(ns("group.by"), "Group by", selected = "", choices = c("", cat.choices)),
            materialSwitch(ns("show.outliers"), "Show Outliers", value = TRUE, status = "success"),
            uiOutput(ns("palette.selection"))
        ),
        "Adjustments" = tagList(
            numericInput(ns("boxplot.width"), "Boxplot Width", min = 0, max = 1, value = 0.8, step = 0.05),
            selectInput(ns("sort_x"), "Sort X by", selected = "", choices = c("",
                "mean_asc", "mean_desc", "mean", "median_asc",
                "median_desc", "median"
            )),
            numericInput(ns("y.max"), "Max Value of Y Axis", value = max.y, min = -Inf, max = Inf),
            numericInput(ns("y.min"), "Min Value of Y Axis", value = min.y, min = -Inf, max = Inf),
            materialSwitch(ns("add.points"), "Add Jitter Points", value = FALSE, status = "success"),
            numericInput(ns("pt.size"), "Point Size", max = 100, min = 0.1, value = 1),
            numericInput(ns("pt.alpha"), "Point Alpha", min = 0, max = 1, value = 1),
            numericInput(ns("jitter.width"), "Jitter Width", min = 0, max = 1, value = 0.3, step = 0.05),
            colourpicker::colourInput(ns("pt.color"), "Point Outline Colour", value = "#000000")
        ),
        "Highlight" = tagList(
            textInput(ns("highlight"), "Highlight", value = "", placeholder = "E.g. col name > 0"),
            colourpicker::colourInput(ns("highlight.colour"), "Highlight Colour", value = "#000000"),
            numericInput(ns("highlight.size"), "Highlight Size", value = 1, min = 0),
            numericInput(ns("highlight.alpha"), "Highlight Alpha", value = 1, min = 0, max = 1)
        ),
        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by", selected = "", choices = c(cat.choices, "")),
            selectInput(ns("facet.scale"), "Facet Scale", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Columns", value = NULL, min = 0),
            numericInput(ns("facet.nrow"), "Rows", value = NULL, min = 0),
            materialSwitch(ns("facet.by.row"), "Facet by Row", value = TRUE, status = "success")
        ),
        "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE, include.flip = FALSE),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("BoxPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the BoxPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the boxPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_BoxPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("BoxPlot"))
    )
}
