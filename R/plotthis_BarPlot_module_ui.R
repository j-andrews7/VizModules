#' Input UI components for the BarPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `plotthis_BarPlotServer()` and `plotthis_BarPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::BarPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @importFrom colourpicker colourInput
#' @importFrom shinyWidgets materialSwitch
#' @import shiny
#' @importFrom plotthis BarPlot
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::BarPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_BarPlotOutputUI()], [VizModules::plotthis_BarPlotServer()], [VizModules::plotthis_BarPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' plotthis_BarPlotInputsUI("BarPlot", mtcars)
plotthis_BarPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, unlist(lapply(data, is.numeric), use.names = FALSE), drop = FALSE]
    #Axis range values 
    max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE)
    min.y <- 0
  

    inputs <- list(
    "Data" = tagList(
        selectInput(ns("x.data"), "X values:",
        selected = char.choices[2], choices = char.choices
        ),
        selectInput(ns("y.data"), "Y values:",
        selected = num.choices[2], choices = num.choices
        ),
        selectInput(ns("group.by"), "Group by:",
        selected = char.choices[2], choices = char.choices
        )
    ),

    "Facet" = tagList(
        selectInput(ns("facet.by"), "Facet by:",
        selected = "", choices = c(char.choices, "")
        ),
        selectInput(ns("facet.scale"), "Facet scale:",
        selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")
        ),
        numericInput(ns("facet.ncol"), "Facet number of columns:",
        value = NULL, min = 0, max = 20
        ),
        numericInput(ns("facet.nrow"), "Facet number of rows:",
        value = NULL, min = 0, max = 20
        ),
        materialSwitch(ns("facet.by.row"), "Facet by row:",
        value = TRUE, status = "success"),
        selectInput(ns("split.by"), "Split by:",
        selected = "", choices = c(char.choices, "")
        )
    ),

    "Aesthetics" = tagList(
        uiOutput(ns("palette.selection")),
        selectInput(ns("theme"), "Theme",
        selected = "theme_this",
        choices = c(
            "theme_grey", "theme_bw", "theme_linedraw", "theme_light",
            "theme_dark", "theme_minimal", "theme_classic", "theme_void",
            "theme_this", "theme_blank"
        )
        ),
        numericInput(ns("alpha"), "Alpha", value = 1, min = 0, max = 1),
        numericInput(ns("width"), "Width", value = NA),
        textInput(ns("expand"), "Expand", value = "",
        placeholder = "e.g. 1,2,3,4"
        )
    ),

    "Adjustments" = tagList(
        numericInput(ns("y.min"), "Y-axis min:",
            value = min.y
        ),
        numericInput(ns("y.max"), "Y-axis max:",
            value = max.y
        )
    ),

    "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
    "Lines" = .uniform_lines_inputs_ui(ns, defaults)
    )


    organize_inputs(
        inputs,
        id = ns("BarPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the BarPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the BarPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_BarPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("BarPlot"))
    )
}
