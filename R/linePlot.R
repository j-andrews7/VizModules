#' Create a plotly line plot
#'
#' @return A plotly object.
#'
#' @importFrom plotly plot_ly subplot add_trace
#'
#' @export
#' @author Jacob Martin
linePlot <- function(reactive.data, x, y, plot.mode, line.type, colour.group.by, palette.selection, show.legend, facet.by = NULL,
                     facet.scales = "fixed",
                     axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, axis.tickfont.size = 12,
                     axis.tickfont.color = "black", axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
                     axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, title.text = "", title.font.size = 14, title.font.family = "Arial",
                     title.text.color = "black", y.title = NULL, x.title = NULL, flip.x = FALSE, flip.y = FALSE,
                     x.adjustment = NULL, y.adjustment = NULL, color.adjustment = NULL, order.by = NULL) {
    # Unique x axis styling for linePlot:
    xaxis_style <- list(
        showline = axis.showline, mirror = axis.mirror, linecolor = axis.linecolor, linewidth = axis.linewidth,
        tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
        tickangle = axis.tickangle.x, ticks = axis.ticks, tickcolor = axis.tickcolor, ticklen = axis.ticklen, tickwidth = axis.tickwidth,
        title = x.title, autorange = TRUE
    )

    # Y axis styling by editing unique aspects of the x axis styling
    yaxis_style <- xaxis_style
    yaxis_style$tickangle <- axis.tickangle.y
    yaxis_style$title <- y.title

    if (flip.x) {
        xaxis_style$autorange <- "reversed"
    }

    if (flip.y) {
        yaxis_style$autorange <- "reversed"
    }

    # Making axis adjustments if the parameters are not NULL
    if (!is.null(x.adjustment) && x.adjustment != "") {
        reactive.data <- .adjust_column_values(df = reactive.data, x.col = x, x.adj.fun = x.adjustment)
        x.new <- x
        for (i in seq_along(x)) {
            adj_name <- paste(x[i], "adj", sep = ".")
            if (adj_name %in% names(reactive.data)) {
                x.new[i] <- adj_name
            }
        }
        x <- x.new
    }

    if (!is.null(y.adjustment) && y.adjustment != "") {
        reactive.data <- .adjust_column_values(df = reactive.data, y.col = y, y.adj.fun = y.adjustment)
        y.new <- y
        for (i in seq_along(y)) {
            adj_name <- paste(y[i], "adj", sep = ".")
            if (adj_name %in% names(reactive.data)) {
                y.new[i] <- adj_name
            }
        }
        y <- y.new
    }

    if (!is.null(color.adjustment) && color.adjustment != "") {
        reactive.data <- .adjust_column_values(df = reactive.data, color.col = colour.group.by, color.adj.fun = color.adjustment)
        colour.group.by.new <- colour.group.by
        for (i in seq_along(colour.group.by)) {
            adj_name <- paste(colour.group.by[i], "adj", sep = ".")
            if (adj_name %in% names(reactive.data)) {
                colour.group.by.new[i] <- adj_name
            }
        }
        colour.group.by <- colour.group.by.new
    }

    order.cols <- order.by
    if (is.null(order.cols)) {
        order.cols <- x
    }

    plot_data <- reactive.data
    if (!is.null(order.cols) && length(order.cols) > 0 && order.cols[1] %in% names(reactive.data)) {
        plot_data <- reactive.data[order(reactive.data[[order.cols[1]]]), ]
    }

    multi_axis <- xor(length(x) > 1, length(y) > 1)

    if (!is.null(facet.by) && facet.by != "" && !multi_axis) {
        # Split data by facet variable
        facet_levels <- unique(plot_data[[facet.by]])
        plots <- lapply(facet_levels, function(level) {
            facet_data <- plot_data[plot_data[[facet.by]] == level, ]
            # Build plot parameters conditionally
            plot_params <- list(
                data = facet_data,
                x = reformulate(x),
                y = reformulate(y),
                type = "scatter",
                mode = plot.mode,
                color = colour.group.by,
                colors = palette.selection,
                showlegend = show.legend
            )
            # Only add line parameter if mode is "lines" or "lines+markers"
            if (plot.mode %in% c("lines", "lines+markers")) {
                plot_params$line <- list(dash = line.type)
            }
            do.call(plot_ly, plot_params)
        })

        # Determine shareX and shareY based on facet.scales
        shareX <- TRUE
        shareY <- TRUE
        if (facet.scales == "free") {
            shareX <- FALSE
            shareY <- FALSE
        } else if (facet.scales == "free_x") {
            shareX <- FALSE
            shareY <- TRUE
        } else if (facet.scales == "free_y") {
            shareX <- TRUE
            shareY <- FALSE
        }

        fig <- subplot(plots, nrows = 1, shareX = shareX, shareY = shareY, titleX = TRUE, titleY = TRUE)
        
        # Add subplot titles as annotations
        n_facets <- length(facet_levels)
        annotations <- lapply(seq_along(facet_levels), function(i) {
            list(
                x = (i - 0.5) / n_facets,
                y = 1.02,
                xref = "paper",
                yref = "paper",
                text = as.character(facet_levels[i]),
                showarrow = FALSE,
                xanchor = "center",
                yanchor = "bottom",
                font = list(size = 12)
            )
        })
        fig <- fig |> layout(annotations = annotations)
    } else if (!is.null(facet.by) && facet.by != "" && multi_axis) {
        # Faceting with multi-axis: create subplots where each subplot contains all traces
        facet_levels <- unique(plot_data[[facet.by]])
        
        # Determine shareX and shareY based on facet.scales
        shareX <- TRUE
        shareY <- TRUE
        if (facet.scales == "free") {
            shareX <- FALSE
            shareY <- FALSE
        } else if (facet.scales == "free_x") {
            shareX <- FALSE
            shareY <- TRUE
        } else if (facet.scales == "free_y") {
            shareX <- TRUE
            shareY <- FALSE
        }
        
        plots <- lapply(facet_levels, function(level) {
            facet_data <- plot_data[plot_data[[facet.by]] == level, ]
            # Initialize empty plot for this facet
            facet_fig <- plot_ly(data = facet_data, type = "scatter")
            
            # Add traces for multi-axis
            if (length(x) > 1) {
                for (i in 1:length(x)) {
                    trace_data <- facet_data
                    sort_column <- order.cols[1]
                    if (!is.null(order.cols) && length(order.cols) >= i && order.cols[i] %in% names(trace_data)) {
                        sort_column <- order.cols[i]
                    }
                    if (!is.null(sort_column) && sort_column %in% names(trace_data)) {
                        trace_data <- trace_data[order(trace_data[[sort_column]]), ]
                    }
                    # Build trace parameters conditionally
                    trace_params <- list(
                        x = trace_data[[x[i]]],
                        y = trace_data[[y[1]]],
                        type = "scatter",
                        mode = plot.mode,
                        name = x[i],
                        showlegend = TRUE
                    )
                    # Only add line parameter if mode is "lines" or "lines+markers"
                    if (plot.mode %in% c("lines", "lines+markers")) {
                        trace_params$line <- list(dash = line.type, color = palette.selection[i])
                    }
                    # Add marker parameter with matching color for consistency
                    if (plot.mode %in% c("markers", "lines+markers")) {
                        trace_params$marker <- list(color = palette.selection[i])
                    }
                    facet_fig <- do.call(add_trace, c(list(facet_fig), trace_params))
                }
            }
            if (length(y) > 1) {
                for (i in 1:length(y)) {
                    trace_data <- facet_data
                    sort_column <- order.cols[1]
                    if (!is.null(order.cols) && length(order.cols) >= i && order.cols[i] %in% names(trace_data)) {
                        sort_column <- order.cols[i]
                    }
                    if (!is.null(sort_column) && sort_column %in% names(trace_data)) {
                        trace_data <- trace_data[order(trace_data[[sort_column]]), ]
                    }
                    # Build trace parameters conditionally
                    trace_params <- list(
                        x = trace_data[[x[1]]],
                        y = trace_data[[y[i]]],
                        type = "scatter",
                        mode = plot.mode,
                        name = y[i],
                        showlegend = TRUE
                    )
                    # Only add line parameter if mode is "lines" or "lines+markers"
                    if (plot.mode %in% c("lines", "lines+markers")) {
                        trace_params$line <- list(dash = line.type, color = palette.selection[i])
                    }
                    # Add marker parameter with matching color for consistency
                    if (plot.mode %in% c("markers", "lines+markers")) {
                        trace_params$marker <- list(color = palette.selection[i])
                    }
                    facet_fig <- do.call(add_trace, c(list(facet_fig), trace_params))
                }
            }
            
            facet_fig
        })
        
        fig <- subplot(plots, nrows = 1, shareX = shareX, shareY = shareY, titleX = TRUE, titleY = TRUE)
        
        # Add subplot titles as annotations
        n_facets <- length(facet_levels)
        annotations <- lapply(seq_along(facet_levels), function(i) {
            list(
                x = (i - 0.5) / n_facets,
                y = 1.02,
                xref = "paper",
                yref = "paper",
                text = as.character(facet_levels[i]),
                showarrow = FALSE,
                xanchor = "center",
                yanchor = "bottom",
                font = list(size = 12)
            )
        })
        fig <- fig |> layout(annotations = annotations)
    } else if (multi_axis) {
        # Initialize empty plot for multi-axis to avoid creating initial trace
        fig <- plot_ly(data = plot_data, type = "scatter")
    } else {
        # Build plot parameters conditionally
        plot_params <- list(
            data = plot_data,
            x = reformulate(x),
            y = reformulate(y),
            type = "scatter",
            mode = plot.mode,
            color = colour.group.by,
            colors = palette.selection,
            showlegend = show.legend
        )
        # Only add line parameter if mode is "lines" or "lines+markers"
        if (plot.mode %in% c("lines", "lines+markers")) {
            plot_params$line <- list(dash = line.type)
        }
        fig <- do.call(plot_ly, plot_params)
    }

    if (multi_axis && (is.null(facet.by) || facet.by == "")) {
        if (length(x) > 1) {
            for (i in 1:length(x)) {
                trace_data <- reactive.data
                sort_column <- order.cols[1]
                if (!is.null(order.cols) && length(order.cols) >= i && order.cols[i] %in% names(trace_data)) {
                    sort_column <- order.cols[i]
                }
                if (!is.null(sort_column) && sort_column %in% names(trace_data)) {
                    trace_data <- trace_data[order(trace_data[[sort_column]]), ]
                }
                # Build trace parameters conditionally
                trace_params <- list(
                    x = trace_data[[x[i]]],
                    y = trace_data[[y[1]]],
                    type = "scatter",
                    mode = plot.mode,
                    name = x[i],
                    showlegend = TRUE
                )
                # Only add line parameter if mode is "lines" or "lines+markers"
                if (plot.mode %in% c("lines", "lines+markers")) {
                    trace_params$line <- list(dash = line.type, color = palette.selection[i])
                }
                # Add marker parameter with matching color for consistency
                if (plot.mode %in% c("markers", "lines+markers")) {
                    trace_params$marker <- list(color = palette.selection[i])
                }
                fig <- do.call(add_trace, c(list(fig), trace_params))
            }
        }
        if (length(y) > 1) {
            for (i in 1:length(y)) {
                trace_data <- reactive.data
                sort_column <- order.cols[1]
                if (!is.null(order.cols) && length(order.cols) >= i && order.cols[i] %in% names(trace_data)) {
                    sort_column <- order.cols[i]
                }
                if (!is.null(sort_column) && sort_column %in% names(trace_data)) {
                    trace_data <- trace_data[order(trace_data[[sort_column]]), ]
                }
                # Build trace parameters conditionally
                trace_params <- list(
                    x = trace_data[[x[1]]],
                    y = trace_data[[y[i]]],
                    type = "scatter",
                    mode = plot.mode,
                    name = y[i],
                    showlegend = TRUE
                )
                # Only add line parameter if mode is "lines" or "lines+markers"
                if (plot.mode %in% c("lines", "lines+markers")) {
                    trace_params$line <- list(dash = line.type, color = palette.selection[i])
                }
                # Add marker parameter with matching color for consistency
                if (plot.mode %in% c("markers", "lines+markers")) {
                    trace_params$marker <- list(color = palette.selection[i])
                }
                fig <- do.call(add_trace, c(list(fig), trace_params))
            }
        }
    }

    fig <- fig |> layout(
        title = list(
            text = title.text,
            font = list(size = title.font.size, family = title.font.family, color = title.text.color),
            x = 0.47, xanchor = "center", y = 0.95, yanchor = "top", pad = list(t = 20)
        ),
        margin = list(t = 80),
        showlegend = TRUE,
        xaxis = xaxis_style,
        yaxis = yaxis_style
    )

    # Apply axis styling to all subplot axes (handles faceting)
    fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

    return(fig)
}
