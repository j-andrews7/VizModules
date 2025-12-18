areaPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "areaPlotTabsetPanel", target = tab.name)
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
            numeric.data <- data()[, sapply(data(), is.numeric), drop = FALSE]
            char.choices <- c("", names(data())[unlist(lapply(data(), is.character), use.names = FALSE)])
            max.y <- max(numeric.data, na.rm = TRUE)
            min.y <- min(numeric.data, na.rm = TRUE)
            # Reset numeric inputs to defaults derived from data
            #Data
            updateSelectInput(session, "x.data", selected = char.choices[2])

            # Grouping
            updateSelectInput(session, "group.by", selected = char.choices[3])
            updateSelectInput(session, "facet.by", selected = "NULL")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateSwitchInput(session, "facet.by.row", value = TRUE)
            updateSelectInput(session, "split.by", selected = "NULL")

            # Aesthetics
            updateSelectInput(session, "palette", selected = "Set2")
            updateSelectInput(session, "theme", selected = "theme_this")
            updateNumericInput(session, "alpha", value = 1)

            # Labels
            updateSelectInput(session, "font.type", selected = "Arial")
            updateNumericInput(session, "axis.font.size", value = 18)
            updateNumericInput(session, "title.font.size", value = 28)
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
            # Action Button:
            updateSelectInput(session, "download.type", selected = "png")
        })


        output$areaPlot <- renderPlotly({
            # Null Values:
            facet.by <- NULL
            if (!input$facet.by == "NULL"){
                facet.by <- input$facet.by
            }
            split.by <- NULL
            if (!input$split.by == "NULL"){
                split.by <- input$split.by
            }
            design <- if(input$split.by == "NULL" || input$design == "NULL") NULL else input$design
            # area Plot
            
            p<-plotthis::AreaPlot(
                data(),
                x=input$x.data,
                y=input$y.data,
                split_by=split.by,
                group_by=input$group.by,
                theme=input$theme,
                palette=input$palette,
                palcolor=input$palette.colours,
                alpha=input$alpha,
                facet_by=facet.by,
                facet_scales=input$facet.scale,
                facet_ncol=input$facet.ncol,
                facet_nrow=input$facet.nrow,
                facet_byrow=input$facet.by.row,
                combine = input$combine,
                design = design
            )


            plotlyOut <- ggplotly(p) |>
                layout(
                    title = list(text = "Click To Edit Title", font = list(size = input$title.font.size, family = input$font.type, color = input$text.colour), x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"), # Editing the Plotly axis titles and download button
                    xaxis = list(title = list(text = "X-axis", font = list(size = input$axis.font.size, family = input$font.type, color = input$text.colour))),
                    yaxis = list(title = list(text = "Y-axis", font = list(size = input$axis.font.size, family = input$font.type, color = input$text.colour)))
                ) |>
                config(
                    editable = TRUE, edits = list(titleText = TRUE, axisTitleText = TRUE),
                    toImageButtonOptions = list(format = input$download.type, filename = "area_plot", height = 500, width = 700, scale = 1),
                    displaylogo = FALSE
                ) # Hiding Plotly Logo

            return(plotlyOut)
        })
    })
}
