#' Create an Interactive Parallel Coordinates Plot with plotly
#'
#' Generates a customizable interactive parallel coordinates plot using plotly,
#' supporting dimension selection, color mapping, and font styling.
#'
#' @param reactive.data A data.frame or tibble containing the data to plot.
#' @param dimensions Character vector of column names to use as dimensions (axes).
#'   Must contain at least two columns. Non-numeric columns are mapped to integers.
#' @param color.by Optional character, column name to color lines by.
#'   Numeric columns use a continuous colorscale; categorical columns are mapped
#'   to integers and displayed with the same colorscale. Default: NULL.
#' @param color.scale Character, plotly colorscale name for line coloring.
#'   Options include "Viridis", "Cividis", "Inferno", "Magma", "Plasma",
#'   "Blues", "Greens", "Reds", "Oranges", "RdBu", "RdYlBu", "Spectral",
#'   "Jet", "Hot", "Cool", "Portland". Default: "Viridis".
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
#' @param title.text.color Character, hex color for plot title text. Default: "black".
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
#'   reactive.data = mtcars,
#'   dimensions = c("mpg", "cyl", "disp", "hp", "wt"),
#'   color.by = "mpg",
#'   color.scale = "Viridis",
#'   line.opacity = 0.6
#' )
parallelCoordinatesPlot <- function(
    reactive.data,
    dimensions,
    color.by = NULL,
    color.scale = "Viridis",
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
    title.text.color = "black",
    bgcolor = "#FFFFFF"
) {
    df <- reactive.data

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

        # Map categorical color column to integers
        if (!is.numeric(color_vals)) {
            lvls <- sort(unique(as.character(color_vals)))
            color_vals <- match(as.character(color_vals), lvls)

            
        } else {
        
            line_spec <- list(
                color = color_vals,
                colorscale = color.scale,
                showscale = show.colorbar,
                opacity = line.opacity,
                cmin = min(color_vals, na.rm = TRUE),
                cmax = max(color_vals, na.rm = TRUE)
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
                color = title.text.color
            ),
            x = 0.47, xanchor = "center", y = 0.98, yanchor = "top", pad = list(t = 20)
        ),
        paper_bgcolor = bgcolor,
        plot_bgcolor = bgcolor,
        margin = list(t = 80, l = 80, r = 80, b = 60)
    )

    return(fig)
}
