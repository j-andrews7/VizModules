#' Input UI components for the scatterPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoViz_scatterPlotServer()` and `dittoViz_scatterPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [dittoViz::scatterPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' Note that some of the parameters may have input types that differ from the actual function, e.g. `shape.panel`
#' is a text input for comma-separated integers, while the function expects a vector of integers.
#' The module will parse such inputs into the appropriate format for [dittoViz::scatterPlot()] automatically.
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [dittoViz::scatterPlot()] parameters are not available via UI inputs or have been superseded:
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{main} - Plot title (plotly allows interactive editing)
#'   \item \code{sub} - Plot subtitle (not supported in plotly)
#'   \item \code{theme} - ggplot2 theme (not applicable to plotly)
#'   \item \code{legend.title} - Legend title (managed by plotly interactively)
#'   \item \code{add.xline} - Use \code{vline.intercepts} instead for vertical lines with full styling options
#'   \item \code{add.yline} - Use \code{hline.intercepts} instead for horizontal lines with full styling options
#'   \item \code{xline.linetype} - Use \code{vline.linetypes} instead
#'   \item \code{xline.color} - Use \code{vline.colors} instead
#'   \item \code{yline.linetype} - Use \code{hline.linetypes} instead
#'   \item \code{yline.color} - Use \code{hline.colors} instead
#'   \item \code{do.letter} - Lettering subplots (not implemented for plotly)
#'   \item \code{do.label} - Labeling points interactively (not compatible with plotly hover)
#' }
#' The new Lines tab provides enhanced functionality including multiple lines per type,
#' individual line widths, opacities, and diagonal/ablines with slope control.
#'
#' @section Plot parameters and defaults:
#' The following [dittoViz::scatterPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x.by} - X-axis variable (UI: "X Data", default: 2nd column)
#'   \item \code{y.by} - Y-axis variable (UI: "Y Data", default: 3rd column)
#'   \item \code{color.by} - Coloring variable (UI: "Color By", default: "")
#'   \item \code{shape.by} - Shape variable (UI: "Shape By", default: "")
#'   \item \code{split.by} - Faceting variable (UI: "Split By", default: "")
#'   \item \code{rows.use} - Row filter expression (UI: "Rows Filter", default: "")
#'   \item \code{x.adjustment} - X-axis adjustment (UI: "X Adjustment", default: "")
#'   \item \code{y.adjustment} - Y-axis adjustment (UI: "Y Adjustment", default: "")
#'   \item \code{color.adjustment} - Color adjustment (UI: "Color Adjustment", default: "")
#'   \item \code{x.adj.fxn} - X adjustment function (UI: "X Adjustment Function", default: "")
#'   \item \code{y.adj.fxn} - Y adjustment function (UI: "Y Adjustment Function", default: "")
#'   \item \code{color.adj.fxn} - Color adjustment function (UI: "Color Adjustment Function", default: "")
#'   \item \code{size} - Point size (UI: "Point Size", default: 1)
#'   \item \code{opacity} - Point opacity (UI: "Point Opacity", default: 1)
#'   \item \code{show.others} - Show others (UI: "Show Others", default: TRUE)
#'   \item \code{split.show.all.others} - Show split others (UI: "Show Split Others", default: TRUE)
#'   \item \code{plot.order} - Plot order (UI: "Plot Order", default: "unordered")
#'   \item \code{shape.panel} - Shape panel values (UI: "Shape Panel", default: "16, 15, 17, 23, 25, 8")
#'   \item \code{min.color} - Minimum color (UI: "Min Color", default: "#F0E442")
#'   \item \code{max.color} - Maximum color (UI: "Max Color", default: "#0072B2")
#'   \item \code{contour.color} - Contour color (UI: "Contour Color", default: "black")
#'   \item \code{contour.linetype} - Contour linetype (UI: "Contour Linetype", default: "solid")
#'   \item \code{color.panel} - Custom color values (UI: color.panel.ui, derived from palette)
#'   \item \code{split.nrow} - Number of split rows (UI: "Split Rows", default: NA)
#'   \item \code{split.ncol} - Number of split columns (UI: "Split Columns", default: NA)
#'   \item \code{multivar.split.dir} - Multivar split direction (UI: "Multivar Split Dir", default: "col")
#'   \item \code{split.adjust.scales} - Facet scales (UI: "Facet Scales", default: "fixed")
#'   \item \code{annotate.by} - Annotate by column (UI: "Annotate By", default: "")
#'   \item \code{highlight.points} - Points to highlight (UI: "Points to Highlight", default: "")
#'   \item \code{highlight.color} - Highlight fill (UI: "Highlight Fill", default: "#00FFF7")
#'   \item \code{highlight.size} - Highlight size (UI: "Highlight Size", default: 7)
#'   \item \code{highlight.border.color} - Highlight border color (UI: "Highlight Border Color", default: "#000000")
#'   \item \code{highlight.border.width} - Highlight border width (UI: "Highlight Border Width", default: 1)
#'   \item \code{highlight.auto.annotate} - Auto-annotate highlights (UI: "Auto-annotate Highlights", default: TRUE)
#'   \item \code{annotation.color} - Annotation color (UI: "Annotation Color", default: "black")
#'   \item \code{annotation.ax} - Annotation X offset (UI: "Annotation X Offset", default: 20)
#'   \item \code{annotation.ay} - Annotation Y offset (UI: "Annotation Y Offset", default: -20)
#'   \item \code{annotation.size} - Annotation size (UI: "Annotation Size", default: 10)
#'   \item \code{annotation.showarrow} - Show arrow (UI: "Show Arrow", default: TRUE)
#'   \item \code{annotation.arrowcolor} - Arrow color (UI: "Arrow Color", default: "black")
#'   \item \code{annotation.arrowhead} - Arrowhead style (UI: "Arrowhead Style", default: 2)
#'   \item \code{annotation.arrowwidth} - Arrow linewidth (UI: "Arrow Linewidth", default: 1.5)
#'   \item \code{legend.show} - Show legend (UI: "Show Legend", default: TRUE)
#'   \item \code{legend.color.title} - Legend title (UI: "Legend Title", default: "make")
#'   \item \code{legend.color.size} - Legend color size (UI: "Legend Color Size", default: 5)
#'   \item \code{legend.shape.size} - Legend shape size (UI: "Legend Shape Size", default: 5)
#'   \item \code{legend.color.breaks} - Legend tick breaks (UI: "Legend Tick Breaks", default: "")
#'   \item \code{min.value} - Minimum value (UI: "Min Value", default: NA)
#'   \item \code{max.value} - Maximum value (UI: "Max Value", default: NA)
#'   \item \code{trajectory.group.by} - Trajectory group by (UI: "Trajectory Group By", default: "")
#'   \item \code{add.trajectory.by.groups} - Add trajectory by groups (UI: "Add Trajectory By Groups", default: "")
#'   \item \code{trajectory.arrow.size} - Trajectory arrow size (UI: "Trajectory Arrow Size", default: 0.15)
#'   \item \code{do.ellipse} - Enable ellipses (UI: "Enable Ellipses", default: FALSE)
#'   \item \code{do.contour} - Enable contour (UI: "Enable Contour", default: FALSE)
#'   \item \code{hover.data} - Hover data columns (UI: "Hover Data", default: "")
#'   \item \code{hover.round.digits} - Hover round digits (UI: "Hover Round Digits", default: 5)
#' }
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#' \itemize{
#'   \item \code{webgl} - Plot with webGL (UI: "Plot with webGL", default: TRUE)
#'   \item \code{shape.fill} - Shape fill color (UI: "Shape Fill", default: "rgba(0, 0, 0, 0)")
#'   \item \code{shape.line.color} - Shape line color (UI: "Shape Line Color", default: "black")
#'   \item \code{shape.line.width} - Shape line width (UI: "Shape Line Width", default: 4)
#'   \item \code{shape.linetype} - Shape linetype (UI: "Shape Linetype", default: "solid")
#'   \item \code{shape.opacity} - Shape opacity (UI: "Shape Opacity", default: 1)
#'   \item \code{axis.title.font.size} - Axis title font size (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.title.font.color} - Axis title font color (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.title.font.family} - Axis title font family (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.showline} - Show axis lines (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.mirror} - Mirror axis lines (UI: via .uniform_axes_inputs_ui)
#'   \item \code{show.grid.x} - Show X gridlines (UI: via .uniform_axes_inputs_ui)
#'   \item \code{show.grid.y} - Show Y gridlines (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.linecolor} - Axis line color (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.linewidth} - Axis line width (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.tickfont.size} - Tick label size (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.tickfont.color} - Tick label color (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.tickfont.family} - Tick label font (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.tickangle.x} - X-axis tick angle (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.tickangle.y} - Y-axis tick angle (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.ticks} - Tick position (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.tickcolor} - Tick mark color (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.ticklen} - Tick mark length (UI: via .uniform_axes_inputs_ui)
#'   \item \code{axis.tickwidth} - Tick mark width (UI: via .uniform_axes_inputs_ui)
#'   \item \code{hline.intercepts} - Horizontal line Y-intercepts (UI: via .uniform_lines_inputs_ui)
#'   \item \code{hline.colors} - Horizontal line colors (UI: via .uniform_lines_inputs_ui)
#'   \item \code{hline.widths} - Horizontal line widths (UI: via .uniform_lines_inputs_ui)
#'   \item \code{hline.linetypes} - Horizontal line types (UI: via .uniform_lines_inputs_ui)
#'   \item \code{hline.opacities} - Horizontal line opacities (UI: via .uniform_lines_inputs_ui)
#'   \item \code{vline.intercepts} - Vertical line X-intercepts (UI: via .uniform_lines_inputs_ui)
#'   \item \code{vline.colors} - Vertical line colors (UI: via .uniform_lines_inputs_ui)
#'   \item \code{vline.widths} - Vertical line widths (UI: via .uniform_lines_inputs_ui)
#'   \item \code{vline.linetypes} - Vertical line types (UI: via .uniform_lines_inputs_ui)
#'   \item \code{vline.opacities} - Vertical line opacities (UI: via .uniform_lines_inputs_ui)
#'   \item \code{abline.slopes} - Diagonal line slopes (UI: via .uniform_lines_inputs_ui)
#'   \item \code{abline.intercepts} - Diagonal line Y-intercepts (UI: via .uniform_lines_inputs_ui)
#'   \item \code{abline.colors} - Diagonal line colors (UI: via .uniform_lines_inputs_ui)
#'   \item \code{abline.widths} - Diagonal line widths (UI: via .uniform_lines_inputs_ui)
#'   \item \code{abline.linetypes} - Diagonal line types (UI: via .uniform_lines_inputs_ui)
#'   \item \code{abline.opacities} - Diagonal line opacities (UI: via .uniform_lines_inputs_ui)
#'   \item \code{fit.line} - Fit line (UI: via .uniform_lines_inputs_ui)
#'   \item \code{fit.line.color} - Fit line color (UI: via .uniform_lines_inputs_ui)
#'   \item \code{fit.line.width} - Fit line width (UI: via .uniform_lines_inputs_ui)
#'   \item \code{fit.line.type} - Fit line type (UI: via .uniform_lines_inputs_ui)
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
#' @author Jared Andrews
#' @seealso [dittoViz::scatterPlot()], [VizModules::organize_inputs()],
#' [VizModules::dittoViz_scatterPlotOutputUI()], [VizModules::dittoViz_scatterPlotServer()], [VizModules::dittoViz_scatterPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' dittoViz_scatterPlotInputsUI("scatterPlot", mtcars)
dittoViz_scatterPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric),
        use.names = FALSE
    )])

    # Get categorical variables of data.
    cat.choices <- c("", names(data)[unlist(lapply(data,
        FUN = function(x) !is.numeric(x)
    ), use.names = FALSE)])

    # Various other choice vectors
    adj.choices <- c("", "z-score", "relative.to.max")
    adj.fxn.choices <- c("", "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt")

    selected <- c("x.by", "y.by", "color.by", "shape.by", "split.by",
            "rows.use", "x.adjustment", "y.adjustment", "color.adjustment",
            "x.adj.fxn", "y.adj.fxn", "color.adj.fxn",
            "size", "opacity", "show.others", "split.show.all.others",
            "plot.order", "shape.panel",
            "min.color", "max.color", "contour.color", "contour.linetype",
            "split.nrow", "split.ncol", "multivar.split.dir",
            "do.ellipse", "do.contour",
            "hover.data", "hover.round.digits",
            "legend.show", "legend.color.title", "legend.color.size",
            "legend.shape.size", "legend.color.breaks",
            "min.value", "max.value",
            "trajectory.group.by", "add.trajectory.by.groups",
            "trajectory.arrow.size")

    documentParameters <- get_documentation(
        package_name = "dittoViz::scatterPlot", type = "param",
        selected = selected, cap = TRUE
    )

    # Create list of Shiny inputs for most scatterPlot parameters
    # Broken up by sensible categories (e.g. "Data", "Point Styling")
    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("x.by"), "X Data",
                choices = choices,
                selected = ifelse("x.by" %in% names(defaults),
                    ifelse(defaults[["x.by"]] %in% choices, defaults[["x.by"]], choices[2]),
                    choices[2]
                )
            ), documentParameters$x.by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.by"), "Y Data",
                choices = choices,
                selected = ifelse("y.by" %in% names(defaults),
                    ifelse(defaults[["y.by"]] %in% choices, defaults[["y.by"]], choices[3]),
                    choices[3]
                )
            ), documentParameters$y.by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.by"), "Color By",
                choices = choices,
                selected = ifelse("color.by" %in% names(defaults),
                    ifelse(defaults[["color.by"]] %in% choices, defaults[["color.by"]], ""),
                    ""
                )
            ), documentParameters$color.by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("shape.by"), "Shape By",
                choices = cat.choices,
                selected = ifelse("shape.by" %in% names(defaults),
                    ifelse(defaults[["shape.by"]] %in% cat.choices, defaults[["shape.by"]], ""),
                    ""
                )
            ), documentParameters$shape.by, placement = "top", options = list(container = "body")),
            tipify(selectizeInput(ns("split.by"), "Split By",
                choices = cat.choices,
                selected = ifelse("split.by" %in% names(defaults),
                    ifelse(all(defaults[["split.by"]] %in% cat.choices), defaults[["split.by"]], ""),
                    ""
                ),
                multiple = TRUE,
                options = list(maxItems = 2)
            ), documentParameters$split.by, placement = "top", options = list(container = "body")),
            tipify(textInput(ns("rows.use"), "Rows Filter",
                placeholder = "Filter expression, e.g. Sepal.Length > 5",
                value = ifelse("rows.use" %in% names(defaults), defaults[["rows.use"]], "")
            ), documentParameters$rows.use, placement = "top", options = list(container = "body"))
        ),
        "Adjustments" = tagList(
            tipify(selectInput(ns("x.adjustment"), "X Adjustment",
                choices = adj.choices,
                selected = ifelse("x.adjustment" %in% names(defaults),
                    ifelse(defaults[["x.adjustment"]] %in% adj.choices, defaults[["x.adjustment"]], ""),
                    ""
                )
            ), documentParameters$x.adjustment, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.adjustment"), "Y Adjustment",
                choices = adj.choices,
                selected = ifelse("y.adjustment" %in% names(defaults),
                    ifelse(defaults[["y.adjustment"]] %in% adj.choices, defaults[["y.adjustment"]], ""),
                    ""
                )
            ), documentParameters$y.adjustment, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.adjustment"), "Color Adjustment",
                choices = adj.choices,
                selected = ifelse("color.adjustment" %in% names(defaults),
                    ifelse(defaults[["color.adjustment"]] %in% adj.choices, defaults[["color.adjustment"]], ""),
                    ""
                )
            ), documentParameters$color.adjustment, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("x.adj.fxn"), "X Adjustment Function",
                choices = adj.fxn.choices,
                selected = ifelse("x.adj.fxn" %in% names(defaults),
                    ifelse(defaults[["x.adj.fxn"]] %in% adj.fxn.choices, defaults[["x.adj.fxn"]], ""),
                    ""
                )
            ), documentParameters$x.adj.fxn, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.adj.fxn"), "Y Adjustment Function",
                choices = adj.fxn.choices,
                selected = ifelse("y.adj.fxn" %in% names(defaults),
                    ifelse(defaults[["y.adj.fxn"]] %in% adj.fxn.choices, defaults[["y.adj.fxn"]], ""),
                    ""
                )
            ), documentParameters$y.adj.fxn, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.adj.fxn"), "Color Adjustment Function",
                choices = adj.fxn.choices,
                selected = ifelse("color.adj.fxn" %in% names(defaults),
                    ifelse(defaults[["color.adj.fxn"]] %in% adj.fxn.choices, defaults[["color.adj.fxn"]], ""),
                    ""
                )
            ), documentParameters$color.adj.fxn, placement = "top", options = list(container = "body"))
        ),
        "Points" = tagList(
            tipify(numericInput(ns("size"), "Point Size",
                value = ifelse("size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["size"]]), defaults[["size"]], 1),
                    1
                ),
                min = 0.1
            ), documentParameters$size, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("opacity"), "Point Opacity",
                value = ifelse("opacity" %in% names(defaults),
                    ifelse(is.numeric(defaults[["opacity"]]), defaults[["opacity"]], 1),
                    1
                ),
                max = 1,
                min = 0,
                step = 0.05
            ), documentParameters$opacity, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("show.others"), "Show Others",
                value = ifelse("show.others" %in% names(defaults),
                    ifelse(is.logical(defaults[["show.others"]]), defaults[["show.others"]], TRUE),
                    TRUE
                )
            ), documentParameters$show.others, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("split.show.all.others"),
                "Show Split Others",
                value = ifelse("split.show.all.others" %in% names(defaults),
                    ifelse(is.logical(defaults[["split.show.all.others"]]), defaults[["split.show.all.others"]], TRUE),
                    TRUE
                )
            ), documentParameters$split.show.all.others, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("plot.order"), "Plot Order",
                choices = c("unordered", "increasing", "decreasing", "randomize"),
                selected = ifelse("plot.order" %in% names(defaults),
                    ifelse(defaults[["plot.order"]] %in% c(
                        "unordered", "increasing", "decreasing", "randomize"
                    ), defaults[["plot.order"]], "unordered"),
                    "unordered"
                )
            ), documentParameters$plot.order, placement = "top", options = list(container = "body")),
            tipify(textInput(ns("shape.panel"), "Shape Panel",
                value = ifelse("shape.panel" %in% names(defaults),
                    defaults[["shape.panel"]], "16, 15, 17, 23, 25, 8"
                )
            ), documentParameters$shape.panel, placement = "top", options = list(container = "body"))
        ),
        "Colors" = tagList(
            tipify(colourInput(ns("min.color"), "Min Color",
                value = ifelse("min.color" %in% names(defaults),
                    defaults[["min.color"]], "#F0E442"
                )
            ), documentParameters$min.color, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("max.color"), "Max Color",
                value = ifelse("max.color" %in% names(defaults),
                    defaults[["max.color"]], "#0072B2"
                )
            ), documentParameters$max.color, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("contour.color"), "Contour Color",
                value = ifelse("contour.color" %in% names(defaults),
                    defaults[["contour.color"]], "black"
                )
            ), documentParameters$contour.color, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("contour.linetype"), "Contour Linetype",
                choices = c(
                    "solid", "dashed", "dotted", "dotdash",
                    "longdash", "twodash"
                ),
                selected = ifelse("contour.linetype" %in% names(defaults),
                    ifelse(defaults[["contour.linetype"]] %in% c(
                        "solid", "dashed", "dotted", "dotdash",
                        "longdash", "twodash"
                    ), defaults[["contour.linetype"]], "solid"),
                    "solid"
                )
            ), documentParameters$contour.linetype, placement = "top", options = list(container = "body")),
            uiOutput(ns("color.panel.ui"))
        ),
        "Facets" = tagList(
            tipify(numericInput(ns("split.nrow"), "Split Rows",
                step = 1, min = 0,
                value = ifelse("split.nrow" %in% names(defaults) & is.numeric(defaults[["split.nrow"]]),
                    ifelse(is.numeric(defaults[["split.nrow"]]), defaults[["split.nrow"]], NA),
                    NA
                )
            ), documentParameters$split.nrow, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("split.ncol"), "Split Columns",
                step = 1, min = 0,
                value = ifelse("split.ncol" %in% names(defaults),
                    ifelse(is.numeric(defaults[["split.ncol"]]), defaults[["split.ncol"]], NA),
                    NA
                )
            ), documentParameters$split.ncol, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("multivar.split.dir"), "Multivar Split Dir",
                choices = c("col", "row"),
                selected = ifelse("multivar.split.dir" %in% names(defaults),
                    ifelse(defaults[["multivar.split.dir"]] %in% c("col", "row"),
                        defaults[["multivar.split.dir"]], "col"
                    ),
                    "col"
                )
            ), documentParameters$multivar.split.dir, placement = "top", options = list(container = "body")),
            selectInput(ns("split.adjust.scales"), "Facet Scales",
                choices = c("fixed", "free", "free_x", "free_y"),
                selected = ifelse("split.adjust.scales" %in% names(defaults),
                    ifelse(defaults[["split.adjust.scales"]] %in% c("fixed", "free", "free_x", "free_y"),
                        defaults[["split.adjust.scales"]], "fixed"
                    ),
                    "fixed"
                )
            )
        ),
        "Annotations" = tagList(
            selectInput(ns("annotate.by"), "Annotate By",
                choices = choices,
                selected = ifelse("annotate.by" %in% names(defaults),
                    ifelse(defaults[["annotate.by"]] %in% choices, defaults[["annotate.by"]], ""),
                    ""
                )
            ),
            textAreaInput(ns("highlight.points"), "Points to Highlight",
                placeholder = "Values from 'Annotate by' column\n(comma, space, or newline delimited)",
                value = ifelse("highlight.points" %in% names(defaults),
                    defaults[["highlight.points"]], ""
                ),
                rows = 3
            ),
            colourInput(ns("highlight.color"), "Highlight Fill",
                value = ifelse("highlight.color" %in% names(defaults),
                    defaults[["highlight.color"]], "#00FFF7"
                ),
                allowTransparent = TRUE
            ),
            numericInput(ns("highlight.size"), "Highlight Size",
                min = 0.1, step = 0.5,
                value = ifelse("highlight.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["highlight.size"]]), defaults[["highlight.size"]], 7),
                    7
                )
            ),
            colourInput(ns("highlight.border.color"), "Highlight Border Color",
                value = ifelse("highlight.border.color" %in% names(defaults),
                    defaults[["highlight.border.color"]], "#000000"
                )
            ),
            numericInput(ns("highlight.border.width"), "Highlight Border Width",
                min = 0, step = 0.25,
                value = ifelse("highlight.border.width" %in% names(defaults),
                    ifelse(is.numeric(defaults[["highlight.border.width"]]), defaults[["highlight.border.width"]], 0.5),
                    1
                )
            ),
            checkboxInput(ns("highlight.auto.annotate"), "Auto-annotate Highlights",
                value = ifelse("highlight.auto.annotate" %in% names(defaults),
                    ifelse(is.logical(defaults[["highlight.auto.annotate"]]), defaults[["highlight.auto.annotate"]], TRUE),
                    TRUE
                )
            ),
            colourInput(ns("annotation.color"), "Annotation Color",
                value = ifelse("annotation.color" %in% names(defaults),
                    defaults[["annotation.color"]], "black"
                )
            ),
            numericInput(ns("annotation.ax"), "Annotation X Offset",
                step = 1,
                value = ifelse("annotation.ax" %in% names(defaults),
                    ifelse(is.numeric(defaults[["annotation.ax"]]), defaults[["annotation.ax"]], 20),
                    20
                )
            ),
            numericInput(ns("annotation.ay"), "Annotation Y Offset",
                step = 1,
                value = ifelse("annotation.ay" %in% names(defaults),
                    ifelse(is.numeric(defaults[["annotation.ay"]]), defaults[["annotation.ay"]], -20),
                    -20
                )
            ),
            numericInput(ns("annotation.size"), "Annotation Size",
                min = 1, step = 0.5,
                value = ifelse("annotation.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["annotation.size"]]), defaults[["annotation.size"]], 10),
                    10
                )
            ),
            checkboxInput(ns("annotation.showarrow"), "Show Arrow",
                value = ifelse("annotation.showarrow" %in% names(defaults),
                    ifelse(is.logical(defaults[["annotation.showarrow"]]), defaults[["annotation.showarrow"]], TRUE),
                    TRUE
                )
            ),
            colourInput(ns("annotation.arrowcolor"), "Arrow Color",
                value = ifelse("annotation.arrowcolor" %in% names(defaults),
                    defaults[["annotation.arrowcolor"]], "black"
                )
            ),
            numericInput(ns("annotation.arrowhead"), "Arrowhead Style",
                min = 0, step = 1, max = 7,
                value = ifelse("annotation.arrowhead" %in% names(defaults),
                    ifelse(is.numeric(defaults[["annotation.arrowhead"]]), defaults[["annotation.arrowhead"]], 2),
                    2
                )
            ),
            numericInput(ns("annotation.arrowwidth"), "Arrow Linewidth",
                min = 0.1, step = 0.25,
                value = ifelse("annotation.arrowwidth" %in% names(defaults),
                    ifelse(is.numeric(defaults[["annotation.arrowwidth"]]), defaults[["annotation.arrowwidth"]], 1.5),
                    1.5
                )
            ),
            actionButton(ns("annotation.clear"), "Clear Annotations")
        ),
        "Legend/Scale" = tagList(
            tipify(checkboxInput(ns("legend.show"), "Show Legend",
                value = ifelse("legend.show" %in% names(defaults),
                    ifelse(is.logical(defaults[["legend.show"]]), defaults[["legend.show"]], TRUE),
                    TRUE
                )
            ), documentParameters$legend.show, placement = "top", options = list(container = "body")),
            tipify(textInput(ns("legend.color.title"), "Legend Title",
                value = ifelse("legend.color.title" %in% names(defaults),
                    defaults[["legend.color.title"]], "make"
                )
            ), documentParameters$legend.color.title, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("legend.color.size"), "Legend Color Size",
                min = 1,
                value = ifelse("legend.color.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["legend.color.size"]]), defaults[["legend.color.size"]], 5),
                    5
                )
            ), documentParameters$legend.color.size, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("legend.shape.size"), "Legend Shape Size",
                min = 1,
                value = ifelse("legend.shape.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["legend.shape.size"]]), defaults[["legend.shape.size"]], 5),
                    5
                )
            ), documentParameters$legend.shape.size, placement = "top", options = list(container = "body")),
            tipify(textInput(ns("legend.color.breaks"), "Legend Tick Breaks",
                placeholder = "e.g. -3, 0, 3",
                value = ifelse("legend.color.breaks" %in% names(defaults),
                    ifelse(is.character(defaults[["legend.color.breaks"]]), defaults[["legend.color.breaks"]], ""),
                    ""
                )
            ), documentParameters$legend.color.breaks, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("min.value"), "Min Value",
                value = ifelse("min.value" %in% names(defaults),
                    ifelse(is.numeric(defaults[["min.value"]]), defaults[["min.value"]], NA),
                    NA
                )
            ), documentParameters$min.value, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("max.value"), "Max Value",
                value = ifelse("max.value" %in% names(defaults),
                    ifelse(is.numeric(defaults[["max.value"]]), defaults[["max.value"]], NA),
                    NA
                )
            ), documentParameters$max.value, placement = "top", options = list(container = "body"))
        ),
        "Trajectory" = tagList(
            tipify(selectInput(ns("trajectory.group.by"), "Trajectory Group By",
                choices = cat.choices,
                selected = ifelse("trajectory.group.by" %in% names(defaults),
                    ifelse(defaults[["trajectory.group.by"]] %in% cat.choices, defaults[["trajectory.group.by"]], ""),
                    ""
                )
            ), documentParameters$trajectory.group.by, placement = "top", options = list(container = "body")),
            tipify(textInput(ns("add.trajectory.by.groups"), "Add Trajectory By Groups",
                placeholder = "e.g. [A,B],[C,D,E]",
                value = ifelse("add.trajectory.by.groups" %in% names(defaults),
                    defaults[["add.trajectory.by.groups"]], ""
                )
            ), documentParameters$add.trajectory.by.groups, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("trajectory.arrow.size"), "Trajectory Arrow Size",
                value = ifelse("trajectory.arrow.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["trajectory.arrow.size"]]), defaults[["trajectory.arrow.size"]], 0.15),
                    0.15
                ),
                min = 0,
                step = 0.05
            ), documentParameters$trajectory.arrow.size, placement = "top", options = list(container = "body"))
        ),
        "Plotly" = tagList(
            checkboxInput(ns("webgl"), "Plot with webGL",
                value = ifelse("webgl" %in% names(defaults),
                    ifelse(is.logical(defaults[["webgl"]]), defaults[["webgl"]], TRUE),
                    TRUE
                )
            ),
            colourInput(ns("shape.fill"), "Shape Fill",
                allowTransparent = TRUE,
                value = ifelse("shape.fill" %in% names(defaults),
                    defaults[["shape.fill"]], "rgba(0, 0, 0, 0)"
                )
            ),
            colourInput(ns("shape.line.color"), "Shape Line Color",
                allowTransparent = TRUE,
                value = ifelse("shape.line.color" %in% names(defaults),
                    defaults[["shape.line.color"]], "black"
                )
            ),
            numericInput(ns("shape.line.width"), "Shape Line Width",
                value = ifelse("shape.line.width" %in% names(defaults),
                    ifelse(is.numeric(defaults[["shape.line.width"]]), defaults[["shape.line.width"]], 4),
                    4
                ),
                min = 0,
                step = 0.25
            ),
            selectInput(ns("shape.linetype"), "Shape Linetype",
                choices = c(
                    "solid", "dot", "dash", "longdash",
                    "dashdot", "longdashdot"
                ),
                selected = ifelse("shape.linetype" %in% names(defaults),
                    ifelse(defaults[["shape.linetype"]] %in% c(
                        "solid", "dot", "dash", "longdash",
                        "dashdot", "longdashdot"
                    ), defaults[["shape.linetype"]], "solid"),
                    "solid"
                )
            ),
            numericInput(ns("shape.opacity"), "Shape Opacity",
                value = ifelse("shape.opacity" %in% names(defaults),
                    ifelse(is.numeric(defaults[["shape.opacity"]]), defaults[["shape.opacity"]], 1),
                    1
                ),
                min = 0,
                max = 1,
                step = 0.01
            )
        ),
        "Extras" = tagList(
            tipify(checkboxInput(ns("do.ellipse"), "Enable Ellipses",
                value = ifelse("do.ellipse" %in% names(defaults),
                    ifelse(is.logical(defaults[["do.ellipse"]]), defaults[["do.ellipse"]], FALSE),
                    FALSE
                )
            ), documentParameters$do.ellipse, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("do.contour"), "Enable Contour",
                value = ifelse("do.contour" %in% names(defaults),
                    ifelse(is.logical(defaults[["do.contour"]]), defaults[["do.contour"]], FALSE),
                    FALSE
                )
            ), documentParameters$do.contour, placement = "top", options = list(container = "body")),
            tipify(selectizeInput(ns("hover.data"), "Hover Data",
                choices = choices,
                multiple = TRUE,
                selected = ifelse("hover.data" %in% names(defaults),
                    ifelse(all(defaults[["hover.data"]] %in% choices), defaults[["hover.data"]], ""),
                    ""
                )
            ), documentParameters$hover.data, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("hover.round.digits"), "Hover Round Digits",
                value = ifelse("hover.round.digits" %in% names(defaults),
                    ifelse(is.numeric(defaults[["hover.round.digits"]]), defaults[["hover.round.digits"]], 5),
                    5
                ),
                step = 1,
                min = 1
            ), documentParameters$hover.round.digits, placement = "top", options = list(container = "body"))
        ),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults, include.fit.lines = TRUE),
        "Axes" = .uniform_axes_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("scatterPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the scatterPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the scatterplot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
dittoViz_scatterPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("scatterPlot"))
    )
}
