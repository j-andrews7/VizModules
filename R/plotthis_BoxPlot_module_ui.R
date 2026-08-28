#' Input UI components for the BoxPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `plotthis_BoxPlotServer()` and `plotthis_BoxPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::BoxPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::BoxPlot()] parameters are not available via UI inputs:
#'
#' - `xlab` - X-axis label (plotly allows interactive editing)
#' - `ylab` - Y-axis label (plotly allows interactive editing)
#' - `title` - Plot title (plotly allows interactive editing)
#' - `subtitle` - Plot subtitle (not supported in plotly)
#' - `aspect.ratio` - Aspect ratio control (handled by plotly layout)
#' - `legend.position` - Legend positioning (plotly allows interactive repositioning)
#' - `x_sep` - Separator for x columns (not applicable in UI context)
#' - `in_form` - Data input format (not applicable - always long form)
#' - `split_by` - Split variable (returns a patchwork object, not supported in plotly), use `facet_by` instead
#' - `split_by_sep` - Only applies if `split_by` is used
#' - `symnum_args` - Significance symbol arguments (the Stats tab manages symbol display)
#' - `keep_empty` - Keep empty values (not implemented)
#' - `keep_na` - Keep NA values (not implemented)
#' - `group_by_sep` - Separator for group columns (not applicable in UI context)
#' - `group_name` - Group legend name (handled by plotly)
#' - `paired_by` - Pairing variable for paired tests (use the Stats tab "Paired Test" input instead)
#' - `x_text_angle` - X-axis text angle (handled by plotly axis settings)
#' - `step_increase` - Step increase for significance brackets (set via the Stats tab "Bracket Spacing")
#' - `base` - Base plot type box/violin/bar (fixed to "box" in this module)
#' - `fill_mode` - Fill mode for grouped data (handled automatically)
#' - `position_dodge_preserve` - Preserve dodge width (not implemented)
#' - `add_errorbar` - Add error bars (only for base = "bar"; not implemented)
#' - `errorbar_color` - Error bar color (not implemented)
#' - `errorbar_width` - Error bar cap width (not implemented)
#' - `errorbar_linewidth` - Error bar line width (not implemented)
#' - `theme` - ggplot2 theme (not applicable in plotly)
#' - `theme_args` - Theme arguments (not applicable in plotly)
#' - `palette` - Managed internally via the palette selection UI
#' - `palreverse` - Reverse the color palette (not implemented)
#' - `alpha` - Alpha transparency (not implemented in UI)
#' - `stack` - Stack boxplots (not implemented)
#' - `add_beeswarm` - Add beeswarm points (not implemented in UI)
#' - `beeswarm_method` - Beeswarm arrangement method (not implemented)
#' - `beeswarm_cex` - Beeswarm point size factor (not implemented)
#' - `beeswarm_priority` - Beeswarm priority order (not implemented)
#' - `beeswarm_dodge` - Beeswarm dodge width (not implemented)
#' - `add_trend` - Add trend line (not implemented in UI)
#' - `trend_color` - Trend line color (not implemented)
#' - `trend_linewidth` - Trend line width (not implemented)
#' - `trend_ptsize` - Trend point size (not implemented)
#' - `add_stat` - Add statistical annotation (not implemented)
#' - `stat_name` - Statistical test name (not implemented)
#' - `stat_color` - Statistical annotation color (not implemented)
#' - `stat_size` - Statistical annotation size (not implemented)
#' - `stat_stroke` - Statistical annotation stroke (not implemented)
#' - `stat_shape` - Statistical annotation shape (not implemented)
#' - `add_bg` - Add background shading (not implemented)
#' - `bg_palette` - Background palette (not implemented)
#' - `bg_palcolor` - Background color (not implemented)
#' - `bg_alpha` - Background transparency (not implemented)
#' - `add_line` - Add horizontal line (not implemented in UI - use Lines tab)
#' - `line_color` - Line color (not implemented)
#' - `line_width` - Line width (not implemented)
#' - `line_type` - Line type (not implemented)
#' - `comparisons` - plotthis pairwise comparisons are not passed; equivalent pairwise
#'   significance testing is provided via the module's Stats tab (see "Statistical annotation parameters")
#' - `ref_group` - Reference group for comparisons (use the Stats tab instead)
#' - `pairwise_method` - Pairwise test method (set via the Stats tab "Test" input instead)
#' - `multiplegroup_comparisons` - Multiple-group comparison flag (use the Stats tab instead)
#' - `multiple_method` - Multiple-group test method (set via the Stats tab "Test" input instead)
#' - `sig_label` - Significance label format (set via the Stats tab "Display" input instead)
#' - `sig_labelsize` - Significance label size (handled by the Stats tab)
#' - `hide_ns` - Hide non-significant comparisons (use the Stats tab "Hide Non-Significant" input)
#' - `seed` - Random seed (not applicable)
#' - `combine` - Only applies if `split_by` is used
#' - `nrow` - Only applies if `split_by` is used
#' - `ncol` - Only applies if `split_by` is used
#' - `byrow` - Only applies if `split_by` is used
#' - `axes` - Only applies if `split_by` is used
#' - `axis_titles` - Only applies if `split_by` is used
#' - `guides` - Only applies if `split_by` is used
#' - `legend.direction` - Managed position of legend however this can be handled via plotly
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::BoxPlot()] parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x` - X-axis variable (UI: "X data", default: 2nd categorical variable)
#' - `y` - Y-axis variable (UI: "Y data", default: 2nd numeric variable)
#' - `group_by` - Grouping variable (UI: "Group by", default: "")
#' - `flip` - Flip/swap the x and y axes (UI: "Rotate (swap X/Y)", default: FALSE)
#' - `sort_x` - Sort X-axis by statistic (UI: "Sort X by", default: "")
#' - `y_max` - Maximum Y-axis value (UI: "Max Value of Y Axis", default: calculated)
#' - `y_min` - Minimum Y-axis value (UI: "Min Value of Y Axis", default: calculated)
#' - `add_point` - Add jitter points (UI: "Add Jitter Points", default: FALSE)
#' - `pt_size` - Point size (UI: "Point Size", default: 1)
#' - `pt_alpha` - Point transparency (UI: "Point Alpha", default: 1)
#' - `jitter_width` - Jitter width (UI: "Jitter Width", default: 0.3)
#' - `pt_color` - Point outline color (UI: "Point Outline Colour", default: "#000000")
#' - `highlight` - Highlight condition (UI: "Highlight", default: "")
#' - `highlight_color` - Highlight color (UI: "Highlight Colour", default: "#000000")
#' - `highlight_size` - Highlight size (UI: "Highlight Size", default: 1)
#' - `highlight_alpha` - Highlight transparency (UI: "Highlight Alpha", default: 1)
#' - `facet_by` - Faceting variable (UI: "Facet by", default: "")
#' - `facet_scales` - Facet scale behavior (UI: "Facet Scale", default: "fixed")
#' - `facet_ncol` - Number of facet columns (UI: "Columns", default: NULL)
#' - `facet_nrow` - Number of facet rows (UI: "Rows", default: NULL)
#' - `facet_byrow` - Facet ordering direction (UI: "Facet by Row", default: TRUE)
#' - `palcolor` - Custom color values (UI: palette picker, derived from palette)
#'
#' @section Statistical annotation parameters:
#' The module provides plotly-based significance testing via the Stats tab (a reimplementation of
#' the plotthis significance-testing features). The following inputs are available:
#'
#' - `stats.enabled` - Enable statistical annotations (UI: "Enable Stats", default: FALSE)
#' - `stat.test` - Test to apply: Wilcoxon, t-test, Kruskal-Wallis, or ANOVA (UI: "Test")
#' - `stat.p.adjust` - P-value adjustment method (UI: "P-value Adjustment", default: "holm")
#' - `stat.display` - Value to display: adjusted p-value, p-value, or symbols (UI: "Display")
#' - `stat.sig.threshold` - Significance threshold for symbols/hiding (UI: "Significance Threshold")
#' - `stat.hide.ns` - Hide non-significant comparisons (UI: "Hide Non-Significant", default: FALSE)
#' - `stat.paired` - Use a paired test (UI: "Paired Test", default: FALSE)
#' - `stat.pairs` - Group comparisons to test (UI: "Comparisons", multiple selection)
#' - `stat.line.color` - Bracket line color (UI: "Line Color", default: "#000000")
#' - `stat.line.width` - Bracket line width (UI: "Line Width")
#' - `stat.bracket.style` - Bracket style, capped or flat (UI: "Bracket Style")
#' - `stat.step.increase` - Vertical spacing between stacked brackets (UI: "Bracket Spacing")
#' - `stat.text.bump` - Offset of the significance text above the bracket (UI: "Text Offset")
#' - `stat.bracket.inset` - Horizontal inset of the brackets (UI: "Bracket Inset")
#' - `stat.per.facet` - Compute statistics independently per facet panel (UI: "Per Facet Panel")
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#'
#' - `boxplot.width` - Width of boxplot (UI: "Boxplot Width", default: 0.8)
#' - `show.outliers` - Show outlier points (UI: "Show Outliers", default: TRUE)
#' - `axis.title.font.size` - Axis title font size (UI: "Axis title size", default: 18)
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
#' - `palette.colours` - Named character vector mapping group levels to colors, e.g.
#'   `c(A = "#FF0000", B = "blue")` (UI: "Plot colors"). Seeds the picker; unnamed groups fall
#'   back to the default palette and user edits take precedence.
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
#' @import shiny
#' @importFrom colourpicker colourInput
#' @importFrom shinyWidgets materialSwitch
#' @importFrom shinyBS tipify
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::BoxPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_BoxPlotOutputUI()], [VizModules::plotthis_BoxPlotServer()],
#' [VizModules::plotthis_BoxPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' plotthis_BoxPlotInputsUI("BoxPlot", mtcars)
plotthis_BoxPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    cat.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]

    if (length(num.choices) >= 2) {
        max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * .y_axis_scale_factor
        min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)
    } else {
        max.y <- 1
        min.y <- 0
    }

    selected <- list(
        "x", "y", "group_by", "sort_x",
        "y_max", "y_min", "add_point", "pt_size", "pt_alpha",
        "jitter_width", "pt_color",
        "highlight", "highlight_color", "highlight_size", "highlight_alpha",
        "facet_by", "facet_scales", "facet_ncol", "facet_nrow", "facet_byrow"
    )

    documentParameters <- get_documentation(
        package_name = "plotthis::BoxPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(
                viz_select_input(ns("x.data"), "X Data",
                    choices = cat.choices[nzchar(cat.choices)],
                    selected = get_default(
                        defaults, "x.data", cat.choices[2],
                        function(x) x %in% cat.choices
                    )
                ),
                documentParameters$x,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                viz_select_input(ns("y.data"), "Y Data",
                    choices = num.choices[nzchar(num.choices)],
                    selected = get_default(
                        defaults, "y.data", num.choices[2],
                        function(x) x %in% num.choices
                    )
                ),
                documentParameters$y,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                viz_select_input(ns("group.by"), "Group By",
                    selected = get_default(
                        defaults, "group.by", "",
                        function(x) x %in% c("", cat.choices)
                    ),
                    choices = c("", cat.choices)
                ),
                documentParameters$group_by,
                placement = "top", options = list(container = "body")
            ),
            tipify(materialSwitch(ns("show.outliers"), "Show Outliers",
                value = get_default(defaults, "show.outliers", TRUE, is.logical), status = "success"),
                "Toggle whether outlier points beyond the whiskers are displayed on the boxplot",
                placement = "top", options = list(container = "body")
            ),
            uiOutput(ns("palette.selection"))
        ),
        "Adjustments" = tagList(
            tipify(numericInput(ns("boxplot.width"), "Boxplot Width", min = 0, max = 1,
                value = get_default(defaults, "boxplot.width", 0.8, is.numeric), step = 0.05),
                "Set the relative width of each boxplot, where 1 fills the entire available space",
                placement = "top", options = list(container = "body")
            ),
            tipify(textInput(ns("sort_x"), "Sort X By",
                value = get_default(defaults, "sort_x", ""), placeholder = "mean(y data col name)"), 
                documentParameters$sort_x, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("y.max"), "Max Value of Y Axis",
                value = get_default(defaults, "y.max", max.y, is.numeric), min = -Inf, max = Inf),
                documentParameters$y_max,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("y.min"), "Y Axis Min",
                value = get_default(defaults, "y.min", min.y, is.numeric), min = -Inf, max = Inf),
                documentParameters$y_min,
                placement = "top", options = list(container = "body")
            ),
            tipify(materialSwitch(ns("add.points"), "Add Jitter Points",
                value = get_default(defaults, "add.points", FALSE, is.logical), status = "success"),
                documentParameters$add_point,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("pt.size"), "Point Size", max = 100, min = 0.1,
                value = get_default(defaults, "pt.size", 1, is.numeric)),
                documentParameters$pt_size,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("pt.alpha"), "Point Alpha", min = 0, max = 1,
                value = get_default(defaults, "pt.alpha", 1, is.numeric)),
                documentParameters$pt_alpha,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("jitter.width"), "Jitter Width", min = 0, max = 1,
                value = get_default(defaults, "jitter.width", 0.3, is.numeric), step = 0.05),
                documentParameters$jitter_width,
                placement = "top", options = list(container = "body")
            ),
            tipify(colourInput(ns("pt.color"), "Point Outline Colour",
                value = get_default(defaults, "pt.color", "#000000")),
                documentParameters$pt_color,
                placement = "top", options = list(container = "body")
            )
        ),
        "Highlight" = tagList(
            tipify(textInput(ns("highlight"), "Highlight",
                value = get_default(defaults, "highlight", ""), placeholder = "E.g. col name > 0"),
                documentParameters$highlight,
                placement = "top", options = list(container = "body")
            ),
            tipify(colourInput(ns("highlight.colour"), "Highlight Colour",
                value = get_default(defaults, "highlight.colour", "#000000")),
                documentParameters$highlight_color,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("highlight.size"), "Highlight Size",
                value = get_default(defaults, "highlight.size", 1, is.numeric), min = 0),
                documentParameters$highlight_size,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("highlight.alpha"), "Highlight Alpha",
                value = get_default(defaults, "highlight.alpha", 1, is.numeric), min = 0, max = 1),
                documentParameters$highlight_alpha,
                placement = "top", options = list(container = "body")
            )
        ),
        "Facet" = tagList(
            tipify(viz_select_input(ns("facet.by"), "Facet By",
                selected = get_default(defaults, "facet.by", "", function(x) x == "" || x %in% cat.choices),
                choices = c("", .facet_check(data))),
                documentParameters$facet_by,
                placement = "top", options = list(container = "body")
            ),
            tipify(viz_select_input(ns("facet.scale"), "Facet Scale",
                selected = get_default(
                    defaults, "facet.scale", "fixed",
                    function(x) x %in% c("fixed", "free", "free_x", "free_y")
                ),
                choices = c("fixed", "free", "free_x", "free_y")),
                documentParameters$facet_scales,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("facet.ncol"), "Columns",
                value = get_default(defaults, "facet.ncol", NULL, is.numeric), min = 0),
                documentParameters$facet_ncol,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("facet.nrow"), "Rows",
                value = get_default(defaults, "facet.nrow", NULL, is.numeric), min = 0),
                documentParameters$facet_nrow,
                placement = "top", options = list(container = "body")
            ),
            tipify(materialSwitch(ns("facet.by.row"), "Facet by Row",
                value = get_default(defaults, "facet.by.row", TRUE, is.logical), status = "success"),
                documentParameters$facet_byrow,
                placement = "top", options = list(container = "body")
            ),
            .uniform_subplot_spacing_inputs_ui(ns, defaults)
        ),
        "Stats" = .uniform_stats_inputs_ui(ns, defaults),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE, include.flip = FALSE),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("BoxPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the BoxPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output
#'   is wrapped in [shinyjqui::jqui_resizable()] so it can be resized
#'   by dragging. Set to `FALSE` when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the boxPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_BoxPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("BoxPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
