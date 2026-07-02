#' Input UI components for the piePlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `piePlotServer()` and `piePlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Provide summarized data (one row per slice) with columns for labels and aggregated values.
#' Nearly all parameters for [VizModules::piePlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
#'
#' @section Plot parameters not implemented or with altered functionality:
#' The following [VizModules::piePlot()] parameters are not exposed as UI inputs:
#' \itemize{
#'   \item \code{palette} - Color palette name; use \code{colors} via the color picker UI instead
#'   \item \code{legend.x} - Legend horizontal position offset (use \code{defaults} to set)
#'   \item \code{legend.y} - Legend vertical position offset (use \code{defaults} to set)
#'   \item \code{title.text} - Plot title text (plotly allows interactive editing; use \code{defaults} to set)
#' }
#'
#' @section Plot parameters and defaults:
#' The following [VizModules::piePlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{title.font.size} - Plot title font size (UI: "Title Size", default: 26)
#'   \item \code{title.font.family} - Font family for title text (UI: "Title Font", default: "Arial")
#'   \item \code{title.font.color} - Color for plot title (UI: "Title Color", default: "#000000")
#'   \item \code{labels} - Label column (UI: "Label column (summary data)", default: 2nd categorical column)
#'   \item \code{values} - Aggregated value column (UI: "Aggregated value column", default: 2nd numeric column)
#'   \item \code{sort} - Sort slices by value (UI: "Sort slices by value", default: TRUE)
#'   \item \code{direction} - Slice direction (UI: "Slice direction", default: "counterclockwise")
#'   \item \code{rotation} - Start angle in degrees (UI: "Start angle (degrees)", default: 0)
#'   \item \code{hole} - Center hole size for donut chart (UI: "Center hole size", default: 0)
#'   \item \code{colors} - Slice colors (UI: color picker, derived from palette)
#'   \item \code{slice.line.color} - Slice border color (UI: "Slice border color", default: "#FFFFFF")
#'   \item \code{slice.line.width} - Slice border width (UI: "Slice border width", default: 0)
#'   \item \code{textinfo} - Text to show on slices (UI: "Text to show on slices", default: c("label", "value", "percent"))
#'   \item \code{textposition} - Text position (UI: "Text position", default: "auto")
#'   \item \code{insidetextorientation} - Inside text orientation (UI: "Inside text orientation", default: "auto")
#'   \item \code{text.font.size} - Slice text size (UI: "Slice text size", default: 12)
#'   \item \code{text.font.family} - Slice text font (UI: "Slice text font", default: "Arial")
#'   \item \code{text.font.color} - Slice text color (UI: "Slice text color", default: "#000000")
#'   \item \code{title.x} - Title horizontal position (UI: "Title horizontal position", default: 0.5)
#'   \item \code{show.legend} - Show legend (UI: "Show legend", default: TRUE)
#'   \item \code{legend.orientation} - Legend orientation (UI: "Legend orientation", default: "h")
#'   \item \code{legend.font.family} - Legend font (UI: "Legend font", default: "Arial")
#'   \item \code{legend.font.size} - Legend font size (UI: "Legend font size", default: 12)
#'   \item \code{legend.font.color} - Legend font color (UI: "Legend font color", default: "#000000")
#' }
#'
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation. Supply a summary table with one row per slice.
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
#' @seealso [VizModules::piePlot()], [VizModules::organize_inputs()],
#' [VizModules::piePlotOutputUI()], [VizModules::piePlotServer()], [VizModules::piePlotApp()]
#' @examples
#' library(VizModules)
#' pie_df <- as.data.frame(table(iris$Species))
#' names(pie_df) <- c("Species", "Count")
#' piePlotInputsUI("piePlot", pie_df)
piePlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variable choices
    num.choices <- c("", names(data)[vapply(data, is.numeric, logical(1))])
    cat.choices <- c("", names(data)[!vapply(data, is.numeric, logical(1))])

    font.choices <- c(
        "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono", "Gravitas One",
        "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman", "Verdana",
        "sans-serif", "serif", "monospace"
    )

    selected <- list(
        "labels", "values", "sort", "direction", "rotation", "hole",
        "slice.line.color", "slice.line.width", "textinfo", "textposition",
        "insidetextorientation", "text.font.size", "text.font.family", "text.font.color",
        "title.x", "title.font.size", "title.font.family", "title.font.color",
        "show.legend", "legend.orientation", "legend.font.family",
        "legend.font.size", "legend.font.color"
    )

    documentParameters <- get_documentation(
        package_name = "VizModules::piePlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(
                selectInput(ns("labels"), "Label Column",
                    selected = get_default(
                        defaults, "labels", cat.choices[2],
                        function(x) x %in% cat.choices
                    ),
                    choices = cat.choices, selectize = FALSE
                ),
                documentParameters$labels,
                placement = "top", options = list(container = "body")
            ),
            tipify(
                selectInput(ns("values"), "Aggregated Value Column",
                    selected = get_default(
                        defaults, "values", num.choices[2],
                        function(x) x %in% num.choices
                    ),
                    choices = num.choices, selectize = FALSE
                ),
                documentParameters$values,
                placement = "top", options = list(container = "body")
            ),
            tipify(checkboxInput(ns("sort.slices"), "Sort Slices by Value",
                value = get_default(defaults, "sort.slices", TRUE, is.logical)
            ), documentParameters$sort, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("direction"), "Slice Direction",
                choices = c("Counterclockwise" = "counterclockwise", "Clockwise" = "clockwise"),
                selected = get_default(defaults, "direction", "counterclockwise"), selectize = FALSE
            ), documentParameters$direction, placement = "top", options = list(container = "body")),
            tipify(sliderInput(ns("rotation"), "Start Angle (Degrees)",
                min = 0, max = 360,
                value = get_default(defaults, "rotation", 0),
                step = 5
            ), documentParameters$rotation, placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            uiOutput(ns("color.picker")),
            tipify(colourInput(ns("slice.line.color"), "Slice Border Color",
                value = get_default(defaults, "slice.line.color", "#FFFFFF")
            ), documentParameters$slice.line.color, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("slice.line.width"), "Slice Border Width",
                value = get_default(defaults, "slice.line.width", 0, is.numeric),
                min = 0,
                step = 0.5
            ), documentParameters$slice.line.width, placement = "top", options = list(container = "body")),
            tipify(sliderInput(ns("hole"), "Center Hole Size",
                min = 0, max = 0.9,
                value = get_default(defaults, "hole", 0),
                step = 0.01
            ), documentParameters$hole, placement = "top", options = list(container = "body"))
        ),
        "Labels" = tagList(
            tipify(selectInput(ns("textinfo"), "Slice Label",
                selected = get_default(defaults, "textinfo", c("label", "value", "percent")),
                choices = c("label", "value", "percent", "none"),
                multiple = TRUE, selectize = TRUE
            ), documentParameters$textinfo, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("textposition"), "Text Position",
                choices = c("Auto" = "auto", "Inside" = "inside", "Outside" = "outside", "Hide text" = "none"),
                selected = get_default(defaults, "textposition", "auto"), selectize = FALSE
            ), documentParameters$textposition, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("insidetextorientation"), "Inside Text Orientation",
                choices = c("auto", "horizontal", "radial", "tangential"),
                selected = get_default(defaults, "insidetextorientation", "auto"), selectize = FALSE
            ), documentParameters$insidetextorientation, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("text.font.size"), "Slice Text Size",
                value = get_default(defaults, "text.font.size", 12, is.numeric),
                min = 6,
                step = 1
            ), documentParameters$text.font.size, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("text.font.family"), "Slice Text Font",
                choices = font.choices,
                selected = get_default(
                    defaults, "text.font.family", "Arial",
                    function(x) x %in% font.choices
                ), selectize = FALSE
            ), documentParameters$text.font.family, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("text.font.color"), "Slice Text Color",
                value = get_default(defaults, "text.font.color", "#000000")
            ), documentParameters$text.font.color, placement = "top", options = list(container = "body"))
        ),
        "Title & Legend" = tagList(
            tipify(sliderInput(ns("title.x"), "Title Position",
                min = 0, max = 1,
                value = get_default(defaults, "title.x", 0.5),
                step = 0.01
            ), documentParameters$title.x, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("title.font.size"), "Title Size",
                value = get_default(defaults, "title.font.size", 28, is.numeric),
                min = 0
            ), documentParameters$title.font.size, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("title.font.family"), "Title Font",
                choices = font.choices,
                selected = get_default(
                    defaults, "title.font.family", "Arial",
                    function(x) x %in% font.choices
                ), selectize = FALSE
            ), documentParameters$title.font.family, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("title.font.color"), "Title Color",
                value = get_default(defaults, "title.font.color", "#000000")
            ), documentParameters$title.font.color, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("show.legend"), "Show Legend",
                value = get_default(defaults, "show.legend", TRUE, is.logical)
            ), documentParameters$show.legend, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("legend.orientation"), "Legend Orientation",
                choices = c("Horizontal" = "h", "Vertical" = "v"),
                selected = get_default(defaults, "legend.orientation", "h"), selectize = FALSE
            ), documentParameters$legend.orientation, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("legend.font.family"), "Legend Font",
                choices = font.choices,
                selected = get_default(
                    defaults, "legend.font.family", "Arial",
                    function(x) x %in% font.choices
                ), selectize = FALSE
            ), documentParameters$legend.font.family, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("legend.font.size"), "Legend Font Size",
                value = get_default(defaults, "legend.font.size", 12, is.numeric),
                min = 1,
                step = 1
            ), documentParameters$legend.font.size, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("legend.font.color"), "Legend Font Color",
                value = get_default(defaults, "legend.font.color", "#000000")
            ), documentParameters$legend.font.color, placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults)
    )

    organize_inputs(
        inputs,
        id = ns("piePlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the piePlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#' @param resizable Logical; when \code{TRUE} (the default) the plot output
#'   is wrapped in \code{\link[shinyjqui]{jqui_resizable}} so it can be resized
#'   by dragging. Set to \code{FALSE} when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the piePlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
piePlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("piePlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
