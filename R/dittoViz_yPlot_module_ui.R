#' Input UI components for the yPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoViz_yPlotServer()` and `dittoViz_yPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [dittoViz::yPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [dittoViz::yPlot()] parameters are not available via UI inputs:
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (auto-generated to reflect any applied Y adjustment,
#'     e.g. \code{"log2(z-score(units))"}; plotly allows interactive editing)
#'   \item \code{main} - Plot title (plotly allows interactive editing)
#'   \item \code{sub} - Plot subtitle (not supported in plotly)
#'   \item \code{theme} - ggplot2 theme (not applicable to plotly)
#'   \item \code{legend.title} - Legend title (managed by plotly interactively)
#'   \item \code{add.line} - Use \code{hline.intercepts} instead for horizontal lines with full styling options
#'   \item \code{line.linetype} - Use \code{hline.linetypes} instead
#'   \item \code{line.color} - Use \code{hline.colors} instead
#'   \item \code{line.linewidth} - Use \code{hline.widths} instead
#'   \item \code{line.opacity} - Use \code{hline.opacities} instead
#'   \item \code{multivar.aes} - Aesthetic used for multiple \code{var} columns (not implemented; one var at a time)
#'   \item \code{multivar.split.dir} - Facet direction for multiple \code{var} columns (not implemented)
#'   \item \code{rows.use} - Row subset to plot (not implemented)
#'   \item \code{colors} - Integer index/order into \code{color.panel} (managed via the palette UI)
#'   \item \code{shape.panel} - Shapes used with \code{shape.by} (not implemented)
#'   \item \code{y.breaks} - Custom continuous-axis breaks (not implemented)
#'   \item \code{x.labels} - Override group labels (not implemented)
#'   \item \code{x.labels.rotate} - Rotate group labels (handled by the Axes tab tick-angle controls)
#'   \item \code{x.reorder} - Reorder x-axis groups (not implemented)
#'   \item \code{boxplot.width} - Boxplot width (controlled via \code{boxgap} and \code{boxgroupgap})
#'   \item \code{boxplot.outlier.size} - Outlier point size (not implemented)
#'   \item \code{boxplot.position.dodge} - Boxplot dodge (controlled via \code{boxgap})
#'   \item \code{hover.data} - Columns shown on hover (not implemented; a default set is used)
#'   \item \code{hover.round.digits} - Hover value rounding (not implemented)
#'   \item \code{vlnplot.quantiles} - Violin quantiles (doesn't translate to plotly)
#' }
#'
#' @section Plot parameters and defaults:
#' The following [dittoViz::yPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{var} - Y-axis variable (UI: "Y data (var)", default: 2nd numeric variable)
#'   \item \code{group.by} - Grouping variable for x-axis (UI: "Group by", default: 2nd categorical variable)
#'   \item \code{color.by} - Coloring variable (UI: "Color by", default: "")
#'   \item \code{shape.by} - Shape variable (UI: "Shape by", default: "")
#'   \item \code{split.by} - Faceting variable (UI: "Split by (facet)", default: "")
#'   \item \code{plots} - Plot types to show (UI: "Plots to show", default: c("boxplot", "jitter"))
#'   \item \code{color.panel} - Custom color values (UI: palette picker, derived from palette)
#'   \item \code{min} - Y-axis minimum (UI: "Y Axis Min", auto-calculated)
#'   \item \code{max} - Y-axis maximum (UI: "Y Axis Max", auto-calculated)
#'   \item \code{var.adjustment} - Y-axis data adjustment (UI: "Y Adjustment", default: "")
#'   \item \code{var.adj.fxn} - Y-axis adjustment function (UI: "Y Adjustment Function", default: "")
#'   \item \code{split.nrow} - Number of facet rows (UI: "Rows", default: 4)
#'   \item \code{split.ncol} - Number of facet columns (UI: "Columns", default: 4)
#'   \item \code{split.adjust} - Facet scale behavior (UI: "Facet Scaling", default: "free")
#'   \item \code{do.raster} - Rasterize jitter points (UI: "Rasterize Jitter", default: FALSE)
#'   \item \code{raster.dpi} - DPI for rasterization (UI: "Raster DPI", default: 600)
#'   \item \code{jitter.size} - Jitter point size (UI: "Jitter Point Size", default: 1)
#'   \item \code{jitter.width} - Jitter width (UI: "Jitter Width", default: 0.2)
#'   \item \code{jitter.color} - Jitter point color (UI: "Jitter Point Color", default: "#000000")
#'   \item \code{jitter.shape.legend.size} - Shape legend size (UI: "Shape Legend Size", default: 5)
#'   \item \code{jitter.shape.legend.show} - Show shape legend (UI: "Show Shape Legend", default: TRUE)
#'   \item \code{jitter.position.dodge} - Jitter position dodge (calculated from boxgap)
#'   \item \code{boxplot.show.outliers} - Show boxplot outliers
#'   \item \code{boxplot.color} - Boxplot outline color (UI: "Boxplot Color", default: "#000000")
#'   \item \code{boxplot.fill} - Fill boxplot (UI: "Fill Boxplot", default: TRUE)
#'   \item \code{boxplot.lineweight} - Boxplot line weight (UI: "Boxplot Line Weight", default: 0.5)
#'   \item \code{vlnplot.lineweight} - Violin line weight (UI: "Violin Line Weight", default: 0.5)
#'   \item \code{vlnplot.scaling} - Violin scaling method (UI: "Violin Scaling", default: "area")
#'   \item \code{vlnplot.width} - Violin width (derived from \code{boxgap}; not directly settable)
#'   \item \code{ridgeplot.lineweight} - Ridge line weight (UI: "Ridge Line Weight", default: 0.5)
#'   \item \code{ridgeplot.scale} - Ridge overlap scale (UI: "Ridge Scale (overlap)", default: 1.25)
#'   \item \code{ridgeplot.ymax.expansion} - Ridge Y-max expansion (UI: "Ridge Y-max Expansion", default: NA)
#'   \item \code{ridgeplot.shape} - Ridge shape (UI: "Ridge Shape", default: "smooth")
#'   \item \code{ridgeplot.bins} - Ridge bins (UI: "Ridge Bins", default: 30)
#'   \item \code{ridgeplot.binwidth} - Ridge binwidth (UI: "Ridge Binwidth", default: NULL)
#'   \item \code{legend.show} - Show legend (always \code{TRUE}; not directly settable)
#' }
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#' \itemize{
#'   \item \code{boxmode} - Boxplot mode grouping (calculated: "group" or "overlay" based on color.by)
#'   \item \code{boxgap} - Boxplot position dodge (UI: "Boxplot Position Dodge", default: 0.3)
#'   \item \code{boxgroupgap} - Boxplot group dodge (UI: "Boxplot Group Dodge", default: 0.2)
#'   \item \code{title.font.size} - Plot title font size (UI: "Title Size", default: 26)
#'   \item \code{title.font.family} - Font family for title text (UI: "Title Font", default: "Arial")
#'   \item \code{title.font.color} - Color for plot title (UI: "Title Color", default: "#000000")
#'   \item \code{axis.title.font.size} - Axis title font size (UI: "Axis Title Size", default: 18)
#'   \item \code{axis.title.font.color} - Axis title font color (UI: "Axis Title Color", default: "#000000")
#'   \item \code{axis.title.font.family} - Axis title font family (UI: "Axis Title Font", default: "Arial")
#'   \item \code{axis.showline} - Show axis border lines (UI: "Show Axis Lines", default: TRUE)
#'   \item \code{axis.mirror} - Mirror axis lines on opposite side (UI: "Mirror Axis Lines", default: TRUE)
#'   \item \code{show.grid.x} - Show X-axis major gridlines (UI: "Show X Major Gridlines", default: TRUE)
#'   \item \code{show.grid.y} - Show Y-axis major gridlines (UI: "Show Y Major Gridlines", default: TRUE)
#'   \item \code{axis.linecolor} - Color of axis lines (UI: "Axis Line Color", default: "black")
#'   \item \code{axis.linewidth} - Width of axis lines (UI: "Axis Line Width", default: 0.5)
#'   \item \code{axis.tickfont.size} - Size of tick labels (UI: "Tick Label Size", default: 12)
#'   \item \code{axis.tickfont.color} - Color of tick labels (UI: "Tick Label Color", default: "black")
#'   \item \code{axis.tickfont.family} - Font family for tick labels (UI: "Tick Label Font", default: "Arial")
#'   \item \code{axis.tickangle.x} - Rotation angle for X-axis tick labels (UI: "X-axis Tick Label Angle", default: 0)
#'   \item \code{axis.tickangle.y} - Rotation angle for Y-axis tick labels (UI: "Y-axis Tick Label Angle", default: 0)
#'   \item \code{axis.ticks} - Position of tick marks (UI: "Tick Position", default: "outside")
#'   \item \code{axis.tickcolor} - Color of tick marks (UI: "Tick Mark Color", default: "black")
#'   \item \code{axis.ticklen} - Length of tick marks (UI: "Tick Mark Length", default: 5)
#'   \item \code{axis.tickwidth} - Width of tick marks (UI: "Tick Mark Width", default: 1)
#'   \item \code{hline.intercepts} - Y-coordinates for horizontal reference lines (UI: "Y-intercepts", default: "")
#'   \item \code{hline.colors} - Colors for horizontal lines (UI: "Colors", default: "#000000")
#'   \item \code{hline.widths} - Widths for horizontal lines (UI: "Widths", default: "1")
#'   \item \code{hline.linetypes} - Line types for horizontal lines (UI: "Line Types", default: "dashed")
#'   \item \code{hline.opacities} - Opacities for horizontal lines (UI: "Opacities (0-1)", default: "1")
#'   \item \code{vline.intercepts} - X-coordinates for vertical reference lines (UI: "X-intercepts", default: "")
#'   \item \code{vline.colors} - Colors for vertical lines (UI: "Colors", default: "#000000")
#'   \item \code{vline.widths} - Widths for vertical lines (UI: "Widths", default: "1")
#'   \item \code{vline.linetypes} - Line types for vertical lines (UI: "Line Types", default: "dashed")
#'   \item \code{vline.opacities} - Opacities for vertical lines (UI: "Opacities (0-1)", default: "1")
#'   \item \code{abline.slopes} - Slopes for diagonal reference lines (UI: "Slopes", default: "")
#'   \item \code{abline.intercepts} - Y-intercepts for diagonal lines (UI: "Y-intercepts", default: "")
#'   \item \code{abline.colors} - Colors for diagonal lines (UI: "Colors", default: "#000000")
#'   \item \code{abline.widths} - Widths for diagonal lines (UI: "Widths", default: "1")
#'   \item \code{abline.linetypes} - Line types for diagonal lines (UI: "Line Types", default: "dashed")
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
#' @author Jared Andrews, Jacob Martin
#' @seealso [dittoViz::yPlot()], [VizModules::organize_inputs()],
#' [VizModules::dittoViz_yPlotOutputUI()], [VizModules::dittoViz_yPlotServer()],
#' [VizModules::dittoViz_yPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' dittoViz_yPlotInputsUI("yPlot", mtcars)
dittoViz_yPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    cat.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]

    # Recognized data adjustments for the (numeric) continuous variable.
    adj.choices <- c("", "z-score", "relative.to.max")
    adj.fxn.choices <- c("", "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt")

    if (length(num.choices) >= 2) {
        max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * .y_axis_scale_factor
        min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)
    } else {
        max.y <- 1
        min.y <- 0
    }

    selected <- list(
        "var", "group.by", "color.by", "shape.by",
        "plots", c("min", "max"), "var.adjustment", "var.adj.fxn",
        "split.by", c("split.nrow", "split.ncol"),
        "split.adjust", "do.raster", "raster.dpi",
        "jitter.size", "jitter.width", "jitter.color",
        "jitter.shape.legend.size", "jitter.shape.legend.show",
        "boxplot.show.outliers", "boxplot.color", "boxplot.fill",
        "boxplot.lineweight",
        "vlnplot.lineweight", "vlnplot.scaling",
        "ridgeplot.lineweight", "ridgeplot.scale",
        "ridgeplot.ymax.expansion", "ridgeplot.shape",
        "ridgeplot.bins", "ridgeplot.binwidth"
    )

    documentParameters <- get_documentation(
        package_name = "dittoViz::yPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(
                selectInput(ns("var"), "Y Data",
                    choices = num.choices,
                    selected = .get_default(
                        defaults, "var", num.choices[2],
                        function(x) x %in% num.choices
                    ), selectize = FALSE
                ),
                documentParameters$var,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                selectInput(ns("group.by"), "Group By",
                    choices = cat.choices,
                    selected = .get_default(
                        defaults, "group.by", cat.choices[2],
                        function(x) x %in% cat.choices
                    ), selectize = FALSE
                ),
                documentParameters$group.by,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                selectInput(ns("color.by"), "Color By",
                    choices = cat.choices,
                    selected = .get_default(
                        defaults, "color.by", "",
                        function(x) x %in% cat.choices
                    ), selectize = FALSE
                ),
                documentParameters$color.by,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                selectInput(ns("shape.by"), "Shape By",
                    choices = cat.choices,
                    selected = .get_default(
                        defaults, "shape.by", "",
                        function(x) x %in% cat.choices
                    ), selectize = FALSE
                ),
                documentParameters$shape.by,
                placement = "top", options = list(container = "body")
            ),
            uiOutput(ns("palette.selection"))
        ),
        "Plot Type" = tagList(
            tipify(selectInput(
                ns("plots"),
                "Plots",
                choices = c("Violin" = "vlnplot", "Box" = "boxplot", "Jitter" = "jitter", "Ridge" = "ridgeplot"),
                selected = .get_default(
                    defaults, "plots", c("boxplot", "jitter"),
                    function(x) all(x %in% c("vlnplot", "boxplot", "jitter", "ridgeplot"))
                ),
                multiple = TRUE, selectize = TRUE
            ), documentParameters$plots, placement = "top", options = list(container = "body")),
            helpText("Order not currently respected")
        ),
        "Adjustments" = tagList(
            tipify(
                selectInput(ns("var.adjustment"), "Y Adjustment",
                    choices = adj.choices,
                    selected = .get_default(
                        defaults, "var.adjustment", "",
                        function(x) x %in% adj.choices
                    ), selectize = FALSE
                ),
                documentParameters$var.adjustment,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                selectInput(ns("var.adj.fxn"), "Y Adjustment Function",
                    choices = adj.fxn.choices,
                    selected = .get_default(
                        defaults, "var.adj.fxn", "",
                        function(x) x %in% adj.fxn.choices
                    ), selectize = FALSE
                ),
                documentParameters$var.adj.fxn,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("y.max"), "Y Axis Max",
                    value = .get_default(defaults, "max", max.y, is.numeric),
                    min = -1000, max = 1000
                ),
                documentParameters$max,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("y.min"), "Y Axis Min",
                    value = .get_default(defaults, "min", min.y, is.numeric),
                    min = -1000, max = 1000
                ),
                documentParameters$min,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                materialSwitch(ns("do.raster"), "Rasterize Jitter",
                    value = .get_default(defaults, "do.raster", FALSE, is.logical),
                    status = "success"
                ),
                documentParameters$do.raster,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("raster.dpi"), "Raster DPI",
                    value = .get_default(defaults, "raster.dpi", 600, is.numeric),
                    min = 100, max = 1200
                ),
                documentParameters$raster.dpi,
                placement = "top", options = list(container = "body")
            )
        ),
        "Jitter" = tagList(
            tipify(
                numericInput(ns("jitter.size"), "Jitter Point Size",
                    max = 10, min = 0.1,
                    value = .get_default(defaults, "jitter.size", 1, is.numeric)
                ),
                documentParameters$jitter.size,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("jitter.width"), "Jitter Width",
                    min = 0, max = 1, step = 0.05,
                    value = .get_default(defaults, "jitter.width", 0.2, is.numeric)
                ),
                documentParameters$jitter.width,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                colourInput(ns("jitter.color"), "Jitter Point Color",
                    value = .get_default(defaults, "jitter.color", "#000000")
                ),
                documentParameters$jitter.color,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("jitter.shape.legend.size"), "Shape Legend Size",
                    value = .get_default(defaults, "jitter.shape.legend.size", 5, is.numeric),
                    min = 0, max = 20
                ),
                documentParameters$jitter.shape.legend.size,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                materialSwitch(ns("jitter.shape.legend.show"), "Show Shape Legend",
                    value = .get_default(defaults, "jitter.shape.legend.show", TRUE, is.logical),
                    status = "success"
                ),
                documentParameters$jitter.shape.legend.show,
                placement = "top", options = list(container = "body")
            )
        ),
        "Box" = tagList(
            tipify(
                materialSwitch(ns("boxplot.show.outliers"), "Show Outliers",
                    value = .get_default(defaults, "boxplot.show.outliers", FALSE, is.logical),
                    status = "success"
                ),
                documentParameters$boxplot.show.outliers,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                colourInput(ns("boxplot.color"), "Boxplot Color",
                    value = .get_default(defaults, "boxplot.color", "#000000")
                ),
                documentParameters$boxplot.color,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                materialSwitch(ns("boxplot.fill"), "Fill Boxplot",
                    value = .get_default(defaults, "boxplot.fill", TRUE, is.logical),
                    status = "success"
                ),
                documentParameters$boxplot.fill,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("boxplot.lineweight"), "Boxplot Line Weight",
                    value = .get_default(defaults, "boxplot.lineweight", 0.5, is.numeric),
                    min = 0, max = 5, step = 0.1
                ),
                documentParameters$boxplot.lineweight,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("boxgap"), "Boxplot Position Dodge",
                    value = .get_default(defaults, "boxgap", 0.3, is.numeric),
                    min = 0, max = 1, step = 0.05
                ),
                "Set the gap between boxplots within the same group, controlling how closely boxes are spaced",
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("boxgroupgap"), "Boxplot Group Dodge",
                    value = .get_default(defaults, "boxgroupgap", 0.2, is.numeric),
                    min = 0, max = 1, step = 0.05
                ),
                "Set the gap between groups of boxplots when a color.by variable is used",
                placement = "top", options = list(container = "body")
            )
        ),
        "Violin" = tagList(
            tipify(
                numericInput(ns("vlnplot.lineweight"), "Violin Line Weight",
                    value = .get_default(defaults, "vlnplot.lineweight", 0.5, is.numeric),
                    min = 0, max = 5, step = 0.1
                ),
                documentParameters$vlnplot.lineweight,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                selectInput(ns("vlnplot.scaling"), "Violin Scaling",
                    selected = .get_default(
                        defaults, "vlnplot.scaling", "area",
                        function(x) x %in% c("area", "count", "width")
                    ),
                    choices = c("area", "count", "width"), selectize = FALSE
                ),
                documentParameters$vlnplot.scaling,
                placement = "top", options = list(container = "body")
            )
        ),
        "Ridge" = tagList(
            tipify(
                numericInput(ns("ridgeplot.lineweight"), "Ridge Line Weight",
                    value = .get_default(defaults, "ridgeplot.lineweight", 0.5, is.numeric),
                    min = 0, max = 5, step = 0.1
                ),
                documentParameters$ridgeplot.lineweight,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("ridgeplot.scale"), "Ridge Scale (overlap)",
                    value = .get_default(defaults, "ridgeplot.scale", 1.25, is.numeric),
                    min = 0.5, max = 3
                ),
                documentParameters$ridgeplot.scale,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("ridgeplot.ymax.expansion"), "Ridge Y-max Expansion",
                    value = .get_default(
                        defaults, "ridgeplot.ymax.expansion", NA,
                        function(x) is.numeric(x) || is.na(x)
                    ),
                    min = 0, max = 1
                ),
                documentParameters$ridgeplot.ymax.expansion,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                selectInput(ns("ridgeplot.shape"), "Ridge Shape",
                    selected = .get_default(
                        defaults, "ridgeplot.shape", "smooth",
                        function(x) x %in% c("smooth", "hist")
                    ),
                    choices = c("smooth", "hist"), selectize = FALSE
                ),
                documentParameters$ridgeplot.shape,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("ridgeplot.bins"), "Ridge Bins",
                    value = .get_default(defaults, "ridgeplot.bins", 30, is.numeric),
                    min = 5, max = 100
                ),
                documentParameters$ridgeplot.bins,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                numericInput(ns("ridgeplot.binwidth"), "Ridge Binwidth",
                    value = .get_default(
                        defaults, "ridgeplot.binwidth", NULL,
                        function(x) is.numeric(x) || is.null(x)
                    ),
                    min = 0
                ),
                documentParameters$ridgeplot.binwidth,
                placement = "top", options = list(container = "body")
            )
        ),
        "Stats" = .uniform_stats_inputs_ui(ns, defaults),
        "Facet" = tagList(
            tipify(
                selectInput(ns("split.by"), "Split by (facet)",
                    choices = cat.choices,
                    selected = .get_default(
                        defaults, "split.by", "",
                        function(x) x %in% cat.choices
                    ), selectize = FALSE
                ),
                documentParameters$split.by,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                selectInput(ns("split.adjust"), "Facet Scaling",
                    selected = .get_default(
                        defaults, "split.adjust", "free",
                        function(x) x %in% c("fixed", "free", "free_y", "free_x")
                    ),
                    choices = c("fixed", "free", "free_y", "free_x"), selectize = FALSE
                ),
                documentParameters$split.adjust,
                placement = "top", options = list(container = "body")
            ),
            tipify(numericInput(ns("split.ncol"), "Columns",
                step = 1, min = 0,
                value = .get_default(defaults, "split.ncol", NA, is.numeric)
            ), documentParameters$split.ncol, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("split.nrow"), "Rows",
                step = 1, min = 0,
                value = .get_default(defaults, "split.nrow", NA, is.numeric)
            ), documentParameters$split.nrow, placement = "top", options = list(container = "body")),
            .uniform_subplot_spacing_inputs_ui(ns, defaults)
        ),
        "Legend" = .uniform_legend_inputs_ui(ns, defaults),
        "Plotly" = .uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = .uniform_axes_inputs_ui(ns, defaults),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("yPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the yPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output
#'   is wrapped in \code{\link[shinyjqui]{jqui_resizable}} so it can be resized
#'   by dragging. Set to \code{FALSE} when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the yPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
dittoViz_yPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("yPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
