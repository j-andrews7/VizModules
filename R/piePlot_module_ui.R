#' Input UI components for the piePlot module
#' 
#' This should be placed in the UI where the inputs should be shown, with an `id` 
#' that matches the `id` used in the `piePlotServer()` and `piePlotOutputUI()` functions.
#' 
#' @details The user inputs for this module are separated from the outputs to allow for 
#' more flexible UI design. 
#' 
#' The inputs will automatically be organized into a grid layout via the `organize_inputs()` function,
#' with `columns` controlling the number of columns in the grid. 
#' 
#' Defaults can be set for each input by providing a named list of values to the `defaults` argument.
#' Nearly all parameters for [vizModules::piePlot()] can be set via these inputs, so see the help
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
#'
#' @export
#' @author Jacob Martin
#' @seealso [vizModules::piePlot()], [vizModules::organize_inputs()], 
#' [vizModules::piePlotOutputUI()], [vizModules::piePlotServer()], [vizModules::createpiePlotApp()]
#' @examples
#' library(vizModules)
#' data(mtcars)
#' piePlotInputsUI("piePlot", mtcars)
piePlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
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
            selectInput(ns("labels"), "Select categories", selected = char.choices[2], choices = char.choices),
            selectInput(ns("values"), "Select numeric data:", selected = num.choices[2], choices = num.choices)        
        ),
        "Aesthetics" = tagList(
            numericInput(ns("make.hole"), "Make into donut plot", value = 0, min = 0, max = 1),
            selectInput(ns("palette"), "Select palette:", selected = "Paired", choices = names(plotthis::palette_list)),
            uiOutput(ns("palette.selection")),
            textInput(ns("plot.text"), "Plot labels:", value = "label+percent", placeholder = "e.g. label+percent"), 
            numericInput(ns("title.font.size"), "Title font size:", value = 28, min = 0),
            selectInput(ns("font.type"), "Font type:", selected = "Arial", choices = c("Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono", "Gravitas One",
                                                                                "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman", "Verdana", 
                                                                                "sans-serif", "serif", "monospace")),
            colourpicker::colourInput(ns("text.colour"), "Colour of title:", value = "#000000")
        )
    
    )

    organize_inputs(
        inputs,
        id = ns("piePlotTabsetPanel"),
        title = title,
        tack = tagList(actionButton(ns("reset"),  "Reset Defaults", class = "btn-secondary"), 
                        selectInput(ns("download.type"), "Download Format:", selected = "png", choices = c("png", "svg")),
                        br()),
        columns = columns
    )
}



#' Output UI components for the piePlot module
#' 
#' This should be placed in the UI where the plot should be shown.
#' 
#' @param id The ID for the Shiny module.
#'
#' @return A Shiny plotlyOutput for the piePlot
#'
#' @importFrom shiny NS
#' @importFrom plotly plotlyOutput
#' @importFrom shinyjqui jqui_resizable
#'
#' @export
#' @author Jacob Martin
piePlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("piePlot"), width = "100%", height = "400px"),
        options = list( 
        minWidth = 300,
        minHeight = 300,
        maxWidth = 1200,
        maxHeight = 800)
    )
    
}
