#' Input UI components for the volcanoPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `volcanoPlotServer()` and `volcanoPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the [VizModules::organize_inputs()] function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' This module wraps [VizModules::dittoViz_scatterPlotInputsUI()] and adds volcano-specific controls.
#'
#' Additional inputs specific to volcano plots are added to control significance thresholds and colors:
#' \itemize{
#'   \item `sig.thresh`: Significance threshold (default 0.05)
#'   \item `fc.thresh`: Log2 fold change threshold (default 0)
#'   \item `volcano.colors`: A multiColorPicker for Up/Down/n.s. group colors
#'     (defaults: Up="red", Down="blue", n.s.="lightgray")
#' }
#'
#' @section Plot parameters and defaults:
#' The following parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x.by} - X-axis variable (auto-detected from effect size columns: log2FoldChange, LFC, logFC)
#'   \item \code{y.by} - Y-axis variable (auto-detected from significance columns: padj, pval, adj.p, svalue, FDR, p)
#'   \item \code{color.by} - Coloring variable (default: "group", auto-generated from thresholds)
#'   \item \code{y.adj.fxn} - Y adjustment function (default: "neg_log10" for -log10(p-value))
#'   \item \code{show.others} - Show others (default: FALSE)
#'   \item \code{hover.data} - Hover data columns (default: c("symbol", x.by, y.by))
#'   \item \code{sig.thresh} - Significance threshold (UI: "Significance Threshold", default: 0.05)
#'   \item \code{fc.thresh} - Log2 fold change threshold (UI: "LFC Threshold (log2)", default: 0)
#'   \item All other [dittoViz::scatterPlot()] parameters are also available via the wrapped UI
#' }
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing volcano-specific features are also available:
#' \itemize{
#'   \item \code{volcano.colors} - Named color vector for Up/Down/n.s. groups (UI: "Group Colors" multiColorPicker)
#'   \item \code{group} - Auto-generated grouping column based on sig.thresh and fc.thresh
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
#' 
#' @export
#' @author Jared Andrews
#' @seealso [dittoViz::scatterPlot()], [VizModules::dittoViz_scatterPlotInputsUI()],
#' [VizModules::volcanoPlotOutputUI()], [VizModules::volcanoPlotServer()],
#' [VizModules::volcanoPlotApp()]
#' @examples
#' library(VizModules)
#' data(airway_deseq2)
#' volcanoPlotInputsUI("volcanoPlot", airway_deseq2)
volcanoPlotInputsUI <- function(id, data, defaults = NULL, title = "Volcano Settings", columns = 2) {
    # Add a few extra inputs to control the DE thresholds
    ns <- NS(id)

    if (is.null(defaults)) {
        defaults <- list()
    }

    # Set defaults typical for volcano plots if not provided
    # Define common names to search for
    lfc_names <- c("log2FoldChange", "LFC", "logFC")
    p_names <- c("padj", "pval", "adj.p", "svalue", "FDR", "p")

    # Find LFC column
    if (!"x.by" %in% names(defaults)) {
        found_lfc <- intersect(lfc_names, names(data))
        if (length(found_lfc) > 0) {
            defaults$x.by <- found_lfc[1]
        } else {
            stop("Could not find an effect size column (e.g. 'log2FoldChange', 'LFC', 'logFC'). Please specify one in defaults$x.by.")
        }
    }

    # Find Significance column
    if (!"y.by" %in% names(defaults)) {
        found_p <- intersect(p_names, names(data))
        if (length(found_p) > 0) {
            defaults$y.by <- found_p[1]
        } else {
            stop("Could not find a significance column (e.g. 'padj', 'adj.p', 'FDR'). Please specify one in defaults$y.by.")
        }
    }

    if (!"color.by" %in% names(defaults)) defaults$color.by <- "group"
    if (!"y.adj.fxn" %in% names(defaults)) defaults$y.adj.fxn <- "neg_log10"
    if (!"show.others" %in% names(defaults)) defaults$show.others <- FALSE
    if (!"hover.data" %in% names(defaults)) {
        # Use the selected or defaulted columns for hover data
        defaults$hover.data <- c("symbol", defaults$x.by, defaults$y.by)
    }

    # Ensure threshold defaults exist
    if (!"sig.thresh" %in% names(defaults)) defaults$sig.thresh <- 0.05
    if (!"fc.thresh" %in% names(defaults)) defaults$fc.thresh <- 0

    # Build initial colors from defaults or use standard volcano colors
    initial_colors <- c(
        "Up" = if ("color.up" %in% names(defaults)) defaults[["color.up"]] else "red",
        "Down" = if ("color.down" %in% names(defaults)) defaults[["color.down"]] else "blue",
        "n.s." = if ("color.ns" %in% names(defaults)) defaults[["color.ns"]] else "lightgray"
    )

    extras <- tagList(
        numericInput(ns("sig.thresh"), "Significance Threshold:",
            value = defaults[["sig.thresh"]],
            max = 1,
            min = 0,
            step = 0.01
        ),
        numericInput(ns("fc.thresh"), "LFC Threshold (log2):",
            value = defaults[["fc.thresh"]],
            min = 0,
            step = 0.25
        ),
        multiColorPicker(
            inputId = ns("volcano.colors"),
            label = "Group Colors",
            groups = c("Up", "Down", "n.s."),
            colors = initial_colors,
            palette_options = default_palettes()[["choices"]],
            compact = TRUE
        )
    )

    extras <- organize_inputs(extras, columns = columns)

    # Ensure 'group' is in the data so it appears in the choices for dittoViz_ScatterPlotInputsUI
    # This allows the default selected="group" for color.by to work correctly
    if (!"group" %in% names(data)) {
        data$group <- "dummy"
    }

    outs <- dittoViz_scatterPlotInputsUI(id = id, data = data, defaults = defaults, title = h3(title), columns = columns)

    tagList(extras, outs)
}


#' Output UI components for the volcanoPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the volcano plot
#' 
#' @import shiny
#'
#' @export
#' @author Jared Andrews
volcanoPlotOutputUI <- function(id) {
    dittoViz_scatterPlotOutputUI(id)
}
