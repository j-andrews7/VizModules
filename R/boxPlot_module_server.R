#' boxPlot Shiny Module Server
#'
#' Server function for the interactive boxPlot Shiny module using [plotthis::BoxPlot()].
#' Creates interactive box plots with extensive customization options including points,
#' trends, statistics, facets, highlighting, and download capabilities.
#'
#' @param id Character ID for the module.
#' @param data Reactive expression returning a data frame to plot.
#' @param hide.inputs Character vector of input names to hide (e.g., c("add.points", "flip")).
#' @param hide.tabs Character vector of tab names to hide from the input panel.
#'
#' @return Module server object with `boxPlot` plotly output.
#' 
#' @importFrom shiny moduleServer reactive renderPlotly updateSelectInput updateSwitchInput
#'   updateNumericInput updateTextInput updateColourInput selectInput switchInput
#'   numericInput textInput actionButton hide hideTab
#' @importFrom shinyWidgets updateSwitchInput
#' @importFrom colourpicker updateColourInput
#' @importFrom plotly ggplotly layout config
#' @export
#' 
#' @author Jacob Martin
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

        #Data
        updateSelectInput(session, "group.by", selected = "NULL")
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
        updateNumericInput(session, "add.line", value = NULL)
        updateTextInput(session, "highlight", value = "")
        colourpicker::updateColourInput(session, "highlight.colour", value = "#000000")
        updateNumericInput(session, "highlight.size", value = 1)
        updateNumericInput(session, "highlight.alpha", value = 1)
        updateSelectInput(session, "font.type", selected = "Arial")
        colourpicker::updateColourInput(session, "text.colour", value = "#000000")

        # Trajectory
        updateSwitchInput(session, "add.trend", value = FALSE)
        updateNumericInput(session, "trend.pt.size", value = 2)
        colourpicker::updateColourInput(session, "trend.colour", value = "#000000")
        updateNumericInput(session, "trend.line.width", value = 1)

        # Stats
        updateSelectInput(session, "add.stat", selected = "mean")
        colourpicker::updateColourInput(session, "stat.color", value = "#000000")
        updateNumericInput(session, "stat.size", value = 1)
        updateNumericInput(session, "stat.sroke", value = 1)
        updateNumericInput(session, "stat.shape", value = 25)

        #Palette
        updateSelectInput(session, "palette", selected = "Paired")
        #Facet
        updateSelectInput(session, "facet.by", selected = "NULL")
        updateSelectInput(session, "facet.scale", selected = "fixed")
        updateNumericInput(session, "facet.ncol", value = NULL)
        updateNumericInput(session, "facet.nrow", value = NULL)
        updateSwitchInput(session, "facet.by.row", value = TRUE)

        #Action Button: 
        updateSelectInput(session, "download.type", selected = "png")
        })

        
        output$boxPlot <- renderPlotly({
            #Facet By Null option Upstream:
            facet.by <- NULL
            if (!input$facet.by == "NULL"){
                facet.by <- input$facet.by

            }
            group.by <- NULL
            if(!input$group.by == "NULL"){
                group.by <- input$group.by
            }
            highlight <- NULL
            if(!input$highlight == ""){
                highlight <- input$highlight
            }
            #Box Plot 
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
                                    add_trend = input$add.trend,
                                    trend_ptsize = input$trend.pt.size,
                                    trend_color = input$trend.colour,
                                    trend_linewidth = input$trend.line.width,
                                    add_stat = match.fun(input$add.stat),
                                    stat_color = input$stat.color,
                                    stat_size = input$stat.size,
                                    stat_stroke = input$stat.stroke,
                                    stat_shape = input$stat.shape,
                                    stat_name = input$add.stat,
                                    palette = input$palette,
                                    add_bg = input$background.colour,
                                    bg_palette = input$background.palette,
                                    add_line = input$add.line, 
                                    facet_by = facet.by,
                                    facet_scales = input$facet.scale,
                                    facet_ncol = input$facet.ncol,
                                    facet_nrow = input$facet.nrow,
                                    facet_byrow = input$facet.by.row, 
                                    group_by = group.by,
                                    highlight = highlight,
                                    highlight_color = input$highlight.colour,
                                    highlight_size = input$highlight.size,
                                    highlight_alpha = input$highlight.alpha,
                                    combine = input$combine
                                    )
            plotlyOut <- ggplotly(p) |>
                layout(title = list(text = "Click To Edit Title", font = list(size = 28, family = input$font.type, color = input$text.colour), x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"),  # Editing the Plotly axis titles and download button 
                    xaxis = list(title = list(text = "X-axis", font = list(size = 18, family = input$font.type, color = input$text.colour))),
                    yaxis = list(title = list(text = "Y-axis", font = list(size = 18, family = input$font.type, color = input$text.colour)))) |>
                    config(editable = TRUE, edits = list(titleText = TRUE, axisTitleText = TRUE), 
                        toImageButtonOptions = list(format = input$download.type, filename = "box_plot", height = 500, width = 700, scale = 1),
                        displaylogo = FALSE) # Hiding Plotly Logo

            return(plotlyOut)
            
        })
    })
}

