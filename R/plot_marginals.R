# Marginal distribution plots for a single-panel figure.

# The kinds of marginal a side can show.
.marginal_types <- c("Density" = "density", "Histogram" = "histogram", "Rug" = "rug")

# Validator for a side's marginal selection in `defaults`; an empty one draws nothing.
.valid_marginal_types <- function(x) {
    is.character(x) && all(x %in% .marginal_types)
}

#' Add marginal distribution plots to a scatter plot
#'
#' Draws the distribution of the plotted X values in a strip above a single-panel plotly
#' figure, and of the Y values in a strip to its right, as a density curve, a histogram, a
#' rug, or any combination of them. One trace is drawn per group, in that group's colour, and
#' the rug gives each group its own lane so groups do not overplot.
#'
#' The main panel is shrunk to make room, and each strip's value axis `matches` the main
#' axis, so zooming or panning the plot moves its marginals with it. Paper-anchored shapes
#' (such as the panel border ggplotly draws) and axis-title annotations from
#' [axis_titles_as_annotations()] are moved into the shrunk panel.
#'
#' Call this last, once everything else has been drawn: helpers that work per panel (fit
#' lines, reference lines, axis styling) read the strips' extra axes as facet panels. It is
#' not meant for a faceted figure.
#'
#' A density and a histogram on the same side share one strip, the histogram drawn first
#' and scaled to a density (count / (n * bin width)) so both share a scale; a histogram on
#' its own shows counts. A rug sits in a strip of its own, between the main panel and any
#' density or histogram. Densities, like ggplot2's, span each group's range of values.
#' Every marginal is a line trace, so box and lasso selection pick only the plot's points,
#' and each takes its group's `legendgroup`, so hiding a group from the legend hides its
#' marginals too.
#'
#' @param fig A single-panel plotly figure.
#' @param x,y Numeric vectors of the plotted X and Y values, one per point. Pass the values
#'   as drawn (after any data adjustment), not the raw data. Non-finite values are dropped.
#' @param groups A vector or factor of the same length giving each point's group, or `NULL`
#'   for a single ungrouped distribution. Factor levels set the order of the rug lanes.
#' @param colors Colours for the groups: a vector named by group, or an unnamed vector
#'   recycled over the groups in level order. Without groups, the first colour is used.
#' @param top,right Character vectors of the marginals to draw above the plot (for `x`) and
#'   to its right (for `y`), any of `"density"`, `"histogram"` and `"rug"`. An empty vector
#'   draws nothing on that side.
#' @param top.size,right.size Fraction of the plot's height (`top.size`) or width
#'   (`right.size`) given to that side's marginals, from 0.02 to 0.8.
#' @param opacity Opacity of the density and histogram fills and of the rug lines, 0 to 1.
#' @param bins Number of histogram bins, spanning the range of all groups' values.
#' @param binwidth Histogram bin width. When given, it overrides `bins`, and the bins are
#'   aligned to multiples of it.
#' @param density.adjust Multiplier on the density bandwidth, as `adjust` in
#'   [stats::density()]. Larger values smooth more.
#' @param rug.size Share of a side's strip given to the rug when the side also has a density
#'   or histogram, 0.1 to 0.9. A rug on its own fills the side.
#' @param rug.length Length of each rug tick as a fraction of its group's lane, 0 to 1.
#' @param rug.width Line width of the rug ticks, in pixels.
#' @param gap Paper-space gap between the main panel and the marginals.
#'
#' @return The built plotly figure with the marginals added, or `fig` unchanged when `top`
#'   and `right` are both empty.
#'
#' @seealso [stats::density()], [axis_titles_as_annotations()]
#' @export
#' @author Jared Andrews
#' @examples
#' library(plotly)
#' df <- example_iris
#' fig <- plot_ly(df,
#'     x = ~Sepal.Length, y = ~Sepal.Width, color = ~Species,
#'     type = "scatter", mode = "markers"
#' )
#' add_marginal_plots(fig,
#'     x = df$Sepal.Length, y = df$Sepal.Width, groups = df$Species,
#'     colors = c("#E69F00", "#56B4E9", "#009E73"),
#'     top = c("density", "rug"), right = "histogram"
#' )
add_marginal_plots <- function(fig, x, y, groups = NULL, colors = "#000000",
                               top = character(0), right = character(0),
                               top.size = 0.15, right.size = 0.15, opacity = 0.5,
                               bins = 30, binwidth = NULL, density.adjust = 1,
                               rug.size = 0.3, rug.length = 0.8, rug.width = 1, gap = 0.02) {
    top <- intersect(.marginal_types, top)
    right <- intersect(.marginal_types, right)
    if (!length(top) && !length(right)) {
        return(fig)
    }

    fig <- plotly::plotly_build(fig)

    if (is.null(groups)) {
        groups <- factor(rep("", length(x)))
        grouped <- FALSE
    } else {
        groups <- droplevels(as.factor(groups))
        grouped <- TRUE
    }
    group.levels <- levels(groups)
    group.colors <- .marginal_colors(group.levels, colors, grouped)

    opacity <- .clamp_number(opacity, 0, 1, 0.5)
    rug.size <- .clamp_number(rug.size, 0.1, 0.9, 0.3)
    rug.length <- .clamp_number(rug.length, 0, 1, 0.8)
    rug.width <- .clamp_number(rug.width, 0.1, 20, 1)
    density.adjust <- .clamp_number(density.adjust, 0.01, Inf, 1)
    gap <- .clamp_number(gap, 0, 0.2, 0.02)

    layout <- fig$x$layout
    x.domain <- layout$xaxis$domain %||% c(0, 1)
    y.domain <- layout$yaxis$domain %||% c(0, 1)
    new.x <- x.domain
    new.y <- y.domain
    if (length(right)) {
        right.size <- .clamp_number(right.size, 0.02, 0.8, 0.15)
        new.x[2] <- x.domain[2] - right.size - gap
    }
    if (length(top)) {
        top.size <- .clamp_number(top.size, 0.02, 0.8, 0.15)
        new.y[2] <- y.domain[2] - top.size - gap
    }
    layout$xaxis$domain <- new.x
    layout$yaxis$domain <- new.y
    layout <- .remap_paper_items(layout, x.domain, new.x, y.domain, new.y)

    next.axis <- c(
        x = .next_axis_index(layout, "x"),
        y = .next_axis_index(layout, "y")
    )
    new.traces <- list()

    for (side in c("top", "right")[c(length(top) > 0, length(right) > 0)]) {
        types <- if (side == "top") top else right
        values <- if (side == "top") x else y
        keep <- is.finite(values) & !is.na(groups)
        values <- values[keep]
        side.groups <- groups[keep]

        # The value axis runs along the main panel; each strip gets a count axis of its own.
        value.letter <- if (side == "top") "x" else "y"
        count.letter <- if (side == "top") "y" else "x"
        value.axis <- paste0(value.letter, next.axis[[value.letter]])
        next.axis[[value.letter]] <- next.axis[[value.letter]] + 1L

        has.rug <- "rug" %in% types
        has.dist <- any(c("density", "histogram") %in% types)
        band <- if (side == "top") {
            c(y.domain[2] - top.size, y.domain[2])
        } else {
            c(x.domain[2] - right.size, x.domain[2])
        }
        strips <- .marginal_strips(band, has.rug, has.dist, rug.size, gap / 2)

        strip.axes <- list()
        for (strip in names(strips)) {
            count.axis <- paste0(count.letter, next.axis[[count.letter]])
            next.axis[[count.letter]] <- next.axis[[count.letter]] + 1L
            strip.axes[[strip]] <- count.axis

            traces <- if (strip == "rug") {
                .marginal_rug_traces(values, side.groups, group.colors, opacity, rug.length, rug.width, side)
            } else {
                .marginal_dist_traces(
                    values, side.groups, group.colors, opacity, intersect(c("histogram", "density"), types),
                    bins, binwidth, density.adjust, side
                )
            }
            count.range <- if (strip == "rug") {
                c(0, max(1, length(group.levels)))
            } else {
                c(0, max(attr(traces, "peak"), 1e-12) * 1.05)
            }

            traces <- lapply(traces, function(tr) {
                tr[[paste0(value.letter, "axis")]] <- value.axis
                tr[[paste0(count.letter, "axis")]] <- count.axis
                if (grouped) {
                    tr$legendgroup <- tr$name
                }
                tr
            })
            new.traces <- c(new.traces, traces)

            layout[[.axis_layout_name(count.axis)]] <- c(
                list(domain = strips[[strip]], anchor = value.axis, range = count.range, fixedrange = TRUE),
                .marginal_axis_style()
            )
        }

        main.axis <- value.letter
        layout[[.axis_layout_name(value.axis)]] <- c(
            list(
                domain = if (side == "top") new.x else new.y,
                matches = main.axis,
                anchor = strip.axes[[1]]
            ),
            .marginal_axis_style()
        )
    }

    fig$x$layout <- layout
    fig$x$data <- c(fig$x$data, new.traces)
    fig
}

# Clamp a single number into [lo, hi], falling back when it is missing or not a number.
.clamp_number <- function(value, lo, hi, fallback) {
    value <- suppressWarnings(as.numeric(value)[1])
    if (length(value) == 0 || !is.finite(value)) {
        return(fallback)
    }
    min(max(value, lo), hi)
}

# "x3" -> "xaxis3", the name a trace's axis reference has in the layout.
.axis_layout_name <- function(ref) {
    sub("^([xy])", "\\1axis", ref)
}

# The first unused axis number for `letter` ("x" or "y") in a layout.
.next_axis_index <- function(layout, letter) {
    names <- grep(paste0("^", letter, "axis[0-9]*$"), names(layout), value = TRUE)
    used <- suppressWarnings(as.integer(sub(paste0("^", letter, "axis"), "", names)))
    used[is.na(used)] <- 1L
    max(c(1L, used)) + 1L
}

# A marginal strip's axes show nothing of their own.
.marginal_axis_style <- function() {
    list(
        showticklabels = FALSE, showgrid = FALSE, zeroline = FALSE, showline = FALSE,
        ticks = "", title = list(text = "")
    )
}

# One colour per group level, in level order: by name when `colors` is named, otherwise by
# position. Unnamed, since an ungrouped plot's one level is "", which cannot be a name.
.marginal_colors <- function(levels, colors, grouped) {
    colors <- as.character(colors)
    if (!length(colors)) {
        colors <- "#000000"
    }
    if (!grouped) {
        return(colors[1])
    }
    by.position <- rep_len(unname(colors), length(levels))
    out <- if (!is.null(names(colors))) unname(colors[levels]) else by.position
    out[is.na(out)] <- by.position[is.na(out)]
    out
}

# Split a side's band into its strips: the rug nearest the main panel, the distribution beyond.
.marginal_strips <- function(band, has.rug, has.dist, rug.size, inner.gap) {
    if (has.rug && has.dist) {
        split <- band[1] + diff(band) * rug.size
        list(
            rug = c(band[1], split - inner.gap / 2),
            dist = c(split + inner.gap / 2, band[2])
        )
    } else if (has.rug) {
        list(rug = band)
    } else {
        list(dist = band)
    }
}

# Move paper-anchored shapes and axis titles drawn for the old panel into the shrunk one.
# Only coordinates inside the old domain move, so items placed outside the panel (the
# axis titles' offsets below and left of it, a legend to its right) keep their place.
.remap_paper_items <- function(layout, old.x, new.x, old.y, new.y) {
    remap <- function(v, old, new) {
        if (!is.numeric(v) || identical(old, new)) {
            return(v)
        }
        inside <- !is.na(v) & v >= old[1] - 1e-9 & v <= old[2] + 1e-9
        v[inside] <- new[1] + (v[inside] - old[1]) * diff(new) / diff(old)
        v
    }
    is.paper <- function(ref) is.null(ref) || identical(ref, "paper")

    if (length(layout$shapes)) {
        layout$shapes <- lapply(layout$shapes, function(s) {
            if (is.paper(s$xref)) {
                s$x0 <- remap(s$x0, old.x, new.x)
                s$x1 <- remap(s$x1, old.x, new.x)
            }
            if (is.paper(s$yref)) {
                s$y0 <- remap(s$y0, old.y, new.y)
                s$y1 <- remap(s$y1, old.y, new.y)
            }
            s
        })
    }

    if (length(layout$annotations)) {
        layout$annotations <- lapply(layout$annotations, function(a) {
            if (!identical(a$annotationType, "axis")) {
                return(a)
            }
            if (is.paper(a$xref)) a$x <- remap(a$x, old.x, new.x)
            if (is.paper(a$yref)) a$y <- remap(a$y, old.y, new.y)
            a
        })
    }
    layout
}

# Lay a trace's value/height pairs along the side: X across the top, Y up the right.
.marginal_xy <- function(values, heights, side) {
    if (side == "top") list(x = values, y = heights) else list(x = heights, y = values)
}

# Shared histogram breaks over all groups' values.
.marginal_breaks <- function(values, bins, binwidth) {
    rng <- range(values)
    if (diff(rng) == 0) {
        rng <- rng + c(-0.5, 0.5)
    }
    binwidth <- suppressWarnings(as.numeric(binwidth)[1])
    if (length(binwidth) && is.finite(binwidth) && binwidth > 0) {
        start <- floor(rng[1] / binwidth) * binwidth
        n <- max(1L, as.integer(ceiling((rng[2] - start) / binwidth)))
        # A bin width far smaller than the data's range would draw thousands of slivers.
        if (n <= 1000L) {
            breaks <- start + binwidth * (0:n)
            if (breaks[length(breaks)] < rng[2]) {
                breaks <- c(breaks, breaks[length(breaks)] + binwidth)
            }
            return(breaks)
        }
    }
    bins <- as.integer(round(.clamp_number(bins, 1, 1000, 30)))
    seq(rng[1], rng[2], length.out = bins + 1L)
}

# Density and/or histogram traces for one side, histograms first. The tallest point drawn
# is returned as the "peak" attribute so the strip's axis can be fitted to it.
.marginal_dist_traces <- function(values, groups, colors, opacity, types, bins, binwidth,
                                  density.adjust, side) {
    traces <- list()
    peak <- 0
    if (!length(values)) {
        return(structure(traces, peak = peak))
    }
    fill <- if (side == "top") "tozeroy" else "tozerox"
    value.ref <- if (side == "top") "%{x:.4g}" else "%{y:.4g}"
    height.ref <- if (side == "top") "%{y:.3g}" else "%{x:.3g}"
    as.density <- "density" %in% types
    breaks <- .marginal_breaks(values, bins, binwidth)
    n.bins <- length(breaks) - 1L

    group.levels <- levels(groups)
    for (type in types) {
        for (i in seq_along(group.levels)) {
            level <- group.levels[i]
            v <- values[groups == level]
            if (!length(v)) next
            color <- colors[[i]]
            label <- if (nzchar(level)) paste0(level, "<br>") else ""
            base <- list(
                type = "scatter", mode = "lines", name = level, showlegend = FALSE,
                fill = fill, fillcolor = plotly::toRGB(color, opacity),
                line = list(color = color, width = 1)
            )

            if (type == "histogram") {
                counts <- tabulate(
                    findInterval(v, breaks, rightmost.closed = TRUE, all.inside = TRUE),
                    nbins = n.bins
                )
                heights <- if (as.density) counts / (length(v) * diff(breaks)) else counts
                # A step outline: up the left edge of each bin, across its top, down the last.
                tr <- c(base, .marginal_xy(rep(breaks, each = 2), c(0, rep(heights, each = 2), 0), side))
                bin <- c(1L, rep(seq_len(n.bins), each = 2), n.bins)
                tr$text <- paste0(
                    label, signif(breaks[bin], 4), " to ", signif(breaks[bin + 1L], 4),
                    "<br>Count: ", counts[bin]
                )
                tr$hoverinfo <- "text"
                peak <- max(peak, heights)
            } else {
                if (length(v) < 2) next
                d <- tryCatch(
                    stats::density(v, adjust = density.adjust, from = min(v), to = max(v)),
                    error = function(e) NULL
                )
                if (is.null(d)) next
                tr <- c(base, .marginal_xy(d$x, d$y, side))
                tr$line$width <- 1.5
                tr$hovertemplate <- paste0(label, value.ref, "<br>Density: ", height.ref, "<extra></extra>")
                peak <- max(peak, d$y)
            }
            traces[[length(traces) + 1L]] <- tr
        }
    }
    structure(traces, peak = peak)
}

# Rug traces for one side, one lane per group: the first group in the top lane above the
# plot and the leftmost lane beside it. Each group is one trace of NA-separated ticks.
.marginal_rug_traces <- function(values, groups, colors, opacity, rug.length, rug.width, side) {
    group.levels <- levels(groups)
    n <- length(group.levels)
    traces <- list()
    for (i in seq_len(n)) {
        v <- values[groups == group.levels[i]]
        if (!length(v)) next
        center <- if (side == "top") n - i + 0.5 else i - 0.5
        ends <- center + c(-0.5, 0.5) * rug.length
        tr <- list(
            type = "scatter", mode = "lines", name = group.levels[i], showlegend = FALSE,
            line = list(color = plotly::toRGB(colors[[i]], opacity), width = rug.width),
            hoverinfo = "skip"
        )
        tr <- c(tr, .marginal_xy(
            as.vector(rbind(v, v, NA)), rep(c(ends, NA), length(v)), side
        ))
        traces[[length(traces) + 1L]] <- tr
    }
    traces
}
