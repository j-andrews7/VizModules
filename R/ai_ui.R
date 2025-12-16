#' boxAI inputs UI
#'
#' @param id Shiny module id.
#' @param data A data.frame used to infer variable choices.
#' @param defaults Optional named list of default values.
#' @param title Optional title tag for the UI group.
#' @param columns Number of columns in the UI grid.
#'
#' @return A Shiny tagList containing the UI elements.
#'
#' @importFrom shiny tagList NS selectInput numericInput textInput actionButton
#'   br fluidPage titlePanel sidebarLayout sidebarPanel mainPanel h3 h4
#' @importFrom shinyjs useShinyjs hide
#' @importFrom shinyWidgets switchInput
#' @importFrom colourpicker colourInput
#' @importFrom shinyjqui jqui_resizable
#' @importFrom plotly plotlyOutput renderPlotly ggplotly
#'
#' @export
boxAIInputsUI <- function(id, data, defaults = NULL, title = NULL, columns = 2) {
    ns <- NS(id)

    # Get variables of data
    choices <- c("", names(data))
    num.choices  <- c("", names(data)[unlist(lapply(data, is.numeric), use.names = FALSE)])
    char.choices <- c("", names(data)[unlist(lapply(data, is.character), use.names = FALSE)])
    numeric.data <- data[, sapply(data, is.numeric), drop = FALSE]
    max.y <- max(numeric.data, na.rm = TRUE)
    min.y <- min(numeric.data, na.rm = TRUE)

    inputs <- list(
        "Data" = tagList(
            selectInput(ns("x.data"), "Select X ", choices = char.choices, selected = char.choices[2]),
            selectInput(ns("y.data"), "Select Y ", choices = num.choices, selected = num.choices[2]),
            selectInput(ns("group_by"), "Group by:",  choices = choices, selected = ""),
            selectInput(ns("facet_by"), "Facet by:",  choices = choices, selected = "")
        ),
        "Layout" = tagList(
            shiny::selectInput(
                ns("sort_x"), "Sort X-axis:",
                c("none", "mean_asc", "mean_desc", "median_asc", "median_desc"),
                selected = "none"
            ),
            switchInput(ns("flip"), "Flip Plot:", value = FALSE),
            numericInput(ns("x.text.angle"), "X text angle:", value = 90, min = 0, max = 360),
            switchInput(ns("stack"), "Stack:", value = FALSE),
            numericInput(ns("y.max"), "Y Max:", value = max.y, min = -1000, max = 1000),
            numericInput(ns("y.min"), "Y Min:", value = min.y, min = -1000, max = 1000),
            numericInput(ns("aspect.ratio"), "Aspect Ratio:", value = 1, min = 0.1, max = 10)
        ),
        "Points" = tagList(
            switchInput(ns("add.points"), "Add Points:", value = FALSE),
            colourInput(ns("pt.color"), "Point Color:", value = "#4472C4"),
            numericInput(ns("pt.size"),  "Point Size:",  min = 0.1, max = 10, value = 1),
            numericInput(ns("pt.alpha"), "Point Alpha:", min = 0,   max = 1,  value = 0.8),
            numericInput(ns("jitter.width"),  "Jitter Width:",  min = 0, max = 1, value = 0.2),
            numericInput(ns("jitter.height"), "Jitter Height:", min = 0, max = 1, value = 0)
        ),
        "Stats" = tagList(
            selectInput(
                ns("add_stat"), "Add Statistic:",
                c("none", "p.signif", "p.format"),
                selected = "none"
            ),
            switchInput(ns("comparisons"), "Pairwise Comparisons:", value = FALSE),
            selectInput(
                ns("pairwise_method"), "Pairwise Method:",
                c("wilcox.test", "t.test", "anova"),
                selected = "wilcox.test"
            ),
            switchInput(ns("hide_ns"), "Hide NS:", value = TRUE),
            numericInput(ns("sig_labelsize"), "Sig Label Size:", min = 2, max = 10, value = 4)
        ),
        "Labels" = tagList(
            textInput(ns("title"),    "Plot Title:", value = ""),
            textInput(ns("subtitle"), "Subtitle:",   value = ""),
            textInput(ns("x.lab"),    "X Label:",    value = ""),
            textInput(ns("y.lab"),    "Y Label:",    value = "")
        ),
        "Trend" = tagList(
            switchInput(ns("add.trend"), "Add Trend:", value = FALSE),
            colourInput(ns("trend.color"), "Trend Color:", value = "#E74C3C"),
            numericInput(ns("trend.ptsize"), "Trend Point Size:", min = 0.5, max = 5, value = 2)
        )
    )

    organize_inputs(
        inputs,
        id = ns("boxAITabsetPanel"),
        title = title,
        tack = tagList(
            actionButton(ns("update"), "Update Plot", class = "btn-primary btn-lg"),
            actionButton(ns("reset"),  "Reset Defaults", class = "btn-secondary"),
            br()
        ),
        columns = columns
    )
}

#' boxAI output UI
#'
#' @param id Shiny module id.
#'
#' @return A resizable plotlyOutput.
#'
#' @export
boxAIOutputUI <- function(id) {
    ns <- NS(id)
    jqui_resizable(
        plotlyOutput(ns("boxAIPlot"), width = "100%", height = "400px"),
        options = list(
            minWidth  = 300,
            minHeight = 300,
            maxWidth  = 1200,
            maxHeight = 800
        )
    )
}
