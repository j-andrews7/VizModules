# Expectations for anything VizModules draws over a plot it did not draw itself:
# significance brackets, fit lines, model lines, ribbons. Such an overlay is only right if
# it is in the plot's own coordinate space -- after any axis adjustment, on the
# panel it describes, within the range the axis finally shows. That is easiest to
# check on the built figure, which is what these do. Use them for any new overlay.

# The range a built figure's axis shows, from a trace/shape reference ("x2", "y").
.built_axis_range <- function(built, ref) {
    ax <- built$x$layout[[sub("^([xy])", "\\1axis", ref)]]
    r <- as.numeric(unlist(ax$range))
    if (length(r) == 2 && all(is.finite(r))) sort(r) else NULL
}

.data_ref <- function(ref) {
    !is.null(ref) && !grepl("paper|domain", ref)
}

.within <- function(values, range, tol = 1e-6) {
    values <- as.numeric(unlist(values))
    slack <- diff(range) * tol
    all(values >= range[1] - slack & values <= range[2] + slack)
}

# Every bracket line and label anchored to data coordinates lies within the range
# its axes show once the figure is built. Returns the built figure invisibly.
expect_brackets_within_axes <- function(fig, min.count = 1) {
    built <- plotly::plotly_build(fig)
    lay <- built$x$layout
    shapes <- Filter(function(s) identical(s$type, "line") && .data_ref(s$yref), lay$shapes)
    labels <- Filter(function(a) .data_ref(a$yref) && !isTRUE(a$showarrow), lay$annotations)

    testthat::expect_gte(length(shapes) + length(labels), min.count)
    for (s in shapes) {
        y_range <- .built_axis_range(built, s$yref)
        x_range <- .built_axis_range(built, s$xref)
        testthat::expect_true(!is.null(y_range) && .within(c(s$y0, s$y1), y_range),
            label = sprintf("bracket at y %s within %s range %s",
                toString(signif(c(s$y0, s$y1), 4)), s$yref, toString(signif(y_range, 4))))
        testthat::expect_true(!is.null(x_range) && .within(c(s$x0, s$x1), x_range),
            label = sprintf("bracket at x %s within %s range", toString(signif(c(s$x0, s$x1), 4)), s$xref))
    }
    for (a in labels) {
        y_range <- .built_axis_range(built, a$yref)
        testthat::expect_true(!is.null(y_range) && .within(a$y, y_range),
            label = sprintf("label '%s' at y %s within %s range %s",
                a$text, signif(a$y, 4), a$yref, toString(signif(y_range, 4))))
    }
    invisible(built)
}

# Every point label (an arrowed annotation anchored to data coordinates) points at
# a position that is finite and within its axes. A label built from a point the
# plot could not draw (its adjusted value is NaN) has a missing coordinate, which
# plotly places somewhere arbitrary. Returns the labels invisibly.
expect_point_labels_on_points <- function(fig, min.count = 1) {
    built <- plotly::plotly_build(fig)
    labels <- Filter(function(a) .data_ref(a$yref) && isTRUE(a$showarrow), built$x$layout$annotations)
    testthat::expect_gte(length(labels), min.count)
    for (a in labels) {
        x <- suppressWarnings(as.numeric(unlist(a$x)))
        y <- suppressWarnings(as.numeric(unlist(a$y)))
        x_range <- .built_axis_range(built, a$xref)
        y_range <- .built_axis_range(built, a$yref)
        testthat::expect_true(
            length(x) == 1 && length(y) == 1 && is.finite(x) && is.finite(y) &&
                (is.null(x_range) || .within(x, x_range)) && (is.null(y_range) || .within(y, y_range)),
            label = sprintf("label '%s' at (%s, %s) on a drawn point", a$text, toString(x), toString(y))
        )
    }
    invisible(labels)
}

# The line traces named `names` lie over the marker traces drawn on the same axes:
# the fit grid runs from the smallest to the largest x it was fit to, so a line
# off to one side was fit to other values. With `full.span`, each line must cover
# (nearly) the whole x-range of those points, as an ungrouped fit does. Most of
# each line must also fall within its y-axis: a straight fit can rise past the data
# at an extreme x and be clipped there, but a line fit in another coordinate space
# is not on the plot at all. Returns the matched traces invisibly.
expect_fit_lines_on_points <- function(fig, names, min.count = 1, full.span = FALSE) {
    built <- plotly::plotly_build(fig)
    traces <- built$x$data
    lines <- Filter(function(tr) isTRUE(tr$name %in% names) && grepl("lines", tr$mode %||% ""), traces)
    testthat::expect_gte(length(lines), min.count)

    for (ln in lines) {
        xref <- ln$xaxis %||% "x"
        yref <- ln$yaxis %||% "y"
        points <- Filter(function(tr) {
            grepl("markers", tr$mode %||% "") && identical(tr$xaxis %||% "x", xref) &&
                identical(tr$yaxis %||% "y", yref)
        }, traces)
        px <- as.numeric(unlist(lapply(points, `[[`, "x")))
        px <- px[is.finite(px)]
        lx <- as.numeric(unlist(ln$x))
        ly <- as.numeric(unlist(ln$y))
        where <- sprintf("'%s' on %s/%s", ln$name, xref, yref)

        testthat::expect_true(length(px) > 0, label = paste("points share the axes of", where))
        testthat::expect_true(.within(lx, range(px)),
            label = sprintf("%s x %s within its points' x %s", where,
                toString(signif(range(lx), 4)), toString(signif(range(px), 4))))
        if (full.span) {
            testthat::expect_true(diff(range(lx)) >= 0.99 * diff(range(px)),
                label = paste(where, "spans its points' x-range"))
        }
        x_range <- .built_axis_range(built, xref)
        y_range <- .built_axis_range(built, yref)
        testthat::expect_true(is.null(x_range) || .within(lx, x_range), label = paste(where, "x within its axis"))
        ly <- ly[is.finite(ly)]
        shown <- if (is.null(y_range)) 1 else mean(ly >= y_range[1] & ly <= y_range[2])
        testthat::expect_true(length(ly) > 0 && shown >= 0.75,
            label = sprintf("%s y %s mostly within its axis %s", where,
                toString(signif(range(ly), 4)), toString(signif(y_range, 4))))
    }
    invisible(lines)
}

# Every ribbon (a `fill = "toself"` trace) belongs to exactly one line drawn on the same
# axes, in the same legend group, and spans only x positions that line is drawn at: a
# ribbon off to one side, or on another panel, was built from other rows. With `contains`,
# its upper edge is at or above the line and its lower edge at or below it at every x, as
# any interval worked out around the plotted value is. Returns the ribbons invisibly.
expect_ribbons_on_lines <- function(fig, min.count = 1, contains = TRUE) {
    built <- suppressWarnings(plotly::plotly_build(fig))
    is_ribbon <- vapply(built$x$data, function(tr) identical(tr$fill, "toself"), logical(1))
    ribbons <- built$x$data[is_ribbon]
    lines <- built$x$data[!is_ribbon]
    testthat::expect_gte(length(ribbons), min.count)

    for (rb in ribbons) {
        xref <- rb$xaxis %||% "x"
        yref <- rb$yaxis %||% "y"
        where <- sprintf("ribbon '%s' on %s/%s", as.character(rb$name), xref, yref)
        owners <- Filter(function(tr) {
            identical(as.character(tr$legendgroup), as.character(rb$legendgroup)) &&
                identical(tr$xaxis %||% "x", xref) && identical(tr$yaxis %||% "y", yref)
        }, lines)
        testthat::expect_true(length(owners) == 1, label = paste(where, "has one line in its legend group"))
        if (length(owners) != 1) next
        ln <- owners[[1]]
        testthat::expect_false(isTRUE(rb$showlegend), label = paste(where, "takes no legend entry"))

        # group2NA() separates the outlines with missing rows.
        rx <- as.character(unlist(rb$x))
        ry <- as.numeric(unlist(rb$y))
        side <- as.character(unlist(rb$text))
        drawn <- !is.na(rx) & !is.na(ry)
        lx <- as.character(unlist(ln$x))
        testthat::expect_true(all(rx[drawn] %in% lx), label = paste(where, "spans only its line's x positions"))

        if (contains) {
            ly <- as.numeric(unlist(ln$y))[match(rx, lx)]
            tol <- 1e-8 * max(1, abs(ly), na.rm = TRUE)
            up <- drawn & side == "Upper"
            down <- drawn & side == "Lower"
            testthat::expect_true(all(ry[up] >= ly[up] - tol) && all(ry[down] <= ly[down] + tol),
                label = paste(where, "encloses its line"))
        }
    }
    invisible(ribbons)
}
