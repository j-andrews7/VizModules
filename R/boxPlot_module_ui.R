#' Input UI components for the boxPlot module
#' 
#' This should be placed in the UI where the inputs should be shown, with an `id` 
#' that matches the `id` used in the `boxPlotServer()` and `boxPlotOutputUI()` functions.
#' 
#' @details The user inputs for this module are separated from the outputs to allow for 
#' more flexible UI design. 
#' 
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid. 
#' 
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [plotthis::BoxPlot()] can be set via these inputs, so see the help
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
#' @seealso [plotthis::BoxPlot()], [vizModules::organize_inputs()], 
#' [vizModules::boxPlotOutputUI()], [vizModules::boxPlotServer()], [vizModules::createBoxPlotApp()]
#' @examples
#' library(vizModules)
#' data(mtcars)
#' boxPlotInputsUI("boxPlot", mtcars)
boxPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data.
    choices <- c("", names(data))

    # Get numeric variables of data.
    num.choices  <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, is.character), use.names = FALSE)])
    numeric.data <- data[, sapply(data, is.numeric), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "Select X data:", choices = char.choices, selected = char.choices[2]),
            selectInput(ns("y.data"), "Select Y data:", choices = num.choices, selected = num.choices[2]),
            selectInput(ns("group.by"), "Group by:", selected = "NULL", choices = c(char.choices, "NULL"))
        ),
        "Adjustments" = tagList(
            shiny::selectInput(ns("sort_x"), "Sort the X axis by: ", c("none", "mean_asc", "mean_desc", "mean", "median_asc", 
                                                                "median_desc", "median"), selected = "none"),
            switchInput(ns("flip"), "Flip the Plot: ", value = FALSE, onLabel = "Flipped", offLabel = "Not Flipped"),
            switchInput(ns("stack"), "Stack Plot: ", value = FALSE, onLabel = "Stacked", offLabel = "Not Stacked"),
            numericInput(ns("y.max"), "Max Value of Y Axis:", value = max.y, min = -1000, max = 1000),
            numericInput(ns("y.min"), "Min Value of Y Axis:", value = min.y, min = -1000, max = 1000),
            numericInput(ns("aspect.ratio"), "Aspect Ratio:", value = 1, min = 0, max = 100)
        ),
        "Points" = tagList(
            switchInput(ns("add.points"), "Add Jitter Points: ", value = FALSE, onLabel = "Points", offLabel = "No Points"),
            numericInput(ns("pt.size"), "Point Size:", max = 100, min = 0.1, value = 1),
            numericInput(ns("pt.alpha"), "Point Alpha:", min = 0, max = 1, value = 1),
            numericInput(ns("jitter.width"), "Jitter Width:", min = 0, max = 1, value = 0.5),
            numericInput(ns("jitter.height"), "Jitter Height: ", min = 0, max = 1, value = 0),
            colourpicker::colourInput(ns("pt.color"), "Point outline colour", value = "#000000")
        ),
        "Annotations" = tagList(
            numericInput(ns("add.line"), "Add Y interception line:", value = NULL, min = min.y, max = max.y),
            textInput(ns("highlight"), "Highlight:", value = "", placeholder = "E.g. y > 0"),
            colourpicker::colourInput(ns("highlight.colour"), "Highlight colour:", value = "#000000"),
            numericInput(ns("highlight.size"), "Highlight size:", value = 1, min = 0),
            numericInput(ns("highlight.alpha"), "Highlight alpha", value = 1, min = 0, max = 1),
            selectInput(ns("font.type"), "Font type:", selected = "Arial", choices = c("Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono", "Gravitas One",
                                                                                "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman", "Verdana", 
                                                                                "sans-serif", "serif", "monospace")),
            colourpicker::colourInput(ns("text.colour"), "Axis title colour:", value = "#000000")
        ),
        "Trajectory" = tagList(
            switchInput(ns("add.trend"), "Add Median Point", value = FALSE, onLabel = "Trend Added", offLabel = "Trend Not Added"),
            numericInput(ns("trend.pt.size"), "Trend Point Size:", min = 0, max = 40, value = 2),
            colourpicker::colourInput(ns("trend.colour"), "Colour of trend:", value = "#000000"),
            numericInput(ns("trend.line.width"), "Trend line width:", value = 1, min = 0)
        ),
        "Stats" = tagList(
            selectInput(ns("add.stat"), "Add Stats:", selected = "mean", choices = c("mean", "sd", "median", "var")),
            colourpicker::colourInput(ns("stat.color"), "Stats Colour:", value = "#000000"),
            numericInput(ns("stat.size"), "Stat Size:", value = 1, min = 0, max = 10),
            numericInput(ns("stat.stroke"), "Stat Stroke:", value = 1, min = 0, max = 10),
            numericInput(ns("stat.shape"), "Stat Shape:", value = 25, min = 0, max = 100)
        ),
        "Palette" = tagList(
            selectInput(ns("palette"), "Plot Palette:", selected = "Paired", choices = names(plotthis::palette_list)),
            switchInput(ns("background.colour"), "Background colour:", value = FALSE, onLabel = "On", offLabel = "Off"),
            selectInput(ns("background.palette"), "Background Palette:", selected = "Paired", choices = names(plotthis::palette_list))
        ),
        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by:", selected = "NULL", choices = c(char.choices, "NULL")),
            selectInput(ns("facet.scale"), "Facet scale:", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Facet number of columns:", value = NULL, min = 0, max = 20),
            numericInput(ns("facet.nrow"), "Facet number of rows:", value = NULL, min = 0, max = 20), 
            switchInput(ns("facet.by.row"), "Facet by row:", value = TRUE, offLabel = "Off", onLabel = "On"),
            switchInput(ns("combine"), "Combine plots:", value = TRUE, offLabel = "Off", onLabel = "On")

        )
    )

    organize_inputs(
        inputs,
        id = ns("scatterPlotTabsetPanel"),
        title = title,
        tack = tagList(actionButton(ns("reset"),  "Reset Defaults", class = "btn-secondary"), 
                        selectInput(ns("download.type"), "Download Format:", selected = "png", choices = c("png", "svg")),
                        br()),
        columns = columns
    )
}



#' Output UI components for the boxPlot module
#' 
#' This should be placed in the UI where the plot should be shown.
#' 
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the boxPlot
#'
#' @importFrom shiny NS
#' @importFrom plotly plotlyOutput
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
boxPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("boxPlot"), width = "100%", height = "400px"),
        options = list( 
        minWidth = 300,
        minHeight = 300,
        maxWidth = 1200,
        maxHeight = 800)
    )
    
}
