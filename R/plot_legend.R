#' Rendered diameter of the U+25CF circle glyph relative to its font-size
#'
#' The HTML "black circle" glyph (\code{&#9679;}, U+25CF) used by the custom
#' size legend inks at roughly 0.44x its font-size across the sans-serif fonts
#' in plotly's default font stack (measured via the rendered ink bounding box;
#' the ratio is a property of the glyph design and is stable across those
#' fonts). A plotly marker's \code{size} attribute, by contrast, is its
#' diameter in px. Dividing a target marker diameter by this ratio yields the
#' glyph font-size that renders at that diameter, so the legend circles match
#' the plotted dots.
#'
#' @keywords internal
#' @noRd
.CIRCLE_GLYPH_DIAMETER_RATIO <- 0.44

#' Apply uniform legend font styling to a plotly figure
#'
#' Sets the legend title and entry-label font sizes on a plotly figure so the
#' "Legend" UI inputs behave consistently across plot types. Existing legend
#' settings (orientation, position, font family/colour) are preserved because
#' \code{plotly::layout()} merges the supplied attributes into the current
#' layout. \code{NULL} or \code{NA} sizes are ignored, leaving the
#' corresponding font size untouched.
#'
#' Numeric colour mappings (for example \code{fill.by}/\code{color.by} on a
#' continuous variable) are rendered as a \emph{colorbar} rather than a
#' categorical legend. The layout-level legend font does not affect a colorbar,
#' so the colorbar title and tick fonts are updated directly on each trace (and
#' on any shared \code{coloraxis}) using the same sizes. This keeps the "Legend"
#' controls functional for both categorical and continuous legends.
#'
#' @param fig A plotly figure object.
#' @param title.size Numeric font size for the legend (or colorbar) title, or
#'   \code{NULL} to leave unchanged.
#' @param text.size Numeric font size for the legend entry labels (or colorbar
#'   tick labels), or \code{NULL} to leave unchanged.
#' @return The plotly figure with the requested legend font sizes applied.
#'   Returns the figure unchanged when \code{fig} is \code{NULL} or no valid
#'   sizes are supplied.
#'
#' @author Jared Andrews
#' @importFrom plotly layout plotly_build
#' @export
#' @examples
#' fig <- plotly::plot_ly(iris,
#'     x = ~Sepal.Length, y = ~Sepal.Width,
#'     color = ~Species, type = "scatter", mode = "markers"
#' )
#' apply_legend_styling(fig, title.size = 16, text.size = 10)
apply_legend_styling <- function(fig, title.size = NULL, text.size = NULL) {
    if (is.null(fig)) {
        return(fig)
    }

    valid_size <- function(s) is.numeric(s) && length(s) == 1L && !is.na(s)

    if (!valid_size(title.size) && !valid_size(text.size)) {
        return(fig)
    }

    # Categorical legend: title/entry fonts are layout attributes that
    # plotly::layout() merges into the current legend, preserving position,
    # orientation, and font family/colour.
    legend_font <- list()
    if (valid_size(text.size)) {
        legend_font$size <- text.size
    }
    title_font <- list()
    if (valid_size(title.size)) {
        title_font$size <- title.size
    }

    legend_args <- list()
    if (length(legend_font) > 0L) {
        legend_args$font <- legend_font
    }
    if (length(title_font) > 0L) {
        legend_args$title <- list(font = title_font)
    }
    if (length(legend_args) > 0L) {
        fig <- plotly::layout(fig, legend = legend_args)
    }

    # Continuous legend (colorbar): styled per trace/coloraxis because the
    # layout-level legend font has no effect on a colorbar.
    style_colorbar <- function(cb) {
        if (is.null(cb)) {
            return(NULL)
        }
        if (valid_size(title.size)) {
            # Newer plotly nests the title font under title$font; older
            # versions (and ggplotly output) use the titlefont attribute.
            if (is.list(cb$title)) {
                cb$title$font$size <- title.size
            } else {
                cb$titlefont$size <- title.size
            }
        }
        if (valid_size(text.size)) {
            cb$tickfont$size <- text.size
        }
        cb
    }

    fig <- plotly::plotly_build(fig)

    traces <- fig$x$data
    if (!is.null(traces) && length(traces) > 0L) {
        for (i in seq_along(traces)) {
            for (key in c("marker", "line")) {
                if (!is.null(traces[[i]][[key]]) &&
                    !is.null(traces[[i]][[key]]$colorbar)) {
                    fig$x$data[[i]][[key]]$colorbar <-
                        style_colorbar(traces[[i]][[key]]$colorbar)
                }
            }
        }
    }

    if (!is.null(fig$x$layout$coloraxis$colorbar)) {
        fig$x$layout$coloraxis$colorbar <-
            style_colorbar(fig$x$layout$coloraxis$colorbar)
    }

    fig
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


#' Add a custom bubble-size legend to a plotly figure
#'
#' Renders a manual size legend as a vertical column of HTML circle
#' annotations alongside matching numeric labels. The legend is placed
#' outside the right edge of the plot area using paper-referenced
#' coordinates so it does not overlap data.
#'
#' @param fig A plotly figure object.
#' @param data A data frame containing the variable mapped to point size.
#' @param size_by Character string, or \code{NULL}. Name of the column in
#'   \code{data} whose range determines the legend break labels. When \code{NULL}
#'   or empty (no size mapping is in effect), the figure is returned unchanged.
#' @param gap Numeric. Vertical spacing (in paper units, 0–1) between
#'   consecutive legend entries. Defaults to \code{0.03}.
#' @param size_values Numeric vector of font sizes (px) used to render the
#'   circle glyphs, one per legend entry. When \code{NULL} (the default), the
#'   glyph sizes are derived from the actual marker sizes in \code{fig} so the
#'   legend reflects the plot's size scaling (i.e. the \code{size_min}/
#'   \code{size_max} passed to the plot function); the marker pixel diameters
#'   are converted to glyph font-sizes via \code{.CIRCLE_GLYPH_DIAMETER_RATIO}
#'   so the rendered circles match the plotted dots. When supplied, the vector
#'   is used verbatim as font sizes and its length determines the number of
#'   legend entries.
#' @param title.size Numeric, or \code{NULL}. Font size (px) of the legend
#'   title annotation. When \code{NULL}, plotly's default is used.
#' @param text.size Numeric, or \code{NULL}. Font size (px) of the numeric
#'   label annotations. Defaults to \code{12} when \code{NULL}.
#' @param start_y Numeric. Paper-space y coordinate (0–1) at which the legend
#'   column begins; the title sits just above it and subsequent entries stack
#'   downward. Lower it to vertically offset the size legend from an overlapping
#'   color/shape legend. Invalid values fall back to the default. Defaults to
#'   \code{0.95}.
#' @param start_x Numeric. Paper-space x coordinate at which the legend column
#'   (circles, labels and title) is anchored. Values just above \code{1} place
#'   the legend to the right of the plot area; nudge it lower to pull the whole
#'   set inward when it would otherwise overflow a narrow plot, or higher to push
#'   it further out. Defaults to \code{1.02}.
#'
#' @return The plotly figure with size-legend annotations appended, or the
#'   unmodified figure when \code{size_by} is \code{NULL}/empty or not present
#'   in \code{data}.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_custom_legend
.custom_legend <- function(fig, data, size_by, gap = 0.05, size_values = NULL,
                           title.size = NULL, text.size = NULL, start_y = 0.95,
                           start_x = 1.02) {
    # No size mapping -> nothing to draw, return the figure untouched.
    if (is.null(size_by) || !is.character(size_by) || length(size_by) != 1 ||
        !nzchar(size_by) || !size_by %in% names(data)) {
        return(fig)
    }

    vals <- data[[size_by]]
    if (!is.numeric(vals) || all(is.na(vals))) {
        return(fig)
    }

    valid_size <- function(s) is.numeric(s) && length(s) == 1L && !is.na(s)

    if (!valid_size(start_x)) {
        start_x <- 1.02
    }

    if (!valid_size(start_y)) {
        start_y <- 0.95
    }

    n_breaks <- if (!is.null(size_values)) length(size_values) else 5L
    breaks <- seq(
        from = min(vals, na.rm = TRUE),
        to = max(vals, na.rm = TRUE),
        length.out = n_breaks
    )
    labels <- format(breaks, trim = TRUE, scientific = FALSE)

    # Build the figure once up front. This consolidates marker attributes (so
    # marker sizes can be read back) and, crucially, lets us append the legend
    # annotations directly to the built layout below. Using add_annotations()
    # instead would defer the annotations into layoutAttrs, which any later
    # plotly_build() call (e.g. apply_legend_styling(),
    # axis_titles_as_annotations()) re-merges, duplicating every annotation.
    fig <- plotly::plotly_build(fig)

    # Derive the circle glyph sizes from the plot's actual marker sizes so the
    # legend matches the size scaling produced by size_min/size_max. The marker
    # sizes already encode the area-based scale, so the smallest/largest markers
    # anchor the smallest/largest legend entries and the intermediate breaks
    # follow ggplot2's sqrt (area) interpolation (plotthis uses
    # scale_size(range = c(size_min, size_max)), i.e. area scaling).
    if (is.null(size_values)) {
        marker_sizes <- .extract_marker_sizes(fig)
        if (length(marker_sizes) > 0) {
            d_min <- min(marker_sizes)
            d_max <- max(marker_sizes)
            frac <- if (n_breaks > 1L) seq(0, 1, length.out = n_breaks) else 0
            # Break diameters (px) along ggplot2's area (sqrt) size scale.
            break_diameters <- d_min + (d_max - d_min) * sqrt(frac)
            # A plotly marker's `size` is its diameter in px, but the HTML circle
            # glyph (U+25CF) only inks ~0.44x its font-size. Scale the font-size
            # up so the legend glyphs render at the plotted marker diameters.
            size_values <- break_diameters / .CIRCLE_GLYPH_DIAMETER_RATIO
        } else {
            size_values <- c(10, 20, 30, 40, 50)
        }
    }

    x_pos <- start_x
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
    rendered_radii <- (size_values * .CIRCLE_GLYPH_DIAMETER_RATIO) / 2 / nominal_height_px
    centers <- numeric(length(size_values))
    for (i in seq_along(size_values)) {
        centers[i] <- if (i == 1L) {
            start_y - rendered_radii[i]
        } else {
            centers[i - 1L] - rendered_radii[i - 1L] - gap - rendered_radii[i]
        }
    }

    title_font <- list(color = "#000000")
    if (valid_size(title.size)) {
        title_font$size <- title.size
    }
    label_font_size <- if (valid_size(text.size)) text.size else 12

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
            kept <- parts[parts != size_by]
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
            x = x_pos + 0.02, y = min(start_y + gap, 1),
            xref = "paper", yref = "paper",
            text = size_by, showarrow = FALSE,
            xanchor = "center", yanchor = "middle", font = title_font
        )
    )
    for (i in seq_along(size_values)) {
        yc <- centers[i]

        # Circle annotation
        new_anns[[length(new_anns) + 1L]] <- list(
            x = x_pos, y = yc, xref = "paper", yref = "paper",
            text = paste0(
                "<span style='font-size:", size_values[i],
                "px; color:#000000;'>&#9679;</span>"
            ),
            showarrow = FALSE, xanchor = "center", yanchor = "middle"
        )

        # Label annotation. Offset from the circle by a fixed pixel distance
        # (the glyph's rendered radius plus a constant gap) so the spacing does
        # not scale with plot width.
        rendered_diameter_px <- size_values[i] * .CIRCLE_GLYPH_DIAMETER_RATIO
        label_xshift <- rendered_diameter_px / 2 + label_gap_px
        new_anns[[length(new_anns) + 1L]] <- list(
            x = x_pos, y = yc, xref = "paper", yref = "paper",
            text = labels[i], showarrow = FALSE,
            xanchor = "left", yanchor = "middle", xshift = label_xshift,
            font = list(size = label_font_size, color = "#000000")
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
