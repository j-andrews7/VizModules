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
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::BarPlot()] parameters are not available via UI inputs:
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{title} - Plot title (plotly allows interactive editing)
#'   \item \code{subtitle} - Plot subtitle (not supported in plotly)
#'   \item \code{aspect.ratio} - Aspect ratio control (handled by plotly layout)
#'   \item \code{legend.position} - Legend positioning (plotly allows interactive repositioning)
#'   \item \code{position} - Bar position (auto, stack, dodge, fill) (not yet implemented)
#'   \item \code{position_dodge_preserve} - Preserve bar width when dodging (not yet implemented)
#'   \item \code{x_sep} - Separator for multiple x columns (not yet implemented)
#'   \item \code{group_by_sep} - Separator for multiple group_by columns (not yet implemented)
#'   \item \code{split_by_sep} - Separator for multiple split_by columns (not yet implemented)
#'   \item \code{flip} - Flip axes (not yet implemented)
#'   \item \code{fill_by_x_if_no_group} - Fill bars by x values (not yet implemented)
#'   \item \code{line_name} - Name of line (not yet implemented)
#'   \item \code{label} - Bar labels on top (not yet implemented)
#'   \item \code{label_nudge} - Label nudge distance (not yet implemented)
#'   \item \code{label_fg} - Label foreground color (not yet implemented)
#'   \item \code{label_size} - Label size (not yet implemented)
#'   \item \code{label_bg} - Label background color (not yet implemented)
#'   \item \code{label_bg_r} - Label background radius (not yet implemented)
#'   \item \code{group_name} - Group legend name (not yet implemented)
#'   \item \code{facet_args} - Additional facet arguments (not yet implemented)
#'   \item \code{add_bg} - Add background stripes (not yet implemented)
#'   \item \code{bg_palette} - Background palette (not yet implemented)
#'   \item \code{bg_palcolor} - Background palette colors (not yet implemented)
#'   \item \code{bg_alpha} - Background alpha (not yet implemented)
#'   \item \code{add_line} - Add horizontal line (not yet implemented)
#'   \item \code{line_color} - Horizontal line color (not yet implemented)
#'   \item \code{line_width} - Horizontal line width (not yet implemented)
#'   \item \code{line_type} - Horizontal line type (not yet implemented)
#'   \item \code{add_trend} - Add trend line (not yet implemented)
#'   \item \code{trend_color} - Trend line color (not yet implemented)
#'   \item \code{trend_linewidth} - Trend line width (not yet implemented)
#'   \item \code{trend_ptsize} - Trend point size (not yet implemented)
#'   \item \code{theme} - ggplot2 theme (managed internally)
#'   \item \code{theme_args} - Theme arguments (not yet implemented)
#'   \item \code{palette} - Managed internally via the palette selection UI
#'   \item \code{x_text_angle} - X-axis text angle (handled by axis.tickangle.x)
#'   \item \code{legend.direction} - Legend orientation (plotly allows interactive adjustment)
#'   \item \code{keep_empty} - Keep empty factor levels (not yet implemented)
#'   \item \code{keep_na} - Keep NA values (not yet implemented)
#'   \item \code{combine} - Combine multiple plots (not applicable for plotly)
#'   \item \code{nrow} - Only applies if \code{split_by} is used with combine
#'   \item \code{ncol} - Only applies if \code{split_by} is used with combine
#'   \item \code{byrow} - Only applies if \code{split_by} is used with combine
#'   \item \code{seed} - Random seed (not applicable)
#'   \item \code{axes} - Only applies if \code{split_by} is used with combine
#'   \item \code{axis_titles} - Only applies if \code{split_by} is used with combine
#'   \item \code{guides} - Only applies if \code{split_by} is used with combine
#'   \item \code{design} - Only applies if \code{split_by} is used with combine
#' }
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::BarPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis variable (UI: "X values", default: 2nd categorical variable)
#'   \item \code{y} - Y-axis variable (UI: "Y values", default: 2nd numeric variable)
#'   \item \code{group_by} - Grouping variable for bar fill (UI: "Group by", default: 2nd categorical variable)
#'   \item \code{split_by} - Split variable for separate plots (UI: "Split by", default: "")
#'   \item \code{facet_by} - Faceting variable (UI: "Facet by", default: "")
#'   \item \code{facet_scales} - Facet scale behavior (UI: "Facet scale", default: "fixed")
#'   \item \code{facet_ncol} - Number of facet columns (UI: "Facet number of columns", default: NULL)
#'   \item \code{facet_nrow} - Number of facet rows (UI: "Facet number of rows", default: NULL)
#'   \item \code{facet_byrow} - Facet ordering direction (UI: "Facet by row", default: TRUE)
#'   \item \code{palcolor} - Custom color values (UI: palette picker, derived from palette)
#'   \item \code{alpha} - Bar fill transparency (UI: "Alpha", default: 1)
#'   \item \code{width} - Bar width (UI: "Width", default: NA)
#'   \item \code{expand} - Axis expansion values (UI: "Expand", default: "")
#'   \item \code{y_min} - Y-axis minimum value (UI: "Y-axis min", default: 0)
#'   \item \code{y_max} - Y-axis maximum value (UI: "Y-axis max", default: max of data)
#' }
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#' \itemize{
#'   \item \code{axis.font.size} - Axis title font size (UI: "Axis font size", default: 18)
#'   \item \code{title.font.size} - Plot title font size (UI: "Title font size", default: 28)
#'   \item \code{title.font.family} - Font family for title text (UI: "Title Font", default: "Arial")
#'   \item \code{text.colour} - Color for axis labels (UI: "Label colour", default: "#000000")
#'   \item \code{axis.showline} - Show axis border lines (UI: "Show axis lines", default: TRUE)
#'   \item \code{axis.mirror} - Mirror axis lines on opposite side (UI: "Mirror axis lines", default: TRUE)
#'   \item \code{show.grid.x} - Show X-axis major gridlines (UI: "Show X major gridlines", default: TRUE)
#'   \item \code{show.grid.y} - Show Y-axis major gridlines (UI: "Show Y major gridlines", default: TRUE)
#'   \item \code{axis.linecolor} - Color of axis lines (UI: "Axis line color", default: "black")
#'   \item \code{axis.linewidth} - Width of axis lines (UI: "Axis line width", default: 0.5)
#'   \item \code{axis.tickfont.size} - Size of tick labels (UI: "Tick label size", default: 12)
#'   \item \code{axis.tickfont.color} - Color of tick labels (UI: "Tick label color", default: "black")
#'   \item \code{axis.tickfont.family} - Font family for tick labels (UI: "Tick label font", default: "Arial")
#'   \item \code{axis.tickangle.x} - Rotation angle for X-axis tick labels (UI: "X-axis tick label angle", default: 0)
#'   \item \code{axis.tickangle.y} - Rotation angle for Y-axis tick labels (UI: "Y-axis tick label angle", default: 0)
#'   \item \code{axis.ticks} - Position of tick marks (UI: "Tick position", default: "outside")
#'   \item \code{axis.tickcolor} - Color of tick marks (UI: "Tick mark color", default: "black")
#'   \item \code{axis.ticklen} - Length of tick marks (UI: "Tick mark length", default: 5)
#'   \item \code{axis.tickwidth} - Width of tick marks (UI: "Tick mark width", default: 1)
#'   \item \code{hline.intercepts} - Y-coordinates for horizontal reference lines (UI: "Y-intercepts", default: "")
#'   \item \code{hline.colors} - Colors for horizontal lines (UI: "Colors", default: "#000000")
#'   \item \code{hline.widths} - Widths for horizontal lines (UI: "Widths", default: "1")
#'   \item \code{hline.linetypes} - Line types for horizontal lines (UI: "Line types", default: "dashed")
#'   \item \code{hline.opacities} - Opacities for horizontal lines (UI: "Opacities (0-1)", default: "1")
#'   \item \code{vline.intercepts} - X-coordinates for vertical reference lines (UI: "X-intercepts", default: "")
#'   \item \code{vline.colors} - Colors for vertical lines (UI: "Colors", default: "#000000")
#'   \item \code{vline.widths} - Widths for vertical lines (UI: "Widths", default: "1")
#'   \item \code{vline.linetypes} - Line types for vertical lines (UI: "Line types", default: "dashed")
#'   \item \code{vline.opacities} - Opacities for vertical lines (UI: "Opacities (0-1)", default: "1")
#'   \item \code{abline.slopes} - Slopes for diagonal reference lines (UI: "Slopes", default: "")
#'   \item \code{abline.intercepts} - Y-intercepts for diagonal lines (UI: "Y-intercepts", default: "")
#'   \item \code{abline.colors} - Colors for diagonal lines (UI: "Colors", default: "#000000")
#'   \item \code{abline.widths} - Widths for diagonal lines (UI: "Widths", default: "1")
#'   \item \code{abline.linetypes} - Line types for diagonal lines (UI: "Line types", default: "dashed")
#'   \item \code{abline.opacities} - Opacities for diagonal lines (UI: "Opacities (0-1)", default: "1")
#' }
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
#' @importFrom shinyBS tipify
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
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    char.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]

    # Axis range values
    if (length(num.choices) >= 2) {
        max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE)
    } else {
        max.y <- 1
    }
    min.y <- 0

    selected <- list(
        "x", "y", "group_by", "fill_by",
        "facet_by", "facet_scales", "facet_ncol", "facet_nrow", "facet_byrow",
        "split_by", "alpha", "width", "expand", "y_min", "y_max"
    )

    documentParameters <- get_documentation(
        package_name = "plotthis::BarPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
    "Data" = tagList(
        tipify(selectInput(ns("x.data"), "X values:",
        selected = .get_default(defaults, "x.data", char.choices[2],
            function(x) x %in% char.choices),
        choices = char.choices
        ), documentParameters$x, placement = "top", options = list(container = "body")),
        tipify(selectInput(ns("y.data"), "Y values:",
        selected = .get_default(defaults, "y.data", num.choices[2],
            function(x) x %in% num.choices),
        choices = num.choices
        ), documentParameters$y, placement = "top", options = list(container = "body")),
        tipify(selectInput(ns("group.by"), "Group by:",
        selected = .get_default(defaults, "group.by", char.choices[2],
            function(x) x %in% c("", names(data))),
        choices = c("", names(data))
        ), documentParameters$group_by, placement = "top", options = list(container = "body")),
        tipify(selectInput(ns("fill.by"), "Fill by:",
        selected = "", choices = c("", names(data))),
            documentParameters$fill_by, placement = "top", options = list(container = "body"))
    ),

    "Facet" = tagList(
        tipify(selectInput(ns("facet.by"), "Facet by:",
        selected = "", choices = c(char.choices, "")
        ), documentParameters$facet_by, placement = "top", options = list(container = "body")),
        tipify(selectInput(ns("facet.scale"), "Facet scale:",
        selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")
        ), documentParameters$facet_scales, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("facet.ncol"), "Facet number of columns:",
        value = NULL, min = 0, max = 20
        ), documentParameters$facet_ncol, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("facet.nrow"), "Facet number of rows:",
        value = NULL, min = 0, max = 20
        ), documentParameters$facet_nrow, placement = "top", options = list(container = "body")),
        tipify(materialSwitch(ns("facet.by.row"), "Facet by row:",
        value = TRUE, status = "success"),
            documentParameters$facet_byrow, placement = "top", options = list(container = "body")),
        tipify(selectInput(ns("split.by"), "Split by:",
        selected = "", choices = c(char.choices, "")
        ), documentParameters$split_by, placement = "top", options = list(container = "body"))
    ),

    "Aesthetics" = tagList(
        uiOutput(ns("palette.selection")),
        tipify(numericInput(ns("alpha"), "Alpha", value = 1, min = 0, max = 1),
            documentParameters$alpha, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("width"), "Width", value = NA),
            documentParameters$width, placement = "top", options = list(container = "body")),
        tipify(textInput(ns("expand"), "Expand", value = "",
        placeholder = "e.g. 1,2,3,4"
        ), documentParameters$expand, placement = "top", options = list(container = "body"))
    ),

    "Adjustments" = tagList(
        tipify(numericInput(ns("y.min"), "Y-axis min:",
            value = min.y
        ), documentParameters$y_min, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("y.max"), "Y-axis max:",
            value = max.y
        ), documentParameters$y_max, placement = "top", options = list(container = "body"))
    ),

    "Plotly" = .uniform_plotly_inputs_ui(ns, defaults),
    "Axes" = uiOutput(ns("axes_control")),
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
#' @author Jacob Martin, Jared Andrews
plotthis_BarPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("BarPlot"))
    )
}
