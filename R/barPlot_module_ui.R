#' Input UI components for the barPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `barPlotServer()` and `barPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::BarPlot()] can be set via these inputs, so see the help
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
#' @seealso [plotthis::BarPlot()], [vizModules::organize_inputs()],
#' [vizModules::barPlotOutputUI()], [vizModules::barPlotServer()], [vizModules::createBarPlotApp()]
#' @examples
#' library(vizModules)
#' data(mtcars)
#' barPlotInputsUI("barPlot", mtcars)
barPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, unlist(lapply(data, is.numeric), use.names = FALSE), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "X values:", selected = char.choices[2], choices = char.choices),
            selectInput(ns("y.data"), "Y values:", selected = num.choices[2], choices = num.choices),
            switchInput(ns("flip"), "Flip plot:", value = FALSE, onLabel = "On", offLabel = "Off"),
            numericInput(ns("y.max"), "Max y value:", value = max.y),
            numericInput(ns("y.min"), "Min y value:", value = min.y)
        ),
        "Grouping" = tagList(
            selectInput(ns("group.by"), "Group by:", selected = char.choices[2], choices = char.choices),
            selectInput(ns("facet.by"), "Facet by:", selected = "NULL", choices = c(char.choices, "NULL")),
            selectInput(ns("facet.scale"), "Facet scale:", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Facet number of columns:", value = NULL, min = 0, max = 20),
            numericInput(ns("facet.nrow"), "Facet number of rows:", value = NULL, min = 0, max = 20),
            switchInput(ns("facet.by.row"), "Facet by row:", value = TRUE, offLabel = "Off", onLabel = "On"),
            selectInput(ns("split.by"), "Split by:", selected = "NULL", choices = c(char.choices, "NULL"))
        ),
        "Aesthetic" = tagList(
            selectInput(ns("palette"), "Plot Palette:", selected = "Set2", choices = names(plotthis::palette_list)),
            uiOutput(ns("palette.selection")),
            switchInput(ns("background.colour"), "Background colour:", value = FALSE, onLabel = "On", offLabel = "Off"),
            selectInput(ns("background.palette"), "Background Palette:", selected = "Set2", choices = names(plotthis::palette_list)),
            numericInput(ns("background.alpha"), "Background alpha: ", value = 0.5, min = 0, max = 1),
            selectInput(ns("theme"), "Theme:", selected = "theme_this", choices = c(
                "theme_grey", "theme_bw", "theme_linedraw", "theme_light",
                "theme_dark", "theme_minimal", "theme_classic", "theme_void",
                "theme_this", "theme_blank"
            )),
            numericInput(ns("alpha"), "Alpha:", value = 1, min = 0, max = 1),
            numericInput(ns("width"), "Width:", value = NA),
            textInput(ns("expand"), "Expand:", value = "", placeholder = "e.g. 1,2,3,4")
        ),
        "Line" = tagList(
            numericInput(ns("add.line"), "Add line:", value = NULL),
            colourpicker::colourInput(ns("line.colour"), "Line colour:", value = "#000000"),
            numericInput(ns("line.type"), "Line type:", value = 2, min = 0),
            numericInput(ns("line.width"), "Line width:", value = 0.6, min = 0),
            textInput(ns("line.name"), "Line name:", value = "", placeholder = "Line Name")
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
        ),
        "Axes" = tagList(
            checkboxInput(ns("axis.showline"), "Show axis lines",
                value = ifelse("axis.showline" %in% names(defaults),
                    ifelse(is.logical(defaults[["axis.showline"]]), defaults[["axis.showline"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("axis.mirror"), "Mirror axis lines",
                value = ifelse("axis.mirror" %in% names(defaults),
                    ifelse(is.logical(defaults[["axis.mirror"]]), defaults[["axis.mirror"]], TRUE),
                    TRUE
                )
            ),
            colourInput(ns("axis.linecolor"), "Axis line color",
                value = ifelse("axis.linecolor" %in% names(defaults),
                    defaults[["axis.linecolor"]], "black"
                )
            ),
            numericInput(ns("axis.linewidth"), "Axis line width",
                value = ifelse("axis.linewidth" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.linewidth"]]), defaults[["axis.linewidth"]], 0.5),
                    0.5
                ),
                min = 0,
                step = 0.1
            ),
            numericInput(ns("axis.tickfont.size"), "Tick label size",
                value = ifelse("axis.tickfont.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickfont.size"]]), defaults[["axis.tickfont.size"]], 12),
                    12
                ),
                min = 1,
                step = 1
            ),
            colourInput(ns("axis.tickfont.color"), "Tick label color",
                value = ifelse("axis.tickfont.color" %in% names(defaults),
                    defaults[["axis.tickfont.color"]], "black"
                )
            ),
            selectInput(ns("axis.tickfont.family"), "Tick label font",
                choices = c(
                    "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif",
                    "Droid Sans Mono", "Gravitas One", "Old Standard TT", "Open Sans",
                    "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman",
                    "Verdana", "sans-serif", "serif", "monospace"
                ),
                selected = ifelse("axis.tickfont.family" %in% names(defaults),
                    ifelse(defaults[["axis.tickfont.family"]] %in% c(
                        "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif",
                        "Droid Sans Mono", "Gravitas One", "Old Standard TT", "Open Sans",
                        "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman",
                        "Verdana", "sans-serif", "serif", "monospace"
                    ), defaults[["axis.tickfont.family"]], "Arial"),
                    "Arial"
                )
            ),
            numericInput(ns("axis.tickangle.x"), "X-axis tick label angle",
                value = ifelse("axis.tickangle.x" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickangle.x"]]), defaults[["axis.tickangle.x"]], 0),
                    0
                ),
                min = -180,
                max = 180,
                step = 15
            ),
            numericInput(ns("axis.tickangle.y"), "Y-axis tick label angle",
                value = ifelse("axis.tickangle.y" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickangle.y"]]), defaults[["axis.tickangle.y"]], 0),
                    0
                ),
                min = -180,
                max = 180,
                step = 15
            ),
            selectInput(ns("axis.ticks"), "Tick position",
                choices = c("Outside" = "outside", "Inside" = "inside", "None" = ""),
                selected = ifelse("axis.ticks" %in% names(defaults),
                    ifelse(defaults[["axis.ticks"]] %in% c("outside", "inside", ""),
                        defaults[["axis.ticks"]], "outside"
                    ),
                    "outside"
                )
            ),
            colourInput(ns("axis.tickcolor"), "Tick mark color",
                value = ifelse("axis.tickcolor" %in% names(defaults),
                    defaults[["axis.tickcolor"]], "black"
                )
            ),
            numericInput(ns("axis.ticklen"), "Tick mark length",
                value = ifelse("axis.ticklen" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.ticklen"]]), defaults[["axis.ticklen"]], 5),
                    5
                ),
                min = 0,
                step = 1
            ),
            numericInput(ns("axis.tickwidth"), "Tick mark width",
                value = ifelse("axis.tickwidth" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickwidth"]]), defaults[["axis.tickwidth"]], 1),
                    1
                ),
                min = 0,
                step = 0.1
            )
        )
    )

    organize_inputs(
        inputs,
        id = ns("barPlotTabsetPanel"),
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


#' Output UI components for the barPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the barPlot
#'
#' @importFrom shiny NS
#' @importFrom plotly plotlyOutput
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
barPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("barPlot"), width = "100%", height = "400px"),
        options = list(
            minWidth = 300,
            minHeight = 300,
            maxWidth = 1200,
            maxHeight = 800
        )
    )
}
