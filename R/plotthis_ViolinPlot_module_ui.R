#' Input UI components for the ViolinPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `plotthis_ViolinPlotServer()` and `plotthis_ViolinPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::ViolinPlot()] can be set via these inputs, so see the help
#' for that function for an exhaustive list.
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
#' @author Jacob Martin, Jared Andrews
#' @seealso [plotthis::ViolinPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_ViolinPlotOutputUI()], [VizModules::plotthis_ViolinPlotServer()], [VizModules::plotthis_ViolinPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' plotthis_ViolinPlotInputsUI("ViolinPlot", mtcars)
plotthis_ViolinPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11 # Y axis scale factor ( Allows the top of the graph to not reach the top of the axes)
    min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)


    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "X Data", choices = char.choices, selected = char.choices[2]),
            selectInput(ns("y.data"), "Y Data", choices = num.choices, selected = num.choices[2]),
            selectInput(ns("group.by"), "Group By", selected = "", choices = c("", char.choices)),
            uiOutput(ns("palette.selection"))
        ),
        "Adjustments" = tagList(
            shiny::selectInput(ns("sort_x"), "Sort X By", c(
                "none", "mean_asc", "mean_desc", "mean", "median_asc",
                "median_desc", "median"
            ), selected = "none"),
            numericInput(ns("y.max"), "Y Max", value = max.y),
            numericInput(ns("y.min"), "Y Min", value = min.y),
            materialSwitch(ns("add.points"), "Add Jitter Points", value = FALSE, status = "success"),
            numericInput(ns("pt.size"), "Point Size", max = 100, min = 0.1, value = 1),
            numericInput(ns("pt.alpha"), "Point Alpha", min = 0, max = 1, value = 1),
            numericInput(ns("jitter.width"), "Jitter Width", min = 0, max = 1, value = 0.5),
            numericInput(ns("jitter.height"), "Jitter Height", min = 0, max = 1, value = 0),
            colourpicker::colourInput(ns("pt.color"), "Point Outline Colour", value = "#000000"),
            materialSwitch(ns("add.box"), "Add Box", value = FALSE, status = "success"),
            colourpicker::colourInput(ns("box.color"), "Box Colour", value = "#000000"),
            numericInput(ns("box.width"), "Box Width", min = 0, max = 1, value = 0.1),
            numericInput(ns("box.ptsize"), "Box Point Size", min = 0, max = 10, value = 2.5)
        ),
        "Highlight" = tagList(
            textInput(ns("highlight"), "Highlight", value = "", placeholder = "E.g. y > 0"),
            colourpicker::colourInput(ns("highlight.colour"), "Highlight Colour", value = "#000000"),
            numericInput(ns("highlight.size"), "Highlight Size", value = 1, min = 0),
            numericInput(ns("highlight.alpha"), "Highlight Alpha", value = 1, min = 0, max = 1)
        ),
        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet By", selected = "", choices = c(char.choices, "")),
            selectInput(ns("facet.scale"), "Facet Scale", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Columns", value = NULL, min = 0),
            numericInput(ns("facet.nrow"), "Rows", value = NULL, min = 0),
            materialSwitch(ns("facet.by.row"), "Facet By Row", value = TRUE, status = "success")
        ),
        "Axes" = tagList(
            colourpicker::colourInput(ns("text.colour"), "Axis Title Colour", value = "#000000"),
            materialSwitch(ns("flip"), "Flip Horizontal", value = FALSE, status = "success"),
            selectInput(ns("font.type"), "Font Type", selected = "Arial", choices = c(
                            "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono", "Gravitas One",
                            "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman", "Verdana",
                            "sans-serif", "serif", "monospace"
            )),
            checkboxInput(ns("axis.showline"), "Show Axis Lines",
                value = ifelse("axis.showline" %in% names(defaults),
                    ifelse(is.logical(defaults[["axis.showline"]]), defaults[["axis.showline"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("axis.mirror"), "Mirror Axis Lines",
                value = ifelse("axis.mirror" %in% names(defaults),
                    ifelse(is.logical(defaults[["axis.mirror"]]), defaults[["axis.mirror"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("show.major.grid.x"), "Show X Gridlines",
                value = ifelse("show.major.grid.x" %in% names(defaults),
                    ifelse(is.logical(defaults[["show.major.grid.x"]]), defaults[["show.major.grid.x"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("show.major.grid.y"), "Show Y Gridlines",
                value = ifelse("show.major.grid.y" %in% names(defaults),
                    ifelse(is.logical(defaults[["show.major.grid.y"]]), defaults[["show.major.grid.y"]], TRUE),
                    TRUE
                )
            ),
            colourInput(ns("axis.linecolor"), "Axis Line Color",
                value = ifelse("axis.linecolor" %in% names(defaults),
                    defaults[["axis.linecolor"]], "black"
                )
            ),
            numericInput(ns("axis.linewidth"), "Axis Line Width",
                value = ifelse("axis.linewidth" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.linewidth"]]), defaults[["axis.linewidth"]], 0.5),
                    0.5
                ),
                min = 0,
                step = 0.1
            ),
            numericInput(ns("axis.tickfont.size"), "Tick Label Size",
                value = ifelse("axis.tickfont.size" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickfont.size"]]), defaults[["axis.tickfont.size"]], 12),
                    12
                ),
                min = 1,
                step = 1
            ),
            colourInput(ns("axis.tickfont.color"), "Tick Label Color",
                value = ifelse("axis.tickfont.color" %in% names(defaults),
                    defaults[["axis.tickfont.color"]], "black"
                )
            ),
            selectInput(ns("axis.tickfont.family"), "Tick Label Font",
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
            numericInput(ns("axis.tickangle.x"), "X-axis Tick Label Angle",
                value = ifelse("axis.tickangle.x" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickangle.x"]]), defaults[["axis.tickangle.x"]], 0),
                    0
                ),
                min = -180,
                max = 180,
                step = 15
            ),
            numericInput(ns("axis.tickangle.y"), "Y-axis Tick Label Angle",
                value = ifelse("axis.tickangle.y" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickangle.y"]]), defaults[["axis.tickangle.y"]], 0),
                    0
                ),
                min = -180,
                max = 180,
                step = 15
            ),
            selectInput(ns("axis.ticks"), "Tick Position",
                choices = c("Outside" = "outside", "Inside" = "inside", "None" = ""),
                selected = ifelse("axis.ticks" %in% names(defaults),
                    ifelse(defaults[["axis.ticks"]] %in% c("outside", "inside", ""),
                        defaults[["axis.ticks"]], "outside"
                    ),
                    "outside"
                )
            ),
            colourInput(ns("axis.tickcolor"), "Tick Mark Color",
                value = ifelse("axis.tickcolor" %in% names(defaults),
                    defaults[["axis.tickcolor"]], "black"
                )
            ),
            numericInput(ns("axis.ticklen"), "Tick Mark Length",
                value = ifelse("axis.ticklen" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.ticklen"]]), defaults[["axis.ticklen"]], 5),
                    5
                ),
                min = 0,
                step = 1
            ),
            numericInput(ns("axis.tickwidth"), "Tick Mark Width",
                value = ifelse("axis.tickwidth" %in% names(defaults),
                    ifelse(is.numeric(defaults[["axis.tickwidth"]]), defaults[["axis.tickwidth"]], 1),
                    1
                ),
                min = 0,
                step = 0.1
            )
        ),
        "Lines" = tagList(
            textInput(ns("hline.intercepts"), "Y-intercepts",
                value = ifelse("hline.intercepts" %in% names(defaults), defaults[["hline.intercepts"]], "")
            ),
            textInput(ns("hline.colors"), "Colors",
                value = ifelse("hline.colors" %in% names(defaults), defaults[["hline.colors"]], "#000000")
            ),
            textInput(ns("hline.widths"), "Widths",
                value = ifelse("hline.widths" %in% names(defaults), defaults[["hline.widths"]], "1")
            ),
            textInput(ns("hline.linetypes"), "Line types",
                placeholder = "solid, dashed, dotted, ...",
                value = ifelse("hline.linetypes" %in% names(defaults), defaults[["hline.linetypes"]], "dashed")
            ),
            textInput(ns("hline.opacities"), "Opacities (0-1)",
                value = ifelse("hline.opacities" %in% names(defaults), defaults[["hline.opacities"]], "1")
            ),
            hr(),
            textInput(ns("vline.intercepts"), "X-intercepts",
                value = ifelse("vline.intercepts" %in% names(defaults), defaults[["vline.intercepts"]], "")
            ),
            textInput(ns("vline.colors"), "Colors",
                value = ifelse("vline.colors" %in% names(defaults), defaults[["vline.colors"]], "#000000")
            ),
            textInput(ns("vline.widths"), "Widths",
                value = ifelse("vline.widths" %in% names(defaults), defaults[["vline.widths"]], "1")
            ),
            textInput(ns("vline.linetypes"), "Line types",
                placeholder = "solid, dashed, dotted, ...",
                value = ifelse("vline.linetypes" %in% names(defaults), defaults[["vline.linetypes"]], "dashed")
            ),
            textInput(ns("vline.opacities"), "Opacities (0-1)",
                value = ifelse("vline.opacities" %in% names(defaults), defaults[["vline.opacities"]], "1")
            ),
            hr(),
            textInput(ns("abline.slopes"), "Slopes",
                value = ifelse("abline.slopes" %in% names(defaults), defaults[["abline.slopes"]], "")
            ),
            textInput(ns("abline.intercepts"), "Y-intercepts",
                value = ifelse("abline.intercepts" %in% names(defaults), defaults[["abline.intercepts"]], "")
            ),
            textInput(ns("abline.colors"), "Colors",
                value = ifelse("abline.colors" %in% names(defaults), defaults[["abline.colors"]], "#000000")
            ),
            textInput(ns("abline.widths"), "Widths",
                value = ifelse("abline.widths" %in% names(defaults), defaults[["abline.widths"]], "1")
            ),
            textInput(ns("abline.linetypes"), "Line types",
                placeholder = "solid, dashed, dotted, ...",
                value = ifelse("abline.linetypes" %in% names(defaults), defaults[["abline.linetypes"]], "dashed")
            ),
            textInput(ns("abline.opacities"), "Opacities (0-1)",
                value = ifelse("abline.opacities" %in% names(defaults), defaults[["abline.opacities"]], "1")
            )
        )
    )

    organize_inputs(
        inputs,
        id = ns("ViolinPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the ViolinPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the ViolinPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_ViolinPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("ViolinPlot"))
    )
}
