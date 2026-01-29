#' Server logic for SplitBarPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#'
#' @return The `moduleServer` function for the SplitBarPlot module.
#'
#' @import shiny
#' @importFrom shinyjs hide
#' @importFrom plotly ggplotly
#'
#' @seealso [plotthis::SplitBarPlot()], [VizModules::organize_inputs()],
#' [VizModules::plotthis_SplitBarPlotInputsUI()], [VizModules::plotthis_SplitBarPlotOutputUI()],
#' [VizModules::plotthis_SplitBarPlotApp()]
#'
#' @export
#' @author Jacob Martin
plotthis_SplitBarPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Constant for y-axis scaling to ensure highest bar reaches ~85% of chart height
        y_axis_scale_factor <- 1.18
        
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
                    max.y <- max(agg_data$x, na.rm = TRUE) * y_axis_scale_factor
                }, error = function(e) {
                    # If aggregation fails, fall back to simple max
                    max.y <<- max(df[[y_data_col]], na.rm = TRUE) * y_axis_scale_factor
                })
            } else {
                # No grouping, just use max of y column
                max.y <- max(df[[y_data_col]], na.rm = TRUE) * y_axis_scale_factor
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
                hideTab(inputId = "SplitBarPlotTabsetPanel", target = tab.name)
            })
        }

        ns <- session$ns
        default_palette_name <- "dittoColors"
        palette_lookup <- .flatten_palette_options(default_palettes()[["choices"]])
        default_palette_values <- palette_lookup[[default_palette_name]]
        if (is.null(default_palette_values) || length(default_palette_values) == 0) {
            default_palette_values <- if (length(palette_lookup) > 0) palette_lookup[[1]] else character(0)
        }

        palette_groups <- reactive({
            df <- data()
            if (is.null(df)) {
                return(character(0))
            }

            fill_col <- input$fill.by
            y_col <- input$y.data

            if (!is.null(fill_col) && nzchar(fill_col) && fill_col %in% names(df)) {
                unique(stats::na.omit(as.character(df[[fill_col]])))
            } else if (!is.null(y_col) && nzchar(y_col) && y_col %in% names(df)) {
                unique(stats::na.omit(as.character(df[[y_col]])))
            } else {
                character(0)
            }
        })

        # Track initialization
        initialized <- reactiveVal(FALSE)

        output$palette.selection <- renderUI({
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

        # Initialize y-axis range on startup
        observe({
            # Only run once when inputs are first available
            if (!initialized()) {
                # Only require y.data, other inputs can be empty
                req(input$y.data)
                
                # Wait a moment for other inputs to be available
                if (!is.null(input$y.data) && input$y.data != "") {
                    y_range <- calculate_y_range(input$y.data, input$x.data, input$fill.by)
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
            # Trigger on changes to y.data, x.data, or fill.by
            y_col <- input$y.data
            x_col <- input$x.data
            fill_col <- input$fill.by
            
            # Skip if we haven't initialized yet or y.data is not set
            if (!initialized() || is.null(y_col) || y_col == "") {
                return()
            }
            
            # Only auto-update if auto.update is enabled
            if (!is.null(input$auto.update) && input$auto.update) {
                y_range <- calculate_y_range(y_col, x_col, fill_col)
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
                max.y <- max(numeric.data, na.rm = TRUE) * y_axis_scale_factor
            }
            # Reset numeric inputs to defaults derived from data

            # Data
            # Data Section
            updateSelectInput(session, "x.data", selected = num.choices[2])
            updateSelectInput(session, "y.data", selected = char.choices[2])
            updateSelectInput(session, "fill.by", selected = char.choices[2])

            # Facet Section
            updateSelectInput(session, "facet.by", selected = "")
            updateSelectInput(session, "facet.scale", selected = "free_y")
            updateNumericInput(session, "facet.ncol", value = NA) # Using NA for NULL in numericInput
            updateNumericInput(session, "facet.nrow", value = NA)
            updateMaterialSwitch(session, "facet.by.row", value = TRUE)
            updateSelectInput(session, "split.by", selected = "")
          #Aesthetics
            updateSelectInput(session, "theme", selected = "theme_this")
            updateSelectInput(session, "alpha.by", selected = "")
            updateMaterialSwitch(session, "alpha.reverse", value = FALSE)
            updateTextInput(session, "alpha.name", value = "")
            updateNumericInput(session, "bar.height", value = 0.9)
            updateNumericInput(session, "line.height", value = 0.5)
            # Axes
            updateMaterialSwitch(session, "flip", value = FALSE)
            updateNumericInput(session, "x.max", value = max.y)
            updateNumericInput(session, "x.min", value = min.y)

            updateSelectInput(session, "font.type", selected = "Arial")
            updateNumericInput(session, "axis.font.size", value = 18)
            updateNumericInput(session, "title.font.size", value = 28)
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")

            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror", value = TRUE)
            updateCheckboxInput(session, "show.major.grid.x", value = TRUE)
            updateCheckboxInput(session, "show.major.grid.y", value = TRUE)
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

            # Action Button (unchanged)
            updateSelectInput(session, "download.type", selected = "png")

            # Lines
            updateTextInput(session, "hline.intercepts", value = "")
            updateTextInput(session, "hline.colors", value = "#000000")
            updateTextInput(session, "hline.widths", value = "1")
            updateTextInput(session, "hline.linetypes", value = "dashed")
            updateTextInput(session, "hline.opacities", value = "1")
            updateTextInput(session, "vline.intercepts", value = "")
            updateTextInput(session, "vline.colors", value = "#000000")
            updateTextInput(session, "vline.widths", value = "1")
            updateTextInput(session, "vline.linetypes", value = "dashed")
            updateTextInput(session, "vline.opacities", value = "1")
            updateTextInput(session, "abline.slopes", value = "")
            updateTextInput(session, "abline.intercepts", value = "")
            updateTextInput(session, "abline.colors", value = "#000000")
            updateTextInput(session, "abline.widths", value = "1")
            updateTextInput(session, "abline.linetypes", value = "dashed")
            updateTextInput(session, "abline.opacities", value = "1")

        })

        # Update y-axis range when y data column is changed (when auto-update is off)
        observeEvent(input$y.data, {
            y_range <- calculate_y_range(input$y.data, input$x.data, input$fill.by)
            if (!is.null(y_range)) {
                updateNumericInput(session, "y.max", value = y_range$max)
                updateNumericInput(session, "y.min", value = y_range$min)
            }
        })


        output$SplitBarPlot <- renderPlotly({
            isolate_fn <- setup_auto_update_logic(input)

            # Null Values:
            facet.by <- NULL
            if (!isolate_fn(input$facet.by) == "") {
                facet.by <- isolate_fn(input$facet.by)
            }

            split.by <- NULL
            if (!isolate_fn(input$split.by) == "") {
                split.by <- isolate_fn(input$split.by)
            }
            fill.by <- NULL
            if (!isolate_fn(input$fill.by) == ""){
                fill.by <- isolate_fn(input$fill.by)
            }

            # Convert NA to NULL for facet.ncol and facet.nrow
            facet.ncol <- .na_to_null(isolate_fn(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate_fn(input$facet.nrow))
            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours),
                default_palette_values
            )
            alpha.by <- NULL
            if (!isolate_fn(input$alpha.by) == ""){
              alpha.by <- isolate_fn(input$alpha.by)
            }
          
          
            # bar Plot
            p <- plotthis::SplitBarPlot(
                data(),
                x = isolate_fn(input$x.data),
                y = isolate_fn(input$y.data),
                flip = isolate_fn(input$flip),
                fill_by = fill.by,
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate_fn(input$facet.by.row),
                palette = default_palette_name,
                palcolor = unname(palette_values),
                x_min = isolate_fn(input$x.min),
                x_max = isolate_fn(input$x.max),
                theme = isolate_fn(input$theme),
                alpha_by  = alpha.by,
                alpha_reverse = isolate_fn(input$alpha.reverse),
                alpha_name = isolate_fn(input$alpha.name),
                split_by = split.by,
                bar_height = isolate_fn(input$bar.height),
                lineheight = isolate_fn(input$line.height)
            )
            fig <- ggplotly(p) |>
                layout(
                    title = list(
                        font = list(size = isolate_fn(input$title.font.size), family = isolate_fn(input$font.type), color = isolate_fn(input$text.colour)),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    )
                )

            # Apply axis styling to all subplot axes (handles faceting/split_by)
            xaxis_style <- .create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn)
            yaxis_style <- .create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn)

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

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

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), include.modebar.buttons = TRUE, facet.by = facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })

        # Render the plot output
        output$splitBarPlot <- renderPlotly({
            generate_splitbarplot()
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot = generate_splitbarplot(),
            filename_base = "splitbarplot"
        )
    })
}
