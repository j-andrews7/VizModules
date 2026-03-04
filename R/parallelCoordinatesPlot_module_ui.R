#' Input UI components for the parallelCoordinatesPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `parallelCoordinatesPlotServer()` and
#' `parallelCoordinatesPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [VizModules::parallelCoordinatesPlot()] can be set via these inputs,
#' so see the help for that function for an exhaustive list.
#'
#' @section Plot parameters and defaults:
#' The following [VizModules::parallelCoordinatesPlot()] parameters can be accessed via UI inputs
#' and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{dimensions} - Columns to use as axes (UI: "Select dimensions", multiple: TRUE)
#'   \item \code{color.by} - Column to color lines by (UI: "Color by", default: "")
#'   \item \code{color.scale} - Colorscale for lines (UI: "Color scale", default: "Viridis")
#'   \item \code{line.opacity} - Line opacity (UI: "Line opacity", default: 0.5)
#'   \item \code{line.width} - Line width (UI: "Line width", default: 1)
#'   \item \code{show.colorbar} - Show colorbar (UI: "Show colorbar", default: TRUE)
#'   \item \code{label.font.size} - Dimension label font size (UI: "Label font size", default: 12)
#'   \item \code{label.font.color} - Dimension label font color (UI: "Label font color", default: "black")
#'   \item \code{label.font.family} - Dimension label font family (UI: "Label font", default: "Arial")
#'   \item \code{tick.font.size} - Tick label font size (UI: "Tick font size", default: 10)
#'   \item \code{tick.font.color} - Tick label font color (UI: "Tick font color", default: "black")
#'   \item \code{tick.font.family} - Tick label font family (UI: "Tick font", default: "Arial")
#'   \item \code{title.font.size} - Title font size (UI: "Title font size", default: 16)
#'   \item \code{title.font.family} - Title font family (UI: "Title font", default: "Arial")
#'   \item \code{title.text.color} - Title text color (UI: "Title color", default: "black")
#'   \item \code{bgcolor} - Plot background color (UI: "Background color", default: "#FFFFFF")
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
#' @seealso [VizModules::parallelCoordinatesPlot()], [VizModules::organize_inputs()],
#' [VizModules::parallelCoordinatesPlotOutputUI()], [VizModules::parallelCoordinatesPlotServer()],
#' [VizModules::parallelCoordinatesPlotApp()]
#' @examples
#' library(VizModules)
#' parallelCoordinatesPlotInputsUI("parcoords", mtcars)
parallelCoordinatesPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    all.choices <- names(data)
    all.with.empty <- c("", names(data))

    font.choices <- c(
        "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif",
        "Droid Sans Mono", "Gravitas One", "Old Standard TT", "Open Sans",
        "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman",
        "Verdana", "sans-serif", "serif", "monospace"
    )

    colorscale.choices <- c(
        "Viridis", "Cividis", "Inferno", "Magma", "Plasma",
        "Blues", "Greens", "Reds", "Oranges", "Greys",
        "RdBu", "RdYlBu", "Spectral", "Jet", "Hot", "Cool",
        "Portland", "Picnic", "Rainbow", "Earth"
    )

    # Default dimensions: all columns
    default_dims <- if ("dimensions" %in% names(defaults)) {
        defaults[["dimensions"]]
    } else {
        all.choices
    }

    selected <- c("dimensions", "color.by", "color.scale",
        "line.opacity", "line.width", "show.colorbar",
        "label.font.size", "label.font.color", "label.font.family",
        "tick.font.size", "tick.font.color", "tick.font.family",
        "title.font.size", "title.font.family", "title.text.color", "bgcolor")

    documentParameters <- get_documentation(
        package_name = "VizModules::parallelCoordinatesPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("dimensions"), "Select dimensions:",
                choices = all.choices,
                selected = default_dims,
                multiple = TRUE
            ), documentParameters$dimensions, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.by"), "Color by:",
                choices = all.with.empty,
                selected = ifelse("color.by" %in% names(defaults), defaults[["color.by"]], "")
            ), documentParameters$color.by, placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            tipify(selectInput(ns("color.scale"), "Color scale:",
                choices = colorscale.choices,
                selected = ifelse(
                    "color.scale" %in% names(defaults) && defaults[["color.scale"]] %in% colorscale.choices,
                    defaults[["color.scale"]],
                    "Viridis"
                )
            ), documentParameters$color.scale, placement = "top", options = list(container = "body")),
            tipify(sliderInput(ns("line.opacity"), "Line opacity:",
                min = 0, max = 1,
                value = ifelse("line.opacity" %in% names(defaults),
                    ifelse(is.numeric(defaults[["line.opacity"]]), defaults[["line.opacity"]], 0.5),
                    0.5
                ),
                step = 0.05
            ), documentParameters$line.opacity, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("line.width"), "Line width:",
                value = ifelse("line.width" %in% names(defaults),
                    ifelse(is.numeric(defaults[["line.width"]]), defaults[["line.width"]], 1),
                    1
                ),
                min = 0.5,
                step = 0.5
            ), documentParameters$line.width, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("show.colorbar"), "Show colorbar",
                value = ifelse("show.colorbar" %in% names(defaults),
                    isTRUE(defaults[["show.colorbar"]]),
                    TRUE
                )
            ), documentParameters$show.colorbar, placement = "top", options = list(container = "body"))
        ),
        "Labels" = tagList(
            tipify(numericInput(ns("label.font.size"), "Label font size:",
                value = ifelse("label.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["label.font.size"]]), defaults[["label.font.size"]], 12),
                    12
                ),
                min = 1, step = 1
            ), documentParameters$label.font.size, placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("label.font.color"), "Label font color:",
                value = ifelse("label.font.color" %in% names(defaults),
                    defaults[["label.font.color"]], "black"
                )
            ), documentParameters$label.font.color, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("label.font.family"), "Label font:",
                choices = font.choices,
                selected = ifelse(
                    "label.font.family" %in% names(defaults) &&
                        defaults[["label.font.family"]] %in% font.choices,
                    defaults[["label.font.family"]], "Arial"
                )
            ), documentParameters$label.font.family, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("tick.font.size"), "Tick font size:",
                value = ifelse("tick.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["tick.font.size"]]), defaults[["tick.font.size"]], 10),
                    10
                ),
                min = 1, step = 1
            ), documentParameters$tick.font.size, placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("tick.font.color"), "Tick font color:",
                value = ifelse("tick.font.color" %in% names(defaults),
                    defaults[["tick.font.color"]], "black"
                )
            ), documentParameters$tick.font.color, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("tick.font.family"), "Tick font:",
                choices = font.choices,
                selected = ifelse(
                    "tick.font.family" %in% names(defaults) &&
                        defaults[["tick.font.family"]] %in% font.choices,
                    defaults[["tick.font.family"]], "Arial"
                )
            ), documentParameters$tick.font.family, placement = "top", options = list(container = "body"))
        ),
        "Title & Background" = tagList(
            tipify(numericInput(ns("title.font.size"), "Title font size:",
                value = ifelse("title.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["title.font.size"]]), defaults[["title.font.size"]], 16),
                    16
                ),
                min = 1, step = 1
            ), documentParameters$title.font.size, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("title.font.family"), "Title font:",
                choices = font.choices,
                selected = ifelse(
                    "title.font.family" %in% names(defaults) &&
                        defaults[["title.font.family"]] %in% font.choices,
                    defaults[["title.font.family"]], "Arial"
                )
            ), documentParameters$title.font.family, placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("title.text.color"), "Title color:",
                value = ifelse("title.text.color" %in% names(defaults),
                    defaults[["title.text.color"]], "black"
                )
            ), documentParameters$title.text.color, placement = "top", options = list(container = "body")),
            tipify(colourpicker::colourInput(ns("bgcolor"), "Background color:",
                value = ifelse("bgcolor" %in% names(defaults),
                    defaults[["bgcolor"]], "#FFFFFF"
                )
            ), documentParameters$bgcolor, placement = "top", options = list(container = "body"))
        )
    )

    organize_inputs(
        inputs,
        id = ns("parallelCoordinatesPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the parallelCoordinatesPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the parallelCoordinatesPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
parallelCoordinatesPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("parallelCoordinatesPlot"))
    )
}
