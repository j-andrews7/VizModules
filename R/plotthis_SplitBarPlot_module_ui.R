#' Input UI components for the SplitBarPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `plotthis_SplitBarPlotServer()` and `plotthis_SplitBarPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::SplitBarPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#' 
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::SplitBarPlot()] parameters are not available via UI inputs:
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{title} - Plot title (plotly allows interactive editing)
#'   \item \code{subtitle} - Plot subtitle (not supported in plotly)
#'   \item \code{aspect.ratio} - Aspect ratio control (handled by plotly layout)
#'   \item \code{legend.position} - Legend positioning (plotly allows interactive repositioning)
#'   \item \code{y} - Y-axis variable (automatically set from data structure)
#'   \item \code{y_sep} - Separator for y columns (not applicable in UI context)
#'   \item \code{flip} - Flip axes (not implemented in current UI)
#'   \item \code{split_by_sep} - Separator for split columns (not applicable in UI context)
#'   \item \code{order_y} - Y-axis ordering rules (handled by default logic)
#'   \item \code{lineheight} - Text line height (not applicable in plotly)
#'   \item \code{max_charwidth} - Maximum character width (not applicable in plotly)
#'   \item \code{fill_by_sep} - Separator for fill columns (not applicable in UI context)
#'   \item \code{fill_name} - Fill legend name (handled by plotly)
#'   \item \code{direction_pos_name} - Positive direction name (not implemented)
#'   \item \code{direction_neg_name} - Negative direction name (not implemented)
#'   \item \code{theme} - ggplot2 theme (not applicable in plotly)
#'   \item \code{theme_args} - Theme arguments (not applicable in plotly)
#'   \item \code{palette} - Managed internally via the palette selection UI
#'   \item \code{keep_empty} - Keep empty values (not implemented)
#'   \item \code{keep_na} - Keep NA values (not implemented)
#'   \item \code{combine} - Only applies if `split_by` is used
#'   \item \code{nrow} - Only applies if `split_by` is used
#'   \item \code{ncol} - Only applies if `split_by` is used
#'   \item \code{byrow} - Only applies if `split_by` is used
#'   \item \code{seed} - Random seed (not applicable)
#'   \item \code{axes} - Only applies if `split_by` is used
#'   \item \code{axis_titles} - Only applies if `split_by` is used
#'   \item \code{guides} - Only applies if `split_by` is used
#'   \item \code{design} - Only applies if `split_by` is used
#'   \item \code{legend_direction} - Managed position of legend however this can be handled via plotly
#' }
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::SplitBarPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis variable (UI: "X values", default: 2nd numeric variable)
#'   \item \code{fill_by} - Fill color variable (UI: "Fill by", default: 2nd variable)
#'   \item \code{alpha_by} - Variable for alpha transparency (UI: "Alpha by", default: "")
#'   \item \code{alpha_reverse} - Reverse alpha order (UI: "Alpha reverse", default: FALSE)
#'   \item \code{alpha_name} - Alpha legend name (UI: "Alpha name", default: "")
#'   \item \code{bar_height} - Height of bars (UI: "Bar height", default: 0.9)
#'   \item \code{facet_by} - Faceting variable (UI: "Facet by", default: "")
#'   \item \code{facet_scales} - Facet scale behavior (UI: "Facet scale", default: "free_y")
#'   \item \code{facet_ncol} - Number of facet columns (UI: "Facet number of columns", default: NULL)
#'   \item \code{facet_nrow} - Number of facet rows (UI: "Facet number of rows", default: NULL)
#'   \item \code{facet_byrow} - Facet ordering direction (UI: "Facet by row", default: TRUE)
#'   \item \code{split_by} - Split variable (UI: "Split by", default: "")
#'   \item \code{x_min} - Minimum X-axis value (UI: "X-axis min", default: calculated from data)
#'   \item \code{x_max} - Maximum X-axis value (UI: "X-axis max", default: calculated from data)
#'   \item \code{palcolor} - Custom color values (UI: palette picker, derived from palette)
#' }
#' 
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#' \itemize{
#'   \item \code{label.on.y.axis} - Show category labels on the Y axis instead of on the plot (UI: "Labels on Y axis", default: FALSE).
#'     When enabled, the text position slider is hidden and labels appear as Y-axis tick labels.
#'   \item \code{text.position} - Position of category labels along the X axis (UI: "Position of category labels", default: 0).
#'     Only visible when \code{label.on.y.axis} is FALSE.
#'   \item \code{axis.font.size} - Axis title font size (UI: "Axis font size", default: 18)
#'   \item \code{title.font.size} - Plot title font size (UI: "Title font size", default: 28)
#'   \item \code{font.type} - Font family for plot text (UI: "Font", default: "Arial")
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
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom shinyBS tipify
#'
#' @export
#' @author Jacob Martin
#' @seealso [plotthis::SplitBarPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_SplitBarPlotOutputUI()], [VizModules::plotthis_SplitBarPlotServer()], [VizModules::plotthis_SplitBarPlotApp()]
#' @examples
#' library(VizModules)
#' mtcars$cyl <- as.factor(mtcars$cyl)
#' plotthis_SplitBarPlotInputsUI("splitBarPlot", mtcars)
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

    selected <- c("x", "fill_by", "alpha_by", "alpha_reverse", "alpha_name",
            "bar_height", "facet_by", "facet_scales", "facet_ncol", "facet_nrow",
            "facet_byrow", "split_by", "x_min", "x_max")

    documentParameters <- .get_documentation(
        package_name = "plotthis::SplitBarPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
      "Data" = tagList(
      tipify(selectInput(ns("x.data"), "X values",
        selected = num.choices[2], choices = num.choices
      ), documentParameters$x, placement = "top"),
      selectInput(ns("y.data"), "Y values",
        selected = char.choices[2], choices = char.choices
      ),
      # Changed from group.by to fill.by
      tipify(selectInput(ns("fill.by"), "Fill by",
        selected = choices[2], choices = choices
      ), documentParameters$fill_by, placement = "top")),


    "Facet" = tagList(
        tipify(selectInput(ns("facet.by"), "Facet by",
        selected = "", choices = c(char.choices, "")
        ), documentParameters$facet_by, placement = "top"),
        tipify(selectInput(ns("facet.scale"), "Facet scale",
        selected = "free_y", choices = c("fixed", "free", "free_x", "free_y")
        ), documentParameters$facet_scales, placement = "top"),
        tipify(numericInput(ns("facet.ncol"), "Facet number of columns",
        value = NULL, min = 0, max = 20
        ), documentParameters$facet_ncol, placement = "top"),
        tipify(numericInput(ns("facet.nrow"), "Facet number of rows",
        value = NULL, min = 0, max = 20
        ), documentParameters$facet_nrow, placement = "top"),
        tipify(materialSwitch(ns("facet.by.row"), "Facet by row",
        value = TRUE, status = "success"),
            documentParameters$facet_byrow, placement = "top"),
        tipify(selectInput(ns("split.by"), "Split by",
        selected = "", choices = c(char.choices, "")
        ), documentParameters$split_by, placement = "top")
    ),

    "Aesthetics" = tagList(
        uiOutput(ns("palette.selection")),
        tipify(selectInput(ns("alpha.by"), "Alpha by", selected = "", choices = c("", num.choices)),
            documentParameters$alpha_by, placement = "top"),
        tipify(materialSwitch(ns("alpha.reverse"), "Alpha reverse", value = FALSE, status = "success"),
            documentParameters$alpha_reverse, placement = "top"),
        tipify(textInput(ns("alpha.name"), "Alpha name", value = ""),
            documentParameters$alpha_name, placement = "top"),
        tipify(numericInput(ns("bar.height"), "Bar height", value = 0.9, min = 0),
            documentParameters$bar_height, placement = "top"),
        sliderInput(ns("axis.scale.factor"), "Factor to which the bars fill the axis", min = 0, max = 5, value = 1.2, step = 0.2),
        materialSwitch(ns("label.on.y.axis"), "Labels on Y axis", value = FALSE, status = "success"),
        sliderInput(ns("text.position"), "Position of category labels: ", value = 0, min = -100, max = 100)

    ),

    "Adjustments" = tagList(
        tipify(numericInput(ns("x.min"), "X-axis min:",
            value = min.x
        ), documentParameters$x_min, placement = "top"),
        tipify(numericInput(ns("x.max"), "X-axis max:",
            value = max.x
        ), documentParameters$x_max, placement = "top")
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
