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
#'
#' - `xlab` - X-axis label (plotly allows interactive editing)
#' - `ylab` - Y-axis label (plotly allows interactive editing)
#' - `title` - Plot title (plotly allows interactive editing)
#' - `subtitle` - Plot subtitle (not supported in plotly)
#' - `aspect.ratio` - Aspect ratio control (handled by plotly layout)
#' - `legend.position` - Legend positioning (plotly allows interactive repositioning)
#' - `position` - Bar position (auto, stack, dodge, fill) (not yet implemented)
#' - `position_dodge_preserve` - Preserve bar width when dodging (not yet implemented)
#' - `x_sep` - Separator for multiple x columns (not yet implemented)
#' - `group_by_sep` - Separator for multiple group_by columns (not yet implemented)
#' - `split_by_sep` - Separator for multiple split_by columns (not yet implemented)
#' - `fill_name` - Name of the fill legend (not yet implemented)
#' - `line_name` - Name of line (not yet implemented)
#' - `label` - Bar labels on top (not yet implemented)
#' - `label_nudge` - Label nudge distance (not yet implemented)
#' - `label_fg` - Label foreground color (not yet implemented)
#' - `label_size` - Label size (not yet implemented)
#' - `label_bg` - Label background color (not yet implemented)
#' - `label_bg_r` - Label background radius (not yet implemented)
#' - `group_name` - Group legend name (not yet implemented)
#' - `facet_args` - Additional facet arguments (not yet implemented)
#' - `add_bg` - Add background stripes (not yet implemented)
#' - `bg_palette` - Background palette (not yet implemented)
#' - `bg_palcolor` - Background palette colors (not yet implemented)
#' - `bg_alpha` - Background alpha (not yet implemented)
#' - `add_line` - Add horizontal line (not yet implemented)
#' - `line_color` - Horizontal line color (not yet implemented)
#' - `line_width` - Horizontal line width (not yet implemented)
#' - `line_type` - Horizontal line type (not yet implemented)
#' - `add_trend` - Add trend line (not yet implemented)
#' - `trend_color` - Trend line color (not yet implemented)
#' - `trend_linewidth` - Trend line width (not yet implemented)
#' - `trend_ptsize` - Trend point size (not yet implemented)
#' - `theme` - ggplot2 theme (managed internally)
#' - `theme_args` - Theme arguments (not yet implemented)
#' - `palette` - Managed internally via the palette selection UI
#' - `x_text_angle` - X-axis text angle (handled by axis.tickangle.x)
#' - `legend.direction` - Legend orientation (plotly allows interactive adjustment)
#' - `keep_empty` - Keep empty factor levels (not yet implemented)
#' - `keep_na` - Keep NA values (not yet implemented)
#' - `combine` - Combine multiple plots (not applicable for plotly)
#' - `nrow` - Only applies if `split_by` is used with combine
#' - `ncol` - Only applies if `split_by` is used with combine
#' - `byrow` - Only applies if `split_by` is used with combine
#' - `seed` - Random seed (not applicable)
#' - `axes` - Only applies if `split_by` is used with combine
#' - `axis_titles` - Only applies if `split_by` is used with combine
#' - `guides` - Only applies if `split_by` is used with combine
#' - `design` - Only applies if `split_by` is used with combine
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::BarPlot()] parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x` - X-axis variable (UI: "X values", default: 2nd categorical variable)
#' - `y` - Y-axis variable (UI: "Y values", default: 2nd numeric variable)
#' - `group_by` - Grouping variable for bar fill (UI: "Group by", default: 2nd categorical variable)
#' - `fill_by` - Variable used to fill the bars (UI: "Fill by", default: "")
#' - `flip` - Flip/swap the x and y axes (UI: "Rotate (swap X/Y)", default: FALSE)
#' - `split_by` - Split variable for separate plots (UI: "Split by", default: "")
#' - `facet_by` - Faceting variable (UI: "Facet by", default: "")
#' - `facet_scales` - Facet scale behavior (UI: "Facet scale", default: "fixed")
#' - `facet_ncol` - Number of facet columns (UI: "Facet number of columns", default: NULL)
#' - `facet_nrow` - Number of facet rows (UI: "Facet number of rows", default: NULL)
#' - `facet_byrow` - Facet ordering direction (UI: "Facet by row", default: TRUE)
#' - `palcolor` - Custom color values (UI: palette picker, derived from palette)
#' - `palreverse` - Reverse the color palette (UI: "Reverse palette", default: FALSE)
#' - `alpha` - Bar fill transparency (UI: "Alpha", default: 1)
#' - `width` - Bar width (UI: "Width", default: NA)
#' - `expand` - Axis expansion values (UI: "Expand", default: "")
#' - `y_min` - Y-axis minimum value (UI: "Y-axis min", default: 0)
#' - `y_max` - Y-axis maximum value (UI: "Y-axis max", default: max of data)
#' - `lower_quantile` - Lower quantile for the continuous fill color scale
#'   (UI: "Lower Quantile", default: 0); only affects a numeric `fill_by`
#' - `upper_quantile` - Upper quantile for the continuous fill color scale
#'   (UI: "Upper Quantile", default: 1); only affects a numeric `fill_by`
#' - `lower_cutoff` - Explicit lower cutoff for the continuous fill color scale
#'   (UI: "Lower Cutoff", default: NA); overrides `lower_quantile` when set
#' - `upper_cutoff` - Explicit upper cutoff for the continuous fill color scale
#'   (UI: "Upper Cutoff", default: NA); overrides `upper_quantile` when set
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#'
#' - `title.font.size` - Plot title font size (UI: "Title Size", default: 26)
#' - `title.font.family` - Font family for title text (UI: "Title Font", default: "Arial")
#' - `title.font.color` - Color for plot title (UI: "Title Color", default: "#000000")
#' - `axis.title.font.size` - Axis title font size (UI: "Axis Title Size", default: 18)
#' - `axis.title.font.color` - Axis title font color (UI: "Axis Title Color", default: "#000000")
#' - `axis.title.font.family` - Axis title font family (UI: "Axis Title Font", default: "Arial")
#' - `axis.showline` - Show axis border lines (UI: "Show axis lines", default: TRUE)
#' - `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror axis lines", default: TRUE)
#' - `show.grid.x` - Show X-axis major gridlines (UI: "Show X major gridlines", default: TRUE)
#' - `show.grid.y` - Show Y-axis major gridlines (UI: "Show Y major gridlines", default: TRUE)
#' - `axis.linecolor` - Color of axis lines (UI: "Axis line color", default: "black")
#' - `axis.linewidth` - Width of axis lines (UI: "Axis line width", default: 0.5)
#' - `axis.tickfont.size` - Size of tick labels (UI: "Tick label size", default: 12)
#' - `axis.tickfont.color` - Color of tick labels (UI: "Tick label color", default: "black")
#' - `axis.tickfont.family` - Font family for tick labels (UI: "Tick label font", default: "Arial")
#' - `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI: "X-axis tick label angle", default: 0)
#' - `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI: "Y-axis tick label angle", default: 0)
#' - `axis.ticks` - Position of tick marks (UI: "Tick position", default: "outside")
#' - `axis.tickcolor` - Color of tick marks (UI: "Tick mark color", default: "black")
#' - `axis.ticklen` - Length of tick marks (UI: "Tick mark length", default: 5)
#' - `axis.tickwidth` - Width of tick marks (UI: "Tick mark width", default: 1)
#' - `hline.intercepts` - Y-coordinates for horizontal reference lines (UI: "Y-intercepts", default: "")
#' - `hline.colors` - Colors for horizontal lines (UI: "Colors", default: "#000000")
#' - `hline.widths` - Widths for horizontal lines (UI: "Widths", default: "1")
#' - `hline.linetypes` - Line types for horizontal lines (UI: "Line types", default: "dashed")
#' - `hline.opacities` - Opacities for horizontal lines (UI: "Opacities (0-1)", default: "1")
#' - `vline.intercepts` - X-coordinates for vertical reference lines (UI: "X-intercepts", default: "")
#' - `vline.colors` - Colors for vertical lines (UI: "Colors", default: "#000000")
#' - `vline.widths` - Widths for vertical lines (UI: "Widths", default: "1")
#' - `vline.linetypes` - Line types for vertical lines (UI: "Line types", default: "dashed")
#' - `vline.opacities` - Opacities for vertical lines (UI: "Opacities (0-1)", default: "1")
#' - `abline.slopes` - Slopes for diagonal reference lines (UI: "Slopes", default: "")
#' - `abline.intercepts` - Y-intercepts for diagonal lines (UI: "Y-intercepts", default: "")
#' - `abline.colors` - Colors for diagonal lines (UI: "Colors", default: "#000000")
#' - `abline.widths` - Widths for diagonal lines (UI: "Widths", default: "1")
#' - `abline.linetypes` - Line types for diagonal lines (UI: "Line types", default: "dashed")
#' - `abline.opacities` - Opacities for diagonal lines (UI: "Opacities (0-1)", default: "1")
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
#' @param defaults A named list of default values for the inputs. An entry may also be a
#'   [shiny::reactive()] or [shiny::reactiveVal()]; it is resolved with [shiny::isolate()] to
#'   seed the control, and the module then keeps it live (see [setup_reactive_defaults()]).
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
        "split_by", "alpha", "width", "expand", "y_min", "y_max", "palreverse",
        c("lower_quantile", "upper_quantile"), c("lower_cutoff", "upper_cutoff")
    )

    documentParameters <- get_documentation(
        package_name = "plotthis::BarPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
    "Data" = tagList(
        tipify(viz_select_input(ns("x.data"), "X Values",
        selected = get_default(defaults, "x.data", char.choices[2],
            function(x) x %in% char.choices),
        choices = char.choices
        ), documentParameters$x, placement = "top", options = list(container = "body")),
        tipify(viz_select_input(ns("y.data"), "Y Values",
        selected = get_default(defaults, "y.data", num.choices[2],
            function(x) x %in% num.choices),
        choices = num.choices
        ), documentParameters$y, placement = "top", options = list(container = "body")),
        tipify(viz_select_input(ns("group.by"), "Group By",
        selected = get_default(defaults, "group.by", char.choices[2],
            function(x) x %in% c("", names(data))),
        choices = c("", names(data))
        ), documentParameters$group_by, placement = "top", options = list(container = "body")),
        tipify(viz_select_input(ns("fill.by"), "Fill By",
        selected = get_default(defaults, "fill.by", "", function(x) x == "" || x %in% names(data)),
            choices = c("", names(data))),
            documentParameters$fill_by, placement = "top", options = list(container = "body"))
    ),

    "Facet" = tagList(
        tipify(viz_select_input(ns("facet.by"), "Facet By",
        selected = get_default(defaults, "facet.by", "", function(x) x == "" || x %in% char.choices),
        choices = c("", .facet_check(data))
        ), documentParameters$facet_by, placement = "top", options = list(container = "body")),
        tipify(viz_select_input(ns("facet.scale"), "Facet Scale",
        selected = get_default(
            defaults, "facet.scale", "fixed",
            function(x) x %in% c("fixed", "free", "free_x", "free_y")
        ),
        choices = c("fixed", "free", "free_x", "free_y")
        ), documentParameters$facet_scales, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("facet.ncol"), "Columns",
        value = get_default(defaults, "facet.ncol", NULL, is.numeric), min = 0, max = 20
        ), documentParameters$facet_ncol, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("facet.nrow"), "Rows",
        value = get_default(defaults, "facet.nrow", NULL, is.numeric), min = 0, max = 20
        ), documentParameters$facet_nrow, placement = "top", options = list(container = "body")),
        tipify(materialSwitch(ns("facet.by.row"), "Facet by Row",
        value = get_default(defaults, "facet.by.row", TRUE, is.logical), status = "success"),
            documentParameters$facet_byrow, placement = "top", options = list(container = "body")),
        tipify(viz_select_input(ns("split.by"), "Split By",
        selected = get_default(defaults, "split.by", "", function(x) x == "" || x %in% char.choices),
        choices = c(char.choices, "")
        ), documentParameters$split_by, placement = "top", options = list(container = "body")),
        .uniform_subplot_spacing_inputs_ui(ns, defaults)
    ),

    "Aesthetics" = tagList(
        uiOutput(ns("palette.selection")),
        tipify(numericInput(ns("alpha"), "Alpha",
            value = get_default(defaults, "alpha", 1, is.numeric), min = 0, max = 1),
            documentParameters$alpha, placement = "top", options = list(container = "body")),
        tipify(materialSwitch(ns("palreverse"), "Reverse Palette",
        value = get_default(defaults, "palreverse", FALSE, is.logical), status = "success"),
            documentParameters$palreverse, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("width"), "Width",
            value = get_default(defaults, "width", NA, is.numeric)),
            documentParameters$width, placement = "top", options = list(container = "body")),
        tipify(textInput(ns("expand"), "Expand",
            value = get_default(defaults, "expand", ""),
        placeholder = "e.g. 1,2,3,4"
        ), documentParameters$expand, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("lower.quantile"), "Lower Quantile",
            value = get_default(defaults, "lower.quantile", 0, is.numeric),
            min = 0, max = 1, step = 0.01
        ), documentParameters$lower_quantile, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("upper.quantile"), "Upper Quantile",
            value = get_default(defaults, "upper.quantile", 1, is.numeric),
            min = 0, max = 1, step = 0.01
        ), documentParameters$upper_quantile, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("lower.cutoff"), "Lower Cutoff",
            value = get_default(defaults, "lower.cutoff", NA, is.numeric)
        ), documentParameters$lower_cutoff, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("upper.cutoff"), "Upper Cutoff",
            value = get_default(defaults, "upper.cutoff", NA, is.numeric)
        ), documentParameters$upper_cutoff, placement = "top", options = list(container = "body"))
    ),

    "Adjustments" = tagList(
        tipify(numericInput(ns("y.min"), "Y-axis Min",
            value = get_default(defaults, "y.min", min.y, is.numeric)
        ), documentParameters$y_min, placement = "top", options = list(container = "body")),
        tipify(numericInput(ns("y.max"), "Y-axis Max",
            value = get_default(defaults, "y.max", max.y, is.numeric)
        ), documentParameters$y_max, placement = "top", options = list(container = "body"))
    ),

    "Legend" = uniform_legend_inputs_ui(ns, defaults),

    "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
    "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
    "Lines" = uniform_lines_inputs_ui(ns, defaults)
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
#' @param resizable Logical; when `TRUE` (the default) the plot output
#'   is wrapped in [shinyjqui::jqui_resizable()] so it can be resized
#'   by dragging. Set to `FALSE` when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the BarPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
plotthis_BarPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("BarPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
