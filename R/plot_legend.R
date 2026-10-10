#' Rendered diameter of the U+25CF circle glyph relative to its font-size
#'
#' The HTML "black circle" glyph (`&#9679;`, U+25CF) used by the custom
#' size legend inks at roughly 0.44x its font-size across the sans-serif fonts
#' in plotly's default font stack (measured via the rendered ink bounding box;
#' the ratio is a property of the glyph design and is stable across those
#' fonts). A plotly marker's `size` attribute, by contrast, is its
#' diameter in px. Dividing a target marker diameter by this ratio yields the
#' glyph font-size that renders at that diameter, so the legend circles match
#' the plotted dots.
#'
#' @keywords internal
#' @noRd
.CIRCLE_GLYPH_DIAMETER_RATIO <- 0.44

#' Apply uniform legend styling to a plotly figure
#'
#' Shows or hides the legend and sets the font family, color and sizes of its
#' title and entry labels, so the "Legend" UI inputs behave consistently across
#' plot types. Existing legend settings (orientation, position, and any font
#' property not supplied) are preserved because `plotly::layout()` merges the
#' supplied attributes into the current layout. `NULL`, `NA` or blank values
#' are ignored, leaving the corresponding property untouched.
#'
#' Numeric colour mappings (for example `fill.by`/`color.by` on a
#' continuous variable) are rendered as a *colorbar* rather than a
#' categorical legend. The layout-level legend font and visibility do not affect
#' a colorbar, so the colorbar title and tick fonts are updated directly on each
#' trace (and on any shared `coloraxis`) using the same values, and hiding the
#' legend turns each colorbar's `showscale` off. This keeps the "Legend"
#' controls functional for both categorical and continuous legends.
#'
#' @param fig A plotly figure object.
#' @param title.size Numeric font size for the legend (or colorbar) title, or
#'   `NULL` to leave unchanged.
#' @param text.size Numeric font size for the legend entry labels (or colorbar
#'   tick labels), or `NULL` to leave unchanged.
#' @param position Optional length-2 vector `c(x, xanchor)` placing the legend
#'   horizontally, e.g. `c(1.02, "left")`. `NULL` (the default) leaves the
#'   position unchanged.
#' @param font.family Character font family for the legend title and entry
#'   labels (and colorbar title and ticks), or `NULL` to leave unchanged.
#' @param font.color Character color for the legend title and entry labels (and
#'   colorbar title and ticks), or `NULL` to leave unchanged.
#' @param show Logical. `FALSE` hides the legend and every colorbar; `TRUE` or
#'   `NULL` (the default) leave their visibility unchanged.
#' @return The plotly figure with the requested legend styling applied.
#'   Returns the figure unchanged when `fig` is `NULL` or nothing valid is
#'   supplied.
#'
#' @author Jared Andrews
#' @importFrom plotly layout plotly_build
#' @importFrom utils modifyList
#' @export
#' @examples
#' fig <- plotly::plot_ly(iris,
#'     x = ~Sepal.Length, y = ~Sepal.Width,
#'     color = ~Species, type = "scatter", mode = "markers"
#' )
#' apply_legend_styling(fig, title.size = 16, text.size = 10, font.family = "Courier New")
#' apply_legend_styling(fig, show = FALSE)
apply_legend_styling <- function(fig, title.size = NULL, text.size = NULL, position = NULL,
                                 font.family = NULL, font.color = NULL, show = NULL) {
    if (is.null(fig)) {
        return(fig)
    }

    valid_size <- function(s) is.numeric(s) && length(s) == 1L && !is.na(s)
    valid_string <- function(s) is.character(s) && length(s) == 1L && !is.na(s) && nzchar(s)
    hide <- isFALSE(show)

    # Family and colour style the title and the entries alike; each takes its
    # own size.
    shared_font <- list()
    if (valid_string(font.family)) {
        shared_font$family <- font.family
    }
    if (valid_string(font.color)) {
        shared_font$color <- font.color
    }
    legend_font <- shared_font
    if (valid_size(text.size)) {
        legend_font$size <- text.size
    }
    title_font <- shared_font
    if (valid_size(title.size)) {
        title_font$size <- title.size
    }

    if (length(legend_font) == 0L && length(title_font) == 0L && is.null(position) && !hide) {
        return(fig)
    }

    # Categorical legend: title/entry fonts are layout attributes that
    # plotly::layout() merges into the current legend, preserving position,
    # orientation, and any font property not given here.
    legend_args <- list()
    if (length(legend_font) > 0L) {
        legend_args$font <- legend_font
    }
    if (length(title_font) > 0L) {
        legend_args$title <- list(font = title_font)
    }

    if (!is.null(position)) {
        legend_args$x <- position[1]
        legend_args$xanchor <- position[2]
    }

    if (length(legend_args) > 0L) {
        fig <- plotly::layout(fig, legend = legend_args)
    }
    if (hide) {
        fig <- plotly::layout(fig, showlegend = FALSE)
    }

    # Continuous legend (colorbar): styled per trace/coloraxis because the
    # layout-level legend font has no effect on a colorbar.
    style_colorbar <- function(cb) {
        if (is.null(cb)) {
            return(NULL)
        }
        if (length(title_font) > 0L) {
            # Newer plotly nests the title font under title$font; older
            # versions (and ggplotly output) use the titlefont attribute.
            if (is.list(cb$title)) {
                cb$title$font <- modifyList(cb$title$font %||% list(), title_font)
            } else {
                cb$titlefont <- modifyList(cb$titlefont %||% list(), title_font)
            }
        }
        if (length(legend_font) > 0L) {
            cb$tickfont <- modifyList(cb$tickfont %||% list(), legend_font)
        }
        cb
    }

    # Whether a trace (or its marker/line) draws a colorbar. layout.showlegend
    # does not hide one, and ggplotly draws each on a dummy trace of its own.
    draws_colorbar <- function(x) is.list(x) && (!is.null(x$colorbar) || isTRUE(x$showscale))

    fig <- plotly::plotly_build(fig)

    traces <- fig$x$data
    if (!is.null(traces) && length(traces) > 0L) {
        for (i in seq_along(traces)) {
            # Heatmap-type traces carry their colorbar at the top level. Read
            # the trace as it stands, so the whole-trace pass keeps the edits
            # made to its marker and line.
            for (key in c("marker", "line", "")) {
                trace <- fig$x$data[[i]]
                part <- if (nzchar(key)) trace[[key]] else trace
                if (!draws_colorbar(part)) {
                    next
                }
                part$colorbar <- style_colorbar(part$colorbar)
                if (hide) {
                    part$showscale <- FALSE
                }
                if (nzchar(key)) {
                    fig$x$data[[i]][[key]] <- part
                } else {
                    fig$x$data[[i]] <- part
                }
            }
        }
    }

    if (!is.null(fig$x$layout$coloraxis)) {
        fig$x$layout$coloraxis$colorbar <-
            style_colorbar(fig$x$layout$coloraxis$colorbar)
        if (hide) {
            fig$x$layout$coloraxis$showscale <- FALSE
        }
    }

    fig
}

#' Apply the uniform Legend inputs to a plotly figure
#'
#' Reads the inputs created by [uniform_legend_inputs_ui()] (`legend.show`,
#' `legend.font.family`, `legend.font.color`, `legend.title.size` and
#' `legend.text.size`) and applies them with [apply_legend_styling()]. An input
#' that has not reported yet (`NULL`) leaves its property unchanged, so the
#' legend stays visible until `legend.show` is `FALSE`.
#'
#' @param fig A plotly figure object.
#' @param input Shiny input object (or a list) containing the legend fields.
#' @param isolate_fn Function to isolate reactive values. Defaults to
#'   `shiny::isolate`.
#'
#' @return The plotly figure with the legend inputs applied.
#'
#' @author Jared Andrews
#' @export
#' @seealso [uniform_legend_inputs_ui()], [reset_legend_inputs()], [apply_legend_styling()]
#' @examples
#' fig <- plotly::plot_ly(iris,
#'     x = ~Sepal.Length, y = ~Sepal.Width,
#'     color = ~Species, type = "scatter", mode = "markers"
#' )
#' legend_input <- list(
#'     legend.show = TRUE, legend.font.family = "Courier New", legend.font.color = "#333333",
#'     legend.title.size = 16, legend.text.size = 12
#' )
#' apply_legend_inputs(fig, legend_input, isolate_fn = identity)
apply_legend_inputs <- function(fig, input, isolate_fn = isolate) {
    apply_legend_styling(
        fig,
        title.size = isolate_fn(input$legend.title.size),
        text.size = isolate_fn(input$legend.text.size),
        font.family = isolate_fn(input$legend.font.family),
        font.color = isolate_fn(input$legend.font.color),
        show = isolate_fn(input$legend.show)
    )
}


#' Hide jitter points from plotly legend
#'
#' Hides jitter point traces from the legend by setting showlegend to FALSE.
#' The jitter points remain visible in the plot but do not clutter the legend
#' with individual point entries.
#'
#' @param fig A plotly figure object containing scatter traces for jitter points.
#'
#' @return The modified plotly figure with jitter points hidden from the legend.
#'
#' @details This function iterates through all traces in the plotly figure and
#'   identifies scatter traces that represent jitter points (mode = "markers").
#'   For each jitter trace, it sets showlegend to FALSE, preventing them from
#'   appearing in the legend while keeping them visible in the plot. Box traces
#'   and other trace types are returned unchanged.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_hide_jitter_from_legend
.hide_jitter_from_legend <- function(fig) {
    stopifnot("plotly" %in% class(fig))
    for (i in seq_along(fig$x$data)) {
        fig_data <- fig$x$data[[i]]
        if (!is.null(fig_data$type) && fig_data$type == "scatter" && !is.null(fig_data$mode) && fig_data$mode == "markers") {
            fig_data$showlegend <- FALSE
        }
        fig$x$data[[i]] <- fig_data
    }
    fig
}


#' Add a point-size legend to a plotly figure
#'
#' plotly drops the size legend when marker size encodes a numeric column
#' (plotly.R#705), whether the figure comes from [plotly::ggplotly()] or is
#' built by hand. This draws one in its place: a vertical column of circles
#' with numeric labels, outside the right edge of the plot area in
#' paper-referenced coordinates so it does not overlap the data. The breaks run
#' evenly across the size scale's `limits`, and each circle is drawn at the size
#' the scale gives its value, so the legend follows the plot's size scaling. The
#' DotPlot and scatter plot modules use it, and a module in another package can
#' too.
#'
#' For a ggplot drawn with `scale_size(range = r, limits = l)`, pass
#' `size.range = r` and `limits = l`. Without `size.range`, the circles are read
#' from the figure's own markers instead, taking its smallest and largest to be
#' the data's minimum and maximum.
#'
#' Call it after the figure's traces are complete. It builds the figure and
#' appends its annotations to the built layout, so later
#' [plotly::plotly_build()] calls (e.g. [apply_legend_inputs()] or
#' [axis_titles_as_annotations()]) do not duplicate them. A module hiding its
#' legend should pass `size.by = NULL`.
#'
#' @param fig A plotly figure object.
#' @param data A data frame containing the variable mapped to point size.
#' @param size.by Character string, or `NULL`. Name of the column in
#'   `data` whose range determines the legend break labels. When `NULL`
#'   or empty (no size mapping is in effect), the figure is returned unchanged.
#' @param gap Numeric. Vertical spacing (in paper units, 0–1) between
#'   consecutive legend entries. Defaults to `0.05`.
#' @param size.values Numeric vector of font sizes (px) used to render the
#'   circle glyphs, one per legend entry. When `NULL` (the default), the
#'   glyph sizes follow the plot's size scaling: from `size.range` when it is
#'   given, otherwise from the marker sizes in `fig`. The marker pixel
#'   diameters are converted to glyph font-sizes via
#'   `.CIRCLE_GLYPH_DIAMETER_RATIO` so the rendered circles match the plotted
#'   dots. When supplied, the vector is used verbatim as font sizes and its
#'   length determines the number of legend entries.
#' @param title Character. Legend title. Defaults to `size.by`.
#' @param digits Integer, or `NULL`. Decimal places the break labels are
#'   rounded to. When `NULL` (the default), the break values are printed as
#'   they are.
#' @param title.size Numeric, or `NULL`. Font size (px) of the legend
#'   title annotation. When `NULL`, plotly's default is used.
#' @param text.size Numeric, or `NULL`. Font size (px) of the numeric
#'   label annotations. Defaults to `12` when `NULL`.
#' @param start.y Numeric. Paper-space y coordinate (0–1) at which the legend
#'   column begins; the title sits just above it and subsequent entries stack
#'   downward. Lower it to vertically offset the size legend from an overlapping
#'   color/shape legend. Invalid values fall back to the default. Defaults to
#'   `0.95`.
#' @param start.x Numeric. Paper-space x coordinate at which the legend column
#'   (circles, labels and title) is anchored. Values just above `1` place
#'   the legend to the right of the plot area; nudge it lower to pull the whole
#'   set inward when it would otherwise overflow a narrow plot, or higher to push
#'   it further out. Defaults to `1.02`.
#' @param font.family Character, or `NULL`. Font family of the title and label
#'   annotations. When `NULL`, plotly's default is used.
#' @param font.color Character, or `NULL`. Font color of the title and label
#'   annotations. Defaults to `"#000000"` when `NULL`. The circles stay black.
#' @param limits Numeric length-2 vector, or `NULL`. The `size.by` values drawn
#'   at the smallest and largest sizes, as given to the plot's size scale. The
#'   breaks run evenly between them. A `NA` end takes the data's minimum or
#'   maximum, and limits that are not in increasing order fall back to the
#'   data's range. Defaults to `NULL`, the data's range.
#' @param size.range Numeric length-2 vector, or `NULL`. The size range the
#'   plot's size scale maps `limits` onto, in ggplot2 size units (the `range`
#'   of [ggplot2::scale_size()]). When given, each circle is drawn at the size
#'   the scale gives its break. When `NULL` (the default), the circles are read
#'   from the marker sizes in `fig`.
#' @param breaks Numeric vector, or `NULL`. The `size.by` values to draw a circle
#'   for, in place of five spaced evenly between the limits. Values outside the
#'   limits are dropped. Useful for round labels, or to leave out the lower limit
#'   of a scale whose `size.range` starts at 0, which would draw an empty circle.
#'   When `size.values` is also given, it is recycled to one glyph size per break.
#'   Defaults to `NULL`.
#'
#' @return The built plotly figure with size-legend annotations appended, or
#'   the unmodified figure when `size.by` is `NULL`/empty, not present in
#'   `data`, not numeric, or has no finite values.
#'
#' @export
#' @author Jacob Martin, Jared Andrews
#' @examples
#' library(plotly)
#' df <- data.frame(x = 1:5, y = c(2, 4, 3, 5, 1), n = c(10, 40, 25, 80, 55))
#' fig <- plot_ly(df, x = ~x, y = ~y, type = "scatter", mode = "markers",
#'     marker = list(size = sqrt(df$n) * 3))
#' add_size_legend(fig, df, size.by = "n", title = "Count", digits = 0)
#'
#' # A ggplot with a fixed size scale: the legend runs 0, 25, ..., 100.
#' library(ggplot2)
#' p <- ggplot(df, aes(x, y, size = n)) +
#'     geom_point() +
#'     scale_size(range = c(2, 8), limits = c(0, 100))
#' add_size_legend(ggplotly(p), df, size.by = "n", limits = c(0, 100), size.range = c(2, 8))
add_size_legend <- function(fig, data, size.by, gap = 0.05, size.values = NULL, title = size.by,
                            digits = NULL, title.size = NULL, text.size = NULL, start.y = 0.95,
                            start.x = 1.02, font.family = NULL, font.color = NULL,
                            limits = NULL, size.range = NULL, breaks = NULL) {
    # No size mapping -> nothing to draw, return the figure untouched.
    if (is.null(size.by) || !is.character(size.by) || length(size.by) != 1 ||
        !nzchar(size.by) || !size.by %in% names(data)) {
        return(fig)
    }

    vals <- data[[size.by]]
    if (!is.numeric(vals) || !any(is.finite(vals))) {
        return(fig)
    }

    valid_size <- function(s) is.numeric(s) && length(s) == 1L && !is.na(s)

    if (!valid_size(start.x)) {
        start.x <- 1.02
    }

    if (!valid_size(start.y)) {
        start.y <- 0.95
    }

    lims <- .size_limits(vals, limits[1], limits[2])
    # Caller-chosen breaks, kept within the limits; without any, five run evenly
    # between them (or one per size.values glyph).
    breaks <- if (is.numeric(breaks)) breaks[is.finite(breaks) & breaks >= lims[1] & breaks <= lims[2]] else numeric(0)
    breaks <- sort(unique(breaks))
    if (length(breaks) == 0) {
        n_breaks <- if (!is.null(size.values)) length(size.values) else 5L
        breaks <- seq(from = lims[1], to = lims[2], length.out = n_breaks)
    }
    n_breaks <- length(breaks)
    if (!is.null(size.values) && length(size.values) != n_breaks) {
        size.values <- rep_len(size.values, n_breaks)
    }
    labels <- format(if (valid_size(digits)) round(breaks, digits) else breaks, trim = TRUE, scientific = FALSE)

    # Build the figure once up front. This consolidates marker attributes (so
    # marker sizes can be read back) and, crucially, lets us append the legend
    # annotations directly to the built layout below. Using add_annotations()
    # instead would defer the annotations into layoutAttrs, which any later
    # plotly_build() call (e.g. apply_legend_styling(),
    # axis_titles_as_annotations()) re-merges, duplicating every annotation.
    fig <- plotly::plotly_build(fig)

    # Size each circle as the plot sizes its break, on ggplot2's area scale
    # (scale_size(), which plotthis and dittoViz both use): from the scale's own
    # range when the caller gives it, otherwise from the figure's markers.
    if (is.null(size.values)) {
        range_known <- is.numeric(size.range) && length(size.range) == 2L && all(is.finite(size.range))
        marker_sizes <- if (range_known) numeric(0) else .extract_marker_sizes(fig)
        break_diameters <- if (range_known) {
            .size_scale_px(breaks, size.range, lims)
        } else if (length(marker_sizes) > 0) {
            # The smallest and largest markers are the data's extremes, which sit
            # inside the limits when those are wider than the data. Diameter is
            # linear in the square root of a value's position within the limits,
            # so the breaks are placed on that line.
            d_min <- min(marker_sizes)
            d_max <- max(marker_sizes)
            ends <- .size_scale_position(range(vals[is.finite(vals)]), lims)
            pos <- .size_scale_position(breaks, lims)
            if (ends[2] > ends[1]) {
                pmax(0, d_min + (d_max - d_min) * (pos - ends[1]) / (ends[2] - ends[1]))
            } else {
                frac <- if (n_breaks > 1L) seq(0, 1, length.out = n_breaks) else 0
                d_min + (d_max - d_min) * sqrt(frac)
            }
        }
        # A plotly marker's `size` is its diameter in px, but the HTML circle
        # glyph (U+25CF) only inks ~0.44x its font-size. Scale the font-size
        # up so the legend glyphs render at the plotted marker diameters.
        size.values <- if (is.null(break_diameters)) {
            c(10, 20, 30, 40, 50)
        } else {
            break_diameters / .CIRCLE_GLYPH_DIAMETER_RATIO
        }
    }

    x_pos <- start.x
    # Constant pixel gap inserted between a circle's right edge and its numeric
    # label. The labels are anchored at the circle's x (paper space) but offset
    # via the annotation `xshift`, which plotly measures in pixels. Pairing a
    # paper-space anchor with a pixel-space shift keeps the marker-to-label
    # spacing fixed regardless of plot width; a relative paper offset (as used
    # previously) instead grew with the plot, drifting the labels away from the
    # circles on wide plots and crowding them on narrow ones.
    label_gap_px <- 6

    # Vertical centres (paper units) for each legend entry. Advance by each
    # glyph's rendered radius plus the requested gap so larger circles claim
    # proportionally more room and do not overlap once their font-sizes are
    # scaled up to match the plotted marker diameters. A nominal figure height
    # converts the px diameters to paper-space radii. The exact value only
    # affects absolute spacing; if the real figure height differs the entries
    # simply sit a little closer/further apart while staying proportional.
    nominal_height_px <- 500
    rendered_radii <- (size.values * .CIRCLE_GLYPH_DIAMETER_RATIO) / 2 / nominal_height_px
    centers <- numeric(length(size.values))
    for (i in seq_along(size.values)) {
        centers[i] <- if (i == 1L) {
            start.y - rendered_radii[i]
        } else {
            centers[i - 1L] - rendered_radii[i - 1L] - gap - rendered_radii[i]
        }
    }

    valid_string <- function(s) is.character(s) && length(s) == 1L && !is.na(s) && nzchar(s)
    text_font <- list(color = if (valid_string(font.color)) font.color else "#000000")
    if (valid_string(font.family)) {
        text_font$family <- font.family
    }
    title_font <- text_font
    if (valid_size(title.size)) {
        title_font$size <- title.size
    }
    label_font <- c(text_font, list(size = if (valid_size(text.size)) text.size else 12))

    # Strip the size variable from the (categorical) color/shape legend title.
    # When point size maps to a column, ggplotly joins each aesthetic's guide
    # title with "<br />", so the color legend ends up titled e.g.
    # "color<br />size". This manual legend already conveys size, so drop the
    # size line -- but only when the title actually combines multiple guides, so
    # a standalone (already-merged) title is left untouched.
    legend_title <- fig$x$layout$legend$title$text
    if (!is.null(legend_title) && is.character(legend_title) &&
        length(legend_title) == 1L) {
        parts <- unlist(strsplit(legend_title, "<br\\s*/?>|\n"))
        if (length(parts) > 1L) {
            kept <- parts[parts != size.by]
            if (length(kept) == 0L) {
                kept <- parts[1]
            }
            fig$x$layout$legend$title$text <- paste(kept, collapse = "<br />")
        }
    }

    # Assemble the legend annotations and append them directly to the built
    # layout (see plotly_build() note above) so they are not duplicated by
    # subsequent builds.
    new_anns <- list(
        list(
            x = x_pos + 0.02, y = min(start.y + gap, 1),
            xref = "paper", yref = "paper",
            text = title, showarrow = FALSE,
            xanchor = "center", yanchor = "middle", font = title_font
        )
    )
    for (i in seq_along(size.values)) {
        yc <- centers[i]

        # Circle annotation
        new_anns[[length(new_anns) + 1L]] <- list(
            x = x_pos, y = yc, xref = "paper", yref = "paper",
            text = paste0(
                "<span style='font-size:", size.values[i],
                "px; color:#000000;'>&#9679;</span>"
            ),
            showarrow = FALSE, xanchor = "center", yanchor = "middle"
        )

        # Label annotation. Offset from the circle by a fixed pixel distance
        # (the glyph's rendered radius plus a constant gap) so the spacing does
        # not scale with plot width.
        rendered_diameter_px <- size.values[i] * .CIRCLE_GLYPH_DIAMETER_RATIO
        label_xshift <- rendered_diameter_px / 2 + label_gap_px
        new_anns[[length(new_anns) + 1L]] <- list(
            x = x_pos, y = yc, xref = "paper", yref = "paper",
            text = labels[i], showarrow = FALSE,
            xanchor = "left", yanchor = "middle", xshift = label_xshift,
            font = label_font
        )
    }

    existing <- fig$x$layout$annotations
    if (is.null(existing)) {
        existing <- list()
    }
    fig$x$layout$annotations <- c(existing, new_anns)

    return(fig)
}


#' Extract marker sizes from a plotly figure
#'
#' Builds the figure (to consolidate any deferred trace attributes) and
#' collects the numeric marker sizes across all traces. Used to derive a
#' custom size legend that matches the plot's actual point sizes.
#'
#' @param fig A plotly figure object.
#'
#' @return A numeric vector of finite marker sizes, possibly empty.
#'
#' @importFrom plotly plotly_build
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_extract_marker_sizes
.extract_marker_sizes <- function(fig) {
    built <- tryCatch(plotly::plotly_build(fig), error = function(e) NULL)
    if (is.null(built) || is.null(built$x$data)) {
        return(numeric(0))
    }
    sizes <- numeric(0)
    for (tr in built$x$data) {
        s <- tr$marker$size
        if (!is.null(s) && is.numeric(s)) {
            sizes <- c(sizes, s)
        }
    }
    sizes[is.finite(sizes)]
}


#' Size range for a numeric size mapping
#'
#' The smallest and largest point sizes, in ggplot2 size units, from a module's
#' min/max inputs. An end that is missing, `NA` or not numeric falls back to
#' ggplot2's default range, `c(1, 6)`.
#'
#' @param min,max The smallest and largest sizes.
#' @return A numeric length-2 vector.
#'
#' @author Jared Andrews
#' @keywords internal
#' @noRd
.size_range <- function(min, max) {
    valid <- function(s) is.numeric(s) && length(s) == 1L && is.finite(s)
    c(if (valid(min)) min else 1, if (valid(max)) max else 6)
}


#' Limits for a numeric size mapping
#'
#' The values drawn at the smallest and largest sizes. A blank or `NA` end takes
#' the data's minimum or maximum. Limits that do not increase (say a lower limit
#' above the data's maximum) fall back to the data's range, since ggplot2 would
#' otherwise reverse the scale. A module resolves the limits once and gives the
#' same pair to `.size_scale()` and `add_size_legend()`, so the two agree.
#'
#' @param values The numeric values mapped to size.
#' @param lower,upper The requested limits, or `NULL`/`NA` for the data's own.
#' @return A numeric length-2 vector, or `NULL` when `values` has no finite value.
#'
#' @author Jared Andrews
#' @keywords internal
#' @noRd
.size_limits <- function(values, lower = NULL, upper = NULL) {
    values <- values[is.finite(values)]
    if (length(values) == 0L) {
        return(NULL)
    }
    valid <- function(s) is.numeric(s) && length(s) == 1L && is.finite(s)
    data_range <- range(values)
    lims <- c(if (valid(lower)) lower else data_range[1], if (valid(upper)) upper else data_range[2])
    if (lims[1] < lims[2]) lims else data_range
}


#' Size scale for a numeric size mapping
#'
#' ggplot2's area size scale (what [ggplot2::scale_size()] builds) over the
#' given limits, except that a value beyond a limit is drawn at that end's size
#' rather than dropped. Adding it to a plot replaces any size scale already
#' there.
#'
#' @param range The smallest and largest sizes, in ggplot2 size units.
#' @param limits The values drawn at those sizes, or `NULL` for the data's range.
#' @return A ggplot2 continuous scale for the `size` aesthetic.
#'
#' @author Jared Andrews
#' @keywords internal
#' @noRd
.size_scale <- function(range, limits = NULL) {
    ggplot2::continuous_scale(
        "size",
        palette = scales::area_pal(range),
        limits = limits,
        oob = scales::squish
    )
}


#' Position of values on an area size scale
#'
#' The square root of each value's position between the limits, values beyond
#' them taken as the nearest one. A point's diameter on ggplot2's area scale is
#' linear in this.
#'
#' @param values Numeric values.
#' @param limits The scale's limits.
#' @return A numeric vector in `[0, 1]`.
#'
#' @author Jared Andrews
#' @keywords internal
#' @noRd
.size_scale_position <- function(values, limits) {
    sqrt(scales::rescale(pmin(pmax(values, limits[1]), limits[2]), from = limits))
}


#' Diameter of the marker drawn for a value on an area size scale
#'
#' The size `.size_scale()` (or `ggplot2::scale_size()`) gives each value, in
#' the pixels `plotly::ggplotly()` draws it at: a size is in mm, at 96 px to the
#' inch.
#'
#' @param values Numeric values.
#' @param range The scale's smallest and largest sizes, in ggplot2 size units.
#' @param limits The scale's limits.
#' @return Marker diameters in px.
#'
#' @author Jared Andrews
#' @keywords internal
#' @noRd
.size_scale_px <- function(values, range, limits) {
    (range[1] + (range[2] - range[1]) * .size_scale_position(values, limits)) * 96 / 25.4
}
