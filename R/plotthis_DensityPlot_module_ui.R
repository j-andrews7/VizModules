#' Density Plot Input UI Module
#'
#' @description
#' Generates the user interface for density plot configuration, including data selection,
#' faceting options, aesthetic controls (alpha, position), and detailed axis styling.
#'
#' @details
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::DensityPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#' 
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::DensityPlot()] parameters are not available via UI inputs:
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{title} - Plot title (plotly allows interactive editing)
#'   \item \code{subtitle} - Plot subtitle (not supported in plotly)
#'   \item \code{aspect.ratio} - Aspect ratio control (handled by plotly layout)
#'   \item \code{legend.position} - Legend positioning (plotly allows interactive repositioning)
#'   \item \code{legend_direction} - Legend orientation (plotly allows interactive repositioning)
#'   \item \code{palette} - Managed internally via the palette selection UI
#' }
#'
#' @param id \code{character} unique ID for the shiny namespace.
#' @param data \code{data.frame} The dataset used to populate column selection choices.
#' @param defaults \code{list} Optional named list of default values for the inputs.
#' @param title \code{character} Optional title for the input panel.
#' @param columns \code{numeric} Number of columns to organize the inputs into. Default is 2.
#'
#' @return A \code{tagList} containing the organized UI elements.
#' 
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#' 
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::DensityPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_DensityPlotOutputUI()], [VizModules::plotthis_DensityPlotServer()], [VizModules::plotthis_DensityPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' plotthis_DensityPlotInputsUI("densityPlot", mtcars)
plotthis_DensityPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "X Data", selected = ifelse("x.data" %in% names(defaults) && defaults[["x.data"]] %in% num.choices,
                    defaults[["x.data"]], num.choices[2]
                ),
                choices = num.choices),
            selectInput(ns("group.by"), "Group By", selected = "", choices = c("", cat.choices))
        ),
        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet By", selected = "", choices = c("", cat.choices)),
            selectInput(ns("facet.scale"), "Facet Scale", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Number of Columns", value = NULL, min = 0, max = 20),
            numericInput(ns("facet.nrow"), "Number of Rows", value = NULL, min = 0, max = 20),
            materialSwitch(ns("facet.by.row"), "Facet by Row", value = TRUE, status = "success")
        ),
        "Aesthetics" = tagList(
            numericInput(ns("plot.alpha"), "Plot Alpha", min = 0, max = 1, value = 0.5),
            uiOutput(ns("palette.selection")),
            selectInput(ns("position"), "Position", selected = "identity",
            choices = c("identity", "stack", "dodge", "fill")
            )
        ),
        "Rug" = tagList(
            materialSwitch(ns("add.bars"), "Add Rug Plot", value = FALSE, status = "success"),
            numericInput(ns("bar.height"), "Rug Bar Height", value = 0.04),
            sliderInput(ns("bar.alpha"), "Rug Bar Alpha", min = 0, max = 1, value = 1, step = 0.05),
            numericInput(ns("bar.width"), "Rug Bar Width", value = 1, min = 0, step = 0.05)
        ),
        "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("densityPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the densityPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the densityPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_DensityPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("densityPlot"))
    )
}
