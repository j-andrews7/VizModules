linePlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "linePlotTabsetPanel", target = tab.name)
            })
        }
        ns <- session$ns
        output$palette.selection <- renderUI({
            pal <- input$palette
            colour_selection <- plotthis::palette_list[[pal]]

            selectInput(
                ns("palette.colours"), # namespaced ID
                "Colours to use:",
                multiple = TRUE,
                selected = NULL,
                choices  = c(colour_selection)
            )
        })

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- c("", names(data())[unlist(lapply(data(), is.numeric), use.names = FALSE)])
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])

            #Reset Data columns to default. First and second index of data named list 
            updateSelectInput(session, "x.value", selected = names(data())[1])
            updateSelectInput(session, "y.value", selected = names(data())[2])
            updateSelectInput(session, "plot.type", selected = "lines")
        })


        output$linePlot <- renderPlotly({
            input$update

            # Null Values:
            x_values <- reformulate(isolate(input$x.value))
            y_values <- reformulate(isolate(input$y.value))

            # line Plot

            p <- linePlot(
                reactive.data = data(),
                x.value = x_values,
                y.value = y_values,
                plot.mode = input$plot.type
            )


            plotlyOut <- ggplotly(p) |>
                layout(
                    title = list(text = "Click To Edit Title", font = list(size = isolate(input$title.font.size), family = isolate(input$font.type), color = isolate(input$text.colour)), x = 0.47, xanchor = "center", y = 0.95, yanchor = "top", pad = list(t = 20)), margin = list(t = 80), showlegend = TRUE,
                    xaxis = list(
                        showline = isolate(input$axis.showline),
                        mirror = isolate(input$axis.mirror),
                        linecolor = isolate(input$axis.linecolor),
                        linewidth = isolate(input$axis.linewidth),
                        tickfont = list(
                            size = isolate(input$axis.tickfont.size),
                            color = isolate(input$axis.tickfont.color),
                            family = isolate(input$axis.tickfont.family)
                        ),
                        tickangle = isolate(input$axis.tickangle.x),
                        ticks = isolate(input$axis.ticks),
                        tickcolor = isolate(input$axis.tickcolor),
                        ticklen = isolate(input$axis.ticklen),
                        tickwidth = isolate(input$axis.tickwidth)
                    ),
                    yaxis = list(
                        showline = isolate(input$axis.showline),
                        mirror = isolate(input$axis.mirror),
                        linecolor = isolate(input$axis.linecolor),
                        linewidth = isolate(input$axis.linewidth),
                        tickfont = list(
                            size = isolate(input$axis.tickfont.size),
                            color = isolate(input$axis.tickfont.color),
                            family = isolate(input$axis.tickfont.family)
                        ),
                        tickangle = isolate(input$axis.tickangle.y),
                        ticks = isolate(input$axis.ticks),
                        tickcolor = isolate(input$axis.tickcolor),
                        ticklen = isolate(input$axis.ticklen),
                        tickwidth = isolate(input$axis.tickwidth)
                    )
                ) |>
                config(
                    editable = TRUE, edits = list(titleText = TRUE, axisTitleText = TRUE),
                    toImageButtonOptions = list(
                        format = isolate(input$download.type),
                        filename = "line_plot", height = 600, width = 700, scale = 1
                    ),
                    displaylogo = FALSE
                ) # Hiding Plotly Logo

            return(plotlyOut)
        })
    })
}
