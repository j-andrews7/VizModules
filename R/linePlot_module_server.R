#' Server logic for linePlot module
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the linePlot module.
#'
#' @importFrom shinyjs hide
#'
#' @seealso [vizModules::linePlot()], [vizModules::organize_inputs()],
#' [vizModules::linePlotOutputUI()], [vizModules::linePlotServer()], [vizModules::linePlotApp()]
#'
#' @export
#' @author Jacob Martin
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

        # Reset functionality
        observeEvent(input$reset, {
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
            updateSelectInput(session, "facet.scales", selected = "fixed")

            # Axes:
            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror",  value = TRUE)
            colourpicker::updateColourInput(session, "axis.linecolor", value = "black")
            updateNumericInput(session, "axis.linewidth", value = 0.5)
            updateNumericInput(session, "axis.tickfont.size", value = 12)
            colourpicker::updateColourInput(session, "axis.tickfont.color", value = "black")
            updateSelectInput(session, "axis.tickfont.family", selected = "Arial")
            updateNumericInput(session, "axis.tickangle.x", value = 0)
            updateNumericInput(session, "axis.tickangle.y", value = 0)
            updateSelectInput(session, "axis.ticks", selected = "outside")
            colourpicker::updateColourInput(session, "axis.tickcolor", value = "black")
            updateNumericInput(session, "axis.ticklen", value = 5)
            updateNumericInput(session, "axis.tickwidth", value = 1)
        })


        output$linePlot <- renderPlotly({
            input$update

            d <- data_reactive()

            x_input <- input$x.value
            y_input <- input$y.value

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

            if (is.numeric(d[, x_input])) {
                d <- d[do.call(order, d[, order_by, drop = FALSE]), ]
            }

            if (is.numeric(d[, y_input])) {
                d <- d[do.call(order, d[, order_by, drop = FALSE]), ]
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

            y.adjustment <- NULL
            if (!input$y.adjustment == "") {
                y.adjustment <- input$y.adjustment
            }

            x.adjustment <- NULL
            if (!input$x.adjustment == "") {
                x.adjustment <- input$x.adjustment
            }

            # Checking that all columns are numeric for x and y adjustment to be available
            if (!all(sapply(d[x_input], is.numeric))) {
                updateSelectInput(session, "x.adjustment", selected = "")
                x.adjustment <- NULL
            }
            if (!all(sapply(d[y_input], is.numeric))) {
                updateSelectInput(session, "y.adjustment", selected = "")
                y.adjustment <- NULL
            }

            fig <- linePlot(
                reactive.data = d,
                x = x_input,
                y = y_input,
                plot.mode = isolate(input$plot.type),
                line.type = isolate(input$line.type),
                colour.group.by = group.by,
                palette.selection = plotthis::palette_list[[input$palette]],
                show.legend = FALSE,
                facet.by = input$facet.by,
                facet.scales = isolate(input$facet.scales),
                order.by = order_by,
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
                x.title = x_title,
                y.title = y_title,
                flip.x = isolate(input$flip.x),
                flip.y = isolate(input$flip.y),
                x.adjustment = x.adjustment,
                y.adjustment = y.adjustment
            )

            config_list <- .add_plot_config(download.format = isolate(input$download.type), include.modebar.buttons = FALSE, facet.by = input$facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })
    })
}
