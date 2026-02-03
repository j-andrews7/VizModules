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
#' There are also a handful that are specific to the Shiny module that additionally modify the plotly output:
#'
#' - `id`: The ID for the Shiny module.
#' - `marginal.plots`: Select types of marginal distribution plots to display (histogram, density, rug).
#'   Note: Marginal plots work best without faceting (split.by). When faceting is used, marginals show
#'   the combined distribution across all facets.
#' - `marginal.sides`: Choose which sides to display marginal plots (top, right, or both)
#' - `marginal.size`: Control the relative size of marginal plots (0.05-0.5)
#' - `marginal.opacity`: Set the opacity of marginal plot elements (0-1)
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [dittoViz::scatterPlot()] parameters are superseded by the enhanced Lines tab:
#' \itemize{
#'   \item \code{add.xline} - Use \code{vline.intercepts} instead for vertical lines with full styling options
#'   \item \code{add.yline} - Use \code{hline.intercepts} instead for horizontal lines with full styling options
#'   \item \code{xline.linetype} - Use \code{vline.linetypes} instead
#'   \item \code{xline.color} - Use \code{vline.colors} instead
#'   \item \code{yline.linetype} - Use \code{hline.linetypes} instead
#'   \item \code{yline.color} - Use \code{hline.colors} instead
#' }
#' The new Lines tab provides enhanced functionality including multiple lines per type,
#' individual line widths, opacities, and diagonal/ablines with slope control.
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

    # Create list of Shiny inputs for most scatterPlot parameters
    # Broken up by sensible categories (e.g. "Data", "Point Styling")
    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.by"), "X Data",
                choices = choices,
                selected = ifelse("x.by" %in% names(defaults),
                    ifelse(defaults[["x.by"]] %in% choices, defaults[["x.by"]], choices[2]),
                    choices[2]
                )
            ),
            selectInput(ns("y.by"), "Y Data",
                choices = choices,
                selected = ifelse("y.by" %in% names(defaults),
                    ifelse(defaults[["y.by"]] %in% choices, defaults[["y.by"]], choices[3]),
                    choices[3]
                )
            ),
            selectInput(ns("color.by"), "Color By",
                choices = choices,
                selected = ifelse("color.by" %in% names(defaults),
                    ifelse(defaults[["color.by"]] %in% choices, defaults[["color.by"]], ""),
                    ""
                )
            ),
            selectInput(ns("shape.by"), "Shape By",
                choices = cat.choices,
                selected = ifelse("shape.by" %in% names(defaults),
                    ifelse(defaults[["shape.by"]] %in% cat.choices, defaults[["shape.by"]], ""),
                    ""
                )
            ),
            selectizeInput(ns("split.by"), "Split By",
                choices = cat.choices,
                selected = ifelse("split.by" %in% names(defaults),
                    ifelse(all(defaults[["split.by"]] %in% cat.choices), defaults[["split.by"]], ""),
                    ""
                ),
                multiple = TRUE,
                options = list(maxItems = 2)
            ),
            textInput(ns("rows.use"), "Rows Filter",
                placeholder = "Filter expression, e.g. Sepal.Length > 5",
                value = ifelse("rows.use" %in% names(defaults), defaults[["rows.use"]], "")
            )
        ),
        "Adjustments" = tagList(
            selectInput(ns("x.adjustment"), "X Adjustment",
                choices = adj.choices,
                selected = ifelse("x.adjustment" %in% names(defaults),
                    ifelse(defaults[["x.adjustment"]] %in% adj.choices, defaults[["x.adjustment"]], ""),
                    ""
                )
            ),
            selectInput(ns("y.adjustment"), "Y Adjustment",
                choices = adj.choices,
                selected = ifelse("y.adjustment" %in% names(defaults),
                    ifelse(defaults[["y.adjustment"]] %in% adj.choices, defaults[["y.adjustment"]], ""),
                    ""
                )
            ),
            selectInput(ns("color.adjustment"), "Color Adjustment",
                choices = adj.choices,
                selected = ifelse("color.adjustment" %in% names(defaults),
                    ifelse(defaults[["color.adjustment"]] %in% adj.choices, defaults[["color.adjustment"]], ""),
                    ""
                )
            ),
            selectInput(ns("x.adj.fxn"), "X Adjustment Function",
                choices = adj.fxn.choices,
                selected = ifelse("x.adj.fxn" %in% names(defaults),
                    ifelse(defaults[["x.adj.fxn"]] %in% adj.fxn.choices, defaults[["x.adj.fxn"]], ""),
                    ""
                )
            ),
            selectInput(ns("y.adj.fxn"), "Y Adjustment Function",
                choices = adj.fxn.choices,
                selected = ifelse("y.adj.fxn" %in% names(defaults),
                    ifelse(defaults[["y.adj.fxn"]] %in% adj.fxn.choices, defaults[["y.adj.fxn"]], ""),
                    ""
                )
            ),
            selectInput(ns("color.adj.fxn"), "Color Adjustment Function",
                choices = adj.fxn.choices,
                selected = ifelse("color.adj.fxn" %in% names(defaults),
                    ifelse(defaults[["color.adj.fxn"]] %in% adj.fxn.choices, defaults[["color.adj.fxn"]], ""),
                    ""
                )
            )
        ),
        "Points" = tagList(
            numericInput(ns("size"), "Point Size",
                value = ifelse("size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["size"]]), defaults[["size"]], 1),
                    1
                ),
                min = 0.1
            ),
            numericInput(ns("opacity"), "Point Opacity",
                value = ifelse("opacity" %in% names(defaults),
                    ifelse(is.numeric(defaults[["opacity"]]), defaults[["opacity"]], 1),
                    1
                ),
                max = 1,
                min = 0,
                step = 0.05
            ),
            checkboxInput(ns("show.others"), "Show Others",
                value = ifelse("show.others" %in% names(defaults),
                    ifelse(is.logical(defaults[["show.others"]]), defaults[["show.others"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("split.show.all.others"),
                "Show Split Others",
                value = ifelse("split.show.all.others" %in% names(defaults),
                    ifelse(is.logical(defaults[["split.show.all.others"]]), defaults[["split.show.all.others"]], TRUE),
                    TRUE
                )
            ),
            selectInput(ns("plot.order"), "Plot Order",
                choices = c("unordered", "increasing", "decreasing", "randomize"),
                selected = ifelse("plot.order" %in% names(defaults),
                    ifelse(defaults[["plot.order"]] %in% c(
                        "unordered", "increasing", "decreasing", "randomize"
                    ), defaults[["plot.order"]], "unordered"),
                    "unordered"
                )
            ),
            textInput(ns("shape.panel"), "Shape Panel",
                value = ifelse("shape.panel" %in% names(defaults),
                    defaults[["shape.panel"]], "16, 15, 17, 23, 25, 8"
                )
            )
        ),
        "Colors" = tagList(
            colourInput(ns("min.color"), "Min Color",
                value = ifelse("min.color" %in% names(defaults),
                    defaults[["min.color"]], "#F0E442"
                )
            ),
            colourInput(ns("max.color"), "Max Color",
                value = ifelse("max.color" %in% names(defaults),
                    defaults[["max.color"]], "#0072B2"
                )
            ),
            colourInput(ns("contour.color"), "Contour Color",
                value = ifelse("contour.color" %in% names(defaults),
                    defaults[["contour.color"]], "black"
                )
            ),
            selectInput(ns("contour.linetype"), "Contour Linetype",
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
            ),
            uiOutput(ns("color.panel.ui"))
        ),
        "Facets" = tagList(
            numericInput(ns("split.nrow"), "Split Rows",
                step = 1, min = 0,
                value = ifelse("split.nrow" %in% names(defaults) & is.numeric(defaults[["split.nrow"]]),
                    ifelse(is.numeric(defaults[["split.nrow"]]), defaults[["split.nrow"]], NA),
                    NA
                )
            ),
            numericInput(ns("split.ncol"), "Split Columns",
                step = 1, min = 0,
                value = ifelse("split.ncol" %in% names(defaults),
                    ifelse(is.numeric(defaults[["split.ncol"]]), defaults[["split.ncol"]], NA),
                    NA
                )
            ),
            selectInput(ns("multivar.split.dir"), "Multivar Split Dir",
                choices = c("col", "row"),
                selected = ifelse("multivar.split.dir" %in% names(defaults),
                    ifelse(defaults[["multivar.split.dir"]] %in% c("col", "row"),
                        defaults[["multivar.split.dir"]], "col"
                    ),
                    "col"
                )
            ),
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
            checkboxInput(ns("legend.show"), "Show Legend",
                value = ifelse("legend.show" %in% names(defaults),
                    ifelse(is.logical(defaults[["legend.show"]]), defaults[["legend.show"]], TRUE),
                    TRUE
                )
            ),
            textInput(ns("legend.color.title"), "Legend Title",
                value = ifelse("legend.color.title" %in% names(defaults),
                    defaults[["legend.color.title"]], "make"
                )
            ),
            numericInput(ns("legend.color.size"), "Legend Color Size",
                min = 1,
                value = ifelse("legend.color.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["legend.color.size"]]), defaults[["legend.color.size"]], 5),
                    5
                )
            ),
            numericInput(ns("legend.shape.size"), "Legend Shape Size",
                min = 1,
                value = ifelse("legend.shape.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["legend.shape.size"]]), defaults[["legend.shape.size"]], 5),
                    5
                )
            ),
            textInput(ns("legend.color.breaks"), "Legend Tick Breaks",
                placeholder = "e.g. -3, 0, 3",
                value = ifelse("legend.color.breaks" %in% names(defaults),
                    ifelse(is.character(defaults[["legend.color.breaks"]]), defaults[["legend.color.breaks"]], ""),
                    ""
                )
            ),
            numericInput(ns("min.value"), "Min Value",
                value = ifelse("min.value" %in% names(defaults),
                    ifelse(is.numeric(defaults[["min.value"]]), defaults[["min.value"]], NA),
                    NA
                )
            ),
            numericInput(ns("max.value"), "Max Value",
                value = ifelse("max.value" %in% names(defaults),
                    ifelse(is.numeric(defaults[["max.value"]]), defaults[["max.value"]], NA),
                    NA
                )
            )
        ),
        "Trajectory" = tagList(
            selectInput(ns("trajectory.group.by"), "Trajectory Group By",
                choices = cat.choices,
                selected = ifelse("trajectory.group.by" %in% names(defaults),
                    ifelse(defaults[["trajectory.group.by"]] %in% cat.choices, defaults[["trajectory.group.by"]], ""),
                    ""
                )
            ),
            textInput(ns("add.trajectory.by.groups"), "Add Trajectory By Groups",
                placeholder = "e.g. [A,B],[C,D,E]",
                value = ifelse("add.trajectory.by.groups" %in% names(defaults),
                    defaults[["add.trajectory.by.groups"]], ""
                )
            ),
            numericInput(ns("trajectory.arrow.size"), "Trajectory Arrow Size",
                value = ifelse("trajectory.arrow.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["trajectory.arrow.size"]]), defaults[["trajectory.arrow.size"]], 0.15),
                    0.15
                ),
                min = 0,
                step = 0.05
            )
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
            checkboxInput(ns("do.ellipse"), "Enable Ellipses",
                value = ifelse("do.ellipse" %in% names(defaults),
                    ifelse(is.logical(defaults[["do.ellipse"]]), defaults[["do.ellipse"]], FALSE),
                    FALSE
                )
            ),
            checkboxInput(ns("do.contour"), "Enable Contour",
                value = ifelse("do.contour" %in% names(defaults),
                    ifelse(is.logical(defaults[["do.contour"]]), defaults[["do.contour"]], FALSE),
                    FALSE
                )
            ),
            selectizeInput(ns("hover.data"), "Hover Data",
                choices = choices,
                multiple = TRUE,
                selected = ifelse("hover.data" %in% names(defaults),
                    ifelse(all(defaults[["hover.data"]] %in% choices), defaults[["hover.data"]], ""),
                    ""
                )
            ),
            numericInput(ns("hover.round.digits"), "Hover Round Digits",
                value = ifelse("hover.round.digits" %in% names(defaults),
                    ifelse(is.numeric(defaults[["hover.round.digits"]]), defaults[["hover.round.digits"]], 5),
                    5
                ),
                step = 1,
                min = 1
            ),
            selectizeInput(ns("marginal.plots"), "Marginal Plots",
                choices = c("histogram", "density", "rug"),
                multiple = TRUE,
                selected = ifelse("marginal.plots" %in% names(defaults),
                    defaults[["marginal.plots"]], character(0)
                )
            ),
            selectInput(ns("marginal.sides"), "Marginal Sides",
                choices = c("top" = "t", "right" = "r", "both" = "tr"),
                selected = ifelse("marginal.sides" %in% names(defaults),
                    defaults[["marginal.sides"]], "tr"
                )
            ),
            numericInput(ns("marginal.size"), "Marginal Size",
                value = ifelse("marginal.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["marginal.size"]]), defaults[["marginal.size"]], 0.15),
                    0.15
                ),
                min = 0.05,
                max = 0.5,
                step = 0.05
            ),
            numericInput(ns("marginal.opacity"), "Marginal Opacity",
                value = ifelse("marginal.opacity" %in% names(defaults),
                    ifelse(is.numeric(defaults[["marginal.opacity"]]), defaults[["marginal.opacity"]], 0.6),
                    0.6
                ),
                min = 0,
                max = 1,
                step = 0.1
            )
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
