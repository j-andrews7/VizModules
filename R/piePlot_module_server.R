piePlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "piePlotTabsetPanel", target = tab.name)
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
            char.choices <- c("", names(data())[unlist(lapply(data(), is.character), use.names = FALSE)])
            # max.y <- max(numeric.data, na.rm = TRUE)
            # min.y <- min(numeric.data, na.rm = TRUE)
            # Reset numeric inputs to defaults derived from data
            #Data
            updateSelectInput(session, "labels", selected = char.choices[2])
            updateSelectInput(session, "values", selected = numeric.data[2])

            #Aesthetics
            updateNumericInput(session, "make.hole", value = 0)
            updateSelectInput(session, "palette", selected = "Paired")
            updateSelectInput(session, "palette.colours", selected = NULL)
            updateTextInput(session, "plot.text", value = "label+percent")
            updateNumericInput(session, "title.font.size", value = 28)
            updateSelectInput(session, "font.type", selected = "Arial")
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")

        })


        output$piePlot <- renderPlotly({
            # Null Values:
            
            labels_formula <- reformulate(input$labels)
            plot_values <- reformulate(input$values)

            # pie Plot
            
            p <- piePlot(reactive.data = data(), 
                        plot.labels = labels_formula,
                        plot.values = plot_values,
                        make.hole = input$make.hole,
                        palette = plotthis::palette_list[[input$palette]],
                        col_palette = input$palette.colours,
                        plot.text = input$plot.text
                        )


            plotlyOut <- ggplotly(p) |>
                layout(
                    title = list(text = "Click To Edit Title", font = list(size = input$title.font.size, family = input$font.type, color = input$text.colour), x = 0.47, xanchor = "center", y = 0.95, yanchor = "top", pad = list(t = 20)), margin = list(t = 80), showlegend = TRUE
                ) |>
                config(
                    editable = TRUE, edits = list(titleText = TRUE, axisTitleText = TRUE),
                    toImageButtonOptions = list(format = input$download.type, filename = "pie_plot", height = 600, width = 700, scale = 1),
                    displaylogo = FALSE
                ) # Hiding Plotly Logo

            return(plotlyOut)
        })
    })
}
