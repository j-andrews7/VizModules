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
#' @section Plot parameters not implemented or with altered functionality:
#' The following [VizModules::parallelCoordinatesPlot()] parameters are not exposed as UI inputs:
#'
#' - `title.text` - Plot title text (plotly allows interactive editing; use `defaults` to set)
#'
#' @section Plot parameters and defaults:
#' The following [VizModules::parallelCoordinatesPlot()] parameters can be accessed via UI inputs
#' and/or the `defaults` argument:
#'
#' - `title.font.size` - Plot title font size (UI: "Title Size", default: 26)
#' - `title.font.family` - Font family for title text (UI: "Title Font", default: "Arial")
#' - `title.font.color` - Color for plot title (UI: "Title Color", default: "#000000")
#' - `dimensions` - Columns to use as axes (UI: "Select dimensions", multiple: TRUE)
#' - `color.by` - Column to color lines by (UI: "Color by", default: "")
#' - `color.scale` - Colorscale for lines when `color.by` is numeric (UI: "Color Scale", default: "Viridis")
#' - `palette.selection` - Discrete color palette used when `color.by` is categorical (UI: palette picker)
#' - `line.opacity` - Line opacity (UI: "Line opacity", default: 0.5)
#' - `line.width` - Line width (UI: "Line width", default: 1)
#' - `show.colorbar` - Show colorbar (UI: "Show colorbar", default: TRUE)
#' - `label.font.size` - Dimension label font size (UI: "Label font size", default: 12)
#' - `label.font.color` - Dimension label font color (UI: "Label font color", default: "black")
#' - `label.font.family` - Dimension label font family (UI: "Label font", default: "Arial")
#' - `tick.font.size` - Tick label font size (UI: "Tick font size", default: 10)
#' - `tick.font.color` - Tick label font color (UI: "Tick font color", default: "black")
#' - `tick.font.family` - Tick label font family (UI: "Tick font", default: "Arial")
#' - `bgcolor` - Plot background color (UI: "Background color", default: "#FFFFFF")
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
        "Blackbody", "Bluered", "Blues", "Cividis", "Earth",
        "Electric", "Greens", "Greys", "Hot", "Jet", "Picnic",
        "Portland", "Rainbow", "RdBu", "Reds", "Viridis",
        "YlGnBu", "YlOrRd"
    )

    default_dims <- if ("dimensions" %in% names(defaults)) {
        defaults[["dimensions"]]
    } else {
        all.choices
    }

    selected <- list(
        "dimensions", "color.by", "color.scale", "palette.selection",
        "line.opacity", "line.width", "show.colorbar",
        "label.font.size", "label.font.color", "label.font.family",
        "tick.font.size", "tick.font.color", "tick.font.family",
        "title.font.size", "title.font.family", "title.font.color", "bgcolor"
    )

    documentParameters <- get_documentation(
        package_name = "VizModules::parallelCoordinatesPlot", type = "param",
        selected = selected, cap = TRUE
    )

    inputs <- list(
        "Data" = tagList(
            tipify(selectInput(ns("dimensions"), "Dimensions",
                choices = all.choices,
                selected = default_dims,
                multiple = TRUE, selectize = TRUE
            ), documentParameters$dimensions, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("color.by"), "Color By",
                choices = all.with.empty,
                selected = get_default(defaults, "color.by", ""), selectize = FALSE
            ), documentParameters$color.by, placement = "top", options = list(container = "body"))
        ),
        "Aesthetics" = tagList(
            tipify(selectInput(ns("color.scale"), "Color Scale",
                choices = colorscale.choices,
                selected = get_default(
                    defaults, "color.scale", "Viridis",
                    function(x) x %in% colorscale.choices
                ), selectize = FALSE
            ), documentParameters$color.scale, placement = "top", options = list(container = "body")),
            uiOutput(ns("palette.selection")),
            tipify(sliderInput(ns("line.opacity"), "Line Opacity",
                min = 0, max = 1,
                value = get_default(defaults, "line.opacity", 0.5, is.numeric),
                step = 0.05
            ), documentParameters$line.opacity, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("line.width"), "Line Width",
                value = get_default(defaults, "line.width", 1, is.numeric),
                min = 0.5,
                step = 0.5
            ), documentParameters$line.width, placement = "top", options = list(container = "body")),
            tipify(checkboxInput(ns("show.colorbar"), "Show Colorbar",
                value = get_default(defaults, "show.colorbar", TRUE, is.logical)
            ), documentParameters$show.colorbar, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("bgcolor"), "Background Color",
                value = get_default(defaults, "bgcolor", "#FFFFFF")
            ), documentParameters$bgcolor, placement = "top", options = list(container = "body"))
        ),
        "Labels" = tagList(
            tipify(numericInput(ns("label.font.size"), "Label Size",
                value = get_default(defaults, "label.font.size", 12, is.numeric),
                min = 1, step = 1
            ), documentParameters$label.font.size, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("label.font.color"), "Label Color",
                value = get_default(defaults, "label.font.color", "black")
            ), documentParameters$label.font.color, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("label.font.family"), "Label Font",
                choices = font.choices,
                selected = get_default(
                    defaults, "label.font.family", "Arial",
                    function(x) x %in% font.choices
                ), selectize = FALSE
            ), documentParameters$label.font.family, placement = "top", options = list(container = "body")),
            tipify(numericInput(ns("tick.font.size"), "Tick Font Size",
                value = get_default(defaults, "tick.font.size", 10, is.numeric),
                min = 1, step = 1
            ), documentParameters$tick.font.size, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("tick.font.color"), "Tick Font Color",
                value = get_default(defaults, "tick.font.color", "black")
            ), documentParameters$tick.font.color, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("tick.font.family"), "Tick Font",
                choices = font.choices,
                selected = get_default(
                    defaults, "tick.font.family", "Arial",
                    function(x) x %in% font.choices
                ), selectize = FALSE
            ), documentParameters$tick.font.family, placement = "top", options = list(container = "body"))
        ),
        "Title" = tagList(
            tipify(numericInput(ns("title.font.size"), "Title Size",
                value = get_default(defaults, "title.font.size", 26, is.numeric),
                min = 1, step = 1
            ), documentParameters$title.font.size, placement = "top", options = list(container = "body")),
            tipify(selectInput(ns("title.font.family"), "Title Font",
                choices = font.choices,
                selected = get_default(
                    defaults, "title.font.family", "Arial",
                    function(x) x %in% font.choices
                ), selectize = FALSE
            ), documentParameters$title.font.family, placement = "top", options = list(container = "body")),
            tipify(colourInput(ns("title.font.color"), "Title Color",
                value = get_default(defaults, "title.font.color", "black")
            ), documentParameters$title.font.color, placement = "top", options = list(container = "body"))
        ),
        "Plotly" = uniform_plotly_inputs_ui(ns, defaults)
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
#' @param resizable Logical; when `TRUE` (the default) the plot output
#'   is wrapped in [shinyjqui::jqui_resizable()] so it can be resized
#'   by dragging. Set to `FALSE` when embedding the output in a container
#'   that already provides resizing.
#'
#' @return A Shiny plotlyOutput for the parallelCoordinatesPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
parallelCoordinatesPlotOutputUI <- function(id, resizable = TRUE) {
    ns <- NS(id)
    plot_output <- plotlyOutput(ns("parallelCoordinatesPlot"))
    if (isTRUE(resizable)) {
        plot_output <- jqui_resizable(plot_output)
    }
    plot_output
}
