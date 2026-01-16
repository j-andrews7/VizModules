#' Input UI components for the linePlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `linePlotServer()` and `linePlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [vizModules::linePlot()] can be set via these inputs, so see the help
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
#' @author Jacob Martin, Jared Andrews
#' @seealso [vizModules::linePlot()], [vizModules::organize_inputs()],
#' [vizModules::linePlotOutputUI()], [vizModules::linePlotServer()], [vizModules::linePlotApp()]
#' @examples
#' library(vizModules)
#' data(mtcars)
#' linePlotInputsUI("linePlot", mtcars)
linePlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, unlist(lapply(data, is.numeric), use.names = FALSE), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.value"), "Select X values:", selected = names(data)[1], choices = names(data), multiple = TRUE),
            selectInput(ns("y.value"), "Select Y values:", selected = names(data)[2], choices = names(data), multiple = TRUE),
            switchInput(ns("order.by"), "Order plot by:", value = FALSE, offLabel = "x axis", onLabel = "y axis"),
            selectInput(ns("y.adjustment"), "Adjust the y axis:", selected = "", choices = c("", "log2", "log", "log10", "neg_log10", "log1p", "abs", "sqrt")),
            selectInput(ns("x.adjustment"), "Adjust the x axis:", selected = "", choices = c("", "log2", "log", "log10", "neg_log10", "log1p", "abs", "sqrt"))
        ),
        "Grouping & Facets" = tagList(
            selectInput(ns("group.by"), "Group by:", selected = cat.choices[1], choices = cat.choices),
            selectInput(ns("facet.by"), "Facet by: ", selected = "", choices = cat.choices),
            selectInput(ns("facet.scales"), "Facet scales",
                choices = c("fixed", "free", "free_x", "free_y"),
                selected = ifelse("facet.scales" %in% names(defaults),
                    ifelse(defaults[["facet.scales"]] %in% c("fixed", "free", "free_x", "free_y"),
                        defaults[["facet.scales"]], "fixed"
                    ),
                    "fixed"
                )
            ),
            switchInput(ns("flip.y"), "Flip Y axis:", value = FALSE),
            switchInput(ns("flip.x"), "Flip X axis:", value = FALSE)
        ),
        "Aesthetics" = tagList(
            selectInput(ns("palette"), "Select palette:", selected = "Paired", choices = names(plotthis::palette_list))
        ),
        "Lines" = tagList(
            selectInput(ns("plot.type"), "Plot type: ", selected = "lines", choices = c("lines", "markers", "lines+markers")),
            selectInput(ns("line.type"), "Line type:", selected = "solid", choices = c("solid", "dot", "dash", "longdash", "dashdot", "longdashdot"))
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
        id = ns("linePlotTabsetPanel"),
        title = title,
        tack = tagList(
            fluidRow(
                column(3, switchInput(ns("auto.update"), "Auto Update", value = FALSE, size = "mini", onLabel = "ON", offLabel = "OFF"), style = "margin-top: 25px;"),
                column(3, actionButton(ns("update"), "Update", width = "100%"), style = "margin-top: 25px;"),
                column(3, actionButton(ns("reset"), "Reset", class = "btn-secondary", width = "100%"), style = "margin-top: 25px;"),
                column(3, selectInput(ns("download.type"), "Download Format", selected = "png", choices = c("png", "svg"), width = "100%"))
            ),
            br()
        ),
        columns = columns
    )
}


#' Output UI components for the linePlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the linePlot
#'
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
linePlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("linePlot"))
    )
}
