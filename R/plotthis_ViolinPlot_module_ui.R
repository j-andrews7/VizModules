#' Input UI components for the ViolinPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `plotthis_ViolinPlotServer()` and `plotthis_ViolinPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::ViolinPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#' 
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::ViolinPlot()] parameters are not available via UI inputs:
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
#'   \item \code{stack} - Stack violins (not implemented)
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
#' The following [plotthis::ViolinPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis variable (UI: "X Data", default: 2nd categorical variable)
#'   \item \code{y} - Y-axis variable (UI: "Y Data", default: 2nd numeric variable)
#'   \item \code{group_by} - Grouping variable (UI: "Group By", default: "")
#'   \item \code{sort_x} - Sort X-axis by statistic (UI: "Sort X By", default: "none")
#'   \item \code{y_max} - Maximum Y-axis value (UI: "Y Max", default: calculated)
#'   \item \code{y_min} - Minimum Y-axis value (UI: "Y Min", default: calculated)
#'   \item \code{add_point} - Add jitter points (UI: "Add Jitter Points", default: FALSE)
#'   \item \code{pt_size} - Point size (UI: "Point Size", default: 1)
#'   \item \code{pt_alpha} - Point transparency (UI: "Point Alpha", default: 1)
#'   \item \code{jitter_width} - Jitter width (UI: "Jitter Width", default: 0.5)
#'   \item \code{jitter_height} - Jitter height (UI: "Jitter Height", default: 0)
#'   \item \code{pt_color} - Point outline color (UI: "Point Outline Colour", default: "#000000")
#'   \item \code{add_box} - Add box plot overlay (UI: "Add Box", default: FALSE)
#'   \item \code{box_color} - Box outline color (UI: "Box Colour", default: "#000000")
#'   \item \code{box_width} - Box width (UI: "Box Width", default: 0.1)
#'   \item \code{box_ptsize} - Box point size (UI: "Box Point Size", default: 2.5)
#'   \item \code{highlight} - Highlight condition (UI: "Highlight", default: "")
#'   \item \code{highlight_color} - Highlight color (UI: "Highlight Colour", default: "#000000")
#'   \item \code{highlight_size} - Highlight size (UI: "Highlight Size", default: 1)
#'   \item \code{highlight_alpha} - Highlight transparency (UI: "Highlight Alpha", default: 1)
#'   \item \code{facet_by} - Faceting variable (UI: "Facet By", default: "")
#'   \item \code{facet_scales} - Facet scale behavior (UI: "Facet Scale", default: "fixed")
#'   \item \code{facet_ncol} - Number of facet columns (UI: "Columns", default: NULL)
#'   \item \code{facet_nrow} - Number of facet rows (UI: "Rows", default: NULL)
#'   \item \code{facet_byrow} - Facet ordering direction (UI: "Facet By Row", default: TRUE)
#'   \item \code{palcolor} - Custom color values (UI: palette picker, derived from palette)
#' }
#' 
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#' \itemize{
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
#' @importFrom shinyBS tipify
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::ViolinPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_ViolinPlotOutputUI()], [VizModules::plotthis_ViolinPlotServer()], [VizModules::plotthis_ViolinPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' plotthis_ViolinPlotInputsUI("ViolinPlot", mtcars)
plotthis_ViolinPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11 # Y axis scale factor ( Allows the top of the graph to not reach the top of the axes)
    min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)

    selected <- c("x", "y", "group_by", "sort_x",
            "y_max", "y_min", "add_point", "pt_size", "pt_alpha",
            "jitter_width", "jitter_height", "pt_color",
            "add_box", "box_color", "box_width", "box_ptsize",
            "highlight", "highlight_color", "highlight_size", "highlight_alpha",
            "facet_by", "facet_scales", "facet_ncol", "facet_nrow", "facet_byrow")

    documentParameters <- .get_documentation(
        package_name = "plotthis::ViolinPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("x.data"), "X Data", choices = char.choices, selected = char.choices[2]),
                documentParameters$x),
            tipify(selectInput(ns("y.data"), "Y Data", choices = num.choices, selected = num.choices[2]),
                documentParameters$y),
            tipify(selectInput(ns("group.by"), "Group By", selected = "", choices = c("", char.choices)),
                documentParameters$group_by),
            uiOutput(ns("palette.selection"))
        ),
        "Adjustments" = tagList(
            tipify(shiny::selectInput(ns("sort_x"), "Sort X By", c(
                "none", "mean_asc", "mean_desc", "mean", "median_asc",
                "median_desc", "median"
            ), selected = "none"), documentParameters$sort_x),
            tipify(numericInput(ns("y.max"), "Y Max", value = max.y),
                documentParameters$y_max),
            tipify(numericInput(ns("y.min"), "Y Min", value = min.y),
                documentParameters$y_min),
            tipify(materialSwitch(ns("add.points"), "Add Jitter Points", value = FALSE, status = "success"),
                documentParameters$add_point),
            tipify(numericInput(ns("pt.size"), "Point Size", max = 100, min = 0.1, value = 1),
                documentParameters$pt_size),
            tipify(numericInput(ns("pt.alpha"), "Point Alpha", min = 0, max = 1, value = 1),
                documentParameters$pt_alpha),
            tipify(numericInput(ns("jitter.width"), "Jitter Width", min = 0, max = 1, value = 0.5),
                documentParameters$jitter_width),
            tipify(numericInput(ns("jitter.height"), "Jitter Height", min = 0, max = 1, value = 0),
                documentParameters$jitter_height),
            tipify(colourpicker::colourInput(ns("pt.color"), "Point Outline Colour", value = "#000000"),
                documentParameters$pt_color),
            tipify(materialSwitch(ns("add.box"), "Add Box", value = FALSE, status = "success"),
                documentParameters$add_box),
            tipify(colourpicker::colourInput(ns("box.color"), "Box Colour", value = "#000000"),
                documentParameters$box_color),
            tipify(numericInput(ns("box.width"), "Box Width", min = 0, max = 1, value = 0.1),
                documentParameters$box_width),
            tipify(numericInput(ns("box.ptsize"), "Box Point Size", min = 0, max = 10, value = 2.5),
                documentParameters$box_ptsize)
        ),
        "Highlight" = tagList(
            tipify(textInput(ns("highlight"), "Highlight", value = "", placeholder = "E.g. y > 0"),
                documentParameters$highlight),
            tipify(colourpicker::colourInput(ns("highlight.colour"), "Highlight Colour", value = "#000000"),
                documentParameters$highlight_color),
            tipify(numericInput(ns("highlight.size"), "Highlight Size", value = 1, min = 0),
                documentParameters$highlight_size),
            tipify(numericInput(ns("highlight.alpha"), "Highlight Alpha", value = 1, min = 0, max = 1),
                documentParameters$highlight_alpha)
        ),
        "Facet" = tagList(
            tipify(selectInput(ns("facet.by"), "Facet By", selected = "", choices = c(char.choices, "")),
                documentParameters$facet_by),
            tipify(selectInput(ns("facet.scale"), "Facet Scale", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
                documentParameters$facet_scales),
            tipify(numericInput(ns("facet.ncol"), "Columns", value = NULL, min = 0),
                documentParameters$facet_ncol),
            tipify(numericInput(ns("facet.nrow"), "Rows", value = NULL, min = 0),
                documentParameters$facet_nrow),
            tipify(materialSwitch(ns("facet.by.row"), "Facet By Row", value = TRUE, status = "success"),
                documentParameters$facet_byrow)
        ),
        "Axes" = .uniform_axes_inputs_ui(ns, defaults, include.rotate = TRUE),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("ViolinPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the ViolinPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the ViolinPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_ViolinPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("ViolinPlot"))
    )
}
