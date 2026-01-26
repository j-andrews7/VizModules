#' Server logic for scatterPlot module
#' @param id The ID for the Shiny module.
#' @param data A `reactive` containing the data frame to plot.
#' @param hide.inputs A character vector of input IDs to hide.
#'   These will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param hide.tabs A character vector of tab names to hide.
#'   Inputs in these tabs will still be initialized and their values passed to the plot function,
#'   but the user will not be able to see/adjust them in the UI.
#' @param manual.colors A named character vector of colors or a reactive returning a named character vector of colors.
#' @return The `moduleServer` function for the scatterPlot module.
#'
#' @import shiny
#' @importFrom dittoViz scatterPlot colLevels
#' @importFrom ggplot2 theme_bw waiver
#' @importFrom shinyjs hide
#'
#' @seealso [dittoViz::scatterPlot()], [VizModules::organize_inputs()],
#' [VizModules::dittoViz_scatterPlotOutputUI()], [VizModules::dittoViz_scatterPlotServer()], [VizModules::dittoViz_scatterPlotApp()]
#'
#' @export
#' @author Jared Andrews
dittoViz_scatterPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, manual.colors = NULL) {
    stopifnot(is.reactive(data))

    moduleServer(id, function(input, output, session) {
        ns <- session$ns
        # Hide individual inputs if specified
        if (!is.null(hide.inputs)) {
            lapply(hide.inputs, function(input.name) {
                hide(input.name)
            })
        }

        # Hide tabs if specified
        if (!is.null(hide.tabs)) {
            lapply(hide.tabs, function(tab.name) {
                hideTab(inputId = "scatterPlotTabsetPanel", target = tab.name)
            })
        }

        # Available color groups for the current color.by selection
        color_levels <- reactive({
            df <- data()
            color_by <- input$color.by

            if (is.null(df) || is.null(color_by) || color_by == "" || !color_by %in% names(df)) {
                return(character(0))
            }

            if (is.numeric(df[[color_by]])) {
                return(character(0))
            }

            colLevels(color_by, df)
        })

        # Resolve manual colors supplied to the module (reactive or static)
        manual_color_values <- reactive({
            if (is.null(manual.colors)) {
                return(NULL)
            }

            if (is.reactive(manual.colors)) {
                manual.colors()
            } else {
                manual.colors
            }
        })

        # Render the multiColorPicker for discrete color mappings
        output$color.panel.ui <- renderUI({
            groups <- color_levels()

            if (length(groups) == 0) {
                return(NULL)
            }

            initial_colors <- isolate(input$color.panel)
            if (is.null(initial_colors) || length(initial_colors) == 0) {
                initial_colors <- manual_color_values()
            }

            multiColorPicker(
                ns("color.panel"),
                label = "Color palette",
                groups = groups,
                palette_options = default_palettes()[["choices"]],
                selected_palette = "dittoColors",
                colors = initial_colors,
                compact = TRUE
            )
        })

        # Get color panel aligned to the current groups
        color.panel <- reactive({
            isolate_fn <- setup_auto_update_logic(input)

            picker_values <- isolate_fn(input$color.panel)
            manual_vals <- manual_color_values()

            palette <- NULL

            if (!is.null(picker_values) && length(picker_values) > 0) {
                palette <- picker_values
            } else if (!is.null(manual_vals) && length(manual_vals) > 0) {
                palette <- manual_vals
            }

            if (is.null(palette) || length(palette) == 0) {
                palette <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]
            }

            levels <- isolate_fn(color_levels())
            if (length(levels) > 0) {
                if (!is.null(names(palette)) && any(nzchar(names(palette)))) {
                    palette <- palette[match(levels, names(palette))]
                }

                if (any(is.na(palette))) {
                    fallback_palette <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]
                    na_idx <- which(is.na(palette))
                    palette[na_idx] <- rep_len(fallback_palette, length(na_idx))
                }

                palette <- rep_len(palette, length(levels))
                palette <- palette[seq_len(length(levels))]
                palette <- stats::setNames(palette, levels)
            }

            palette
        })

        # dataframe of selected data, which is added to with multiple selections
        selected.data <- reactiveVal()

        # Observer to add selected data to selected.data
        observeEvent(
            event_data("plotly_selected"),
            # suspended = TRUE,
            {
                selected <- event_data("plotly_selected")
                selected.full <- rbind(selected.data(), selected)

                # Since this is running on every selection, remove duplicates
                keep <- selected.full[!duplicated(selected.full), ]

                if (nrow(keep) == 0) {
                    selected.data(NULL)
                } else {
                    selected.data(keep)
                }
            }
        )

        # Observer to clear selected data
        observeEvent(input$annotation.clear, {
            selected.data(NULL)
        })

        output$scatterPlot <- renderPlotly({
            req(input$x.by, input$y.by, data())

            isolate_fn <- setup_auto_update_logic(input)

            # Change textInputs and selectInputs to NULL if empty
            null.na.inputs <- list(
                "trajectory.group.by" = .na_to_null(isolate_fn(input$trajectory.group.by)),
                "add.trajectory.by.groups" = .na_to_null(isolate_fn(input$add.trajectory.by.groups)),
                "color.by" = .na_to_null(isolate_fn(input$color.by)),
                "shape.by" = .na_to_null(isolate_fn(input$shape.by)),
                "split.by" = .na_to_null(isolate_fn(input$split.by)),
                "annotate.by" = .na_to_null(isolate_fn(input$annotate.by)),
                "x.adjustment" = .na_to_null(isolate_fn(input$x.adjustment)),
                "y.adjustment" = .na_to_null(isolate_fn(input$y.adjustment)),
                "color.adjustment" = .na_to_null(isolate_fn(input$color.adjustment)),
                "x.adj.fxn" = .na_to_null(isolate_fn(input$x.adj.fxn)),
                "y.adj.fxn" = .na_to_null(isolate_fn(input$y.adj.fxn)),
                "color.adj.fxn" = .na_to_null(isolate_fn(input$color.adj.fxn)),
                "split.nrow" = .na_to_null(isolate_fn(input$split.nrow)),
                "split.ncol" = .na_to_null(isolate_fn(input$split.ncol)),
                "hover.data" = .na_to_null(isolate_fn(input$hover.data)),
                "annotate.by" = .na_to_null(isolate_fn(input$annotate.by))
            )

            # Waiver inputs
            waiver.inputs <- list(
                "legend.color.breaks" = isolate_fn(input$legend.color.breaks)
            )

            # If input is empty, set to waiver()
            for (input.name in names(waiver.inputs)) {
                if (waiver.inputs[[input.name]] == "") {
                    waiver.inputs[[input.name]] <- waiver()
                } else {
                    waiver.inputs[[input.name]] <- as.numeric(.string_to_vector(waiver.inputs[[input.name]]))
                }
            }

            # Collect hover data
            if (identical(null.na.inputs$hover.data, NULL)) {
                hover.data <- unique(c(
                    null.na.inputs$annotate.by,
                    null.na.inputs$color.by,
                    paste0(null.na.inputs$color.by, ".color.adj"),
                    "color.multi", "color.which",
                    isolate_fn(input$x.by),
                    paste0(isolate_fn(input$x.by), ".x.adj"),
                    isolate_fn(input$y.by),
                    paste0(isolate_fn(input$y.by), ".y.adj"),
                    null.na.inputs$shape.by,
                    null.na.inputs$split.by
                ))
            } else {
                hover.data <- unique(c(null.na.inputs$hover.data, null.na.inputs$annotate.by))
            }

            palette_values <- isolate_fn(color.panel())
            current_color_levels <- isolate_fn(color_levels())

            p <- dittoViz::scatterPlot(
                data(),
                x.by = isolate_fn(input$x.by),
                y.by = isolate_fn(input$y.by),
                color.by = null.na.inputs$color.by,
                shape.by = null.na.inputs$shape.by,
                split.by = null.na.inputs$split.by,
                size = isolate_fn(input$size),
                rows.use = with(data(), eval(str2expression(isolate_fn(input$rows.use)))),
                show.others = isolate_fn(input$show.others),
                x.adjustment = null.na.inputs$x.adjustment,
                y.adjustment = null.na.inputs$y.adjustment,
                color.adjustment = null.na.inputs$color.adjustment,
                x.adj.fxn = eval(str2expression(isolate_fn(input$x.adj.fxn))),
                y.adj.fxn = eval(str2expression(isolate_fn(input$y.adj.fxn))),
                color.adj.fxn = eval(str2expression(isolate_fn(input$color.adj.fxn))),
                split.show.all.others = isolate_fn(input$split.show.all.others),
                opacity = isolate_fn(input$opacity),
                color.panel = unname(palette_values),
                colors = if (length(palette_values) > 0) seq_len(length(palette_values)) else NULL,
                split.nrow = null.na.inputs$split.nrow,
                split.ncol = null.na.inputs$split.ncol,
                split.adjust = list(scales = isolate_fn(input$split.adjust.scales)),
                multivar.split.dir = isolate_fn(input$multivar.split.dir),
                shape.panel = as.numeric(.string_to_vector(isolate_fn(input$shape.panel))),
                rename.color.groups = NULL,
                rename.shape.groups = NULL,
                min.color = isolate_fn(input$min.color),
                max.color = isolate_fn(input$max.color),
                min.value = isolate_fn(input$min.value),
                max.value = isolate_fn(input$max.value),
                plot.order = isolate_fn(input$plot.order),
                theme = theme_bw(),
                do.hover = TRUE,
                hover.data = hover.data,
                hover.round.digits = isolate_fn(input$hover.round.digits),
                do.contour = isolate_fn(input$do.contour),
                contour.color = isolate_fn(input$contour.color),
                contour.linetype = isolate_fn(input$contour.linetype),
                add.trajectory.by.groups = .string_to_list_of_vectors(null.na.inputs$add.trajectory.by.groups),
                trajectory.group.by = null.na.inputs$trajectory.group.by,
                trajectory.arrow.size = isolate_fn(input$trajectory.arrow.size),
                do.ellipse = isolate_fn(input$do.ellipse),
                legend.show = isolate_fn(input$legend.show),
                legend.color.title = isolate_fn(input$legend.color.title),
                legend.color.size = isolate_fn(input$legend.color.size),
                legend.color.breaks = waiver.inputs$legend.color.breaks,
                legend.color.breaks.labels = waiver(),
                legend.shape.title = null.na.inputs$shape.by,
                legend.shape.size = isolate_fn(input$legend.shape.size),
                show.grid.lines = isolate_fn(input$show.grid.lines),
                data.out = TRUE
            )

            plot_data <- p$Target_data

            # COLOUR MAPPING FOR LINE
            manual_vals <- manual_color_values()
            if (!is.null(manual_vals) && length(manual_vals) > 0) {
                palette_for_mapping <- manual_vals
            } else if (!is.null(null.na.inputs$color.by) &&
                length(current_color_levels) > 0 &&
                length(palette_values) > 0) {
                palette_for_mapping <- palette_values
            } else {
                palette_for_mapping <- NULL
            }

            if (!is.null(palette_for_mapping) && length(current_color_levels) > 0) {
                if (!is.null(names(palette_for_mapping)) && any(nzchar(names(palette_for_mapping)))) {
                    palette_for_mapping <- palette_for_mapping[match(current_color_levels, names(palette_for_mapping))]
                }

                if (any(is.na(palette_for_mapping))) {
                    fallback_palette <- default_palettes()[["choices"]][["Defaults"]][["dittoColors"]]
                    na_idx <- which(is.na(palette_for_mapping))
                    palette_for_mapping[na_idx] <- rep_len(fallback_palette, length(na_idx))
                }

                palette_for_mapping <- rep_len(palette_for_mapping, length(current_color_levels))
                color_mapping <- stats::setNames(palette_for_mapping[seq_len(length(current_color_levels))], current_color_levels)
            } else {
                color_mapping <- NULL
            }


            config_list <- .add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE)
            fig <- do.call(config, c(list(p = p$plot), config_list))

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

            # Apply highlight styling to specified points
            highlight_points_raw <- isolate_fn(input$highlight.points)
            if (!is.null(null.na.inputs$annotate.by) &&
                !is.null(highlight_points_raw) &&
                highlight_points_raw != "") {
                highlight_vals <- .string_to_vector(highlight_points_raw)
                # Remove empty strings that may result from parsing
                highlight_vals <- highlight_vals[highlight_vals != ""]

                if (length(highlight_vals) > 0) {
                    # Get styling parameters
                    hl_color <- isolate_fn(input$highlight.color)
                    hl_size <- isolate_fn(input$highlight.size)
                    hl_border_color <- isolate_fn(input$highlight.border.color)
                    hl_border_width <- isolate_fn(input$highlight.border.width)

                    # Find indices of points to highlight in plot_data
                    annotate_col <- null.na.inputs$annotate.by
                    if (annotate_col %in% names(plot_data)) {
                        highlight_idx <- which(as.character(plot_data[[annotate_col]]) %in% highlight_vals)

                        if (length(highlight_idx) > 0 && !is.null(fig$x$data)) {
                            # Iterate through traces and modify marker properties
                            for (i in seq_along(fig$x$data)) {
                                trace <- fig$x$data[[i]]

                                # Skip traces that should not be included
                                if (!.should_include_trace(trace, isolate_fn(input$show.others))) {
                                    next
                                }

                                # Match trace points to plot_data by coordinates
                                trace_n <- length(trace$x)

                                # Initialize marker properties if not present
                                if (is.null(trace$marker)) {
                                    fig$x$data[[i]]$marker <- list()
                                }

                                # Get current marker properties (may be single value or vector)
                                cur_color <- trace$marker$color
                                cur_size <- if (!is.null(trace$marker$size)) {
                                    trace$marker$size
                                } else {
                                    isolate_fn(input$size)
                                }
                                cur_line_color <- if (!is.null(trace$marker$line$color)) {
                                    trace$marker$line$color
                                } else {
                                    "transparent"
                                }
                                cur_line_width <- if (!is.null(trace$marker$line$width)) {
                                    trace$marker$line$width
                                } else {
                                    0
                                }

                                # Expand to vectors if single values
                                if (length(cur_color) == 1) cur_color <- rep(cur_color, trace_n)
                                if (length(cur_size) == 1) cur_size <- rep(cur_size, trace_n)
                                if (length(cur_line_color) == 1) cur_line_color <- rep(cur_line_color, trace_n)
                                if (length(cur_line_width) == 1) cur_line_width <- rep(cur_line_width, trace_n)

                                # Build trace annotation mapping
                                trace_map <- .build_trace_anno_map(trace, isolate_fn(input$annotate.by))
                                if (is.null(trace_map)) {
                                    next
                                }

                                # Get plot coordinates for highlighted points
                                x_adj_col <- paste0(isolate_fn(input$x.by), ".x.adj")
                                y_adj_col <- paste0(isolate_fn(input$y.by), ".y.adj")
                                x_match_col <- if (x_adj_col %in% names(plot_data)) {
                                    x_adj_col
                                } else {
                                    isolate_fn(input$x.by)
                                }
                                y_match_col <- if (y_adj_col %in% names(plot_data)) {
                                    y_adj_col
                                } else {
                                    isolate_fn(input$y.by)
                                }

                                highlight_coords <- .create_coord_id(
                                    plot_data[[x_match_col]][highlight_idx],
                                    plot_data[[y_match_col]][highlight_idx]
                                )

                                # Find which points in this trace should be highlighted
                                trace_highlight_mask <- trace_map$coord_id %in% highlight_coords &
                                    trace_map$anno_value %in% highlight_vals

                                if (any(trace_highlight_mask)) {
                                    # Apply highlight styling
                                    if (!is.null(hl_color) && hl_color != "" && hl_color != "transparent") {
                                        cur_color[trace_highlight_mask] <- hl_color
                                    }
                                    if (!is.null(hl_size) && !is.na(hl_size)) {
                                        cur_size[trace_highlight_mask] <- hl_size
                                    }
                                    if (!is.null(hl_border_color) && hl_border_color != "") {
                                        cur_line_color[trace_highlight_mask] <- hl_border_color
                                    }
                                    if (!is.null(hl_border_width) && !is.na(hl_border_width)) {
                                        cur_line_width[trace_highlight_mask] <- hl_border_width
                                    }

                                    # Update trace marker properties
                                    fig$x$data[[i]]$marker$color <- cur_color
                                    fig$x$data[[i]]$marker$size <- cur_size
                                    fig$x$data[[i]]$marker$line <- list(
                                        color = cur_line_color,
                                        width = cur_line_width
                                    )
                                }
                            }
                        }
                    }
                }
            }

            # Create annotation parameters (used for both manual and auto annotations)
            annotation_params <- list(
                ax = isolate_fn(input$annotation.ax),
                ay = isolate_fn(input$annotation.ay),
                showarrow = isolate_fn(input$annotation.showarrow),
                arrowcolor = isolate_fn(input$annotation.arrowcolor),
                arrowhead = isolate_fn(input$annotation.arrowhead),
                arrowwidth = isolate_fn(input$annotation.arrowwidth),
                size = isolate_fn(input$annotation.size),
                color = isolate_fn(input$annotation.color)
            )

            if (!is.null(null.na.inputs$annotate.by) && !is.null(selected.data())) {
                # Create annotations for selected points using helper function
                annos <- .create_selected_annotations(
                    selected_data = selected.data(),
                    fig = fig,
                    annotate.by = isolate_fn(input$annotate.by),
                    annotation_params = annotation_params,
                    show.others = isolate_fn(input$show.others)
                )
            } else {
                annos <- NULL
            }

            # Auto-annotate highlighted points if enabled
            if (isTRUE(isolate_fn(input$highlight.auto.annotate)) &&
                !is.null(null.na.inputs$annotate.by) &&
                !is.null(highlight_points_raw) &&
                highlight_points_raw != "") {
                highlight_vals <- .string_to_vector(highlight_points_raw)
                highlight_vals <- highlight_vals[highlight_vals != ""]

                if (length(highlight_vals) > 0) {
                    # Create annotations for highlighted points
                    highlight_annos <- .create_highlight_annotations(
                        plot_data = plot_data,
                        fig = fig,
                        annotate.by = isolate_fn(input$annotate.by),
                        highlight_vals = highlight_vals,
                        x_col = isolate_fn(input$x.by),
                        y_col = isolate_fn(input$y.by),
                        annotation_params = annotation_params,
                        show.others = isolate_fn(input$show.others)
                    )
                    
                    # Combine with existing annotations (avoiding duplicates)
                    if (!is.null(highlight_annos)) {
                        if (is.null(annos)) {
                            annos <- highlight_annos
                        } else {
                            # Helper to create unique key for an annotation
                            get_anno_key <- function(a) {
                                paste0(round(a$x, 10), "_", round(a$y, 10), "_", a$text)
                            }
                            
                            existing_keys <- vapply(annos, get_anno_key, character(1))
                            
                            # Add only highlight annotations that don't already exist
                            for (ha in highlight_annos) {
                                ha_key <- get_anno_key(ha)
                                if (!ha_key %in% existing_keys) {
                                    annos <- c(annos, list(ha))
                                    existing_keys <- c(existing_keys, ha_key)
                                }
                            }
                        }
                    }
                }
            }

            fig <- fig %>% layout(
                newshape = list(
                    fillcolor = isolate_fn(input$shape.fill),
                    line = list(
                        color = isolate_fn(input$shape.line.color),
                        width = isolate_fn(input$shape.line.width),
                        dash = isolate_fn(input$shape.linetype)
                    ),
                    opacity = isolate_fn(input$shape.opacity)
                ),
                annotations = annos
            )

            # Apply axis styling to all subplot axes (handles faceting/split.by)
            xaxis_style <- .create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn)
            yaxis_style <- .create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn)

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

            if (isolate_fn(input$webgl)) {
                # Fix hover data issue with toWebGL() when there are layers without proper text attributes
                # Layers with a single text element (length == 1) are typically background/other layers
                # that don't have meaningful hover data. These interfere with hover functionality when
                # converted to WebGL, so we skip hover info for them.
                if (!is.null(fig$x) && !is.null(fig$x$data)) {
                    for (i in seq_along(fig$x$data)) {
                        if (!is.null(fig$x$data[[i]]$text) && length(fig$x$data[[i]]$text) == 1) {
                            fig$x$data[[i]]$hoverinfo <- "skip"
                        }
                    }
                }
                fig <- fig %>% toWebGL()
            }

            # Add fit lines if requested
            # Determine grouping
            group_col <- if (!is.null(input$color.by) && input$color.by != "") {
                input$color.by
            } else {
                NULL
            }

            # Linear model fits
            if (isTRUE(input$linear.model)) {
                fit_data <- .compute_linear_fit(
                    df = data(),
                    x.col = isolate_fn(input$x.by),
                    y.col = isolate_fn(input$y.by),
                    group.col = group_col
                )

                if (!is.null(fit_data)) {
                    if (is.data.frame(fit_data)) {
                        # Single global fit line
                        fig <- fig %>%
                            add_lines(
                                data = fit_data,
                                x = ~x,
                                y = ~y,
                                line = list(color = input$line.best.colour, width = 3),
                                name = "Linear Fit"
                            )
                    } else {
                        # Grouped fit lines (fit_data is a list)
                        for (group_name in names(fit_data)) {
                            line_color <- color_mapping[[group_name]]
                            fig <- fig %>%
                                add_lines(
                                    data = fit_data[[group_name]],
                                    x = ~x,
                                    y = ~y,
                                    line = list(color = line_color, width = 3),
                                    name = paste("Linear", group_name)
                                )
                        }
                    }
                }
            } else if (isTRUE(input$best.fit)) {
                # LOESS smooth fit lines (only if linear model not selected)
                fit_data <- .compute_loess_fit(
                    df = data(),
                    x.col = isolate_fn(input$x.by),
                    y.col = isolate_fn(input$y.by),
                    group.col = group_col,
                    span = input$line.best.smoothness
                )

                if (!is.null(fit_data)) {
                    if (is.data.frame(fit_data)) {
                        # Single global fit line
                        fig <- fig %>%
                            add_lines(
                                data = fit_data,
                                x = ~x,
                                y = ~y,
                                line = list(color = input$line.best.colour, width = 3),
                                name = "Best Fit"
                            )
                    } else {
                        # Grouped fit lines (fit_data is a list)
                        for (group_name in names(fit_data)) {
                            line_color <- color_mapping[[group_name]]
                            fig <- fig %>%
                                add_lines(
                                    data = fit_data[[group_name]],
                                    x = ~x,
                                    y = ~y,
                                    line = list(color = line_color, width = 3),
                                    name = paste("Best fit", group_name)
                                )
                        }
                    }
                }
            }

            fig
        })
    })
}
