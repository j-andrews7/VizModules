# Continuous colour scales for plotly figures: the presets offered by
# uniform_colorscale_inputs_ui() and the scale they resolve to.

# The picker's colour stops, lowest value first. Each preset holds exactly one
# colour per stop: the picker cycles a palette over its groups, so a preset of
# another length would not run from its low end to its high end.
.colorscale_stops <- c("Lowest", "Low", "Middle", "High", "Highest")

.colorscale_presets <- list(
    "RdYlBu" = c("#2C7BB6", "#ABD9E9", "#FFFFBF", "#FDAE61", "#D7191C"),
    "Jet" = c("#0000FF", "#00FFFF", "#80FF80", "#FFFF00", "#FF0000"),
    "Blue-White-Red" = c("#2166AC", "#92C5DE", "#F7F7F7", "#F4A582", "#B2182B"),
    "Viridis" = c("#440154", "#3B528B", "#21908C", "#5DC863", "#FDE725"),
    "Magma" = c("#000004", "#51127C", "#B63679", "#FB8861", "#FCFDBF"),
    "Cividis" = c("#00224E", "#434E6C", "#7D7C78", "#BCAF6F", "#FEE838")
)


#' Resolve a continuous colour scale for plotly
#'
#' Turns colour stops and optional limits into the `colorscale`, `cmin` and `cmax`
#' of a plotly `coloraxis`, or of a trace once `cmin` and `cmax` are renamed to its
#' `zmin` and `zmax`. The stops are spaced evenly from `min` to `mid` and from `mid`
#' to `max`, so a middle stop sits exactly at `mid` and a midpoint off centre
#' stretches one side of the scale rather than moving its ends.
#'
#' These are the values of the inputs from [uniform_colorscale_inputs_ui()]. A
#' scale set on `layout.coloraxis` rather than on the trace can be changed without
#' redrawing the plot: it is a layout-only update, as a styling step should be.
#'
#' @param colors Character vector of colours, lowest value first. A named vector,
#'   as a [multiColorPicker()] reports, is taken in order. `NULL` uses the first
#'   preset of [uniform_colorscale_inputs_ui()].
#' @param min,mid,max Numeric limits and midpoint. `NA` or `NULL` (a cleared
#'   numeric input) falls back to the ends of `data.range` and the centre of the
#'   limits. A `mid` outside the limits is held just inside them.
#' @param reverse Logical; run the colours from high to low.
#' @param data.range The values plotted, or their range, used for a blank limit.
#'   Non-finite values are ignored. With none left, the limits are 0 and 1.
#'
#' @return A list with `colorscale` (a list of `list(position, colour)` stops
#'   running from 0 to 1), `cmin`, and `cmax`. `cmin` is always below `cmax`: limits
#'   given in the wrong order are swapped, and equal limits (constant data) are
#'   widened by 0.5 either way.
#'
#' @seealso [uniform_colorscale_inputs_ui()], [reset_colorscale_inputs()]
#'
#' @author Jared Andrews
#' @export
#' @examples
#' # Betas, with the middle colour at 0.3.
#' scale <- resolve_colorscale(c("blue", "white", "red"), min = 0, mid = 0.3, max = 1)
#' scale$colorscale
#'
#' fig <- plotly::plot_ly(z = volcano, type = "heatmap", coloraxis = "coloraxis")
#' plotly::layout(fig, coloraxis = scale)
resolve_colorscale <- function(colors = NULL, min = NA, mid = NA, max = NA, reverse = FALSE,
                               data.range = c(0, 1)) {
    colors <- unname(as.character(colors))
    if (length(colors) == 0) {
        colors <- .colorscale_presets[[1]]
    } else if (length(colors) == 1) {
        colors <- rep(colors, 2)
    }
    if (isTRUE(reverse)) {
        colors <- rev(colors)
    }

    number_or <- function(value, fallback) {
        value <- suppressWarnings(as.numeric(value)[1])
        if (length(value) == 0 || !is.finite(value)) fallback else value
    }
    finite <- data.range[is.finite(data.range)]
    bounds <- if (length(finite) > 0) range(finite) else c(0, 1)

    limits <- sort(c(number_or(min, bounds[1]), number_or(max, bounds[2])))
    if (limits[1] == limits[2]) {
        limits <- limits + c(-0.5, 0.5)
    }

    # Held inside (0, 1): plotly needs the stops strictly increasing.
    middle <- number_or(mid, mean(limits))
    frac <- .clamp_number((middle - limits[1]) / diff(limits), 0.001, 0.999, 0.5)

    at <- (seq_along(colors) - 1) / (length(colors) - 1)
    position <- ifelse(at <= 0.5, at * 2 * frac, frac + (at - 0.5) * 2 * (1 - frac))
    # Plotly rejects a scale that does not end at exactly 1.
    position[length(position)] <- 1

    list(
        colorscale = Map(function(p, color) list(p, color), position, colors, USE.NAMES = FALSE),
        cmin = limits[1],
        cmax = limits[2]
    )
}
