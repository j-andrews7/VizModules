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
        default_palette_name <- "Paired"
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

        resolve_palette <- function(groups, selected_colors = NULL) {
            if (length(groups) == 0) {
                return(NULL)
            }

            colors <- selected_colors
            if (is.null(colors) || length(colors) == 0) {
                colors <- default_palette_values
            }

            if (!is.null(names(colors)) && any(nzchar(names(colors)))) {
                colors <- colors[match(groups, names(colors))]
            }

            if (any(is.na(colors))) {
                na_idx <- which(is.na(colors))
                fallback <- if (length(default_palette_values) > 0) default_palette_values else "#000000"
                colors[na_idx] <- rep_len(fallback, length(na_idx))
            }

            colors <- rep_len(colors, length(groups))
            stats::setNames(colors[seq_along(groups)], groups)
        }

        output$palette.selection <- renderUI({
            groups <- palette_groups()
            if (length(groups) == 0) {
                return(NULL)
            }

            initial_colors <- isolate(resolve_palette(groups, input$palette.colours))

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
            updateSwitchInput(session, "order.by", value = FALSE)
            updateSwitchInput(session, "flip.x", value = FALSE)
            updateSwitchInput(session, "flip.y", value = FALSE)
            updateSelectInput(session, "group.by", selected = "")
            updateSelectInput(session, "facet.by", selected = "")
            updateSelectInput(session, "facet.scales", selected = "fixed")

            # Axes:
            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror", value = TRUE)
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
            # Check if auto update on
            auto_update <- input$auto.update

            # If update button is required, add dependency on it
            if (!auto_update) {
                input$update
            }

            # Set up wrapper function based on switch state
            isolate_fn <- if (auto_update) identity else isolate

            d <- data_reactive()

            x_input <- isolate_fn(input$x.value)
            y_input <- isolate_fn(input$y.value)

            # Sets the colouring to the first item in the selected palette unless group.by is selected
            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours)
            )
            palette_selection <- unname(palette_values)
            if (is.null(palette_selection) || length(palette_selection) == 0) {
                palette_selection <- default_palette_values
            }

            group.by <- palette_selection[1]
            if (!isolate_fn(input$group.by) == "" && length(x_input) == 1 && length(y_input) == 1) {
                group.by <- reformulate(isolate_fn(input$group.by))
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
            # TODO: remove sapply usage here
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
                plot.mode = isolate_fn(input$plot.type),
                line.type = isolate_fn(input$line.type),
                colour.group.by = group.by,
                palette.selection = palette_selection,
                show.legend = FALSE,
                facet.by = isolate_fn(input$facet.by),
                facet.scales = isolate_fn(input$facet.scales),
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
                title.font.size = isolate_fn(input$title.font.size),
                title.font.family = isolate_fn(input$font.type),
                title.text.color = isolate_fn(input$text.colour),
                x.title = x_title,
                y.title = y_title,
                flip.x = isolate_fn(input$flip.x),
                flip.y = isolate_fn(input$flip.y),
                x.adjustment = x.adjustment,
                y.adjustment = y.adjustment
            )

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), include.modebar.buttons = FALSE, facet.by = input$facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })
    })
}
