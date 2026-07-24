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
#'
#' - `xlab` - X-axis label (auto-generated to reflect any applied X adjustment,
#'   e.g. `"log2(z-score(units))"`; plotly allows interactive editing)
#' - `ylab` - Y-axis label (auto-generated to reflect any applied Y adjustment,
#'   e.g. `"log2(z-score(units))"`; plotly allows interactive editing)
#' - `main` - Plot title (plotly allows interactive editing)
#' - `sub` - Plot subtitle (not supported in plotly)
#' - `theme` - ggplot2 theme (not applicable to plotly)
#' - `legend.title` - Legend title (managed by plotly interactively)
#' - `legend.color.size` - Legend color size (not supported in plotly)
#' - `legend.shape.size` - Legend shape size (not supported in plotly)
#' - `add.xline` - Use `vline.intercepts` instead for vertical lines with full styling options
#' - `add.yline` - Use `hline.intercepts` instead for horizontal lines with full styling options
#' - `xline.linetype` - Use `vline.linetypes` instead
#' - `xline.color` - Use `vline.colors` instead
#' - `yline.linetype` - Use `hline.linetypes` instead
#' - `yline.color` - Use `hline.colors` instead
#' - `do.letter` - Lettering subplots (not implemented for plotly)
#' - `do.label` - Labeling points interactively (not compatible with plotly hover)
#' - `labels.size`, `labels.highlight`, `labels.use.numbers`,
#'   `labels.numbers.spacer`, `labels.repel`, `labels.repel.adjust`,
#'   `labels.split.by` - Point-label styling (tied to `do.label`, not implemented)
#' - `rename.color.groups` - Rename color groups (not implemented)
#' - `rename.shape.groups` - Rename shape groups (not implemented)
#' - `add.trajectory.curves` - Add trajectory curves from coordinate matrices
#'   (not implemented; use `add.trajectory.by.groups` instead)
#' - `do.raster` - Rasterize the point layer (not implemented; use `webgl` for performance instead)
#' - `raster.dpi` - Rasterization DPI (not applicable without `do.raster`)
#' - `show.grid.lines` - Toggle grid lines (managed via the Axes tab gridline controls)
#' - `legend.color.breaks.labels` - Labels for color-scale breaks (not implemented)
#'
#' The new Lines tab provides enhanced functionality including multiple lines per type,
#' individual line widths, opacities, and diagonal/ablines with slope control.
#'
#' @section Plot parameters and defaults:
#' The following [dittoViz::scatterPlot()] parameters can be accessed via UI inputs and/or the `defaults` argument:
#'
#' - `x.by` - X-axis variable (UI: "X Data", default: 2nd column)
#' - `y.by` - Y-axis variable (UI: "Y Data", default: 3rd column)
#' - `color.by` - Coloring variable (UI: "Color By", default: "")
#' - `shape.by` - Shape variable (UI: "Shape By", default: "")
#' - `split.by` - Faceting variable (UI: "Split By", default: "")
#' - `rows.use` - Row filter expression (UI: "Rows Filter", default: "")
#' - `x.adjustment` - X-axis adjustment (UI: "X Adjustment", default: "")
#' - `y.adjustment` - Y-axis adjustment (UI: "Y Adjustment", default: "")
#' - `color.adjustment` - Color adjustment (UI: "Color Adjustment", default: "")
#' - `x.adj.fxn` - X adjustment function (UI: "X Adjustment Function", default: "")
#' - `y.adj.fxn` - Y adjustment function (UI: "Y Adjustment Function", default: "")
#' - `color.adj.fxn` - Color adjustment function (UI: "Color Adjustment Function", default: "")
#' - `size` - Point size (UI: "Point Size", default: 1)
#' - `size.by` - Numeric column mapped to point size (UI: "Size By", default: ""); when set,
#'   a custom circle size legend is drawn since plotly cannot render a native size legend
#' - `opacity` - Point opacity (UI: "Point Opacity", default: 1)
#' - `show.others` - Show others (UI: "Show Others", default: TRUE)
#' - `split.show.all.others` - Show split others (UI: "Show Split Others", default: TRUE)
#' - `plot.order` - Plot order (UI: "Plot Order", default: "unordered")
#' - `shape.panel` - Shape panel values (UI: "Shape Panel", default: "16, 15, 17, 23, 25, 8")
#' - `min.color` - Minimum color (UI: "Min Color", default: "#F0E442")
#' - `max.color` - Maximum color (UI: "Max Color", default: "#0072B2")
#' - `contour.color` - Contour color (UI: "Contour Color", default: "black")
#' - `contour.linetype` - Contour linetype (UI: "Contour Linetype", default: "solid")
#' - `color.panel` - Custom color values (UI: color.panel.ui, derived from palette)
#' - `split.nrow` - Number of split rows (UI: "Rows", default: NA)
#' - `split.ncol` - Number of split columns (UI: "Columns", default: NA)
#' - `multivar.split.dir` - Multivar split direction (UI: "Multivar Split Dir", default: "col")
#' - `split.adjust.scales` - Facet scales (UI: "Facet Scales", default: "fixed")
#' - `annotate.by` - Annotate by column (UI: "Annotate By", default: "")
#' - `highlight.points` - Points to highlight (UI: "Points to Highlight", default: "")
#' - `highlight.color` - Highlight fill (UI: "Highlight Fill", default: "#00FFF7")
#' - `highlight.size` - Highlight size (UI: "Highlight Size", default: 7)
#' - `highlight.border.color` - Highlight border color (UI: "Highlight Border Color", default: "#000000")
#' - `highlight.border.width` - Highlight border width (UI: "Highlight Border Width", default: 1)
#' - `highlight.auto.annotate` - Auto-annotate highlights (UI: "Auto-annotate Highlights", default: TRUE)
#' - `annotation.color` - Annotation color (UI: "Annotation Color", default: "black")
#' - `annotation.ax` - Annotation X offset (UI: "Annotation X Offset", default: 20)
#' - `annotation.ay` - Annotation Y offset (UI: "Annotation Y Offset", default: -20)
#' - `annotation.size` - Annotation size (UI: "Annotation Size", default: 10)
#' - `annotation.showarrow` - Show arrow (UI: "Show Arrow", default: TRUE)
#' - `annotation.arrowcolor` - Arrow color (UI: "Arrow Color", default: "black")
#' - `annotation.arrowhead` - Arrowhead style (UI: "Arrowhead Style", default: 2)
#' - `annotation.arrowwidth` - Arrow linewidth (UI: "Arrow Linewidth", default: 1.5)
#' - `legend.color.breaks` - Legend tick breaks (UI: "Legend Tick Breaks", default: "")
#' - `size.legend.x` - Custom size-legend x position (UI: "Size Legend X Position",
#'   default: 1.02); nudges the manual size legend (drawn when `size.by` is set) along the x-axis.
#' - `size.legend.y` - Custom size-legend y position (UI: "Size Legend Y Position",
#'   default: 0.95); nudges the manual size legend (drawn when `size.by` is set) along the y-axis.
#' - `min.value` - Minimum value (UI: "Min Value", default: NA)
#' - `max.value` - Maximum value (UI: "Max Value", default: NA)
#' - `trajectory.group.by` - Trajectory group by (UI: "Trajectory Group By", default: "")
#' - `add.trajectory.by.groups` - Add trajectory by groups (UI: "Add Trajectory By Groups", default: "")
#' - `trajectory.arrow.size` - Trajectory arrow size (UI: "Trajectory Arrow Size", default: 0.15)
#' - `do.ellipse` - Enable ellipses (UI: "Enable Ellipses", default: FALSE)
#' - `do.contour` - Enable contour (UI: "Enable Contour", default: FALSE)
#' - `hover.data` - Hover data columns (UI: "Hover Data", default: "")
#' - `hover.round.digits` - Hover round digits (UI: "Hover Round Digits", default: 5)
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#'
#' - `webgl` - Plot with webGL (UI: "Plot with webGL", default: TRUE)
#' - `shape.fill` - Shape fill color (UI: "Shape Fill", default: "rgba(0, 0, 0, 0)")
#' - `shape.line.color` - Shape line color (UI: "Shape Line Color", default: "black")
#' - `shape.line.width` - Shape line width (UI: "Shape Line Width", default: 4)
#' - `shape.linetype` - Shape linetype (UI: "Shape Linetype", default: "solid")
#' - `shape.opacity` - Shape opacity (UI: "Shape Opacity", default: 1)
#' - `title.font.size` - Plot title font size (UI: "Title Size", default: 26)
#' - `title.font.family` - Font family for title text (UI: "Title Font", default: "Arial")
#' - `title.font.color` - Color for plot title (UI: "Title Color", default: "#000000")
#' - `axis.title.font.size` - Axis title font size (UI: "Axis Title Size", default: 18)
#' - `axis.title.font.color` - Axis title font color (UI: "Axis Title Color", default: "#000000")
#' - `axis.title.font.family` - Axis title font family (UI: "Axis Title Font", default: "Arial")
#' - `axis.showline` - Show axis border lines (UI: "Show Axis Borders", default: TRUE)
#' - `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror Axis Borders", default: TRUE)
#' - `show.grid.x` - Show X-axis major gridlines (UI: "Show X Gridlines", default: TRUE)
#' - `show.grid.y` - Show Y-axis major gridlines (UI: "Show Y Gridlines", default: TRUE)
#' - `grid.color` - Gridline color (UI: "Gridline Color", default: "#CCCCCC")
#' - `axis.linecolor` - Color of axis lines (UI: "Axis Line Color", default: "black")
#' - `axis.linewidth` - Width of axis lines (UI: "Axis Line Width", default: 0.5)
#' - `axis.tickfont.size` - Size of tick labels (UI: "Tick Label Size", default: 12)
#' - `axis.tickfont.color` - Color of tick labels (UI: "Tick Label Color", default: "black")
#' - `axis.tickfont.family` - Font family for tick labels (UI: "Tick Label Font", default: "Arial")
#' - `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI: "X Tick Label Angle", default: 0)
#' - `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI: "Y Tick Label Angle", default: 0)
#' - `axis.ticks` - Position of tick marks (UI: "Tick Position", default: "outside")
#' - `axis.tickcolor` - Color of tick marks (UI: "Tick Mark Color", default: "black")
#' - `axis.ticklen` - Length of tick marks (UI: "Tick Mark Length", default: 5)
#' - `axis.tickwidth` - Width of tick marks (UI: "Tick Mark Width", default: 1)
#' - `facet.title.font.size` - Facet subplot title font size (UI: "Facet Subplot Title Size", default: 18)
#' - `facet.title.font.color` - Facet subplot title font color (UI: "Facet Title Color", default: "#000000")
#' - `facet.title.font.family` - Facet subplot title font family (UI: "Facet Title Font", default: "Arial")
#' - `hline.intercepts` - Y-coordinates for horizontal reference lines (UI: "Y-intercepts", default: "")
#' - `hline.colors` - Colors for horizontal lines (UI: "Colors", default: "#000000")
#' - `hline.widths` - Widths for horizontal lines (UI: "Widths", default: "1")
#' - `hline.linetypes` - Line types for horizontal lines (UI: "Line Types", default: "dashed")
#' - `hline.opacities` - Opacities for horizontal lines (UI: "Opacities (0-1)", default: "1")
#' - `vline.intercepts` - X-coordinates for vertical reference lines (UI: "X-intercepts", default: "")
#' - `vline.colors` - Colors for vertical lines (UI: "Colors", default: "#000000")
#' - `vline.widths` - Widths for vertical lines (UI: "Widths", default: "1")
#' - `vline.linetypes` - Line types for vertical lines (UI: "Line Types", default: "dashed")
#' - `vline.opacities` - Opacities for vertical lines (UI: "Opacities (0-1)", default: "1")
#' - `abline.slopes` - Slopes for diagonal reference lines (UI: "Slopes", default: "")
#' - `best.fit` - Enable line of best fit (UI: "Line of best fit:", default: FALSE)
#' - `line.best.smoothness` - Smoothness of line of best fit (UI: "Smoothness of line of best fit:", default: 1)
#' - `line.best.colour` - Color of line of best fit (UI: "Line of best fit colour:", default: "#000000")
#' - `linear.model` - Enable linear model line (UI: "Linear model line", default: FALSE)
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
#' dittoViz_scatterPlotInputsUI("scatterPlot", example_mtcars)
dittoViz_scatterPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    if (is.null(defaults)) defaults <- list()

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])

    # Get categorical variables of data.
    cat.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])

    # Various other choice vectors
    adj.choices <- c("", "z-score", "relative.to.max")
    adj.fxn.choices <- c("", "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt")

    selected <- list(
        c("x.by", "y.by"), "color.by", "shape.by", "split.by",
        "rows.use", c("x.adjustment", "y.adjustment", "color.adjustment"),
        c("x.adj.fxn", "y.adj.fxn", "color.adj.fxn"),
        "size", "opacity", "show.others", "split.show.all.others",
        "plot.order", "shape.panel",
        "min.color", "max.color", "contour.color", "contour.linetype",
        c("split.nrow", "split.ncol"), "multivar.split.dir",
        "do.ellipse", "do.contour",
        "hover.data", "hover.round.digits",
        "legend.show", c("legend.color.title", "legend.shape.title"),
        "legend.color.breaks",
        c("min.value", "max.value"),
        "trajectory.group.by", "add.trajectory.by.groups",
        "trajectory.arrow.size"
    )

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
                selected = get_default(
                    defaults, "x.by", choices[2],
                    function(x) x %in% choices
                ), selectize = FALSE
            ), documentParameters$x.by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.by"), "Y Data",
                choices = choices,
                selected = get_default(
                    defaults, "y.by", choices[3],
                    function(x) x %in% choices
                ), selectize = FALSE
            ), documentParameters$y.by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.by"), "Color By",
                choices = choices,
                selected = get_default(
                    defaults, "color.by", "",
                    function(x) x %in% choices
                ), selectize = FALSE
            ), documentParameters$color.by, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("size.by"), "Size By",
                choices = num.choices,
                selected = get_default(
                    defaults, "size.by", "",
                    function(x) x == "" || x %in% num.choices
                ), selectize = FALSE
            ), documentParameters$size, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("shape.by"), "Shape By",
                choices = cat.choices,
                selected = get_default(
                    defaults, "shape.by", "",
                    function(x) x %in% cat.choices
                ), selectize = FALSE
            ), documentParameters$shape.by, placement = "top", options = list(container = "body")),
            tipify(selectizeInput(ns("split.by"), "Split By",
                choices = c("", .facet_check(data)),
                selected = get_default(
                    defaults, "split.by", "",
                    function(x) all(x %in% cat.choices)
                ),
                multiple = TRUE,
                options = list(maxItems = 2)
            ), documentParameters$split.by, placement = "top", options = list(container = "body"))
        ),
        "Adjustments" = tagList(
            tipify(selectInput(ns("x.adjustment"), "X Adjustment",
                choices = adj.choices,
                selected = get_default(
                    defaults, "x.adjustment", "",
                    function(x) x %in% adj.choices
                ), selectize = FALSE
            ), documentParameters$x.adjustment, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.adjustment"), "Y Adjustment",
                choices = adj.choices,
                selected = get_default(
                    defaults, "y.adjustment", "",
                    function(x) x %in% adj.choices
                ), selectize = FALSE
            ), documentParameters$y.adjustment, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.adjustment"), "Color Adjustment",
                choices = adj.choices,
                selected = get_default(
                    defaults, "color.adjustment", "",
                    function(x) x %in% adj.choices
                ), selectize = FALSE
            ), documentParameters$color.adjustment, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("x.adj.fxn"), "X Adjustment Function",
                choices = adj.fxn.choices,
                selected = get_default(
                    defaults, "x.adj.fxn", "",
                    function(x) x %in% adj.fxn.choices
                ), selectize = FALSE
            ), documentParameters$x.adj.fxn, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("y.adj.fxn"), "Y Adjustment Function",
                choices = adj.fxn.choices,
                selected = get_default(
                    defaults, "y.adj.fxn", "",
                    function(x) x %in% adj.fxn.choices
                ), selectize = FALSE
            ), documentParameters$y.adj.fxn, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.adj.fxn"), "Color Adjustment Function",
                choices = adj.fxn.choices,
                selected = get_default(
                    defaults, "color.adj.fxn", "",
                    function(x) x %in% adj.fxn.choices
                ), selectize = FALSE
            ), documentParameters$color.adj.fxn, placement = "top", options = list(container = "body"))
        ),
        "Points" = tagList(
            tipify(numericInput(ns("size"), "Point Size",
                value = get_default(defaults, "size", 1, is.numeric),
                min = 0.1
            ), documentParameters$size, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("opacity"), "Point Opacity",
                value = get_default(defaults, "opacity", 1, is.numeric),
                max = 1,
                min = 0,
                step = 0.05
            ), documentParameters$opacity, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("show.others"), "Show Others",
                value = get_default(defaults, "show.others", TRUE, is.logical)
            ), documentParameters$show.others, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("split.show.all.others"),
                "Show Split Others",
                value = get_default(defaults, "split.show.all.others", TRUE, is.logical)
            ), documentParameters$split.show.all.others, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("plot.order"), "Plot Order",
                choices = c("unordered", "increasing", "decreasing", "randomize"),
                selected = get_default(
                    defaults, "plot.order", "unordered",
                    function(x) x %in% c("unordered", "increasing", "decreasing", "randomize")
                ), selectize = FALSE
            ), documentParameters$plot.order, placement = "top", options = list(container = "body")),
            tipify(textInput(ns("shape.panel"), "Shape Panel",
                value = get_default(defaults, "shape.panel", "16, 15, 17, 23, 25, 8")
            ), documentParameters$shape.panel, placement = "top", options = list(container = "body"))
        ),
        "Colors" = tagList(
            tipify(colourInput(ns("min.color"), "Min Color",
                value = get_default(defaults, "min.color", "#F0E442")
            ), documentParameters$min.color, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("max.color"), "Max Color",
                value = get_default(defaults, "max.color", "#0072B2")
            ), documentParameters$max.color, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("contour.color"), "Contour Color",
                value = get_default(defaults, "contour.color", "black")
            ), documentParameters$contour.color, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("contour.linetype"), "Contour Linetype",
                choices = c(
                    "solid", "dashed", "dotted", "dotdash",
                    "longdash", "twodash"
                ),
                selected = get_default(
                    defaults, "contour.linetype", "solid",
                    function(x) {
                        x %in% c(
                            "solid", "dashed", "dotted", "dotdash",
                            "longdash", "twodash"
                        )
                    }
                ), selectize = FALSE
            ), documentParameters$contour.linetype, placement = "top", options = list(container = "body")),
            uiOutput(ns("color.panel.ui"))
        ),
        "Facet" = tagList(
            tipify(numericInput(ns("split.nrow"), "Rows",
                step = 1, min = 0,
                value = get_default(defaults, "split.nrow", NA, is.numeric)
            ), documentParameters$split.nrow, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("split.ncol"), "Columns",
                step = 1, min = 0,
                value = get_default(defaults, "split.ncol", NA, is.numeric)
            ), documentParameters$split.ncol, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("multivar.split.dir"), "Multivar Split Dir",
                choices = c("col", "row"),
                selected = get_default(
                    defaults, "multivar.split.dir", "col",
                    function(x) x %in% c("col", "row")
                ), selectize = FALSE
            ), documentParameters$multivar.split.dir, placement = "top", options = list(container = "body")),
            tipify(
                selectInput(ns("split.adjust.scales"), "Facet Scales",
                    choices = c("fixed", "free", "free_x", "free_y"),
                    selected = get_default(
                        defaults, "split.adjust.scales", "fixed",
                        function(x) x %in% c("fixed", "free", "free_x", "free_y")
                    ), selectize = FALSE
                ), "Control whether facet panels share the same axis scales or allow them to vary independently",
                placement = "top", options = list(container = "body")
            ),
            .uniform_subplot_spacing_inputs_ui(ns, defaults)
        ),
        "Annotations" = tagList(
            tipify(
                selectInput(ns("annotate.by"), "Annotate By",
                    choices = choices,
                    selected = get_default(
                        defaults, "annotate.by", "",
                        function(x) x %in% choices
                    ), selectize = FALSE
                ), "Select a column whose values will be used to identify points for highlighting and annotation",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                textAreaInput(ns("highlight.points"), "Points to Highlight",
                    placeholder = "Values from 'Annotate by' column\n(comma, space, or newline delimited)",
                    value = get_default(defaults, "highlight.points", ""),
                    rows = 3
                ), "Enter specific values from the 'Annotate By' column to highlight those points on the plot",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                colourInput(ns("highlight.color"), "Highlight Fill",
                    value = get_default(defaults, "highlight.color", "#00FFF7"),
                    allowTransparent = TRUE
                ), "Choose the fill color for highlighted points",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("highlight.size"), "Highlight Size",
                    min = 0.1, step = 0.5,
                    value = get_default(defaults, "highlight.size", 7, is.numeric)
                ), "Set the size of highlighted points on the plot",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                colourInput(ns("highlight.border.color"), "Highlight Border Color",
                    value = get_default(defaults, "highlight.border.color", "#000000")
                ), "Choose the border color for highlighted points",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("highlight.border.width"), "Highlight Border Width",
                    min = 0, step = 0.25,
                    value = get_default(defaults, "highlight.border.width", 1, is.numeric)
                ), "Set the width of the border around highlighted points",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                checkboxInput(ns("highlight.auto.annotate"), "Auto-annotate Highlights",
                    value = get_default(defaults, "highlight.auto.annotate", TRUE, is.logical)
                ), "When enabled, automatically adds text labels to highlighted points using their 'Annotate By' values",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                colourInput(ns("annotation.color"), "Annotation Color",
                    value = get_default(defaults, "annotation.color", "black")
                ), "Set the text color for annotation labels",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("annotation.ax"), "Annotation X Offset",
                    step = 1,
                    value = get_default(defaults, "annotation.ax", 20, is.numeric)
                ), "Horizontal pixel offset of annotation labels from their target points",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("annotation.ay"), "Annotation Y Offset",
                    step = 1,
                    value = get_default(defaults, "annotation.ay", -20, is.numeric)
                ), "Vertical pixel offset of annotation labels from their target points (negative values move up)",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("annotation.size"), "Annotation Size",
                    min = 1, step = 0.5,
                    value = get_default(defaults, "annotation.size", 10, is.numeric)
                ), "Set the font size of annotation text labels in points",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                checkboxInput(ns("annotation.showarrow"), "Show Arrow",
                    value = get_default(defaults, "annotation.showarrow", TRUE, is.logical)
                ), "Toggle whether an arrow is drawn from the annotation label to the target point",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                colourInput(ns("annotation.arrowcolor"), "Arrow Color",
                    value = get_default(defaults, "annotation.arrowcolor", "black")
                ), "Set the color of the annotation arrow connecting the label to the point",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("annotation.arrowhead"), "Arrowhead Style",
                    min = 0, step = 1, max = 7,
                    value = get_default(defaults, "annotation.arrowhead", 2, is.numeric)
                ), "Choose the arrowhead style (0-7) for annotation arrows, where 0 is no arrowhead",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("annotation.arrowwidth"), "Arrow Linewidth",
                    min = 0.1, step = 0.25,
                    value = get_default(defaults, "annotation.arrowwidth", 1.5, is.numeric)
                ), "Set the line width of the annotation arrow",
                placement = "top", options = list(container = "body")
            ),
            tipify(actionButton(ns("annotation.clear"), "Clear Annotations"),
                "Remove all annotation labels and arrows from the current plot",
                placement = "top", options = list(container = "body")
            )
        ),
        "Legend" = tagList(
            tipify(checkboxInput(ns("legend.show"), "Show Legend",
                value = get_default(defaults, "legend.show", TRUE, is.logical)
            ), documentParameters$legend.show, placement = "top", options = list(container = "body")),
            tipify(textInput(ns("legend.color.title"), "Legend Title",
                value = get_default(defaults, "legend.color.title", "make")
            ), documentParameters$legend.color.title, placement = "top", options = list(container = "body")),
            uniform_legend_inputs_ui(ns, defaults),
            tipify(textInput(ns("legend.color.breaks"), "Color Tick Breaks",
                placeholder = "e.g. -3, 0, 3",
                value = get_default(defaults, "legend.color.breaks", "", is.character)
            ), documentParameters$legend.color.breaks, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("size.legend.x"), "Size Legend X Position",
                value = get_default(defaults, "size.legend.x", 1.03, is.numeric),
                step = 0.02
            ), paste(
                "Horizontal position (paper coordinates) of the custom size",
                "legend drawn when 'Size By' is set. Values just above 1 sit to",
                "the right of the plot; lower it to pull the legend inward on",
                "narrow plots or raise it to push it further out."
            ), placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("size.legend.y"), "Size Legend Y Position",
                value = get_default(defaults, "size.legend.y", 0.35, is.numeric),
                step = 0.05
            ), paste(
                "Vertical position (paper coordinates) of the custom size",
                "legend drawn when 'Size By' is set. Lower it to offset the",
                "size legend from an overlapping color or shape legend."
            ), placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("min.value"), "Color Min",
                value = get_default(defaults, "min.value", NA, is.numeric)
            ), documentParameters$min.value, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("max.value"), "Color Max",
                value = get_default(defaults, "max.value", NA, is.numeric)
            ), documentParameters$max.value, placement = "top", options = list(container = "body"))
        ),
        "Trajectory" = tagList(
            tipify(selectInput(ns("trajectory.group.by"), "Trajectory Group By",
                choices = cat.choices,
                selected = get_default(
                    defaults, "trajectory.group.by", "",
                    function(x) x %in% cat.choices
                ), selectize = FALSE
            ), documentParameters$trajectory.group.by, placement = "top", options = list(container = "body")),
            tipify(textInput(ns("add.trajectory.by.groups"), "Add Trajectory By Groups",
                placeholder = "e.g. [A,B],[C,D,E]",
                value = get_default(defaults, "add.trajectory.by.groups", "")
            ), documentParameters$add.trajectory.by.groups, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("trajectory.arrow.size"), "Trajectory Arrow Size",
                value = get_default(defaults, "trajectory.arrow.size", 0.15, is.numeric),
                min = 0,
                step = 0.05
            ), documentParameters$trajectory.arrow.size, placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Extras" = tagList(
            tipify(checkboxInput(ns("webgl"), "Plot with webGL",
                value = get_default(defaults, "webgl", TRUE, is.logical)
            ), "Enable WebGL rendering for improved performance with large datasets at the cost of some visual features",
                placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("do.ellipse"), "Enable Ellipses",
                value = get_default(defaults, "do.ellipse", FALSE, is.logical)
            ), documentParameters$do.ellipse, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("do.contour"), "Enable Contour",
                value = get_default(defaults, "do.contour", FALSE, is.logical)
            ), documentParameters$do.contour, placement = "top", options = list(container = "body")),
            tipify(selectizeInput(ns("hover.data"), "Hover Data",
                choices = choices,
                multiple = TRUE,
                selected = get_default(
                    defaults, "hover.data", "",
                    function(x) all(x %in% choices)
                )
            ), documentParameters$hover.data, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("hover.round.digits"), "Hover Round Digits",
                value = get_default(defaults, "hover.round.digits", 5, is.numeric),
                step = 1,
                min = 1
            ), documentParameters$hover.round.digits, placement = "top", options = list(container = "body"))
        ),
        "Lines" = uniform_lines_inputs_ui(ns, defaults, include.fit.lines = TRUE),
        "Axes" = uniform_axes_inputs_ui(ns, defaults)
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
#' @param resizable Logical; when `TRUE` (the default) the plot output
#'   is wrapped in [shinyjqui::jqui_resizable()] so it can be resized
#'   by dragging. Set to `FALSE` when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the scatterplot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
dittoViz_scatterPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("scatterPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
