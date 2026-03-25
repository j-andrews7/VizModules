#' Create an Interactive Dumbbell Plot with plotly
#'
#' Generates a customizable interactive dumbbell plot using plotly. Supports single dot mode (1 x variable)
#' or dumbbell mode (2 x variables), with flexible coloring by either X or Y variables, faceting, and transformations.
#'
#' @param data A data.frame or tibble containing the data to plot.
#' @param x Character vector of column name(s) for x-axis values. Maximum 2 values allowed.
#'   If 1 value: creates single dot plot. If 2 values: creates dumbbell plot with connecting segments.
#' @param y Character, column name for the y-axis (categorical variable recommended).
#' @param colour.by Character, how to color the markers. Options: "X variables" (different colors for each x variable)
#'   or "Y variables" (different colors for each y category). Default: "X variables".
#' @param palette.selection Character vector of hex colors for marker colors.
#' @param show.legend Logical, whether to display the legend. Default: TRUE.
#' @param facet.by Optional character, column name to facet plots by. Creates subplots for each unique value. Default: NULL.
#' @param line.colour Character, hex color for the connecting lines between dumbbell points. Default: "gray80".
#' @param facet.scales Character, controls axis scaling across facets. Options: "fixed" (same for all), "free" (independent),
#'   "free_x" (independent x-axis), "free_y" (independent y-axis). Default: "fixed".
#' @param subplot.margin Numeric, spacing between facet panels as a fraction of the plot area. Default: 0.06.
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
#' @param order.by Optional character vector, column name(s) to order data by before plotting. Default: NULL.
#'
#' @return A plotly object representing the interactive dumbbell plot.
#'
#' @details
#' The dumbbell plot is designed for comparing two values across categories.
#'
#' **Modes:**
#' - **Single dot mode** (1 x variable): Shows one marker per y category
#' - **Dumbbell mode** (2 x variables): Shows two markers connected by a line per y category
#'
#' **Coloring options:**
#' - **By X variables**: Each x variable gets a different color (e.g., Male=blue, Female=pink)
#' - **By Y variables**: Each y category gets a different color (e.g., School A=red, School B=blue)
#'
#' @import plotly
#'
#' @author Jacob Martin
#' @export
#'
#' @examples
#' data <- data.frame(
#'     School = c("MIT", "Stanford", "Harvard"),
#'     Women = c(152, 96, 112),
#'     Men = c(95, 151, 165)
#' )
#'
#' fig <- dumbbellPlot(
#'     data = data,
#'     x = c("Women", "Men"),
#'     y = "School",
#'     colour.by = "X variables",
#'     palette.selection = c("green", "blue"),
#'     show.legend = TRUE,
#'     line.colour = "gray80"
#' )
dumbbellPlot <- function(data, x, y, colour.by = "X variables", palette.selection, show.legend = TRUE, 
                        facet.by = NULL, line.colour = "gray80",
                        facet.scales = "fixed",
                        subplot.margin = 0.06,
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

    # Unique x axis styling for dumbbellPlot:
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
        data <- .adjust_column_values(df = data, x.col = x, x.adj.fun = x.adjustment)
        x.new <- x
        for (i in seq_along(x)) {
            adj_name <- paste(x[i], "adj", sep = ".")
            if (adj_name %in% names(data)) {
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

    plot_data <- data
    if (!is.null(order.cols) && length(order.cols) > 0 && order.cols[1] %in% names(data)) {
        plot_data <- data[order(data[[order.cols[1]]]), ]
    }

    sharing <- .resolve_facet_sharing(facet.scales)

    # Clear per-axis titles when faceting - single titles added as annotations instead
    if (!is.null(facet.by) && facet.by != "") {
        xaxis_style$title <- NULL
        yaxis_style$title <- NULL
    }

    # Main plotting logic
    if (!is.null(facet.by) && facet.by != "") {
        # WITH FACETING
        facet_levels <- unique(plot_data[[facet.by]])

        plots <- list()
        first <- TRUE # Ensure figure legend only added to the first subplot
        for (level in facet_levels) {
            facet_data <- plot_data[plot_data[[facet.by]] == level, ]
            plots[[length(plots) + 1]] <- .create_dumbbell_plot(
                facet_data, x, y, colour.by, palette.selection,
                line.colour,
                show.legend = first
            )
            first <- FALSE
        }

        fig <- subplot(
            plots, nrows = 1, shareX = sharing$shareX, shareY = sharing$shareY,
            titleX = FALSE, titleY = FALSE, margin = subplot.margin
        )

        annotations <- .build_facet_annotations(facet_levels, x.title = x.title, y.title = y.title)
        fig <- fig |> layout(annotations = annotations)
    } else {
        # WITHOUT FACETING
        fig <- .create_dumbbell_plot(plot_data, x, y, colour.by, palette.selection, line.colour, show.legend)
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

#' Create a Dumbbell Plot for a Single Dataset
#'
#' Helper function that generates a plotly scatter plot in either single dot or dumbbell mode
#' for one dataset (i.e., one facet). Called internally by \code{\link{dumbbellPlot}}.
#'
#' @param data A data.frame containing the data to plot.
#' @param x Character vector of column name(s) for x-axis values. Length 1 produces a single dot plot;
#'   length 2 produces a dumbbell plot with connecting segments.
#' @param y Character, column name for the y-axis (categorical variable).
#' @param colour.by Character, how to color the markers. Either \code{"X variables"} (one color per x variable)
#'   or \code{"Y variables"} (one color per y category).
#' @param palette.selection Character vector of hex colors used for marker coloring.
#' @param line.colour Character, hex color for the connecting line between dumbbell points.
#' @param show.legend Logical, whether to display the legend for this subplot.
#'
#' @return A plotly object representing the dumbbell (or single dot) plot for the supplied data.
#' 
#' @importFrom stats reformulate
#'
#' @author Jacob Martin
#' @rdname INTERNAL_create_dumbbell_plot
#' @keywords internal
.create_dumbbell_plot <- function(data, x, y, colour.by, palette.selection, line.colour, show.legend) {
    if (is.null(x) || length(x) == 0) {
        return(plot_ly())
    }

    # Initialize empty plot
    fig <- plot_ly(data, type = "scatter")

    if (length(x) == 1) {
        # SINGLE DOT MODE
        if (colour.by == "X variables") {
            # Color by X variable (single color for all points)
            fig <- fig |> add_markers(
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
            fig <- fig |> add_segments(
                x = data[[x[1]]],
                xend = data[[x[2]]],
                y = data[[y]],
                yend = data[[y]],
                line = list(color = line.colour),
                showlegend = FALSE,
                hoverinfo = "skip"
            )
            # Add start markers
            fig <- fig |> add_markers(
                x = data[[x[1]]],
                y = data[[y]],
                name = x[1],
                marker = list(color = palette.selection[1]),
                showlegend = show.legend
            )
            # Add end markers
            fig <- fig |> add_markers(
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

            # Add segments and markers for each y value
            for (i in seq_along(y_unique)) {
                y_val <- y_unique[i]
                y_data <- data[data[[y]] == y_val, ]
                color_idx <- (i - 1) %% length(palette.selection) + 1

                # Add segment
                fig <- fig |> add_segments(
                    x = y_data[[x[1]]],
                    xend = y_data[[x[2]]],
                    y = y_data[[y]],
                    yend = y_data[[y]],
                    line = list(color = palette.selection[color_idx]),
                    showlegend = FALSE,
                    hoverinfo = "skip"
                )
                # Add start markers
                fig <- fig |> add_markers(
                    x = y_data[[x[1]]],
                    y = y_data[[y]],
                    name = as.character(y_val),
                    marker = list(color = palette.selection[color_idx]),
                    showlegend = (i == 1) && show.legend,
                    legendgroup = as.character(y_val)
                )
                # Add end markers
                fig <- fig |> add_markers(
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
