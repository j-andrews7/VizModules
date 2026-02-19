dumbellPlot <- function(reactive.data, x, x_end, y, colour.group.by, palette.selection, show.legend, facet.by = NULL, line.colour = "red",
                     facet.scales = "fixed",
                     axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, axis.tickfont.size = 12,
                     axis.tickfont.color = "black", axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
                     axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, title.text = "", title.font.size = 14, title.font.family = "Arial",
                     title.text.color = "black", y.title = NULL, x.title = NULL, flip.x = FALSE, flip.y = FALSE,
                     x.adjustment = NULL, y.adjustment = NULL, color.adjustment = NULL, order.by = NULL) {
    # Unique x axis styling for dumbellPlot:
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
        reactive.data <- .adjust_column_values(df = reactive.data, x.col = x_end, x.adj.fun = x.adjustment)
        x.new <- x
        x.end.new <- x_end
        for (i in seq_along(x)) {
            adj_name <- paste(x[i], "adj", sep = ".")
            if (adj_name %in% names(reactive.data)) {
                x.new[i] <- adj_name
            }
        }
        for (i in seq_along(x_end)) {
            adj_name <- paste(x_end[i], "adj", sep = ".")
            if (adj_name %in% names(reactive.data)) {
                x.end.new[i] <- adj_name
            }
        }
        x <- x.new
        x_end <- x.end.new
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

  #IF FACET = ON and MULTI AXIS = FALSE
    if (!is.null(facet.by) && facet.by != "" && !multi_axis) {



      facet_levels <- unique(plot_data[[facet.by]])

      plots <- lapply(facet_levels, function(level) {
          facet_data <- plot_data[plot_data[[facet.by]] == level, ]
          # Build plot parameters conditionally
                    # Split data by facet variable
          fig <- plot_ly(facet_data, color = I(line.colour)) # Creating intial Plot 
        
          fig <- fig %>% add_segments(x = ~x, xend = ~x_end, y = ~y, yend = ~y, showlegend = FALSE)
          fig <- fig %>% add_markers(x = ~x, y = ~y, name = x, color = I(palette.selection))
          return(fig)
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
      # Calculate subplot domain width (accounting for spacing between subplots)
      # Plotly subplots have small gaps, so we adjust positioning
      subplot_width <- 1.0 / n_facets
      annotations <- lapply(seq_along(facet_levels), function(i) {
          # Position at center of each subplot's domain
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