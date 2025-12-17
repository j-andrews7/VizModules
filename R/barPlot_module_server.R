barPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "barPlotTabsetPanel", target = tab.name)
            })
        }
        ns <- session$ns  
        output$palette.selection <- renderUI({
            pal <- input$palette
            colour_selection <- plotthis::palette_list[[pal]]

            selectInput(
            ns("palette.colours"),             # namespaced ID
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
            updateSwitchInput(session, "flip", value = FALSE)
            updateNumericInput(session, "y.max", value = max.y)
            updateNumericInput(session, "y.min", value = min.y)

            #Grouping
            updateSelectInput(session, "group.by", selected = char.choices[2])
            updateSelectInput(session, "facet.by", selected = "NULL")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateSwitchInput(session, "facet.by.row", value = TRUE)
            updateSelectInput(session, "split.by", selected = "NULL")

            #Aesthetics
            updateSelectInput(session, "palette", selected = "Set2")
            updateSwitchInput(session, "background.colour", value = FALSE)
            updateSelectInput(session, "background.palette", selected = "Set2")
            updateNumericInput(session, "background.alpha", value = 0.5)
            updateSelectInput(session, "theme", selected = "theme_this")
            updateNumericInput(session, "alpha", value = 1)
            updateNumericInput(session, "width", value = NA)
            updateTextInput(session, "expand", value = "")

            #Line
            updateNumericInput(session, "add.line", value = NA)
            colourpicker::updateColourInput(session, "line.colour", value = "#000000")
            updateNumericInput(session, "line.type", value = 2)
            updateNumericInput(session, "line.width", value = 0.6)
            updateTextInput(session, "line.name", value = "")

            #Labels
            updateSelectInput(session, "font.type", selected = "Arial")
            updateNumericInput(session, "axis.font.size", value = 18)
            updateNumericInput(session, "title.font.size", value = 28)
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
            #Action Button: 
            updateSelectInput(session, "download.type", selected = "png")
            })

        
        output$barPlot <- renderPlotly({
            #Null Values: 
            facet.by <- NULL
            if (!input$facet.by == "NULL"){
                facet.by <- input$facet.by
            }
            line.name <- NULL
            if (!input$line.name == ""){
                line.name <- input$line.name
            }
            expand <- waiver()
            if (!input$expand == ""){
                expand <- as.numeric(strsplit(input$expand, ",\\s*")[[1]])
            } 
            if (!is.na(input$width)){
                width <- input$width
            } else {
                width <- waiver()
            }
            split.by <- NULL
            if(!input$split.by == "NULL"){
                split.by <- input$split.by
            }
            #bar Plot 
            p <- plotthis::BarPlot(
                data(),
                x = input$x.data,
                y = input$y.data,
                flip = input$flip,
                group_by = input$group.by,
                facet_by = facet.by,
                facet_scales = input$facet.scale,
                facet_ncol = input$facet.ncol,
                facet_nrow = input$facet.nrow,
                facet_byrow = input$facet.by.row,
                palette = input$palette,
                palcolor = input$palette.colours,
                add_bg = input$background.colour,
                bg_palette = input$background.palette,
                bg_alpha = input$background.alpha, 
                y_min = input$y.min,
                y_max = input$y.max,
                theme = input$theme,
                alpha = input$alpha, 
                add_line = input$add.line,
                line_color = input$line.colour,
                line_width = input$line.width,
                line_type = input$line.type,
                line_name = line.name,
                fill_by_x_if_no_group = TRUE,
                expand = expand, 
                width = width,
                split_by = split.by
            )
            plotlyOut <- ggplotly(p) |>
                layout(title = list(text = "Click To Edit Title", font = list(size = input$title.font.size, family = input$font.type, color = input$text.colour), x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"),  # Editing the Plotly axis titles and download button 
                    xaxis = list(title = list(text = "X-axis", font = list(size = input$axis.font.size, family = input$font.type, color = input$text.colour))),
                    yaxis = list(title = list(text = "Y-axis", font = list(size = input$axis.font.size, family = input$font.type, color = input$text.colour)))) |>
                    config(editable = TRUE, edits = list(titleText = TRUE, axisTitleText = TRUE), 
                        toImageButtonOptions = list(format = input$download.type, filename = "box_plot", height = 500, width = 700, scale = 1),
                        displaylogo = FALSE) # Hiding Plotly Logo

            return(plotlyOut)
            
        })
    })
}

