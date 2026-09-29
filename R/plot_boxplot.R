#' Dodge width `plotthis` builds its box plots with
#'
#' `plotthis::BoxPlot()` hardcodes `position_dodge(width = 0.9)` for its box
#' layer and `position_jitterdodge(dodge.width = 0.9)` for its point layer. A
#' module wrapping it must hand the same number to [.align_box_positions()] so
#' the boxes land back on the coordinates `ggplot2` gave the rest of the layers.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_plotthis_dodge_width
.PLOTTHIS_DODGE_WIDTH <- 0.9


#' Put box traces back on the positions ggplot2 dodged them to
#'
#' Rewrites the `x` of every box trace in a `ggplotly()` figure so the boxes sit
#' where `ggplot2` placed them, then switches `boxmode` to `"overlay"` so
#' plotly.js leaves them alone.
#'
#' @param fig A plotly figure object containing one or more box traces.
#' @param dodge.width Width the groups at one x position are dodged across. Must
#'   match the dodge the figure's `ggplot` was built with (see
#'   [.PLOTTHIS_DODGE_WIDTH] for `plotthis`; `dittoViz` uses `vlnplot.width`).
#' @param box.width Fraction of its slot each box fills, between 0 and 1.
#'
#' @return The figure with explicit `x` and `width` on every box trace and
#'   `boxmode = "overlay"` in the layout.
#'
#' @details `plotly`'s boxplot conversion rebuilds box traces from the layer's
#'   *prestats* data, so they arrive carrying the raw x category index and none
#'   of `ggplot2`'s dodge. Point, violin and errorbar traces keep the positions
#'   `ggplot2` computed. `boxmode = "group"` then dodges the boxes by plotly.js'
#'   own rule -- one slot per box trace in the subplot -- while `ggplot2` gave
#'   every other layer one slot per group *present at that x position*. Where a
#'   group is missing from some x categories the two disagree and the boxes no
#'   longer line up over their points.
#'
#'   Which x positions each box trace occupies is exactly the presence
#'   information needed to redo the dodge, so no data frame is required. Traces
#'   are ranked in the order `ggplotly()` emitted them, which follows factor
#'   level order, matching how `ggplot2` assigns slots. Each facet panel is
#'   dodged independently, as `ggplot2` does per panel, and a panel is identified
#'   by its *pair* of axes: `ggplotly()` gives every panel its own x axis only
#'   when the x scale is free, and otherwise shares one x axis down a whole facet
#'   column, so the x axis alone would merge the panels stacked in that column.
#'
#'   plotly only accepts one `width` per trace, so boxes are drawn a constant
#'   width everywhere (taken from the most crowded x position) rather than
#'   widening where a group is absent. This keeps the widths plotly.js was
#'   already drawing and matches the jitter cloud, whose width is also constant.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_align_box_positions
.align_box_positions <- function(fig, dodge.width = 1, box.width = 0.8) {
    stopifnot("plotly" %in% class(fig))

    d <- fig$x$data
    is_box <- vapply(
        d,
        function(tr) identical(tr$type, "box") && length(tr$x) > 0,
        logical(1)
    )
    if (!any(is_box)) {
        return(fig)
    }

    # Each facet panel is dodged on its own, so same-named groups keep identical
    # positions across panels only because every panel applies the same rule --
    # not because a slot is reserved for them. A panel is an axis *pair*: with a
    # fixed x scale one x axis is shared down a whole facet column, so keying on
    # the x axis alone would merge the panels stacked in it into one dodge group
    # and invent slots ggplot2 never used.
    panel_of <- vapply(
        d,
        function(tr) paste0(tr$xaxis %__% "x", "|", tr$yaxis %__% "y"),
        character(1)
    )

    # Built with lapply() rather than in the loop below because a `for` reuses one
    # environment across iterations, so closures over `pos` would all see the last
    # panel's.
    panels <- lapply(unique(panel_of[is_box]), function(pn) {
        idx <- which(is_box & panel_of == pn)
        list(idx = idx, pos = lapply(idx, function(i) {
            sort(unique(round(suppressWarnings(as.numeric(d[[i]]$x)))))
        }))
    })

    # A categorical x axis has no numeric positions to dodge across; leave it be
    # rather than writing NAs over the trace.
    usable <- vapply(panels, function(panel) {
        !any(vapply(panel$pos, function(v) length(v) == 0 || anyNA(v), logical(1)))
    }, logical(1))
    if (!any(usable)) {
        return(fig)
    }

    occupants_in <- function(pos) {
        function(p) which(vapply(pos, function(v) p %in% v, logical(1)))
    }

    # One width for the whole figure, so boxes do not change size between panels.
    n_max <- max(vapply(panels[usable], function(panel) {
        occupants <- occupants_in(panel$pos)
        max(vapply(
            sort(unique(unlist(panel$pos))),
            function(p) length(occupants(p)), integer(1)
        ))
    }, integer(1)))

    for (panel in panels[usable]) {
        occupants <- occupants_in(panel$pos)
        for (j in seq_along(panel$idx)) {
            i <- panel$idx[j]
            key <- round(suppressWarnings(as.numeric(d[[i]]$x)))
            d[[i]]$x <- vapply(key, function(p) {
                present <- occupants(p)
                p + dodge.width * ((match(j, present) - 0.5) / length(present) - 0.5)
            }, numeric(1))
            d[[i]]$width <- dodge.width / n_max * box.width
            # Both only matter to the plotly.js dodge we are replacing.
            d[[i]]$offsetgroup <- NULL
            d[[i]]$alignmentgroup <- NULL
        }
    }

    fig$x$data <- d
    # Only once every box carries an explicit position: leaving some on plotly.js'
    # dodge while telling it not to dodge would stack them on the tick.
    if (all(usable)) {
        fig$x$layout$boxmode <- "overlay"
    }
    fig
}


#' A box-geometry control's value, or its default when the control is blank
#'
#' A blank `numericInput()` reports `NA`, which would otherwise propagate into
#' the dodge arithmetic and put every box at `NA`.
#'
#' @param value The input value.
#' @param default Fallback used when `value` is not a single finite number.
#'
#' @return A single number.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_box_num
.box_num <- function(value, default) {
    if (is.null(value) || length(value) != 1 || !is.numeric(value) || !is.finite(value)) {
        default
    } else {
        value
    }
}
