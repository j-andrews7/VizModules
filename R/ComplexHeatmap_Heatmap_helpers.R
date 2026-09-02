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
#' A third method, `"Annotation"`, splits on the values of one or more
#' annotation columns instead of on a derived grouping, letting rows or columns
#' be grouped by what they *are* (pathway, condition) rather than by how they
#' cluster. It also makes drawing cheap when no clustering is wanted: the
#' grouping needs no distance matrix. Several columns give nested slices, one
#' per observed combination. It routes through `row_split` like the
#' hierarchical method, so the never-both invariant above still holds.
#'
#' @param method One of `"None"`, `"K-means"`, `"Hierarchical"`, or
#'   `"Annotation"` (case-sensitive, matching the UI's `viz_select_input`
#'   choices). Anything else is treated as `"None"`.
#' @param n The requested number of groups. `NA`/`NULL`/non-numeric or `< 2` is
#'   treated as "no split" regardless of `method`. Ignored for `"Annotation"`,
#'   whose group count comes from the data.
#' @param dim_n The size of the dimension being split (`nrow(mat)` or
#'   `ncol(mat)`), used to clamp `n`.
#' @param split_values For `method = "Annotation"`, a data frame of annotation
#'   values with `dim_n` rows (one column per split column). Ignored otherwise.
#'   A grouping that puts every row in its own slice conveys nothing and costs
#'   a slice label per row, so it falls back to no split.
#'
#' @return A list with `km` (integer, `1L` when unused) and `split` (integer or
#'   `NULL`), suitable for `Heatmap(row_km = res$km, row_split = res$split, ...)`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_resolve_split
#' @keywords internal
.heatmap_resolve_split <- function(method, n, dim_n, split_values = NULL) {
    dim_n <- as.integer(dim_n)
    no_split <- list(km = 1L, split = NULL)

    if (identical(method, "Annotation")) {
        if (is.null(split_values)) {
            return(no_split)
        }
        sv <- as.data.frame(split_values, stringsAsFactors = FALSE, check.names = FALSE)
        if (ncol(sv) == 0 || nrow(sv) != dim_n || dim_n < 2) {
            return(no_split)
        }
        # An NA would otherwise drop out of the slice labelling entirely; make
        # it an explicit group so those rows stay visible and accounted for.
        sv[] <- lapply(sv, function(x) {
            x <- as.character(x)
            x[is.na(x)] <- "NA"
            x
        })
        n_groups <- nrow(unique(sv))
        if (n_groups < 2 || n_groups >= dim_n) {
            return(no_split)
        }
        return(list(km = 1L, split = sv))
    }

    n <- suppressWarnings(as.integer(n))
    if (is.null(method) || is.na(method) || !method %in% c("K-means", "Hierarchical") ||
        length(n) == 0 || is.na(n) || n < 2) {
        return(no_split)
    }

    if (method == "K-means") {
        n <- min(n, dim_n - 1L)
        if (n < 2) return(no_split)
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


#' Extract one annotation column, aligned to a matrix axis
#'
#' Row and column annotations reach their values by different routes, and the
#' difference is easy to get subtly wrong: row-annotation values sit in the
#' matrix data frame itself and line up **positionally** with the matrix rows,
#' while column-annotation values live in a separate per-sample table and are
#' matched **by value** through a key column. Both
#' [.heatmap_build_annotation()] and the "Annotation" split method need the
#' same vector, so they share this rather than each re-deriving it.
#'
#' @param source_df The data frame holding the annotation column: the matrix
#'   data frame for rows, the `column_annotations` table for columns.
#' @param col Name of the column to extract.
#' @param key_values `rownames(mat)` / `colnames(mat)`, in matrix order.
#' @param key_col `NULL` for row annotations (positional alignment); the name
#'   of the key column in `source_df` for column annotations (matched against
#'   `key_values`).
#'
#' @return A vector of `length(key_values)` aligned to the matrix axis, or
#'   `NULL` when the column is unusable or does not line up.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_annotation_values
#' @keywords internal
.heatmap_annotation_values <- function(source_df, col, key_values, key_col = NULL) {
    if (is.null(source_df) || is.null(col) || !nzchar(col) || !col %in% names(source_df)) {
        return(NULL)
    }
    if (is.null(key_col)) {
        values <- source_df[[col]]
    } else {
        if (!nzchar(key_col) || !key_col %in% names(source_df)) {
            return(NULL)
        }
        values <- source_df[[col]][match(key_values, source_df[[key_col]])]
    }
    if (length(values) != length(key_values)) {
        return(NULL)
    }
    values
}


#' Build the frame a column filter expression is evaluated against
#'
#' Matrix columns are sample *names*, not rows of a data frame, so a column
#' filter has nothing to evaluate against on its own. This assembles one: a row
#' per selected matrix column, in matrix order, carrying a synthetic `column`
#' field with the matrix column name plus every field of the per-sample
#' metadata table joined through `key_col`.
#'
#' That means `column %in% c("Healthy_1", "Healthy_2")` works with no metadata
#' at all, while `condition == "Disease" & batch == "B1"` works as soon as a
#' `column_annotations` table is supplied. If the metadata already has a field
#' literally named `column`, the real one wins and no synthetic is added —
#' shadowing a user's own column would be the more surprising behaviour.
#'
#' @param column_data The `column_annotations` data frame, or `NULL`.
#' @param key_col Name of the field in `column_data` holding the matrix column
#'   names. Ignored when `column_data` is `NULL` or the name is not present.
#' @param matrix_cols Character vector of the currently selected matrix columns.
#'
#' @return A data frame with one row per entry of `matrix_cols`, in the same
#'   order. Never `NULL`; a zero-column `matrix_cols` gives a zero-row frame.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_column_meta
#' @keywords internal
.heatmap_column_meta <- function(column_data, key_col, matrix_cols) {
    matrix_cols <- as.character(matrix_cols %||% character(0))

    usable <- !is.null(column_data) && is.data.frame(column_data) &&
        !is.null(key_col) && length(key_col) == 1L && !is.na(key_col) &&
        nzchar(key_col) && key_col %in% names(column_data)

    if (!usable) {
        return(data.frame(column = matrix_cols, stringsAsFactors = FALSE))
    }

    idx <- match(matrix_cols, as.character(column_data[[key_col]]))
    meta <- column_data[idx, , drop = FALSE]
    rownames(meta) <- NULL

    # Only synthesise `column` when the metadata has not claimed the name.
    if (!"column" %in% names(meta)) {
        meta <- cbind(data.frame(column = matrix_cols, stringsAsFactors = FALSE), meta)
    }
    meta
}


#' Resolve a user filter expression into a keep-mask
#'
#' Thin wrapper over [safe_eval_filter()] that turns its result into something
#' a caller can act on without guessing. `safe_eval_filter()` returns `NULL`
#' both for "you typed nothing" and for "you typed something disallowed", which
#' must not collapse into the same outcome: the first should keep every row,
#' the second should surface an error rather than silently plotting unfiltered
#' data.
#'
#' `NA` in the result counts as `FALSE` — a row whose filter value is unknown is
#' not a row the user asked to see.
#'
#' @param expr_text The user-typed expression. `NULL`/blank means "no filter".
#' @param df The data frame to evaluate against.
#' @param n_expected Expected length of the result, i.e. `nrow(df)`.
#'
#' @return A list with `keep` (a logical vector of length `n_expected`, or
#'   `NULL` when the expression was invalid) and `status`, one of `"empty"`,
#'   `"ok"`, or `"invalid"`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_heatmap_apply_filter
#' @keywords internal
.heatmap_apply_filter <- function(expr_text, df, n_expected) {
    keep_all <- list(keep = rep(TRUE, n_expected), status = "empty")
    if (is.null(expr_text) || length(expr_text) != 1L || is.na(expr_text) ||
        !nzchar(trimws(expr_text))) {
        return(keep_all)
    }

    # safe_eval_filter() warns on a rejected expression; the status carries
    # that outcome to the caller, so the warning itself is noise here.
    res <- withCallingHandlers(
        safe_eval_filter(expr_text, df),
        warning = function(w) invokeRestart("muffleWarning")
    )

    if (is.null(res) || !is.logical(res) || length(res) != n_expected) {
        return(list(keep = NULL, status = "invalid"))
    }

    res[is.na(res)] <- FALSE
    list(keep = res, status = "ok")
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
#' Each row may also carry `label_side` and `label_size`, controlling where that
#' track's own name is drawn and at what font size. `annotation_name_side` and
#' `annotation_name_gp` are both vectorised per track by ComplexHeatmap, so these
#' are collected in lockstep with the tracks actually added — a row skipped for an
#' unusable or duplicate column must not shift the labels of the rows after it.
#' Valid sides differ by axis: a row annotation's name goes `"top"`/`"bottom"`, a
#' column annotation's `"left"`/`"right"`; the wrong one is an error from
#' ComplexHeatmap, so anything unrecognised falls back to that axis's default.
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

    # A row annotation's name is drawn above or below it, a column annotation's
    # to one side; passing the other axis's value is an error from ComplexHeatmap.
    valid_sides <- if (which == "row") c("top", "bottom") else c("left", "right")
    default_side <- if (which == "row") "bottom" else "right"

    values_list <- list()
    col_list <- list()
    name_sides <- character(0)
    name_sizes <- numeric(0)
    for (row_name in names(rows)) {
        r <- rows[[row_name]]
        col <- r$column
        if (is.null(col) || !nzchar(col) || !col %in% names(source_df) || col %in% names(values_list)) {
            next
        }

        values <- .heatmap_annotation_values(source_df, col, key_values, key_col)
        if (is.null(values)) {
            next
        }

        mapping <- color_lookup(row_name, col, values)
        if (is.null(mapping)) {
            next
        }

        values_list[[col]] <- values
        col_list[[col]] <- mapping

        # Appended only alongside a track that was actually added, so a skipped
        # row cannot shift every later track's label.
        side <- tolower(as.character(r$label_side %||% ""))
        name_sides <- c(name_sides, if (length(side) == 1L && side %in% valid_sides) side else default_side)

        size <- suppressWarnings(as.numeric(r$label_size %||% NA))
        name_sizes <- c(name_sizes, if (length(size) == 1L && !is.na(size) && size > 0) size else 10)
    }

    if (length(values_list) == 0) {
        return(NULL)
    }

    ann_df <- as.data.frame(values_list, stringsAsFactors = FALSE, check.names = FALSE)
    rownames(ann_df) <- NULL

    args <- list(
        df = ann_df,
        col = col_list,
        annotation_name_side = name_sides,
        annotation_name_gp = grid::gpar(fontsize = name_sizes)
    )

    if (which == "row") {
        do.call(ComplexHeatmap::rowAnnotation, args)
    } else {
        do.call(ComplexHeatmap::columnAnnotation, args)
    }
}
