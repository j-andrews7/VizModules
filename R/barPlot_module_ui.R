barPlotInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
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
            selectInput(ns("x.data"), "X values:", selected = char.choices[2], choices = char.choices),
            selectInput(ns("y.data"), "Y values:", selected = num.choices[2], choices = num.choices),
            switchInput(ns("flip"), "Flip plot:", value = FALSE, onLabel = "On", offLabel = "Off"),
            numericInput(ns("y.max"), "Max y value:", value = max.y),
            numericInput(ns("y.min"), "Min y value:", value = min.y)

        ),
        "Grouping" = tagList(
            selectInput(ns("group.by"), "Group by:", selected = char.choices[2], choices = char.choices),
            selectInput(ns("facet.by"), "Facet by:", selected = "NULL", choices = c(char.choices, "NULL")),
            selectInput(ns("facet.scale"), "Facet scale:", selected = "fixed", choices = c("fixed", "free", "free_x", "free_y")),
            numericInput(ns("facet.ncol"), "Facet number of columns:", value = NULL, min = 0, max = 20),
            numericInput(ns("facet.nrow"), "Facet number of rows:", value = NULL, min = 0, max = 20), 
            switchInput(ns("facet.by.row"), "Facet by row:", value = TRUE, offLabel = "Off", onLabel = "On"),
            selectInput(ns("split.by"), "Split by:", selected = "NULL", choices = c(char.choices, "NULL"))
        ),

        "Aesthetic" = tagList(
            selectInput(ns("palette"), "Plot Palette:", selected = "Set2", choices = names(plotthis::palette_list)),
            uiOutput(ns("palette.selection")),
            switchInput(ns("background.colour"), "Background colour:", value = FALSE, onLabel = "On", offLabel = "Off"),
            selectInput(ns("background.palette"), "Background Palette:", selected = "Set2", choices = names(plotthis::palette_list)),
            numericInput(ns("background.alpha"), "Background alpha: ", value = 0.5, min = 0, max = 1),
            selectInput(ns("theme"), "Theme:", selected = "theme_this", choices = c("theme_grey", "theme_bw", "theme_linedraw", "theme_light", 
                                                                                    "theme_dark", "theme_minimal", "theme_classic", "theme_void", 
                                                                                    "theme_this", "theme_blank")),
            numericInput(ns("alpha"), "Alpha:", value = 1, min = 0, max = 1),
            numericInput(ns("width"), "Width:", value = NA),
            textInput(ns("expand"), "Expand:", value = "", placeholder = "e.g. 1,2,3,4")
            
        ), 
        "Line" = tagList(
            numericInput(ns("add.line"), "Add line:", value = NULL),
            colourpicker::colourInput(ns("line.colour"), "Line colour:", value = "#000000"),
            numericInput(ns("line.type"), "Line type:", value = 2, min = 0),
            numericInput(ns("line.width"), "Line width:", value = 0.6, min = 0),
            textInput(ns("line.name"), "Line name:", value = "", placeholder = "Line Name")
        ), 
        "Labels" = tagList(
            selectInput(ns("font.type"), "Font:", selected = "Arial", choices = c("Arial", "Balto", "Courier New", "Droid Sans", "Droid Serif", "Droid Sans Mono", "Gravitas One",
                                                                                "Old Standard TT", "Open Sans", "Overpass", "PT Sans Narrow", "Raleway", "Times New Roman", "Verdana", 
                                                                                "sans-serif", "serif", "monospace")),
            numericInput(ns("axis.font.size"), "Axis font size", value = 18, min = 1),
            numericInput(ns("title.font.size"), "Axis font size", value = 28, min = 1),
            colourpicker::colourInput(ns("text.colour"), "Label colour:", value = "#000000")
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



barPlotOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("barPlot"), width = "100%", height = "400px"),
        options = list( 
        minWidth = 300,
        minHeight = 300,
        maxWidth = 1200,
        maxHeight = 800)
    )
    
}
