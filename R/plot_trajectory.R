#' Draw trajectory arrows between group medians on a plotly figure
#'
#' Draws each trajectory as a path through the medians of the groups it names,
#' ending in an arrowhead, as [dittoViz::scatterPlot()]'s `add.trajectory.by.groups`
#' does. dittoViz draws that path with a ggplot arrow, which `ggplotly()` drops, so
#' the scatter module draws trajectories itself.
#'
#' Each path is a line trace, and hovering over a median names its group. Its head is
#' an annotation arrow over the last segment, with both ends in data coordinates
#' (`axref`/`ayref` name the panel's axes), so it stays pointed the right way through
#' zooming and resizing and is drawn above WebGL points. plotly does not clip
#' annotations to the plot area, so the annotation's own line is a hairline under the
#' trace, which is clipped: zoomed in, the path stops at the panel's edge, though a
#' head just past it is still drawn.
#'
#' Medians are taken from the values as plotted, separately for each facet panel from
#' the rows that panel draws, and a path is left out of any panel that lacks one of
#' its groups.
#'
#' @param fig A plotly figure from `ggplotly()` (e.g. a dittoViz plot).
#' @param df Data frame holding the plotted values.
#' @param x.col,y.col Character. Columns of `df` holding the plotted x and y values.
#' @param group.col Character. Column of `df` whose groups the trajectories pass through.
#' @param trajectories List of character vectors, each naming groups in the order its
#'   path visits them.
#' @param split.by Character vector or `NULL`; the faceting column(s), as for
#'   `.fit_panels()`.
#' @param arrow.size Numeric. Length of the arrowhead in inches, as dittoViz's
#'   `trajectory.arrow.size`.
#' @param color Character. Colour of the line and arrowhead.
#' @param width Numeric. Line width in pixels. The default is the width ggplotly
#'   gives dittoViz's path.
#'
#' @return The figure with a `"Trajectory"` line trace and a head annotation added for
#'   each path drawn in each panel.
#'
#' @importFrom stats median
#'
#' @author Jared Andrews
#' @rdname INTERNAL_add_trajectory_arrows
#' @keywords internal
.add_trajectory_arrows <- function(fig, df, x.col, y.col, group.col, trajectories, split.by = NULL,
                                   arrow.size = 0.1, color = "#000000", width = 1.89) {
    # plotly scales an arrowhead by arrowwidth * arrowsize; head style 2 is 5 of those
    # long, and a browser draws 96 pixels to the inch. The annotation's line is kept to
    # plotly's thinnest, so its size goes into arrowsize.
    if (!is.numeric(arrow.size) || length(arrow.size) != 1 || !is.finite(arrow.size)) arrow.size <- 0.1
    head.width <- 0.1
    head.size <- max(0.3, arrow.size * 96 / 5 / head.width)

    heads <- list()
    for (panel in .fit_panels(fig, df, split.by)) {
        pdf <- panel$df
        pdf <- pdf[is.finite(pdf[[x.col]]) & is.finite(pdf[[y.col]]), , drop = FALSE]
        groups <- as.character(pdf[[group.col]])
        cent.x <- vapply(split(pdf[[x.col]], groups), stats::median, numeric(1))
        cent.y <- vapply(split(pdf[[y.col]], groups), stats::median, numeric(1))

        for (path in trajectories) {
            path <- as.character(path)
            if (length(path) < 2 || !all(path %in% names(cent.x))) next
            px <- unname(cent.x[path])
            py <- unname(cent.y[path])
            n <- length(path)

            # add_paths(), not add_lines(): add_lines() sorts its points by x, which
            # reorders any path that doubles back.
            fig <- fig |>
                plotly::add_paths(
                    x = px,
                    y = py,
                    xaxis = panel$pair$x,
                    yaxis = panel$pair$y,
                    line = list(color = color, width = width),
                    text = paste0(group.col, ": ", path),
                    hoverinfo = "text",
                    name = "Trajectory",
                    legendgroup = "Trajectory",
                    showlegend = FALSE,
                    inherit = FALSE
                )
            heads[[length(heads) + 1]] <- list(
                x = px[n], y = py[n], ax = px[n - 1], ay = py[n - 1],
                xref = panel$pair$x, yref = panel$pair$y,
                axref = panel$pair$x, ayref = panel$pair$y,
                text = "", showarrow = TRUE, standoff = 0,
                arrowhead = 2, arrowsize = head.size, arrowwidth = head.width, arrowcolor = color
            )
        }
    }

    if (length(heads)) {
        fig$x$layout$annotations <- c(fig$x$layout$annotations, heads)
    }
    fig
}


#' Trajectory paths from any form the scatter module takes them in
#'
#' The scatter module's **Trajectories** input reports a named list of rows, each
#' holding the groups its path visits, in order:
#' `list(trajectories1 = list(groups = c("A", "B")))`. `defaults` may instead give
#' dittoViz's `add.trajectory.by.groups` form, a list of character vectors such as
#' `list(c("A", "B"), c("C", "D", "E"))`, or the bracketed text the module once took,
#' `"[A,B],[C,D,E]"`.
#'
#' @param x Any of those forms, or `NULL`.
#'
#' @return A list of character vectors, one per trajectory in the order given, each
#'   without blank or missing entries. Trajectories left empty are dropped.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_trajectory_paths
#' @keywords internal
.trajectory_paths <- function(x) {
    if (is.null(x) || length(x) == 0) {
        return(list())
    }
    if (is.character(x) && length(x) == 1) {
        x <- .string_to_list_of_vectors(x)
    }
    if (!is.list(x)) {
        x <- list(x)
    }
    paths <- lapply(unname(x), function(p) {
        groups <- if (is.list(p) && !is.null(p$groups)) p$groups else p
        groups <- as.character(unlist(groups))
        groups[!is.na(groups) & nzchar(groups)]
    })
    Filter(function(p) length(p) > 0, paths)
}

#' Rows of the scatter module's Trajectories input for a set of paths
#'
#' @param paths A list of character vectors, as from `.trajectory_paths()`.
#'
#' @return A named list of rows, each `list(groups = )`, for the `elements` of
#'   [multiDynamicInput()] or [updateMultiDynamicInput()].
#'
#' @author Jared Andrews
#' @rdname INTERNAL_trajectory_rows
#' @keywords internal
.trajectory_rows <- function(paths) {
    stats::setNames(
        lapply(paths, function(p) list(groups = p)),
        sprintf("trajectories%d", seq_along(paths))
    )
}
