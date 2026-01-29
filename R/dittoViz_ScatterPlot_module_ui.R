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
            selectInput(ns("x.by"), "X-axis variable",
                choices = choices,
                selected = ifelse("x.by" %in% names(defaults),
                    ifelse(defaults[["x.by"]] %in% choices, defaults[["x.by"]], choices[2]),
                    choices[2]
                )
            ),
            selectInput(ns("y.by"), "Y-axis variable",
                choices = choices,
                selected = ifelse("y.by" %in% names(defaults),
                    ifelse(defaults[["y.by"]] %in% choices, defaults[["y.by"]], choices[3]),
                    choices[3]
                )
            ),
            selectInput(ns("color.by"), "Color by",
                choices = choices,
                selected = ifelse("color.by" %in% names(defaults),
                    ifelse(defaults[["color.by"]] %in% choices, defaults[["color.by"]], ""),
                    ""
                )
            ),
            selectInput(ns("shape.by"), "Shape by",
                choices = cat.choices,
                selected = ifelse("shape.by" %in% names(defaults),
                    ifelse(defaults[["shape.by"]] %in% cat.choices, defaults[["shape.by"]], ""),
                    ""
                )
            ),
            selectizeInput(ns("split.by"), "Split by",
                choices = cat.choices,
                selected = ifelse("split.by" %in% names(defaults),
                    ifelse(all(defaults[["split.by"]] %in% cat.choices), defaults[["split.by"]], ""),
                    ""
                ),
                multiple = TRUE,
                options = list(maxItems = 2)
            ),
            textInput(ns("rows.use"), "Rows to plot",
                placeholder = "Filter expression, e.g. Sepal.Length > 5",
                value = ifelse("rows.use" %in% names(defaults), defaults[["rows.use"]], "")
            )
        ),
        "Adjustments" = tagList(
            selectInput(ns("x.adjustment"), "X-axis adjustment",
                choices = adj.choices,
                selected = ifelse("x.adjustment" %in% names(defaults),
                    ifelse(defaults[["x.adjustment"]] %in% adj.choices, defaults[["x.adjustment"]], ""),
                    ""
                )
            ),
            selectInput(ns("y.adjustment"), "Y-axis adjustment",
                choices = adj.choices,
                selected = ifelse("y.adjustment" %in% names(defaults),
                    ifelse(defaults[["y.adjustment"]] %in% adj.choices, defaults[["y.adjustment"]], ""),
                    ""
                )
            ),
            selectInput(ns("color.adjustment"), "Color adjustment",
                choices = adj.choices,
                selected = ifelse("color.adjustment" %in% names(defaults),
                    ifelse(defaults[["color.adjustment"]] %in% adj.choices, defaults[["color.adjustment"]], ""),
                    ""
                )
            ),
            selectInput(ns("x.adj.fxn"), "X-axis adjustment function",
                choices = adj.fxn.choices,
                selected = ifelse("x.adj.fxn" %in% names(defaults),
                    ifelse(defaults[["x.adj.fxn"]] %in% adj.fxn.choices, defaults[["x.adj.fxn"]], ""),
                    ""
                )
            ),
            selectInput(ns("y.adj.fxn"), "Y-axis adjustment function",
                choices = adj.fxn.choices,
                selected = ifelse("y.adj.fxn" %in% names(defaults),
                    ifelse(defaults[["y.adj.fxn"]] %in% adj.fxn.choices, defaults[["y.adj.fxn"]], ""),
                    ""
                )
            ),
            selectInput(ns("color.adj.fxn"), "Color adjustment function",
                choices = adj.fxn.choices,
                selected = ifelse("color.adj.fxn" %in% names(defaults),
                    ifelse(defaults[["color.adj.fxn"]] %in% adj.fxn.choices, defaults[["color.adj.fxn"]], ""),
                    ""
                )
            )
        ),
        "Points" = tagList(
            numericInput(ns("size"), "Point size",
                value = ifelse("size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["size"]]), defaults[["size"]], 1),
                    1
                ),
                min = 0.1
            ),
            numericInput(ns("opacity"), "Point opacity",
                value = ifelse("opacity" %in% names(defaults),
                    ifelse(is.numeric(defaults[["opacity"]]), defaults[["opacity"]], 1),
                    1
                ),
                max = 1,
                min = 0,
                step = 0.05
            ),
            checkboxInput(ns("show.others"), "Show others",
                value = ifelse("show.others" %in% names(defaults),
                    ifelse(is.logical(defaults[["show.others"]]), defaults[["show.others"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("split.show.all.others"),
                "Show split others",
                value = ifelse("split.show.all.others" %in% names(defaults),
                    ifelse(is.logical(defaults[["split.show.all.others"]]), defaults[["split.show.all.others"]], TRUE),
                    TRUE
                )
            ),
            selectInput(ns("plot.order"), "Plot order",
                choices = c("unordered", "increasing", "decreasing", "randomize"),
                selected = ifelse("plot.order" %in% names(defaults),
                    ifelse(defaults[["plot.order"]] %in% c(
                        "unordered", "increasing", "decreasing", "randomize"
                    ), defaults[["plot.order"]], "unordered"),
                    "unordered"
                )
            ),
            textInput(ns("shape.panel"), "Shape panel",
                value = ifelse("shape.panel" %in% names(defaults),
                    defaults[["shape.panel"]], "16, 15, 17, 23, 25, 8"
                )
            )
        ),
        "Colors" = tagList(
            colourInput(ns("min.color"), "Min color",
                value = ifelse("min.color" %in% names(defaults),
                    defaults[["min.color"]], "#F0E442"
                )
            ),
            colourInput(ns("max.color"), "Max color",
                value = ifelse("max.color" %in% names(defaults),
                    defaults[["max.color"]], "#0072B2"
                )
            ),
            colourInput(ns("contour.color"), "Contour color",
                value = ifelse("contour.color" %in% names(defaults),
                    defaults[["contour.color"]], "black"
                )
            ),
            selectInput(ns("contour.linetype"), "Contour linetype",
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
            numericInput(ns("split.nrow"), "Split nrow",
                step = 1, min = 0,
                value = ifelse("split.nrow" %in% names(defaults) & is.numeric(defaults[["split.nrow"]]),
                    ifelse(is.numeric(defaults[["split.nrow"]]), defaults[["split.nrow"]], NA),
                    NA
                )
            ),
            numericInput(ns("split.ncol"), "Split ncol",
                step = 1, min = 0,
                value = ifelse("split.ncol" %in% names(defaults),
                    ifelse(is.numeric(defaults[["split.ncol"]]), defaults[["split.ncol"]], NA),
                    NA
                )
            ),
            selectInput(ns("multivar.split.dir"), "Multivar split dir",
                choices = c("col", "row"),
                selected = ifelse("multivar.split.dir" %in% names(defaults),
                    ifelse(defaults[["multivar.split.dir"]] %in% c("col", "row"),
                        defaults[["multivar.split.dir"]], "col"
                    ),
                    "col"
                )
            ),
            selectInput(ns("split.adjust.scales"), "Facet scales",
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
            selectInput(ns("annotate.by"), "Annotate by",
                choices = choices,
                selected = ifelse("annotate.by" %in% names(defaults),
                    ifelse(defaults[["annotate.by"]] %in% choices, defaults[["annotate.by"]], ""),
                    ""
                )
            ),
            textAreaInput(ns("highlight.points"), "Points to highlight",
                placeholder = "Values from 'Annotate by' column\n(comma, space, or newline delimited)",
                value = ifelse("highlight.points" %in% names(defaults),
                    defaults[["highlight.points"]], ""
                ),
                rows = 3
            ),
            colourInput(ns("highlight.color"), "Highlight color",
                value = ifelse("highlight.color" %in% names(defaults),
                    defaults[["highlight.color"]], "#00FFF7"
                ),
                allowTransparent = TRUE
            ),
            numericInput(ns("highlight.size"), "Highlight size",
                min = 0.1, step = 0.5,
                value = ifelse("highlight.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["highlight.size"]]), defaults[["highlight.size"]], 7),
                    7
                )
            ),
            colourInput(ns("highlight.border.color"), "Highlight border color",
                value = ifelse("highlight.border.color" %in% names(defaults),
                    defaults[["highlight.border.color"]], "#000000"
                )
            ),
            numericInput(ns("highlight.border.width"), "Highlight border width",
                min = 0, step = 0.25,
                value = ifelse("highlight.border.width" %in% names(defaults),
                    ifelse(is.numeric(defaults[["highlight.border.width"]]), defaults[["highlight.border.width"]], 0.5),
                    1
                )
            ),
            checkboxInput(ns("highlight.auto.annotate"), "Auto-annotate highlighted points",
                value = ifelse("highlight.auto.annotate" %in% names(defaults),
                    ifelse(is.logical(defaults[["highlight.auto.annotate"]]), defaults[["highlight.auto.annotate"]], TRUE),
                    TRUE
                )
            ),
            colourInput(ns("annotation.color"), "Annotation color",
                value = ifelse("annotation.color" %in% names(defaults),
                    defaults[["annotation.color"]], "black"
                )
            ),
            numericInput(ns("annotation.ax"), "Annotation x-axis offset",
                step = 1,
                value = ifelse("annotation.ax" %in% names(defaults),
                    ifelse(is.numeric(defaults[["annotation.ax"]]), defaults[["annotation.ax"]], 20),
                    20
                )
            ),
            numericInput(ns("annotation.ay"), "Annotation y-axis offset",
                step = 1,
                value = ifelse("annotation.ay" %in% names(defaults),
                    ifelse(is.numeric(defaults[["annotation.ay"]]), defaults[["annotation.ay"]], -20),
                    -20
                )
            ),
            numericInput(ns("annotation.size"), "Annotation size",
                min = 1, step = 0.5,
                value = ifelse("annotation.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["annotation.size"]]), defaults[["annotation.size"]], 10),
                    10
                )
            ),
            checkboxInput(ns("annotation.showarrow"), "Show arrow",
                value = ifelse("annotation.showarrow" %in% names(defaults),
                    ifelse(is.logical(defaults[["annotation.showarrow"]]), defaults[["annotation.showarrow"]], TRUE),
                    TRUE
                )
            ),
            colourInput(ns("annotation.arrowcolor"), "Arrow color",
                value = ifelse("annotation.arrowcolor" %in% names(defaults),
                    defaults[["annotation.arrowcolor"]], "black"
                )
            ),
            numericInput(ns("annotation.arrowhead"), "Arrowhead style",
                min = 0, step = 1, max = 7,
                value = ifelse("annotation.arrowhead" %in% names(defaults),
                    ifelse(is.numeric(defaults[["annotation.arrowhead"]]), defaults[["annotation.arrowhead"]], 2),
                    2
                )
            ),
            numericInput(ns("annotation.arrowwidth"), "Arrow linewidth",
                min = 0.1, step = 0.25,
                value = ifelse("annotation.arrowwidth" %in% names(defaults),
                    ifelse(is.numeric(defaults[["annotation.arrowwidth"]]), defaults[["annotation.arrowwidth"]], 1.5),
                    1.5
                )
            ),
            actionButton(ns("annotation.clear"), "Clear annotations")
        ),
        "Legend/Scale" = tagList(
            checkboxInput(ns("legend.show"), "Enable legend",
                value = ifelse("legend.show" %in% names(defaults),
                    ifelse(is.logical(defaults[["legend.show"]]), defaults[["legend.show"]], TRUE),
                    TRUE
                )
            ),
            textInput(ns("legend.color.title"), "Legend title",
                value = ifelse("legend.color.title" %in% names(defaults),
                    defaults[["legend.color.title"]], "make"
                )
            ),
            numericInput(ns("legend.color.size"), "Legend color size",
                min = 1,
                value = ifelse("legend.color.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["legend.color.size"]]), defaults[["legend.color.size"]], 5),
                    5
                )
            ),
            numericInput(ns("legend.shape.size"), "Legend shape size",
                min = 1,
                value = ifelse("legend.shape.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["legend.shape.size"]]), defaults[["legend.shape.size"]], 5),
                    5
                )
            ),
            textInput(ns("legend.color.breaks"), "Legend tick breaks",
                placeholder = "e.g. -3, 0, 3",
                value = ifelse("legend.color.breaks" %in% names(defaults),
                    ifelse(is.character(defaults[["legend.color.breaks"]]), defaults[["legend.color.breaks"]], ""),
                    ""
                )
            ),
            numericInput(ns("min.value"), "Min value",
                value = ifelse("min.value" %in% names(defaults),
                    ifelse(is.numeric(defaults[["min.value"]]), defaults[["min.value"]], NA),
                    NA
                )
            ),
            numericInput(ns("max.value"), "Max value",
                value = ifelse("max.value" %in% names(defaults),
                    ifelse(is.numeric(defaults[["max.value"]]), defaults[["max.value"]], NA),
                    NA
                )
            )
        ),
        "Trajectory" = tagList(
            selectInput(ns("trajectory.group.by"), "Trajectory group by",
                choices = cat.choices,
                selected = ifelse("trajectory.group.by" %in% names(defaults),
                    ifelse(defaults[["trajectory.group.by"]] %in% cat.choices, defaults[["trajectory.group.by"]], ""),
                    ""
                )
            ),
            textInput(ns("add.trajectory.by.groups"), "Add trajectory by groups",
                placeholder = "e.g. [A,B],[C,D,E]",
                value = ifelse("add.trajectory.by.groups" %in% names(defaults),
                    defaults[["add.trajectory.by.groups"]], ""
                )
            ),
            numericInput(ns("trajectory.arrow.size"), "Trajectory arrow size",
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
            colourInput(ns("shape.fill"), "Shape fill",
                allowTransparent = TRUE,
                value = ifelse("shape.fill" %in% names(defaults),
                    defaults[["shape.fill"]], "rgba(0, 0, 0, 0)"
                )
            ),
            colourInput(ns("shape.line.color"), "Shape line color",
                allowTransparent = TRUE,
                value = ifelse("shape.line.color" %in% names(defaults),
                    defaults[["shape.line.color"]], "black"
                )
            ),
            numericInput(ns("shape.line.width"), "Shape line width",
                value = ifelse("shape.line.width" %in% names(defaults),
                    ifelse(is.numeric(defaults[["shape.line.width"]]), defaults[["shape.line.width"]], 4),
                    4
                ),
                min = 0,
                step = 0.25
            ),
            selectInput(ns("shape.linetype"), "Shape linetype",
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
            numericInput(ns("shape.opacity"), "Shape opacity",
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
            checkboxInput(ns("do.ellipse"), "Enable ellipses",
                value = ifelse("do.ellipse" %in% names(defaults),
                    ifelse(is.logical(defaults[["do.ellipse"]]), defaults[["do.ellipse"]], FALSE),
                    FALSE
                )
            ),
            checkboxInput(ns("do.contour"), "Enable contour",
                value = ifelse("do.contour" %in% names(defaults),
                    ifelse(is.logical(defaults[["do.contour"]]), defaults[["do.contour"]], FALSE),
                    FALSE
                )
            ),
            checkboxInput(ns("show.grid.lines"), "Show gridlines",
                value = ifelse("show.grid.lines" %in% names(defaults),
                    ifelse(is.logical(defaults[["show.grid.lines"]]), defaults[["show.grid.lines"]], TRUE),
                    TRUE
                )
            ),
            selectizeInput(ns("hover.data"), "Hover data",
                choices = choices,
                multiple = TRUE,
                selected = ifelse("hover.data" %in% names(defaults),
                    ifelse(all(defaults[["hover.data"]] %in% choices), defaults[["hover.data"]], ""),
                    ""
                )
            ),
            numericInput(ns("hover.round.digits"), "Hover round digits",
                value = ifelse("hover.round.digits" %in% names(defaults),
                    ifelse(is.numeric(defaults[["hover.round.digits"]]), defaults[["hover.round.digits"]], 5),
                    5
                ),
                step = 1,
                min = 1
            )
        ),
        "Lines" = tagList(
            textInput(ns("hline.intercepts"), "Y-intercepts",
                placeholder = "e.g. 2, -2",
                value = ifelse("hline.intercepts" %in% names(defaults), defaults[["hline.intercepts"]], "")
            ),
            textInput(ns("hline.colors"), "Colors",
                value = ifelse("hline.colors" %in% names(defaults), defaults[["hline.colors"]], "#000000")
            ),
            textInput(ns("hline.widths"), "Widths",
                value = ifelse("hline.widths" %in% names(defaults), defaults[["hline.widths"]], "1")
            ),
            textInput(ns("hline.linetypes"), "Line types",
                placeholder = "solid, dashed, dotted, ...",
                value = ifelse("hline.linetypes" %in% names(defaults), defaults[["hline.linetypes"]], "dashed")
            ),
            textInput(ns("hline.opacities"), "Opacities (0-1)",
                value = ifelse("hline.opacities" %in% names(defaults), defaults[["hline.opacities"]], "1")
            ),
            hr(),
            textInput(ns("vline.intercepts"), "X-intercepts",
                placeholder = "e.g. 2, -2",
                value = ifelse("vline.intercepts" %in% names(defaults), defaults[["vline.intercepts"]], "")
            ),
            textInput(ns("vline.colors"), "Colors",
                value = ifelse("vline.colors" %in% names(defaults), defaults[["vline.colors"]], "#000000")
            ),
            textInput(ns("vline.widths"), "Widths",
                value = ifelse("vline.widths" %in% names(defaults), defaults[["vline.widths"]], "1")
            ),
            textInput(ns("vline.linetypes"), "Line types",
                placeholder = "solid, dashed, dotted, ...",
                value = ifelse("vline.linetypes" %in% names(defaults), defaults[["vline.linetypes"]], "dashed")
            ),
            textInput(ns("vline.opacities"), "Opacities (0-1)",
                value = ifelse("vline.opacities" %in% names(defaults), defaults[["vline.opacities"]], "1")
            ),
            hr(),
            textInput(ns("abline.slopes"), "Slopes",
                value = ifelse("abline.slopes" %in% names(defaults), defaults[["abline.slopes"]], "")
            ),
            textInput(ns("abline.intercepts"), "Y-intercepts",
                value = ifelse("abline.intercepts" %in% names(defaults), defaults[["abline.intercepts"]], "")
            ),
            textInput(ns("abline.colors"), "Colors",
                value = ifelse("abline.colors" %in% names(defaults), defaults[["abline.colors"]], "#000000")
            ),
            textInput(ns("abline.widths"), "Widths",
                value = ifelse("abline.widths" %in% names(defaults), defaults[["abline.widths"]], "1")
            ),
            textInput(ns("abline.linetypes"), "Line types",
                placeholder = "solid, dashed, dotted, ...",
                value = ifelse("abline.linetypes" %in% names(defaults), defaults[["abline.linetypes"]], "dashed")
            ),
            textInput(ns("abline.opacities"), "Opacities (0-1)",
                value = ifelse("abline.opacities" %in% names(defaults), defaults[["abline.opacities"]], "1")
            ),
            hr(),
            materialSwitch(ns("best.fit"), "Line of best fit:",
                value = FALSE,
                status = "success"),
            numericInput(ns("line.best.smoothness"), "Smoothness of line of best fit:",
                value = 1,
                min = 0,
                max = 10000
            ),
            colourpicker::colourInput(ns("line.best.colour"), "Line of best fit colour:",
                value = "#000000"
            ),
            materialSwitch(ns("linear.model"), "Linear model line",
                value = FALSE,
                status = "success")
        ),
        "Axes" = tagList(
            checkboxInput(ns("axis.showline"), "Show axis lines",
                value = ifelse("axis.showline" %in% names(defaults),
                    ifelse(is.logical(defaults[["axis.showline"]]), defaults[["axis.showline"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("axis.mirror"), "Mirror axis lines",
                value = ifelse("axis.mirror" %in% names(defaults),
                    ifelse(is.logical(defaults[["axis.mirror"]]), defaults[["axis.mirror"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("show.major.grid.x"), "Show X major gridlines",
                value = ifelse("show.major.grid.x" %in% names(defaults),
                    ifelse(is.logical(defaults[["show.major.grid.x"]]), defaults[["show.major.grid.x"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("show.major.grid.y"), "Show Y major gridlines",
                value = ifelse("show.major.grid.y" %in% names(defaults),
                    ifelse(is.logical(defaults[["show.major.grid.y"]]), defaults[["show.major.grid.y"]], TRUE),
                    TRUE
                )
            ),
            colourInput(ns("axis.linecolor"), "Axis line color",
                value = ifelse("axis.linecolor" %in% names(defaults),
                    defaults[["axis.linecolor"]], "black"
                )
            ),
            numericInput(ns("axis.linewidth"), "Axis line width",
                value = ifelse("axis.linewidth" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.linewidth"]]), defaults[["axis.linewidth"]], 0.5),
                    0.5
                ),
                min = 0,
                step = 0.1
            ),
            numericInput(ns("axis.tickfont.size"), "Tick label size",
                value = ifelse("axis.tickfont.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickfont.size"]]), defaults[["axis.tickfont.size"]], 12),
                    12
                ),
                min = 1,
                step = 1
            ),
            colourInput(ns("axis.tickfont.color"), "Tick label color",
                value = ifelse("axis.tickfont.color" %in% names(defaults),
                    defaults[["axis.tickfont.color"]], "black"
                )
            ),
            selectInput(ns("axis.tickfont.family"), "Tick label font",
                choices = c(
                    "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif",
                    "Droid Sans Mono", "Gravitas One", "Old Standard TT", "Open Sans",
                    "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman",
                    "Verdana", "sans-serif", "serif", "monospace"
                ),
                selected = ifelse("axis.tickfont.family" %in% names(defaults),
                    ifelse(defaults[["axis.tickfont.family"]] %in% c(
                        "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif",
                        "Droid Sans Mono", "Gravitas One", "Old Standard TT", "Open Sans",
                        "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman",
                        "Verdana", "sans-serif", "serif", "monospace"
                    ), defaults[["axis.tickfont.family"]], "Arial"),
                    "Arial"
                )
            ),
            numericInput(ns("axis.tickangle.x"), "X-axis tick label angle",
                value = ifelse("axis.tickangle.x" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickangle.x"]]), defaults[["axis.tickangle.x"]], 0),
                    0
                ),
                min = -180,
                max = 180,
                step = 15
            ),
            numericInput(ns("axis.tickangle.y"), "Y-axis tick label angle",
                value = ifelse("axis.tickangle.y" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickangle.y"]]), defaults[["axis.tickangle.y"]], 0),
                    0
                ),
                min = -180,
                max = 180,
                step = 15
            ),
            selectInput(ns("axis.ticks"), "Tick position",
                choices = c("Outside" = "outside", "Inside" = "inside", "None" = ""),
                selected = ifelse("axis.ticks" %in% names(defaults),
                    ifelse(defaults[["axis.ticks"]] %in% c("outside", "inside", ""),
                        defaults[["axis.ticks"]], "outside"
                    ),
                    "outside"
                )
            ),
            colourInput(ns("axis.tickcolor"), "Tick mark color",
                value = ifelse("axis.tickcolor" %in% names(defaults),
                    defaults[["axis.tickcolor"]], "black"
                )
            ),
            numericInput(ns("axis.ticklen"), "Tick mark length",
                value = ifelse("axis.ticklen" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.ticklen"]]), defaults[["axis.ticklen"]], 5),
                    5
                ),
                min = 0,
                step = 1
            ),
            numericInput(ns("axis.tickwidth"), "Tick mark width",
                value = ifelse("axis.tickwidth" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickwidth"]]), defaults[["axis.tickwidth"]], 1),
                    1
                ),
                min = 0,
                step = 0.1
            )
        )
    )

    organize_inputs(
        inputs,
        id = ns("scatterPlotTabsetPanel"),
        title = title,
        tack = tagList(
            fluidRow(
                column(3, materialSwitch(ns("auto.update"), "Auto Update", value = FALSE, status = "success"), style = "margin-top: 25px;"),
                column(3, actionButton(ns("update"), "Update", width = "100%"), style = "margin-top: 25px;"),
                column(3, actionButton(ns("reset"), "Reset", class = "btn-secondary", width = "100%"), style = "margin-top: 25px;"),
                column(3, selectInput(ns("download.format"), "Download Format", selected = ifelse("download.format" %in% names(defaults),
                    ifelse(defaults[["download.format"]] %in% c("svg", "png"), defaults[["download.format"]], "svg"),
                    "svg"
                ), choices = c("png", "svg"), width = "100%"))
            ),
            br()
        ),
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
