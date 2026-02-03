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
#' @section Plot parameters and defaults:
#' The following [VizModules::piePlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
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
#'   \item \code{title.font.size} - Title font size (UI: "Title font size", default: 28)
#'   \item \code{title.font.family} - Title font (UI: "Title font", default: "Arial")
#'   \item \code{title.font.color} - Title font color (UI: "Title font color", default: "#000000")
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

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("labels"), "Label column (summary data):", selected = cat.choices[2], choices = cat.choices),
            selectInput(ns("values"), "Aggregated value column:", selected = num.choices[2], choices = num.choices),
            checkboxInput(ns("sort.slices"), "Sort slices by value",
                value = ifelse("sort.slices" %in% names(defaults),
                    isTRUE(defaults[["sort.slices"]]),
                    TRUE
                )
            ),
            selectInput(ns("direction"), "Slice direction:",
                choices = c("Counterclockwise" = "counterclockwise", "Clockwise" = "clockwise"),
                selected = ifelse("direction" %in% names(defaults),
                    defaults[["direction"]],
                    "counterclockwise"
                )
            ),
            sliderInput(ns("rotation"), "Start angle (degrees):",
                min = 0, max = 360,
                value = ifelse("rotation" %in% names(defaults),
                    defaults[["rotation"]],
                    0
                ),
                step = 5
            ),
            sliderInput(ns("hole"), "Center hole size:",
                min = 0, max = 0.9,
                value = ifelse("hole" %in% names(defaults),
                    defaults[["hole"]],
                    0
                ),
                step = 0.01
            )
        ),
        "Colors" = tagList(
            uiOutput(ns("color.picker")),
            colourpicker::colourInput(ns("slice.line.color"), "Slice border color:",
                value = ifelse("slice.line.color" %in% names(defaults),
                    defaults[["slice.line.color"]],
                    "#FFFFFF"
                )
            ),
            numericInput(ns("slice.line.width"), "Slice border width:",
                value = ifelse("slice.line.width" %in% names(defaults),
                    ifelse(is.numeric(defaults[["slice.line.width"]]), defaults[["slice.line.width"]], 0),
                    0
                ),
                min = 0,
                step = 0.5
            )
        ),
        "Labels & Text" = tagList(
            selectInput(ns("textinfo"), "Text to show on slices:",
                selected = ifelse("textinfo" %in% names(defaults),
                    defaults[["textinfo"]],
                    c("label", "value", "percent")
                ),
                choices = c("label", "value", "percent", "none"),
                multiple = TRUE
            ),
            selectInput(ns("textposition"), "Text position:",
                choices = c("Auto" = "auto", "Inside" = "inside", "Outside" = "outside", "Hide text" = "none"),
                selected = ifelse("textposition" %in% names(defaults),
                    defaults[["textposition"]],
                    "auto"
                )
            ),
            selectInput(ns("insidetextorientation"), "Inside text orientation:",
                choices = c("auto", "horizontal", "radial", "tangential"),
                selected = ifelse("insidetextorientation" %in% names(defaults),
                    defaults[["insidetextorientation"]],
                    "auto"
                )
            ),
            numericInput(ns("text.font.size"), "Slice text size:",
                value = ifelse("text.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["text.font.size"]]), defaults[["text.font.size"]], 12),
                    12
                ),
                min = 6,
                step = 1
            ),
            selectInput(ns("text.font.family"), "Slice text font:",
                choices = font.choices,
                selected = ifelse("text.font.family" %in% names(defaults) && defaults[["text.font.family"]] %in% font.choices,
                    defaults[["text.font.family"]],
                    "Arial"
                )
            ),
            colourpicker::colourInput(ns("text.font.color"), "Slice text color:",
                value = ifelse("text.font.color" %in% names(defaults),
                    defaults[["text.font.color"]],
                    "#000000"
                )
            )
        ),
        "Title & Legend" = tagList(
            sliderInput(ns("title.x"), "Title horizontal position:",
                min = 0, max = 1,
                value = ifelse("title.x" %in% names(defaults),
                    defaults[["title.x"]],
                    0.5
                ),
                step = 0.01
            ),
            numericInput(ns("title.font.size"), "Title font size:",
                value = ifelse("title.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["title.font.size"]]), defaults[["title.font.size"]], 28),
                    28
                ),
                min = 0
            ),
            selectInput(ns("title.font.family"), "Title font:",
                choices = font.choices,
                selected = ifelse("title.font.family" %in% names(defaults) && defaults[["title.font.family"]] %in% font.choices,
                    defaults[["title.font.family"]],
                    "Arial"
                )
            ),
            colourpicker::colourInput(ns("title.font.color"), "Title font color:",
                value = ifelse("title.font.color" %in% names(defaults),
                    defaults[["title.font.color"]],
                    "#000000"
                )
            ),
            checkboxInput(ns("show.legend"), "Show legend",
                value = ifelse("show.legend" %in% names(defaults),
                    isTRUE(defaults[["show.legend"]]),
                    TRUE
                )
            ),
            selectInput(ns("legend.orientation"), "Legend orientation:",
                choices = c("Horizontal" = "h", "Vertical" = "v"),
                selected = ifelse("legend.orientation" %in% names(defaults),
                    defaults[["legend.orientation"]],
                    "h"
                )
            ),
            selectInput(ns("legend.font.family"), "Legend font:",
                choices = font.choices,
                selected = ifelse("legend.font.family" %in% names(defaults) && defaults[["legend.font.family"]] %in% font.choices,
                    defaults[["legend.font.family"]],
                    "Arial"
                )
            ),
            numericInput(ns("legend.font.size"), "Legend font size:",
                value = ifelse("legend.font.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["legend.font.size"]]), defaults[["legend.font.size"]], 12),
                    12
                ),
                min = 1,
                step = 1
            ),
            colourpicker::colourInput(ns("legend.font.color"), "Legend font color:",
                value = ifelse("legend.font.color" %in% names(defaults),
                    defaults[["legend.font.color"]],
                    "#000000"
                )
            )
        )
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
#'
#' @return A Shiny plotlyOutput for the piePlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin, Jared Andrews
piePlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("piePlot"))
    )
}
