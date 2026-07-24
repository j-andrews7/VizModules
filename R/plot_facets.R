#' Apply custom subplot spacing to a faceted ggplotly figure
#'
#' `ggplotly()` assigns panel layout via plotly domain coordinates
#' (`fig$x$layout$xaxis*/yaxis*$domain`) rather than honouring the ggplot2
#' `panel.spacing` theme option. This helper rewrites those domains so that
#' each facet panel has a uniform size and the gap between panels is exactly
#' `spacing` (expressed as a fraction of the plot area, e.g. `0.04`).
#'
#' In addition to the axis domains, any paper-anchored layout annotations
#' (e.g. facet strip titles) and shapes (e.g. strip backgrounds, panel
#' borders) are remapped through a piecewise-linear transform built from the
#' old and new domain intervals, so strip labels and panel borders move with
#' their panels. Annotations/shapes whose `xref`/`yref` is tied to an axis
#' (for example `"x"`, `"y2"`, or `"x2 domain"`) are left alone because they
#' follow the rewritten axis automatically.
#'
#' The number of columns and rows can be supplied manually, or detected
#' automatically from the distinct x / y domain starts already present in the
#' ggplotly output.
#'
#' @param fig A plotly figure object (typically the result of `ggplotly()`).
#' @param spacing Numeric fraction of the plot area to leave between panels
#'   (default `0.04`). May be a single value applied to both directions, or a
#'   length-2 numeric vector `c(horizontal, vertical)` to control the gap
#'   between columns and rows independently. Must satisfy
#'   `horizontal * (ncol - 1) < 1` and `vertical * (nrow - 1) < 1`; otherwise
#'   the figure is returned unchanged.
#' @param ncol Optional integer. Number of facet columns. If `NULL` or `NA`,
#'   detected from the number of distinct x-axis domain starts.
#' @param nrow Optional integer. Number of facet rows. If `NULL` or `NA`,
#'   detected from the number of distinct y-axis domain starts.
#'
#' @return The modified plotly figure with rewritten axis domains and
#'   remapped paper-anchored annotations/shapes. Figures with a single panel
#'   (or no layout) are returned unchanged.
#'
#' @author Jacob Martin
#' @importFrom stats approx
#' @export
#' @examples
#' p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
#'     ggplot2::geom_point() +
#'     ggplot2::facet_wrap(~cyl)
#' fig <- plotly::ggplotly(p)
#' apply_facet_subplot_spacing(fig, spacing = 0.05)
apply_facet_subplot_spacing <- function(fig, spacing = 0.04, ncol = NULL, nrow = NULL) {
    stopifnot("plotly" %in% class(fig))
    if (is.null(fig$x) || is.null(fig$x$layout)) {
        return(fig)
    }

    layout_names <- names(fig$x$layout)
    x_axes <- layout_names[grepl("^xaxis[0-9]*$", layout_names)]
    y_axes <- layout_names[grepl("^yaxis[0-9]*$", layout_names)]

    if (length(x_axes) <= 1 && length(y_axes) <= 1) {
        return(fig)
    }

    # Sort axes by numeric suffix ("xaxis", "xaxis2", ...)
    axis_order <- function(nms) {
        nums <- suppressWarnings(as.integer(sub("^[xy]axis", "", nms)))
        nums[is.na(nums)] <- 1L
        nms[order(nums)]
    }
    x_axes <- axis_order(x_axes)
    y_axes <- axis_order(y_axes)

    # Capture the existing (old) domains for each axis before we rewrite them.
    get_domain <- function(a) {
        d <- fig$x$layout[[a]]$domain
        if (is.numeric(d) && length(d) == 2L) d else c(NA_real_, NA_real_)
    }
    x_old <- lapply(x_axes, get_domain)
    y_old <- lapply(y_axes, get_domain)
    x_starts <- vapply(x_old, `[`, numeric(1), 1)
    y_starts <- vapply(y_old, `[`, numeric(1), 1)

    valid_x <- !is.na(x_starts)
    valid_y <- !is.na(y_starts)
    if (!any(valid_x) || !any(valid_y)) {
        return(fig)
    }

    # Auto-detect grid dimensions from distinct domain starts in the ggplotly output.
    unique_x_starts <- sort(unique(round(x_starts[valid_x], 6)))
    # Largest y-start = top row, so order descending to get row 1 = top.
    unique_y_starts <- sort(unique(round(y_starts[valid_y], 6)), decreasing = TRUE)

    detected_ncol <- length(unique_x_starts)
    detected_nrow <- length(unique_y_starts)

    if (is.null(ncol) || is.na(ncol)) ncol <- detected_ncol
    if (is.null(nrow) || is.na(nrow)) nrow <- detected_nrow
    ncol <- as.integer(ncol)
    nrow <- as.integer(nrow)
    if (!is.finite(ncol) || !is.finite(nrow) || ncol < 1L || nrow < 1L) {
        return(fig)
    }

    # Guard against invalid spacing that would leave no room for panels.
    # `spacing` may be a single value (applied to both directions) or a
    # length-2 vector c(horizontal, vertical).
    if (!is.numeric(spacing) || length(spacing) < 1L || any(is.na(spacing)) || any(spacing < 0)) {
        return(fig)
    }
    spacing_x <- spacing[1]
    spacing_y <- if (length(spacing) >= 2L) spacing[2] else spacing[1]
    cell_w <- (1 - spacing_x * (ncol - 1)) / ncol
    cell_h <- (1 - spacing_y * (nrow - 1)) / nrow
    if (cell_w <= 0 || cell_h <= 0) {
        return(fig)
    }

    # Map each axis to a column / row using its current domain start relative
    # to the detected unique starts (smallest x = col 1, largest y = row 1).
    col_idx <- match(round(x_starts, 6), unique_x_starts)
    row_idx <- match(round(y_starts, 6), unique_y_starts)

    # Compute the new domains, and build parallel lists of old/new intervals
    # so we can build a piecewise-linear remap for paper coordinates.
    x_new <- x_old
    y_new <- y_old
    for (i in seq_along(x_axes)) {
        c <- col_idx[i]
        if (is.na(c) || c < 1L || c > ncol) next
        x0 <- (c - 1) * (cell_w + spacing_x)
        new_d <- c(x0, x0 + cell_w)
        fig$x$layout[[x_axes[i]]]$domain <- new_d
        x_new[[i]] <- new_d
    }
    for (i in seq_along(y_axes)) {
        r <- row_idx[i]
        if (is.na(r) || r < 1L || r > nrow) next
        y1 <- 1 - (r - 1) * (cell_h + spacing_y)
        new_d <- c(y1 - cell_h, y1)
        fig$x$layout[[y_axes[i]]]$domain <- new_d
        y_new[[i]] <- new_d
    }

    # Build piecewise-linear remap: collect (old_start, new_start) and
    # (old_end, new_end) knots per distinct old interval, anchored by (0,0)
    # and (1,1), then linearly interpolate between them.
    build_remap <- function(old_list, new_list) {
        olds <- numeric(0)
        news <- numeric(0)
        seen <- character(0)
        for (k in seq_along(old_list)) {
            od <- old_list[[k]]
            nd <- new_list[[k]]
            if (any(is.na(od)) || any(is.na(nd))) next
            key <- paste(round(od, 6), collapse = "_")
            if (key %in% seen) next
            seen <- c(seen, key)
            olds <- c(olds, od[1], od[2])
            news <- c(news, nd[1], nd[2])
        }
        if (length(olds) == 0L) return(function(p) p)
        olds <- c(0, olds, 1)
        news <- c(0, news, 1)
        ord <- order(olds)
        olds <- olds[ord]
        news <- news[ord]
        # Collapse duplicate old knots (keep the mean of the corresponding new values).
        dup <- duplicated(round(olds, 8))
        if (any(dup)) {
            agg <- tapply(news, round(olds, 8), mean)
            olds <- as.numeric(names(agg))
            news <- as.numeric(agg)
            ord <- order(olds)
            olds <- olds[ord]
            news <- news[ord]
        }
        function(p) {
            if (!is.numeric(p) || length(p) == 0L) return(p)
            out <- suppressWarnings(stats::approx(olds, news, xout = p, rule = 2)$y)
            out
        }
    }
    remap_x <- build_remap(x_old, x_new)
    remap_y <- build_remap(y_old, y_new)

    # A ref is paper-anchored iff it is NULL, "paper", or missing.
    is_paper_ref <- function(ref) is.null(ref) || identical(ref, "paper") || identical(ref, NA)

    # Remap paper-anchored annotations (e.g. facet strip titles).
    anns <- fig$x$layout$annotations
    if (is.list(anns) && length(anns) > 0L) {
        for (i in seq_along(anns)) {
            a <- anns[[i]]
            if (is.null(a)) next
            if (is_paper_ref(a$xref) && is.numeric(a$x)) {
                a$x <- remap_x(a$x)
            }
            if (is_paper_ref(a$yref) && is.numeric(a$y)) {
                a$y <- remap_y(a$y)
            }
            anns[[i]] <- a
        }
        fig$x$layout$annotations <- anns
    }

    # Remap paper-anchored shapes (e.g. strip backgrounds and panel borders).
    shps <- fig$x$layout$shapes
    if (is.list(shps) && length(shps) > 0L) {
        for (i in seq_along(shps)) {
            s <- shps[[i]]
            if (is.null(s)) next
            if (is_paper_ref(s$xref)) {
                if (is.numeric(s$x0)) s$x0 <- remap_x(s$x0)
                if (is.numeric(s$x1)) s$x1 <- remap_x(s$x1)
            }
            if (is_paper_ref(s$yref)) {
                if (is.numeric(s$y0)) s$y0 <- remap_y(s$y0)
                if (is.numeric(s$y1)) s$y1 <- remap_y(s$y1)
            }
            shps[[i]] <- s
        }
        fig$x$layout$shapes <- shps
    }

    fig
}


#' Resolve facet axis sharing from facet.scales
#'
#' Converts a `facet.scales` string (one of `"fixed"`, `"free"`,
#' `"free_x"`, `"free_y"`) into the `shareX` / `shareY`
#' logical values expected by `plotly::subplot`.
#'
#' @param facet.scales Character, one of `"fixed"` (default),
#'   `"free"`, `"free_x"`, or `"free_y"`.
#'
#' @return A named list with logical elements `shareX` and `shareY`.
#'
#' @author Jared Andrews
#' @export
#' @examples
#' resolve_facet_sharing("fixed")
#' resolve_facet_sharing("free_x")
resolve_facet_sharing <- function(facet.scales = "fixed") {
    shareX <- TRUE
    shareY <- TRUE
    if (facet.scales == "free") {
        shareX <- FALSE
        shareY <- FALSE
    } else if (facet.scales == "free_x") {
        shareX <- FALSE
    } else if (facet.scales == "free_y") {
        shareY <- FALSE
    }
    list(shareX = shareX, shareY = shareY)
}


#' Resolve number of rows for a faceted subplot grid
#'
#' Given the number of facet levels and optional user-supplied
#' `facet.nrow` / `facet.ncol` values, computes the `nrows`
#' argument to pass to `plotly::subplot`.
#'
#' Resolution rules:
#'
#' - Both `NULL`/`NA`: returns 1 (single row, preserves legacy behaviour).
#' - Only `facet.nrow` supplied: returns that value.
#' - Only `facet.ncol` supplied: returns `ceiling(n_facets / facet.ncol)`.
#' - Both supplied: `facet.nrow` wins.
#'
#' The result is clamped to the range `[1, n_facets]`.
#'
#' @param n_facets Integer, number of facet panels.
#' @param facet.nrow Optional integer, user-requested number of rows.
#' @param facet.ncol Optional integer, user-requested number of columns.
#'
#' @return A positive integer giving the number of rows for
#'   `plotly::subplot`.
#'
#' @author Jared Andrews
#' @export
#' @examples
#' resolve_facet_layout(6, facet.nrow = 2)
#' resolve_facet_layout(6, facet.ncol = 3)
resolve_facet_layout <- function(n_facets, facet.nrow = NULL, facet.ncol = NULL) {
    n_facets <- max(1L, as.integer(n_facets))

    .is_set <- function(x) {
        !is.null(x) && length(x) == 1L && !is.na(x) && is.numeric(x) && as.integer(x) >= 1L
    }

    if (.is_set(facet.nrow)) {
        nrows <- as.integer(facet.nrow)
    } else if (.is_set(facet.ncol)) {
        nrows <- as.integer(ceiling(n_facets / as.integer(facet.ncol)))
    } else {
        nrows <- 1L
    }

    # Clamp to [1, n_facets]
    nrows <- max(1L, min(nrows, n_facets))
    nrows
}


#' Build facet subplot annotations
#'
#' Creates a list of plotly annotation objects suitable for labelling faceted
#' subplots arranged in a grid of `nrows` rows. When `nrows = 1`
#' (the default) the behaviour matches the previous single-row layout.
#' Optionally appends a shared X-axis title (bottom centre) and a shared,
#' rotated Y-axis title (left centre).
#'
#' @param facet_levels Character vector of facet level labels, one per subplot.
#' @param x.title Optional character, shared X-axis title. Default: `NULL`.
#' @param y.title Optional character, shared Y-axis title. Default: `NULL`.
#' @param title.font.size Numeric, font size for all annotation text.
#'   Default: 14.
#' @param nrows Integer, number of rows the faceted subplots are arranged in.
#'   Used to compute per-subplot annotation coordinates for multi-row grids
#'   when `fig` is not supplied. Default: 1.
#' @param fig Optional plotly figure. When supplied, per-panel title
#'   coordinates are read directly from the figure's xaxis/yaxis domains so
#'   that titles stay aligned with panels after domain-rewriting helpers such
#'   as [apply_facet_subplot_spacing()]. If `NULL` (the default),
#'   coordinates are computed from `nrows` assuming evenly spaced
#'   panels filling the full paper area.
#' @param title.offset Numeric fraction of the figure height to place each
#'   subplot title above the top of its panel. Default: `0.02`.
#'
#' @return A list of annotation lists suitable for `plotly::layout(annotations = ...)`.
#'
#' @author Jared Andrews
#' @export
#' @examples
#' build_facet_annotations(c("A", "B", "C"), x.title = "X", y.title = "Y")
build_facet_annotations <- function(facet_levels, x.title = NULL,
                                     y.title = NULL,
                                     title.font.size = 14,
                                     nrows = 1,
                                     fig = NULL,
                                     title.offset = 0.02) {
    n_facets <- length(facet_levels)

    # Prefer actual axis domains on the figure (if supplied) so titles follow
    # any domain rewriting performed by e.g. apply_facet_subplot_spacing().
    panel_coords <- NULL
    if (!is.null(fig) && !is.null(fig$x) && !is.null(fig$x$layout)) {
        axis_name <- function(prefix, i) if (i == 1L) prefix else paste0(prefix, i)
        coords <- lapply(seq_len(n_facets), function(i) {
            xa <- fig$x$layout[[axis_name("xaxis", i)]]
            ya <- fig$x$layout[[axis_name("yaxis", i)]]
            if (is.null(xa) || is.null(ya)) {
                return(NULL)
            }
            xd <- xa$domain
            yd <- ya$domain
            if (!is.numeric(xd) || length(xd) != 2L ||
                !is.numeric(yd) || length(yd) != 2L) {
                return(NULL)
            }
            list(x_center = mean(xd), y_title = yd[2] + title.offset)
        })
        if (!any(vapply(coords, is.null, logical(1)))) {
            panel_coords <- coords
        }
    }

    # Fallback: compute from nrows/ncols assuming even, full-paper panels.
    if (is.null(panel_coords)) {
        nrows <- max(1L, as.integer(nrows))
        ncols <- max(1L, as.integer(ceiling(n_facets / nrows)))
        subplot_width <- 1.0 / ncols
        subplot_height <- 1.0 / nrows
        panel_coords <- lapply(seq_len(n_facets), function(i) {
            col_idx <- ((i - 1L) %% ncols)
            row_idx <- ((i - 1L) %/% ncols)
            list(
                x_center = col_idx * subplot_width + (subplot_width / 2),
                y_title = (1 - row_idx * subplot_height) + 0.05 * subplot_height
            )
        })
    }

    # Per-subplot title annotations anchored just above each panel's top edge.
    annotations <- lapply(seq_along(facet_levels), function(i) {
        pc <- panel_coords[[i]]
        list(
            x = pc$x_center,
            y = pc$y_title,
            xref = "paper",
            yref = "paper",
            text = as.character(facet_levels[i]),
            showarrow = FALSE,
            xanchor = "center",
            yanchor = "bottom",
            font = list(size = title.font.size)
        )
    })

    # Shared X-axis title at bottom centre
    if (!is.null(x.title)) {
        annotations <- c(annotations, list(list(
            x = 0.5,
            y = -0.1,
            xref = "paper",
            yref = "paper",
            text = x.title,
            showarrow = FALSE,
            xanchor = "center",
            yanchor = "top",
            font = list(size = title.font.size)
        )))
    }

    # Shared Y-axis title at left centre (rotated)
    if (!is.null(y.title)) {
        annotations <- c(annotations, list(list(
            x = -0.05,
            y = 0.5,
            xref = "paper",
            yref = "paper",
            text = y.title,
            showarrow = FALSE,
            xanchor = "center",
            yanchor = "middle",
            textangle = -90,
            font = list(size = title.font.size)
        )))
    }

    annotations
}


#' Build paper-anchored panel border shapes for a faceted plotly figure
#'
#' Native plotly `subplot()` figures with shared (`shareX`/`shareY`) axes do not
#' render axis border lines on the matched/inner panels, so faceted plots end up
#' with a box around only the first panel. This helper reconstructs each panel's
#' rectangle from the grid of x/y axis domains in the figure layout and returns
#' paper-anchored shapes that draw a uniform border around every panel.
#'
#' Panel rectangles are derived from the geometry of the subplot grid rather than
#' from a per-panel axis index. With shared axes plotly only keeps one axis per
#' column (x) and one per row (y), so an `xaxis{i}`/`yaxis{i}` lookup keyed on the
#' facet index breaks down for grids with more than one row or column. Instead the
#' distinct x-axis domain starts define the columns (left to right) and the
#' distinct y-axis domain starts define the rows (top to bottom), and each facet
#' panel is mapped to a (row, column) cell in row-major fill order — matching how
#' `subplot()` lays panels out.
#'
#' The borders honour the same axis styling semantics used for single-panel
#' figures:
#'
#' - `showline` and `mirror` both `TRUE`: full rectangle
#'   border around each panel.
#' - only `showline` `TRUE`: left and bottom edges only.
#' - `showline` `FALSE`: no borders (empty list).
#'
#' @param fig A plotly figure object whose `x$layout` contains the per-panel
#'   `xaxis*`/`yaxis*` domains (typically after `subplot()` and
#'   [apply_facet_subplot_spacing()]).
#' @param n_facets Integer, number of facet panels.
#' @param showline Logical, whether to draw border lines. Default `TRUE`.
#' @param mirror Logical, whether to mirror the lines to form a full box.
#'   Default `TRUE`.
#' @param linecolor Character, colour of the border lines. Default `"black"`.
#' @param linewidth Numeric, width of the border lines in pixels. Default `0.5`.
#' @param ncol Optional integer. Number of facet columns. If `NULL` or `NA`,
#'   detected from the distinct x-axis domain starts.
#' @param nrow Optional integer. Number of facet rows. If `NULL` or `NA`,
#'   detected from the distinct y-axis domain starts.
#'
#' @return A list of plotly shape definitions (each paper-anchored). Returns an
#'   empty list when borders should not be drawn or panel domains cannot be
#'   resolved.
#'
#' @author Jacob Martin
#' @export
#' @examples
#' p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
#'     ggplot2::geom_point() +
#'     ggplot2::facet_wrap(~cyl)
#' fig <- plotly::ggplotly(p)
#' build_facet_panel_borders(fig, n_facets = 3)
build_facet_panel_borders <- function(fig, n_facets, showline = TRUE, mirror = TRUE,
                                      linecolor = "black", linewidth = 0.5,
                                      ncol = NULL, nrow = NULL) {
    if (!isTRUE(showline) || n_facets < 1L) {
        return(list())
    }
    if (is.null(fig) || is.null(fig$x) || is.null(fig$x$layout)) {
        return(list())
    }

    line_style <- list(color = linecolor, width = linewidth)

    # Collect the per-axis domains. Each distinct x-domain start is a column
    # (ordered left to right) and each distinct y-domain start is a row (ordered
    # top to bottom). This holds for both shared (shareX/shareY) and free axes,
    # because subplot lays panels on a grid regardless of which axes are matched.
    layout_names <- names(fig$x$layout)
    x_axes <- layout_names[grepl("^xaxis[0-9]*$", layout_names)]
    y_axes <- layout_names[grepl("^yaxis[0-9]*$", layout_names)]

    domain_of <- function(a) {
        d <- fig$x$layout[[a]]$domain
        if (is.numeric(d) && length(d) == 2L) d else NULL
    }
    x_domains <- Filter(Negate(is.null), lapply(x_axes, domain_of))
    y_domains <- Filter(Negate(is.null), lapply(y_axes, domain_of))
    if (length(x_domains) == 0L || length(y_domains) == 0L) {
        return(list())
    }

    # One representative domain per distinct start, ordered into columns/rows.
    dedupe_domains <- function(domains, decreasing = FALSE) {
        starts <- vapply(domains, `[`, numeric(1), 1)
        ord <- order(starts, decreasing = decreasing)
        domains <- domains[ord]
        starts <- starts[ord]
        keep <- !duplicated(round(starts, 6))
        domains[keep]
    }
    # Columns left to right (ascending x start); rows top to bottom (descending y start).
    col_domains <- dedupe_domains(x_domains, decreasing = FALSE)
    row_domains <- dedupe_domains(y_domains, decreasing = TRUE)

    detected_ncol <- length(col_domains)
    detected_nrow <- length(row_domains)
    if (is.null(ncol) || is.na(ncol)) ncol <- detected_ncol
    if (is.null(nrow) || is.na(nrow)) nrow <- detected_nrow
    ncol <- as.integer(ncol)
    nrow <- as.integer(nrow)
    if (!is.finite(ncol) || ncol < 1L) ncol <- detected_ncol

    shapes <- list()
    for (i in seq_len(n_facets)) {
        # Panels are filled row-major (left to right, top to bottom).
        col <- ((i - 1L) %% ncol) + 1L
        row <- ((i - 1L) %/% ncol) + 1L
        if (col > length(col_domains) || row > length(row_domains)) {
            next
        }
        xd <- col_domains[[col]]
        yd <- row_domains[[row]]
        if (!is.numeric(xd) || length(xd) != 2L || !is.numeric(yd) || length(yd) != 2L) {
            next
        }

        if (isTRUE(mirror)) {
            # Full rectangle border around the panel.
            shapes[[length(shapes) + 1]] <- list(
                type = "rect", xref = "paper", yref = "paper",
                x0 = xd[1], x1 = xd[2], y0 = yd[1], y1 = yd[2],
                line = line_style, fillcolor = "rgba(0,0,0,0)", layer = "above"
            )
        } else {
            # Left and bottom edges only.
            shapes[[length(shapes) + 1]] <- list(
                type = "line", xref = "paper", yref = "paper",
                x0 = xd[1], x1 = xd[1], y0 = yd[1], y1 = yd[2],
                line = line_style, layer = "above"
            )
            shapes[[length(shapes) + 1]] <- list(
                type = "line", xref = "paper", yref = "paper",
                x0 = xd[1], x1 = xd[2], y0 = yd[1], y1 = yd[1],
                line = line_style, layer = "above"
            )
        }
    }

    shapes
}


#' Clean and validate facet dimension value for lineplot module
#'
#' @description Internal helper function that validates and sanitizes a numeric 
#'   value intended for use as a **facet dimension** (rows or columns) in a 
#'   **ggplot2 faceting layout**. Ensures the value is a positive numeric 
#'   greater than or equal to 1, returning `NULL` for invalid inputs to 
#'   gracefully handle missing or malformed facet specifications.
#'
#' @details This function is used within **VizModules** lineplot functions to 
#'   process user-supplied facet dimensions before passing to `facet_grid()` or 
#'   `facet_wrap()`. Invalid values trigger sensible defaults rather than 
#'   breaking the plot layout.
#'   **Valid inputs** return unchanged. **Invalid inputs** (NULL, NA, non-numeric, 
#'   < 1) return `NULL`.
#' @param val `numeric(1)` or `NULL`  
#'   Proposed facet dimension value (number of rows or columns).
#' @return `numeric(1)` or `NULL`  
#'   Validated facet dimension value, or `NULL` if invalid.
#' @author Jacob Martin
#' @export
#' @examples
#' clean_facet_dim(3)
#' clean_facet_dim(NA)
#' clean_facet_dim(NULL)
clean_facet_dim <- function(val) {
    if (is.null(val) || length(val) == 0 || is.na(val) ||
        !is.numeric(val) || val < 1) {
        return(NULL)
    }
    val
}

#' Identify columns valid for faceting or splitting
#'
#' Scans a data frame and returns the names of columns that are appropriate
#' choices for a facet/split selector. A column qualifies when it is
#' categorical (character or factor) and has fewer than 50 unique values.
#' This keeps facet/split inputs from offering numeric columns or
#' high-cardinality categoricals that would produce an unwieldy number of
#' panels.
#'
#' Intended to populate the `choices` of a facet/split `selectInput()` via
#' [shiny::updateSelectInput()] inside a module server, so that only sensible
#' faceting variables are exposed to the user.
#'
#' @param data A data frame whose columns are evaluated.
#'
#' @return A character vector of column names suitable for faceting/splitting.
#'   Returns `character(0)` when no column qualifies.
#'
#' @details A column is considered valid when both of the following hold:
#'   \itemize{
#'     \item It is categorical: `is.character(col)` or `is.factor(col)`.
#'     \item It has fewer than 50 unique values (`NA`s excluded).
#'   }
#'   Numeric columns and categorical columns with 50 or more distinct values
#'   are always excluded.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_facet_check
.facet_check <- function(data) {
    if (is.null(data) || ncol(data) == 0) {
        return(character(0))
    }
    valid_cols <- character(0)
    for (nm in names(data)) {
        col <- data[[nm]]
        if ((is.character(col) || is.factor(col)) &&
            length(unique(col[!is.na(col)])) < 50) {
            valid_cols <- c(valid_cols, nm)
        }
    }
    valid_cols
}