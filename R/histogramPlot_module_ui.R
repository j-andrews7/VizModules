#' Histogram Plot Input UI Module
#'
#' @description
#' Generates the user interface for histogram configuration, including data selection,
#' faceting options, aesthetic controls (bins, trend lines, alpha), and detailed axis styling.
#'
#' @param id \code{character} unique ID for the shiny namespace.
#' @param data \code{data.frame} The dataset used to populate column selection choices.
#' @param defaults \code{list} Optional named list of default values for the inputs.
#' @param title \code{character} Optional title for the input panel.
#' @param columns \code{numeric} Number of columns to organize the inputs into. Default is 2.
#'
#' @return A \code{tagList} containing the organized UI elements.
#'
#' @author Jacob Martin
#' 
#' @import shiny
#' @importFrom shinyWidgets switchInput
#' @importFrom colourpicker colourInput
#' @export
histogramPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)


    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "X input:", selected = names(data)[1], choices = names(data)),
            selectInput(ns("group.by"), "Group by:", selected = "", choices = c("", char.choices)),
            textInput(ns("group.by.name"), "Group by legend name", value = "")
        ),

        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by:", selected = "", choices = c("", char.choices)),
            selectInput(ns("facet.scale"), "Facet scale:", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Facet number of columns:", value = NULL, min = 0, max = 20),
            numericInput(ns("facet.nrow"), "Facet number of rows:", value = NULL, min = 0, max = 20),
            switchInput(ns("facet.by.row"), "Facet by row:", value = TRUE, offLabel = "Off", onLabel = "On"),
            selectInput(ns("split.by"), "Split by:", selected = "", choices = c("", char.choices))
        ),

        "Aesthetics" = tagList(
            numericInput(ns("bins"), "Number of bins:", value = NA, min = 0),
            numericInput(ns("bin.width"), "Bin width:", value = NA, min = 0),
            switchInput(ns("use.trend"), "Trend line only", value = FALSE),
            switchInput(ns("trend.skip.zero"), "Skip zero values", value = FALSE),
            switchInput(ns("add.trend"), "Add trend to histogram", value = FALSE),
            sliderInput(ns("trend.alpha"), "Trend line alpha", min = 0, max = 1, value = 1),
            numericInput(ns("trend.linewidth"), "Trend line width:", value = 0.8, min = 0),
            numericInput(ns("trend.pt.size"), "Trend point size:", value = 1.5),
            sliderInput(ns("plot.alpha"), "Plot alpha", min = 0, max = 1, value = 1),
            selectInput(ns("theme"), "Plot theme:", selected = "theme_this",
            choices = c(
                "theme_grey", "theme_bw", "theme_linedraw", "theme_light",
                "theme_dark", "theme_minimal", "theme_classic", "theme_void",
                "theme_this", "theme_blank"
            )
            ),
            uiOutput(ns("palette.selection")),
            selectInput(ns("position"), "Postion:", selected = "identity",
            choices = c("identity", "stack", "dodge", "fill")
            )
        ),

        "Extras" = tagList(
            switchInput(ns("add.bars"), "Add rug plot", value = FALSE),
            numericInput(ns("bar.height"), "Rug bar height:", value = 0.05),
            sliderInput(ns("bar.alpha"), "Rug bar alpha", min = 0, max = 1, value = 1),
            numericInput(ns("bar.width"), "Rug bar width:", value = 1)
        ),


        "Axes" = tagList(
            switchInput(ns("flip"), "Flip the plot: ", value = FALSE, onLabel = "Flipped", offLabel = "Not Flipped"),
            selectInput(ns("font.type"), "Font type:", selected = "Arial", choices = c(
                            "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono", "Gravitas One",
                            "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman", "Verdana",
                            "sans-serif", "serif", "monospace"
            )),
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
            checkboxInput(ns("show.major.grid.x"), "Show X major gridlines",
                value = ifelse("show.major.grid.x" %in% names(defaults),
                    ifelse(is.logical(defaults[["show.major.grid.x"]]), defaults[["show.major.grid.x"]], TRUE),
                    TRUE
                )
            ),
            checkboxInput(ns("show.major.grid.y"), "Show Y major gridlines",
                value = ifelse("show.major.grid.y" %in% names(defaults),
                    ifelse(is.logical(defaults[["show.major.grid.y"]]), defaults[["show.major.grid.y"]], TRUE),
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
        ),
        "Lines" = tagList(
            textInput(ns("hline.intercepts"), "Y-intercepts (comma-separated)",
                value = ifelse("hline.intercepts" %in% names(defaults), defaults[["hline.intercepts"]], "")
            ),
            textInput(ns("hline.colors"), "Colors (comma-separated)",
                value = ifelse("hline.colors" %in% names(defaults), defaults[["hline.colors"]], "#000000")
            ),
            textInput(ns("hline.widths"), "Widths (comma-separated)",
                value = ifelse("hline.widths" %in% names(defaults), defaults[["hline.widths"]], "1")
            ),
            selectInput(ns("hline.linetypes"), "Line type",
                choices = c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash"),
                selected = ifelse("hline.linetypes" %in% names(defaults), defaults[["hline.linetypes"]], "dashed")
            ),
            textInput(ns("hline.opacities"), "Opacities (comma-separated, 0-1)",
                value = ifelse("hline.opacities" %in% names(defaults), defaults[["hline.opacities"]], "1")
            ),
            hr(),
            textInput(ns("vline.intercepts"), "X-intercepts (comma-separated)",
                value = ifelse("vline.intercepts" %in% names(defaults), defaults[["vline.intercepts"]], "")
            ),
            textInput(ns("vline.colors"), "Colors (comma-separated)",
                value = ifelse("vline.colors" %in% names(defaults), defaults[["vline.colors"]], "#000000")
            ),
            textInput(ns("vline.widths"), "Widths (comma-separated)",
                value = ifelse("vline.widths" %in% names(defaults), defaults[["vline.widths"]], "1")
            ),
            selectInput(ns("vline.linetypes"), "Line type",
                choices = c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash"),
                selected = ifelse("vline.linetypes" %in% names(defaults), defaults[["vline.linetypes"]], "dashed")
            ),
            textInput(ns("vline.opacities"), "Opacities (comma-separated, 0-1)",
                value = ifelse("vline.opacities" %in% names(defaults), defaults[["vline.opacities"]], "1")
            ),
            hr(),
            textInput(ns("abline.slopes"), "Slopes (comma-separated)",
                value = ifelse("abline.slopes" %in% names(defaults), defaults[["abline.slopes"]], "")
            ),
            textInput(ns("abline.intercepts"), "Y-intercepts (comma-separated)",
                value = ifelse("abline.intercepts" %in% names(defaults), defaults[["abline.intercepts"]], "")
            ),
            textInput(ns("abline.colors"), "Colors (comma-separated)",
                value = ifelse("abline.colors" %in% names(defaults), defaults[["abline.colors"]], "#000000")
            ),
            textInput(ns("abline.widths"), "Widths (comma-separated)",
                value = ifelse("abline.widths" %in% names(defaults), defaults[["abline.widths"]], "1")
            ),
            selectInput(ns("abline.linetypes"), "Line type",
                choices = c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash"),
                selected = ifelse("abline.linetypes" %in% names(defaults), defaults[["abline.linetypes"]], "dashed")
            ),
            textInput(ns("abline.opacities"), "Opacities (comma-separated, 0-1)",
                value = ifelse("abline.opacities" %in% names(defaults), defaults[["abline.opacities"]], "1")
            )
        )
    )

    organize_inputs(
        inputs,
        id = ns("histogramPlotTabsetPanel"),
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


#' Output UI components for the histogramPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the histogramPlot
#'
#' @import shiny
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
histogramPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("histogramPlot"))
    )
}
