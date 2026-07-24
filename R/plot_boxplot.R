#' Fix boxplot positioning across faceted subplots
#'
#' Sets the `offsetgroup` property on each box trace to ensure consistent
#' positioning across faceted subplot panels. Without this, plotly.js may
#' calculate different box offsets per subplot when `boxmode = "group"` is used,
#' causing boxes in different facets to appear at different x-positions.
#'
#' @param fig A plotly figure object containing one or more boxplot traces.
#'
#' @return The modified plotly figure with `offsetgroup` set on all box traces.
#'
#' @details When ggplotly converts a faceted ggplot, each facet becomes a
#'   subplot with its own axis pair. Plotly.js calculates box offsets
#'   independently per subplot unless `offsetgroup` is explicitly set on each
#'   trace. This function sets `offsetgroup` to the trace's `name` property
#'   (which corresponds to the color/grouping variable level), ensuring
#'   identical positioning of same-group boxes across all facet panels.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_fix_boxplot_facet_positions
.fix_boxplot_facet_positions <- function(fig) {
    stopifnot("plotly" %in% class(fig))
    fig$x$data <- lapply(
        fig$x$data,
        function(i) {
            if (is.null(i$type) || i$type != "box") {
                return(i)
            }
            i$offsetgroup <- if (!is.null(i$name)) i$name else ""
            i
        }
    )
    fig
}


