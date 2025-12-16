#' @importFrom shiny tagList NS selectInput numericInput sliderInput
#'   checkboxInput textInput actionButton br selectizeInput switchInput
#' @importFrom shinyWidgets switchInput  
#' @importFrom colourpicker colourInput
#' @importFrom plotthis BoxPlot
#' @importFrom plotly ggplotly
boxPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            lapply(hide.inputs, function(input.name) {
                hide(input.name)
            })
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            lapply(hide.tabs, function(tab.name) {
                hideTab(inputId = "boxPlotTabsetPanel", target = tab.name)
            })
        }

        # Reset functionality
    observeEvent(input$reset, {
        numeric.data <- data()[, sapply(data(), is.numeric), drop = FALSE]
        max.y <- max(numeric.data, na.rm = TRUE)
        min.y <- min(numeric.data, na.rm = TRUE)
        # Reset numeric inputs to defaults derived from data

        #Adjustments
        updateSelectInput(session, "sort_x", selected = "none")
        updateSwitchInput(session, "flip", value = FALSE)
        updateSwitchInput(session, "stack", value = FALSE)
        updateNumericInput(session, "aspect.ratio", value = 1)
        updateNumericInput(session, "y.min", value = min.y)
        updateNumericInput(session, "y.max", value = max.y)

        #Points
        updateSwitchInput(session, "add.points", value = FALSE)
        updateNumericInput(session, "pt.size", value = 1)
        updateNumericInput(session, "pt.alpha", value = 1)
        updateNumericInput(session, "jitter.width", value = 0.5)
        updateNumericInput(session, "jitter.height", value = 0)

        # Colors
        colourpicker::updateColourInput(session, "pt.color", value = "#4472C4")
        updateNumericInput(session, "alpha", value = 0.7)

        # Annotations
        updateTextInput(session, "title", value = "title")
        updateTextInput(session, "y.lab", value = "y title")
        updateTextInput(session, "x.lab", value = "x title")

        # Trajectory
        updateSwitchInput(session, "add.trend", value = FALSE)
        updateNumericInput(session, "trend.pt.size", value = 2)

        # Stats
        updateSelectInput(session, "add.stat", selected = "mean")
        colourpicker::updateColourInput(session, "stat.color", value = "#000000")
        updateNumericInput(session, "stat.size", value = 1)
        updateNumericInput(session, "stat.sroke", value = 1)
        updateNumericInput(session, "stat.shape", value = 25)
        })

        
        output$boxPlot <- renderPlotly({

            p <- plotthis::BoxPlot(data = data(),
                                    x = input$x.data,
                                    y = input$y.data,
                                    flip = input$flip,
                                    sort_x = input$sort_x,
                                    stack = input$stack,
                                    y_max = input$y.max,
                                    y_min = input$y.min,
                                    aspect.ratio = input$aspect.ratio,
                                    add_point = input$add.points,
                                    pt_size = input$pt.size,
                                    pt_alpha = input$pt.alpha,
                                    jitter_width = input$jitter.width,
                                    jitter_height = input$jitter.height,
                                    pt_color = input$pt.color,
                                    alpha = input$alpha,
                                    title = input$title,
                                    ylab = input$y.lab,
                                    xlab = input$x.lab,
                                    add_trend = input$add.trend,
                                    trend_ptsize = input$trend.pt.size,
                                    add_stat = match.fun(input$add.stat),
                                    stat_color = input$stat.color,
                                    stat_size = input$stat.size,
                                    stat_stroke = input$stat.stroke,
                                    stat_shape = input$stat.shape,
                                    stat_name = input$add.stat,
                                    palette = input$palette,
                                    add_bg = input$background.colour,
                                    bg_palette = input$background.palette,
                                    add_line = input$add.line
                                    )
            plotlyOut <- ggplotly(p)
            return(plotlyOut)
            
        })
    })
}

