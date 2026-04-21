#' Create an Interactive Line Plot with plotly
#'
#' Generates a customizable interactive line plot using plotly, supporting grouping, faceting, axis adjustments, and color palettes.
#'
#' @param data A data.frame or tibble containing the data to plot.
#' @param x Character vector of column name(s) for the x-axis.
#'   Multiple columns create separate traces.
#' @param y Character vector of column name(s) for the y-axis.
#'   Multiple columns create separate traces.
#' @param palette.selection Character vector of hex colors for line colors.
#'   Used to assign colors to groups or traces.
#' @param plot.mode Character, plotly mode for plot type.
#'   Options: "lines", "markers", "lines+markers". Default: "lines".
#' @param line.type Character, line style.
#'   Options: "solid", "dot", "dash", "longdash", "dashdot", "longdashdot". Default: "solid".
#' @param colour.group.by Character or formula, column name(s) to group lines by color.
#'   Can be a formula like \code{~ column_name}. Ignored if multiple `x` or `y` columns are provided.
#'   Default: `NULL`.
#' @param show.legend Logical, whether to display the legend. Default: TRUE.
#' @param facet.by Optional character, column name to facet plots by.
#'   Creates subplots for each unique value. Default: NULL.
#' @param facet.scales Character, controls axis scaling across facets. Options: "fixed" (same for all), "free" (independent),
#'   "free_x" (independent x-axis), "free_y" (independent y-axis). Default: "fixed".
#' @param facet.nrow Optional integer, number of rows in the faceted subplot grid.
#'   If \code{NULL} (default), a single row is used unless \code{facet.ncol} is supplied,
#'   in which case the number of rows is derived from the number of facet levels.
#' @param facet.ncol Optional integer, number of columns in the faceted subplot grid.
#'   If \code{NULL} (default), columns are derived from \code{facet.nrow} and the number
#'   of facet levels. Only one of \code{facet.nrow} / \code{facet.ncol} needs to be set;
#'   if both are provided, \code{facet.nrow} takes precedence.
#' @param subplot.margin Numeric, spacing between facet panels as a fraction of the plot area. Default: 0.05.
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
#' @param title.font.color Character, hex color for plot title text. Default: "black".
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
#'     data = mtcars,
#'     x = "cyl",
#'     y = "mpg",
#'     plot.mode = "lines",
#'     line.type = "solid",
#'     colour.group.by = "mpg",
#'     palette.selection = palette,
#'     show.legend = TRUE
#' )
linePlot <- function(data, x, y, palette.selection, 
                     plot.mode = "lines", line.type = "solid", 
                     colour.group.by = NULL,
                     show.legend = TRUE, facet.by = NULL,
                     facet.scales = "fixed",
                     facet.nrow = NULL, facet.ncol = NULL,
                     subplot.margin = 0.05,
                     axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, axis.tickfont.size = 12,
                     axis.tickfont.color = "black", axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
                     axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, show.grid.x = TRUE, show.grid.y = TRUE,
                     title.text = "", title.font.size = 14, title.font.family = "Arial",
                     title.font.color = "black", y.title = NULL, x.title = NULL, flip.x = FALSE, flip.y = FALSE,
                     x.adjustment = NULL, y.adjustment = NULL, color.adjustment = NULL, order.by = NULL, error.colour = NULL, error.width = NULL, error.bar = FALSE) {
    # Unique x axis styling for linePlot:
    xaxis_style <- list(
        showline = axis.showline, mirror = axis.mirror, linecolor = axis.linecolor, linewidth = axis.linewidth,
        tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
        tickangle = axis.tickangle.x, ticks = axis.ticks, tickcolor = axis.tickcolor, ticklen = axis.ticklen, tickwidth = axis.tickwidth,
        title = x.title, autorange = TRUE, showgrid = show.grid.x
    )

    multi_axis <- xor(length(x) > 1, length(y) > 1)

    cat.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])

    if (!is.null(x.adjustment) && nzchar(x.adjustment)) {
        data <- adjust_column_values(df = data, x.col = x, x.adj.fun = x.adjustment)
        x.new <- x
        for (i in seq_along(x)) {
            adj_name <- paste(x[i], "adj", sep = ".")
            if (adj_name %in% names(data)) {
                x.new[i] <- adj_name
            }
        }
        x <- x.new
    }

    if (!is.null(y.adjustment) && nzchar(y.adjustment)) {
        data <- adjust_column_values(df = data, y.col = y, y.adj.fun = y.adjustment)
        y.new <- y
        for (i in seq_along(y)) {
            adj_name <- paste(y[i], "adj", sep = ".")
            if (adj_name %in% names(data)) {
                y.new[i] <- adj_name
            }
        }
        y <- y.new
    }

    if (!is.null(color.adjustment) && nzchar(color.adjustment) && !is.null(colour.group.by) && nzchar(colour.group.by)) {
        data <- adjust_column_values(df = data, color.col = colour.group.by, color.adj.fun = color.adjustment)
        adj_name <- paste(colour.group.by, "adj", sep = ".")

        if (adj_name %in% names(data)) {
            colour.group.by <- adj_name
        }
    }

    if (length(x) == 1 && x %in% cat.choices) {
        # Compute per-group mean and SD for error bars
        group_vars <- x
        if (!is.null(facet.by) && nzchar(facet.by)) {
            group_vars <- c(facet.by, group_vars)
        }

        if (!is.null(colour.group.by) && nzchar(colour.group.by)) {
            group_vars <- c(colour.group.by, group_vars)
        }

        ex <- data |>
            dplyr::group_by(dplyr::across(dplyr::all_of(group_vars))) |>
            dplyr::summarise(
                sd_y = if (length(y) == 1) stats::sd(.data[[y[1]]], na.rm = TRUE) else NA_real_,
                dplyr::across(
                    dplyr::all_of(y),
                    list(mean = ~ mean(.x, na.rm = TRUE)),
                    .names = "{.col}"
                ),
                .groups = "drop"
            )
        data <- ex
    } else {
        data <- data |>
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

    order.cols <- order.by
    if (is.null(order.cols)) {
        order.cols <- x
    }

    plot_data <- data
    if (!is.null(order.cols) && length(order.cols) > 0 && order.cols[1] %in% names(data)) {
        plot_data <- data[order(data[[order.cols[1]]]), ]
    }

    multi_axis <- xor(length(x) > 1, length(y) > 1)

    if (!is.null(colour.group.by) && nzchar(colour.group.by)) {
        color <- reformulate(colour.group.by)
    } else {
        color <- NULL
    }

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
                color = color,
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

        sharing <- .resolve_facet_sharing(facet.scales)
        nrows <- .resolve_facet_layout(length(facet_levels), facet.nrow, facet.ncol)
        fig <- subplot(
            plots, nrows = nrows, shareX = sharing$shareX, shareY = sharing$shareY,
            titleX = FALSE, titleY = FALSE, margin = subplot.margin
        )

        ncols <- max(1L, as.integer(ceiling(length(facet_levels) / nrows)))
        fig <- .apply_facet_subplot_spacing(
                    fig,
                    spacing = subplot.margin,
                    ncol = ncols,
                    nrow = nrows
                )    
      
        annotations <- .build_facet_annotations(
            facet_levels, x.title = x.title, y.title = y.title,
            nrows = nrows, fig = fig
        )

        fig <- fig |> layout(annotations = annotations)
        
  
      
    } else if (!is.null(facet.by) && facet.by != "" && multi_axis) {
        # Faceting with multi-axis: create subplots where each subplot contains all traces
        facet_levels <- unique(plot_data[[facet.by]])
        sharing <- .resolve_facet_sharing(facet.scales)
        nrows <- .resolve_facet_layout(length(facet_levels), facet.nrow, facet.ncol)

        plots <- list()
        first_facet <- TRUE
        for (n in seq_along(facet_levels)) {
            facet_data <- plot_data[plot_data[[facet.by]] == facet_levels[n], ]
            facet_fig <- plot_ly(data = facet_data, type = "scatter")
            facet_fig <- .add_multi_axis_traces(
                facet_fig, facet_data, x, y, order.cols, plot.mode,
                line.type, palette.selection,
                show.legend = first_facet
            )
            plots[[length(plots) + 1]] <- facet_fig
            first_facet <- FALSE
        }

        fig <- subplot(
            plots, nrows = nrows, shareX = sharing$shareX, shareY = sharing$shareY,
            titleX = FALSE, titleY = FALSE
        )
      
        ncols <- max(1L, as.integer(ceiling(length(facet_levels) / nrows)))
        fig <- .apply_facet_subplot_spacing(
                    fig,
                    spacing = subplot.margin,
                    ncol = ncols,
                    nrow = nrows
                ) 
      
        annotations <- .build_facet_annotations(
            facet_levels, x.title = x.title, y.title = y.title,
            nrows = nrows, fig = fig
        )
      

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
            color = color,
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
        fig <- .add_multi_axis_traces(
            fig, data, x, y, order.cols, plot.mode,
            line.type, palette.selection,
            show.legend = TRUE
        )
    }

    fig <- fig |> layout(
        title = list(
            text = title.text,
            font = list(size = title.font.size, family = title.font.family, color = title.font.color),
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
