#' Input UI components for the DimPlot module
#'
#' This should be placed in the UI where the inputs should be shown, with an `id`
#' that matches the `id` used in the `DimPlotServer()` and `DimPlotOutputUI()` functions.
#'
#' @details The user inputs for this module are separated from the outputs to allow for
#' more flexible UI design.
#'
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid.
#'
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::DimPlot()] can be set via these inputs, so see the help
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
#' @import shiny
#' @importFrom shinyWidgets switchInput
#'
#' @export
#' @author Jared Andrews
#' @seealso [plotthis::DimPlot()], [vizModules::organize_inputs()],
#' [vizModules::DimPlotOutputUI()], [vizModules::DimPlotServer()], [vizModules::DimPlotApp()]
#' @examples
#' library(vizModules)
#' # Create example data with dimension reduction coordinates
#' set.seed(123)
#' df <- data.frame(
#'     dim1 = rnorm(100),
#'     dim2 = rnorm(100),
#'     cluster = sample(c("A", "B", "C"), 100, replace = TRUE),
#'     celltype = sample(c("Type1", "Type2"), 100, replace = TRUE)
#' )
#' DimPlotInputsUI("dimPlot", df)
DimPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, function(x) !is.numeric(x)), use.names = FALSE)])

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("dim1"), "Dimension 1 (X):", selected = num.choices[2], choices = num.choices),
            selectInput(ns("dim2"), "Dimension 2 (Y):", selected = num.choices[3], choices = num.choices),
            selectInput(ns("group.by"), "Group by:", selected = char.choices[2], choices = char.choices),
            selectInput(ns("split.by"), "Split by:", selected = "", choices = c("", char.choices))
        ),

        "Points" = tagList(
            numericInput(ns("pt.size"), "Point size:", value = 1, min = 0.1, max = 10, step = 0.1),
            numericInput(ns("pt.alpha"), "Point alpha:", value = 1, min = 0, max = 1, step = 0.05),
            colourpicker::colourInput(ns("bg.color"), "Background color:", value = "grey80")
        ),

        "Labels" = tagList(
            switchInput(ns("label"), "Show labels:", value = FALSE, offLabel = "Off", onLabel = "On"),
            switchInput(ns("label.insitu"), "In situ labels:", value = FALSE, offLabel = "Off", onLabel = "On"),
            numericInput(ns("label.size"), "Label size:", value = 4, min = 1, max = 20),
            colourpicker::colourInput(ns("label.fg"), "Label foreground:", value = "white"),
            colourpicker::colourInput(ns("label.bg"), "Label background:", value = "black"),
            numericInput(ns("label.bg.r"), "Label background radius:", value = 0.1, min = 0, max = 1, step = 0.05),
            switchInput(ns("label.repel"), "Repel labels:", value = FALSE, offLabel = "Off", onLabel = "On"),
            numericInput(ns("label.repulsion"), "Label repulsion:", value = 20, min = 1, max = 100),
            numericInput(ns("label.pt.size"), "Label point size:", value = 1, min = 0, max = 10, step = 0.5),
            colourpicker::colourInput(ns("label.pt.color"), "Label point color:", value = "black"),
            colourpicker::colourInput(ns("label.segment.color"), "Label segment color:", value = "black")
        ),

        "Marks & Highlights" = tagList(
            switchInput(ns("add.mark"), "Add marks:", value = FALSE, offLabel = "Off", onLabel = "On"),
            selectInput(ns("mark.type"), "Mark type:", selected = "hull", 
                choices = c("hull", "ellipse", "rect", "circle")),
            numericInput(ns("mark.alpha"), "Mark alpha:", value = 0.1, min = 0, max = 1, step = 0.05),
            numericInput(ns("mark.linetype"), "Mark line type:", value = 1, min = 0, max = 6, step = 1),
            textInput(ns("highlight"), "Highlight groups:", value = "", 
                placeholder = "e.g., group1, group2"),
            numericInput(ns("highlight.alpha"), "Highlight alpha:", value = 1, min = 0, max = 1, step = 0.05),
            numericInput(ns("highlight.size"), "Highlight size:", value = 1, min = 0, max = 10, step = 0.5),
            colourpicker::colourInput(ns("highlight.color"), "Highlight color:", value = "black"),
            numericInput(ns("highlight.stroke"), "Highlight stroke:", value = 0.8, min = 0, max = 5, step = 0.1)
        ),

        "Order & Stats" = tagList(
            selectInput(ns("order"), "Point order:", selected = "as-is",
                choices = c("as-is", "reverse", "high-top", "low-top", "random")),
            switchInput(ns("show.stat"), "Show stats:", value = FALSE, offLabel = "Off", onLabel = "On"),
            selectInput(ns("stat.by"), "Stat variable:", selected = "", choices = c("", names(data))),
            selectInput(ns("stat.plot.type"), "Stat plot type:", selected = "pie",
                choices = c("pie", "ring", "bar", "line")),
            numericInput(ns("stat.plot.size"), "Stat plot size:", value = 0.1, min = 0, max = 1, step = 0.05)
        ),

        "Density" = tagList(
            switchInput(ns("add.density"), "Add density:", value = FALSE, offLabel = "Off", onLabel = "On"),
            colourpicker::colourInput(ns("density.color"), "Density color:", value = "grey80"),
            switchInput(ns("density.filled"), "Filled density:", value = FALSE, offLabel = "Off", onLabel = "On")
        ),

        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by:", selected = "", choices = c("", char.choices)),
            selectInput(ns("facet.scales"), "Facet scales:", selected = "fixed", 
                choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.nrow"), "Facet rows:", value = NULL, min = 1, max = 20),
            numericInput(ns("facet.ncol"), "Facet columns:", value = NULL, min = 1, max = 20),
            switchInput(ns("facet.byrow"), "Facet by row:", value = TRUE, offLabel = "Off", onLabel = "On")
        ),

        "Aesthetics" = tagList(
            uiOutput(ns("palette.selection")),
            selectInput(ns("theme"), "Theme:", selected = "theme_this", choices = c(
                "theme_grey", "theme_bw", "theme_linedraw", "theme_light",
                "theme_dark", "theme_minimal", "theme_classic", "theme_void",
                "theme_this", "theme_blank"
            )),
            numericInput(ns("aspect.ratio"), "Aspect ratio:", value = 1, min = 0.1, max = 5, step = 0.1),
            selectInput(ns("legend.position"), "Legend position:", selected = "right",
                choices = c("right", "left", "top", "bottom", "none")),
            selectInput(ns("legend.direction"), "Legend direction:", selected = "vertical",
                choices = c("vertical", "horizontal"))
        ),

        "Titles" = tagList(
            textInput(ns("title"), "Plot title:", value = "", placeholder = "Enter title"),
            textInput(ns("subtitle"), "Plot subtitle:", value = "", placeholder = "Enter subtitle"),
            textInput(ns("xlab"), "X-axis label:", value = "", placeholder = "X label"),
            textInput(ns("ylab"), "Y-axis label:", value = "", placeholder = "Y label")
        ),

        "Axes" = tagList(
            selectInput(ns("font.type"), "Font:", selected = "Arial", choices = c(
                "Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif",
                "Droid Sans Mono", "Gravitas One", "Old Standard TT", "Open Sans",
                "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman",
                "Verdana", "sans-serif", "serif", "monospace"
            )),
            numericInput(ns("axis.font.size"), "Axis font size", value = 18, min = 1),
            numericInput(ns("title.font.size"), "Title font size", value = 28, min = 1),
            colourpicker::colourInput(ns("text.colour"), "Text colour:", value = "#000000"),
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
        id = ns("DimPlotTabsetPanel"),
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


#' Output UI components for the DimPlot module
#'
#' This should be placed in the UI where the plot should be shown.
#'
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the DimPlot
#'
#' @import shiny
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jared Andrews
DimPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("DimPlot"))
    )
}
