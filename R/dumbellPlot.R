dumbellPlot <- function(reactive.data, x, y, colour.by = "X variables", palette.selection, show.legend = TRUE, 
                        facet.by = NULL, line.colour = "gray80",
                        facet.scales = "fixed",
                        axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, 
                        axis.tickfont.size = 12, axis.tickfont.color = "black", axis.tickfont.family = "Arial", 
                        axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
                        axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, 
                        title.text = "", title.font.size = 14, title.font.family = "Arial",
                        title.text.color = "black", y.title = NULL, x.title = NULL, 
                        flip.x = FALSE, flip.y = FALSE,
                        x.adjustment = NULL, order.by = NULL) {
    
    # Ensure max 2 x values
    if (!is.null(x) && length(x) > 2) {
        x <- x[1:2]
    }
    
    # Unique x axis styling for dumbellPlot:
    xaxis_style <- list(
        showline = axis.showline, mirror = axis.mirror, linecolor = axis.linecolor, linewidth = axis.linewidth,
        tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
        tickangle = axis.tickangle.x, ticks = axis.ticks, tickcolor = axis.tickcolor, ticklen = axis.ticklen, 
        tickwidth = axis.tickwidth,
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

    # Order data if needed
    order.cols <- order.by
    if (is.null(order.cols) && !is.null(x) && length(x) > 0) {
        order.cols <- x[1]
    }

    plot_data <- reactive.data
    if (!is.null(order.cols) && length(order.cols) > 0 && order.cols[1] %in% names(reactive.data)) {
        plot_data <- reactive.data[order(reactive.data[[order.cols[1]]]), ]
    }

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

    # Main plotting logic
    if (!is.null(facet.by) && facet.by != "") {
        # WITH FACETING
        facet_levels <- unique(plot_data[[facet.by]])
        
        plots <- lapply(facet_levels, function(level) {
            facet_data <- plot_data[plot_data[[facet.by]] == level, ]
            create_dumbbell_plot(facet_data, x, y, colour.by, palette.selection, line.colour, show.legend)
        })
        
        fig <- subplot(plots, nrows = 1, shareX = shareX, shareY = shareY, titleX = TRUE, titleY = TRUE)
        
        # Add subplot titles as annotations
        n_facets <- length(facet_levels)
        subplot_width <- 1.0 / n_facets
        annotations <- lapply(seq_along(facet_levels), function(i) {
            x_pos <- (i - 1) * subplot_width + (subplot_width / 2)
            list(
                x = x_pos,
                y = 1.05,
                xref = "paper",
                yref = "paper",
                text = as.character(facet_levels[i]),
                showarrow = FALSE,
                xanchor = "center",
                yanchor = "bottom",
                font = list(size = 14)
            )
        })
        fig <- fig |> layout(annotations = annotations)
    } else {
        # WITHOUT FACETING
        fig <- create_dumbbell_plot(plot_data, x, y, colour.by, palette.selection, line.colour, show.legend)
    }

    fig <- fig |> layout(
        title = list(
            text = title.text,
            font = list(size = title.font.size, family = title.font.family, color = title.text.color),
            x = 0.47, xanchor = "center", y = 0.95, yanchor = "top", pad = list(t = 20)
        ),
        margin = list(t = 80),
        showlegend = show.legend,
        xaxis = xaxis_style,
        yaxis = yaxis_style
    )

    # Apply axis styling to all subplot axes (handles faceting)
    fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

    return(fig)
}

# Helper function to create dumbbell plot for a single dataset
create_dumbbell_plot <- function(data, x, y, colour.by, palette.selection, line.colour, show.legend) {
    if (is.null(x) || length(x) == 0) {
        return(plot_ly())
    }
    
    # Initialize empty plot
    fig <- plot_ly(data, type = "scatter")
    
    if (length(x) == 1) {
        # SINGLE DOT MODE
        if (colour.by == "X variables") {
            # Color by X variable (single color for all points)
            fig <- fig %>% add_markers(
                x = data[[x[1]]],
                y = data[[y]],
                name = x[1],
                marker = list(color = palette.selection[1]),
                showlegend = show.legend
            )
        } else {
            # Color by Y variables (different color for each y value)
            fig <- plot_ly(data, 
                x = reformulate(x[1]),
                y = reformulate(y),
                type = "scatter",
                mode = "markers",
                color = reformulate(y),
                colors = palette.selection,
                showlegend = show.legend
            )
        }
    } else if (length(x) == 2) {
        # DUMBBELL MODE (2 X values)
        if (colour.by == "X variables") {
            # Color by X variables (different colors for each x variable)
            # Add connecting segments
            fig <- fig %>% add_segments(
                x = data[[x[1]]],
                xend = data[[x[2]]],
                y = data[[y]],
                yend = data[[y]],
                line = list(color = line.colour),
                showlegend = FALSE,
                hoverinfo = "skip"
            )
            # Add start markers
            fig <- fig %>% add_markers(
                x = data[[x[1]]],
                y = data[[y]],
                name = x[1],
                marker = list(color = palette.selection[1]),
                showlegend = show.legend
            )
            # Add end markers
            fig <- fig %>% add_markers(
                x = data[[x[2]]],
                y = data[[y]],
                name = x[2],
                marker = list(color = palette.selection[min(2, length(palette.selection))]),
                showlegend = show.legend
            )
        } else {
            # Color by Y variables (same color for start/end, different colors per y category)
            # Get unique y values for coloring
            y_unique <- unique(data[[y]])
            
            # Create color mapping
            color_map <- setNames(palette.selection[seq_along(y_unique) %% length(palette.selection) + 1], y_unique)
            
            # Add segments and markers for each y value
            for (i in seq_along(y_unique)) {
                y_val <- y_unique[i]
                y_data <- data[data[[y]] == y_val, ]
                color_idx <- (i - 1) %% length(palette.selection) + 1
                
                # Add segment
                fig <- fig %>% add_segments(
                    x = y_data[[x[1]]],
                    xend = y_data[[x[2]]],
                    y = y_data[[y]],
                    yend = y_data[[y]],
                    line = list(color = palette.selection[color_idx]),
                    showlegend = FALSE,
                    hoverinfo = "skip"
                )
                # Add start markers
                fig <- fig %>% add_markers(
                    x = y_data[[x[1]]],
                    y = y_data[[y]],
                    name = as.character(y_val),
                    marker = list(color = palette.selection[color_idx]),
                    showlegend = (i == 1) && show.legend,
                    legendgroup = as.character(y_val)
                )
                # Add end markers
                fig <- fig %>% add_markers(
                    x = y_data[[x[2]]],
                    y = y_data[[y]],
                    name = as.character(y_val),
                    marker = list(color = palette.selection[color_idx]),
                    showlegend = FALSE,
                    legendgroup = as.character(y_val)
                )
            }
        }
    }
    
    return(fig)
}
