#' Density Plot Input UI Module
#'
#' @description
#' Generates the user interface for density plot configuration, including data selection,
#' faceting options, aesthetic controls (alpha, position), and detailed axis styling.
#'
#' @param id \code{character} unique ID for the shiny namespace.
#' @param data \code{data.frame} The dataset used to populate column selection choices.
#' @param defaults \code{list} Optional named list of default values for the inputs.
#' @param title \code{character} Optional title for the input panel.
#' @param columns \code{numeric} Number of columns to organize the inputs into. Default is 2.
#'
#' @return A \code{tagList} containing the organized UI elements.
#'
#' @author Jacob Martin, Jared Andrews
#' 
#' @import shiny
#' @importFrom shinyWidgets materialSwitch
#' @importFrom colourpicker colourInput
#' @export
plotthis_DensityPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "X Data", selected = ifelse("x.data" %in% names(defaults) && defaults[["x.data"]] %in% num.choices,
                    defaults[["x.data"]], num.choices[2]
                ),
                choices = num.choices),
            selectInput(ns("group.by"), "Group By", selected = "", choices = c("", cat.choices))
        ),
        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet By", selected = "", choices = c("", cat.choices)),
            selectInput(ns("facet.scale"), "Facet Scale", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Number of Columns", value = NULL, min = 0, max = 20),
            numericInput(ns("facet.nrow"), "Number of Rows", value = NULL, min = 0, max = 20),
            materialSwitch(ns("facet.by.row"), "Facet by Row", value = TRUE, status = "success")
        ),
        "Aesthetics" = tagList(
            numericInput(ns("plot.alpha"), "Plot Alpha", min = 0, max = 1, value = 0.5),
            selectInput(ns("theme"), "Plot Theme", selected = "theme_this",
            choices = c(
                "theme_grey", "theme_bw", "theme_linedraw", "theme_light",
                "theme_dark", "theme_minimal", "theme_classic", "theme_void",
                "theme_this", "theme_blank"
            )
            ),
            uiOutput(ns("palette.selection")),
            selectInput(ns("position"), "Position", selected = "identity",
            choices = c("identity", "stack", "dodge", "fill")
            )
        ),
        "Rug" = tagList(
            materialSwitch(ns("add.bars"), "Add Rug Plot", value = FALSE, status = "success"),
            numericInput(ns("bar.height"), "Rug Bar Height", value = 0.04),
            sliderInput(ns("bar.alpha"), "Rug Bar Alpha", min = 0, max = 1, value = 1, step = 0.05),
            numericInput(ns("bar.width"), "Rug Bar Width", value = 1, min = 0, step = 0.05)
        ),
        "Axes" = tagList(
            materialSwitch(ns("flip"), "Flip Horizontal", value = FALSE, status = "success"),
            selectInput(ns("font.type"), "Font Type", selected = "Arial", choices = c(
                            "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono", "Gravitas One",
                            "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman", "Verdana",
                            "sans-serif", "serif", "monospace"
            )),
            colourInput(ns("text.colour"), "Title Text Colour", value = "#000000"),
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
            colourInput(ns("axis.linecolor"), "Axis Line Colour",
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
            colourInput(ns("axis.tickfont.color"), "Tick Label Colour",
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
            colourInput(ns("axis.tickcolor"), "Tick Mark Colour",
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
        id = ns("densityPlotTabsetPanel"),
        title = title,
        tack = module_tack_ui(ns, defaults = defaults),
        columns = columns
    )
}


#' Output UI components for the densityPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the densityPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
plotthis_DensityPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("densityPlot"))
    )
}
