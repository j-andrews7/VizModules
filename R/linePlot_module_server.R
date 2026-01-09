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
        # Defining reactive data before reset button

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- c("", names(data())[unlist(lapply(data(), is.numeric), use.names = FALSE)])
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])

            # Reset Data columns to default. First and second index of data named list
            updateSelectInput(session, "x.value", selected = names(data())[1])
            updateSelectInput(session, "y.value", selected = names(data())[2])
            updateSelectInput(session, "plot.type", selected = "lines")
            updateSelectInput(session, "line.type", selected = "solid")
            updateSwitchInput(session, "order.by", value = FALSE)
            updateSwitchInput(session, "flip.x", value = FALSE)
            updateSwitchInput(session, "flip.y", value = FALSE)
            updateSelectInput(session, "palette", selected = "Paired")
            updateSelectInput(session, "group.by", selected = "")
            updateSelectInput(session, "facet.by", selected = "")
        })


        output$linePlot <- renderPlotly({
            input$update

            d <- data_reactive()
            x_input <- input$x.value
            y_input <- input$y.value
            # Multiple data points on

            # Null Values:
            x_values <- reformulate(isolate(input$x.value))
            y_values <- reformulate(isolate(input$y.value))


            # Sets the colouring to the first item in the selected palette unless group.by is selected
            group.by <- plotthis::palette_list[[input$palette]][1]
            if (!input$group.by == "" && length(x_input) == 1 && length(y_input) == 1) {
                group.by <- reformulate(input$group.by)
            }

            # Making multiple lines on the axis. e.g 3x and 1y
            # Determining axis min and max
            # Checking if the axis is a category and non continious
            # And axis ordering
            axis_min_x <- NULL
            axis_max_x <- NULL

            # Choosing which axis to order by:
            order_by <- x_input
            if (input$order.by == TRUE) {
                order_by <- y_input
            }

            if (is.numeric(d[[x_input[1]]])) {
                axis_min_x <- min(d[[x_input[1]]])
                axis_max_x <- max(d[[x_input[1]]])
                d_sorted <- d[order(d[[order_by[1]]]), ]
            }
            axis_min_y <- NULL
            axis_max_y <- NULL

            if (is.numeric(d[[y_input[1]]])) {
                axis_min_y <- min(d[[y_input[1]]])
                axis_max_y <- max(d[[y_input[1]]])
                d_sorted <- d[order(d[[order_by[1]]]), ]
            }

            # Facet By default
            input.facet.by <- NULL
            if (!input$facet.by == "") {
                input.facet.by <- input$facet.by
            }


            # Axis title:
            x_title <- x_input[1]
            if (length(x_input) > 1) {
                x_title <- "Value"
            }
            y_title <- y_input[1]
            if (length(y_input) > 1) {
                y_title <- "Value"
            }

            # Axis flipped:

            flip_x <- NULL
            if (input$flip.x == TRUE) {
                flip_x <- "reversed"
            }
            flip_y <- NULL
            if (input$flip.y == TRUE) {
                flip_y <- "reversed"
            }

            y.adjustment <- NULL 
            if (!input$y.adjustment == ""){
                y.adjustment <- input$y.adjustment
            }
            x.adjustment <- NULL 
            if (!input$x.adjustment == ""){
                x.adjustment <- input$x.adjustment
            }
            # line Plot

            #Checking that all columns are numeric for x and y adjustment to be available
            if (!all(sapply(d[x_input], is.numeric))){
                updateSelectInput(session, "x.adjustment", selected = "")
                x.adjustment <- NULL
            }
            if (!all(sapply(d[y_input], is.numeric))){
                updateSelectInput(session, "y.adjustment", selected = "")
                y.adjustment <- NULL
            }
            p <- linePlot(
                reactive.data = d_sorted,
                x.value = reformulate(isolate(x_input[1])),
                y.value = reformulate(isolate(y_input[1])),
                plot.mode = input$plot.type,
                line.type = input$line.type,
                colour.group.by = group.by,
                palette.selection = plotthis::palette_list[[input$palette]],
                show.legend = FALSE,
                facet.by = input.facet.by,
                axis.showline = isolate(input$axis.showline),
                axis.mirror = isolate(input$axis.mirror),
                axis.linecolor = isolate(input$axis.linecolor),
                axis.linewidth = isolate(input$axis.linewidth),
                axis.tickfont.size = isolate(input$axis.tickfont.size),
                axis.tickfont.color = isolate(input$axis.tickfont.color),
                axis.tickfont.family = isolate(input$axis.tickfont.family),
                axis.tickangle.x = isolate(input$axis.tickangle.x),
                axis.tickangle.y = isolate(input$axis.tickangle.y),
                axis.ticks = isolate(input$axis.ticks),
                axis.tickcolor = isolate(input$axis.tickcolor),
                axis.ticklen = isolate(input$axis.ticklen),
                axis.tickwidth = isolate(input$axis.tickwidth),
                title.font.size = isolate(input$title.font.size),
                title.font.family = isolate(input$font.type),
                title.text.color = isolate(input$text.colour),
                axis.range.x = c(axis_min_x, axis_max_x),
                axis.range.y = c(axis_min_y, axis_max_y),
                x.title = x_title,
                y.title = y_title,
                flip.x = flip_x,
                flip.y = flip_y,
                x.adjustment = x.adjustment,
                y.adjustment = y.adjustment,
                x.input = x_input,
                y.input = y_input
            )


            # If multiple X and Y variables are selected:
            # ADDs lines to the plot
            if (xor(length(x_input) > 1, length(y_input) > 1)) {
                if (length(x_input) > 1) {
                    fig <- fig |> add_trace(
                        x = reformulate(isolate(x_input[1])),
                        y = reformulate(isolate(y_input[1])),
                        mode = input$plot.type,
                        line = list(dash = input$line.type),
                        name = x_input[1],
                        showlegend = TRUE
                    )
                    updateSwitchInput(session, "order.by", value = FALSE) # So that the graph is ordered by the axis that has multiple data sets / columns
                    for (i in 2:length(x_input)) {
                        d_sorted <- d[order(d[[order_by[i]]]), ]
                        fig <- fig |> add_trace(
                            x = d_sorted[[x_input[i]]],
                            y = d_sorted[[y_input[1]]],
                            type = "scatter",
                            mode = input$plot.type,
                            line = list(dash = input$line.type),
                            color = plotthis::palette_list[[input$palette]][i],
                            name = x_input[i],
                            showlegend = TRUE
                        )
                        axis_max_x <- max(d[, x_input])
                        axis_min_x <- min(d[, x_input])
                    }
                }
                if (length(y_input) > 1) {
                    fig <- fig |> add_trace(
                        x = reformulate(isolate(x_input[1])),
                        y = reformulate(isolate(y_input[1])),
                        mode = input$plot.type,
                        line = list(dash = input$line.type),
                        name = y_input[1],
                        showlegend = TRUE
                    )
                    updateSwitchInput(session, "order.by", value = TRUE) # So that the graph is ordered by the axis that has multiple data sets / columns
                    for (i in 2:length(y_input)) {
                        d_sorted <- d[order(d[[order_by[i]]]), ]
                        fig <- fig |> add_trace(
                            x = d_sorted[[x_input[1]]],
                            y = d_sorted[[y_input[i]]],
                            type = "scatter",
                            mode = input$plot.type,
                            line = list(dash = input$line.type),
                            color = plotthis::palette_list[[input$palette]][i],
                            name = y_input[i],
                            showlegend = TRUE
                        )
                        axis_max_y <- max(d[, y_input])
                        axis_min_y <- min(d[, y_input])
                    }
                }
            }


            fig <- fig |>
                config(
                    editable = TRUE,
                    edits = list(
                        titleText = TRUE,
                        axisTitleText = TRUE
                    ),
                    toImageButtonOptions = list(
                        format = isolate(input$download.type),
                        filename = "line_plot", height = 600, width = 700, scale = 1
                    ),
                    displaylogo = FALSE
                ) # Hiding Plotly Logo

            return(fig)
        })
    })
}
