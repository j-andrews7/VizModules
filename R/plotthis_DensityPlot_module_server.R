#' Density Plot Server Module
#'
#' @description 
#' Server-side logic for the density plot module. This function manages 
#' reactive data processing, dynamic UI generation for color palettes, 
#' and the rendering of interactive Plotly density plots.
#'
#' @param id \code{character} unique ID for the shiny namespace.
#' @param data \code{reactive} A reactive expression returning a data frame to be plotted.
#' @param hide.inputs \code{character} vector of input IDs to hide in the UI. Default is NULL.
#' @param hide.tabs \code{character} vector of tab names to hide within the module. Default is NULL.
#' 
#' @return A \code{reactive} Plotly object.
#' 
#' @import shiny
#' @import plotly
#' @importFrom stats na.omit setNames
#' 
#' @export
#' @author Jacob Martin, Jared Andrews
plotthis_DensityPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "densityPlotTabsetPanel", target = tab.name)
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

            # Only return groups when group.by is set to a valid categorical column
            if (!is.null(group_col) && nzchar(group_col) && group_col != "NULL" && group_col %in% names(df)) {
                unique(stats::na.omit(as.character(df[[group_col]])))
            } else {
                # No grouping - will show single color picker instead
                character(0)
            }
        })

        output$palette.selection <- renderUI({
            groups <- palette_groups()
            if (length(groups) == 0) {
                # No grouping - show single color picker for fill color
                initial_color <- isolate(input$single.fill.color)
                if (is.null(initial_color) || !nzchar(initial_color)) {
                    initial_color <- default_palette_values[1]
                }
                return(colourpicker::colourInput(
                    ns("single.fill.color"),
                    label = "Fill color",
                    value = initial_color
                ))
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
            max.y <- max(numeric.data, na.rm = TRUE)
            min.y <- min(numeric.data, na.rm = TRUE)
            # Reset numeric inputs to defaults derived from data

            # Data
            updateSelectInput(session, "x.data", selected = names(numeric.data)[1])
            updateSelectInput(session, "group.by", selected = "")
            updateSelectInput(session, "facet.by", selected = "")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateMaterialSwitch(session, "facet.by.row", value = TRUE)
            updateSelectInput(session, "split.by", selected = "")
            updateMaterialSwitch(session, "flip", value = FALSE)
            updateMaterialSwitch(session, "add.bars", value = FALSE)
            updateNumericInput(session, "bar.height", value = 0.04)
            updateSliderInput(session, "bar.alpha", value = 1)
            updateNumericInput(session, "bar.width", value = 1)
            updateSliderInput(session, "plot.alpha", value = 0.5)
            updateSelectInput(session, "theme", selected = "theme_this")
            updateSelectInput(session, "position", selected = "identity")
            colourpicker::updateColourInput(session, "single.fill.color", value = default_palette_values[1])

            # Action Button
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
            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror",  value = TRUE)
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
            updateSelectInput(session, "font.type", selected = "Arial")
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
        })


        generate_DensityPlot <- reactive({
            # Check if auto update on
            auto_update <- input$auto.update

            # If update button is required, add dependency on it
            if (!auto_update) {
                input$update
            }

            # Set up wrapper function based on switch state
            isolate_fn <- if (auto_update) identity else isolate

            facet.by <- NULL
            if (!isolate_fn(input$facet.by) == "") {
                facet.by <- isolate_fn(input$facet.by)
            }

            group.by <- NULL
            if (!isolate_fn(input$group.by) == "") {
                group.by <- isolate_fn(input$group.by)
            }

            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours),
                default_palette_values
            )

            palcolor_arg <- NULL
            if (!is.null(palette_values) && length(palette_values) > 0) {
                palcolor_arg <- as.list(palette_values)
            } else {
                # No grouping - use single fill color
                single_color <- isolate_fn(input$single.fill.color)
                if (!is.null(single_color) && nzchar(single_color)) {
                    palcolor_arg <- list(single_color)
                }
            }

            # Facet rows and columns na to null
            facet.ncol <- .na_to_null(isolate_fn(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate_fn(input$facet.nrow))

            p <- plotthis::DensityPlot(
                data = data(),
                x = isolate_fn(input$x.data),
                group_by = group.by,
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate_fn(input$facet.by.row),
                alpha = isolate_fn(input$plot.alpha),
                flip = isolate_fn(input$flip),
                add_bars = isolate_fn(input$add.bars),
                bar_height = isolate_fn(input$bar.height),
                bar_alpha = isolate_fn(input$bar.alpha),
                bar_width = isolate_fn(input$bar.width),
                theme = isolate_fn(input$theme),
                palcolor = palcolor_arg,
                position = isolate_fn(input$position)
            )

            fig <- ggplotly(p) |>
                plotly::layout(
                    title = list(
                        font = list(size = 28, family = isolate_fn(input$font.type), color = isolate_fn(input$text.colour)),
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
        output$DensityPlot <- renderPlotly({
            generate_DensityPlot()
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_DensityPlot,
            filename_base = "DensityPlot"
        )
    })
}
