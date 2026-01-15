#' Server logic for BarPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the BarPlot module.
#'
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateSwitchInput
#'
#' @export
#' @author Jacob Martin, Jared Andrews
BarPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Constant for y-axis scaling to ensure highest bar reaches ~85% of chart height
        Y_AXIS_SCALE_FACTOR <- 1.18
        
        # Helper function to calculate y-axis range accounting for grouping/stacking
        calculate_y_range <- function(y_data_col, x_data_col = NULL, group_data_col = NULL) {
            if (is.null(y_data_col) || y_data_col == "") {
                return(NULL)
            }
            
            df <- data()
            if (!y_data_col %in% names(df) || !is.numeric(df[[y_data_col]])) {
                return(NULL)
            }
            
            # Calculate min from raw data
            min.y <- min(df[[y_data_col]], na.rm = TRUE)
            
            # For max, we need to consider if bars might be stacked
            # If there's grouping by x and group_by, bars could be stacked
            if (!is.null(x_data_col) && x_data_col != "" && x_data_col %in% names(df) &&
                !is.null(group_data_col) && group_data_col != "" && group_data_col %in% names(df)) {
                # Calculate sum of y values for each x group (worst case for stacked bars)
                tryCatch({
                    agg_data <- aggregate(df[[y_data_col]], 
                                         by = list(x = df[[x_data_col]]), 
                                         FUN = sum, na.rm = TRUE)
                    max.y <- max(agg_data$x, na.rm = TRUE) * Y_AXIS_SCALE_FACTOR
                }, error = function(e) {
                    # If aggregation fails, fall back to simple max
                    max.y <<- max(df[[y_data_col]], na.rm = TRUE) * Y_AXIS_SCALE_FACTOR
                })
            } else {
                # No grouping, just use max of y column
                max.y <- max(df[[y_data_col]], na.rm = TRUE) * Y_AXIS_SCALE_FACTOR
            }
            
            # Handle edge cases
            if (!is.finite(min.y)) min.y <- 0
            if (!is.finite(max.y)) max.y <- 1
            
            return(list(min = min.y, max = max.y))
        }
        
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            lapply(hide.inputs, function(input.name) {
                hide(input.name)
            })
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            lapply(hide.tabs, function(tab.name) {
                hideTab(inputId = "BarPlotTabsetPanel", target = tab.name)
            })
        }

        ns <- session$ns
        
        # Track initialization
        initialized <- reactiveVal(FALSE)
        
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

        # Initialize y-axis range on startup
        observe({
            # Only run once when inputs are first available
            if (!initialized()) {
                # Only require y.data, other inputs can be empty
                req(input$y.data)
                
                # Wait a moment for other inputs to be available
                if (!is.null(input$y.data) && input$y.data != "") {
                    y_range <- calculate_y_range(input$y.data, input$x.data, input$group.by)
                    if (!is.null(y_range)) {
                        updateNumericInput(session, "y.max", value = y_range$max)
                        updateNumericInput(session, "y.min", value = y_range$min)
                        initialized(TRUE)
                    }
                }
            }
        })

        # Auto-update y-axis range when relevant inputs change
        observe({
            # Trigger on changes to y.data, x.data, or group.by
            y_col <- input$y.data
            x_col <- input$x.data
            group_col <- input$group.by
            
            # Skip if we haven't initialized yet or y.data is not set
            if (!initialized() || is.null(y_col) || y_col == "") {
                return()
            }
            
            # Only auto-update if auto.update is enabled
            if (!is.null(input$auto.update) && input$auto.update) {
                y_range <- calculate_y_range(y_col, x_col, group_col)
                if (!is.null(y_range)) {
                    updateNumericInput(session, "y.max", value = y_range$max)
                    updateNumericInput(session, "y.min", value = y_range$min)
                }
            }
        })

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])
            num.choices <- c("", names(data())[unlist(lapply(data(), is.numeric), use.names = FALSE)])
            
            # Calculate y.max and y.min from the default selections
            default_y_col <- if (length(num.choices) >= 2) num.choices[2] else NULL
            default_x_col <- if (length(char.choices) >= 2) char.choices[2] else NULL
            default_group_col <- if (length(char.choices) >= 2) char.choices[2] else NULL
            
            y_range <- calculate_y_range(default_y_col, default_x_col, default_group_col)
            if (!is.null(y_range)) {
                min.y <- y_range$min
                max.y <- y_range$max
            } else {
                # Fallback to all numeric data if no default column
                min.y <- min(numeric.data, na.rm = TRUE)
                max.y <- max(numeric.data, na.rm = TRUE) * Y_AXIS_SCALE_FACTOR
            }
            # Reset numeric inputs to defaults derived from data

            # Data
            updateSelectInput(session, "x.data", selected = char.choices[2])
            updateSelectInput(session, "y.data", selected = default_y_col)
            updateSwitchInput(session, "flip", value = FALSE)
            updateNumericInput(session, "y.max", value = max.y)
            updateNumericInput(session, "y.min", value = min.y)

            # Grouping
            updateSelectInput(session, "group.by", selected = char.choices[2])
            updateSelectInput(session, "facet.by", selected = "NULL")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateSwitchInput(session, "facet.by.row", value = TRUE)
            updateSelectInput(session, "split.by", selected = "NULL")

            # Aesthetics
            updateSelectInput(session, "palette", selected = "Set2")
            updateSwitchInput(session, "background.colour", value = FALSE)
            updateSelectInput(session, "background.palette", selected = "Set2")
            updateNumericInput(session, "background.alpha", value = 0.5)
            updateSelectInput(session, "theme", selected = "theme_this")
            updateNumericInput(session, "alpha", value = 1)
            updateNumericInput(session, "width", value = NA)
            updateTextInput(session, "expand", value = "")

            # Line
            updateNumericInput(session, "add.line", value = NA)
            colourpicker::updateColourInput(session, "line.colour", value = "#000000")
            updateNumericInput(session, "line.type", value = 2)
            updateNumericInput(session, "line.width", value = 0.6)
            updateTextInput(session, "line.name", value = "")

            # Labels
            updateSelectInput(session, "font.type", selected = "Arial")
            updateNumericInput(session, "axis.font.size", value = 18)
            updateNumericInput(session, "title.font.size", value = 28)
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
            # Action Button:
            updateSelectInput(session, "download.type", selected = "png")

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

        # Update y-axis range when update button is clicked (when auto-update is off)
        observeEvent(input$update, {
            y_range <- calculate_y_range(input$y.data, input$x.data, input$group.by)
            if (!is.null(y_range)) {
                updateNumericInput(session, "y.max", value = y_range$max)
                updateNumericInput(session, "y.min", value = y_range$min)
            }
        })


        output$BarPlot <- renderPlotly({
            # Check if auto update on
            auto_update <- input$auto.update

            # If update button is required, add dependency on it
            if (!auto_update) {
                input$update
            }

            # Set up wrapper function based on switch state
            isolate_fn <- if (auto_update) identity else isolate

            # Null Values:
            facet.by <- NULL
            if (!isolate_fn(input$facet.by) == "NULL") {
                facet.by <- isolate_fn(input$facet.by)
            }
            line.name <- .na_to_null(isolate_fn(input$line.name))
            expand <- waiver()
            expand.input <- .na_to_null(isolate_fn(input$expand))
            if (!is.null(expand.input)) {
                expand <- as.numeric(strsplit(expand.input, ",\\s*")[[1]])
            }
            if (!is.na(isolate_fn(input$width))) {
                width <- isolate_fn(input$width)
            } else {
                width <- waiver()
            }
            split.by <- NULL
            if (!isolate_fn(input$split.by) == "NULL") {
                split.by <- isolate_fn(input$split.by)
            }
            group.by <- NULL
            if (!isolate_fn(input$group.by) == ""){
                group.by <- isolate_fn(input$group.by)
            }

            # Convert NA to NULL for facet.ncol and facet.nrow
            facet.ncol <- .na_to_null(isolate_fn(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate_fn(input$facet.nrow))

            # bar Plot
            p <- plotthis::BarPlot(
                data(),
                x = isolate_fn(input$x.data),
                y = isolate_fn(input$y.data),
                flip = isolate_fn(input$flip),
                group_by = group.by,
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate_fn(input$facet.by.row),
                palette = isolate_fn(input$palette),
                palcolor = isolate_fn(input$palette.colours),
                add_bg = isolate_fn(input$background.colour),
                bg_palette = isolate_fn(input$background.palette),
                bg_alpha = isolate_fn(input$background.alpha),
                y_min = input$y.min,  # Don't isolate - needs to be reactive for update button
                y_max = input$y.max,  # Don't isolate - needs to be reactive for update button
                theme = isolate_fn(input$theme),
                alpha = isolate_fn(input$alpha),
                add_line = isolate_fn(input$add.line),
                line_color = isolate_fn(input$line.colour),
                line_width = isolate_fn(input$line.width),
                line_type = isolate_fn(input$line.type),
                line_name = line.name,
                fill_by_x_if_no_group = TRUE,
                expand = expand,
                width = width,
                split_by = split.by
            )
            fig <- ggplotly(p) |>
                layout(
                    title = list(
                        font = list(size = isolate_fn(input$title.font.size), family = isolate_fn(input$font.type), color = isolate_fn(input$text.colour)),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    )
                )

            # Apply axis styling to all subplot axes (handles faceting/split_by)
            xaxis_style <- .create_axis_styles(input, axis_side = "x")
            yaxis_style <- .create_axis_styles(input, axis_side = "y")

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), include.modebar.buttons = TRUE, facet.by = facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })
    })
}
