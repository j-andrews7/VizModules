#' Create a plotly radar chart
#'
#' @param df A data frame containing the data to plot. For a single trace, provide columns for
#'   categories (theta) and values (r). For multiple traces, include a grouping column.
#'   The function automatically closes the radar polygon by adding the first point to the end.
#' @param theta Character, name of the column to use for the angular categories (axes).
#' @param r Character, name of the column to use for the radial values.
#' @param group Optional character, name of the column to use for grouping multiple traces.
#'   If NULL, a single trace is plotted. Default: NULL.
#' @param colors Optional character vector of hex colors for the traces.
#'   If named, values are matched to the group values; otherwise colours are recycled.
#' @param palette Optional character vector of fallback colors used when
#'   \code{colors} is not supplied or missing values are present.
#' @param fill Logical or character, whether to fill the area under each trace.
#'   Use "toself" to fill to the first point, or FALSE for no fill. Default: "toself".
#' @param line.width Numeric, width of the trace lines in pixels. Default: 2.
#' @param line.dash Character, line dash style. Options: "solid", "dot", "dash",
#'   "longdash", "dashdot", "longdashdot". Default: "solid".
#' @param marker.size Numeric, size of the markers on the trace. Default: 5.
#' @param marker.symbol Character, marker symbol. Options: "circle", "square",
#'   "diamond", "cross", "x", "triangle-up", etc. Default: "circle".
#' @param opacity Numeric, opacity of the traces (0-1). Default: 0.6.
#' @param radial.visible Logical, whether to show the radial axis. Default: TRUE.
#' @param radial.range Optional numeric vector of length 2 specifying the range
#'   of the radial axis (e.g., c(0, 100)). If NULL, automatically determined. Default: NULL.
#' @param radial.showline Logical, whether to show the radial axis line. Default: TRUE.
#' @param radial.linecolor Character, hex color for the radial axis line. Default: "#444444".
#' @param radial.gridcolor Character, hex color for the radial grid lines. Default: "#EEEEEE".
#' @param angular.direction Character, direction of angular axis. Options: "clockwise" or
#'   "counterclockwise". Default: "clockwise".
#' @param angular.rotation Numeric, rotation angle for the angular axis in degrees. Default: 90.
#' @param angular.gridcolor Character, hex color for the angular grid lines. Default: "#EEEEEE".
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
#' @param polar.bgcolor Character, hex color for the polar area background. Default: "#FFFFFF".
#'
#' @examples
#' # Single trace radar chart
#' # Note: Polygon is automatically closed by the function
#' skills <- data.frame(
#'     category = c("Speed", "Strength", "Defense", "Stamina"),
#'     value = c(8, 6, 7, 9)
#' )
#'
#' radarPlot(
#'     df = skills,
#'     theta = "category",
#'     r = "value",
#'     title.text = "Player Stats"
#' )
#'
#' # Multiple trace radar chart
#' # Note: Polygon is automatically closed for each trace
#' team_stats <- data.frame(
#'     category = rep(c("Speed", "Strength", "Defense", "Stamina"), 2),
#'     value = c(8, 6, 7, 9, 5, 9, 8, 6),
#'     player = rep(c("Player A", "Player B"), each = 4)
#' )
#'
#' radarPlot(
#'     df = team_stats,
#'     theta = "category",
#'     r = "value",
#'     group = "player",
#'     title.text = "Team Comparison"
#' )
#'
#' @return A plotly object.
#'
#' @import plotly
#'
#' @export
#' @author Jacob Martin
radarPlot <- function(df, theta, r,
                      group = NULL,
                      colors = NULL,
                      palette = NULL,
                      fill = "toself",
                      line.width = 2,
                      line.dash = "solid",
                      marker.size = 5,
                      marker.symbol = "circle",
                      opacity = 0.6,
                      radial.visible = TRUE,
                      radial.range = NULL,
                      radial.showline = TRUE,
                      radial.linecolor = "#444444",
                      radial.gridcolor = "#EEEEEE",
                      angular.direction = "clockwise",
                      angular.rotation = 90,
                      angular.gridcolor = "#EEEEEE",
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
                      bgcolor = "#FFFFFF",
                      polar.bgcolor = "#FFFFFF") {
    stopifnot(is.data.frame(df))

    if (!theta %in% names(df)) {
        stop("`theta` must refer to a column in `df`.")
    }
    if (!r %in% names(df)) {
        stop("`r` must refer to a column in `df`.")
    }
    if (!is.null(group) && !group %in% names(df)) {
        stop("`group` must refer to a column in `df`.")
    }

    # Establish a fallback palette
    fallback_palette <- palette
    if (is.null(fallback_palette)) {
        fallback_palette <- tryCatch(plotthis::palette_list[[1]], error = function(...) NULL)
    }
    if (is.null(fallback_palette)) {
        fallback_palette <- tryCatch(
            default_palettes()$choices$Defaults$dittoColors,
            error = function(...) NULL
        )
    }
    if (is.null(fallback_palette) || length(fallback_palette) == 0) {
        fallback_palette <- c(
            "#1F77B4", "#FF7F0E", "#2CA02C", "#D62728", "#9467BD",
            "#8C564B", "#E377C2", "#7F7F7F", "#BCBD22", "#17BECF"
        )
    }
    fallback_palette <- unname(fallback_palette)

    # Initialize plotly figure
    fig <- plot_ly(type = "scatterpolar")

    # Handle single vs multiple traces
    if (is.null(group)) {
        # Single trace
        # Automatically close the polygon by adding first point to the end
        first_row <- df[1, , drop = FALSE]
        df_closed <- rbind(df, first_row)

        colour_value <- if (!is.null(colors) && length(colors) > 0) {
            colors[1]
        } else {
            fallback_palette[1]
        }

        fig <- fig |>
            add_trace(
                data = df_closed,
                r = reformulate(r),
                theta = reformulate(theta),
                mode = "lines+markers",
                fill = fill,
                fillcolor = colour_value,
                line = list(
                    color = colour_value,
                    width = line.width,
                    dash = line.dash
                ),
                marker = list(
                    color = colour_value,
                    size = marker.size,
                    symbol = marker.symbol
                ),
                opacity = opacity,
                showlegend = FALSE
            )
    } else {
        # Multiple traces
        group_values <- unique(df[[group]])

        # Set up color mapping
        if (!is.null(colors) && length(colors) > 0) {
            if (!is.null(names(colors)) && any(nzchar(names(colors)))) {
                # Named colors - map to group values
                colour_vector <- colors[match(group_values, names(colors))]
                missing_map <- is.na(colour_vector)
                if (any(missing_map)) {
                    colour_vector[missing_map] <- rep_len(fallback_palette, sum(missing_map))
                }
            } else {
                # Unnamed colors - recycle
                colour_vector <- rep_len(colors, length(group_values))
            }
        } else {
            # No colors provided - use fallback
            colour_vector <- rep_len(fallback_palette, length(group_values))
        }

        # Add a trace for each group
        for (i in seq_along(group_values)) {
            group_val <- group_values[i]
            group_data <- df[df[[group]] == group_val, ]

            # Automatically close the polygon by adding first point to the end
            first_row <- group_data[1, , drop = FALSE]
            group_data_closed <- rbind(group_data, first_row)

            fig <- fig |>
                add_trace(
                    data = group_data_closed,
                    r = reformulate(r),
                    theta = reformulate(theta),
                    name = as.character(group_val),
                    mode = "lines+markers",
                    fill = fill,
                    fillcolor = colour_vector[i],
                    line = list(
                        color = colour_vector[i],
                        width = line.width,
                        dash = line.dash
                    ),
                    marker = list(
                        color = colour_vector[i],
                        size = marker.size,
                        symbol = marker.symbol
                    ),
                    opacity = opacity
                )
        }
    }

    # Configure layout
    fig <- layout(
        fig,
        title = list(
            text = title.text,
            font = list(
                family = title.font.family,
                size = title.font.size,
                color = title.font.color
            ),
            x = title.x,
            xanchor = "center"
        ),
        polar = list(
            bgcolor = polar.bgcolor,
            radialaxis = list(
                visible = radial.visible,
                range = radial.range,
                showline = radial.showline,
                linecolor = radial.linecolor,
                gridcolor = radial.gridcolor
            ),
            angularaxis = list(
                direction = angular.direction,
                rotation = angular.rotation,
                gridcolor = angular.gridcolor
            )
        ),
        showlegend = show.legend,
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
