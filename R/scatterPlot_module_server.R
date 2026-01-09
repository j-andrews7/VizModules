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
#' @importFrom ggplot2 theme_bw waiver
#' @importFrom plotly renderPlotly %>% config layout toWebGL event_data add_lines
#' @importFrom shinyjs hide
#'
#' @seealso [dittoViz::scatterPlot()], [vizModules::organize_inputs()],
#' [vizModules::scatterPlotOutputUI()], [vizModules::scatterPlotServer()], [vizModules::createScatterPlotApp()]
#'
#' @export
#' @author Jared Andrews
scatterPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, manual.colors = NULL) {
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
                hideTab(inputId = "scatterPlotTabsetPanel", target = tab.name)
            })
        }

        # Get color panel
        color.panel <- reactive({
            palette <- NULL
            if (!is.null(manual.colors)) {
                if (is.reactive(manual.colors)) {
                    palette <- manual.colors()
                } else if (is.function(manual.colors)) {
                    palette <- manual.colors(input)
                } else {
                    palette <- manual.colors
                }
            }

            if (is.null(palette)) {
                if (is.null(isolate(input$color.panel)) || isolate(input$color.panel) == "dittoColors") {
                    palette <- dittoColors()
                } else if (!is.null(isolate(input$color.by))) {
                    if (isolate(input$color.panel) %in% c("viridis", "magma", "inferno", "plasma", "cividis")) {
                        palette <- viridis_pal(option = isolate(input$color.panel))(length(colLevels(isolate(input$color.by), data())))
                    } else if (isolate(input$color.panel) == "ggplot2") {
                        palette <- hue_pal()(length(colLevels(isolate(input$color.by), data())))
                    } else {
                        palette <- brewer_pal(palette = isolate(input$color.panel))(length(colLevels(isolate(input$color.by), data())))
                    }
                }
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
            input$update

            # Change textInputs and selectInputs to NULL if empty
            null.na.inputs <- list(
                "trajectory.group.by" = .na_to_null(isolate(input$trajectory.group.by)),
                "add.trajectory.by.groups" = .na_to_null(isolate(input$add.trajectory.by.groups)),
                "add.xline" = .na_to_null(isolate(input$add.xline)),
                "add.yline" = .na_to_null(isolate(input$add.yline)),
                "color.by" = .na_to_null(isolate(input$color.by)),
                "shape.by" = .na_to_null(isolate(input$shape.by)),
                "split.by" = .na_to_null(isolate(input$split.by)),
                "x.adjustment" = .na_to_null(isolate(input$x.adjustment)),
                "y.adjustment" = .na_to_null(isolate(input$y.adjustment)),
                "color.adjustment" = .na_to_null(isolate(input$color.adjustment)),
                "x.adj.fxn" = .na_to_null(isolate(input$x.adj.fxn)),
                "y.adj.fxn" = .na_to_null(isolate(input$y.adj.fxn)),
                "color.adj.fxn" = .na_to_null(isolate(input$color.adj.fxn)),
                "split.nrow" = .na_to_null(isolate(input$split.nrow)),
                "split.ncol" = .na_to_null(isolate(input$split.ncol)),
                "hover.data" = .na_to_null(isolate(input$hover.data)),
                "annotate.by" = .na_to_null(isolate(input$annotate.by))
            )

            # Waiver inputs
            waiver.inputs <- list(
                "legend.color.breaks" = isolate(input$legend.color.breaks)
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
                    null.na.inputs$color.by,
                    paste0(null.na.inputs$color.by, ".color.adj"),
                    "color.multi", "color.which",
                    isolate(input$x.by),
                    paste0(isolate(input$x.by), ".x.adj"),
                    isolate(input$y.by),
                    paste0(isolate(input$y.by), ".y.adj"),
                    null.na.inputs$shape.by,
                    null.na.inputs$split.by
                ))
            } else {
                hover.data <- null.na.inputs$hover.data
            }

            p <- dittoViz::scatterPlot(
                data(),
                x.by = isolate(input$x.by),
                y.by = isolate(input$y.by),
                color.by = null.na.inputs$color.by,
                shape.by = null.na.inputs$shape.by,
                split.by = null.na.inputs$split.by,
                size = isolate(input$size),
                rows.use = with(data(), eval(str2expression(isolate(input$rows.use)))),
                show.others = isolate(input$show.others),
                x.adjustment = null.na.inputs$x.adjustment,
                y.adjustment = null.na.inputs$y.adjustment,
                color.adjustment = null.na.inputs$color.adjustment,
                x.adj.fxn = eval(str2expression(isolate(input$x.adj.fxn))),
                y.adj.fxn = eval(str2expression(isolate(input$y.adj.fxn))),
                color.adj.fxn = eval(str2expression(isolate(input$color.adj.fxn))),
                split.show.all.others = isolate(input$split.show.all.others),
                opacity = isolate(input$opacity),
                color.panel = isolate(color.panel()),
                colors = seq_along(isolate(color.panel())),
                split.nrow = null.na.inputs$split.nrow,
                split.ncol = null.na.inputs$split.ncol,
                split.adjust = list(scales = isolate(input$split.adjust.scales)),
                multivar.split.dir = isolate(input$multivar.split.dir),
                shape.panel = as.numeric(.string_to_vector(isolate(input$shape.panel))),
                rename.color.groups = NULL,
                rename.shape.groups = NULL,
                min.color = isolate(input$min.color),
                max.color = isolate(input$max.color),
                min.value = isolate(input$min.value),
                max.value = isolate(input$max.value),
                plot.order = isolate(input$plot.order),
                theme = theme_bw(),
                do.hover = TRUE,
                hover.data = hover.data,
                hover.round.digits = isolate(input$hover.round.digits),
                do.contour = isolate(input$do.contour),
                contour.color = isolate(input$contour.color),
                contour.linetype = isolate(input$contour.linetype),
                add.trajectory.by.groups = .string_to_list_of_vectors(null.na.inputs$add.trajectory.by.groups),
                trajectory.group.by = null.na.inputs$trajectory.group.by,
                trajectory.arrow.size = isolate(input$trajectory.arrow.size),
                add.xline = as.numeric(.string_to_vector(null.na.inputs$add.xline)),
                xline.linetype = isolate(input$xline.linetype),
                xline.color = isolate(input$xline.color),
                add.yline = as.numeric(.string_to_vector(null.na.inputs$add.yline)),
                yline.linetype = isolate(input$yline.linetype),
                yline.color = isolate(input$yline.color),
                do.ellipse = isolate(input$do.ellipse),
                legend.show = isolate(input$legend.show),
                legend.color.title = isolate(input$legend.color.title),
                legend.color.size = isolate(input$legend.color.size),
                legend.color.breaks = waiver.inputs$legend.color.breaks,
                legend.color.breaks.labels = waiver(),
                legend.shape.title = null.na.inputs$shape.by,
                legend.shape.size = isolate(input$legend.shape.size),
                show.grid.lines = isolate(input$show.grid.lines),
                data.out = TRUE
            )

            plot_data <- p$Target_data

            # COLOUR MAPPING FOR LINE
            if (!is.null(manual.colors)) {
                if (is.reactive(manual.colors)) {
                    color_mapping <- manual.colors()
                } else {
                    color_mapping <- manual.colors
                }
            } else if (!is.null(isolate(input$color.by)) && isolate(input$color.by) != "") {
                color_levels <- colLevels(isolate(input$color.by), data())
                color_mapping <- setNames(color.panel()[seq_along(color_levels)], color_levels)
            } else {
                color_mapping <- NULL
            }


            fig <- p$plot %>% config(
                edits = list(
                    axisTitleText = TRUE,
                    titleText = TRUE,
                    legendText = TRUE,
                    legendPosition = TRUE,
                    colorbarPosition = TRUE,
                    colorbarTitleText = TRUE,
                    annotationTail = TRUE
                ),
                toImageButtonOptions = list(
                    format = isolate(input$download.format)
                ),
                modeBarButtonsToAdd = list(
                    "drawline",
                    "drawopenpath",
                    "drawclosedpath",
                    "drawcircle",
                    "drawrect",
                    "eraseshape"
                ),
                displaylogo = FALSE
            )

            # Apply highlight styling to specified points
            highlight_points_raw <- isolate(input$highlight.points)
            if (!is.null(null.na.inputs$annotate.by) &&
                !is.null(highlight_points_raw) &&
                highlight_points_raw != "") {
                highlight_vals <- .string_to_vector(highlight_points_raw)
                # Remove empty strings that may result from parsing
                highlight_vals <- highlight_vals[highlight_vals != ""]

                if (length(highlight_vals) > 0) {
                    # Get styling parameters
                    hl_color <- isolate(input$highlight.color)
                    hl_size <- isolate(input$highlight.size)
                    hl_border_color <- isolate(input$highlight.border.color)
                    hl_border_width <- isolate(input$highlight.border.width)

                    # Find indices of points to highlight in plot_data
                    annotate_col <- null.na.inputs$annotate.by
                    if (annotate_col %in% names(plot_data)) {
                        highlight_idx <- which(as.character(plot_data[[annotate_col]]) %in% highlight_vals)

                        if (length(highlight_idx) > 0 && !is.null(fig$x$data)) {
                            # Iterate through traces and modify marker properties
                            for (i in seq_along(fig$x$data)) {
                                trace <- fig$x$data[[i]]

                                # Skip traces without x/y data or non-scatter traces
                                if (is.null(trace$x) || is.null(trace$y)) next
                                if (!is.null(trace$type) && !trace$type %in% c("scatter", "scattergl")) next

                                # Match trace points to plot_data by coordinates
                                trace_n <- length(trace$x)

                                # Initialize marker properties if not present
                                if (is.null(trace$marker)) {
                                    fig$x$data[[i]]$marker <- list()
                                }

                                # Get current marker properties (may be single value or vector)
                                cur_color <- trace$marker$color
                                cur_size <- if (!is.null(trace$marker$size)) trace$marker$size else isolate(input$size)
                                cur_line_color <- if (!is.null(trace$marker$line$color)) trace$marker$line$color else "transparent"
                                cur_line_width <- if (!is.null(trace$marker$line$width)) trace$marker$line$width else 0

                                # Expand to vectors if single values
                                if (length(cur_color) == 1) cur_color <- rep(cur_color, trace_n)
                                if (length(cur_size) == 1) cur_size <- rep(cur_size, trace_n)
                                if (length(cur_line_color) == 1) cur_line_color <- rep(cur_line_color, trace_n)
                                if (length(cur_line_width) == 1) cur_line_width <- rep(cur_line_width, trace_n)

                                # Match trace points to highlight indices
                                # Use coordinate matching since trace order may differ
                                # Skip if trace$x or trace$y are not numeric (e.g., factors)
                                if (!is.numeric(trace$x) || !is.numeric(trace$y)) next

                                trace_coords <- paste0(round(trace$x, 10), "_", round(trace$y, 10))
                                plot_coords <- paste0(
                                    round(plot_data[[if (paste0(isolate(input$x.by), ".x.adj") %in% names(plot_data)) {
                                        paste0(isolate(input$x.by), ".x.adj")
                                    } else {
                                        isolate(input$x.by)
                                    }]], 10),
                                    "_",
                                    round(plot_data[[if (paste0(isolate(input$y.by), ".y.adj") %in% names(plot_data)) {
                                        paste0(isolate(input$y.by), ".y.adj")
                                    } else {
                                        isolate(input$y.by)
                                    }]], 10)
                                )
                                highlight_coords <- plot_coords[highlight_idx]

                                trace_highlight_mask <- trace_coords %in% highlight_coords

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

            if (!is.null(null.na.inputs$annotate.by) & !is.null(selected.data())) {
                # Determine the column names for matching against plotly's event_data coordinates
                # event_data returns the PLOTTED coordinates, which may be transformed via adj.fxn
                x_col <- isolate(input$x.by)
                y_col <- isolate(input$y.by)

                # Check if adjustment functions are applied - if so, use the adjusted column
                x_adj_col <- paste0(x_col, ".x.adj")
                y_adj_col <- paste0(y_col, ".y.adj")

                # Use adjusted columns if they exist (i.e., if an adjustment function was applied)
                if (x_adj_col %in% names(plot_data)) {
                    x_match_col <- x_adj_col
                } else {
                    x_match_col <- x_col
                }

                if (y_adj_col %in% names(plot_data)) {
                    y_match_col <- y_adj_col
                } else {
                    y_match_col <- y_col
                }

                # Extract data for annotation matching using the correctly transformed coordinates
                anno_data <- data.frame(
                    x = plot_data[[x_match_col]],
                    y = plot_data[[y_match_col]],
                    text = plot_data[[null.na.inputs$annotate.by]]
                )

                # Filter to rows of anno_data where the x and y columns BOTH match selected.data()$x and selected.data()$y in the same row
                # Round coordinates to avoid floating-point precision issues
                anno_data$xy <- paste0(round(anno_data$x, 10), "_", round(anno_data$y, 10))
                selected_xy <- paste0(round(selected.data()$x, 10), "_", round(selected.data()$y, 10))
                anno_data <- anno_data[anno_data$xy %in% selected_xy, ]

                # Map curveNumber to xref/yref for subplots
                # Extract axis references from the plotly figure for each trace
                trace_axis_map <- list()
                if (!is.null(fig) && !is.null(fig$x) && !is.null(fig$x$data) && length(fig$x$data) > 0) {
                    trace_axis_map <- lapply(seq_along(fig$x$data), function(i) {
                        trace <- fig$x$data[[i]]
                        # Get xaxis and yaxis references from trace
                        # Default to "x" and "y" if not specified
                        xaxis <- if (!is.null(trace$xaxis)) trace$xaxis else "x"
                        yaxis <- if (!is.null(trace$yaxis)) trace$yaxis else "y"
                        list(xaxis = xaxis, yaxis = yaxis)
                    })
                }

                # Create annotations list with correct xref/yref for each point
                # Match selected points to their trace and use corresponding axis references
                annos <- list()
                if (nrow(anno_data) > 0) {
                    # Cache selected.data() to avoid repeated calls
                    selected_data_cached <- selected.data()
                    has_curve_number <- "curveNumber" %in% names(selected_data_cached) &&
                        !is.null(selected_data_cached$curveNumber) &&
                        is.numeric(selected_data_cached$curveNumber)

                    for (i in seq_len(nrow(anno_data))) {
                        # Find matching selected data point to get curveNumber
                        xy_match <- paste0(round(anno_data$x[i], 10), "_", round(anno_data$y[i], 10))
                        selected_idx <- match(xy_match, selected_xy)

                        if (!is.na(selected_idx) &&
                            has_curve_number &&
                            selected_idx <= length(selected_data_cached$curveNumber)) {
                            curve_num <- selected_data_cached$curveNumber[selected_idx] + 1 # R is 1-indexed

                            # Get axis references for this trace
                            if (length(trace_axis_map) > 0 && curve_num <= length(trace_axis_map)) {
                                xref <- trace_axis_map[[curve_num]]$xaxis
                                yref <- trace_axis_map[[curve_num]]$yaxis
                            } else {
                                # Fallback to default
                                xref <- "x"
                                yref <- "y"
                            }
                        } else {
                            # Fallback to default if curveNumber not available
                            xref <- "x"
                            yref <- "y"
                        }

                        annos[[i]] <- list(
                            x = anno_data$x[i],
                            y = anno_data$y[i],
                            text = as.character(anno_data$text[i]),
                            xref = xref,
                            yref = yref,
                            ax = isolate(input$annotation.ax),
                            ay = isolate(input$annotation.ay),
                            showarrow = isolate(input$annotation.showarrow),
                            arrowcolor = isolate(input$annotation.arrowcolor),
                            arrowhead = isolate(input$annotation.arrowhead),
                            arrowwidth = isolate(input$annotation.arrowwidth),
                            font = list(
                                size = isolate(input$annotation.size),
                                color = isolate(input$annotation.color)
                            )
                        )
                    }
                }

                # Set to NULL if empty list
                if (length(annos) == 0) {
                    annos <- NULL
                }
            } else {
                annos <- NULL
            }

            # Auto-annotate highlighted points if enabled
            if (isTRUE(isolate(input$highlight.auto.annotate)) &&
                !is.null(null.na.inputs$annotate.by) &&
                !is.null(highlight_points_raw) &&
                highlight_points_raw != "") {
                highlight_vals <- .string_to_vector(highlight_points_raw)
                highlight_vals <- highlight_vals[highlight_vals != ""]

                if (length(highlight_vals) > 0) {
                    annotate_col <- null.na.inputs$annotate.by
                    if (annotate_col %in% names(plot_data)) {
                        # Get coordinate columns (same logic as manual annotations)
                        x_col <- isolate(input$x.by)
                        y_col <- isolate(input$y.by)
                        x_adj_col <- paste0(x_col, ".x.adj")
                        y_adj_col <- paste0(y_col, ".y.adj")
                        x_match_col <- if (x_adj_col %in% names(plot_data)) x_adj_col else x_col
                        y_match_col <- if (y_adj_col %in% names(plot_data)) y_adj_col else y_col

                        # Find highlighted point indices
                        highlight_idx <- which(as.character(plot_data[[annotate_col]]) %in% highlight_vals)

                        if (length(highlight_idx) > 0) {
                            # Create annotations for highlighted points
                            highlight_annos <- lapply(highlight_idx, function(idx) {
                                list(
                                    x = plot_data[[x_match_col]][idx],
                                    y = plot_data[[y_match_col]][idx],
                                    text = as.character(plot_data[[annotate_col]][idx]),
                                    xref = "x",
                                    yref = "y",
                                    ax = isolate(input$annotation.ax),
                                    ay = isolate(input$annotation.ay),
                                    showarrow = isolate(input$annotation.showarrow),
                                    arrowcolor = isolate(input$annotation.arrowcolor),
                                    arrowhead = isolate(input$annotation.arrowhead),
                                    arrowwidth = isolate(input$annotation.arrowwidth),
                                    font = list(
                                        size = isolate(input$annotation.size),
                                        color = isolate(input$annotation.color)
                                    )
                                )
                            })

                            # Combine with existing annotations (avoiding duplicates by coordinate)
                            if (is.null(annos)) {
                                annos <- highlight_annos
                            } else {
                                # Get existing annotation coordinates
                                existing_coords <- sapply(annos, function(a) {
                                    paste0(round(a$x, 10), "_", round(a$y, 10))
                                })
                                # Add only highlight annotations that don't already exist
                                for (ha in highlight_annos) {
                                    ha_coord <- paste0(round(ha$x, 10), "_", round(ha$y, 10))
                                    if (!ha_coord %in% existing_coords) {
                                        annos <- c(annos, list(ha))
                                        existing_coords <- c(existing_coords, ha_coord)
                                    }
                                }
                            }
                        }
                    }
                }
            }

            fig <- fig %>% layout(
                newshape = list(
                    fillcolor = isolate(input$shape.fill),
                    line = list(
                        color = isolate(input$shape.line.color),
                        width = isolate(input$shape.line.width),
                        dash = isolate(input$shape.linetype)
                    ),
                    opacity = isolate(input$shape.opacity)
                ),
                annotations = annos
            )

            # Apply axis styling to all subplot axes (handles faceting/split.by)
            xaxis_style <- list(
                showline = isolate(input$axis.showline),
                mirror = isolate(input$axis.mirror),
                linecolor = isolate(input$axis.linecolor),
                linewidth = isolate(input$axis.linewidth),
                tickfont = list(
                    size = isolate(input$axis.tickfont.size),
                    color = isolate(input$axis.tickfont.color),
                    family = isolate(input$axis.tickfont.family)
                ),
                tickangle = isolate(input$axis.tickangle.x),
                ticks = isolate(input$axis.ticks),
                tickcolor = isolate(input$axis.tickcolor),
                ticklen = isolate(input$axis.ticklen),
                tickwidth = isolate(input$axis.tickwidth)
            )

            yaxis_style <- list(
                showline = isolate(input$axis.showline),
                mirror = isolate(input$axis.mirror),
                linecolor = isolate(input$axis.linecolor),
                linewidth = isolate(input$axis.linewidth),
                tickfont = list(
                    size = isolate(input$axis.tickfont.size),
                    color = isolate(input$axis.tickfont.color),
                    family = isolate(input$axis.tickfont.family)
                ),
                tickangle = isolate(input$axis.tickangle.y),
                ticks = isolate(input$axis.ticks),
                tickcolor = isolate(input$axis.tickcolor),
                ticklen = isolate(input$axis.ticklen),
                tickwidth = isolate(input$axis.tickwidth)
            )

            fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

            if (isolate(input$webgl)) {
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
                    x.col = isolate(input$x.by),
                    y.col = isolate(input$y.by),
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
                    x.col = isolate(input$x.by),
                    y.col = isolate(input$y.by),
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
