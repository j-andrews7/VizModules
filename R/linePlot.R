#' Create an Interactive Line Plot with plotly
#'
#' Generates a customizable interactive line plot using plotly, supporting grouping, faceting, axis adjustments, and color palettes.
#'
#' @param reactive.data A data.frame or tibble containing the data to plot.
#' @param x Character vector of column name(s) for the x-axis. Multiple columns create separate traces.
#' @param y Character vector of column name(s) for the y-axis. Multiple columns create separate traces.
#' @param plot.mode Character, plotly mode for plot type. Options: "lines", "markers", "lines+markers". Default: "lines".
#' @param line.type Character, line style. Options: "solid", "dot", "dash", "longdash", "dashdot", "longdashdot". Default: "solid".
#' @param colour.group.by Character or formula, column name(s) to group lines by color. Can be a formula like \code{~ column_name}.
#' @param palette.selection Character vector of hex colors or palette name for line colors. Used to assign colors to groups or traces.
#' @param show.legend Logical, whether to display the legend. Default: TRUE.
#' @param facet.by Optional character, column name to facet plots by. Creates subplots for each unique value. Default: NULL.
#' @param facet.scales Character, controls axis scaling across facets. Options: "fixed" (same for all), "free" (independent),
#'   "free_x" (independent x-axis), "free_y" (independent y-axis). Default: "fixed".
#' @param order.by Optional character vector, column name(s) to order data by before plotting. Default: NULL.
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
#' @param show.grid.x Logical, whether to show gridlines on the x-axis. Default: TRUE.
#' @param show.grid.y Logical, whether to show gridlines on the y-axis. Default: TRUE.
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
#' @param error.width numeric input to set the width of the error bars on a plot with a categorical X axis and only 1 Y axis variable
#' @param error.colour hex colour input to set the colour of the error bars on a plot with a categorical X axis and only 1 Y axis variable
#' @param error.bar Boolean value to determine if error bars will be on or off on a plot with a categorical X axis and only 1 Y axis variable
#'
#' @return A plotly object representing the interactive line plot.
#'
#' @import plotly
#' @importFrom dplyr group_by summarise across all_of mutate
#' 
#' @author Jacob Martin, Jared Andrews
#' @export
#'
#' @examples
#' palette <- plotthis::palette_list[["Set2"]]
#' fig <- linePlot(
#'   reactive.data = mtcars,
#'   x = "cyl",
#'   y = "mpg",
#'   plot.mode = "lines",
#'   line.type = "solid",
#'   colour.group.by = "mpg",
#'   palette.selection = palette,
#'   show.legend = TRUE
#'   )
linePlot <- function(reactive.data, x, y, plot.mode, line.type, colour.group.by, palette.selection, show.legend, facet.by = NULL,
                     facet.scales = "fixed",
                     axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, axis.tickfont.size = 12,
                     axis.tickfont.color = "black", axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
                     axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, show.grid.x = TRUE, show.grid.y = TRUE,
                     title.text = "", title.font.size = 14, title.font.family = "Arial",
                     title.text.color = "black", y.title = NULL, x.title = NULL, flip.x = FALSE, flip.y = FALSE,
                     x.adjustment = NULL, y.adjustment = NULL, color.adjustment = NULL, order.by = NULL, error.colour = NULL, error.width = NULL, error.bar = FALSE) {
    # Unique x axis styling for linePlot:
    xaxis_style <- list(
        showline = axis.showline, mirror = axis.mirror, linecolor = axis.linecolor, linewidth = axis.linewidth,
        tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
        tickangle = axis.tickangle.x, ticks = axis.ticks, tickcolor = axis.tickcolor, ticklen = axis.ticklen, tickwidth = axis.tickwidth,
        title = x.title, autorange = TRUE, showgrid = show.grid.x
    )

    #Error Bars Mean Logic: 
    multi_axis <- xor(length(x) > 1, length(y) > 1)


    cat.choices <- c("", names(reactive.data)[vapply(reactive.data, function(x) !is.numeric(x), logical(1))])
    # if (x %in% cat.choices ){
    #     for (i in y){
    #         reactive.data <- reactive.data %>%
    #         dplyr::group_by(.data[[x]]) %>%      
    #         dplyr::mutate(
    #             ymean = mean(.data[[i]], na.rm = TRUE)        
    #         ) %>%
    #             dplyr::ungroup()

    #         reactive.data[[i]] <- reactive.data$ymean
    #         reactive.data$ymean <- NULL
    #     }
    # }

    if (length(x) == 1 && x %in% cat.choices) {
        # Compute per-group mean and SD for error bars
        group_vars <- x
        if (!is.null(facet.by) && nzchar(facet.by)) {
            group_vars <- c(facet.by, x)
        }
        ex <- reactive.data |>
            dplyr::group_by(dplyr::across(dplyr::all_of(group_vars))) |>
            dplyr::summarise(
                sd_y = if (length(y) == 1) stats::sd(.data[[y[1]]], na.rm = TRUE) else NA_real_,
                dplyr::across(
                    dplyr::all_of(y),
                    list(mean = ~mean(.x, na.rm = TRUE)),
                    .names = "{.col}"
                ),
                .groups = "drop"
            )
        reactive.data <- ex
    } else {
        reactive.data <- reactive.data |>
            dplyr::mutate(sd_y = NA)
    }

    # Y axis styling by editing unique aspects of the x axis styling
    yaxis_style <- xaxis_style
    yaxis_style$tickangle <- axis.tickangle.y
    yaxis_style$title <- y.title
    yaxis_style$showgrid <- show.grid.y

    if (flip.x) {
        xaxis_style$autorange <- "reversed"
    }

    if (flip.y) {
        yaxis_style$autorange <- "reversed"
    }

    # Clear per-axis titles when faceting - single titles added as annotations instead
    if (!is.null(facet.by) && facet.by != "") {
        xaxis_style$title <- NULL
        yaxis_style$title <- NULL
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
            # Only add error_y if sd_y exists and has non-NA values
            if ("sd_y" %in% names(facet_data) && any(!is.na(facet_data$sd_y)) && error.bar) {
                plot_params$error_y <- list(array = facet_data$sd_y, color = error.colour, thickness = error.width)
            }
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

        fig <- subplot(plots, nrows = 1, shareX = shareX, shareY = shareY, titleX = FALSE, titleY = FALSE, margin = 0.05)

        # Add subplot titles as annotations plus single axis titles
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
        # Add single X-axis title annotation at bottom center
        annotations <- c(annotations, list(list(
            x = 0.5,
            y = -0.1,
            xref = "paper",
            yref = "paper",
            text = x.title,
            showarrow = FALSE,
            xanchor = "center",
            yanchor = "top",
            font = list(size = 14)
        )))
        # Add single Y-axis title annotation at left center (rotated)
        annotations <- c(annotations, list(list(
            x = -0.05,
            y = 0.5,
            xref = "paper",
            yref = "paper",
            text = y.title,
            showarrow = FALSE,
            xanchor = "center",
            yanchor = "middle",
            textangle = -90,
            font = list(size = 14)
        )))
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
        # plots <- lapply(facet_levels, function(level) {
            # facet_data <- plot_data[plot_data[[facet.by]] == level, ]        
        plots <- list()
        first_facet <- TRUE
        for (n in seq_along(facet_levels)){
            facet_data <- plot_data[plot_data[[facet.by]] == facet_levels[n], ]
            # Initialize empty plot for this facet
            facet_fig <- plot_ly(data = facet_data, type = "scatter")

            # Add traces for multi-axis
            if (length(x) > 1) {
                for (i in seq_along(x)) {
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
                        showlegend = first_facet # Condtional on the first iteration therefore legend is not multiplied when there are multiple facets 
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
                for (i in seq_along(y)) {
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
                        showlegend = first_facet # Condtional on the first iteration therefore legend is not multiplied when there are multiple facets 
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
            plots[[length(plots) + 1]] <- facet_fig # Adding multiple lines plot for each facet to list of plots 
            first_facet <- FALSE # Set to false after first iteration 

            
        }
        # Combining all elements of plots list into one plotly element
        fig <- subplot(plots, nrows = 1, shareX = shareX, shareY = shareY, titleX = FALSE, titleY = FALSE, margin = 0.05)

        # Add subplot titles as annotations plus single axis titles
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
        # Add single X-axis title annotation at bottom center
        annotations <- c(annotations, list(list(
            x = 0.5,
            y = -0.1,
            xref = "paper",
            yref = "paper",
            text = x.title,
            showarrow = FALSE,
            xanchor = "center",
            yanchor = "top",
            font = list(size = 14)
        )))
        # Add single Y-axis title annotation at left center (rotated)
        annotations <- c(annotations, list(list(
            x = -0.05,
            y = 0.5,
            xref = "paper",
            yref = "paper",
            text = y.title,
            showarrow = FALSE,
            xanchor = "center",
            yanchor = "middle",
            textangle = -90,
            font = list(size = 14)
        )))
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

        # Only add error_y if sd_y exists and has non-NA values
        if ("sd_y" %in% names(plot_data) && any(!is.na(plot_data$sd_y)) && error.bar) {
            plot_params$error_y <- list(array = plot_data$sd_y, color = error.colour, thickness = error.width)
        }
        # Only add line parameter if mode is "lines" or "lines+markers"
        if (plot.mode %in% c("lines", "lines+markers")) {
            plot_params$line <- list(dash = line.type)
        }
        fig <- do.call(plot_ly, plot_params)
    }

    if (multi_axis && (is.null(facet.by) || facet.by == "")) {
        if (length(x) > 1) {
            for (i in seq_along(x)) {
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
            for (i in seq_along(y)) {
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
        margin = list(t = 70),
        showlegend = TRUE,
        xaxis = xaxis_style,
        yaxis = yaxis_style
    )

    # Apply axis styling to all subplot axes (handles faceting)
    fig <- .apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

    return(fig)
    }
