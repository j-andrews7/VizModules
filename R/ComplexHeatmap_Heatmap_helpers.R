#' Resolve a single row/column split method + count into Heatmap() arguments
#'
#' [ComplexHeatmap::Heatmap()] exposes two independent ways to split rows (or
#' columns) into groups — `row_km` (k-means) and `row_split` (an integer cuts
#' the hierarchical clustering dendrogram into that many groups) — and errors
#' if both are supplied as more than their "no split" defaults at once
#' (`"You can not perform k-means clustering since you have already
#' specified a clustering object."`). This resolves the module's single
#' `*_split_by`/`*_split_n` UI pair into exactly one of `row_km`/`row_split`
#' (never both), so that error can't occur.
#'
#' Both methods are clamped to the matrix dimension, but not to the same bound.
#' k-means is clamped to *one less* than the dimension, not equal to it —
#' confirmed empirically that `row_km == nrow(mat)` reliably errors
#' (`"number of cluster centres must lie between 1 and nrow(x)"`) 
#' while `row_km == nrow(mat) - 1` does not. A bare
#' hierarchical `row_split` count, by contrast, tolerates being equal to (or
#' even greater than) the dimension without erroring.
#'
#' @param method One of `"None"`, `"K-means"`, or `"Hierarchical"` (case-sensitive,
#'   matching the UI's `viz_select_input` choices). Anything else is treated as
#'   `"None"`.
#' @param n The requested number of groups. `NA`/`NULL`/non-numeric or `< 2` is
#'   treated as "no split" regardless of `method`.
#' @param dim_n The size of the dimension being split (`nrow(mat)` or
#'   `ncol(mat)`), used to clamp `n`.
#'
#' @return A list with `km` (integer, `1L` when unused) and `split` (integer or
#'   `NULL`), suitable for `Heatmap(row_km = res$km, row_split = res$split, ...)`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_resolve_split
#' @keywords internal
.heatmap_resolve_split <- function(method, n, dim_n) {
    n <- suppressWarnings(as.integer(n))
    if (is.null(method) || is.na(method) || !method %in% c("K-means", "Hierarchical") ||
        length(n) == 0 || is.na(n) || n < 2) {
        return(list(km = 1L, split = NULL))
    }

    dim_n <- as.integer(dim_n)

    if (method == "K-means") {
        n <- min(n, dim_n - 1L)
        if (n < 2) return(list(km = 1L, split = NULL))
        list(km = n, split = NULL)
    } else {
        list(km = 1L, split = min(n, dim_n))
    }
}


#' The heatmap module's default low/mid/high value colors
#'
#' Blue/white/red, used to seed the "Low Color"/"Mid Color"/"High Color"
#' pickers (the source of truth for [circlize::colorRamp2()]) and the reset
#' handler. A single constant rather than three repeated hex literals.
#'
#' @return A length-3 character vector: low, mid, high.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_default_colors
#' @keywords internal
.heatmap_default_colors <- function() {
    c("#2166AC", "#F7F7F7", "#B2182B")
}


#' Z-score a matrix by row or column
#'
#' [base::scale()] z-scores the *columns* of a matrix. This applies it either
#' way, and to a zero-variance row/column (constant values, sd 0) — which
#' `scale()` turns into `NaN` for every entry via a `0/0` division, not just
#' where the input was already missing — pins the result to `0` (no deviation
#' from the mean) instead. Missing (`NA`) input cells are left `NA`
#' either way, so [ComplexHeatmap::Heatmap()]'s `na_col` still renders them as
#' missing rather than as a z-score of zero.
#'
#' @param mat A numeric matrix.
#' @param scale One of `"none"`, `"row"`, or `"column"`.
#'
#' @return The (possibly) scaled matrix, with the same dimnames as `mat`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_scale_matrix
#' @keywords internal
.heatmap_scale_matrix <- function(mat, scale = c("none", "row", "column")) {
    scale <- match.arg(scale)
    if (scale == "none") {
        return(mat)
    }

    was_na <- is.na(mat)
    m <- if (scale == "row") t(base::scale(t(mat))) else base::scale(mat)
    attr(m, "scaled:center") <- NULL
    attr(m, "scaled:scale") <- NULL

    m[is.nan(m)] <- 0
    m[was_na] <- NA
    dimnames(m) <- dimnames(mat)
    m
}


#' Normalize the ComplexHeatmap module's `data` argument
#'
#' `data()` accepts either a plain data frame (the module's original,
#' single-table behavior: the matrix and any row-annotation columns all live
#' in one data frame) or `list(matrix = <data.frame>, column_annotations =
#' <data.frame>)` (adds a companion per-sample metadata table, keyed by a
#' column matching the matrix's selected column names, for column
#' annotations). This normalizes either shape to the list form.
#'
#' Deliberately does not use the shared [.require_data_frame()] — that helper
#' coerces its input straight to one data frame via [as.data.frame()], which
#' would mangle the two-table list shape.
#'
#' This is a plain function (no [shiny::validate()]/[shiny::req()]) so it can
#' be called both from the server (inside a `reactive()`, where the caller is
#' expected to have already validated `d`'s shape) and from the UI function
#' (a plain, non-reactive call at UI-build time).
#'
#' @param d Either a data frame, or a list with a `matrix` element (and
#'   optionally a `column_annotations` element).
#'
#' @return A list with `matrix` (data frame) and `column_annotations` (data
#'   frame or `NULL`).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_resolve_data
#' @keywords internal
.heatmap_resolve_data <- function(d) {
    if (is.data.frame(d)) {
        return(list(matrix = d, column_annotations = NULL))
    }
    list(matrix = d$matrix, column_annotations = d[["column_annotations"]])
}


#' Id for one annotation row's dynamically-rendered color widget(s)
#'
#' The "Annotations" tab renders a color-control widget per `multiDynamicInput`
#' row (Low/Mid/High colour pickers for a numeric column, a [multiColorPicker()]
#' for a categorical one) in a `renderUI()` below the row list — see
#' `ComplexHeatmap_HeatmapServer()`. This derives that widget's (unnamespaced)
#' input id from the row's own name (`"row1"`, `"row2"`, ...), used identically
#' by the `renderUI` that builds the widget and by the code that later reads its
#' value back, so the two can never drift apart.
#'
#' @param prefix `"row_ann_color"` or `"column_ann_color"`.
#' @param row_name The `multiDynamicInput` row's name (an element of
#'   `names(input$row_annotations)`/`names(input$column_annotations)`).
#'
#' @return A single string, safe to use as an HTML id.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_annotation_widget_id
#' @keywords internal
.heatmap_annotation_widget_id <- function(prefix, row_name) {
    paste0(prefix, "_", gsub("[^A-Za-z0-9_]", "_", row_name))
}


#' Summarize what color widget(s) one axis's annotation rows need
#'
#' A pure, `input`-agnostic reduction of `input$row_annotations`/
#' `input$column_annotations` plus the source data frame down to just what
#' determines a row's color widget's *shape*: its column name, whether it's
#' numeric, and (if not) its sorted distinct levels. Used to decide whether
#' the dynamically-rendered color widgets need to be rebuilt at all — see
#' `ComplexHeatmap_HeatmapServer()`, where this is wrapped in a
#' [shiny::reactiveVal()] that only updates (and so only triggers a
#' `renderUI()` rebuild) when the spec actually changes. Without that, a
#' `renderUI()` keyed directly on the raw data frame would rebuild — and
#' reset — every color widget whenever the data changes at all (e.g. an
#' unrelated "Data Table" filter tweak), even when every annotated column's
#' own values/levels are untouched.
#'
#' @param rows `input$row_annotations` or `input$column_annotations`, or
#'   `NULL`.
#' @param df The data frame to inspect each row's chosen column in
#'   (`matrix_data()`/`column_data()`), or `NULL`.
#'
#' @return A named list (row name -> `list(column, numeric, levels)`,
#'   `levels` present only when `numeric` is `FALSE`), omitting rows with no
#'   usable column picked. Never `NULL` (an empty list when there's nothing to
#'   show).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_annotation_spec
#' @keywords internal
.heatmap_annotation_spec <- function(rows, df) {
    if (is.null(rows) || length(rows) == 0 || is.null(df)) {
        return(list())
    }

    out <- lapply(rows, function(r) {
        col <- r$column
        if (is.null(col) || !nzchar(col) || !col %in% names(df)) {
            return(NULL)
        }
        values <- df[[col]]
        if (is.numeric(values)) {
            list(column = col, numeric = TRUE)
        } else {
            levels <- sort(unique(as.character(values[!is.na(values)])))
            if (length(levels) == 0) {
                return(NULL)
            }
            list(column = col, numeric = FALSE, levels = levels)
        }
    })
    names(out) <- names(rows)
    Filter(Negate(is.null), out)
}


#' Build one annotation track's color mapping
#'
#' Numeric values get a continuous gradient from `low_color`/`mid_color`/
#' `high_color`, mirroring the main value palette's `col_fun`; anything else is
#' treated as categorical and uses `discrete_colors` (a named vector, one hex
#' color per level, as returned by [multiColorPicker()]) directly.
#'
#' @param values The annotation column's values, aligned to the matrix's rows
#'   or columns.
#' @param low_color,mid_color,high_color Colors for a numeric `values`
#'   (ignored otherwise).
#' @param discrete_colors A named character vector (name = level) for a
#'   non-numeric `values` (ignored otherwise).
#'
#' @return A [circlize::colorRamp2()] function for numeric `values`, a named
#'   character vector (one color per level) otherwise, or `NULL` when there's
#'   nothing usable to build a mapping from (no non-`NA` values, or the needed
#'   colors weren't supplied).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_annotation_col
#' @keywords internal
.heatmap_annotation_col <- function(values, low_color = NULL, mid_color = NULL, high_color = NULL,
                                    discrete_colors = NULL) {
    if (is.numeric(values)) {
        if (is.null(low_color) || is.null(mid_color) || is.null(high_color)) {
            return(NULL)
        }
        rng <- suppressWarnings(range(values, na.rm = TRUE))
        if (!all(is.finite(rng))) {
            return(NULL)
        }
        if (rng[1] == rng[2]) {
            rng <- rng + c(-0.5, 0.5)
        }
        circlize::colorRamp2(c(rng[1], mean(rng), rng[2]), c(low_color, mid_color, high_color))
    } else {
        levels <- sort(unique(as.character(values[!is.na(values)])))
        if (length(levels) == 0 || is.null(discrete_colors) || length(discrete_colors) == 0) {
            return(NULL)
        }
        # discrete_colors was captured when the multiColorPicker was last built;
        # a level that has since appeared in the data (or disappeared) falls
        # back to neutral grey rather than erroring or silently dropping it.
        out <- unname(discrete_colors[levels])
        out[is.na(out)] <- "#999999"
        stats::setNames(out, levels)
    }
}


#' Build a row or column HeatmapAnnotation from `multiDynamicInput` rows
#'
#' @param rows `input$row_annotations` or `input$column_annotations` — a named
#'   list of rows (each a list with `column` and `side` fields), or `NULL`.
#'   Already filtered to the rows for one `side` value by the caller (see
#'   `ComplexHeatmap_HeatmapServer()`) — this builds one `HeatmapAnnotation`,
#'   not per-side splitting.
#' @param source_df The data frame to pull annotation values from: the
#'   matrix's own data frame for row annotations (its row order already
#'   matches the matrix 1:1, since `heatmap_matrix()` never reorders/filters
#'   rows), or the `column_annotations` table for column annotations.
#' @param key_values `rownames(mat)`/`colnames(mat)`, in matrix order.
#' @param key_col `NULL` for row annotations (see `source_df`, above); the
#'   name of the key column in `source_df` for column annotations, matched
#'   against `key_values`.
#' @param which `"row"` or `"column"`.
#' @param color_lookup A function `function(row_name, column, values)`
#'   returning that row's color mapping (as from [.heatmap_annotation_col()]),
#'   or `NULL` to skip it. Supplied by the caller so this stays a pure,
#'   `input`-agnostic function — see `ComplexHeatmap_HeatmapServer()` for the
#'   closure that resolves each row's dynamically-rendered color widget(s) via
#'   [.heatmap_annotation_widget_id()].
#'
#' @return A [ComplexHeatmap::rowAnnotation()]/[ComplexHeatmap::columnAnnotation()]
#'   object, or `NULL` if there are no usable rows.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_build_annotation
#' @keywords internal
.heatmap_build_annotation <- function(rows, source_df, key_values, key_col = NULL,
                                      which = c("row", "column"), color_lookup) {
    which <- match.arg(which)
    if (is.null(rows) || length(rows) == 0 || is.null(source_df) || length(key_values) == 0) {
        return(NULL)
    }

    values_list <- list()
    col_list <- list()
    for (row_name in names(rows)) {
        r <- rows[[row_name]]
        col <- r$column
        if (is.null(col) || !nzchar(col) || !col %in% names(source_df) || col %in% names(values_list)) {
            next
        }

        values <- if (is.null(key_col)) {
            source_df[[col]]
        } else {
            source_df[[col]][match(key_values, source_df[[key_col]])]
        }
        if (length(values) != length(key_values)) {
            next
        }

        mapping <- color_lookup(row_name, col, values)
        if (is.null(mapping)) {
            next
        }

        values_list[[col]] <- values
        col_list[[col]] <- mapping
    }

    if (length(values_list) == 0) {
        return(NULL)
    }

    ann_df <- as.data.frame(values_list, stringsAsFactors = FALSE, check.names = FALSE)
    rownames(ann_df) <- NULL

    if (which == "row") {
        ComplexHeatmap::rowAnnotation(df = ann_df, col = col_list)
    } else {
        ComplexHeatmap::columnAnnotation(df = ann_df, col = col_list)
    }
}
