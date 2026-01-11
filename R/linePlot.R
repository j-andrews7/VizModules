#' Create a plotly line plot
#'
#' @return A plotly object.
#'
#' @importFrom plotly plot_ly subplot
#'
#' @export
#' @author Jacob Martin
linePlot <- function(reactive.data, x.value, y.value, plot.mode, line.type, colour.group.by, palette.selection, show.legend, facet.by = NULL,
                     axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, axis.tickfont.size = 12,
                     axis.tickfont.color = "black", axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
                     axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, title.text = "Click To Edit Title", title.font.size = 14, title.font.family = "Arial",
                     title.text.color = "black", axis.range.x = NULL, axis.range.y = NULL, y.title = NULL, x.title = NULL, flip.x = NULL, flip.y = NULL,
                     x.adjustment = NULL, y.adjustment = NULL, x.input = NULL, y.input = NULL, order.by = NULL) {
    # Unique x axis styling for linePlot:
    xaxis_style <- list(
        showline = axis.showline, mirror = axis.mirror, linecolor = axis.linecolor, linewidth = axis.linewidth,
        tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
        tickangle = axis.tickangle.x, ticks = axis.ticks, tickcolor = axis.tickcolor, ticklen = axis.ticklen, tickwidth = axis.tickwidth,
        range = axis.range.x, title = x.title, autorange = flip.x
    )

    # Y axis styling by editing unique aspects of the x axis styling
    yaxis_style <- xaxis_style
    yaxis_style$tickangle <- axis.tickangle.y
    yaxis_style$range <- axis.range.y
    yaxis_style$title <- y.title

    # Making axis adjustments if the parameters are not NULL
    if (!is.null(x.adjustment)) {
        reactive.data <- .adjust_column_values(df = reactive.data, col_names = x.input, transformation = x.adjustment)
    }
    if (!is.null(y.adjustment)) {
        reactive.data <- .adjust_column_values(df = reactive.data, col_names = y.input, transformation = y.adjustment)
    }
    order.cols <- order.by
    if (is.null(order.cols)) {
        order.cols <- x.input
    }

    plot_data <- reactive.data
    if (!is.null(order.cols) && length(order.cols) > 0 && order.cols[1] %in% names(reactive.data)) {
        plot_data <- reactive.data[order(reactive.data[[order.cols[1]]]), ]
    }

    # Finding Axis min and max if all columns are numeric
    # X values
    if (all(sapply(plot_data[x.input], is.numeric))) {
        min_vals_x <- sapply(plot_data[x.input], min, na.rm = TRUE)
        max_vals_x <- sapply(plot_data[x.input], max, na.rm = TRUE)
    } else {
        min_vals_x <- NULL
        max_vals_x <- NULL
    }
    # Y values:
    if (all(sapply(plot_data[y.input], is.numeric))) {
        min_vals_y <- sapply(plot_data[y.input], min, na.rm = TRUE)
        max_vals_y <- sapply(plot_data[y.input], max, na.rm = TRUE)
    } else {
        min_vals_y <- NULL
        max_vals_y <- NULL
    }

    multi_axis <- xor(length(x.input) > 1, length(y.input) > 1)

    if (!is.null(facet.by) && facet.by != "") {
        # Split data by facet variable
        facet_levels <- unique(plot_data[[facet.by]])
        plots <- lapply(facet_levels, function(level) {
            facet_data <- plot_data[plot_data[[facet.by]] == level, ]
            plot_ly(
                data = facet_data,
                x = x.value,
                y = y.value,
                type = "scatter",
                mode = plot.mode,
                line = list(dash = line.type),
                color = colour.group.by,
                colors = palette.selection,
                showlegend = show.legend
            )
        })

        fig <- subplot(plots, nrows = 1, shareX = TRUE, shareY = TRUE, titleX = TRUE, titleY = TRUE)
    } else {
        fig <- plot_ly(
            data = plot_data,
            x = x.value,
            y = y.value,
            type = "scatter",
            mode = plot.mode,
            line = list(dash = line.type),
            color = colour.group.by,
            colors = palette.selection,
            showlegend = show.legend
        )
    }

    if (multi_axis) {
        if (length(x.input) > 1) {
            fig <- fig |> add_trace(
                data = plot_data,
                x = plot_data[[x.input[1]]],
                y = plot_data[[y.input[1]]],
                type = "scatter",
                mode = plot.mode,
                line = list(dash = line.type),
                name = x.input[1],
                showlegend = TRUE
            )
            for (i in 2:length(x.input)) {
                trace_data <- reactive.data
                sort_column <- order.cols[1]
                if (!is.null(order.cols) && length(order.cols) >= i && order.cols[i] %in% names(trace_data)) {
                    sort_column <- order.cols[i]
                }
                if (!is.null(sort_column) && sort_column %in% names(trace_data)) {
                    trace_data <- trace_data[order(trace_data[[sort_column]]), ]
                }
                fig <- fig |> add_trace(
                    x = trace_data[[x.input[i]]],
                    y = trace_data[[y.input[1]]],
                    type = "scatter",
                    mode = plot.mode,
                    line = list(dash = line.type, color = palette.selection[i]),
                    name = x.input[i],
                    showlegend = TRUE
                )
            }
        }
        if (length(y.input) > 1) {
            fig <- fig |> add_trace(
                data = plot_data,
                x = plot_data[[x.input[1]]],
                y = plot_data[[y.input[1]]],
                type = "scatter",
                mode = plot.mode,
                line = list(dash = line.type),
                name = y.input[1],
                showlegend = TRUE
            )
            for (i in 2:length(y.input)) {
                trace_data <- reactive.data
                sort_column <- order.cols[1]
                if (!is.null(order.cols) && length(order.cols) >= i && order.cols[i] %in% names(trace_data)) {
                    sort_column <- order.cols[i]
                }
                if (!is.null(sort_column) && sort_column %in% names(trace_data)) {
                    trace_data <- trace_data[order(trace_data[[sort_column]]), ]
                }
                fig <- fig |> add_trace(
                    x = trace_data[[x.input[1]]],
                    y = trace_data[[y.input[i]]],
                    type = "scatter",
                    mode = plot.mode,
                    line = list(dash = line.type, color = palette.selection[i]),
                    name = y.input[i],
                    showlegend = TRUE
                )
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
        xaxis = list( # ← KEY: Always works here
            showline = axis.showline,
            mirror = axis.mirror,
            linecolor = axis.linecolor,
            linewidth = axis.linewidth,
            tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
            tickangle = axis.tickangle.x,
            ticks = axis.ticks,
            tickcolor = axis.tickcolor,
            ticklen = axis.ticklen,
            tickwidth = axis.tickwidth,
            range = c(min_vals_x, max_vals_x),
            title = x.title,
            autorange = flip.x
        ),
        yaxis = list(
            showline = axis.showline,
            mirror = axis.mirror,
            linecolor = axis.linecolor,
            linewidth = axis.linewidth,
            tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
            tickangle = axis.tickangle.y,
            ticks = axis.ticks,
            tickcolor = axis.tickcolor,
            ticklen = axis.ticklen,
            tickwidth = axis.tickwidth,
            range = c(min_vals_y, max_vals_y),
            title = y.title,
            autorange = flip.y
        )
    )
    return(fig)
}
