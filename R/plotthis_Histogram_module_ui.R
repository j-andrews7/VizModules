#' Input UI components for the Histogram module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `plotthis_HistogramServer()` and `plotthis_HistogramOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::Histogram()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::Histogram()] parameters are not available via UI inputs:
#'
#' - `xlab` - X-axis label (plotly allows interactive editing)
#' - `ylab` - Y-axis label (plotly allows interactive editing)
#' - `title` - Plot title (plotly allows interactive editing)
#' - `subtitle` - Plot subtitle (not supported in plotly)
#' - `legend.position` - Legend positioning (plotly allows interactive repositioning)
#' - `group_by_sep` - Separator for group columns (not applicable in UI context)
#' - `group_name` - Group legend name (handled by plotly)
#' - `xtrans` - X-axis transformation (not implemented in UI)
#' - `ytrans` - Y-axis transformation (not implemented in UI)
#' - `split_by` - Split variable (returns a patchwork object, not supported in plotly), use `facet_by` instead
#' - `split_by_sep` - Only applies if `split_by` is used
#' - `theme` - ggplot2 theme (not applicable in plotly)
#' - `theme_args` - Theme arguments (not applicable in plotly)
#' - `palette` - Managed internally via the palette selection UI
#' - `expand` - Axis expansion (not implemented)
#' - `seed` - Random seed (not applicable)
#' - `combine` - Only applies if `split_by` is used
#' - `nrow` - Only applies if `split_by` is used
#' - `ncol` - Only applies if `split_by` is used
#' - `byrow` - Only applies if `split_by` is used
#' - `axes` - Only applies if `split_by` is used
#' - `axis_titles` - Only applies if `split_by` is used
#' - `guides` - Only applies if `split_by` is used
#' - `design` - Only applies if `split_by` is used
#' - `palreverse` - Reverse the color palette (not implemented)
#' - `aspect.ratio` - Aspect ratio control (handled by plotly layout)
#' - `keep_empty` - Keep empty factor levels (not implemented)
#' - `keep_na` - Keep NA values (not implemented)
#' - `legend.direction` - Managed position of legend however this can be handled via plotly
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::Histogram()] parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x` - X-axis variable (UI: "X Data", default: 2nd numeric variable)
#' - `group_by` - Grouping variable (UI: "Group By", default: "")
#' - `flip` - Flip/swap the x and y axes (UI: "Rotate (swap X/Y)", default: FALSE)
#' - `bins` - Number of bins (UI: "Number of Bins", default: NA)
#' - `binwidth` - Width of bins (UI: "Bin Width", default: NA)
#' - `use_trend` - Show only trend line (UI: "Trend Line Only", default: FALSE)
#' - `add_trend` - Add trend line to histogram (UI: "Add Trend to Histogram", default: FALSE)
#' - `trend_skip_zero` - Skip zero values in trend (UI: "Skip Zero Values", default: FALSE)
#' - `trend_alpha` - Trend line transparency (UI: "Trend Line Alpha", default: 1)
#' - `trend_linewidth` - Trend line width (UI: "Trend Line Width", default: 0.8)
#' - `trend_pt_size` - Trend point size (UI: "Trend Point Size", default: 1.5)
#' - `position` - Position adjustment (UI: "Position", default: "identity")
#' - `alpha` - Histogram fill transparency (UI: "Plot Alpha", default: 1)
#' - `add_bars` - Add rug plot (UI: "Add Rug Plot", default: FALSE)
#' - `bar_height` - Rug bar height (UI: "Rug Bar Height", default: 0.04)
#' - `bar_alpha` - Rug bar transparency (UI: "Rug Bar Alpha", default: 1)
#' - `bar_width` - Rug bar width (UI: "Rug Bar Width", default: 1)
#' - `facet_by` - Faceting variable (UI: "Facet By", default: "")
#' - `facet_scales` - Facet scale behavior (UI: "Facet Scale", default: "fixed")
#' - `facet_ncol` - Number of facet columns (UI: "Columns", default: NULL)
#' - `facet_nrow` - Number of facet rows (UI: "Rows", default: NULL)
#' - `facet_byrow` - Facet ordering direction (UI: "Facet by Row", default: TRUE)
#' - `palcolor` - Custom color values (UI: palette picker, derived from palette)
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
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#' @importFrom shinyBS tipify
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::Histogram()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_HistogramOutputUI()], [VizModules::plotthis_HistogramServer()], [VizModules::plotthis_HistogramApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' plotthis_HistogramInputsUI("histogram", mtcars)
plotthis_HistogramInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    cat.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    selected <- list(
        "x", "group_by", "bins", "binwidth",
        "use_trend", "add_trend", "trend_skip_zero", "trend_alpha",
        "trend_linewidth", "trend_pt_size", "position", "alpha",
        "add_bars", "bar_height", "bar_alpha", "bar_width",
        "facet_by", "facet_scales", "facet_ncol", "facet_nrow", "facet_byrow"
    )

    documentParameters <- get_documentation(
        package_name = "plotthis::Histogram", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("x.data"), "X Data",
                selected = get_default(
                    defaults, "x.data", num.choices[2],
                    function(x) x %in% num.choices
                ),
                choices = num.choices, selectize = FALSE
            ), documentParameters$x, placement = "top", options = list(container = "body")),
            tipify(
                selectInput(ns("group.by"), "Group By",
                    selected = get_default(
                        defaults, "group.by", "",
                        function(x) x %in% c("", cat.choices)
                    ),
                    choices = c("", cat.choices), selectize = FALSE
                ),
                documentParameters$group_by,
                placement = "top", options = list(container = "body")
            )
        ),
        "Facet" = tagList(
            tipify(selectInput(ns("facet.by"), "Facet By",
                selected = get_default(defaults, "facet.by", "", function(x) x == "" || x %in% cat.choices),
                choices = c("", .facet_check(data)), selectize = FALSE),
                documentParameters$facet_by,
                placement = "top", options = list(container = "body")
            ),
            tipify(selectInput(ns("facet.scale"), "Facet Scale",
                selected = get_default(
                    defaults, "facet.scale", "fixed",
                    function(x) x %in% c("fixed", "free", "free_x", "free_y")
                ),
                choices = c("fixed", "free", "free_x", "free_y"), selectize = FALSE),
                documentParameters$facet_scales,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("facet.ncol"), "Columns",
                value = get_default(defaults, "facet.ncol", NULL, is.numeric), min = 0, max = 20),
                documentParameters$facet_ncol,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("facet.nrow"), "Rows",
                value = get_default(defaults, "facet.nrow", NULL, is.numeric), min = 0, max = 20),
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
        "Aesthetics" = tagList(
            tipify(numericInput(ns("bins"), "Number of Bins",
                value = get_default(defaults, "bins", NA, is.numeric), min = 0),
                documentParameters$bins,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("bin.width"), "Bin Width",
                value = get_default(defaults, "bin.width", NA, is.numeric), min = 0),
                documentParameters$binwidth,
                placement = "top", options = list(container = "body")
            ),
            tipify(materialSwitch(ns("use.trend"), "Trend Line Only",
                value = get_default(defaults, "use.trend", FALSE, is.logical), status = "success"),
                documentParameters$use_trend,
                placement = "top", options = list(container = "body")
            ),
            tipify(materialSwitch(ns("trend.skip.zero"), "Skip Zeros",
                value = get_default(defaults, "trend.skip.zero", FALSE, is.logical), status = "success"),
                documentParameters$trend_skip_zero,
                placement = "top", options = list(container = "body")
            ),
            tipify(materialSwitch(ns("add.trend"), "Add Trend",
                value = get_default(defaults, "add.trend", FALSE, is.logical), status = "success"),
                documentParameters$add_trend,
                placement = "top", options = list(container = "body")
            ),
            tipify(sliderInput(ns("trend.alpha"), "Trend Line Alpha", min = 0, max = 1,
                value = get_default(defaults, "trend.alpha", 1, is.numeric)),
                documentParameters$trend_alpha,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("trend.linewidth"), "Trend Line Width",
                value = get_default(defaults, "trend.linewidth", 0.8, is.numeric), min = 0),
                documentParameters$trend_linewidth,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("trend.pt.size"), "Trend Point Size",
                value = get_default(defaults, "trend.pt.size", 1.5, is.numeric)),
                documentParameters$trend_pt_size,
                placement = "top", options = list(container = "body")
            ),
            tipify(sliderInput(ns("plot.alpha"), "Plot Alpha", min = 0, max = 1,
                value = get_default(defaults, "plot.alpha", 1, is.numeric)),
                documentParameters$alpha,
                placement = "top", options = list(container = "body")
            ),
            uiOutput(ns("palette.selection")),
            tipify(selectInput(ns("position"), "Position",
                selected = get_default(
                    defaults, "position", "identity",
                    function(x) x %in% c("identity", "stack", "dodge", "fill")
                ),
                choices = c("identity", "stack", "dodge", "fill"), selectize = FALSE
            ), documentParameters$position, placement = "top", options = list(container = "body"))
        ),
        "Rug" = tagList(
            tipify(materialSwitch(ns("add.bars"), "Add Rug Plot",
                value = get_default(defaults, "add.bars", FALSE, is.logical), status = "success"),
                documentParameters$add_bars,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("bar.height"), "Rug Bar Height",
                value = get_default(defaults, "bar.height", 0.04, is.numeric)),
                documentParameters$bar_height,
                placement = "top", options = list(container = "body")
            ),
            tipify(sliderInput(ns("bar.alpha"), "Rug Bar Alpha", min = 0, max = 1,
                value = get_default(defaults, "bar.alpha", 1, is.numeric), step = 0.05),
                documentParameters$bar_alpha,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("bar.width"), "Rug Bar Width",
                value = get_default(defaults, "bar.width", 1, is.numeric), min = 0, step = 0.05),
                documentParameters$bar_width,
                placement = "top", options = list(container = "body")
            )
        ),
        "Legend" = uniform_legend_inputs_ui(ns, defaults),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
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
#' @param resizable Logical; when `TRUE` (the default) the plot output
#'   is wrapped in [shinyjqui::jqui_resizable()] so it can be resized
#'   by dragging. Set to `FALSE` when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the histogramPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_HistogramOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("histogramPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
