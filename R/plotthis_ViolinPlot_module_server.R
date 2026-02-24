#' Server logic for ViolinPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the ViolinPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom plotthis ViolinPlot
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @export
#' @author Jacob Martin, Jared Andrews
plotthis_ViolinPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "ViolinPlotTabsetPanel", target = tab.name)
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

            group_col <- input$group.by
            x_col <- input$x.data

            if (!is.null(group_col) && nzchar(group_col) && group_col != "NULL" && group_col %in% names(df)) {
                unique(stats::na.omit(as.character(df[[group_col]])))
            } else if (!is.null(x_col) && nzchar(x_col) && x_col %in% names(df)) {
                unique(stats::na.omit(as.character(df[[x_col]])))
            } else {
                character(0)
            }
        })

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

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])
            num.choices <- c("", names(data())[unlist(lapply(data(), is.numeric), use.names = FALSE)])
            
            # Calculate y.max and y.min from the default selections
            max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * 1.11 
            min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)
            # Reset numeric inputs to defaults derived from data

            # Data
            updateSelectInput(session, "group.by", selected = "NULL")
            updateSelectInput(session, "x.data", selected = char.choices[2])
            updateSelectInput(session, "y.data", selected = num.choices[2])
            # Adjustments
            updateSelectInput(session, "sort_x", selected = "none")
            updateMaterialSwitch(session, "flip", value = FALSE)
            updateNumericInput(session, "y.min", value = min.y)
            updateNumericInput(session, "y.max", value = max.y)

            # Points
            updateMaterialSwitch(session, "add.points", value = FALSE)
            updateNumericInput(session, "pt.size", value = 1)
            updateNumericInput(session, "pt.alpha", value = 1)
            updateNumericInput(session, "jitter.width", value = 0.5)
            updateNumericInput(session, "jitter.height", value = 0)

            # Box
            updateMaterialSwitch(session, "add.box", value = FALSE)
            colourpicker::updateColourInput(session, "box.color", value = "#000000")
            updateNumericInput(session, "box.width", value = 0.1)
            updateNumericInput(session, "box.ptsize", value = 2.5)

            # Colors
            colourpicker::updateColourInput(session, "pt.color", value = "#000000")

            # Annotations
            updateTextInput(session, "highlight", value = "")
            colourpicker::updateColourInput(session, "highlight.colour", value = "#000000")
            updateNumericInput(session, "highlight.size", value = 1)
            updateNumericInput(session, "highlight.alpha", value = 1)

            # Facet
            updateSelectInput(session, "facet.by", selected = "NULL")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateMaterialSwitch(session, "facet.by.row", value = TRUE)

            # Action Button:
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

            # Axes
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
            updateSelectInput(session, "font.type", selected = "Arial")
            updateNumericInput(session, "axis.title.font.size", value = 18)
            colourpicker::updateColourInput(session, "axis.title.font.color", value = "#000000")
            updateSelectInput(session, "axis.title.font.family", selected = "Arial")
            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror",  value = TRUE)
            updateCheckboxInput(session, "show.grid.x", value = TRUE)
            updateCheckboxInput(session, "show.grid.y", value = TRUE)
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

        # Update y-axis range when y data column is changed
        observeEvent(input$y.data, {
            y_range <- .calculate_range(df = data(), data_col_y = input$y.data, axis_scale_factor = 1.11, grouping = FALSE)
            if (!is.null(y_range)) {
                updateNumericInput(session, "y.max", value = y_range$max)
                updateNumericInput(session, "y.min", value = y_range$min)
            }
        })

        generate_ViolinPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            # Facet By Null option Upstream:
            facet.by <- NULL
            if (!isolate_fn(input$facet.by) == "") {
                facet.by <- isolate_fn(input$facet.by)
            }
            group.by <- NULL
            if (!isolate_fn(input$group.by) == "") {
                group.by <- isolate_fn(input$group.by)
            }
            highlight <- .na_to_null(isolate_fn(input$highlight))

            # Convert NA to NULL for facet.ncol and facet.nrow
            facet.ncol <- .na_to_null(isolate_fn(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate_fn(input$facet.nrow))

            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours),
                default_palette_values
            )
            palcolor_arg <- NULL
            if (!is.null(palette_values) && length(palette_values) > 0) {
                # plotthis::ViolinPlot expects a named list for palcolor when manually setting colors
                palcolor_arg <- as.list(palette_values)
            }

            theme_args <- .create_ggplot_axis_style(input, isolate_fn = isolate_fn)

            p <- plotthis::ViolinPlot(
                data = data(),
                x = isolate_fn(input$x.data),
                y = isolate_fn(input$y.data),
                group_by = group.by,
                flip = isolate_fn(input$rotate),
                sort_x = isolate_fn(input$sort_x),
                y_max = isolate_fn(input$y.max),
                y_min = isolate_fn(input$y.min),
                add_point = isolate_fn(input$add.points),
                pt_size = isolate_fn(input$pt.size),
                pt_alpha = isolate_fn(input$pt.alpha),
                jitter_width = isolate_fn(input$jitter.width),
                jitter_height = isolate_fn(input$jitter.height),
                pt_color = isolate_fn(input$pt.color),
                add_box = isolate_fn(input$add.box),
                box_color = isolate_fn(input$box.color),
                box_width = isolate_fn(input$box.width),
                box_ptsize = isolate_fn(input$box.ptsize),
                palcolor = palcolor_arg,
                add_line = isolate_fn(input$add.line),
                line_color = isolate_fn(input$line.colour),
                line_width = isolate_fn(input$line.width),
                line_type = isolate_fn(input$line.type),
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate_fn(input$facet.by.row),
                highlight = highlight,
                highlight_color = isolate_fn(input$highlight.colour),
                highlight_size = isolate_fn(input$highlight.size),
                highlight_alpha = isolate_fn(input$highlight.alpha),
                theme = "theme_this",
                theme_args = theme_args
            )


            fig <- ggplotly(p) |>
                plotly::layout(
                    title = list(
                        font = list(size = 28, family = isolate_fn(input$font.type), color = isolate_fn(input$text.colour)),
                        x = 0.5, xanchor = "center", y = 0.98, yanchor = "top"
                    )
                )

            # Apply axis styling to all subplot axes (handles faceting/split_by)
            #Axis Styling: 

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

            # Hide jitter points from legend if they are shown
            if (isolate_fn(input$add.points)) {
                fig <- .hide_jitter_from_legend(fig)
            }

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.type), include.modebar.buttons = TRUE, facet.by = facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))

            return(fig)
        })

        # Render the plot output
        output$ViolinPlot <- renderPlotly({
            width <- session$clientData$output_ViolinPlot_width
            height <- session$clientData$output_ViolinPlot_height
            
            generate_ViolinPlot() %>%
                layout(
                    width = as.numeric(width),
                    height = as.numeric(height) * 0.9,
                    margin = list(t = 100, l = 90, r = 90, b = 100, autoexpand = TRUE)
                )
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_ViolinPlot,
            filename_base = "ViolinPlot"
        )
    })
}
