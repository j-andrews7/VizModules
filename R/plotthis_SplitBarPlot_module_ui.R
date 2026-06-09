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
#'   \item \code{x} - X-axis variable (UI: "X values", defaults key: \code{x.data}, default: 2nd numeric variable)
#'   \item \code{y} - Y-axis grouping variable (UI: "Y values", defaults key: \code{y.data}, default: 2nd categorical variable)
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
#'   \item \code{title.font.size} - Plot title font size (UI: "Title Size", default: 26)
#'   \item \code{title.font.family} - Font family for title text (UI: "Title Font", default: "Arial")
#'   \item \code{title.font.color} - Color for plot title (UI: "Title Color", default: "#000000")
#'   \item \code{axis.title.font.size} - Axis title font size (UI: "Axis Title Size", default: 18)
#'   \item \code{axis.title.font.color} - Axis title font color (UI: "Axis Title Color", default: "#000000")
#'   \item \code{axis.title.font.family} - Axis title font family (UI: "Axis Title Font", default: "Arial")
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
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    char.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.x <- max(numeric.data, na.rm = TRUE)
    min.x <- min(numeric.data, na.rm = TRUE)

    selected <- list(
        "x", "fill_by", "alpha_by", "alpha_reverse", "alpha_name",
        "bar_height", "facet_by", "facet_scales", "facet_ncol", "facet_nrow",
        "facet_byrow", "split_by", "x_min", "x_max"
    )

    documentParameters <- get_documentation(
        package_name = "plotthis::SplitBarPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
      "Data" = tagList(
      tipify(selectInput(ns("x.data"), "X Values",
        selected = .get_default(defaults, "x.data", num.choices[2],
            function(x) x %in% num.choices),
        choices = num.choices, selectize = FALSE
      ), documentParameters$x, placement = "top", options = list(container = "body")),
      tipify(selectInput(ns("y.data"), "Y Values",
        selected = .get_default(defaults, "y.data", char.choices[2],
            function(x) x %in% char.choices),
        choices = char.choices, selectize = FALSE
      ), "Select the categorical column to use for the Y axis groupings",
        placement = "top", options = list(container = "body")),
      # Changed from group.by to fill.by
      tipify(selectInput(ns("fill.by"), "Fill By",
        selected = .get_default(defaults, "fill.by", choices[2],
            function(x) x %in% choices),
        choices = choices, selectize = FALSE
      ), documentParameters$fill_by, placement = "top", options = list(container = "body"))),


    "Facet" = tagList(
        tipify(selectInput(ns("facet.by"), "Facet By",
        selected = .get_default(defaults, "facet.by", "", function(x) x == "" || x %in% char.choices),
        choices = c(char.choices, ""), selectize = FALSE
        ), documentParameters$facet_by, placement = "top", options = list(container = "body")),
        tipify(selectInput(ns("facet.scale"), "Facet Scale",
        selected = .get_default(
            defaults, "facet.scale", "free_y",
            function(x) x %in% c("fixed", "free", "free_x", "free_y")
        ),
        choices = c("fixed", "free", "free_x", "free_y"), selectize = FALSE
        ), documentParameters$facet_scales, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("facet.ncol"), "Columns",
        value = .get_default(defaults, "facet.ncol", NULL, is.numeric), min = 0, max = 20
        ), documentParameters$facet_ncol, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("facet.nrow"), "Rows",
        value = .get_default(defaults, "facet.nrow", NULL, is.numeric), min = 0, max = 20
        ), documentParameters$facet_nrow, placement = "top", options = list(container = "body")),
        tipify(materialSwitch(ns("facet.by.row"), "Facet by Row",
        value = .get_default(defaults, "facet.by.row", TRUE, is.logical), status = "success"),
            documentParameters$facet_byrow, placement = "top", options = list(container = "body")),
        tipify(selectInput(ns("split.by"), "Split By",
        selected = .get_default(defaults, "split.by", "", function(x) x == "" || x %in% char.choices),
        choices = c(char.choices, ""), selectize = FALSE
        ), documentParameters$split_by, placement = "top", options = list(container = "body"))
    ),

    "Aesthetics" = tagList(
        uiOutput(ns("palette.selection")),
        tipify(selectInput(ns("alpha.by"), "Alpha By",
            selected = .get_default(defaults, "alpha.by", "", function(x) x == "" || x %in% num.choices),
            choices = c("", num.choices), selectize = FALSE),
            documentParameters$alpha_by, placement = "top", options = list(container = "body")),
        tipify(materialSwitch(ns("alpha.reverse"), "Alpha Reverse",
            value = .get_default(defaults, "alpha.reverse", FALSE, is.logical), status = "success"),
            documentParameters$alpha_reverse, placement = "top", options = list(container = "body")),
        tipify(textInput(ns("alpha.name"), "Alpha Name",
            value = .get_default(defaults, "alpha.name", "")),
            documentParameters$alpha_name, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("bar.height"), "Bar Height",
            value = .get_default(defaults, "bar.height", 0.9, is.numeric), min = 0),
            documentParameters$bar_height, placement = "top", options = list(container = "body")),
        tipify(sliderInput(ns("axis.scale.factor"), "Axis Scale Factor",
            min = 0, max = 5, value = .get_default(defaults, "axis.scale.factor", 1.2, is.numeric), step = 0.2),
            "Scale factor controlling how much of the axis range the bars fill. Values above 1 extend beyond the data range",
            placement = "top", options = list(container = "body")),
        tipify(materialSwitch(ns("label.on.y.axis"), "Labels on Y Axis",
            value = .get_default(defaults, "label.on.y.axis", FALSE, is.logical), status = "success"),
            "When enabled, category labels are shown as Y-axis tick labels instead of being placed on the plot area",
            placement = "top", options = list(container = "body")),
        tipify(sliderInput(ns("text.position"), "Category Label Position",
            value = .get_default(defaults, "text.position", 0, is.numeric), min = 0, max = 100),
            "Adjust the horizontal position of category labels along the X axis when labels are shown on the plot",
            placement = "top", options = list(container = "body"))

    ),

    "Adjustments" = tagList(
        tipify(numericInput(ns("x.min"), "X-axis Min",
            value = .get_default(defaults, "x.min", min.x, is.numeric)
        ), documentParameters$x_min, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("x.max"), "X-axis Max",
            value = .get_default(defaults, "x.max", max.x, is.numeric)
        ), documentParameters$x_max, placement = "top", options = list(container = "body"))
    ),


    "Plotly" = .uniform_plotly_inputs_ui(ns, defaults),
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
#' @param resizable Logical; when \code{TRUE} (the default) the plot output
#'   is wrapped in \code{\link[shinyjqui]{jqui_resizable}} so it can be resized
#'   by dragging. Set to \code{FALSE} when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the SplitBarPlot
#'
#' @import shiny
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_SplitBarPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("SplitBarPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
