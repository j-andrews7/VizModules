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
            for (input.name in hide.inputs) hide(input.name)
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            for (tab.name in hide.tabs) hideTab(inputId = "ViolinPlotTabsetPanel", target = tab.name)
        }

        ns <- session$ns
        default_palette_name <- "dittoColors"

        # Store last computed stats table for download
        last_stats_df <- reactiveVal(NULL)
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

        # Reset functionality
        observeEvent(input$reset, {
            numeric.data <- data()[, vapply(data(), is.numeric, logical(1)), drop = FALSE]
            char.choices <- c("", names(data())[vapply(data(), function(x) !is.numeric(x), logical(1))])
            num.choices <- c("", names(data())[vapply(data(), is.numeric, logical(1))])
            
            # Calculate y.max and y.min from the default selections
            if (length(num.choices) >= 2) {
                max.y <- max(numeric.data[[num.choices[2]]], na.rm = TRUE) * .y_axis_scale_factor
                min.y <- min(numeric.data[[num.choices[2]]], na.rm = TRUE)
            } else {
                max.y <- 1
                min.y <- 0
            }
            # Reset numeric inputs to defaults derived from data

            # Data
            updateSelectInput(session, "group.by", selected = "")
            updateSelectInput(session, "x.data", selected = char.choices[2])
            updateSelectInput(session, "y.data", selected = num.choices[2])
            # Adjustments
            updateSelectInput(session, "sort_x", selected = "")
            updateMaterialSwitch(session, "rotate", value = FALSE)
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
            updateSelectInput(session, "facet.by", selected = "")
            updateSelectInput(session, "facet.scale", selected = "fixed")
            updateNumericInput(session, "facet.ncol", value = NULL)
            updateNumericInput(session, "facet.nrow", value = NULL)
            updateMaterialSwitch(session, "facet.by.row", value = TRUE)

            # Action Button:
            .reset_plotly_inputs(session)

            # Lines
            .reset_lines_inputs(session)

            # Axes
            .reset_axes_inputs(session)

            # Stats
            .reset_stats_inputs(session)
        })

        # Update stat comparison pairs when x or group.by changes
        observeEvent(c(input$x.data, input$group.by), {
            req(input$x.data)
            pair_strings <- .generate_pair_strings(data(), input$x.data, input$group.by)
            updateSelectInput(session, "stat.pairs", choices = c("", pair_strings), selected = "")
        })

        # Show/hide Save Stats button based on stats.enabled
        observeEvent(input$stats.enabled, {
            if (isTRUE(input$stats.enabled)) {
                shinyjs::show("download.stats.col")
            } else {
                shinyjs::hide("download.stats.col")
            }
        })

        # Update y-axis range when y data column is changed
        observeEvent(input$y.data, {
            y_range <- .calculate_range(df = data(), data_col_y = input$y.data, axis_scale_factor = .y_axis_scale_factor, grouping = FALSE)
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
            highlight <- validate_expression(isolate_fn(input$highlight), names(data()))

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
            sort.x <- NULL 
            if (!isolate_fn(input$sort_x) == ""){
                sort.x <- isolate_fn(input$sort_x)
            }
            theme_args <- .create_ggplot_axis_style(input, isolate_fn = isolate_fn)
            theme_args$panel.spacing <- ggplot2::unit(isolate_fn(input$subplot.margin), "lines")

            p <- plotthis::ViolinPlot(
                data = data(),
                x = isolate_fn(input$x.data),
                y = isolate_fn(input$y.data),
                group_by = group.by,
                flip = isolate_fn(input$rotate),
                sort_x = sort.x,
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
                        font = list(size = 28, family = isolate_fn(input$title.font.family), color = isolate_fn(input$text.colour)),
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

            # Statistical annotations
            if (isolate_fn(input$stats.enabled)) {
                stat_pairs <- .parse_pair_strings(isolate_fn(input$stat.pairs))
                stats_df <- .compute_pairwise_stats(
                    df = data(), x = isolate_fn(input$x.data),
                    y = isolate_fn(input$y.data), pairs = stat_pairs,
                    test = isolate_fn(input$stat.test),
                    p.adjust.method = isolate_fn(input$stat.p.adjust),
                    paired = isolate_fn(input$stat.paired),
                    group.by = group.by, facet.by = facet.by,
                    per.facet = isolate_fn(input$stat.per.facet),
                    sig.threshold = isolate_fn(input$stat.sig.threshold)
                )
                last_stats_df(stats_df)
                stat_result <- .create_stat_annotations(
                    stats_df = stats_df, fig = fig, df = data(),
                    x = isolate_fn(input$x.data), y = isolate_fn(input$y.data),
                    display = isolate_fn(input$stat.display),
                    hide.ns = isolate_fn(input$stat.hide.ns),
                    sig.threshold = isolate_fn(input$stat.sig.threshold),
                    line.color = isolate_fn(input$stat.line.color),
                    line.width = isolate_fn(input$stat.line.width),
                    bracket.style = isolate_fn(input$stat.bracket.style),
                    group.by = group.by, facet.by = facet.by,
                    step.increase = isolate_fn(input$stat.step.increase),
                    text.bump = isolate_fn(input$stat.text.bump),
                    bracket.inset = isolate_fn(input$stat.bracket.inset)
                )
                fig <- .apply_stat_annotations(fig, stat_result,
                    y.min = isolate_fn(input$y.min))
            }

            config_list <- .add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE, facet.by = facet.by)
            fig <- do.call(config, c(list(p = fig), config_list))
            fig <- .apply_plotly_newshape(fig, input, isolate_fn)

            return(fig)
        })

        # Render the plot output
        output$ViolinPlot <- renderPlotly({

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

           

            if (return_empty) {
                fig <- .empty_plot(text = txt, plotly = TRUE)
            } else {
                fig <- generate_ViolinPlot() |>
                    layout(
                        margin = list(t = input$margin.t, b = input$margin.b, l = input$margin.l, r = input$margin.r, autoexpand = TRUE)
                    )
            }

            return(fig)
        })

        # Download handler for interactive plot
        output$download.interactive <- .create_plot_download_handler(
            plot_reactive = generate_ViolinPlot,
            filename_base = "ViolinPlot"
        )

        # Download handler for stats table
        output$download.stats <- downloadHandler(
            filename = function() {
                paste0("stats_table_", Sys.Date(), ".csv")
            },
            content = function(file) {
                .write_stats_csv(
                    stats_df = last_stats_df(), file = file,
                    p.adjust.method = input$stat.p.adjust,
                    sig.threshold = input$stat.sig.threshold
                )
            }
        )
    })
}
