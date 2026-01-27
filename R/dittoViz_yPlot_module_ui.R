#' Input UI components for the yPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `dittoViz_yPlotServer()` and `dittoViz_yPlotOutputUI()` functions.
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
#' @importFrom shinyWidgets materialSwitch
#'
#' @export
#' @author Jared Andrews, Jacob Martin
#' @seealso [dittoViz::yPlot()], [VizModules::organize_inputs()],
#' [VizModules::dittoViz_yPlotOutputUI()], [VizModules::dittoViz_yPlotServer()], [VizModules::dittoViz_yPlotApp()]
#' @examples
#' library(VizModules)
#' data(mtcars)
#' dittoViz_yPlotInputsUI("yPlot", mtcars)
dittoViz_yPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    cat.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])
    numeric.data <- data[, vapply(data, is.numeric, logical(1)), drop = FALSE]
    max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11 # Y axis scale factor
    min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("var"), "Y data (var)", choices = num.choices, selected = num.choices[2]),
            selectInput(ns("group.by"), "Group by", selected = cat.choices[2], choices = cat.choices),
            selectInput(ns("color.by"), "Color by", selected = "", choices = c("", cat.choices)),
            selectInput(ns("shape.by"), "Shape by", selected = "", choices = c("", cat.choices)),
            uiOutput(ns("palette.selection"))
        ),
        "Plot Type" = tagList(
            selectInput(
                ns("plots"),
                "Plots to show:",
                choices = c("Violin" = "vlnplot", "Box" = "boxplot", "Jitter" = "jitter", "Ridge" = "ridgeplot"),
                selected = c("boxplot", "jitter"), multiple = TRUE
            ),
            helpText("Order not currently respected")
        ),
        "Adjustments" = tagList(
            numericInput(ns("y.max"), "Y Axis Max", value = max.y, min = -1000, max = 1000),
            numericInput(ns("y.min"), "Y Axis Min", value = min.y, min = -1000, max = 1000),
            materialSwitch(ns("do.raster"), "Rasterize Jitter", value = FALSE, status = "success"),
            numericInput(ns("raster.dpi"), "Raster DPI", value = 600, min = 100, max = 1200)
        ),
        "Jitter" = tagList(
            numericInput(ns("jitter.size"), "Jitter Point Size", max = 10, min = 0.1, value = 1),
            numericInput(ns("jitter.width"), "Jitter Width", min = 0, max = 1, value = 0.2, step = 0.05),
            colourpicker::colourInput(ns("jitter.color"), "Jitter Point Color", value = "#000000"),
            numericInput(ns("jitter.shape.legend.size"), "Shape Legend Size",
                value = 5, min = 0, max = 20),
            materialSwitch(ns("jitter.shape.legend.show"), "Show Shape Legend",
                value = TRUE, status = "success")
        ),
        "Box" = tagList(
            colourpicker::colourInput(ns("boxplot.color"), "Boxplot Color", value = "#000000"),
            materialSwitch(ns("boxplot.show.outliers"), "Show Outliers",
                value = FALSE, status = "success"),
            numericInput(ns("boxplot.outlier.size"), "Outlier Size", value = 1.5, min = 0, max = 10),
            materialSwitch(ns("boxplot.fill"), "Fill Boxplot", value = TRUE, status = "success"),
            numericInput(ns("boxplot.lineweight"), "Boxplot Line Weight", value = 0.5, min = 0, max = 5, step = 0.1),
            numericInput(ns("boxgap"), "Boxplot Position Dodge", value = 0.3, min = 0, max = 1, step = 0.05),
            numericInput(ns("boxgroupgap"), "Boxplot Group Dodge", value = 0.2, min = 0, max = 1, step = 0.05)
        ),
        "Violin" = tagList(
            numericInput(ns("vlnplot.lineweight"), "Violin Line Weight", value = 0.5, min = 0, max = 5, step = 0.1),
            selectInput(ns("vlnplot.scaling"), "Violin Scaling",
                selected = "area",
                choices = c("area", "count", "width")),
            textInput(ns("vlnplot.quantiles"), "Violin Quantiles (0-1)",
                value = "", placeholder = "e.g., 0.25, 0.5, 0.75")
        ),
        "Ridge" = tagList(
            numericInput(ns("ridgeplot.lineweight"), "Ridge Line Weight", value = 0.5, min = 0, max = 5, step = 0.1),
            numericInput(ns("ridgeplot.scale"), "Ridge Scale (overlap)", value = 1.25, min = 0.5, max = 3),
            numericInput(ns("ridgeplot.ymax.expansion"), "Ridge Y-max Expansion",
                value = NA, min = 0, max = 1),
            selectInput(ns("ridgeplot.shape"), "Ridge Shape",
                selected = "smooth",
                choices = c("smooth", "hist")),
            numericInput(ns("ridgeplot.bins"), "Ridge Bins",
                value = 30, min = 5, max = 100),
            numericInput(ns("ridgeplot.binwidth"), "Ridge Binwidth",
                value = NULL, min = 0)
        ),
        "Facet" = tagList(
            selectInput(ns("split.by"), "Split by (facet)", selected = "", choices = c("", cat.choices)),
            selectInput(ns("split.adjust"), "Facet Scaling", selected = "free", choices = c("fixed", "free", "free_y", "free_x")),
            selectInput(ns("split.ncol"), "Number of Columns", selected = 4, choices = c("", 1:10)),
            selectInput(ns("split.nrow"), "Number of Rows", selected = 4, choices = c("", 1:10))
        ),
        "Axes" = tagList(
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
            ),
            colourpicker::colourInput(ns("text.colour"), "Axis Title Colour", value = "#000000")
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
        id = ns("yPlotTabsetPanel"),
        title = title,
        tack = tagList(
            fluidRow(
                column(3, materialSwitch(ns("auto.update"), "Auto Update",
                    value = FALSE, status = "success"),
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
#' @import plotly
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
dittoViz_yPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("yPlot"))
    )
}
