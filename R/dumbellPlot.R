#' Create an Interactive Dumbbell Plot with plotly
#'
#' Generates a customizable interactive dumbbell plot using plotly, supporting grouping, faceting, multi-axis, and color palettes.
#' Dumbbell plots are useful for comparing two values for the same category, showing the start and end points connected by a line.
#'
#' @param reactive.data A data.frame or tibble containing the data to plot.
#' @param x Character vector of column name(s) for the x-axis start values. Multiple columns create separate dumbbell sets.
#' @param x_end Character vector of column name(s) for the x-axis end values. Must match length of x parameter.
#' @param y Character vector of column name(s) for the y-axis. Multiple columns create separate dumbbell sets.
#' @param colour.group.by Character or formula, column name(s) to group by color. Can be a formula like \code{~ column_name}.
#' @param palette.selection Character vector of hex colors or palette name for marker colors.
#' @param show.legend Logical, whether to display the legend. Default: TRUE.
#' @param facet.by Optional character, column name to facet plots by. Creates subplots for each unique value. Default: NULL.
#' @param line.colour Character, hex color for the connecting lines between start and end points. Default: "red".
#' @param facet.scales Character, controls axis scaling across facets. Options: "fixed" (same for all), "free" (independent),
#'   "free_x" (independent x-axis), "free_y" (independent y-axis). Default: "fixed".
#' @param axis.showline Logical, whether to show axis border lines. Default: TRUE.
#' @param axis.mirror Logical, whether to mirror axis lines on opposite side of plot. Default: TRUE.
#' @param axis.linecolor Character, hex color for axis lines. Default: "black".
#' @param axis.linewidth Numeric, width of axis lines in pixels. Default: 0.5.
#' @param axis.tickfont.size Numeric, font size for axis tick labels. Default: 12.
#' @param axis.tickfont.color Character, hex color for axis tick labels. Default: "black".
#' @param axis.tickfont.family Character, font family for axis tick labels. Default: "Arial".
#' @param axis.tickangle.x Numeric, rotation angle for x-axis tick labels in degrees. Default: 0.
#' @param axis.tickangle.y Numeric, rotation angle for y-axis tick labels in degrees. Default: 0.
#' @param axis.ticks Character, position of tick marks. Options: "outside", "inside", "none". Default: "outside".
#' @param axis.tickcolor Character, hex color for tick marks. Default: "black".
#' @param axis.ticklen Numeric, length of tick marks in pixels. Default: 5.
#' @param axis.tickwidth Numeric, width of tick marks in pixels. Default: 1.
#' @param title.text Character, main title text for the plot. Default: "".
#' @param title.font.size Numeric, font size for plot title. Default: 14.
#' @param title.font.family Character, font family for plot title. Default: "Arial".
#' @param title.text.color Character, hex color for plot title text. Default: "black".
#' @param y.title Optional character, label for y-axis. If NULL, auto-generated from column name. Default: NULL.
#' @param x.title Optional character, label for x-axis. If NULL, auto-generated from column name. Default: NULL.
#' @param flip.x Logical, whether to reverse the x-axis direction. Default: FALSE.
#' @param flip.y Logical, whether to reverse the y-axis direction. Default: FALSE.
#' @param x.adjustment Optional character or function, transformation to apply to x values.
#'   Options: "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt", or custom function. Default: NULL.
#' @param y.adjustment Optional character or function, transformation to apply to y values.
#'   Options: "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt", or custom function. Default: NULL.
#' @param color.adjustment Optional character or function, transformation to apply to color grouping variable.
#'   Same options as x.adjustment and y.adjustment. Default: NULL.
#' @param order.by Optional character vector, column name(s) to order data by before plotting. Default: NULL.
#'
#' @return A plotly object representing the interactive dumbbell plot.
#'
#' @import plotly
#' 
#' @author Jacob Martin, Jared Andrews
#' @export
#'
#' @examples
#' # Basic dumbbell plot
#' data <- data.frame(
#'   School = c("School A", "School B", "School C"),
#'   Women = c(30, 35, 40),
#'   Men = c(50, 55, 60)
#' )
#' fig <- dumbellPlot(
#'   reactive.data = data,
#'   x = "Women",
#'   x_end = "Men",
#'   y = "School",
#'   colour.group.by = "Women",
#'   palette.selection = c("pink", "blue"),
#'   show.legend = TRUE,
#'   line.colour = "gray"
#' )
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

    multi_axis <- xor(length(x) > 1, length(x_end) > 1)

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

    # FACETING WITH SINGLE AXIS
    if (!is.null(facet.by) && facet.by != "" && !multi_axis) {

        facet_levels <- unique(plot_data[[facet.by]])

        plots <- lapply(facet_levels, function(level) {

            facet_data <- plot_data[plot_data[[facet.by]] == level, ]
          
            # Create initial plot with line color
            fig <- plot_ly(facet_data, color = I(line.colour))
          
            # Add segments (dumbbells)
            fig <- fig %>% add_segments(
                x = facet_data[[x[1]]],
                xend = facet_data[[x_end[1]]],
                y = facet_data[[y[1]]],
                yend = facet_data[[y[1]]],
                showlegend = FALSE
            )
          
            # Add start markers
            fig <- fig %>% add_markers(
                x = facet_data[[x[1]]],
                y = facet_data[[y[1]]],
                name = x[1],
                marker = list(color = palette.selection[1])
            )
          
            # Add end markers
            fig <- fig %>% add_markers(
                x = facet_data[[x_end[1]]],
                y = facet_data[[y[1]]],
                name = x_end[1],
                marker = list(color = palette.selection[if (length(palette.selection) > 1) 2 else 1])
            )
            return(fig)
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
      
    } else if (!is.null(facet.by) && facet.by != "" && multi_axis) {

        # FACETING WITH MULTI-AXIS
        facet_levels <- unique(plot_data[[facet.by]])
        plots <- list()
        first_facet <- TRUE

        for (n in seq_along(facet_levels)) {
            facet_data <- plot_data[plot_data[[facet.by]] == facet_levels[n], ]
            # Initialize empty plot for this facet
            facet_fig <- plot_ly(data = facet_data, type = "scatter")

            # Handle multiple x values
            if (length(x) > 1) {

                for (i in seq_along(x)) {

                    # Add segments
                    facet_fig <- facet_fig %>% add_segments(
                        x = facet_data[[x[i]]],
                        xend = facet_data[[x_end]],
                        y = facet_data[[y[1]]],
                        yend = facet_data[[y[1]]],
                        line = list(color = line.colour),
                        showlegend = FALSE
                    )
                  
                    # Add start markers
                    facet_fig <- facet_fig %>% add_markers(
                        x = facet_data[[x[i]]],
                        y = facet_data[[y[1]]],
                        name = x[i],
                        marker = list(color = palette.selection[((i - 1) %% length(palette.selection)) + 1]),
                        showlegend = first_facet
                    )
                  
                    # Add end markers
                    facet_fig <- facet_fig %>% add_markers(
                        x = facet_data[[x_end]],
                        y = facet_data[[y[1]]],
                        name = x_end,
                        marker = list(color = palette.selection[((i + length(x) - 1) %% length(palette.selection)) + 1]),
                        showlegend = first_facet
                    )
                }
            } else if (length(x_end) > 1){

              for (i in seq_along(x_end)) {

                    # Add segments
                    facet_fig <- facet_fig %>% add_segments(
                        x = facet_data[[x]],
                        xend = facet_data[[x_end[i]]],
                        y = facet_data[[y[1]]],
                        yend = facet_data[[y[1]]],
                        line = list(color = line.colour),
                        showlegend = FALSE
                    )
                
                    # Add start markers
                    facet_fig <- facet_fig %>% add_markers(
                        x = facet_data[[x_end[i]]],
                        y = facet_data[[y[1]]],
                        name = x_end[i],
                        marker = list(color = palette.selection[((i - 1) %% length(palette.selection)) + 1]),
                        showlegend = first_facet
                    )
                
                    # Add end markers
                    facet_fig <- facet_fig %>% add_markers(
                        x = facet_data[[x_end[i]]],
                        y = facet_data[[y[1]]],
                        name = x_end[i],
                        marker = list(color = palette.selection[((i + length(x_end) - 1) %% length(palette.selection)) + 1]),
                        showlegend = first_facet
                    )
              }
            }
            plots[[length(plots) + 1]] <- facet_fig
            first_facet <- FALSE
        }

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
    } else if (multi_axis) {
        # MULTI-AXIS WITHOUT FACETING
        fig <- plot_ly(data = plot_data, type = "scatter")

        # Handle multiple x values
        if (length(x) > 1) {

            fig <- fig %>% add_segments(
                x = plot_data[[x[1]]],
                xend = plot_data[[x_end]],
                y = plot_data[[y[1]]],
                yend = plot_data[[y[1]]],
                line = list(color = line.colour),
                showlegend = FALSE
            )
            # Add start markers
            fig <- fig %>% add_markers(
                x = plot_data[[x[1]]],
                y = plot_data[[y[1]]],
                name = x[1],
                marker = list(color = palette.selection[((1 - 1) %% length(palette.selection)) + 1]),
                showlegend = TRUE
            )
            # Add end markers
            fig <- fig %>% add_markers(
                x = plot_data[[x_end]],
                y = plot_data[[y[1]]],
                name = x_end,
                marker = list(color = palette.selection[((1 + length(x) - 1) %% length(palette.selection)) + 1]),
                showlegend = TRUE
            )
            first <- TRUE
            for (i in seq_along(x)) {
                # Add start markers
                if (!first){ # Making sure the first trace is not added twice 
                  fig <- fig %>% add_markers(
                      x = plot_data[[x[i]]],
                      y = plot_data[[y[1]]],
                      name = x[i],
                      marker = list(color = palette.selection[((i - 1) %% length(palette.selection)) + 1]),
                      showlegend = TRUE
                  )
                }
                first <- FALSE
            }
        } else if (length(x_end) > 1) {

          # Add segments
          fig <- fig %>% add_segments(
              x = plot_data[[x]],
              xend = plot_data[[x_end[1]]],
              y = plot_data[[y[1]]],
              yend = plot_data[[y[1]]],
              line = list(color = line.colour),
              showlegend = FALSE
          )
          # Add start markers
          fig <- fig %>% add_markers(
              x = plot_data[[x]],
              y = plot_data[[y[1]]],
              name = x,
              marker = list(color = palette.selection[((1 - 1) %% length(palette.selection)) + 1]),
              showlegend = TRUE
          )
          # Add end markers
          fig <- fig %>% add_markers(
              x = plot_data[[x_end[1]]],
              y = plot_data[[y[1]]],
              name = x_end,
              marker = list(color = palette.selection[((1 + length(x_end) - 1) %% length(palette.selection)) + 1]),
              showlegend = TRUE
          )
          first <- TRUE
          for (i in seq_along(x_end)) {
            if (!first){
              fig <- fig %>% add_markers(
              x = plot_data[[x_end[i]]],
              y = plot_data[[y[1]]],
              name = x_end,
              marker = list(color = palette.selection[((i + length(x_end) - 1) %% length(palette.selection)) + 1]),
              showlegend = TRUE
          )

            } 
          }
        }
    } else {
        # SINGLE AXIS WITHOUT FACETING
        fig <- plot_ly(plot_data, color = I(line.colour))
        # Add segments (dumbbells)
        fig <- fig %>% add_segments(
            x = plot_data[[x[1]]],
            xend = plot_data[[x_end[1]]],
            y = plot_data[[y[1]]],
            yend = plot_data[[y[1]]],
            showlegend = FALSE
        )
        # Add start markers
        fig <- fig %>% add_markers(
            x = plot_data[[x[1]]],
            y = plot_data[[y[1]]],
            name = x[1],
            marker = list(color = palette.selection[1])
        )
        # Add end markers
        fig <- fig %>% add_markers(
            x = plot_data[[x_end[1]]],
            y = plot_data[[y[1]]],
            name = x_end[1],
            marker = list(color = palette.selection[if (length(palette.selection) > 1) 2 else 1])
        )
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