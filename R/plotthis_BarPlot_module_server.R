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
#' @import shiny
#' @import plotly
#' @importFrom shinyjs hide
#' @importFrom shinyWidgets updateMaterialSwitch
#'
#' @export
#' @author Jacob Martin, Jared Andrews
plotthis_BarPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL) {
    stopifnot(is.reactive(data))


    moduleServer(id, function(input, output, session) {
        # Constant for y-axis scaling to ensure highest bar reaches ~85% of chart height
        y_axis_scale_factor <- 1.18


        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "BarPlotTabsetPanel", target = tab.name)
        }

        ns <- session$ns
        default_palette_name <- "dittoColors"
        palette_lookup <- .flatten_palette_options(default_palettes()[["choices"]])
        default_palette_values <- palette_lookup[[default_palette_name]]
        if (is.null(default_palette_values) || length(default_palette_values) == 0) {
            default_palette_values <- if (length(palette_lookup) > 0) palette_lookup[[1]] else character(0)
        }


        fill_numeric <- reactive({
            df <- data()
            fill_col <- input$fill.by
            !is.null(fill_col) && nzchar(fill_col) &&
                fill_col %in% names(df) && is.numeric(df[[fill_col]])
        })

        palette_groups <- reactive({
            df <- data()
            if (is.null(df)) {
                return(character(0))
            }
            fill_col <- input$fill.by

            group_col <- input$group.by
            x_col <- input$x.data

            col_to_use <- if (!fill_numeric() && !is.null(fill_col) && nzchar(fill_col) && fill_col %in% names(df)) {
                fill_col
            } else if (!is.null(group_col) && nzchar(group_col) && group_col %in% names(df)) {
                group_col
            } else if (!is.null(x_col) && nzchar(x_col) && x_col %in% names(df)) {
                x_col
            } else {
                NULL
            }

            if (!is.null(col_to_use)) {
                col_data <- stats::na.omit(df[[col_to_use]])
                # Use factor level order to match ggplot2/plotthis color assignment.
                # For factors, use the defined levels (preserves order);
                # for character/other, convert to factor (alphabetical order).
                if (is.factor(col_data)) {
                    levels(col_data)
                } else {
                    levels(as.factor(col_data))
                }
            } else {
                character(0)
            }
        })

        output$palette.selection <- renderUI({
            if (fill_numeric()) {
                palette_names <- names(.flatten_palette_options(default_palettes()[["choices"]]))
                selectInput(
                    ns("palette.name"),
                    "Color Palette",
                    choices = palette_names,
                    selected = "viridis"
                )
            } else {
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
            }
        })


        output$axes_control <- renderUI({
            facet.by <- isTRUE(nzchar(input$facet.by))
            axes_inputs <- .uniform_axes_inputs_ui(ns, NULL, include.rotate = TRUE, facet.by = facet.by)
            do.call(tagList, organize_inputs(axes_inputs, columns = 2))
        })

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            char.choices <- c("", names(data())[vapply(data(), function(x) !is.numeric(x), logical(1))])
            num.choices <- c("", names(data())[vapply(data(), is.numeric, logical(1))])

            # Calculate y.max and y.min from the default selections
            if (length(num.choices) >= 2) {
                max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * y_axis_scale_factor
            } else {
                max.y <- 1
            }
            min.y <- 0
            # Reset numeric inputs to defaults derived from data

            # Data
            updateSelectInput(session, "x.data", selected = char.choices[2])
            updateSelectInput(session, "y.data", selected = num.choices[2])
            updateSelectInput(session, "group.by", selected = char.choices[2])
            updateSelectInput(session, "fill.by", selected = "")


            # Facet
            updateSelectInput(session, "facet.by", selected = "")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateMaterialSwitch(session, "facet.by.row", value = TRUE)
            updateSelectInput(session, "split.by", selected = "")

            # Aesthetics
            updateSelectInput(session, "theme", selected = "theme_this")
            updateNumericInput(session, "alpha", value = 1)
            updateNumericInput(session, "width", value = NA)
            updateTextInput(session, "expand", value = "")

            # Extras
            updateNumericInput(session, "add.line", value = NA)
            colourpicker::updateColourInput(session, "line.colour", value = "#000000")
            updateNumericInput(session, "line.type", value = 1)
            updateNumericInput(session, "line.width", value = 0.6)
            updateTextInput(session, "line.name", value = "")

            # Axes
            updateMaterialSwitch(session, "rotate", value = FALSE)
            updateNumericInput(session, "y.max", value = max.y)
            updateNumericInput(session, "y.min", value = min.y)
            updateNumericInput(session, "axis.font.size", value = 18)
            updateNumericInput(session, "title.font.size", value = 28)
            .reset_axes_inputs(session)

            # Plotly
            .reset_plotly_inputs(session)

            # Lines
            .reset_lines_inputs(session)
        })

        # Update y-axis range when y data column is changed (when auto-update is off) df, y_data_col, y_axis_scale_factor
        observeEvent(list(input$y.data, input$group.by, input$fill.by), {
            req(input$y.data, input$x.data)
            req(input$y.data %in% names(data()))
            req(input$x.data %in% names(data()))

            group_by_val <- if (nzchar(input$group.by)) input$group.by else NULL
            fill_by_val <- if (nzchar(input$fill.by)) input$fill.by else NULL

            # Determine if stacking is happening:
            # Stacked when group.by is numeric OR fill.by is numeric
            group_is_numeric <- !is.null(group_by_val) && group_by_val %in% names(data()) && is.numeric(data()[[group_by_val]])
            fill_is_numeric <- !is.null(fill_by_val) && fill_by_val %in% names(data()) && is.numeric(data()[[fill_by_val]])

            y_range <- .calculate_range(
                df                = data(),
                data_col_x        = input$x.data,
                data_col_y        = input$y.data,
                axis_scale_factor = 1.18,
                grouping          = TRUE
            )

            if (!is.null(y_range)) {
                updateNumericInput(session, "y.max", value = y_range$max)
                updateNumericInput(session, "y.min", value = y_range$min)
            }
        })


        generate_BarPlot <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            # Null Values:
            facet.by <- NULL
            if (!isolate_fn(input$facet.by) == "") {
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
            if (!isolate_fn(input$split.by) == "") {
                split.by <- isolate_fn(input$split.by)
            }
            group.by <- NULL
            if (!isolate_fn(input$group.by) == "") {
                group.by <- isolate_fn(input$group.by)
            }


            fill_by_input <- isolate_fn(input$fill.by)
            if (nzchar(fill_by_input)) {
                fill.by <- fill_by_input
                group.by <- NULL
            } else {
                fill.by <- FALSE
            }

            if (isolate_fn(fill_numeric())) {
                palette_arg <- isolate_fn(input$palette.name)
                if (is.null(palette_arg) || !nzchar(palette_arg)) palette_arg <- "viridis"
                palcolor_arg <- NULL
            } else {
                palette_arg <- NULL
                palette_values <- resolve_palette(
                    isolate_fn(palette_groups()),
                    isolate_fn(input$palette.colours),
                    default_palette_values
                )
                palcolor_arg <- as.list(palette_values)
            }

            # Convert NA to NULL for facet.ncol and facet.nrow
            facet.ncol <- .na_to_null(isolate_fn(input$facet.ncol))
            facet.nrow <- .na_to_null(isolate_fn(input$facet.nrow))

            theme_args <- .create_ggplot_axis_style(input, isolate_fn = isolate_fn)
            theme_args$panel.spacing <- ggplot2::unit(isolate_fn(input$subplot.margin), "lines")
            # bar Plot
            p <- plotthis::BarPlot(
                data(),
                x = isolate_fn(input$x.data),
                y = isolate_fn(input$y.data),
                flip = isolate_fn(input$rotate),
                group_by = group.by,
                facet_by = facet.by,
                facet_scales = isolate_fn(input$facet.scale),
                facet_ncol = facet.ncol,
                facet_nrow = facet.nrow,
                facet_byrow = isolate_fn(input$facet.by.row),
                palette = palette_arg,
                palcolor = palcolor_arg,
                y_min = isolate_fn(input$y.min),
                y_max = isolate_fn(input$y.max),
                theme = "theme_this",
                theme_args = theme_args,
                alpha = isolate_fn(input$alpha),
                expand = expand,
                width = width,
                split_by = split.by,
                fill_by = fill.by
            )

            fig <- ggplotly(p) |>
                plotly::layout(
                    title = list(
                        font = list(size = isolate_fn(input$title.font.size), family = isolate_fn(input$title.font.family), color = isolate_fn(input$text.colour)),
                        x = 0.5, xanchor = "center", y = 0.95, yanchor = "top"
                    )
                )

            # Apply axis styling to all subplot axes (handles faceting/split_by)
            # Disable plotly borders since we're handling them through ggplot theme_args
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

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE, facet.by = facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- .apply_plotly_newshape(fig, input, isolate_fn)

            return(fig)
        })

        # Render the plot output
        output$BarPlot <- renderPlotly({
            x_input <- input$x.data
            y_input <- input$y.data

            return_empty <- FALSE
            txt <- c()

            if (length(x_input) == 0 || !nzchar(x_input)) {
                return_empty <- TRUE
                txt <- c(txt, "X variable input must not be empty. Please select a variable.")
            }

            if (length(y_input) == 0 || !nzchar(y_input)) {
                return_empty <- TRUE
                txt <- c(txt, "Y variable input must not be empty. Please select a numeric variable.")
            }
            if (y_input == input$group.by) {
                return_empty <- TRUE
                txt <- c(txt, "Cannot have the y input and group.by be equal. Please change either inputs")
            }

            if (return_empty) {
                fig <- .empty_plot(text = txt, plotly = TRUE)
            } else {
                fig <- generate_BarPlot() |>
                    layout(
                        margin = list(t = input$margin.t, b = input$margin.b, l = input$margin.l, r = input$margin.r, autoexpand = TRUE)
                    )
            }

            return(fig)
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_BarPlot,
            filename_base = "BarPlot"
        )
    })
}
