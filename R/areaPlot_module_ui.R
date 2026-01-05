#' Input UI components for the areaPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `areaPlotServer()` and `areaPlotOutputUI()` functions.
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
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @importFrom colourpicker colourInput
#' @importFrom shinyWidgets switchInput
#'
#' @export
#' @author Jacob Martin
#' @seealso [plotthis::AreaPlot()], [vizModules::organize_inputs()],
#' [vizModules::areaPlotOutputUI()], [vizModules::areaPlotServer()], [vizModules::createAreaPlotApp()]
#' @examples
#' library(vizModules)
#' data(mtcars)
#' areaPlotInputsUI("areaPlot", mtcars)
areaPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, is.character), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "X values:", selected = char.choices[2], choices = char.choices),
            selectInput(ns("y.data"), "Y values:", selected = num.choices[2], choices = num.choices),
            selectInput(ns("group.by"), "Group by:", selected = char.choices[3], choices = char.choices)
        ),
        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by:", selected = "NULL", choices = c(char.choices, "NULL")),
            selectInput(ns("facet.scale"), "Facet scale:", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Facet number of columns:", value = NULL, min = 0, max = 20),
            numericInput(ns("facet.nrow"), "Facet number of rows:", value = NULL, min = 0, max = 20),
            switchInput(ns("facet.by.row"), "Facet by row:", value = TRUE, offLabel = "Off", onLabel = "On"),
            selectInput(ns("split.by"), "Split by:", selected = "NULL", choices = c(char.choices, "NULL")),
            switchInput(ns("combine"), "Combine plot:", value = TRUE, offLabel = "Off", onLabel = "On"),
            textAreaInput(ns("design"), "Custom Layout:",
                value = "NULL", rows = 4,
                placeholder = "122\n153\n443"
            )
        ),
        "Aesthetic" = tagList(
            selectInput(ns("palette"), "Plot Palette:", selected = "Set2", choices = names(plotthis::palette_list)),
            uiOutput(ns("palette.selection")),
            selectInput(ns("theme"), "Theme:", selected = "theme_this", choices = c(
                "theme_grey", "theme_bw", "theme_linedraw", "theme_light",
                "theme_dark", "theme_minimal", "theme_classic", "theme_void",
                "theme_this", "theme_blank"
            )),
            numericInput(ns("alpha"), "Alpha:", value = 1, min = 0, max = 1)
        ),
        "Labels" = tagList(
            selectInput(ns("font.type"), "Font:", selected = "Arial", choices = c(
                "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono", "Gravitas One",
                "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman", "Verdana",
                "sans-serif", "serif", "monospace"
            )),
            numericInput(ns("axis.font.size"), "Axis font size", value = 18, min = 1),
            numericInput(ns("title.font.size"), "Title font size", value = 28, min = 1),
            colourpicker::colourInput(ns("text.colour"), "Label colour:", value = "#000000")
        )
    )

    organize_inputs(
        inputs,
        id = ns("areaPlotTabsetPanel"),
        title = title,
        tack = tagList(
            actionButton(ns("update"), "Update Plot"),
            actionButton(ns("reset"), "Reset Defaults", class = "btn-secondary"),
            selectInput(ns("download.type"), "Download Format:", selected = "png", choices = c("png", "svg")),
            br()
        ),
        columns = columns
    )
}

#' Output UI components for the areaPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the areaPlot
#'
#' @importFrom shiny NS
#' @importFrom plotly plotlyOutput
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
areaPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("areaPlot"), width = "100%", height = "400px"),
        options = list(
            minWidth = 300,
            minHeight = 300,
            maxWidth = 1200,
            maxHeight = 800
        )
    )
}
