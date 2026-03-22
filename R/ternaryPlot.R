#' Create a plotly ternary plot
#'
#' @param df A data frame containing the data to plot. Must contain numeric columns for
#'   the three ternary axes (a, b, c). For multiple traces, include a grouping column.
#' @param a Character, name of the column to use for the a-axis (top vertex).
#' @param b Character, name of the column to use for the b-axis (bottom-left vertex).
#' @param c Character, name of the column to use for the c-axis (bottom-right vertex).
#' @param group Optional character, name of the column to use for grouping multiple traces.
#'   If NULL, a single trace is plotted. Default: NULL.
#' @param colors Optional character vector of hex colors for the traces.
#'   If named, values are matched to the group values; otherwise colours are recycled.
#' @param palette Optional character vector of fallback colors used when
#'   \code{colors} is not supplied or missing values are present.
#' @param sum Numeric, the constant sum for the ternary axes (e.g., 100 for percentages,
#'   1 for proportions). All data points should sum to this value. Default: 100.
#' @param mode Character, the trace mode. Options: "markers", "lines", "lines+markers". Default: "markers".
#' @param marker.size Numeric, size of the markers on the trace. Default: 8.
#' @param marker.symbol Character, marker symbol. Options: "circle", "square",
#'   "diamond", "cross", "x", "triangle-up", etc. Default: "circle".
#' @param marker.line.width Numeric, width of the marker border line. Default: 0.
#' @param marker.line.color Character, hex color for the marker border. Default: "#000000".
#' @param line.width Numeric, width of the trace lines in pixels (only used if mode includes "lines"). Default: 2.
#' @param line.dash Character, line dash style. Options: "solid", "dot", "dash",
#'   "longdash", "dashdot", "longdashdot". Default: "solid".
#' @param opacity Numeric, opacity of the traces (0-1). Default: 1.
#' @param a.title Character, title for the a-axis. Default: "a".
#' @param b.title Character, title for the b-axis. Default: "b".
#' @param c.title Character, title for the c-axis. Default: "c".
#' @param a.titlefont.size Numeric, font size for the a-axis title. Default: 16.
#' @param b.titlefont.size Numeric, font size for the b-axis title. Default: 16.
#' @param c.titlefont.size Numeric, font size for the c-axis title. Default: 16.
#' @param a.titlefont.family Character, font family for the a-axis title. Default: "Arial".
#' @param b.titlefont.family Character, font family for the b-axis title. Default: "Arial".
#' @param c.titlefont.family Character, font family for the c-axis title. Default: "Arial".
#' @param a.titlefont.color Character, hex color for the a-axis title. Default: "#000000".
#' @param b.titlefont.color Character, hex color for the b-axis title. Default: "#000000".
#' @param c.titlefont.color Character, hex color for the c-axis title. Default: "#000000".
#' @param a.tickfont.size Numeric, font size for the a-axis tick labels. Default: 12.
#' @param b.tickfont.size Numeric, font size for the b-axis tick labels. Default: 12.
#' @param c.tickfont.size Numeric, font size for the c-axis tick labels. Default: 12.
#' @param a.tickcolor Character, hex color for the a-axis ticks. Default: "rgba(0,0,0,0)".
#' @param b.tickcolor Character, hex color for the b-axis ticks. Default: "rgba(0,0,0,0)".
#' @param c.tickcolor Character, hex color for the c-axis ticks. Default: "rgba(0,0,0,0)".
#' @param a.ticklen Numeric, length of the a-axis ticks. Default: 5.
#' @param b.ticklen Numeric, length of the b-axis ticks. Default: 5.
#' @param c.ticklen Numeric, length of the c-axis ticks. Default: 5.
#' @param a.gridcolor Character, hex color for the a-axis gridlines. Default: "#EEEEEE".
#' @param b.gridcolor Character, hex color for the b-axis gridlines. Default: "#EEEEEE".
#' @param c.gridcolor Character, hex color for the c-axis gridlines. Default: "#EEEEEE".
#' @param show.legend Logical, whether to display the legend. Default: TRUE.
#' @param legend.orientation Character, legend orientation. Options: "h" (horizontal)
#'   or "v" (vertical). Default: "h".
#' @param legend.x Numeric, horizontal legend position offset (0-1). Default: 0.5.
#' @param legend.y Numeric, vertical legend position offset (-1 to 1). Default: -0.1.
#' @param legend.font.family Character, font family for the legend text. Default: "Arial".
#' @param legend.font.size Numeric, font size for the legend text. Default: 12.
#' @param legend.font.color Character, hex color for the legend text. Default: "#000000".
#' @param title.text Character, main plot title text. Default: "".
#' @param title.font.family Character, font family for the title text. Default: "Arial".
#' @param title.font.size Numeric, font size for the title text. Default: 18.
#' @param title.font.color Character, hex color for the title text. Default: "#000000".
#' @param title.x Numeric, horizontal position for the plot title (0-1). Default: 0.5.
#' @param bgcolor Character, hex color for the plot background. Default: "#FFFFFF".
#'
#' @examples
#' # Single trace ternary plot
#' journalist <- c(75, 70, 75, 5, 10, 10, 20, 10, 15, 10, 20)
#' developer <- c(25, 10, 20, 60, 80, 90, 70, 20, 5, 10, 10)
#' designer <- c(0, 20, 5, 35, 10, 0, 10, 70, 80, 80, 70)
#' label <- c(
#'     "point 1", "point 2", "point 3", "point 4", "point 5", "point 6",
#'     "point 7", "point 8", "point 9", "point 10", "point 11"
#' )
#'
#' df <- data.frame(journalist, developer, designer, label)
#'
#' ternaryPlot(
#'     df = df,
#'     a = "journalist",
#'     b = "developer",
#'     c = "designer",
#'     a.title = "Journalist",
#'     b.title = "Developer",
#'     c.title = "Designer",
#'     title.text = "Simple Ternary Plot with Markers"
#' )
#'
#' # Multiple trace ternary plot with grouping
#' team_data <- data.frame(
#'     journalist = c(75, 70, 75, 5, 10, 10),
#'     developer = c(25, 10, 20, 60, 80, 90),
#'     designer = c(0, 20, 5, 35, 10, 0),
#'     team = rep(c("Team A", "Team B"), each = 3)
#' )
#'
#' ternaryPlot(
#'     df = team_data,
#'     a = "journalist",
#'     b = "developer",
#'     c = "designer",
#'     group = "team",
#'     a.title = "Journalist",
#'     b.title = "Developer",
#'     c.title = "Designer",
#'     title.text = "Team Comparison"
#' )
#'
#' @return A plotly object.
#'
#' @import plotly
#'
#' @export
#' @author Jacob Martin
ternaryPlot <- function(df, a, b, c,
                        group = NULL,
                        colors = NULL,
                        palette = NULL,
                        sum = 100,
                        mode = "markers",
                        marker.size = 8,
                        marker.symbol = "circle",
                        marker.line.width = 0,
                        marker.line.color = "#000000",
                        line.width = 2,
                        line.dash = "solid",
                        opacity = 1,
                        a.title = "a",
                        b.title = "b",
                        c.title = "c",
                        a.titlefont.size = 16,
                        b.titlefont.size = 16,
                        c.titlefont.size = 16,
                        a.titlefont.family = "Arial",
                        b.titlefont.family = "Arial",
                        c.titlefont.family = "Arial",
                        a.titlefont.color = "#000000",
                        b.titlefont.color = "#000000",
                        c.titlefont.color = "#000000",
                        a.tickfont.size = 12,
                        b.tickfont.size = 12,
                        c.tickfont.size = 12,
                        a.tickcolor = "rgba(0,0,0,0)",
                        b.tickcolor = "rgba(0,0,0,0)",
                        c.tickcolor = "rgba(0,0,0,0)",
                        a.ticklen = 5,
                        b.ticklen = 5,
                        c.ticklen = 5,
                        a.gridcolor = "#EEEEEE",
                        b.gridcolor = "#EEEEEE",
                        c.gridcolor = "#EEEEEE",
                        show.legend = TRUE,
                        legend.orientation = "h",
                        legend.x = 0.5,
                        legend.y = -0.1,
                        legend.font.family = "Arial",
                        legend.font.size = 12,
                        legend.font.color = "#000000",
                        title.text = "",
                        title.font.family = "Arial",
                        title.font.size = 18,
                        title.font.color = "#000000",
                        title.x = 0.5,
                        bgcolor = "#FFFFFF") {
    # Validate inputs
    if (!a %in% names(df)) {
        stop(paste("Column", a, "not found in data frame"))
    }
    if (!b %in% names(df)) {
        stop(paste("Column", b, "not found in data frame"))
    }
    if (!c %in% names(df)) {
        stop(paste("Column", c, "not found in data frame"))
    }

    # Ensure numeric columns
    if (!is.numeric(df[[a]])) {
        stop(paste("Column", a, "must be numeric"))
    }
    if (!is.numeric(df[[b]])) {
        stop(paste("Column", b, "must be numeric"))
    }
    if (!is.numeric(df[[c]])) {
        stop(paste("Column", c, "must be numeric"))
    }

    # Helper function for creating axis configuration
    axis_config <- function(title, titlefont.size, titlefont.family, titlefont.color,
                            tickfont.size, tickcolor, ticklen, gridcolor) {
        list(
            title = title,
            titlefont = list(
                size = titlefont.size,
                family = titlefont.family,
                color = titlefont.color
            ),
            tickfont = list(
                size = tickfont.size
            ),
            tickcolor = tickcolor,
            ticklen = ticklen,
            gridcolor = gridcolor
        )
    }

    # Configure axes
    aaxis <- axis_config(
        a.title, a.titlefont.size, a.titlefont.family, a.titlefont.color,
        a.tickfont.size, a.tickcolor, a.ticklen, a.gridcolor
    )
    baxis <- axis_config(
        b.title, b.titlefont.size, b.titlefont.family, b.titlefont.color,
        b.tickfont.size, b.tickcolor, b.ticklen, b.gridcolor
    )
    caxis <- axis_config(
        c.title, c.titlefont.size, c.titlefont.family, c.titlefont.color,
        c.tickfont.size, c.tickcolor, c.ticklen, c.gridcolor
    )

    # Initialize plot
    fig <- plot_ly()

    # Handle grouping
    if (!is.null(group) && group != "" && group %in% names(df)) {
        # Multiple traces
        group_values <- unique(df[[group]])

        # Prepare colors
        if (is.null(colors) || length(colors) == 0) {
            if (!is.null(palette) && length(palette) > 0) {
                colors <- rep_len(palette, length(group_values))
            } else {
                default_cols <- c(
                    "#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9467BD",
                    "#8C564B", "#E377C2", "#7F7F7F", "#BCBD22", "#17BECF"
                )
                colors <- rep_len(default_cols, length(group_values))
            }
        }

        # If colors is a named vector, preserve names
        if (!is.null(names(colors))) {
            color_map <- colors
        } else {
            color_map <- stats::setNames(
                rep_len(colors, length(group_values)),
                as.character(group_values)
            )
        }

        for (i in seq_along(group_values)) {
            grp <- group_values[i]
            subset_data <- df[df[[group]] == grp, ]

            trace_color <- if (as.character(grp) %in% names(color_map)) {
                color_map[[as.character(grp)]]
            } else {
                color_map[[i]]
            }

            # Build marker list
            marker_list <- list(
                size = marker.size,
                symbol = marker.symbol,
                color = trace_color,
                opacity = opacity,
                line = list(width = marker.line.width, color = marker.line.color)
            )

            # Build line list (only used if mode includes "lines")
            line_list <- list(
                width = line.width,
                dash = line.dash,
                color = trace_color
            )

            # Add trace
            if (grepl("lines", mode, fixed = TRUE)) {
                fig <- fig |> add_trace(
                    type = "scatterternary",
                    mode = mode,
                    a = subset_data[[a]],
                    b = subset_data[[b]],
                    c = subset_data[[c]],
                    name = as.character(grp),
                    marker = marker_list,
                    line = line_list,
                    showlegend = show.legend
                )
            } else {
                fig <- fig |> add_trace(
                    type = "scatterternary",
                    mode = mode,
                    a = subset_data[[a]],
                    b = subset_data[[b]],
                    c = subset_data[[c]],
                    name = as.character(grp),
                    marker = marker_list,
                    showlegend = show.legend
                )
            }
        }
    } else {
        # Single trace
        trace_color <- if (!is.null(colors) && length(colors) > 0) {
            colors[1]
        } else if (!is.null(palette) && length(palette) > 0) {
            palette[1]
        } else {
            "#1F77B4"
        }

        # Build marker list
        marker_list <- list(
            size = marker.size,
            symbol = marker.symbol,
            color = trace_color,
            opacity = opacity,
            line = list(width = marker.line.width, color = marker.line.color)
        )

        # Build line list (only used if mode includes "lines")
        line_list <- list(
            width = line.width,
            dash = line.dash,
            color = trace_color
        )

        # Add trace
        if (grepl("lines", mode, fixed = TRUE)) {
            fig <- fig |> add_trace(
                type = "scatterternary",
                mode = mode,
                a = df[[a]],
                b = df[[b]],
                c = df[[c]],
                marker = marker_list,
                line = line_list,
                showlegend = FALSE
            )
        } else {
            fig <- fig |> add_trace(
                type = "scatterternary",
                mode = mode,
                a = df[[a]],
                b = df[[b]],
                c = df[[c]],
                marker = marker_list,
                showlegend = FALSE
            )
        }
    }

    # Configure layout
    fig <- fig |> layout(
        title = list(
            text = title.text,
            font = list(
                family = title.font.family,
                size = title.font.size,
                color = title.font.color
            ),
            x = title.x,
            automargin = TRUE
        ),
        ternary = list(
            sum = sum,
            aaxis = aaxis,
            baxis = baxis,
            caxis = caxis,
            bgcolor = bgcolor
        ),
        legend = list(
            orientation = legend.orientation,
            x = legend.x,
            y = legend.y,
            font = list(
                family = legend.font.family,
                size = legend.font.size,
                color = legend.font.color
            )
        ),
        paper_bgcolor = bgcolor
    )

    return(fig)
}
