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
#'
#' - `xlab` - X-axis label (plotly allows interactive editing)
#' - `ylab` - Y-axis label (plotly allows interactive editing)
#' - `title` - Plot title (plotly allows interactive editing)
#' - `subtitle` - Plot subtitle (not supported in plotly)
#' - `aspect.ratio` - Aspect ratio control (handled by plotly layout)
#' - `legend.position` - Legend positioning (plotly allows interactive repositioning)
#' - `y_sep` - Separator for y columns (not applicable in UI context)
#' - `split_by_sep` - Separator for split columns (not applicable in UI context)
#' - `order_y` - Y-axis ordering rules (handled by default logic)
#' - `lineheight` - Text line height (not applicable in plotly)
#' - `max_charwidth` - Maximum character width (not applicable in plotly)
#' - `fill_by_sep` - Separator for fill columns (not applicable in UI context)
#' - `fill_name` - Fill legend name (handled by plotly)
#' - `direction_name` - Direction legend name (not implemented)
#' - `direction_pos_name` - Positive direction name (not implemented)
#' - `direction_neg_name` - Negative direction name (not implemented)
#' - `theme` - ggplot2 theme (not applicable in plotly)
#' - `theme_args` - Theme arguments (not applicable in plotly)
#' - `palette` - Managed internally via the palette selection UI
#' - `keep_empty` - Keep empty values (not implemented)
#' - `keep_na` - Keep NA values (not implemented)
#' - `combine` - Only applies if `split_by` is used
#' - `nrow` - Only applies if `split_by` is used
#' - `ncol` - Only applies if `split_by` is used
#' - `byrow` - Only applies if `split_by` is used
#' - `seed` - Random seed (not applicable)
#' - `axes` - Only applies if `split_by` is used
#' - `axis_titles` - Only applies if `split_by` is used
#' - `guides` - Only applies if `split_by` is used
#' - `design` - Only applies if `split_by` is used
#' - `legend.direction` - Managed position of legend however this can be handled via plotly
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::SplitBarPlot()] parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x` - X-axis variable (UI: "X values", defaults key: `x.data`, default: 2nd numeric variable)
#' - `y` - Y-axis grouping variable (UI: "Y values", defaults key: `y.data`, default: 2nd categorical variable)
#' - `fill_by` - Fill color variable (UI: "Fill by", default: 2nd variable)
#' - `flip` - Flip/swap the x and y axes (UI: "Rotate (swap X/Y)", default: FALSE)
#' - `alpha_by` - Variable for alpha transparency (UI: "Alpha by", default: "")
#' - `alpha_reverse` - Reverse alpha order (UI: "Alpha reverse", default: FALSE)
#' - `alpha_name` - Alpha legend name (UI: "Alpha name", default: "")
#' - `bar_height` - Height of bars (UI: "Bar height", default: 0.9)
#' - `facet_by` - Faceting variable (UI: "Facet by", default: "")
#' - `facet_scales` - Facet scale behavior (UI: "Facet scale", default: "free_y")
#' - `facet_ncol` - Number of facet columns (UI: "Facet number of columns", default: NULL)
#' - `facet_nrow` - Number of facet rows (UI: "Facet number of rows", default: NULL)
#' - `facet_byrow` - Facet ordering direction (UI: "Facet by row", default: TRUE)
#' - `split_by` - Split variable (UI: "Split by", default: "")
#' - `x_min` - Minimum X-axis value (UI: "X-axis min", default: calculated from data)
#' - `x_max` - Maximum X-axis value (UI: "X-axis max", default: calculated from data)
#' - `palcolor` - Custom color values (UI: palette picker, derived from palette)
#' - `palreverse` - Reverse the color palette (UI: "Reverse palette", default: FALSE)
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
#' - `label.on.y.axis` - Show category labels on the Y axis instead of on the plot (UI: "Labels on Y axis", default: FALSE).
#'   When enabled, the text position slider is hidden and labels appear as Y-axis tick labels.
#' - `text.position` - Position of category labels along the X axis (UI: "Position of category labels", default: 0).
#'   Only visible when `label.on.y.axis` is FALSE.
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
        "facet_byrow", "split_by", "x_min", "x_max", "palreverse",
        c("lower_quantile", "upper_quantile"), c("lower_cutoff", "upper_cutoff")
    )

    documentParameters <- get_documentation(
        package_name = "plotthis::SplitBarPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(viz_select_input(ns("x.data"), "X Values",
                selected = get_default(
                    defaults, "x.data", num.choices[2],
                    function(x) x %in% num.choices
                ),
                choices = num.choices
            ), documentParameters$x, placement = "top", options = list(container = "body")),
            tipify(
                viz_select_input(ns("y.data"), "Y Values",
                    selected = get_default(
                        defaults, "y.data", char.choices[2],
                        function(x) x %in% char.choices
                    ),
                    choices = char.choices
                ), "Select the categorical column to use for the Y axis groupings",
                placement = "top", options = list(container = "body")
            ),
            # Changed from group.by to fill.by
            tipify(viz_select_input(ns("fill.by"), "Fill By",
                selected = get_default(
                    defaults, "fill.by", choices[2],
                    function(x) x %in% choices
                ),
                choices = choices
            ), documentParameters$fill_by, placement = "top", options = list(container = "body"))
        ),
        "Facet" = tagList(
            tipify(viz_select_input(ns("facet.by"), "Facet By",
                selected = get_default(defaults, "facet.by", "", function(x) x == "" || x %in% char.choices),
                choices = c("", .facet_check(data))
            ), documentParameters$facet_by, placement = "top", options = list(container = "body")),
            tipify(viz_select_input(ns("facet.scale"), "Facet Scale",
                selected = get_default(
                    defaults, "facet.scale", "free_y",
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
            tipify(
                materialSwitch(ns("facet.by.row"), "Facet by Row",
                    value = get_default(defaults, "facet.by.row", TRUE, is.logical), status = "success"
                ),
                documentParameters$facet_byrow,
                placement = "top", options = list(container = "body")
            ),
            tipify(viz_select_input(ns("split.by"), "Split By",
                selected = get_default(defaults, "split.by", "", function(x) x == "" || x %in% char.choices),
                choices = c(char.choices, "")
            ), documentParameters$split_by, placement = "top", options = list(container = "body")),
            .uniform_subplot_spacing_inputs_ui(ns, defaults)
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            tipify(
                materialSwitch(ns("palreverse"), "Reverse Palette",
                    value = get_default(defaults, "palreverse", FALSE, is.logical), status = "success"
                ),
                documentParameters$palreverse,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                viz_select_input(ns("alpha.by"), "Alpha By",
                    selected = get_default(defaults, "alpha.by", "", function(x) x == "" || x %in% num.choices),
                    choices = c("", num.choices)
                ),
                documentParameters$alpha_by,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                materialSwitch(ns("alpha.reverse"), "Alpha Reverse",
                    value = get_default(defaults, "alpha.reverse", FALSE, is.logical), status = "success"
                ),
                documentParameters$alpha_reverse,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                textInput(ns("alpha.name"), "Alpha Name",
                    value = get_default(defaults, "alpha.name", "")
                ),
                documentParameters$alpha_name,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("bar.height"), "Bar Height",
                    value = get_default(defaults, "bar.height", 0.9, is.numeric), min = 0
                ),
                documentParameters$bar_height,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                sliderInput(ns("axis.scale.factor"), "Axis Scale Factor",
                    min = 0, max = 5, value = get_default(defaults, "axis.scale.factor", 1.2, is.numeric), step = 0.2
                ),
                "Scale factor controlling how much of the axis range the bars fill. Values above 1 extend beyond the data range",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                materialSwitch(ns("label.on.y.axis"), "Labels on Y Axis",
                    value = get_default(defaults, "label.on.y.axis", FALSE, is.logical), status = "success"
                ),
                "When enabled, category labels are shown as Y-axis tick labels instead of being placed on the plot area",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                sliderInput(ns("text.position"), "Category Label Position",
                    value = get_default(defaults, "text.position", 0, is.numeric), min = 0, max = 100
                ),
                "Adjust the horizontal position of category labels along the X axis when labels are shown on the plot",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("lower.quantile"), "Lower Quantile",
                    value = get_default(defaults, "lower.quantile", 0, is.numeric),
                    min = 0, max = 1, step = 0.01
                ),
                documentParameters$lower_quantile,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("upper.quantile"), "Upper Quantile",
                    value = get_default(defaults, "upper.quantile", 1, is.numeric),
                    min = 0, max = 1, step = 0.01
                ),
                documentParameters$upper_quantile,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("lower.cutoff"), "Lower Cutoff",
                    value = get_default(defaults, "lower.cutoff", NA, is.numeric)
                ),
                documentParameters$lower_cutoff,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("upper.cutoff"), "Upper Cutoff",
                    value = get_default(defaults, "upper.cutoff", NA, is.numeric)
                ),
                documentParameters$upper_cutoff,
                placement = "top", options = list(container = "body")
            )
        ),
        "Adjustments" = tagList(
            tipify(numericInput(ns("x.min"), "X-axis Min",
                value = get_default(defaults, "x.min", min.x, is.numeric)
            ), documentParameters$x_min, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("x.max"), "X-axis Max",
                value = get_default(defaults, "x.max", max.x, is.numeric)
            ), documentParameters$x_max, placement = "top", options = list(container = "body"))
        ),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
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
#' @param resizable Logical; when `TRUE` (the default) the plot output
#'   is wrapped in [shinyjqui::jqui_resizable()] so it can be resized
#'   by dragging. Set to `FALSE` when embedding the output in a container
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
