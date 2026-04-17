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
#' @param defaults A named list of default values for the inputs. When the reset button is
#'   clicked, inputs are reset to these values rather than hardcoded fallbacks. Typically
#'   the same list passed to the corresponding UI function.
#'
#' @return The `moduleServer` function for the DensityPlot module.
#'
#' @import shiny
#' @import plotly
#' @importFrom plotthis DensityPlot
#' @importFrom colourpicker updateColourInput
#' @importFrom ggplot2 unit
#'
#' @export
#' @author Jacob Martin, Jared Andrews
plotthis_DensityPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "DensityPlotTabsetPanel", target = tab.name)
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
            if (!is.null(group_col) && nzchar(group_col) && group_col %in% names(df)) {
                unique(na.omit(as.character(df[[group_col]])))
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
                return(colourInput(
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
            all.choices <- c("", names(data()))
            char.choices <- c("", names(data())[vapply(data(), function(x) !is.numeric(x), logical(1))])
            num.choices <- names(numeric.data)
            # Reset numeric inputs to defaults derived from data

            # Data
            updateSelectInput(session, "x.data",
                selected = .get_default(defaults, "x.data", num.choices[1], function(x) x %in% num.choices))
            updateSelectInput(session, "group.by",
                selected = .get_default(defaults, "group.by", "", function(x) x == "" || x %in% all.choices))
            updateSelectInput(session, "facet.by",
                selected = .get_default(defaults, "facet.by", "", function(x) x == "" || x %in% all.choices))
            updateSelectInput(session, "facet.scale",
                selected = .get_default(defaults, "facet.scale", "fixed"))
            updateNumericInput(session, "facet.ncol", value = .get_default(defaults, "facet.ncol", NA, is.numeric))
            updateNumericInput(session, "facet.nrow", value = .get_default(defaults, "facet.nrow", NA, is.numeric))
            updateMaterialSwitch(session, "facet.by.row",
                value = .get_default(defaults, "facet.by.row", TRUE, is.logical))
            updateSelectInput(session, "split.by",
                selected = .get_default(defaults, "split.by", "", function(x) x == "" || x %in% all.choices))
            updateMaterialSwitch(session, "rotate", value = .get_default(defaults, "rotate", FALSE, is.logical))
            updateMaterialSwitch(session, "add.bars",
                value = .get_default(defaults, "add.bars", FALSE, is.logical))
            updateNumericInput(session, "bar.height",
                value = .get_default(defaults, "bar.height", 0.04, is.numeric))
            updateSliderInput(session, "bar.alpha", value = .get_default(defaults, "bar.alpha", 1, is.numeric))
            updateNumericInput(session, "bar.width", value = .get_default(defaults, "bar.width", 1, is.numeric))
            updateSliderInput(session, "plot.alpha", value = .get_default(defaults, "plot.alpha", 0.5, is.numeric))
            updateSelectInput(session, "theme", selected = .get_default(defaults, "theme", "theme_this"))
            updateSelectInput(session, "position", selected = .get_default(defaults, "position", "identity"))
            updateColourInput(session, "single.fill.color",
                value = .get_default(defaults, "single.fill.color", default_palette_values[1]))

            # Action Button
            .reset_plotly_inputs(session, defaults)

            # Lines
            .reset_lines_inputs(session, defaults = defaults)

            # Axes
            .reset_axes_inputs(session, defaults)
        })


        observeEvent(input$facet.by, {
            if (!input$facet.by == "") {
                show("facet.title.font.size")
                show("facet.title.font.color")
                show("facet.title.font.family")
            } else {
                hide("facet.title.font.size")
                hide("facet.title.font.color")
                hide("facet.title.font.family")
            }
        })

        generate_DensityPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

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

            theme_args <- .create_ggplot_axis_style(input, isolate_fn = isolate_fn)
            theme_args$panel.spacing <- unit(isolate_fn(input$subplot.margin), "npc")

            p <- DensityPlot(
                data = data(),
                x = isolate_fn(input$x.data),
                group_by = group.by,
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate_fn(input$facet.by.row),
                alpha = isolate_fn(input$plot.alpha),
                flip = isolate_fn(input$rotate),
                add_bars = isolate_fn(input$add.bars),
                bar_height = isolate_fn(input$bar.height),
                bar_alpha = isolate_fn(input$bar.alpha),
                bar_width = isolate_fn(input$bar.width),
                theme = "theme_this",
                theme_args = theme_args,
                palcolor = palcolor_arg,
                position = isolate_fn(input$position)
            )

            fig <- ggplotly(p)
            fig <- .apply_title_layout(fig, input, isolate_fn, title_y = 0.98)

            fig <- .finalize_plotly(fig, input, isolate_fn, facet.by = facet.by)

            return(fig)
        })

        # Render the plot output
        output$DensityPlot <- renderPlotly({
            req(input$x.data)

            fig <- .apply_render_margins(generate_DensityPlot(), input)

            return(fig)
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_DensityPlot,
            filename_base = "DensityPlot"
        )
    })
}
