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
#' @param update.button Logical; if `TRUE` (default), an "Update Plot" button is shown and plot only re-renders when clicked.
#'   If `FALSE`, plot re-renders immediately when inputs change.
#' @return The `moduleServer` function for the scatterPlot module.
#'
#' @importFrom ggplot2 theme_bw waiver
#' @importFrom shinyjs hide
#'
#' @seealso [dittoViz::scatterPlot()], [vizModules::organize_inputs()],
#' [vizModules::scatterPlotOutputUI()], [vizModules::scatterPlotServer()], [vizModules::createScatterPlotApp()]
#'
#' @export
#' @author Jared Andrews
scatterPlotServer <- function(id, data, hide.inputs = NULL, hide.tabs = NULL, manual.colors = NULL, update.button = TRUE) {
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

        # Hide update button if disabled
        if (!update.button) {
            hide("update")
        }

        # Set up wrapper function for isolate based on update.button parameter
        isolate_fn <- if (update.button) isolate else identity

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
                if (is.null(isolate_fn(input$color.panel)) || isolate_fn(input$color.panel) == "dittoColors") {
                    palette <- dittoColors()
                } else if (!is.null(isolate_fn(input$color.by))) {
                    if (isolate_fn(input$color.panel) %in% c("viridis", "magma", "inferno", "plasma", "cividis")) {
                        palette <- viridis_pal(option = isolate_fn(input$color.panel))(length(colLevels(isolate_fn(input$color.by), data())))
                    } else if (isolate_fn(input$color.panel) == "ggplot2") {
                        palette <- hue_pal()(length(colLevels(isolate_fn(input$color.by), data())))
                    } else {
                        palette <- brewer_pal(palette = isolate_fn(input$color.panel))(length(colLevels(isolate_fn(input$color.by), data())))
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
            if (update.button) {
                input$update
            }

            # Change textInputs and selectInputs to NULL if empty
            null.na.inputs <- list(
                "trajectory.group.by" = .na_to_null(isolate_fn(input$trajectory.group.by)),
                "add.trajectory.by.groups" = .na_to_null(isolate_fn(input$add.trajectory.by.groups)),
                "add.xline" = .na_to_null(isolate_fn(input$add.xline)),
                "add.yline" = .na_to_null(isolate_fn(input$add.yline)),
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
                color.panel = isolate_fn(color.panel()),
                colors = seq_along(isolate_fn(color.panel())),
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
                add.xline = as.numeric(.string_to_vector(null.na.inputs$add.xline)),
                xline.linetype = isolate_fn(input$xline.linetype),
                xline.color = isolate_fn(input$xline.color),
                add.yline = as.numeric(.string_to_vector(null.na.inputs$add.yline)),
                yline.linetype = isolate_fn(input$yline.linetype),
                yline.color = isolate_fn(input$yline.color),
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
            if (!is.null(manual.colors)) {
                if (is.reactive(manual.colors)) {
                    color_mapping <- manual.colors()
                } else {
                    color_mapping <- manual.colors
                }
            } else if (!is.null(isolate_fn(input$color.by)) && isolate_fn(input$color.by) != "") {
                color_levels <- colLevels(isolate_fn(input$color.by), data())
                color_mapping <- setNames(color.panel()[seq_along(color_levels)], color_levels)
            } else {
                color_mapping <- NULL
            }


            config_list <- .add_plot_config(download.format = isolate_fn(input$download.format), include.modebar.buttons = TRUE)
            fig <- do.call(config, c(list(p = p$plot), config_list))

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

                                # Skip traces without x/y data or non-scatter traces
                                if (is.null(trace$x) || is.null(trace$y)) next
                                if (!is.null(trace$type) && !trace$type %in% c("scatter", "scattergl")) next

                                # Skip "show.others" traces (background points in faceted plots)
                                # These have a single text element and shouldn't be highlighted
                                if (!is.null(trace$text) && length(trace$text) == 1) next

                                # Match trace points to plot_data by coordinates
                                trace_n <- length(trace$x)

                                # Initialize marker properties if not present
                                if (is.null(trace$marker)) {
                                    fig$x$data[[i]]$marker <- list()
                                }

                                # Get current marker properties (may be single value or vector)
                                cur_color <- trace$marker$color
                                cur_size <- if (!is.null(trace$marker$size)) trace$marker$size else isolate_fn(input$size)
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

                                # Parse trace text to get annotate.by value (will always be added to hover.data)
                                if (!is.null(trace$text)) {
                                    trace_anno <- strsplit(trace$text, "\\n")
                                    trace_anno <- lapply(trace_anno, function(x) {
                                        y <- grep(isolate_fn(input$annotate.by), x, value = TRUE)
                                        y <- strsplit(y, " ")[[1]][2]
                                        y
                                    })
                                    trace_anno <- unlist(trace_anno)
                                }

                                trace_coords <- data.frame(
                                    xy = trace_coords,
                                    anno = trace_anno
                                )

                                plot_coords <- paste0(
                                    round(plot_data[[if (paste0(isolate_fn(input$x.by), ".x.adj") %in% names(plot_data)) {
                                        paste0(isolate_fn(input$x.by), ".x.adj")
                                    } else {
                                        isolate_fn(input$x.by)
                                    }]], 10),
                                    "_",
                                    round(plot_data[[if (paste0(isolate_fn(input$y.by), ".y.adj") %in% names(plot_data)) {
                                        paste0(isolate_fn(input$y.by), ".y.adj")
                                    } else {
                                        isolate_fn(input$y.by)
                                    }]], 10)
                                )
                                highlight_coords <- plot_coords[highlight_idx]

                                trace_highlight_mask <- trace_coords$xy %in% highlight_coords & trace_coords$anno %in% highlight_vals

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
                        list(xaxis = xaxis, yaxis = yaxis, keep = ifelse(length(trace$text) > 1, TRUE, FALSE))
                    })
                }

                # Filter selected.data() to points that are not from skipped traces
                keep_idx <- unlist(lapply(trace_axis_map, function(x) x$keep))
                selected_data_cached <- selected.data()[selected.data()$curveNumber %in% which(keep_idx), ]

                # Create annotations list with correct xref/yref for each point
                # Use curveNumber to extract annotation values from trace text for robust matching
                annos <- list()
                if (nrow(selected_data_cached) > 0) {
                    has_curve_number <- "curveNumber" %in% names(selected_data_cached) &&
                        !is.null(selected_data_cached$curveNumber) &&
                        is.numeric(selected_data_cached$curveNumber)

                    if (has_curve_number) {
                        # Process each selected point by extracting annotation from its trace
                        for (i in seq_len(nrow(selected_data_cached))) {
                            curve_num <- selected_data_cached$curveNumber[i] + 1 # R is 1-indexed

                            # Get axis references for this trace
                            if (length(trace_axis_map) > 0 && curve_num <= length(trace_axis_map)) {
                                xref <- trace_axis_map[[curve_num]]$xaxis
                                yref <- trace_axis_map[[curve_num]]$yaxis
                            } else {
                                # Fallback to default
                                xref <- "x"
                                yref <- "y"
                            }

                            # Extract annotation text from the trace data
                            trace <- fig$x$data[[curve_num]]
                            if (!is.null(trace$x) && !is.null(trace$y) && !is.null(trace$text)) {
                                # Match selected point coordinates to trace coordinates
                                trace_coords <- paste0(round(trace$x, 10), "_", round(trace$y, 10))
                                selected_coord <- paste0(
                                    round(selected_data_cached$x[i], 10),
                                    "_",
                                    round(selected_data_cached$y[i], 10)
                                )

                                # Find matching point in trace
                                point_idx <- which(trace_coords == selected_coord)

                                if (length(point_idx) > 0) {
                                    # Extract annotation value from trace text
                                    # Use the first match if multiple points share coordinates within same trace
                                    point_text <- trace$text[point_idx[1]]

                                    # Parse the text to extract annotate.by value
                                    text_lines <- strsplit(point_text, "\\n")[[1]]
                                    anno_line <- grep(isolate_fn(input$annotate.by), text_lines, value = TRUE)

                                    if (length(anno_line) > 0) {
                                        # Extract the annotation value (format: "annotate.by: value")
                                        anno_text <- strsplit(anno_line[1], ": ")[[1]]
                                        if (length(anno_text) >= 2) {
                                            anno_text <- anno_text[2]
                                        } else {
                                            # Fallback to splitting by space if colon not found
                                            anno_text <- strsplit(anno_line[1], " ")[[1]][2]
                                        }

                                        annos[[length(annos) + 1]] <- list(
                                            x = selected_data_cached$x[i],
                                            y = selected_data_cached$y[i],
                                            text = anno_text,
                                            xref = xref,
                                            yref = yref,
                                            ax = isolate_fn(input$annotation.ax),
                                            ay = isolate_fn(input$annotation.ay),
                                            showarrow = isolate_fn(input$annotation.showarrow),
                                            arrowcolor = isolate_fn(input$annotation.arrowcolor),
                                            arrowhead = isolate_fn(input$annotation.arrowhead),
                                            arrowwidth = isolate_fn(input$annotation.arrowwidth),
                                            font = list(
                                                size = isolate_fn(input$annotation.size),
                                                color = isolate_fn(input$annotation.color)
                                            )
                                        )
                                    }
                                }
                            }
                        }
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
            if (isTRUE(isolate_fn(input$highlight.auto.annotate)) &&
                !is.null(null.na.inputs$annotate.by) &&
                !is.null(highlight_points_raw) &&
                highlight_points_raw != "") {
                highlight_vals <- .string_to_vector(highlight_points_raw)
                highlight_vals <- highlight_vals[highlight_vals != ""]

                if (length(highlight_vals) > 0) {
                    annotate_col <- null.na.inputs$annotate.by
                    if (annotate_col %in% names(plot_data)) {
                        # Get coordinate columns (same logic as manual annotations)
                        x_col <- isolate_fn(input$x.by)
                        y_col <- isolate_fn(input$y.by)
                        x_adj_col <- paste0(x_col, ".x.adj")
                        y_adj_col <- paste0(y_col, ".y.adj")
                        x_match_col <- if (x_adj_col %in% names(plot_data)) x_adj_col else x_col
                        y_match_col <- if (y_adj_col %in% names(plot_data)) y_adj_col else y_col

                        # Find highlighted point indices
                        highlight_idx <- which(as.character(plot_data[[annotate_col]]) %in% highlight_vals)

                        if (length(highlight_idx) > 0) {
                            # Map curveNumber to xref/yref for subplots (same as manual annotations)
                            trace_axis_map <- list()
                            if (!is.null(fig) && !is.null(fig$x) && !is.null(fig$x$data) && length(fig$x$data) > 0) {
                                trace_axis_map <- lapply(seq_along(fig$x$data), function(i) {
                                    trace <- fig$x$data[[i]]
                                    xaxis <- if (!is.null(trace$xaxis)) trace$xaxis else "x"
                                    yaxis <- if (!is.null(trace$yaxis)) trace$yaxis else "y"
                                    list(xaxis = xaxis, yaxis = yaxis)
                                })
                            }

                            # Create coordinate lookup for matching points to traces
                            highlight_coords <- paste0(
                                round(plot_data[[x_match_col]][highlight_idx], 10),
                                "_",
                                round(plot_data[[y_match_col]][highlight_idx], 10)
                            )

                            # Create annotations for highlighted points
                            # Match each point to its trace to get correct xref/yref
                            highlight_annos <- list()
                            for (h_idx in seq_along(highlight_idx)) {
                                idx <- highlight_idx[h_idx]
                                h_coord <- highlight_coords[h_idx]

                                # Find which trace(s) contain this point
                                # Skip "show.others" traces (length(trace$text) == 1)
                                for (i in seq_along(fig$x$data)) {
                                    trace <- fig$x$data[[i]]

                                    # Skip non-scatter traces or traces without proper data
                                    if (is.null(trace$x) || is.null(trace$y)) next
                                    if (!is.null(trace$type) && !trace$type %in% c("scatter", "scattergl")) next

                                    # Skip "show.others" traces (background points)
                                    if (!is.null(trace$text) && length(trace$text) == 1) next

                                    # Match coordinates
                                    if (!is.numeric(trace$x) || !is.numeric(trace$y)) next
                                    trace_coords <- paste0(round(trace$x, 10), "_", round(trace$y, 10))

                                    # Check that trace coords and anno match highlight coords and vals
                                    trace_anno <- strsplit(trace$text, "\\n")
                                    trace_anno <- lapply(trace_anno, function(x) {
                                        y <- grep(isolate_fn(input$annotate.by), x, value = TRUE)
                                        y <- strsplit(y, " ")[[1]][2]
                                        y
                                    })
                                    trace_anno <- unlist(trace_anno)
                                    trace_coords <- data.frame(
                                        xy = trace_coords,
                                        anno = trace_anno
                                    )

                                    trace_coords <- trace_coords[trace_coords$anno %in% highlight_vals, ]

                                    if (h_coord %in% trace_coords$xy) {
                                        # Found a matching trace - use its axis references
                                        xref <- if (length(trace_axis_map) >= i) trace_axis_map[[i]]$xaxis else "x"
                                        yref <- if (length(trace_axis_map) >= i) trace_axis_map[[i]]$yaxis else "y"

                                        highlight_annos[[length(highlight_annos) + 1]] <- list(
                                            x = plot_data[[x_match_col]][idx],
                                            y = plot_data[[y_match_col]][idx],
                                            text = as.character(plot_data[[annotate_col]][idx]),
                                            xref = xref,
                                            yref = yref,
                                            ax = isolate_fn(input$annotation.ax),
                                            ay = isolate_fn(input$annotation.ay),
                                            showarrow = isolate_fn(input$annotation.showarrow),
                                            arrowcolor = isolate_fn(input$annotation.arrowcolor),
                                            arrowhead = isolate_fn(input$annotation.arrowhead),
                                            arrowwidth = isolate_fn(input$annotation.arrowwidth),
                                            font = list(
                                                size = isolate_fn(input$annotation.size),
                                                color = isolate_fn(input$annotation.color)
                                            )
                                        )
                                        # Don't break - continue to check other traces for the same coordinates
                                        # This handles cases where the same point appears in multiple panels
                                    }
                                }
                            }

                            # Combine with existing annotations (avoiding duplicates by coordinate)
                            # Check for duplicates using coordinates and annotation text
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
            xaxis_style <- .create_axis_styles(input, axis_side = "x")
            yaxis_style <- .create_axis_styles(input, axis_side = "y")

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
