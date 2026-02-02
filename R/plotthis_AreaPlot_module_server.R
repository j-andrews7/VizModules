#' Server logic for AreaPlot module
#'
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @return The `moduleServer` function for the AreaPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom plotthis AreaPlot
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @export
#' @author Jacob Martin, Jared Andrews
plotthis_AreaPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
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
                hideTab(inputId = "AreaPlotTabsetPanel", target = tab.name)
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

            if (!is.null(group_col) && nzchar(group_col) && group_col %in% names(df)) {
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
        
        observeEvent(input$x.data, ignoreInit = TRUE, {
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])
            group_facet_choices <- setdiff(char.choices, input$x.data) 
            updateSelectInput(session, "group.by", choices = c(group_facet_choices), selected = if (input$group.by %in% group_facet_choices) input$group.by else "")
            updateSelectInput(session, "facet.by", choices = c("", group_facet_choices), selected = if(input$facet.by %in% group_facet_choices) input$facet.by else "")
        })

        # Reset functionality
        observeEvent(input$reset, {
            char.choices <- c("", names(data())[unlist(lapply(data(), function(x) !is.numeric(x)), use.names = FALSE)])
            numeric.data <- data()[, unlist(lapply(data(), is.numeric), use.names = FALSE), drop = FALSE]
            num.choices <- c("", names(data())[unlist(lapply(data(), is.numeric), use.names = FALSE)])

            max.y <- max(numeric.data, na.rm = TRUE)
            min.y <- min(numeric.data, na.rm = TRUE)

            # Data
            updateSelectInput(session, "x.data",    selected = char.choices[2])
            updateSelectInput(session, "y.data",    selected = num.choices[2])
            updateSelectInput(session, "group.by",  selected = char.choices[3])

            # Facet
            updateSelectInput(session, "facet.by",    selected = "")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateMaterialSwitch(session, "facet.by.row", value = TRUE)

            # Aesthetic
            # (palette.selection is UI output, so no reset call here)
            updateSelectInput(session, "theme", selected = "theme_this")
            updateNumericInput(session, "alpha", value = 1)
            updateSelectInput(session, "legend.direction", selected = "vertical")
            
            # Axes
            updateNumericInput(session, "axis.font.size", value = 18)
            updateNumericInput(session, "title.font.size", value = 28)
            updateSelectInput(session, "font.type", selected = "Arial")
            colourpicker::updateColourInput(session, "text.colour", value = "#000000")
            updateNumericInput(session, "axis.title.font.size", value = 18)
            colourpicker::updateColourInput(session, "axis.title.font.color", value = "#000000")
            updateSelectInput(session, "axis.title.font.family", selected = "Arial")

            updateCheckboxInput(session, "axis.showline", value = TRUE)
            updateCheckboxInput(session, "axis.mirror",  value = TRUE)
            updateCheckboxInput(session, "show.major.grid.x", value = TRUE)
            updateCheckboxInput(session, "show.major.grid.y", value = TRUE)
            colourpicker::updateColourInput(session, "axis.linecolor", value = "black")
            updateNumericInput(session, "axis.linewidth", value = 0.5)
            updateMaterialSwitch(session, "scale.y", value = FALSE)

            # Ticks
            updateNumericInput(session, "axis.tickfont.size", value = 12)
            colourpicker::updateColourInput(session, "axis.tickfont.color", value = "black")
            updateSelectInput(session, "axis.tickfont.family", selected = "Arial")
            updateNumericInput(session, "axis.tickangle.x", value = 0)
            updateNumericInput(session, "axis.tickangle.y", value = 0)
            updateSelectInput(session, "axis.ticks", selected = "outside")
            colourpicker::updateColourInput(session, "axis.tickcolor", value = "black")
            updateNumericInput(session, "axis.ticklen", value = 5)
            updateNumericInput(session, "axis.tickwidth", value = 1)

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
        })

        generate_AreaPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            group.by <- NULL
            if (!isolate_fn(input$group.by) == ""){
                group.by <- isolate_fn(input$group.by)
            }

            # Null Values:
            facet.by <- NULL
            if (!isolate_fn(input$facet.by) == "") {
                facet.by <- isolate_fn(input$facet.by)
            }

            # Convert NA to NULL for facet.ncol and facet.nrow
            facet.ncol <- .na_to_null(isolate_fn(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate_fn(input$facet.nrow))
            palette_values <- resolve_palette(
                isolate_fn(palette_groups()),
                isolate_fn(input$palette.colours),
                default_palette_values
            )

            p <- plotthis::AreaPlot(
                data(),
                x = isolate_fn(input$x.data),
                y = isolate_fn(input$y.data),
                group_by = group.by,
                theme = isolate_fn(input$theme),
                palcolor = unname(palette_values),
                alpha = isolate_fn(input$alpha),
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate_fn(input$facet.by.row),
                scale_y = isolate_fn(input$scale.y),
                legend_direction = isolate_fn(input$legend.direction)
            )


            # Remove ggplot panel borders to prevent double borders with plotly
            p <- .remove_ggplot_panel_borders(p)

            fig <- ggplotly(p) |>
                plotly::layout(
                    title = list(
                        font = list(
                            size = isolate_fn(input$title.font.size),
                            family = isolate_fn(input$font.type),
                            color = isolate_fn(input$text.colour)
                        ),
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
        output$AreaPlot <- renderPlotly({
            generate_AreaPlot()
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_AreaPlot,
            filename_base = "AreaPlot"
        )
    })
}
