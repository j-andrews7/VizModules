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
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{main} - Plot title (plotly allows interactive editing)
#'   \item \code{sub} - Plot subtitle (not supported in plotly)
#'   \item \code{theme} - ggplot2 theme (not applicable to plotly)
#'   \item \code{legend.title} - Legend title (managed by plotly interactively)
#'   \item \code{add.line} - Use \code{hline.intercepts} instead for horizontal lines with full styling options
#'   \item \code{line.linetype} - Use \code{hline.linetypes} instead
#'   \item \code{line.color} - Use \code{hline.colors} instead
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
#'   \item \code{split.nrow} - Number of facet rows (UI: "Number of Rows", default: 4)
#'   \item \code{split.ncol} - Number of facet columns (UI: "Number of Columns", default: 4)
#'   \item \code{split.adjust} - Facet scale behavior (UI: "Facet Scaling", default: "free")
#'   \item \code{do.raster} - Rasterize jitter points (UI: "Rasterize Jitter", default: FALSE)
#'   \item \code{raster.dpi} - DPI for rasterization (UI: "Raster DPI", default: 600)
#'   \item \code{jitter.size} - Jitter point size (UI: "Jitter Point Size", default: 1)
#'   \item \code{jitter.width} - Jitter width (UI: "Jitter Width", default: 0.2)
#'   \item \code{jitter.color} - Jitter point color (UI: "Jitter Point Color", default: "#000000")
#'   \item \code{jitter.shape.legend.size} - Shape legend size (UI: "Shape Legend Size", default: 5)
#'   \item \code{jitter.shape.legend.show} - Show shape legend (UI: "Show Shape Legend", default: TRUE)
#'   \item \code{jitter.position.dodge} - Jitter position dodge (calculated from boxgap)
#'   \item \code{boxplot.show.outliers} - Show boxplot outliers (always TRUE in implementation)
#'   \item \code{boxplot.color} - Boxplot outline color (UI: "Boxplot Color", default: "#000000")
#'   \item \code{boxplot.fill} - Fill boxplot (UI: "Fill Boxplot", default: TRUE)
#'   \item \code{boxplot.lineweight} - Boxplot line weight (UI: "Boxplot Line Weight", default: 0.5)
#'   \item \code{vlnplot.lineweight} - Violin line weight (UI: "Violin Line Weight", default: 0.5)
#'   \item \code{vlnplot.scaling} - Violin scaling method (UI: "Violin Scaling", default: "area")
#'   \item \code{vlnplot.quantiles} - Violin quantiles (UI: "Violin Quantiles (0-1)", default: "")
#'   \item \code{vlnplot.width} - Violin width (calculated from boxgap)
#'   \item \code{ridgeplot.lineweight} - Ridge line weight (UI: "Ridge Line Weight", default: 0.5)
#'   \item \code{ridgeplot.scale} - Ridge overlap scale (UI: "Ridge Scale (overlap)", default: 1.25)
#'   \item \code{ridgeplot.ymax.expansion} - Ridge Y-max expansion (UI: "Ridge Y-max Expansion", default: NA)
#'   \item \code{ridgeplot.shape} - Ridge shape (UI: "Ridge Shape", default: "smooth")
#'   \item \code{ridgeplot.bins} - Ridge bins (UI: "Ridge Bins", default: 30)
#'   \item \code{ridgeplot.binwidth} - Ridge binwidth (UI: "Ridge Binwidth", default: NULL)
#'   \item \code{legend.show} - Show legend (always TRUE in implementation)
#' }
#'
#' @section Parameters controlling additional functionality:
#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#' \itemize{
#'   \item \code{boxmode} - Boxplot mode grouping (calculated: "group" or "overlay" based on color.by)
#'   \item \code{boxgap} - Boxplot position dodge (UI: "Boxplot Position Dodge", default: 0.3)
#'   \item \code{boxgroupgap} - Boxplot group dodge (UI: "Boxplot Group Dodge", default: 0.2)
#'   \item \code{font.type} - Font family for plot text (UI: "Font", default: "Arial")
#'   \item \code{text.colour} - Color for title text (UI: "Label colour", default: "#000000")
#'   \item \code{axis.title.font.size} - Axis title font size (UI: "Axis font size", default: 18)
#'   \item \code{axis.title.font.color} - Axis title font color (UI: "Axis title font color", default: "#000000")
#'   \item \code{axis.title.font.family} - Axis title font family (UI: "Axis title font family", default: "Arial")
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
#'
#' @export
#' @author Jared Andrews, Jacob Martin
#' @seealso [dittoViz::yPlot()], [VizModules::organize_inputs()],
#' [VizModules::dittoViz_yPlotOutputUI()], [VizModules::dittoViz_yPlotServer()], [VizModules::dittoViz_yPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' dittoViz_yPlotInputsUI("yPlot", mtcars)
dittoViz_yPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11 # Y axis scale factor
    min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)

    tip_btn <- function(ns, tip_id) {
        actionButton(ns(tip_id), HTML("\u2139"),
            class = "btn-xs btn-link p-0",
            style = "box-shadow: none; border: none; background: transparent; line-height: 1.2;",
            `data-bs-toggle` = "tooltip")
    }

    tip_wrap <- function(input_el, tip_el) {
        div(
            style = "display: flex; align-items: center; gap: 4px;",
            div(style = "flex: 1;", input_el),
            tip_el
        )
    }

    inputs <- list(
        "Data" = tagList(
            tip_wrap(
                selectInput(ns("var"), "Y data (var)", choices = num.choices, selected = num.choices[2]),
                tip_btn(ns, "tip_var")
            ),
            tip_wrap(
                selectInput(ns("group.by"), "Group by", selected = cat.choices[2], choices = cat.choices),
                tip_btn(ns, "tip_group.by")
            ),
            tip_wrap(
                selectInput(ns("color.by"), "Color by", selected = "", choices = c("", cat.choices)),
                tip_btn(ns, "tip_color.by")
            ),
            tip_wrap(
                selectInput(ns("shape.by"), "Shape by", selected = "", choices = c("", cat.choices)),
                tip_btn(ns, "tip_shape.by")
            ),
            uiOutput(ns("palette.selection"))
        ),
        "Plot Type" = tagList(
            tip_wrap(
                selectInput(
                    ns("plots"),
                    "Plots to show:",
                    choices = c("Violin" = "vlnplot", "Box" = "boxplot", "Jitter" = "jitter", "Ridge" = "ridgeplot"),
                    selected = c("boxplot", "jitter"), multiple = TRUE
                ),
                tip_btn(ns, "tip_plots")
            ),
            helpText("Order not currently respected")
        ),
        "Adjustments" = tagList(
            tip_wrap(
                numericInput(ns("y.max"), "Y Axis Max", value = max.y, min = -1000, max = 1000),
                tip_btn(ns, "tip_max")
            ),
            tip_wrap(
                numericInput(ns("y.min"), "Y Axis Min", value = min.y, min = -1000, max = 1000),
                tip_btn(ns, "tip_min")
            ),
            tip_wrap(
                materialSwitch(ns("do.raster"), "Rasterize Jitter", value = FALSE, status = "success"),
                tip_btn(ns, "tip_do.raster")
            ),
            tip_wrap(
                numericInput(ns("raster.dpi"), "Raster DPI", value = 600, min = 100, max = 1200),
                tip_btn(ns, "tip_raster.dpi")
            )
        ),
        "Jitter" = tagList(
            tip_wrap(
                numericInput(ns("jitter.size"), "Jitter Point Size", max = 10, min = 0.1, value = 1),
                tip_btn(ns, "tip_jitter.size")
            ),
            tip_wrap(
                numericInput(ns("jitter.width"), "Jitter Width", min = 0, max = 1, value = 0.2, step = 0.05),
                tip_btn(ns, "tip_jitter.width")
            ),
            tip_wrap(
                colourpicker::colourInput(ns("jitter.color"), "Jitter Point Color", value = "#000000"),
                tip_btn(ns, "tip_jitter.color")
            ),
            tip_wrap(
                numericInput(ns("jitter.shape.legend.size"), "Shape Legend Size",
                    value = 5, min = 0, max = 20),
                tip_btn(ns, "tip_jitter.shape.legend.size")
            ),
            tip_wrap(
                materialSwitch(ns("jitter.shape.legend.show"), "Show Shape Legend",
                    value = TRUE, status = "success"),
                tip_btn(ns, "tip_jitter.shape.legend.show")
            )
        ),
        "Box" = tagList(
            materialSwitch(ns("show.outliers"), "Show Outliers",
                value = FALSE, status = "success"),
            tip_wrap(
                colourpicker::colourInput(ns("boxplot.color"), "Boxplot Color", value = "#000000"),
                tip_btn(ns, "tip_boxplot.color")
            ),
            tip_wrap(
                materialSwitch(ns("boxplot.fill"), "Fill Boxplot", value = TRUE, status = "success"),
                tip_btn(ns, "tip_boxplot.fill")
            ),
            tip_wrap(
                numericInput(ns("boxplot.lineweight"), "Boxplot Line Weight", value = 0.5, min = 0, max = 5, step = 0.1),
                tip_btn(ns, "tip_boxplot.lineweight")
            ),
            numericInput(ns("boxgap"), "Boxplot Position Dodge", value = 0.3, min = 0, max = 1, step = 0.05),
            numericInput(ns("boxgroupgap"), "Boxplot Group Dodge", value = 0.2, min = 0, max = 1, step = 0.05)
        ),
        "Violin" = tagList(
            tip_wrap(
                numericInput(ns("vlnplot.lineweight"), "Violin Line Weight", value = 0.5, min = 0, max = 5, step = 0.1),
                tip_btn(ns, "tip_vlnplot.lineweight")
            ),
            tip_wrap(
                selectInput(ns("vlnplot.scaling"), "Violin Scaling",
                    selected = "area",
                    choices = c("area", "count", "width")),
                tip_btn(ns, "tip_vlnplot.scaling")
            ),
            tip_wrap(
                textInput(ns("vlnplot.quantiles"), "Violin Quantiles (0-1)",
                    value = "", placeholder = "e.g., 0.25, 0.5, 0.75"),
                tip_btn(ns, "tip_vlnplot.quantiles")
            )
        ),
        "Ridge" = tagList(
            tip_wrap(
                numericInput(ns("ridgeplot.lineweight"), "Ridge Line Weight", value = 0.5, min = 0, max = 5, step = 0.1),
                tip_btn(ns, "tip_ridgeplot.lineweight")
            ),
            tip_wrap(
                numericInput(ns("ridgeplot.scale"), "Ridge Scale (overlap)", value = 1.25, min = 0.5, max = 3),
                tip_btn(ns, "tip_ridgeplot.scale")
            ),
            tip_wrap(
                numericInput(ns("ridgeplot.ymax.expansion"), "Ridge Y-max Expansion",
                    value = NA, min = 0, max = 1),
                tip_btn(ns, "tip_ridgeplot.ymax.expansion")
            ),
            tip_wrap(
                selectInput(ns("ridgeplot.shape"), "Ridge Shape",
                    selected = "smooth",
                    choices = c("smooth", "hist")),
                tip_btn(ns, "tip_ridgeplot.shape")
            ),
            tip_wrap(
                numericInput(ns("ridgeplot.bins"), "Ridge Bins",
                    value = 30, min = 5, max = 100),
                tip_btn(ns, "tip_ridgeplot.bins")
            ),
            tip_wrap(
                numericInput(ns("ridgeplot.binwidth"), "Ridge Binwidth",
                    value = NULL, min = 0),
                tip_btn(ns, "tip_ridgeplot.binwidth")
            )
        ),
        "Facet" = tagList(
            tip_wrap(
                selectInput(ns("split.by"), "Split by (facet)", selected = "", choices = c("", cat.choices)),
                tip_btn(ns, "tip_split.by")
            ),
            selectInput(ns("split.adjust"), "Facet Scaling", selected = "free", choices = c("fixed", "free", "free_y", "free_x")),
            selectInput(ns("split.ncol"), "Number of Columns", selected = 4, choices = c("", 1:10)),
            selectInput(ns("split.nrow"), "Number of Rows", selected = 4, choices = c("", 1:10))
        ),
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
#'
#' @return A Shiny plotlyOutput for the yPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
dittoViz_yPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("yPlot"))
    )
}
