linePlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data

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
        #Defining reactive data before reset button 

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- c("", names(data())[unlist(lapply(data(), is.numeric), use.names = FALSE)])
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])

            #Reset Data columns to default. First and second index of data named list 
            updateSelectInput(session, "x.value", selected = names(data())[1])
            updateSelectInput(session, "y.value", selected = names(data())[2])
            updateSelectInput(session, "plot.type", selected = "lines")
            updateSelectInput(session, "line.type", selected = "solid")
            updateSwitchInput(session, "order.by", value = FALSE)
            updateSwitchInput(session, "flip.x", value = FALSE)
            updateSwitchInput(session, "flip.y", value = FALSE)
            updateSelectInput(session, "palette", selected = "Paired")
            updateSelectInput(session, "group.by", selected = "")


        })


        output$linePlot <- renderPlotly({
            input$update

            d <- data_reactive()
            x_input <- input$x.value
            y_input <- input$y.value
            #Multiple data points on 

            # Null Values:
            x_values <- reformulate(isolate(input$x.value))
            y_values <- reformulate(isolate(input$y.value))




            # Sets the colouring to the first item in the selected palette unless group.by is selected
            group.by <- plotthis::palette_list[[input$palette]][1]
            if (!input$group.by == "" && length(x_input) == 1 && length(y_input) == 1) {
                group.by <- reformulate(input$group.by)
            }

            #Making multiple lines on the axis. e.g 3x and 1y 
            #Determining axis min and max
            #Checking if the axis is a category and non continious 
            #And axis ordering 
            axis_min_x <- NULL
            axis_max_x <- NULL

            #Choosing which axis to order by: 
            order_by <- x_input
            if (input$order.by == TRUE){
                order_by <- y_input
            }

            if (is.numeric(d[[x_input[1]]])){
                axis_min_x <- min(d[[x_input[1]]])
                axis_max_x <- max(d[[x_input[1]]])
                d_sorted <- d[order(d[[order_by[1]]]), ]
            }
            axis_min_y <- NULL
            axis_max_y <- NULL

            if (is.numeric(d[[y_input[1]]])){
                axis_min_y <- min(d[[y_input[1]]])
                axis_max_y <- max(d[[y_input[1]]])
                d_sorted <- d[order(d[[order_by[1]]]), ]
            }

            

            # line Plot

            p <- linePlot(
                reactive.data = d_sorted,
                x.value = reformulate(isolate(x_input[1])),
                y.value = reformulate(isolate(y_input[1])),
                plot.mode = input$plot.type,
                line.type = input$line.type, 
                colour.group.by = group.by,
                palette.selection = plotthis::palette_list[[input$palette]],
                show.legend = FALSE
                
            )
            
            # If multiple X and Y variables are selected: 
            #ADDs lines to the plot 
            if (xor(length(x_input) > 1, length(y_input) > 1)) {
                if (length(x_input) > 1){
                    p <- p |> add_trace(
                        x = reformulate(isolate(x_input[1])),
                        y = reformulate(isolate(y_input[1])),
                        mode = input$plot.type,
                        line = list(dash = input$line.type),
                        name = x_input[1],
                        showlegend = TRUE
                    )
                    updateSwitchInput(session, "order.by", value = FALSE)  # So that the graph is ordered by the axis that has multiple data sets / columns 
                    for (i in 2:length(x_input)){
                        d_sorted <- d[order(d[[order_by[i]]]), ]
                        p <- p |> add_trace(
                            x = d_sorted[[x_input[i]]],
                            y = d_sorted[[y_input[1]]],
                            type = 'scatter',
                            mode = input$plot.type,
                            line = list(dash = input$line.type),
                            color = plotthis::palette_list[[input$palette]][i],
                            name = x_input[i],
                            showlegend = TRUE
                        )
                    axis_max_x <- max(d[,x_input])
                    axis_min_x <- min(d[,x_input])
                    }
                }
                if (length(y_input) > 1){
                    p <- p |> add_trace(
                        x = reformulate(isolate(x_input[1])),
                        y = reformulate(isolate(y_input[1])),
                        mode = input$plot.type,
                        line = list(dash = input$line.type),
                        name = y_input[1],
                        showlegend = TRUE
                    ) 
                    updateSwitchInput(session, "order.by", value = TRUE) # So that the graph is ordered by the axis that has multiple data sets / columns 
                    for (i in 2:length(y_input)){
                        d_sorted <- d[order(d[[order_by[i]]]), ]
                        p <- p |> add_trace(
                            x = d_sorted[[x_input[1]]],
                            y = d_sorted[[y_input[i]]],
                            type = 'scatter',
                            mode = input$plot.type,
                            line = list(dash = input$line.type),
                            color = plotthis::palette_list[[input$palette]][i],
                            name = y_input[i],
                            showlegend = TRUE
                        )
                    axis_max_y <- max(d[,y_input])
                    axis_min_y <- min(d[,y_input])
                    }
                }
            }

            #Axis title: 
            x_title <- x_input[1]
            if (length(x_input) > 1){
                x_title <- "Value"
            }
            y_title <- y_input[1]
            if (length(y_input) > 1){
                y_title <- "Value"
            }

            #Axis flipped: 

            flip_x <- NULL
            if (input$flip.x == TRUE){
                flip_x <- "reversed"
            }
            flip_y <- NULL
            if (input$flip.y == TRUE){
                flip_y <- "reversed"
            }

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
                        tickwidth = isolate(input$axis.tickwidth),
                        range = c(axis_min_x, axis_max_x),
                        title = x_title,
                        autorange = flip_x
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
                        tickwidth = isolate(input$axis.tickwidth),
                        range = c(axis_min_y, axis_max_y),
                        title = y_title,
                        autorange = flip_y
    
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
