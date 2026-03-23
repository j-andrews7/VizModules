#' Server logic for linePlot module
#'
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
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#'
#' @seealso [VizModules::linePlot()], [VizModules::linePlotInputsUI()],
#' [VizModules::linePlotOutputUI()], [VizModules::linePlotApp()]
#'
#' @export
#' @author Jacob Martin
linePlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))
    data_reactive <- data
    

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if specified
        
        observeEvent(input$x.value, {
            if (length(input$x.value) > 1 || is.numeric(data()[[input$x.value]])) {
                hide("errorBarWidth")
                hide("errorBarColour")
                hide("errorBar")
            } else {
                show("errorBar")
                show("errorBarWidth")
                show("errorBarColour")
            }
        }) 



        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "linePlotTabsetPanel", target = tab.name)
        }

        
        default_palette_name <- "dittoColors"
        palette_lookup <- .flatten_palette_options(default_palettes()[["choices"]])
        default_palette_values <- palette_lookup[[default_palette_name]]
        if (is.null(default_palette_values) || length(default_palette_values) == 0) {
            default_palette_values <- if (length(palette_lookup) > 0) palette_lookup[[1]] else character(0)
        }

        palette_groups <- reactive({
            df <- data_reactive()
            if (is.null(df)) {
                return(character(0))
            }

            x_vals <- input$x.value
            y_vals <- input$y.value
            group_col <- input$group.by
            multi_axis <- xor(length(x_vals) > 1, length(y_vals) > 1)

            if (multi_axis) {
                if (length(x_vals) > 1) {
                    return(x_vals)
                }
                if (length(y_vals) > 1) {
                    return(y_vals)
                }
            }

            if (!is.null(group_col) && nzchar(group_col) && group_col %in% names(df)) {
                return(unique(stats::na.omit(as.character(df[[group_col]]))))
            }

            if (!is.null(x_vals) && length(x_vals) > 0) {
                return(x_vals[1])
            }

            if (!is.null(y_vals) && length(y_vals) > 0) {
                return(y_vals[1])
            }

            character(0)
        })

        output$palette.selection <- renderUI({
            ns <- session$ns
            groups <- palette_groups()
            if (length(groups) == 0) {
                return(NULL)
            }

            initial_colors <- isolate(resolve_palette(groups, input$palette.colours, default_palette_values))

            multiColorPicker(
                ns("palette.colours"),
                label = "Plot colors",
                groups = groups,
                palette_options = default_palettes()[["choices"]],
                selected_palette = default_palette_name,
                colors = initial_colors,
                compact = TRUE
            )
        })

        # Reset functionality
        observeEvent(input$reset, {
            # Reset Data columns to default. First and second index of data named list
            updateSelectInput(session, "x.value", selected = names(data())[1])
            updateSelectInput(session, "y.value", selected = names(data())[2])
            updateSelectInput(session, "plot.type", selected = "lines")
            updateSelectInput(session, "line.type", selected = "solid")
            updateMaterialSwitch(session, "order.by", value = FALSE)
            updateMaterialSwitch(session, "flip.x", value = FALSE)
            updateMaterialSwitch(session, "flip.y", value = FALSE)
            updateSelectInput(session, "group.by", selected = "")
            updateSelectInput(session, "facet.by", selected = "")
            updateSelectInput(session, "facet.scales", selected = "fixed")
            updateSelectInput(session, "x.adjustment", selected = "")
            updateSelectInput(session, "y.adjustment", selected = "")
            updateMaterialSwitch(session, "errorBar", value = TRUE)
            updateNumericInput(session, "errorBarWidth", value = 1)
            colourpicker::updateColourInput(session, "errorBarColour", value = "#000000")

            # Axes
            .reset_axes_inputs(session)

            # Plotly
            .reset_plotly_inputs(session)

            # Lines
            .reset_lines_inputs(session)
        })


        # Reactive expression to generate the plot (used by both output and download)
        generate_linePlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            d <- data_reactive()

            x_input <- isolate_fn(input$x.value)
            y_input <- isolate_fn(input$y.value)

            # Sets the colouring to the first item in the selected palette unless group.by is selected
            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours),
                default_palette_values
            )
            palette_selection <- unname(palette_values)
            if (is.null(palette_selection) || length(palette_selection) == 0) {
                palette_selection <- default_palette_values
            }

            group.by <- palette_selection[1]
            show_legend <- FALSE
            if (isolate_fn(input$group.by) != "" && length(x_input) == 1 && length(y_input) == 1) {
                group.by <- reformulate(isolate_fn(input$group.by))
                show_legend <- TRUE
            } else if (length(x_input) > 1 || length(y_input) > 1) {
                show_legend <- TRUE
            }

            # Making multiple lines on the axis. e.g 3x and 1y
            # Determining axis min and max
            # Checking if the axis is a category and non continious
            # And axis ordering
            axis_min_x <- NULL
            axis_max_x <- NULL

            # Choosing which axis to order by:
            order_by <- x_input
            if (isolate_fn(input$order.by)) {
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
            if (!isolate_fn(input$y.adjustment) == "") {
                y.adjustment <- isolate_fn(input$y.adjustment)
            }

            x.adjustment <- NULL
            if (!isolate_fn(input$x.adjustment) == "") {
                x.adjustment <- isolate_fn(input$x.adjustment)
            }

            # Checking that all columns are numeric for x and y adjustment to be available
            if (!all(vapply(d[x_input], is.numeric, logical(1)))) {
                updateSelectInput(session, "x.adjustment", selected = "")
                x.adjustment <- NULL
            }
            if (!all(vapply(d[y_input], is.numeric, logical(1)))) {
                updateSelectInput(session, "y.adjustment", selected = "")
                y.adjustment <- NULL
            }
            facet.by <- NULL 
            if (!isolate_fn(input$facet.by) == ""){
                facet.by <- isolate_fn(input$facet.by)
            }
            fig <- linePlot(
                data = d,
                x = x_input,
                y = y_input,
                plot.mode = isolate_fn(input$plot.type),
                line.type = isolate_fn(input$line.type),
                colour.group.by = group.by,
                palette.selection = palette_selection,
                show.legend = show_legend,
                facet.by = isolate_fn(input$facet.by),
                facet.scales = isolate_fn(input$facet.scales),
                subplot.margin = isolate_fn(input$subplot.margin),
                order.by = order_by,
                axis.showline = isolate_fn(input$axis.showline),
                axis.mirror = isolate_fn(input$axis.mirror),
                axis.linecolor = isolate_fn(input$axis.linecolor),
                axis.linewidth = isolate_fn(input$axis.linewidth),
                axis.tickfont.size = isolate_fn(input$axis.tickfont.size),
                axis.tickfont.color = isolate_fn(input$axis.tickfont.color),
                axis.tickfont.family = isolate_fn(input$axis.tickfont.family),
                axis.tickangle.x = isolate_fn(input$axis.tickangle.x),
                axis.tickangle.y = isolate_fn(input$axis.tickangle.y),
                axis.ticks = isolate_fn(input$axis.ticks),
                axis.tickcolor = isolate_fn(input$axis.tickcolor),
                axis.ticklen = isolate_fn(input$axis.ticklen),
                axis.tickwidth = isolate_fn(input$axis.tickwidth),
                show.grid.x = isolate_fn(input$show.grid.x),
                show.grid.y = isolate_fn(input$show.grid.y),
                title.font.size = isolate_fn(input$title.font.size),
                title.font.family = isolate_fn(input$title.font.family),
                title.text.color = isolate_fn(input$text.colour),
                x.title = x_title,
                y.title = y_title,
                flip.x = isolate_fn(input$flip.x),
                flip.y = isolate_fn(input$flip.y),
                x.adjustment = x.adjustment,
                y.adjustment = y.adjustment, 
                error.colour = isolate_fn(input$errorBarColour),
                error.width = isolate_fn(input$errorBarWidth),
                error.bar = isolate_fn(input$errorBar)
            )

            # Add reference lines
            fig <- .add_reference_lines(fig,
                hline.intercepts = isolate_fn(input$hline.intercepts),
                hline.colors = isolate_fn(input$hline.colors),
                hline.widths = isolate_fn(input$hline.widths),
                hline.linetypes = isolate_fn(input$hline.linetypes),
                hline.opacities = isolate_fn(input$hline.opacities),
                vline.intercepts = isolate_fn(input$vline.intercepts),
                vline.colors = isolate_fn(input$vline.colors),
                vline.widths = isolate_fn(input$vline.widths),
                vline.linetypes = isolate_fn(input$vline.linetypes),
                vline.opacities = isolate_fn(input$vline.opacities),
                abline.slopes = isolate_fn(input$abline.slopes),
                abline.intercepts = isolate_fn(input$abline.intercepts),
                abline.colors = isolate_fn(input$abline.colors),
                abline.widths = isolate_fn(input$abline.widths),
                abline.linetypes = isolate_fn(input$abline.linetypes),
                abline.opacities = isolate_fn(input$abline.opacities)
            )

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = FALSE, facet.by = facet.by)
            fig <- do.call(plotly::config, c(list(p = fig), config_list))
            fig <- .apply_plotly_newshape(fig, input, isolate_fn)

            return(fig)
        })

        # Render the plot output
        output$linePlot <- renderPlotly({
            
            d <- data_reactive()
            x_input <- input$x.value
            y_input <- input$y.value


            # Section is for catching errors and displaying an empty plot with a warning message if any error conditions are met.
            #Ensures a clean method for dealing with errors and instructing the user on next steps to resolve the issue 
            #Error Prone conditions
            x_is_cat <- length(x_input) == 1 && nzchar(x_input) && !is.numeric(d[[x_input]])
            y_is_cat <- length(y_input) == 1 && nzchar(y_input) && !is.numeric(d[[y_input]])
            x_not_0 <- length(x_input) == 0
            y_not_0 <- length(y_input) == 0
            multi_axis <- xor(length(x_input) > 1, length(y_input) > 1)
            dual_multiAxis <- length(x_input) > 1 && length(y_input) > 1
            x_pure <- is_pure_type(c(x_input), d)
            y_pure <- is_pure_type(c(y_input), d)

            return_empty <- FALSE
            txt <- c()

            

            if (x_is_cat && y_is_cat) {
                return_empty <- TRUE
                txt <- c(txt, "X and Y categories cannot both be discrete data types")
            } else if (x_not_0 || y_not_0){
                return_empty <- TRUE
                txt <- c(txt, "Both X and Y variable inputs must not be empty. Please select a variable input.")
            } else if (!x_pure || !y_pure){
                return_empty <- TRUE
                txt <- c(txt, "Cant have a discrete and non discrete data input on the same axis.")
            } else if (dual_multiAxis) {
                return_empty <- TRUE
                txt <- c(txt, "You cannot have multiple inputs for both X and Y inputs simultaneously")
            } else if (multi_axis && !(input$group.by == "")){
                return_empty <- TRUE
                txt <- c(txt, "You cannot have multiple inputs on x and y axis and group by at the same time")
            }
            if (return_empty){
                fig <- .empty_plot(text = txt, plotly = TRUE)
            } else {
                fig <- generate_linePlot() |>
                    layout(
                        margin = list(t = input$margin.t, b = input$margin.b, l = input$margin.l, r = input$margin.r, autoexpand = TRUE)
                    )
            }

            return(fig)
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_linePlot,
            filename_base = "linePlot"
        )
    })
}
