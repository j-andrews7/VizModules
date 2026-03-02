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
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{title} - Plot title (plotly allows interactive editing)
#'   \item \code{subtitle} - Plot subtitle (not supported in plotly)
#'   \item \code{aspect.ratio} - Aspect ratio control (handled by plotly layout)
#'   \item \code{legend.position} - Legend positioning (plotly allows interactive repositioning)
#'   \item \code{x_sep} - Separator for x columns (not applicable in UI context)
#'   \item \code{in_form} - Data input format (not applicable - always long form)
#'   \item \code{split_by} - Split variable (returns a patchwork object, not supported in plotly), use `facet_by` instead
#'   \item \code{split_by_sep} - Only applies if `split_by` is used
#'   \item \code{symnum_args} - Significance symbol arguments (not implemented)
#'   \item \code{flip} - Flip axes (not implemented in current UI)
#'   \item \code{keep_empty} - Keep empty values (not implemented)
#'   \item \code{keep_na} - Keep NA values (not implemented)
#'   \item \code{group_by_sep} - Separator for group columns (not applicable in UI context)
#'   \item \code{group_name} - Group legend name (handled by plotly)
#'   \item \code{paired_by} - Pairing variable for paired tests (not implemented)
#'   \item \code{x_text_angle} - X-axis text angle (handled by plotly axis settings)
#'   \item \code{step_increase} - Step increase for significance brackets (not implemented)
#'   \item \code{fill_mode} - Fill mode for grouped data (handled automatically)
#'   \item \code{fill_reverse} - Reverse fill order (not implemented)
#'   \item \code{theme} - ggplot2 theme (not applicable in plotly)
#'   \item \code{theme_args} - Theme arguments (not applicable in plotly)
#'   \item \code{palette} - Managed internally via the palette selection UI
#'   \item \code{alpha} - Alpha transparency (not implemented in UI)
#'   \item \code{stack} - Stack boxplots (not implemented)
#'   \item \code{add_beeswarm} - Add beeswarm points (not implemented in UI)
#'   \item \code{beeswarm_method} - Beeswarm arrangement method (not implemented)
#'   \item \code{beeswarm_cex} - Beeswarm point size factor (not implemented)
#'   \item \code{beeswarm_priority} - Beeswarm priority order (not implemented)
#'   \item \code{beeswarm_dodge} - Beeswarm dodge width (not implemented)
#'   \item \code{add_trend} - Add trend line (not implemented in UI)
#'   \item \code{trend_color} - Trend line color (not implemented)
#'   \item \code{trend_linewidth} - Trend line width (not implemented)
#'   \item \code{trend_ptsize} - Trend point size (not implemented)
#'   \item \code{add_stat} - Add statistical annotation (not implemented)
#'   \item \code{stat_name} - Statistical test name (not implemented)
#'   \item \code{stat_color} - Statistical annotation color (not implemented)
#'   \item \code{stat_size} - Statistical annotation size (not implemented)
#'   \item \code{stat_stroke} - Statistical annotation stroke (not implemented)
#'   \item \code{stat_shape} - Statistical annotation shape (not implemented)
#'   \item \code{add_bg} - Add background shading (not implemented)
#'   \item \code{bg_palette} - Background palette (not implemented)
#'   \item \code{bg_palcolor} - Background color (not implemented)
#'   \item \code{bg_alpha} - Background transparency (not implemented)
#'   \item \code{add_line} - Add horizontal line (not implemented in UI - use Lines tab)
#'   \item \code{line_color} - Line color (not implemented)
#'   \item \code{line_width} - Line width (not implemented)
#'   \item \code{line_type} - Line type (not implemented)
#'   \item \code{comparisons} - Group comparisons for significance tests (not implemented)
#'   \item \code{ref_group} - Reference group for comparisons (not implemented)
#'   \item \code{pairwise_method} - Pairwise test method (not implemented)
#'   \item \code{multiplegroup_comparisons} - Multiple group comparison flag (not implemented)
#'   \item \code{multiple_method} - Multiple group test method (not implemented)
#'   \item \code{sig_label} - Significance label format (not implemented)
#'   \item \code{sig_labelsize} - Significance label size (not implemented)
#'   \item \code{hide_ns} - Hide non-significant comparisons (not implemented)
#'   \item \code{seed} - Random seed (not applicable)
#'   \item \code{combine} - Only applies if `split_by` is used
#'   \item \code{nrow} - Only applies if `split_by` is used
#'   \item \code{ncol} - Only applies if `split_by` is used
#'   \item \code{byrow} - Only applies if `split_by` is used
#'   \item \code{axes} - Only applies if `split_by` is used
#'   \item \code{axis_titles} - Only applies if `split_by` is used
#'   \item \code{guides} - Only applies if `split_by` is used
#'   \item \code{legend_direction} - Managed position of legend however this can be handled via plotly
#' }
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::BoxPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis variable (UI: "X data", default: 2nd categorical variable)
#'   \item \code{y} - Y-axis variable (UI: "Y data", default: 2nd numeric variable)
#'   \item \code{group_by} - Grouping variable (UI: "Group by", default: "")
#'   \item \code{sort_x} - Sort X-axis by statistic (UI: "Sort X by", default: "")
#'   \item \code{y_max} - Maximum Y-axis value (UI: "Max Value of Y Axis", default: calculated)
#'   \item \code{y_min} - Minimum Y-axis value (UI: "Min Value of Y Axis", default: calculated)
#'   \item \code{add_point} - Add jitter points (UI: "Add Jitter Points", default: FALSE)
#'   \item \code{pt_size} - Point size (UI: "Point Size", default: 1)
#'   \item \code{pt_alpha} - Point transparency (UI: "Point Alpha", default: 1)
#'   \item \code{jitter_width} - Jitter width (UI: "Jitter Width", default: 0.3)
#'   \item \code{pt_color} - Point outline color (UI: "Point Outline Colour", default: "#000000")
#'   \item \code{highlight} - Highlight condition (UI: "Highlight", default: "")
#'   \item \code{highlight_color} - Highlight color (UI: "Highlight Colour", default: "#000000")
#'   \item \code{highlight_size} - Highlight size (UI: "Highlight Size", default: 1)
#'   \item \code{highlight_alpha} - Highlight transparency (UI: "Highlight Alpha", default: 1)
#'   \item \code{facet_by} - Faceting variable (UI: "Facet by", default: "")
#'   \item \code{facet_scales} - Facet scale behavior (UI: "Facet Scale", default: "fixed")
#'   \item \code{facet_ncol} - Number of facet columns (UI: "Columns", default: NULL)
#'   \item \code{facet_nrow} - Number of facet rows (UI: "Rows", default: NULL)
#'   \item \code{facet_byrow} - Facet ordering direction (UI: "Facet by Row", default: TRUE)
#'   \item \code{palcolor} - Custom color values (UI: palette picker, derived from palette)
#' }
#' 
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#' \itemize{
#'   \item \code{boxplot.width} - Width of boxplot (UI: "Boxplot Width", default: 0.8)
#'   \item \code{show.outliers} - Show outlier points (UI: "Show Outliers", default: TRUE)
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
#' @import shiny
#' @importFrom colourpicker colourInput
#' @importFrom shinyWidgets materialSwitch
#' @importFrom bslib tooltip
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::BoxPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_BoxPlotOutputUI()], [VizModules::plotthis_BoxPlotServer()], [VizModules::plotthis_BoxPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' plotthis_BoxPlotInputsUI("BoxPlot", mtcars)
plotthis_BoxPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11 # Y axis scale factor ( Allows the top of the graph to not reach the top of the axes)
    min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)

    inputs <- list(
        "Data" = tagList(
            tooltip(
                selectInput(ns("x.data"), "X data", choices = cat.choices, selected = cat.choices[2]),
                "TEST"
            ),
            selectInput(ns("y.data"), "Y data", choices = num.choices, selected = num.choices[2]),
            selectInput(ns("group.by"), "Group by", selected = "", choices = c("", cat.choices)),
            materialSwitch(ns("show.outliers"), "Show Outliers", value = TRUE, status = "success"),
            uiOutput(ns("palette.selection"))
        ),
        "Adjustments" = tagList(
            numericInput(ns("boxplot.width"), "Boxplot Width", min = 0, max = 1, value = 0.8, step = 0.05),
            selectInput(ns("sort_x"), "Sort X by", selected = "", choices = c("",
                "mean_asc", "mean_desc", "mean", "median_asc",
                "median_desc", "median"
            )),
            numericInput(ns("y.max"), "Max Value of Y Axis", value = max.y, min = -Inf, max = Inf),
            numericInput(ns("y.min"), "Min Value of Y Axis", value = min.y, min = -Inf, max = Inf),
            materialSwitch(ns("add.points"), "Add Jitter Points", value = FALSE, status = "success"),
            numericInput(ns("pt.size"), "Point Size", max = 100, min = 0.1, value = 1),
            numericInput(ns("pt.alpha"), "Point Alpha", min = 0, max = 1, value = 1),
            numericInput(ns("jitter.width"), "Jitter Width", min = 0, max = 1, value = 0.3, step = 0.05),
            colourpicker::colourInput(ns("pt.color"), "Point Outline Colour", value = "#000000")
        ),
        "Highlight" = tagList(
            textInput(ns("highlight"), "Highlight", value = "", placeholder = "E.g. col name > 0"),
            colourpicker::colourInput(ns("highlight.colour"), "Highlight Colour", value = "#000000"),
            numericInput(ns("highlight.size"), "Highlight Size", value = 1, min = 0),
            numericInput(ns("highlight.alpha"), "Highlight Alpha", value = 1, min = 0, max = 1)
        ),
        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by", selected = "", choices = c(cat.choices, "")),
            selectInput(ns("facet.scale"), "Facet Scale", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Columns", value = NULL, min = 0),
            numericInput(ns("facet.nrow"), "Rows", value = NULL, min = 0),
            materialSwitch(ns("facet.by.row"), "Facet by Row", value = TRUE, status = "success")
        ),
        "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE, include.flip = FALSE),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
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
#'
#' @return A Shiny plotlyOutput for the boxPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_BoxPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("BoxPlot"))
    )
}
