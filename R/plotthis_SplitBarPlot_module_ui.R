#' Input UI components for the SplitBarPlot module
#'
#' Builds the tabbed input controls used to configure the SplitBarPlot module.
#' This should be placed alongside [plotthis_SplitBarPlotOutputUI()] in your app.
#'
#' @param id The ID for the Shiny module.
#' @param data A data frame used to populate input choices.
#' @param defaults Named list of default input values.
#' @param title Optional title for the input panel.
#' @param columns Integer. Number of columns for organizing inputs.
#'
#' @return A Shiny UI element containing the inputs for SplitBarPlot.
#'
#' @import shiny
#'
#' @export
#' @author Jacob Martin
plotthis_SplitBarPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, unlist(lapply(data, is.numeric), use.names = FALSE), drop = FALSE]
    max.x <- max(numeric.data, na.rm = TRUE)
    min.x <- min(numeric.data, na.rm = TRUE)
  

    inputs <- list(
      "Data" = tagList(
      selectInput(ns("x.data"), "X values",
        selected = num.choices[2], choices = num.choices
      ),
      selectInput(ns("y.data"), "Y values",
        selected = char.choices[2], choices = char.choices
      ),
      # Changed from group.by to fill.by
      selectInput(ns("fill.by"), "Fill by",
        selected = choices[2], choices = choices
      )),


    "Facet" = tagList(
        selectInput(ns("facet.by"), "Facet by",
        selected = "", choices = c(char.choices, "")
        ),
        selectInput(ns("facet.scale"), "Facet scale",
        selected = "free_y", choices = c("fixed", "free", "free_x", "free_y")
        ),
        numericInput(ns("facet.ncol"), "Facet number of columns",
        value = NULL, min = 0, max = 20
        ),
        numericInput(ns("facet.nrow"), "Facet number of rows",
        value = NULL, min = 0, max = 20
        ),
        materialSwitch(ns("facet.by.row"), "Facet by row",
        value = TRUE, status = "success"),
        selectInput(ns("split.by"), "Split by",
        selected = "", choices = c(char.choices, "")
        )
    ),

    "Aesthetics" = tagList(
        uiOutput(ns("palette.selection")),
        selectInput(ns("alpha.by"), "Alpha by", selected = "", choices = c("", num.choices)),
        materialSwitch(ns("alpha.reverse"), "Alpha reverse", value = FALSE, status = "success"),
        textInput(ns("alpha.name"), "Alpha name", value = ""),
        numericInput(ns("bar.height"), "Bar height", value = 0.9, min = 0)
    ),

    "Adjustments" = tagList(
        numericInput(ns("x.min"), "X-axis min:",
            value = min.x
        ),
        numericInput(ns("x.max"), "X-axis max:",
            value = max.x
        )
    ),


    "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
    "Lines" = .uniform_lines_inputs_ui(ns, defaults)
    )


    organize_inputs(
        inputs,
        id = ns("SplitBarPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the SplitBarPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the SplitBarPlot
#'
#' @import shiny
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_SplitBarPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("SplitBarPlot"))
    )
}
