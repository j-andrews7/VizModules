#' Input UI components for the dumbbellPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dumbbellPlotServer()` and `dumbbellPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [VizModules::dumbbellPlot()] parameters are not exposed as UI inputs:
#'
#' - `order.by` - Order rows by a Y value; not currently wired to a UI input (use `defaults` to set)
#'
#' @section Plot parameters and defaults:
#' The following [VizModules::dumbbellPlot()] parameters can be accessed via UI inputs:
#'
#' - `x` - X values (UI: "X Values (max 2)", defaults key: `x.value`, multiple: TRUE, max 2 enforced)
#' - `y` - Y value (UI: "Y Value", defaults key: `y.value`, single selection)
#' - `x.adjustment` - X-axis transformation (UI: "X Adjustment", default: "")
#' - `colour.by` - Color by X or Y (UI: "Colour By", default: "X variables")
#' - `facet.by` - Faceting variable (UI: "Facet By", default: "")
#' - `facet.scales` - Facet scale behavior (UI: "Facet Scales", default: "fixed")
#' - `line.colour` - Color of connecting lines (UI: "Colour of Connectors", default: "gray30")
#' - `palette.selection` - Color palette (UI: palette picker)
#'
#' @section Parameters controlling additional functionality:
#' The following parameters controlling plotly-specific features and styling are also available:
#'
#' - `flip.x` - Flip X-axis (UI: "Flip X Axis", default: FALSE)
#' - `flip.y` - Flip Y-axis (UI: "Flip Y Axis", default: FALSE)
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
#' - `abline.intercepts` - Y-intercepts for diagonal lines (UI: "Y-intercepts", default: "")
#' - `abline.colors` - Colors for diagonal lines (UI: "Colors", default: "#000000")
#' - `abline.widths` - Widths for diagonal lines (UI: "Widths", default: "1")
#' - `abline.linetypes` - Line types for diagonal lines (UI: "Line Types", default: "dashed")
#' - `abline.opacities` - Opacities for diagonal lines (UI: "Opacities (0-1)", default: "1")
#' - `margin.t` - Top margin in pixels (UI: "Margin Top", default: 70)
#' - `margin.b` - Bottom margin in pixels (UI: "Margin Bottom", default: 70)
#' - `margin.l` - Left margin in pixels (UI: "Margin Left", default: 70)
#' - `margin.r` - Right margin in pixels (UI: "Margin Right", default: 70)
#' - `subplot.margin.x` - Horizontal spacing between facet panel columns (UI: "Subplot Spacing (Horizontal)")
#' - `subplot.margin.y` - Vertical spacing between facet panel rows (UI: "Subplot Spacing (Vertical)")
#' - `shape.fill` - Fill color for drawn shapes (UI: "Shape Fill", default: "rgba(0, 0, 0, 0)")
#' - `shape.line.color` - Outline color for drawn shapes (UI: "Shape Line Color", default: "black")
#' - `shape.line.width` - Outline width for drawn shapes (UI: "Shape Line Width", default: 4)
#' - `shape.linetype` - Line dash style for drawn shapes (UI: "Shape Linetype", default: "solid")
#' - `shape.opacity` - Opacity for drawn shapes (UI: "Shape Opacity", default: 1)
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
#' @importFrom shinyBS tipify
#'
#' @export
#' @author Jacob Martin
#' @seealso [VizModules::dumbbellPlot()], [VizModules::organize_inputs()],
#' [VizModules::dumbbellPlotOutputUI()], [VizModules::dumbbellPlotServer()], [VizModules::dumbbellPlotApp()]
#' @examples
#' library(VizModules)
#' data <- data.frame(
#'     School = c("MIT", "Stanford", "Harvard"),
#'     Women = c(94, 96, 112),
#'     Men = c(152, 151, 165)
#' )
#' dumbbellPlotInputsUI("dumbbellPlot", data)
dumbbellPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    cat.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    adj.choices <- c("", "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt")

    selected <- list(
        "x", "y", "x.adjustment", "colour.by",
        "facet.by", "facet.scales", "line.colour"
    )

    documentParameters <- get_documentation(
        package_name = "VizModules::dumbbellPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(viz_select_input(ns("x.value"), "X Values (max 2)",
                selected = get_default(
                    defaults, "x.value",
                    if (length(num.choices) >= 3) num.choices[2:3] else num.choices[2],
                    function(x) all(x %in% num.choices)
                ),
                choices = num.choices, multiple = TRUE
            ), documentParameters$x, placement = "top", options = list(container = "body")),
            tipify(viz_select_input(ns("y.value"), "Y Value",
                selected = get_default(
                    defaults, "y.value",
                    if (length(cat.choices) > 1) cat.choices[2] else "",
                    function(x) x %in% cat.choices
                ),
                choices = cat.choices, multiple = FALSE
            ), documentParameters$y, placement = "top", options = list(container = "body")),
            tipify(viz_select_input(ns("x.adjustment"), "X Adjustment",
                choices = adj.choices,
                selected = get_default(
                    defaults, "x.adjustment", "",
                    function(x) x %in% adj.choices
                )
            ), documentParameters$x.adjustment, placement = "top", options = list(container = "body")),
            tipify(viz_select_input(ns("colour.by"), "Colour By",
                choices = c("X variables", "Y variables"),
                selected = get_default(
                    defaults, "colour.by", "X variables",
                    function(x) x %in% c("X variables", "Y variables")
                )
            ), documentParameters$colour.by, placement = "top", options = list(container = "body"))
        ),
        "Facet" = tagList(
            tipify(viz_select_input(ns("facet.by"), "Facet By",
                selected = get_default(
                    defaults, "facet.by", "",
                    function(x) x == "" || x %in% cat.choices
                ),
                choices = c("", .facet_check(data))
            ), documentParameters$facet.by, placement = "top", options = list(container = "body")),
            tipify(viz_select_input(ns("facet.scales"), "Facet Scales",
                choices = c("fixed", "free", "free_x", "free_y"),
                selected = get_default(
                    defaults, "facet.scales", "fixed",
                    function(x) x %in% c("fixed", "free", "free_x", "free_y")
                )
            ), documentParameters$facet.scales, placement = "top", options = list(container = "body")),
            .uniform_subplot_spacing_inputs_ui(ns, defaults)
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            tipify(colourInput(ns("line.colour"), "Colour of Connectors",
                value = get_default(defaults, "line.colour", "gray30")),
                documentParameters$line.colour,
                placement = "top", options = list(container = "body")
            )
        ),

        "Legend" = uniform_legend_inputs_ui(ns, defaults),

        "Plotly" = uniform_plotly_inputs_ui(ns, defaults),
        "Axes" = uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE, include.flip = TRUE),
        "Lines" = uniform_lines_inputs_ui(ns, defaults)
    )


    organize_inputs(
        inputs,
        id = ns("dumbbellPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the dumbbellPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when `TRUE` (the default) the plot output
#'   is wrapped in [shinyjqui::jqui_resizable()] so it can be resized
#'   by dragging. Set to `FALSE` when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the dumbbellPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
dumbbellPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("dumbbellPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
