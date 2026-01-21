#' Input UI components for the yPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `yPlotServer()` and `yPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [dittoViz::yPlot()] can be set via these inputs, so see the help
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
#' @importFrom shinyWidgets switchInput
#'
#' @export
#' @author Jared Andrews
#' @seealso [dittoViz::yPlot()], [vizModules::organize_inputs()],
#' [vizModules::yPlotOutputUI()], [vizModules::yPlotServer()], [vizModules::yPlotApp()]
#' @examples
#' library(vizModules)
#' data(mtcars)
#' yPlotInputsUI("yPlot", mtcars)
yPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11 # Y axis scale factor
    min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)


    inputs <- list(
        "Data" = tagList(
            selectInput(ns("var"), "Select Y data (var):", choices = num.choices, selected = num.choices[2]),
            selectInput(ns("group.by"), "Group by:", selected = char.choices[2], choices = char.choices),
            selectInput(ns("color.by"), "Color by:", selected = "", choices = c("", char.choices)),
            selectInput(ns("shape.by"), "Shape by:", selected = "", choices = c("", char.choices)),
            uiOutput(ns("palette.selection"))
        ),
        "Plot Type" = tagList(
            checkboxGroupInput(
                ns("plots"),
                "Plot types to show:",
                choices = c("Violin" = "vlnplot", "Box" = "boxplot", "Jitter" = "jitter", "Ridge" = "ridgeplot"),
                selected = c("vlnplot", "boxplot", "jitter")
            ),
            helpText("Order matters: first selected will be in back, last in front")
        ),
        "Adjustments" = tagList(
            numericInput(ns("y.max"), "Max Value of Y Axis:", value = max.y, min = -1000, max = 1000),
            numericInput(ns("y.min"), "Min Value of Y Axis:", value = min.y, min = -1000, max = 1000),
            switchInput(ns("do.raster"), "Rasterize jitter: ", value = FALSE, onLabel = "On", offLabel = "Off"),
            numericInput(ns("raster.dpi"), "Raster DPI:", value = 300, min = 100, max = 1200)
        ),
        "Jitter" = tagList(
            numericInput(ns("jitter.size"), "Jitter Point Size:", max = 10, min = 0.1, value = 1),
            numericInput(ns("jitter.width"), "Jitter Width:", min = 0, max = 1, value = 0.2),
            colourpicker::colourInput(ns("jitter.color"), "Jitter Point Color", value = "#000000"),
            numericInput(ns("jitter.shape.legend.size"), "Shape Legend Size:",
                value = 5, min = 0, max = 20),
            switchInput(ns("jitter.shape.legend.show"), "Show Shape Legend: ",
                value = TRUE, onLabel = "Show", offLabel = "Hide"),
            numericInput(ns("jitter.position.dodge"), "Jitter Position Dodge:", value = 1, min = 0, max = 5)
        ),
        "Box" = tagList(
            numericInput(ns("boxplot.width"), "Boxplot Width:", min = 0, max = 2, value = 0.2),
            colourpicker::colourInput(ns("boxplot.color"), "Boxplot Color", value = "#000000"),
            switchInput(ns("boxplot.show.outliers"), "Show Outliers: ",
                value = FALSE, onLabel = "Show", offLabel = "Hide"),
            numericInput(ns("boxplot.outlier.size"), "Outlier Size:", value = 1.5, min = 0, max = 10),
            switchInput(ns("boxplot.fill"), "Fill Boxplot: ", value = TRUE, onLabel = "Fill", offLabel = "No Fill"),
            numericInput(ns("boxplot.position.dodge"), "Boxplot Position Dodge:", value = 1, min = 0, max = 5),
            numericInput(ns("boxplot.lineweight"), "Boxplot Line Weight:", value = 1, min = 0, max = 5)
        ),
        "Violin" = tagList(
            numericInput(ns("vlnplot.lineweight"), "Violin Line Weight:", value = 1, min = 0, max = 5),
            numericInput(ns("vlnplot.width"), "Violin Width:", value = 1, min = 0, max = 5),
            selectInput(ns("vlnplot.scaling"), "Violin Scaling:",
                selected = "area",
                choices = c("area", "count", "width")),
            textInput(ns("vlnplot.quantiles"), "Violin Quantiles (comma-separated, 0-1):",
                value = "", placeholder = "e.g., 0.25, 0.5, 0.75")
        ),
        "Ridge" = tagList(
            numericInput(ns("ridgeplot.lineweight"), "Ridge Line Weight:", value = 1, min = 0, max = 5),
            numericInput(ns("ridgeplot.scale"), "Ridge Scale (overlap):", value = 1.25, min = 0.5, max = 3),
            numericInput(ns("ridgeplot.ymax.expansion"), "Ridge Y-max Expansion:",
                value = NA, min = 0, max = 1),
            selectInput(ns("ridgeplot.shape"), "Ridge Shape:",
                selected = "smooth",
                choices = c("smooth", "hist")),
            numericInput(ns("ridgeplot.bins"), "Ridge Bins (for hist):",
                value = 30, min = 5, max = 100),
            numericInput(ns("ridgeplot.binwidth"), "Ridge Binwidth:",
                value = NULL, min = 0)
        ),
        "Extras" = tagList(
            textInput(ns("add.line"), "Add Y interception line (comma-separated):",
                value = "", placeholder = "e.g., 0, 1, 2"),
            colourpicker::colourInput(ns("line.color"), "Line Color:", value = "#000000"),
            numericInput(ns("line.linewidth"), "Line Width:",
                value = 0.5, min = 0.1, max = 10),
            selectInput(ns("line.linetype"), "Line Type:",
                selected = "dashed",
                choices = c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash")),
            numericInput(ns("line.opacity"), "Line Opacity:", value = 1, min = 0, max = 1)
        ),
        "Facet" = tagList(
            selectInput(ns("split.by"), "Split by (facet):", selected = "", choices = c("", char.choices)),
            selectInput(ns("split.adjust"), "Facet scaling: ", selected = "free", choices = c("fixed", "free", "free_y", "free_x")),
            selectInput(ns("split.ncol"), "Split number of columns:", selected = 4, choices = c("", 1:10)),
            selectInput(ns("split.nrow"), "Split number of rows:", selected = 4, choices = c("", 1:10))
        ),
        "Axes" = tagList(
            switchInput(ns("x.labels.rotate"), "Rotate X labels: ",
                value = TRUE, onLabel = "Rotate", offLabel = "Don't Rotate"),
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
            ),
            colourpicker::colourInput(ns("text.colour"), "Axis title colour:", value = "#000000")
        )
    )

    organize_inputs(
        inputs,
        id = ns("yPlotTabsetPanel"),
        title = title,
        tack = tagList(
            fluidRow(
                column(3, switchInput(ns("auto.update"), "Auto Update",
                    value = FALSE, size = "mini", onLabel = "ON", offLabel = "OFF"),
                    style = "margin-top: 25px;"),
                column(3, actionButton(ns("update"), "Update", width = "100%"),
                    style = "margin-top: 25px;"),
                column(3, actionButton(ns("reset"), "Reset", class = "btn-secondary",
                    width = "100%"), style = "margin-top: 25px;"),
                column(3, selectInput(ns("download.type"), "Download Format",
                    selected = "png", choices = c("png", "svg"), width = "100%"))
            ),
            br()
        ),
        columns = columns
    )
}


#' Output UI components for the yPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the yPlot
#'
#' @import shiny
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
yPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("yPlot"))
    )
}
