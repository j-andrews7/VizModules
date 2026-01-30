#' Histogram Plot Input UI Module
#'
#' @description
#' Generates the user interface for histogram configuration, including data selection,
#' faceting options, aesthetic controls (bins, trend lines, alpha), and detailed axis styling.
#'
#' @param id \code{character} unique ID for the shiny namespace.
#' @param data \code{data.frame} The dataset used to populate column selection choices.
#' @param defaults \code{list} Optional named list of default values for the inputs.
#' @param title \code{character} Optional title for the input panel.
#' @param columns \code{numeric} Number of columns to organize the inputs into. Default is 2.
#'
#' @return A \code{tagList} containing the organized UI elements.
#'
#' @author Jacob Martin, Jared Andrews
#' 
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#' @export
plotthis_HistogramInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
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
            selectInput(ns("x.data"), "X Data",
                    selected = ifelse("x.data" %in% names(defaults) && defaults[["x.data"]] %in% num.choices,
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
            numericInput(ns("bins"), "Number of Bins", value = NA, min = 0),
            numericInput(ns("bin.width"), "Bin Width", value = NA, min = 0),
            materialSwitch(ns("use.trend"), "Trend Line Only", value = FALSE, status = "success"),
            materialSwitch(ns("trend.skip.zero"), "Skip Zero Values", value = FALSE, status = "success"),
            materialSwitch(ns("add.trend"), "Add Trend to Histogram", value = FALSE, status = "success"),
            sliderInput(ns("trend.alpha"), "Trend Line Alpha", min = 0, max = 1, value = 1),
            numericInput(ns("trend.linewidth"), "Trend Line Width", value = 0.8, min = 0),
            numericInput(ns("trend.pt.size"), "Trend Point Size", value = 1.5),
            sliderInput(ns("plot.alpha"), "Plot Alpha", min = 0, max = 1, value = 1),
            selectInput(ns("theme"), "Plot Theme", selected = "theme_this",
            choices = c(
                "theme_grey", "theme_bw", "theme_linedraw", "theme_light",
                "theme_dark", "theme_minimal", "theme_classic", "theme_void",
                "theme_this", "theme_blank"
            )
            ),
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
        id = ns("histogramPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the histogramPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the histogramPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_HistogramOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("histogramPlot"))
    )
}
