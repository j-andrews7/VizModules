# Scale factor applied to the maximum Y value for initial axis range.
# Using a named constant avoids magic numbers scattered across modules.
.y_axis_scale_factor <- 1.11

# Rescalings the module UIs offer after an adjustment function (dittoViz's
# `*.adjustment` values).
.adjustment_choices <- c("z-score", "relative.to.max")

#' Transform values the way the modules plot them
#'
#' The adjustment function (`adj.fxn`, e.g. `log10`) is applied first, then the
#' `adjustment` rescales the result (`"z-score"` or `"relative.to.max"`). That is
#' the order a transform and a standardisation are normally combined in: log
#' first, then z-score. dittoViz applies them the other way round when given both,
#' which turns every below-average value into `log()` of a negative number, so the
#' modules hand dittoViz this whole transform as its function instead (see
#' [adjustment_fn()]).
#'
#' The rescaling is computed over the finite values only, so a value the function
#' makes non-finite (`log(0)`) is dropped from the plot rather than turning the
#' whole column into `NaN`.
#'
#' Anything drawn over an adjusted plot (significance brackets, fit lines, axis
#' limits) has to be computed from these values, not the raw column, or it lands
#' in a different coordinate space from the data.
#'
#' @param values Vector of values, normally one column of the plotted data.
#' @param adjustment `NULL`, `""`, `"z-score"` or `"relative.to.max"`.
#' @param adj.fxn `NULL`, `""`, a name accepted by [safe_resolve_adj_fxn()], or a
#'   function.
#'
#' @return The transformed values, unnamed.
#'
#' @seealso [adjustment_fn()], [as_plotted()], [adjust_column_values()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' adjusted_values(c(1, 10, 100), adjustment = "z-score", adj.fxn = "log10")
#' adjusted_values(c(1, 2, 4), adjustment = "relative.to.max")
adjusted_values <- function(values, adjustment = NULL, adj.fxn = NULL) {
    values <- unname(values)

    if (is.character(adj.fxn)) {
        adj.fxn <- safe_resolve_adj_fxn(adj.fxn)
    }
    if (is.function(adj.fxn)) {
        values <- adj.fxn(values)
    }

    if (is.numeric(values) && nz_value(adjustment)) {
        ok <- is.finite(values)
        if (identical(adjustment, "z-score")) {
            values[ok] <- (values[ok] - mean(values[ok])) / stats::sd(values[ok])
        }
        if (identical(adjustment, "relative.to.max")) {
            values[ok] <- values[ok] / max(values[ok])
        }
    }
    values
}

#' Tooltip note on the order the adjustment inputs are applied in
#'
#' @param adjustment.label The UI label of the rescaling input (e.g. "Y Adjustment").
#'
#' @return A character scalar.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_adjustment_order_note
#' @keywords internal
.adjustment_order_note <- function(adjustment.label) {
    paste0(
        "The Adjustment Function is applied first, and the ", adjustment.label,
        " then rescales the result (e.g. log10, then z-score)."
    )
}

#' The whole plotted transform as one function, for dittoViz
#'
#' dittoViz applies its `*.adjustment` before its `*.adj.fxn`. Passing it this
#' function as `*.adj.fxn`, with no `*.adjustment`, has it plot
#' [adjusted_values()] instead, while it still builds its adjusted columns, hover
#' text and multi-variable reshape as usual.
#'
#' @param adjustment,adj.fxn Passed to [adjusted_values()].
#'
#' @return A function of one vector, or `NULL` when neither is set.
#'
#' @seealso [adjusted_values()], [as_plotted()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' fn <- adjustment_fn(adjustment = "z-score", adj.fxn = "log10")
#' fn(c(1, 10, 100))
#' adjustment_fn()
adjustment_fn <- function(adjustment = NULL, adj.fxn = NULL) {
    fxn <- if (nz_value(adj.fxn)) safe_resolve_adj_fxn(adj.fxn) else NULL
    if (!nz_value(adjustment) && is.null(fxn)) {
        return(NULL)
    }
    force(adjustment)
    function(values) adjusted_values(values, adjustment, fxn)
}

#' Replace data columns with the values the modules plot for them
#'
#' Applies [adjusted_values()] to each of `cols` in place, keeping the column
#' names. Each column is transformed on its own over the whole frame, as dittoViz
#' does before any row subsetting or multi-variable reshape, so the result can be
#' passed wherever the raw frame was (statistics, model formulas that name the
#' raw columns, axis-range calculations).
#'
#' @param df Data frame.
#' @param cols Character vector of column names to transform. Names not in `df`
#'   are ignored.
#' @param adjustment,adj.fxn Passed to [adjusted_values()].
#'
#' @return `df` with `cols` transformed; unchanged when neither argument is set.
#'
#' @seealso [adjusted_values()], [adjust_column_values()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' as_plotted(data.frame(y = c(1, 10, 100)), "y", adjustment = "z-score", adj.fxn = "log10")
as_plotted <- function(df, cols, adjustment = NULL, adj.fxn = NULL) {
    fxn.set <- is.function(adj.fxn) || nz_value(adj.fxn)
    if (is.null(df) || (!nz_value(adjustment) && !fxn.set)) {
        return(df)
    }
    for (col in intersect(cols, names(df))) {
        df[[col]] <- adjusted_values(df[[col]], adjustment, adj.fxn)
    }
    df
}

#' Adjust numeric column values in a data frame using mathematical transformations
#'
#' Transforms the named numeric columns of a data frame the way the plot modules
#' do for their adjustment inputs, adding the transformed values as a new column
#' (original column name + ".adj"). The function is applied first, then an
#' adjustment (`"z-score"` or `"relative.to.max"`) rescales the result, computed
#' over its finite values. The function name must be one of the allowed functions
#' listed in [safe_resolve_adj_fxn()] (e.g., "log2", "log10", "sqrt", "abs",
#' "as.factor"). The original data frame is returned unchanged if no
#' transformation is specified or if the supplied function name is invalid.
#'
#' Use this to compute anything drawn over an adjusted plot (axis limits, bracket
#' headroom, fit lines) from the values the plot actually shows, rather than the
#' raw column. Note that dittoViz, given both an `*.adjustment` and an
#' `*.adj.fxn`, applies them in the opposite order; the modules pass it the whole
#' transform as its function instead.
#'
#' @param df A data frame containing the column to be transformed.
#' @param x.col Character scalar. Name of the column for x‑axis values (optional).
#' @param y.col Character scalar. Name of the column for y‑axis values (optional).
#' @param color.col Character scalar. Name of the column for color values (optional).
#' @param x.adj.fun Character scalar. Name of a transformation function to apply to x‑axis values,
#'   as accepted by `safe_resolve_adj_fxn` (e.g., "log2", "log10", "sqrt"). If `NULL` or an empty string,
#'   x‑axis values are left unchanged.
#' @param y.adj.fun Character scalar. Name of a transformation function to apply to y‑axis values,
#'   as accepted by `safe_resolve_adj_fxn`. If `NULL` or an empty string, y‑axis values are left unchanged.
#' @param color.adj.fun Character scalar. Name of a transformation function to apply to color values,
#'   as accepted by `safe_resolve_adj_fxn`. If `NULL` or an empty string, color values are left unchanged.
#' @param x.adjustment,y.adjustment,color.adjustment Character scalar. `"z-score"` or
#'   `"relative.to.max"` to rescale that column after its function is applied. If `NULL` or
#'   an empty string, no rescaling is done.
#'
#' @return A data frame identical to input `df` but with transformed columns added
#'   (e.g., `mpg.adj`) when valid transformations are specified.
#'
#' @examples
#' data(mtcars)
#' mtcars_mod <- adjust_column_values(mtcars, x.col = "mpg", x.adj.fun = "log2")
#' head(mtcars_mod$mpg.adj)
#'
#' # log10 first, then z-scored: the values the scatter module draws for that pair
#' mtcars_z <- adjust_column_values(mtcars,
#'     x.col = "hp", x.adj.fun = "log10", x.adjustment = "z-score"
#' )
#' range(mtcars_z$hp.adj)
#'
#' @author Jacob Martin, Jared Andrews
#' @export
adjust_column_values <- function(df, x.col = NULL, y.col = NULL, color.col = NULL,
                                  x.adj.fun = NULL, y.adj.fun = NULL, color.adj.fun = NULL,
                                  x.adjustment = NULL, y.adjustment = NULL, color.adjustment = NULL) {

  apply_trans <- function(d, cols, adj_name, adjustment) {
    out <- d

    adj_fun <- NULL
    if (!is.null(adj_name) && nzchar(as.character(adj_name))) {
      adj_fun <- safe_resolve_adj_fxn(adj_name) #Safety check for string input
    }

    if (!is.null(adj_fun) || nz_value(adjustment)) {
      for (col in cols) {
        if (col %in% names(out) && is.numeric(out[[col]])) {
          out[[paste(col, "adj", sep = ".")]] <- adjusted_values(out[[col]], adjustment, adj_fun)
        }
      }
    }
    return(out)
  }

  df <- apply_trans(df, x.col,       x.adj.fun,     x.adjustment)
  df <- apply_trans(df, y.col,       y.adj.fun,     y.adjustment)
  df <- apply_trans(df, color.col,   color.adj.fun, color.adjustment)

  return(df)
}


#' Evaluate a plot expression under a fixed random seed
#'
#' Builds a plot with a reproducible random stream so randomised layers (jitter,
#' most notably) land in the same place on every rebuild. Without this, any input
#' change re-draws the jitter offsets, which makes points appear to jump around
#' and leaves anything anchored to a point's position pointing at stale coordinates.
#' The caller's random stream is restored afterwards.
#'
#' @param expr Expression producing the plot. Evaluated lazily, after the seed is set.
#' @param seed Integer. Seed to build under.
#'
#' @return The value of `expr`.
#'
#' @export
#' @author Jared Andrews
#' @examples
#' with_stable_seed(runif(2))
#' with_stable_seed(runif(2))
with_stable_seed <- function(expr, seed = 42L) {
    if (exists(".Random.seed", envir = globalenv(), inherits = FALSE)) {
        old_seed <- get(".Random.seed", envir = globalenv(), inherits = FALSE)
        on.exit(assign(".Random.seed", old_seed, envir = globalenv()), add = TRUE)
    } else {
        on.exit(suppressWarnings(rm(".Random.seed", envir = globalenv())), add = TRUE)
    }

    set.seed(seed)
    expr
}


#' Create default Plotly configuration
#'
#' Constructs a configuration list for Plotly plots, enabling interactive
#' editing of titles and legends, export options, and additional drawing tools
#' in the modebar.
#'
#' @param download.format Character. The image format for downloads (e.g., "png", "svg", "jpeg").
#' @param filename Character. The filename for downloaded images (default: current date).
#' @param include.modebar.buttons Logical. Whether to include drawing tool buttons in the modebar (default: TRUE).
#' @param facet.by Whether the figure is faceted into panels carrying their own titles: the facet
#'   column name(s), or `TRUE`. `NULL`, `FALSE`, an empty vector, or empty strings mean not faceted.
#'
#' @return A named list suitable for use as the `config` argument in Plotly
#'   calls, containing edit options, image download settings, extra modebar
#'   buttons, and logo display preferences.
#'
#' @details The configuration enables interactive editing of the
#'   plot title, legend text and position, colorbar position and title, and
#'   annotation tails. It also adds drawing tools (lines, paths, circles,
#'   rectangles, and an eraser) to the modebar. Native cartesian axis-title
#'   text editing is disabled because axis titles are rendered as draggable,
#'   editable annotations (see [axis_titles_as_annotations()] and
#'   `build_facet_annotations()`).
#'
#'   When the figure is faceted, plot title editing is disabled too. An empty editable title still
#'   draws plotly's "Click to enter Plot title" placeholder, which sits on top of the facet panel
#'   titles and swallows clicks meant for them.
#'
#' @author Jacob Martin
#' @export
#' @examples
#' add_plot_config()
#' add_plot_config(download.format = "svg", include.modebar.buttons = FALSE)
add_plot_config <- function(download.format = "png", filename = as.character(Sys.Date()),
                             include.modebar.buttons = TRUE, facet.by = NULL) {
    faceted <- length(facet.by) > 0 && !isFALSE(facet.by) && any(nzchar(as.character(facet.by)))

    config <- list(
        edits = list(
            # Native axis titles are replaced with draggable annotations via
            # axis_titles_as_annotations(), so disable native axis-title text
            # editing to avoid misclicks competing with the annotation titles.
            axisTitleText = FALSE,
            # The empty title's placeholder overlaps facet panel titles.
            titleText = !faceted,
            annotationText = TRUE,
            legendText = TRUE,
            legendPosition = TRUE,
            colorbarPosition = TRUE,
            colorbarTitleText = TRUE,
            annotationTail = TRUE,
            annotationPosition = TRUE
        ),
        toImageButtonOptions = list(
            format = download.format,
            filename = filename
        ),
        displaylogo = FALSE
    )
    if (include.modebar.buttons) {
        config$modeBarButtonsToAdd <- list(
            "drawline",
            "drawopenpath",
            "drawclosedpath",
            "drawcircle",
            "drawrect",
            "eraseshape"
        )
    }


    return(config)
}


#' Derive a stable key for a manually-editable annotation
#'
#' Manual edits (drag/text changes) are captured against annotation indices,
#' but those indices shift between rebuilds (e.g. when statistical brackets or
#' reference labels are added/removed). To re-apply edits reliably, annotations
#' are matched by a stable key derived from their content rather than position:
#' draggable axis titles are keyed by axis side, all other annotations by their
#' text. Returns `NULL` for annotations that cannot be keyed.
#'
#' @param ann A single annotation list from `fig$x$layout$annotations`.
#'
#' @return A character key (e.g. `"axis:x"`, `"axis:y"`, or
#'   `"text:Sepal.Length"`), or `NULL` if no stable key applies.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_annotation_edit_key
.annotation_edit_key <- function(ann) {
    if (is.null(ann)) {
        return(NULL)
    }

    if (!is.null(ann$annotationType) && identical(ann$annotationType, "axis")) {
        return(if (!is.null(ann$textangle) && ann$textangle == -90) "axis:y" else "axis:x")
    }

    # A wrapper's annotation text can arrive as a factor (e.g. a label column
    # factored by the data filter), which nzchar() rejects outright.
    txt <- ann$text
    if (is.atomic(txt) && length(txt) == 1 && !is.na(txt)) {
        txt <- as.character(txt)
        if (nzchar(txt)) {
            return(paste0("text:", txt))
        }
    }

    NULL
}


#' Build occurrence-disambiguated keys for a list of annotations
#'
#' Several annotations can share the same text (e.g. point labels for repeated
#' categories), which would otherwise collapse to one key and cause a single
#' drag to move every match. This appends a per-key occurrence index so each
#' annotation maps to a distinct, rebuild-stable slot. Order is preserved across
#' rebuilds because annotations are regenerated deterministically.
#'
#' @param anns A list of annotations from `fig$x$layout$annotations`.
#'
#' @return A character vector the same length as `anns`; entries are
#'   `NA` for annotations that cannot be keyed.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_annotation_edit_keys
.annotation_edit_keys <- function(anns) {
    bases <- vapply(anns, function(a) {
        base <- .annotation_edit_key(a)
        if (is.null(base)) NA_character_ else base
    }, character(1))

    keys <- rep(NA_character_, length(bases))
    seen <- list()

    for (i in seq_along(bases)) {
        base <- bases[i]
        if (is.na(base)) next
        prev <- seen[[base]]
        n <- if (is.null(prev)) 1L else prev + 1L
        seen[[base]] <- n
        keys[i] <- paste0(base, "#", n)
    }

    keys
}


#' Capture manual plot edits from a plotly relayout event
#'
#' Reads a `plotly_relayout` event payload and records user-driven
#' repositioning/edits of the legend and annotations (including draggable axis
#' titles) into a persistent list. Annotation entries are keyed via
#' [.annotation_edit_key()] so they survive index shifts on rebuild.
#' Range/zoom and autosize keys are ignored so panning does not pin the axes.
#'
#' @param edits A list with components `legend` and `annotations`
#'   (typically `reactiveValuesToList()` of the module's edit store).
#' @param relayout The named list returned by `event_data("plotly_relayout")`.
#' @param fig The most recently rendered plotly figure, used to map annotation
#'   indices in the event to stable keys.
#'
#' @return The updated `edits` list.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_capture_manual_edits
.capture_manual_edits <- function(edits, relayout, fig) {
    if (is.null(relayout) || length(relayout) == 0) {
        return(edits)
    }

    if (is.null(edits$annotations)) {
        edits$annotations <- list()
    }

    keys <- names(relayout)

    # Legend position/anchors, e.g. "legend.x", "legend.y", "legend.xanchor".
    # Dragging an editable legend emits anchors alongside x/y, so capture them
    # all to reproduce the dropped position faithfully on rebuild.
    legend_keys <- grep("^legend\\.", keys, value = TRUE)
    if (length(legend_keys) > 0) {
        if (is.null(edits$legend)) {
            edits$legend <- list()
        }

        for (k in legend_keys) {
            edits$legend[[sub("^legend\\.", "", k)]] <- relayout[[k]]
        }
    }

    # Continuous-colour legends are colorbars, whose drag emits keys containing
    # ".colorbar.x"/".colorbar.y" (per-trace or via coloraxis). 
    cb_keys <- grep("colorbar\\.(x|y)$", keys, value = TRUE)
    if (length(cb_keys) > 0) {
        if (is.null(edits$colorbar)) {
            edits$colorbar <- list()
        }

        for (k in cb_keys) {
            edits$colorbar[[sub(".*colorbar\\.", "", k)]] <- relayout[[k]]
        }
    }

    # Annotation moves/edits, e.g. "annotations[0].x", "annotations[1].text"
    ann_keys <- grep("^annotations\\[[0-9]+\\]\\.", keys, value = TRUE)
    anns <- if (!is.null(fig)) fig$x$layout$annotations else NULL
    edit_keys <- .annotation_edit_keys(anns)

    for (k in ann_keys) {
        m <- regmatches(k, regexec("^annotations\\[([0-9]+)\\]\\.([a-zA-Z]+)$", k))[[1]]

        if (length(m) != 3) next

        idx <- as.integer(m[2]) + 1L
        prop <- m[3]

        if (is.null(anns) || idx > length(anns)) next

        ann_key <- edit_keys[idx]
        if (is.na(ann_key)) next

        if (is.null(edits$annotations[[ann_key]])) {
            edits$annotations[[ann_key]] <- list()
        }

        edits$annotations[[ann_key]][[prop]] <- relayout[[k]]
    }

    edits
}


#' Re-apply captured manual edits onto a freshly built plotly figure
#'
#' Merges legend position and annotation position/text edits (captured by
#' [.capture_manual_edits()]) into a rebuilt figure so manual layout
#' tweaks persist across re-renders. Annotations are matched by stable key, so
#' edits are preserved even if their order changed.
#'
#' @param fig A plotly figure object.
#' @param edits A list with components `legend` and `annotations`.
#' @param regen_keys Character vector of annotation keys (e.g. `"axis:y"`) whose
#'   `text` is regenerated from scratch on every rebuild and must therefore not
#'   be overwritten by a captured edit. Used for axis titles carrying an active
#'   data adjustment (e.g. `"log2(units)"`), so the fresh label wins while any
#'   captured position/font still persists. The `#<occurrence>` suffix added by
#'   `.annotation_edit_keys()` is stripped before matching. Defaults to none.
#'
#' @return The figure with manual edits re-applied.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_reapply_manual_edits
.reapply_manual_edits <- function(fig, edits, regen_keys = character(0)) {
    if (is.null(fig) || is.null(edits)) {
        return(fig)
    }

    if (!is.null(edits$legend)) {
        if (is.null(fig$x$layout$legend)) fig$x$layout$legend <- list()
        for (k in names(edits$legend)) {
            fig$x$layout$legend[[k]] <- edits$legend[[k]]
        }
    }

    # Restore a dragged colorbar onto whichever trace/coloraxis carries one.
    if (!is.null(edits$colorbar)) {
        if (!is.null(fig$x$layout$coloraxis$colorbar)) {
            for (k in names(edits$colorbar)) {
                fig$x$layout$coloraxis$colorbar[[k]] <- edits$colorbar[[k]]
            }
        }

        if (!is.null(fig$x$data)) {
            for (i in seq_along(fig$x$data)) {
                if (!is.null(fig$x$data[[i]]$marker$colorbar)) {
                    for (k in names(edits$colorbar)) {
                        fig$x$data[[i]]$marker$colorbar[[k]] <- edits$colorbar[[k]]
                    }
                }
            }
        }
    }

    anns <- fig$x$layout$annotations
    if (!is.null(anns) && length(edits$annotations) > 0) {
        edit_keys <- .annotation_edit_keys(anns)

        for (i in seq_along(anns)) {
            ann_key <- edit_keys[i]
            if (is.na(ann_key)) next
            e <- edits$annotations[[ann_key]]
            if (is.null(e)) next
            # Axis titles with an active data adjustment are regenerated every
            # rebuild (e.g. "log2(units)"), so never re-apply a captured `text`
            # for those sides; their position/font still persists.
            regen <- sub("#[0-9]+$", "", ann_key) %in% regen_keys
            for (prop in names(e)) {
                if (regen && identical(prop, "text")) next
                anns[[i]][[prop]] <- e[[prop]]
            }
        }

        fig$x$layout$annotations <- anns
    }

    fig
}


#' Build a plotly figure unless it is already built
#'
#' [plotly::plotly_build()] is idempotent, but not free: every call re-runs its
#' verification passes over all traces, and the post-processing helpers each
#' need a built figure to read. A figure built here is marked, and building it
#' again is skipped while nothing has been queued on it since (no `layout()`
#' updates in `layoutAttrs`, no unevaluated traces in `attrs`). Direct writes to
#' `fig$x$data` or `fig$x$layout` need no build, so they keep the mark.
#'
#' @param fig A plotly figure object.
#' @return The built figure.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_ensure_built
.ensure_built <- function(fig) {
    x <- fig$x
    queued <- length(x$layoutAttrs) > 0 ||
        !all(vapply(x$attrs, inherits, logical(1), what = "plotly_eval"))
    if (isTRUE(x$.vizmodules_built) && !queued) {
        return(fig)
    }
    fig <- plotly::plotly_build(fig)
    fig$x$.vizmodules_built <- TRUE
    fig
}


#' How many points a plot draws before its point layers switch to WebGL
#'
#' Set with `options(VizModules.webgl.threshold = n)`; 5000 by default.
#'
#' @return A single number.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_webgl_threshold
.webgl_threshold <- function() {
    threshold <- getOption("VizModules.webgl.threshold", 5000)
    if (!is.numeric(threshold) || length(threshold) != 1 || is.na(threshold)) 5000 else threshold
}


#' Draw a figure's point layers with WebGL
#'
#' SVG slows down badly with many points, where WebGL does not. This switches the
#' figure's point traces (`scatter` traces drawn as markers only: jitter, the
#' points of a scatter plot) to `scattergl` once, together, they hold at least
#' `threshold` points. Lines, filled areas, boxes, and violins stay SVG, so they
#' stay vector in SVG downloads; only the switched points become an embedded
#' image there. Unlike [plotly::toWebGL()], which switches every trace.
#'
#' WebGL canvases sit above SVG traces, so a line drawn over the points (an
#' ellipse, a contour) would end up beneath them. Set `overlays = TRUE` to switch
#' a figure's unfilled line traces with its points, which keeps their order. The
#' points alone decide whether the threshold is reached, and filled traces stay
#' SVG either way.
#'
#' Pair it with [webgl_input()]. The default threshold is 5,000 points, or
#' `options(VizModules.webgl.threshold = n)`.
#'
#' @param fig A plotly figure, built or as [plotly::ggplotly()] returns it.
#' @param threshold Point count at and above which the points switch.
#' @param overlays Logical; also switch unfilled line traces, for lines that must
#'   stay on top of the points.
#'
#' @return The figure.
#'
#' @seealso [webgl_input()]
#' @author Jared Andrews
#' @export
#' @examples
#' fig <- plotly::plot_ly(x = rnorm(100), y = rnorm(100), type = "scatter", mode = "markers")
#' fig <- plotly::plotly_build(fig)
#' auto_webgl(fig, threshold = 50)$x$data[[1]]$type
auto_webgl <- function(fig, threshold = .webgl_threshold(), overlays = FALSE) {
    traces <- fig$x$data
    if (!length(traces)) {
        return(fig)
    }
    unfilled_scatter <- function(tr) {
        identical(tr$type %||% "scatter", "scatter") && (is.null(tr$fill) || identical(tr$fill, "none"))
    }
    has_mode <- function(tr, part) grepl(part, tr$mode %||% "", fixed = TRUE)
    is_points <- vapply(traces, function(tr) {
        unfilled_scatter(tr) && has_mode(tr, "markers") && !has_mode(tr, "lines")
    }, logical(1))
    if (!any(is_points)) {
        return(fig)
    }
    n_points <- sum(vapply(traces[is_points], function(tr) length(tr$x %||% tr$y), numeric(1)))
    if (n_points < threshold) {
        return(fig)
    }
    is_lines <- isTRUE(overlays) & vapply(traces, function(tr) {
        unfilled_scatter(tr) && has_mode(tr, "lines")
    }, logical(1))
    for (i in which(is_points | is_lines)) {
        fig$x$data[[i]]$type <- "scattergl"
        # ggplotly sets it; scattergl has no such attribute and plotly warns.
        fig$x$data[[i]]$hoveron <- NULL
        # A WebGL layer whose hover text is a single string (a background or
        # "others" layer) has nothing to show and breaks hovering on the rest.
        if (length(fig$x$data[[i]]$text) == 1) {
            fig$x$data[[i]]$hoverinfo <- "skip"
        }
    }
    fig
}


#' Forward colorbar drag events to a Shiny input
#'
#' Continuous-colour legends (colorbars) live on a trace's marker, so dragging
#' one fires a `plotly_restyle` event, which `event_data()` does not
#' expose. This attaches an `onRender` listener that reports the dropped
#' colorbar x/y to a Shiny input so the position can be captured and re-applied
#' across rebuilds.
#'
#' @param fig A plotly figure object.
#' @param input_id Fully namespaced input id to receive the position (a list
#'   with `x`/`y`).
#'
#' @return The figure with the listener attached.
#'
#' @importFrom htmlwidgets onRender JS
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_add_colorbar_listener
.add_colorbar_listener <- function(fig, input_id) {
    if (is.null(fig)) {
        return(fig)
    }

    js <- sprintf(
        "function(el){ el.on('plotly_restyle', function(d){ var u = d[0] || {};
            var x, y;
            for (var k in u) {
                if (k.indexOf('colorbar.x') !== -1) x = u[k];
                if (k.indexOf('colorbar.y') !== -1) y = u[k];
            }
            if (x !== undefined || y !== undefined) {
                Shiny.setInputValue('%s', {x: x, y: y}, {priority: 'event'});
            }
        }); }",
        input_id
    )

    htmlwidgets::onRender(fig, htmlwidgets::JS(js))
}


#' Set up persistent manual plot layout edits across re-renders
#'
#' VizModules plots are fully rebuilt on every input change, which would normally
#' discard any layout tweaks a user made by hand: dragging the legend, moving or
#' editing annotations, repositioning the (draggable) axis titles, or sliding a
#' continuous-colour legend (colorbar). `setup_manual_edits()` together with
#' its companion [finalize_manual_edits()] add this persistence to a
#' plotting module with two short lines of wiring, so manually repositioned
#' elements survive subsequent rebuilds.
#'
#' Call `setup_manual_edits()` **once**, near the top of your module's
#' [shiny::moduleServer()] body, so the observers it registers belong
#' to the module's reactive domain. It creates a reactive store and registers the
#' observers that capture `plotly_relayout` events (legend, annotation, and
#' axis-title drags) plus the JavaScript-forwarded colorbar drag. Then, inside
#' your [plotly::renderPlotly()], pass the freshly built figure through
#' [finalize_manual_edits()] before returning it.
#'
#' @param input The module's `input` object.
#' @param session The module's `session` object.
#' @param plot_source Character scalar. A unique plotly event source id for this
#'   module instance, typically `session$ns("<plot-type>")` (e.g.
#'   `session$ns("scatter")`). It scopes the captured `plotly_relayout`
#'   events to this plot and **must match** the `plot_source` later
#'   passed to [finalize_manual_edits()].
#'
#' @return A list (the "edit store") to hand to [finalize_manual_edits()],
#'   with components:
#'   \describe{
#'     \item{`edits`}{A [shiny::reactiveValues()] holding the
#'       captured `legend`, `annotations`, and `colorbar` edits.}
#'     \item{`rendered_fig`}{A [shiny::reactiveVal()] holding the
#'       most recently rendered figure, used to map relayout annotation indices to
#'       stable, rebuild-proof keys.}
#'     \item{`sent`}{An environment recording the figure last sent to the
#'       browser, so a render that changes only its layout sends just that.}
#'     \item{`refresh`}{A [shiny::reactiveVal()] the browser bumps, through the
#'       `plot.refresh` input, when it cannot apply a layout-only update, which
#'       makes the next render send the whole figure.}
#'   }
#'
#' @section Module wiring (three steps):
#'
#' ```
#' myPlotServer <- function(id, data) {
#'     moduleServer(id, function(input, output, session) {
#'         # 1. Unique event source + edit store (once, near the top).
#'         plot_source <- session$ns("myplot")
#'         edit_store <- setup_manual_edits(input, session, plot_source)
#'
#'         output$myPlot <- renderPlotly({
#'             # 2. Create your plotly plot
#'             fig <- build_my_plotly_figure(data(), input)
#'             # 3. Finalize on the rebuilt figure, then return it.
#'             finalize_manual_edits(fig, plot_source, edit_store, session)
#'         })
#'     })
#' }
#' ```
#'
#' @seealso [finalize_manual_edits()] for the render-step companion.
#' @author Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Call once inside a module server's moduleServer() body:
#' plot_source <- session$ns("myplot")
#' edit_store <- setup_manual_edits(input, session, plot_source)
#' }
setup_manual_edits <- function(input, session, plot_source) {
    edits <- reactiveValues(legend = NULL, annotations = list(), colorbar = NULL)
    rendered_fig <- reactiveVal(NULL)

    observeEvent(event_data("plotly_relayout", source = plot_source), {
        rl <- event_data("plotly_relayout", source = plot_source)
        new <- .capture_manual_edits(reactiveValuesToList(edits), rl, rendered_fig())
        edits$legend <- new$legend
        edits$annotations <- new$annotations
        # A coloraxis colorbar drag arrives here rather than through the JS listener.
        edits$colorbar <- new$colorbar
    })

    # Colorbars live on a trace marker, so their drag arrives via JS (see
    # .add_colorbar_listener) rather than the relayout event.
    observeEvent(input$colorbar.move, {
        pos <- input$colorbar.move
        cb <- edits$colorbar %||% list()
        if (!is.null(pos$x)) cb$x <- pos$x
        if (!is.null(pos$y)) cb$y <- pos$y
        edits$colorbar <- cb
    })

    # The browser asks for the whole figure when it cannot apply a layout-only
    # update (see .send_layout_only()), e.g. while an error hides the plot.
    sent <- new.env(parent = emptyenv())
    refresh <- reactiveVal(0)
    observeEvent(input$plot.refresh, {
        sent$rest <- NULL
        refresh(isolate(refresh()) + 1)
    })

    list(edits = edits, rendered_fig = rendered_fig, sent = sent, refresh = refresh)
}


#' Render persistent manual plot layout edits across re-renders
#'
#' Render-step companion to [setup_manual_edits()]. Call this inside
#' your module's [plotly::renderPlotly()] on the freshly rebuilt
#' figure, as the last step: return what it returns.
#'
#' It performs six jobs:
#'
#' 1. tags the figure with the module's plotly event `source` so its
#'   `plotly_relayout` events are captured by `setup_manual_edits()`;
#' 2. restores any manually repositioned legend, annotations, axis titles,
#'   and colorbar captured so far;
#' 3. records the figure so future relayout events can be matched to stable
#'   annotation keys (surviving re-ordering on rebuild);
#' 4. attaches the JavaScript listener that forwards colorbar drags;
#' 5. has the figure re-rendered in place: `layout.transition = TRUE` makes the
#'   plotly widget update its graph with `Plotly.react()` instead of purging and
#'   recreating it, which is faster and keeps the user's zoom and toggled legend
#'   entries whenever `layout.uirevision` is unchanged (the cached modules set
#'   it per build of the plot, so styling changes keep the view). A small script
#'   clears the previous render's event listeners first, which purging used to;
#'   and
#' 6. sends only the layout when nothing else changed: if the figure's traces,
#'   config, `layout.uirevision`, and everything else but its layout match the
#'   figure last sent to this output, the new layout goes to the browser in a
#'   small message, applied with `Plotly.react()` over the traces already drawn,
#'   and the render is cancelled (`req(FALSE, cancelOutput = TRUE)`), so no code
#'   after this call runs. A styling change then costs kilobytes rather than the
#'   whole figure.
#'   Set `options(VizModules.layout.updates = FALSE)` to always send the whole
#'   figure.
#'
#' Restored edits are applied under [shiny::isolate()] so re-applying
#' them never triggers an additional re-render.
#'
#' @param fig A plotly figure object, typically the result of your
#'   plotting pipeline. If `NULL`, it is returned
#'   unchanged.
#' @param plot_source Character scalar. The **same** plotly event source id
#'   passed to [setup_manual_edits()]; assigned to `fig$x$source`.
#' @param store The list returned by [setup_manual_edits()].
#' @param session The module's `session` object, used to namespace the
#'   colorbar drag input.
#' @param regen_keys Character vector of annotation keys (e.g. `"axis:y"`) whose
#'   `text` is regenerated on every rebuild and must not be overwritten by a
#'   captured edit. Pass the axis side(s) carrying an active data adjustment so
#'   the freshly built label (e.g. `"log2(units)"`) always wins, while the
#'   captured position still persists. Defaults to none (all captured props are
#'   restored, the pre-existing behaviour).
#'
#' @return The finalized plotly figure, ready to be returned from
#'   [plotly::renderPlotly()]. Inside a render, when only the layout changed,
#'   it instead sends the layout and cancels the render.
#'
#' @seealso [setup_manual_edits()] for the setup-step companion.
#' @author Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Inside renderPlotly(), after building `fig`:
#' finalize_manual_edits(fig, plot_source, edit_store, session)
#' }
finalize_manual_edits <- function(fig, plot_source, store, session, regen_keys = character(0)) {
    if (is.null(fig)) {
        return(fig)
    }

    fig$x$source <- plot_source
    fig <- .reapply_manual_edits(fig, isolate(reactiveValuesToList(store$edits)), regen_keys)
    fig <- .update_in_place(fig)
    fig <- .add_colorbar_listener(fig, session$ns("colorbar.move"))
    in_render <- !is.null(getCurrentOutputInfo(session)) && is.environment(store$sent)
    if (in_render) {
        # Built here so the layout compared and sent is the one the widget would
        # draw; renderPlotly() builds it again anyway, so its own hook can go.
        fig <- .ensure_built(fig)
        fig$preRenderHook <- NULL
    }
    store$rendered_fig(fig)
    if (in_render) .send_layout_only(fig, store, session) else fig
}


#' Send a figure whose traces have not changed as a layout-only update
#'
#' Compares the figure with the one last sent to the output being rendered. If
#' everything but the layout is identical (traces, config, frames, event
#' wiring, dependencies, and render hooks), the layout is sent in a
#' `vizmodules-plotly-layout` message, which `plotlyUpdate.js` applies with
#' `Plotly.react()` over the traces already drawn, and the render is cancelled,
#' so the browser keeps its plot and the trace data is not sent again.
#' Otherwise the figure is recorded and returned, to be sent whole.
#'
#' `identical()` compares unchanged vectors by pointer, so the comparison is cheap
#' when the traces come from a cached figure. A layout holding JavaScript
#' ([htmlwidgets::JS()]) is always sent whole, since only the widget evaluates it.
#'
#' A figure without a `layout.uirevision` of its own is given one that changes
#' only when the figure is sent whole, so the user's zoom survives a styling
#' change in modules not drawn through [cached_structure()] too.
#'
#' A changed `layout.uirevision` is sent whole however little else changed, such
#' as a redraw that only adds the annotations for a selection. It means a new
#' plot, whose view resets, and the traces in the browser hold part of that view:
#' plotly keeps the selected points and hidden legend entries on them, so a
#' selection would stay dimmed over an update that kept them.
#'
#' The browser asks for the whole figure (through the `plot.refresh` input that
#' [setup_manual_edits()] observes) when it cannot apply the update: no plot
#' drawn yet, or an error hiding it, which only a full render clears. The
#' message is therefore sent even when the layout is unchanged.
#'
#' @param fig The finalized, built figure.
#' @param store The list returned by [setup_manual_edits()].
#' @param session The module's `session` object.
#'
#' @return `fig`, when it is to be sent whole; otherwise the render is cancelled.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_send_layout_only
.send_layout_only <- function(fig, store, session) {
    # A session that cannot message the browser (testServer()'s) gets it whole.
    if (isFALSE(getOption("VizModules.layout.updates")) || !is.function(session$sendCustomMessage)) {
        return(fig)
    }
    # Read reactively, so the browser's request for a full render re-runs it.
    store$refresh()
    sent <- store$sent
    id <- getCurrentOutputInfo(session)$name
    rest <- fig
    rest$x[c("layout", "layoutAttrs", "visdat", "cur_data", "attrs")] <- NULL
    rest$preRenderHook <- NULL
    layout <- fig$x$layout
    # A figure with no uirevision of its own (one not drawn through
    # cached_structure()) gets one that changes only with its traces, so a
    # styling change keeps the user's zoom there too.
    own_revision <- is.null(layout$uirevision)
    # A new uirevision is a different plot, whose view resets. Only fresh traces do
    # that: those in the browser hold the view state (selected points, hidden legend
    # entries), so a redraw adding just annotations still goes out whole.
    same_plot <- own_revision || identical(sent$layout$uirevision, layout$uirevision)

    if (identical(sent$id, id) && identical(sent$rest, rest) && same_plot && !.has_js(layout)) {
        if (own_revision) layout$uirevision <- sent$revision
        changed <- !identical(sent$layout, layout)
        session$sendCustomMessage("vizmodules-plotly-layout", list(
            id = id,
            refresh = session$ns("plot.refresh"),
            layout = if (changed) .widget_json(fig, layout)
        ))
        sent$layout <- layout
        req(FALSE, cancelOutput = TRUE)
    }

    if (own_revision) {
        sent$revision <- paste0(id, "-traces-", (sent$sends %||% 0) + 1)
        fig$x$layout$uirevision <- sent$revision
    }
    sent$sends <- (sent$sends %||% 0) + 1
    sent$id <- id
    sent$rest <- rest
    sent$layout <- fig$x$layout
    fig
}


#' Does an object hold JavaScript for htmlwidgets to evaluate?
#'
#' @param x An object, typically a list.
#' @return `TRUE` if any element is an [htmlwidgets::JS()] string.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_has_js
.has_js <- function(x) {
    length(rapply(list(x), function(v) TRUE, classes = "JS_EVAL", how = "unlist")) > 0
}


#' Serialise part of a widget as its widget would be
#'
#' Uses the serialiser the widget declares (plotly's, for a plotly figure), with
#' its arguments, as htmlwidgets does for the whole payload, so the part decodes
#' in the browser exactly as it would inside a full render.
#'
#' @param fig An htmlwidget, whose `x` carries the serialiser.
#' @param value The value to serialise.
#'
#' @return A `json` string, embedded verbatim in a Shiny message.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_widget_json
.widget_json <- function(fig, value) {
    func <- attr(fig$x, "TOJSON_FUNC", exact = TRUE)
    args <- attr(fig$x, "TOJSON_ARGS", exact = TRUE)
    if (length(args) == 0) {
        args <- getOption("htmlwidgets.TOJSON_ARGS")
    }
    if (!is.function(func)) {
        func <- function(x, ...) {
            jsonlite::toJSON(x, auto_unbox = TRUE, force = TRUE, null = "null", na = "null", ...)
        }
    }
    res <- if (length(args) == 0) func(value) else do.call(func, c(list(x = value), args))
    structure(res, class = "json")
}


#' Have a plotly figure re-rendered in place
#'
#' Sets `layout.transition` to `TRUE`, which makes the plotly widget update an
#' existing graph with `Plotly.react()` rather than purging and recreating it,
#' and attaches `plotlyUpdate.js`, which clears the previous render's event
#' listeners first (the widget re-attaches its own on every render).
#'
#' The widget only checks that `layout.transition` is set. It is `TRUE` rather
#' than a transition such as `list(duration = 0)` because plotly.js animates any
#' `react()` whose changes are all animatable when given one, and an animated
#' update restyles the traces without redrawing the legend: a colour change
#' would leave the legend showing the old colours. plotly.js ignores a
#' transition that is not an object, so each update is drawn in full.
#'
#' @param fig A plotly figure.
#' @return The figure.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_update_in_place
.update_in_place <- function(fig) {
    if (is.null(fig$x$layout$transition)) {
        fig$x$layout$transition <- TRUE
    }
    fig$dependencies <- c(fig$dependencies, list(htmlDependency(
        name = "vizmodules-plotly-update",
        version = as.character(utils::packageVersion("VizModules")),
        src = "src",
        package = "VizModules",
        script = "plotlyUpdate.js"
    )))
    fig
}


#' Discard every captured manual layout edit
#'
#' Used by module Reset buttons, so a dragged legend, annotation, axis title or
#' colorbar goes back to where the rebuilt figure puts it. The store's fields are
#' reactive values, so they are cleared in place; reassigning the list returned
#' by [setup_manual_edits()] would only change a local copy.
#'
#' @param store The list returned by [setup_manual_edits()].
#'
#' @return Invisibly `NULL`; called for its side effect.
#'
#' @seealso [setup_manual_edits()], [finalize_manual_edits()]
#'
#' @export
#' @author Jared Andrews
#' @examples
#' \dontrun{
#' # Inside a module's observeEvent(input$reset, ...):
#' manual_edits <- setup_manual_edits(input, session, plot_source)
#' reset_manual_edits(manual_edits)
#' }
reset_manual_edits <- function(store) {
    edits <- store$edits
    edits$legend <- NULL
    edits$annotations <- list()
    edits$colorbar <- NULL
    invisible(NULL)
}


#' Drop persisted axis-title text edits
#'
#' Removes any captured `text` edit for the given axis-title annotation keys from
#' an edit store, so the axis title is regenerated from its (possibly adjusted)
#' data-derived label on the next rebuild rather than restoring a stale manual
#' edit. Any captured position for those titles is left intact, so a dragged
#' title keeps its place. Intended to be called when the plotted variable for an
#' axis changes (e.g. from an `observeEvent()` or inside the plot-building
#' reactive), matching the convention that a manual title only makes sense for
#' the variable it was written for.
#'
#' @param store The list returned by [setup_manual_edits()].
#' @param keys Character vector of axis annotation keys to clear text for.
#'   Defaults to both axis titles, `c("axis:x", "axis:y")`. The
#'   `#<occurrence>` suffix added by `.annotation_edit_keys()` is ignored when
#'   matching.
#'
#' @return Invisibly, `TRUE` if any stored text was removed, otherwise `FALSE`.
#'
#' @seealso [setup_manual_edits()], [finalize_manual_edits()].
#' @author Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Regenerate the y-axis title whenever the plotted variable changes:
#' observeEvent(input$var, reset_axis_title_text(edit_store, "axis:y"),
#'     ignoreInit = TRUE)
#' }
reset_axis_title_text <- function(store, keys = c("axis:x", "axis:y")) {
    anns <- isolate(store$edits$annotations)
    if (is.null(anns) || length(anns) == 0) {
        return(invisible(FALSE))
    }

    changed <- FALSE
    for (nm in names(anns)) {
        base_key <- sub("#[0-9]+$", "", nm)
        if (base_key %in% keys && !is.null(anns[[nm]][["text"]])) {
            anns[[nm]][["text"]] <- NULL
            # Drop the whole entry if only the (now removed) text was stored.
            if (length(anns[[nm]]) == 0) {
                anns[[nm]] <- NULL
            }
            changed <- TRUE
        }
    }

    if (changed) {
        store$edits$annotations <- anns
    }

    invisible(changed)
}


#' Calculate axis range from data
#'
#' Computes a numeric range for the Y-axis based on specified columns in a
#' data frame, applying a scaling factor to the maximum value. Handles both
#' simple (non-stacked) and stacked bar scenarios, where stacking occurs when
#' `group.by` or `fill.by` is numeric.
#'
#' @param df Data frame. The data containing the variables to range over.
#' @param data_col_y Character vector. Name(s) of the numeric Y-axis data
#'   column(s). Takes priority over `data_col_x` if both are provided. When
#'   several columns are given (e.g. a multi-variable Y selection), the range
#'   spans all of them so a single pair of limits fits every one.
#' @param data_col_x Character string. Name of the X-axis data column. Required
#'   when `grouping = TRUE` or `stack_by` is specified, as it defines
#'   the groups over which Y values are summed.
#' @param axis_scale_factor Numeric. Multiplicative factor applied to the
#'   maximum Y value to provide additional headroom on the axis.
#' @param grouping Logical. If `TRUE`, bars are treated as stacked and the
#'   maximum is derived from the sum of Y values within each X group rather than
#'   the raw maximum. Defaults to `FALSE`.
#' @param stack_by Character string or `NULL`. Name of the column used for
#'   stacking (i.e. `group.by` or `fill.by`). When this column is
#'   numeric, bars are stacked and Y values are summed per X category before
#'   computing the maximum. Ignored if `NULL` or if the column is
#'   categorical. Defaults to `NULL`.
#'
#' @return A named list with components `min` and `max` giving the
#'   lower and upper limits for the Y-axis, or `NULL` if any required
#'   column is missing, non-numeric, or otherwise invalid.
#'
#' @details
#' The function resolves the primary data column(s) from `data_col_y` or
#' `data_col_x` and validates that they exist and are numeric in `df`. Blank
#' and `NA` names are dropped first, and `NULL` is returned if nothing usable
#' remains.
#'
#' Behaviour depends on whether bars are stacked:
#'
#' - **Non-stacked** (`grouping = FALSE`, categorical or absent
#'   `stack_by`): the Y range is computed directly from the finite column
#'   values using `min()` and `max()`.
#'
#' The maximum is padded by `axis_scale_factor - 1` of its magnitude, which is
#' `max * axis_scale_factor` for a positive maximum and still raises a negative
#' one (e.g. log-transformed values below 1).
#' - **Stacked** (`grouping = TRUE` or `stack_by` is
#'   numeric): Y values are summed within each unique X category using
#'   `tapply()`, and the maximum of those sums is used. The minimum is
#'   fixed at 0 since stacked bars always originate from zero.
#'
#' Non-finite results (e.g. from empty or all-`NA` columns) are replaced
#' with default values of 0 for the minimum and 1 for the maximum.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_calculate_range
.calculate_range <- function(df, data_col_x = NULL, data_col_y = NULL,
                             axis_scale_factor, grouping = FALSE,
                             stack_by = NULL) {
    # Resolve primary data column(s); several may be given for a multi-variable
    # selection, in which case the returned limits span all of them.
    data_col <- if (!is.null(data_col_y)) data_col_y else data_col_x
    data_col <- data_col[!is.na(data_col) & nzchar(data_col)]

    # Basic guards
    if (length(data_col) == 0) {
        return(NULL)
    }
    if (!all(data_col %in% names(df))) {
        return(NULL)
    }
    if (!all(vapply(df[, data_col, drop = FALSE], is.numeric, logical(1)))) {
        return(NULL)
    }

    # Sum of the selected columns per row; identical to the column itself (with
    # NAs zeroed) when only one is selected, so stacked heights are unchanged.
    stacked_values <- function() rowSums(df[, data_col, drop = FALSE], na.rm = TRUE)

    # Headroom above the top value. Scaling by the magnitude rather than the value
    # keeps a negative maximum (log of values below 1, neg_log10) from being
    # pulled down into the data; for a positive maximum it is max * factor.
    pad_max <- function(v) v + abs(v) * (axis_scale_factor - 1)

    if (!grouping) {
        # --- Non-stacked: bars are NOT stacked, just find the max single value ---
        # If stack_by is provided and numeric, bars ARE stacked → sum per x group
        if (!is.null(stack_by) && stack_by %in% names(df) && is.numeric(df[[stack_by]])) {
            # Numeric stack_by: stacked bars, sum y per x category
            if (is.null(data_col_x) || length(data_col_x) != 1 || !data_col_x %in% names(df)) {
                return(NULL)
            }
            x_sums <- tapply(stacked_values(), df[[data_col_x]], function(v) sum(v, na.rm = TRUE))
            max_val <- pad_max(max(x_sums, na.rm = TRUE))
            min_val <- 0
        } else {
            # Categorical or no stack_by: bars dodged/ungrouped, max of raw values.
            # Values ggplot drops as non-finite (log of 0, say) are not plotted,
            # so they must not set the limits either.
            raw_values <- unlist(df[, data_col, drop = FALSE], use.names = FALSE)
            raw_values <- raw_values[is.finite(raw_values)]
            max_val <- suppressWarnings(pad_max(max(raw_values)))
            min_val <- suppressWarnings(min(raw_values))
        }

        if (!is.finite(min_val)) min_val <- 0
        if (!is.finite(max_val)) max_val <- 1

        return(list(min = min_val, max = max_val))
    } else {
        # --- Stacked grouping: sum y values per x group ---
        if (is.null(data_col_x) || length(data_col_x) != 1 || !data_col_x %in% names(df)) {
            return(NULL)
        }
        x_sums <- tapply(stacked_values(), df[[data_col_x]], function(v) sum(v, na.rm = TRUE))
        max_val <- pad_max(max(x_sums, na.rm = TRUE))
        min_val <- 0

        if (!is.finite(max_val)) max_val <- 1

        return(list(min = min_val, max = max_val))
    }
}


#' Value-axis limits for a bar plot, as plotthis draws it
#'
#' [plotthis::BarPlot()] never aggregates `y`, so how tall a bar is depends on
#' how the rows sharing an x are placed. With `group_by` and at most five groups,
#' its default `position = "auto"` dodges them, and every row is a bar of its
#' own. Otherwise (no groups, more than five, or `fill_by`) the rows sharing an x
#' stack, within each facet panel, positives upward and negatives downward. The
#' limits follow suit, so the axis fits the bars actually drawn rather than the
#' total of every group at an x.
#'
#' @param df Data frame.
#' @param x,y Names of the category and value columns.
#' @param group.by,fill.by,facet.by Names of the grouping, fill, and facet columns,
#'   or `NULL`/`""` for none. `fill.by` replaces `group.by`, as in the module.
#' @param axis_scale_factor Multiplier giving headroom above the tallest bar.
#'
#' @return `list(min = , max = )`, or `NULL` when the columns are missing or `y`
#'   is not numeric.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_bar_range
#' @keywords internal
.bar_range <- function(df, x, y, group.by = NULL, fill.by = NULL, facet.by = NULL, axis_scale_factor = 1) {
    if (is.null(df) || !nz_value(x) || !nz_value(y) || !all(c(x, y) %in% names(df)) || !is.numeric(df[[y]])) {
        return(NULL)
    }
    in_df <- function(col) nz_value(col) && col %in% names(df)
    pad_max <- function(v) v + abs(v) * (axis_scale_factor - 1)

    values <- df[[y]]
    keep <- is.finite(values)
    if (!any(keep)) {
        return(list(min = 0, max = 1))
    }

    # plotthis's position = "auto": dodged when grouped by at most five groups.
    dodged <- in_df(group.by) && !in_df(fill.by) &&
        nlevels(droplevels(as.factor(df[[group.by]][!is.na(df[[group.by]])]))) <= 5

    if (dodged) {
        heights <- values[keep]
    } else {
        # Stacked bars stack positives upward and negatives downward from zero,
        # so each side sums on its own.
        v <- values[keep]
        keys <- list(as.character(df[[x]][keep]), v >= 0)
        if (in_df(facet.by)) {
            keys <- c(keys, list(as.character(df[[facet.by]][keep])))
        }
        heights <- as.vector(tapply(v, keys, sum))
        heights <- heights[is.finite(heights)]
    }

    lo <- min(0, heights)
    hi <- pad_max(max(0, heights))
    if (!is.finite(hi) || hi <= lo) {
        hi <- lo + 1
    }
    list(min = lo, max = hi)
}


#' Stack several data columns into dittoViz's multi-variable long format
#'
#' Reproduces the reshape [dittoViz::yPlot()] performs internally when it is
#' given more than one `var`: the data frame is repeated once per column, the
#' column's values are gathered into `var.multi`, and the column's name is
#' recorded in `var.which`. Downstream code (e.g. statistics computed per
#' variable facet) can then work against the same rows the plot was built from.
#'
#' @param df Data frame. The data to reshape.
#' @param vars Character vector. Names of the columns to stack.
#'
#' @return A data frame with `length(vars)` times as many rows as `df`, plus the
#'   `var.multi` (values) and `var.which` (source column name) columns.
#'
#' @details No data adjustment is applied here; the column values are carried
#'   over as given. dittoViz adjusts each variable before stacking, so pass a
#'   frame already run through [as_plotted()] to get the values it plots.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_multivar_long_df
.multivar_long_df <- function(df, vars) {
    stacked <- lapply(vars, function(this.var) {
        out <- df
        out[["var.multi"]] <- df[[this.var]]
        out[["var.which"]] <- this.var
        out
    })

    long <- do.call(rbind, stacked)
    rownames(long) <- NULL
    long
}


#' Create an empty ggplot2 plot or plotly plot with input text
#'
#' This function creates an empty ggplot2 or plotly plot and places a user-provided text
#' string in the middle of the plot.
#'
#' @param text Character scalar to show in plot area.
#' @param plotly Boolean indicating whether to return a plotly object.
#' @return Either a ggplot object or a plotly object if `plotly = TRUE`.
#'
#' @importFrom ggplot2 theme_void geom_text theme margin ggplot aes
#' @importFrom plotly ggplotly layout
#'
#' @author Jared Andrews
#'
#' @seealso [ggplot2::geom_text()], [ggplot2::theme_void()]
#' @export
#' @examples
#' library(VizModules)
#' empty_plot("No data to display")
empty_plot <- function(text = NULL, plotly = FALSE) {
    if (length(text) > 1) {
        text <- paste(text, collapse = "\n")
    }

    plot <- ggplot() +
        theme_void() +
        theme(plot.margin = margin(1, 1, 1, 1, "cm")) +
        geom_text(aes(x = 0.5, y = 0.5, label = text),
            inherit.aes = FALSE, check_overlap = TRUE
        )

    if (plotly) {
        plot <- ggplotly(plot)
        plot <- plot |> layout(
            xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, showline = FALSE),
            yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, showline = FALSE),
            plot_bgcolor = "white",
            showlegend = FALSE,
            autosize = TRUE,
            margin = list(l = 0, r = 0, b = 0, t = 0)
        )
    }

    plot
}


#' Check if column inputs contain mixed data types
#'
#' This function validates that a vector of column names from a data frame contains
#' columns of only one data type category: either all numeric OR all categorical
#' (anything non-numeric: factor, character, logical, Date, ...). Returns `FALSE` for mixed
#' numeric + categorical columns.
#' Single columns always return `TRUE`. Used for Shiny plotting module input validation.
#'
#' @param inputs Character vector of column names to validate.
#' @param d Data frame containing the columns specified in `inputs`.
#'
#' @return Logical scalar: `TRUE` if all numeric OR all categorical (non-numeric);
#'   `FALSE` if mixed numeric + categorical/factor detected.
#'
#' @author Jacob Martin
#'
#' @examples
#' df <- data.frame(num1 = 1:3, num2 = 4:6, cat1 = letters[1:3], fac1 = factor(1:3))
#' is_pure_type(c("num1", "num2"), df) # TRUE (all numeric)
#' is_pure_type(c("cat1", "fac1"), df) # TRUE (all categorical)
#' is_pure_type(c("num1"), df) # TRUE (single)
#' is_pure_type(c("num1", "cat1"), df) # FALSE (mixed numeric + cat)
#'
#' @rdname is_pure_type
#' @export
is_pure_type <- function(inputs, d) {
    cols <- inputs[nzchar(inputs) & inputs %in% names(d)]

    # Single column or empty always pure
    if (length(cols) <= 1) {
        return(TRUE)
    }

    # Anything non-numeric (factor, character, logical, Date, ...) is plotted
    # as a category, so that is how it is classified here. Leaving those types
    # unclassified made the comparison below `logical(0)` and errored.
    types <- vapply(cols, function(nm) is.numeric(d[[nm]]), logical(1))
    all(types) || !any(types)
}


#' Add multi-axis traces to a plotly figure
#'
#' Appends scatter traces for each element of a multi-valued `x` or
#' multi-valued `y` vector to an existing plotly figure.
#' Handles data ordering, line/marker styling, and palette colouring.
#'
#' @param fig A plotly figure object to add traces to.
#' @param data A data.frame containing the plot data.
#' @param x Character vector of x-column name(s).
#' @param y Character vector of y-column name(s).
#' @param order.cols Character vector of column name(s) used to sort trace
#'   data before plotting.
#' @param plot.mode Character, plotly scatter mode (e.g. `"lines"`,
#'   `"markers"`, `"lines+markers"`).
#' @param line.type Character, plotly dash style for lines.
#' @param palette.selection Character vector of hex colours.
#' @param show.legend Logical, whether traces should appear in the legend.
#'   Default: `TRUE`.
#'
#' @return The modified plotly figure with added traces.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_add_multi_axis_traces
#' @keywords internal
.add_multi_axis_traces <- function(fig, data, x, y, order.cols, plot.mode,
                                   line.type, palette.selection,
                                   show.legend = TRUE) {
    .add_traces_for <- function(iter_var, fixed_var, is_x_multi) {
        for (i in seq_along(iter_var)) {
            trace_data <- data

            sort_column <- order.cols[1]
            if (!is.null(order.cols) && length(order.cols) >= i &&
                order.cols[i] %in% names(trace_data)) {
                sort_column <- order.cols[i]
            }
            if (!is.null(sort_column) && sort_column %in% names(trace_data)) {
                trace_data <- trace_data[order(trace_data[[sort_column]]), ]
            }

            if (is_x_multi) {
                xvals <- trace_data[[iter_var[i]]]
                yvals <- trace_data[[fixed_var[1]]]
                trace_name <- iter_var[i]
            } else {
                xvals <- trace_data[[fixed_var[1]]]
                yvals <- trace_data[[iter_var[i]]]
                trace_name <- iter_var[i]
            }

            trace_params <- list(
                x = xvals,
                y = yvals,
                type = "scatter",
                mode = plot.mode,
                name = trace_name,
                # Group by trace name so a legend click toggles the series in
                # every facet rather than only the one that owns the entry.
                legendgroup = trace_name,
                showlegend = show.legend
            )

            if (plot.mode %in% c("lines", "lines+markers")) {
                trace_params$line <- list(
                    dash = line.type,
                    color = palette.selection[i]
                )
            }
            if (plot.mode %in% c("markers", "lines+markers")) {
                trace_params$marker <- list(color = palette.selection[i])
            }

            fig <<- do.call(plotly::add_trace, c(list(fig), trace_params))
        }
    }

    if (length(x) > 1) {
        .add_traces_for(x, y, is_x_multi = TRUE)
    }
    if (length(y) > 1) {
        .add_traces_for(y, x, is_x_multi = FALSE)
    }

    fig
}


