#' @details The user inputs for this module are separated from the outputs to allow for 
#' @param id The ID for the Shiny module.
#' @param data The data frame used for plot generation.
#' @param defaults A named list of default values for the inputs.
#' @param title An optional title for the UI grid.
#' @param columns Number of columns for the UI grid.
#' @return A Shiny tagList containing the UI elements
#'
#' @importFrom shiny tagList NS selectInput numericInput sliderInput
#'   checkboxInput textInput actionButton br selectizeInput switchInput
#' @importFrom shinyWidgets switchInput  
#' @importFrom colourpicker colourInput
#' @importFrom shinyjqui jqui_resizable
#' @importFrom plotthis palette_list
#' @export
#' @author Jacob Martin
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
            colourpicker::colourInput(ns("pt.color"), "Point outline colour", value = "#4472C4")
        ),
        "Annotations" = tagList(
            textInput(ns("title"), "Title of plot:", value = "title"),
            textInput(ns("y.lab"), "Title of Y:", value = "y title"),
            textInput(ns("x.lab"), "Title of X:", value = "x title"),
            numericInput(ns("add.line"), "Add Y interception line:", value = NULL, min = min.y, max = max.y)
        ),
        "Trajectory" = tagList(
            switchInput(ns("add.trend"), "Add Median Point", value = FALSE, onLabel = "Trend Added", offLabel = "Trend Not Added"),
            numericInput(ns("trend.pt.size"), "Trend Point Size:", min = 0, max = 40, value = 2)
        ),
        "Stats" = tagList(
            selectInput(ns("add.stat"), "Add Stats:", selected = "mean", choices = c("mean", "sd", "median", "var")),
            colourpicker::colourInput(ns("stat.color"), "Stats Colour:", value = "#000000"),
            numericInput(ns("stat.size"), "Stat Size:", value = 1, min = 0, max = 10),
            numericInput(ns("stat.sroke"), "Stat Stroke:", value = 1, min = 0, max = 10),
            numericInput(ns("stat.shape"), "Stat Shape:", value = 25, min = 0, max = 100)
        ),
        "Palette" = tagList(
            selectInput(ns("palette"), "Plot Palette:", selected = "Paired", choices = names(plotthis::palette_list)),
            switchInput(ns("background.colour"), "Background colour:", value = FALSE, onLabel = "On", offLabel = "Off"),
            selectInput(ns("background.palette"), "Background Palette:", selected = "Paired", choices = names(plotthis::palette_list)),
        ),
        "Facet" = tagList(
            selectInput(ns("facet.by"), "Facet by:", selected = "NULL", choices = c(char.choices, "NULL")),
            selectInput(ns("facet.scale"), "Facet scale:", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Facet number of columns:", value = NULL, min = 0, max = 20),
            numericInput(ns("facet.nrow"), "Facet number of rows:", value = NULL, min = 0, max = 20), 
            switchInput(ns("facet.by.row"), "Facet by row:", value = TRUE, offLabel = "Off", onLabel = "On")
        )
    )

    organize_inputs(
        inputs,
        id = ns("scatterPlotTabsetPanel"),
        title = title,
        tack = tagList(actionButton(ns("reset"),  "Reset Defaults", class = "btn-secondary"), 
                        br()),
        columns = columns
    )
}



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

#background colour doesnt work with plotly = add_bg | bg_palette

# facet_by
# A character string specifying the column name of the data frame to facet the plot. Otherwise, the data will be split by split_by and generate multiple plots and combine them into one using patchwork::wrap_plots

# facet_scales
# Whether to scale the axes of facets. Default is "fixed" Other options are "free", "free_x", "free_y". See ggplot2::facet_wrap

# facet_ncol
# A numeric value specifying the number of columns in the facet. When facet_by is a single column and facet_wrap is used.

# facet_nrow
# A numeric value specifying the number of rows in the facet. When facet_by is a single column and facet_wrap is used.

# facet_byrow
# A logical value indicating whether to fill the plots by row. Default is TRUE.