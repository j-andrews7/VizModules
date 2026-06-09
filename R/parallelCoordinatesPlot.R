#' Create an Interactive Parallel Coordinates Plot with plotly
#'
#' Generates a customizable interactive parallel coordinates plot using plotly,
#' supporting dimension selection, color mapping, and font styling.
#'
#' @param data A data.frame or tibble containing the data to plot.
#' @param dimensions Character vector of column names to use as dimensions (axes).
#'   Must contain at least two columns. Non-numeric columns are mapped to integers.
#' @param color.by Optional character, column name to color lines by.
#'   Numeric columns use a continuous colorscale (\code{color.scale}); categorical
#'   columns use a discrete palette (\code{palette.selection}) and are displayed
#'   with category names on the colorbar. Default: NULL.
#' @param color.scale Character, plotly colorscale name for line coloring when
#'   \code{color.by} is numeric. Options include "Viridis", "Cividis", "Inferno",
#'   "Magma", "Plasma", "Blues", "Greens", "Reds", "Oranges", "RdBu", "RdYlBu",
#'   "Spectral", "Jet", "Hot", "Cool", "Portland". Default: "Viridis".
#' @param palette.selection Character vector of hex colors used to color lines
#'   when \code{color.by} is categorical. May be unnamed (colors applied in
#'   order to the sorted unique levels) or named by level. If \code{NULL}, the
#'   plotly \code{color.scale} is used as a fallback. Default: NULL.
#' @param line.opacity Numeric, opacity of lines between 0 and 1. Default: 0.5.
#' @param line.width Numeric, width of lines in pixels. Default: 1.
#' @param show.colorbar Logical, whether to show the colorbar. Default: TRUE.
#' @param label.font.size Numeric, font size for dimension labels. Default: 12.
#' @param label.font.color Character, hex color for dimension labels. Default: "black".
#' @param label.font.family Character, font family for dimension labels. Default: "Arial".
#' @param tick.font.size Numeric, font size for axis tick labels. Default: 10.
#' @param tick.font.color Character, hex color for axis tick labels. Default: "black".
#' @param tick.font.family Character, font family for axis tick labels. Default: "Arial".
#' @param title.text Character, main title text for the plot. Default: "".
#' @param title.font.size Numeric, font size for plot title. Default: 16.
#' @param title.font.family Character, font family for plot title. Default: "Arial".
#' @param title.font.color Character, hex color for plot title text. Default: "black".
#' @param bgcolor Character, hex color for the plot background. Default: "#FFFFFF".
#'
#' @return A plotly object representing the interactive parallel coordinates plot.
#'
#' @import plotly
#'
#' @author Jacob Martin, Jared Andrews
#' @export
#'
#' @examples
#' fig <- parallelCoordinatesPlot(
#'     data = mtcars,
#'     dimensions = c("mpg", "cyl", "disp", "hp", "wt"),
#'     color.by = "mpg",
#'     color.scale = "Viridis",
#'     line.opacity = 0.6
#' )
parallelCoordinatesPlot <- function(
  data,
  dimensions,
  color.by = NULL,
  color.scale = "Viridis",
  palette.selection = NULL,
  line.opacity = 0.5,
  line.width = 1,
  show.colorbar = TRUE,
  label.font.size = 12,
  label.font.color = "black",
  label.font.family = "Arial",
  tick.font.size = 10,
  tick.font.color = "black",
  tick.font.family = "Arial",
  title.text = "",
  title.font.size = 16,
  title.font.family = "Arial",
  title.font.color = "black",
  bgcolor = "#FFFFFF"
) {
    df <- data

    # Build dimensions list for parcoords
    dim_list <- lapply(dimensions, function(col) {
        vals <- df[[col]]
        dim_spec <- list(label = col, values = vals)

        # For categorical columns, add tickvals and ticktext mapping
        if (!is.numeric(vals)) {
            lvls <- unique(as.character(vals))
            lvls <- sort(lvls)
            int_vals <- match(as.character(vals), lvls)
            dim_spec$values <- int_vals
            dim_spec$tickvals <- seq_along(lvls)
            dim_spec$ticktext <- lvls
        }

        dim_spec
    })

    # Build line spec
    if (!is.null(color.by) && nzchar(color.by) && color.by %in% names(df)) {
        color_vals <- df[[color.by]]
        is_categorical <- !is.numeric(color_vals)

        if (is_categorical) {
            # Map categorical color column to integers
            lvls <- sort(unique(as.character(color_vals)))
            color_vals <- match(as.character(color_vals), lvls)
            n_lvls <- length(lvls)

            # Resolve palette colors against levels
            if (!is.null(palette.selection) && length(palette.selection) > 0) {
                pal_colors <- palette.selection
                if (!is.null(names(pal_colors)) && any(nzchar(names(pal_colors)))) {
                    matched <- pal_colors[match(lvls, names(pal_colors))]
                    if (any(is.na(matched))) {
                        fill <- rep_len(unname(pal_colors), n_lvls)
                        matched[is.na(matched)] <- fill[is.na(matched)]
                    }
                    pal_colors <- unname(matched)
                } else {
                    pal_colors <- unname(rep_len(pal_colors, n_lvls))
                }

                # Build a discrete plotly colorscale with one solid band per level.
                # plotly's parcoords renderer rejects colorscales that contain
                # duplicate stop positions (it silently falls back to the default
                # continuous scale), so each band boundary is split by a tiny
                # epsilon to keep the stop positions strictly increasing while
                # still producing hard, discrete colour steps.
                if (n_lvls == 1) {
                    discrete_scale <- list(list(0, pal_colors[1]), list(1, pal_colors[1]))
                } else {
                    # Keep boundary splits large enough to survive JSON/JS
                    # floating-point rounding in plotly, while still tiny
                    # relative to each category band so transitions remain
                    # visually discrete.
                    eps <- min(1e-3, 0.25 / n_lvls)
                    discrete_scale <- list(list(0, pal_colors[1]))
                    for (k in seq_len(n_lvls - 1)) {
                        boundary <- k / n_lvls
                        discrete_scale[[length(discrete_scale) + 1]] <- list(boundary - eps, pal_colors[k])
                        discrete_scale[[length(discrete_scale) + 1]] <- list(boundary + eps, pal_colors[k + 1])
                    }
                    discrete_scale[[length(discrete_scale) + 1]] <- list(1, pal_colors[n_lvls])
                }

                # Centre each integer category value within its colour band by
                # padding the colour range half a step on either side.
                line_spec <- list(
                    color = color_vals,
                    colorscale = discrete_scale,
                    autocolorscale = FALSE,
                    showscale = show.colorbar,
                    opacity = line.opacity,
                    cmin = 0.5,
                    cmax = n_lvls + 0.5,
                    colorbar = list(
                        title = list(text = color.by),
                        tickmode = "array",
                        tickvals = seq_len(n_lvls),
                        ticktext = lvls
                    )
                )
            } else {
                # Fallback: use the plotly native colorscale on integer-mapped values
                line_spec <- list(
                    color = color_vals,
                    colorscale = color.scale,
                    showscale = show.colorbar,
                    opacity = line.opacity,
                    cmin = min(color_vals, na.rm = TRUE),
                    cmax = max(color_vals, na.rm = TRUE),
                    colorbar = list(
                        title = list(text = color.by)
                    )
                )
            }
        } else {
            line_spec <- list(
                color = color_vals,
                colorscale = color.scale,
                showscale = show.colorbar,
                opacity = line.opacity,
                cmin = min(color_vals, na.rm = TRUE),
                cmax = max(color_vals, na.rm = TRUE),
                colorbar = list(
                    title = list(text = color.by)
                )
            )
        }

        if (line.width != 1) {
            line_spec$width <- line.width
        }
    } else {
        line_spec <- list(
            color = "rgba(44, 123, 182, 0.5)",
            opacity = line.opacity
        )
        if (line.width != 1) {
            line_spec$width <- line.width
        }
    }

    fig <- plot_ly(
        type = "parcoords",
        line = line_spec,
        dimensions = dim_list,
        labelfont = list(
            size = label.font.size,
            color = label.font.color,
            family = label.font.family
        ),
        tickfont = list(
            size = tick.font.size,
            color = tick.font.color,
            family = tick.font.family
        )
    )

    fig <- fig |> layout(
        title = list(
            text = title.text,
            font = list(
                size = title.font.size,
                family = title.font.family,
                color = title.font.color
            ),
            x = 0.47, xanchor = "center", y = 0.98, yanchor = "top", pad = list(t = 20)
        ),
        paper_bgcolor = bgcolor,
        plot_bgcolor = bgcolor,
        margin = list(t = 80, l = 80, r = 80, b = 60)
    )

    return(fig)
}
