#' Input UI components for the AreaPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `plotthis_AreaPlotServer()` and `plotthis_AreaPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::AreaPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#' 
#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::AreaPlot()] parameters are not available via UI inputs:
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{title} - Plot title (plotly allows interactive editing)
#'   \item \code{subtitle} - Plot subtitle (not supported in plotly)
#'   \item \code{aspect.ratio} - Aspect ratio control (handled by plotly layout)
#'   \item \code{legend.position} - Legend positioning (plotly allows interactive repositioning)
#'   \item \code{split_by} - Split variable (returns a patchwork object, not supported in plotly), use `facet_by` instead
#'   \item \code{design} - Only applies if `split_by` is used
#'   \item \code{split_by_sep} - Only applies if `split_by` is used
#'   \item \code{axes} - Only applies if `split_by` is used
#'   \item \code{axis_titles} - Only applies if `split_by` is used
#'   \item \code{guides} - Only applies if `split_by` is used
#'   \item \code{byrow} - Only applies if `split_by` is used
#'   \item \code{nrow} - Only applies if `split_by` is used
#'   \item \code{ncol} - Only applies if `split_by` is used
#'   \item \code{palette} - Managed internally via the palette selection UI
#'.  \item \code{legend_direction} - Managed postion of legend however this can be handled via plotly
#' }
#'
#' @section Plot parameters and defaults:
#' The following [plotthis::AreaPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis variable (UI: "X values", default: 2nd categorical variable)
#'   \item \code{y} - Y-axis variable (UI: "Y values", default: 2nd numeric variable)
#'   \item \code{group_by} - Grouping variable for area fill (UI: "Group by", default: 3rd categorical variable or "")
#'   \item \code{facet_by} - Faceting variable (UI: "Facet by", default: "")
#'   \item \code{facet_scales} - Facet scale behavior (UI: "Facet scale", default: "fixed")
#'   \item \code{facet_ncol} - Number of facet columns (UI: "Facet number of columns", default: NULL)
#'   \item \code{facet_nrow} - Number of facet rows (UI: "Facet number of rows", default: NULL)
#'   \item \code{facet_byrow} - Facet ordering direction (UI: "Facet by row", default: TRUE)
#'   \item \code{palcolor} - Custom color values (UI: palette picker, derived from palette)
#'   \item \code{theme} - ggplot2 theme (UI: "Theme", default: "theme_this")
#'   \item \code{alpha} - Area fill transparency (UI: "Alpha", default: 1)
#'   \item \code{scale_y} - Scale y-axis by total (UI: "Scale y-axis by total", default: FALSE)
#'   \item \code{legend_direction} - Legend orientation (UI: "Legend direction", default: "vertical")
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
#' @importFrom colourpicker colourInput
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::AreaPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_AreaPlotOutputUI()], [VizModules::plotthis_AreaPlotServer()], [VizModules::plotthis_AreaPlotApp()]
#' @examples
#' library(VizModules)
#' # Needs at least 2 categorical variables for grouping and x-axis
#' mtcars$cyl <- as.factor(mtcars$cyl)
#' mtcars$gear <- as.factor(mtcars$gear)
#' plotthis_AreaPlotInputsUI("areaPlot", mtcars)
plotthis_AreaPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, unlist(lapply(data, is.numeric), use.names = FALSE), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)
    group_facet_choices <- setdiff(cat.choices, cat.choices[2])

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "X values:",
                selected = ifelse("x.data" %in% names(defaults) && defaults[["x.data"]] %in% cat.choices,
                    defaults[["x.data"]], cat.choices[2]
                ),
                choices = cat.choices
            ),
            selectInput(ns("y.data"), "Y values:",
                selected = ifelse("y.data" %in% names(defaults) && defaults[["y.data"]] %in% num.choices,
                    defaults[["y.data"]], num.choices[2]
                ),
                choices = num.choices
            ),
            selectInput(ns("group.by"), "Group by:",
                selected = ifelse("group.by" %in% names(defaults) && defaults[["group.by"]] %in% c("", group_facet_choices),
                    defaults[["group.by"]], cat.choices[3]
                ),
                choices = c("", group_facet_choices)
            ),
            materialSwitch(ns("scale.y"), "Scale y-axis by total:",
                value = ifelse("scale.y" %in% names(defaults),
                    ifelse(is.logical(defaults[["scale.y"]]), defaults[["scale.y"]], FALSE),
                    FALSE
                ),
                status = "success"
            )
        ),
        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by:",
                selected = ifelse("facet.by" %in% names(defaults) && defaults[["facet.by"]] %in% c(group_facet_choices, ""),
                    defaults[["facet.by"]], ""
                ),
                choices = c(group_facet_choices, "")
            ),
            selectInput(ns("facet.scale"), "Facet scale:",
                selected = ifelse("facet.scale" %in% names(defaults) && defaults[["facet.scale"]] %in% c("fixed", "free", "free_x", "free_y"),
                    defaults[["facet.scale"]], "fixed"
                ),
                choices = c("fixed", "free", "free_x", "free_y")
            ),
            numericInput(ns("facet.ncol"), "Facet number of columns:",
                value = ifelse("facet.ncol" %in% names(defaults) && is.numeric(defaults[["facet.ncol"]]),
                    defaults[["facet.ncol"]], NA
                ),
                min = 0, max = 20
            ),
            numericInput(ns("facet.nrow"), "Facet number of rows:",
                value = ifelse("facet.nrow" %in% names(defaults) && is.numeric(defaults[["facet.nrow"]]),
                    defaults[["facet.nrow"]], NA
                ),
                min = 0, max = 20
            ),
            materialSwitch(ns("facet.by.row"), "Facet by row",
                value = ifelse("facet.by.row" %in% names(defaults),
                    ifelse(is.logical(defaults[["facet.by.row"]]), defaults[["facet.by.row"]], TRUE),
                    TRUE
                ),
                status = "success"
            )
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            numericInput(ns("alpha"), "Alpha:",
                value = ifelse("alpha" %in% names(defaults),
                    ifelse(is.numeric(defaults[["alpha"]]), defaults[["alpha"]], 1),
                    1
                ),
                min = 0, max = 1
            )
        ),
        "Axes" = .uniform_axes_inputs_ui(ns, defaults),
        "Lines" = .uniform_lines_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("AreaPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}

#' Output UI components for the AreaPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the AreaPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_AreaPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("AreaPlot"))
    )
}
