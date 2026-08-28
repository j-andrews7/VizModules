# Tests for the ComplexHeatmap module's internal helpers (R/ComplexHeatmap_Heatmap_helpers.R).
# Heatmap()-building tests are gated on the Bioconductor deps being installed, matching the
# module's own requireNamespace() guards; the pure helpers are tested unconditionally.

# ---- .heatmap_resolve_split() ----------------------------------------------------------------

test_that(".heatmap_resolve_split returns no-op km/split for 'None' or invalid input", {
    expect_equal(.heatmap_resolve_split("None", 3, 10), list(km = 1L, split = NULL))
    expect_equal(.heatmap_resolve_split("K-means", NA, 10), list(km = 1L, split = NULL))
    expect_equal(.heatmap_resolve_split("K-means", 1, 10), list(km = 1L, split = NULL))
    expect_equal(.heatmap_resolve_split(NA, 3, 10), list(km = 1L, split = NULL))
    expect_equal(.heatmap_resolve_split("Bogus", 3, 10), list(km = 1L, split = NULL))
})

test_that(".heatmap_resolve_split never returns both km and split set", {
    km_res <- .heatmap_resolve_split("K-means", 3, 10)
    expect_equal(km_res$km, 3L)
    expect_null(km_res$split)

    split_res <- .heatmap_resolve_split("Hierarchical", 3, 10)
    expect_equal(split_res$km, 1L)
    expect_equal(split_res$split, 3L)
})

test_that(".heatmap_resolve_split clamps k-means one below the dimension, not equal to it", {
    # Empirically confirmed against real ComplexHeatmap: row_km == nrow(mat) errors
    # ("number of cluster centres must lie between 1 and nrow(x)"), row_km == nrow(mat) - 1 does not.
    expect_equal(.heatmap_resolve_split("K-means", 32, 32)$km, 31L)
    expect_equal(.heatmap_resolve_split("K-means", 999, 32)$km, 31L)
    expect_equal(.heatmap_resolve_split("K-means", 31, 32)$km, 31L)
})

test_that(".heatmap_resolve_split clamps hierarchical splits to the dimension (inclusive)", {
    expect_equal(.heatmap_resolve_split("Hierarchical", 32, 32)$split, 32L)
    expect_equal(.heatmap_resolve_split("Hierarchical", 999, 32)$split, 32L)
})

test_that(".heatmap_resolve_split falls back to no-op when k-means clamps below 2", {
    expect_equal(.heatmap_resolve_split("K-means", 5, 2), list(km = 1L, split = NULL))
})

# ---- .heatmap_scale_matrix() ------------------------------------------------------------------

test_that(".heatmap_scale_matrix('none') returns the matrix unchanged", {
    mat <- matrix(1:6, nrow = 2)
    expect_identical(.heatmap_scale_matrix(mat, "none"), mat)
})

test_that(".heatmap_scale_matrix z-scores rows/columns correctly", {
    mat <- matrix(c(1, 2, 3, 4, 5, 6), nrow = 2, byrow = TRUE)
    rownames(mat) <- c("r1", "r2")
    colnames(mat) <- c("c1", "c2", "c3")

    row_scaled <- .heatmap_scale_matrix(mat, "row")
    expect_equal(unname(row_scaled["r1", ]), as.numeric(scale(mat["r1", ])), tolerance = 1e-8)
    expect_equal(unname(row_scaled["r2", ]), as.numeric(scale(mat["r2", ])), tolerance = 1e-8)

    col_scaled <- .heatmap_scale_matrix(mat, "column")
    expected_col <- scale(mat)
    attr(expected_col, "scaled:center") <- NULL
    attr(expected_col, "scaled:scale") <- NULL
    expect_equal(col_scaled, expected_col, tolerance = 1e-8)

    expect_identical(dimnames(row_scaled), dimnames(mat))
    expect_identical(dimnames(col_scaled), dimnames(mat))
})

test_that(".heatmap_scale_matrix preserves genuine NA but pins zero-variance rows/columns to 0", {
    mat <- matrix(c(5, 5, 5, 1, 2, 3, 5, 5, 5), nrow = 3, byrow = TRUE)
    scaled <- .heatmap_scale_matrix(mat, "row")
    expect_equal(scaled[1, ], c(0, 0, 0))
    expect_equal(scaled[3, ], c(0, 0, 0))
    expect_false(anyNA(scaled))

    mat_na <- matrix(c(1, NA, 3, 4, 5, 6), nrow = 2, byrow = TRUE)
    scaled_na <- .heatmap_scale_matrix(mat_na, "row")
    expect_true(is.na(scaled_na[1, 2]))
    expect_false(anyNA(scaled_na[2, ]))
})

# ---- .heatmap_resolve_data() ------------------------------------------------------------------

test_that(".heatmap_resolve_data normalizes a plain data frame", {
    df <- data.frame(x = 1:3, y = 4:6)
    res <- .heatmap_resolve_data(df)
    expect_identical(res$matrix, df)
    expect_null(res$column_annotations)
})

test_that(".heatmap_resolve_data passes through the list(matrix=, column_annotations=) shape", {
    mat_df <- data.frame(x = 1:3)
    col_df <- data.frame(sample = "s1", condition = "A")
    res <- .heatmap_resolve_data(list(matrix = mat_df, column_annotations = col_df))
    expect_identical(res$matrix, mat_df)
    expect_identical(res$column_annotations, col_df)
})

# ---- .heatmap_default_colors() -------------------------------------------------------------

test_that(".heatmap_default_colors returns the blue/white/red triple", {
    expect_equal(.heatmap_default_colors(), c("#2166AC", "#F7F7F7", "#B2182B"))
})

# ---- .heatmap_annotation_widget_id() -----------------------------------------------------------

test_that(".heatmap_annotation_widget_id sanitizes the row name into a safe HTML id", {
    expect_equal(.heatmap_annotation_widget_id("row_ann_color", "row1"), "row_ann_color_row1")
    expect_equal(.heatmap_annotation_widget_id("row_ann_color", "row annotations1"), "row_ann_color_row_annotations1")
})

# ---- .heatmap_annotation_spec() --------------------------------------------------------------
# This drives whether the dynamically-rendered color widgets get rebuilt (and
# so reset) -- it must stay identical across a data change that doesn't
# actually alter an annotated column's type/levels, e.g. a "Data Table" filter
# that keeps every group, and must differ when it genuinely does.

test_that(".heatmap_annotation_spec is stable across a row-filter that keeps every level", {
    df_full <- data.frame(
        gene = paste0("g", 1:9),
        pathway = rep(c("A", "B", "C"), each = 3),
        score = 1:9
    )
    df_filtered <- df_full[c(1, 4, 7), ]  # one row per level -- still all 3 levels

    rows <- list(r1 = list(column = "pathway"))
    expect_identical(.heatmap_annotation_spec(rows, df_full), .heatmap_annotation_spec(rows, df_filtered))
})

test_that(".heatmap_annotation_spec changes when a level actually disappears", {
    df <- data.frame(pathway = rep(c("A", "B", "C"), each = 3))
    rows <- list(r1 = list(column = "pathway"))
    full_spec <- .heatmap_annotation_spec(rows, df)
    dropped_spec <- .heatmap_annotation_spec(rows, df[df$pathway != "C", , drop = FALSE])
    expect_false(identical(full_spec, dropped_spec))
})

test_that(".heatmap_annotation_spec for a numeric column ignores the actual values (row count only matters via existence)", {
    df <- data.frame(score = c(1, 2, 3, 4, 5))
    rows <- list(r1 = list(column = "score"))
    spec1 <- .heatmap_annotation_spec(rows, df)
    spec2 <- .heatmap_annotation_spec(rows, df[1:2, , drop = FALSE])
    expect_identical(spec1, spec2)
    expect_true(spec1$r1$numeric)
})

test_that(".heatmap_annotation_spec changes when a row's column selection changes", {
    df <- data.frame(pathway = c("A", "B"), score = c(1, 2))
    spec_pathway <- .heatmap_annotation_spec(list(r1 = list(column = "pathway")), df)
    spec_score <- .heatmap_annotation_spec(list(r1 = list(column = "score")), df)
    expect_false(identical(spec_pathway, spec_score))
})

test_that(".heatmap_annotation_spec returns an empty list, not NULL, for empty/invalid input", {
    expect_length(.heatmap_annotation_spec(NULL, data.frame(x = 1)), 0)
    expect_length(.heatmap_annotation_spec(list(), data.frame(x = 1)), 0)
    expect_length(.heatmap_annotation_spec(list(r1 = list(column = "nope")), data.frame(x = 1)), 0)
    expect_length(.heatmap_annotation_spec(list(r1 = list(column = "x")), NULL), 0)
})

# ---- .heatmap_annotation_col() ----------------------------------------------------------------

test_that(".heatmap_annotation_col builds a discrete mapping from explicit discrete_colors", {
    discrete <- c(A = "#FF0000", B = "#00FF00")
    mapping <- .heatmap_annotation_col(c("A", "B", "A", NA), discrete_colors = discrete)
    expect_type(mapping, "character")
    expect_setequal(names(mapping), c("A", "B"))
    expect_equal(unname(mapping[c("A", "B")]), c("#FF0000", "#00FF00"))
})

test_that(".heatmap_annotation_col falls back to grey for a level missing from discrete_colors", {
    mapping <- .heatmap_annotation_col(c("A", "B"), discrete_colors = c(A = "#FF0000"))
    expect_false(anyNA(mapping))
    expect_equal(unname(mapping["B"]), "#999999")
})

test_that(".heatmap_annotation_col builds a continuous mapping for numeric values", {
    mapping <- .heatmap_annotation_col(c(1, 2, 3, NA), low_color = "blue", mid_color = "white", high_color = "red")
    expect_true(is.function(mapping))
})

test_that(".heatmap_annotation_col handles a degenerate (constant) numeric range", {
    mapping <- .heatmap_annotation_col(c(5, 5, 5), low_color = "blue", mid_color = "white", high_color = "red")
    expect_true(is.function(mapping))
})

test_that(".heatmap_annotation_col returns NULL when there are no usable values or colors", {
    expect_null(.heatmap_annotation_col(c(NA_real_, NA_real_), low_color = "blue", mid_color = "white", high_color = "red"))
    expect_null(.heatmap_annotation_col(c(NA_character_, NA_character_), discrete_colors = c(A = "red")))
    expect_null(.heatmap_annotation_col(c(1, 2, 3)))  # numeric but no colors supplied
    expect_null(.heatmap_annotation_col(c("A", "B")))  # categorical but no colors supplied
})

# ---- .heatmap_build_annotation() --------------------------------------------------------------

# A color_lookup stand-in used across these tests, mirroring the closure built
# in ComplexHeatmap_HeatmapServer() (numeric -> low/mid/high, else -> a fixed
# discrete mapping) without needing a live Shiny `input`.
.test_color_lookup <- function(row_name, col, values) {
    if (is.numeric(values)) {
        .heatmap_annotation_col(values, low_color = "blue", mid_color = "white", high_color = "red")
    } else {
        levels <- unique(as.character(values[!is.na(values)]))
        .heatmap_annotation_col(values, discrete_colors = stats::setNames(
            grDevices::rainbow(length(levels)), levels
        ))
    }
}

test_that(".heatmap_build_annotation returns NULL for empty/invalid input without erroring", {
    df <- data.frame(gene = c("g1", "g2"), pathway = c("A", "B"))
    expect_null(.heatmap_build_annotation(NULL, df, c("g1", "g2"), NULL, "row", .test_color_lookup))
    expect_null(.heatmap_build_annotation(list(), df, c("g1", "g2"), NULL, "row", .test_color_lookup))
    expect_null(.heatmap_build_annotation(
        list(r = list(column = "nope", side = "Left")), df, c("g1", "g2"), NULL, "row", .test_color_lookup
    ))
    expect_null(.heatmap_build_annotation(list(r = list(column = "pathway", side = "Left")), NULL, c("g1", "g2"), NULL, "row", .test_color_lookup))
})

test_that(".heatmap_build_annotation builds a rowAnnotation/columnAnnotation object", {
    skip_if_not_installed("ComplexHeatmap")
    skip_if_not_installed("circlize")

    row_df <- data.frame(gene = c("g1", "g2", "g3"), pathway = c("A", "B", "A"), score = c(1, 2, 3))
    row_ann <- .heatmap_build_annotation(
        list(r = list(column = "pathway", side = "Left"), s = list(column = "score", side = "Left")),
        row_df, c("g1", "g2", "g3"), key_col = NULL, which = "row", color_lookup = .test_color_lookup
    )
    expect_s4_class(row_ann, "HeatmapAnnotation")

    col_df <- data.frame(sample = c("s1", "s2"), condition = c("Healthy", "Disease"))
    col_ann <- .heatmap_build_annotation(
        list(c = list(column = "condition", side = "Top")),
        col_df, c("s2", "s1"), key_col = "sample", which = "column", color_lookup = .test_color_lookup
    )
    expect_s4_class(col_ann, "HeatmapAnnotation")

    mat <- matrix(1:6, nrow = 3, dimnames = list(c("g1", "g2", "g3"), c("s1", "s2")))
    ht <- ComplexHeatmap::Heatmap(mat, left_annotation = row_ann, top_annotation = col_ann)
    grDevices::pdf(NULL)
    on.exit(grDevices::dev.off(), add = TRUE)
    expect_no_error(ComplexHeatmap::draw(ht))
})

test_that(".heatmap_build_annotation, filtered by side, builds independent left/right annotations", {
    skip_if_not_installed("ComplexHeatmap")
    skip_if_not_installed("circlize")

    df <- data.frame(gene = c("g1", "g2", "g3"), pathway = c("A", "B", "A"), score = c(1, 2, 3))
    rows <- list(
        r1 = list(column = "pathway", side = "Left"),
        r2 = list(column = "score", side = "Right")
    )
    left_rows <- Filter(function(r) identical(r$side %||% "Left", "Left"), rows)
    right_rows <- Filter(function(r) identical(r$side, "Right"), rows)
    expect_named(left_rows, "r1")
    expect_named(right_rows, "r2")

    left_ann <- .heatmap_build_annotation(left_rows, df, df$gene, NULL, "row", .test_color_lookup)
    right_ann <- .heatmap_build_annotation(right_rows, df, df$gene, NULL, "row", .test_color_lookup)
    expect_s4_class(left_ann, "HeatmapAnnotation")
    expect_s4_class(right_ann, "HeatmapAnnotation")

    mat <- matrix(1:9, nrow = 3, dimnames = list(df$gene, c("s1", "s2", "s3")))
    ht <- ComplexHeatmap::Heatmap(mat, left_annotation = left_ann, right_annotation = right_ann)
    grDevices::pdf(NULL)
    on.exit(grDevices::dev.off(), add = TRUE)
    expect_no_error(ComplexHeatmap::draw(ht))
})

test_that("a row without `side` (predating the feature) defaults to Left/Top", {
    rows <- list(r1 = list(column = "pathway"))
    left_rows <- Filter(function(r) identical(r$side %||% "Left", "Left"), rows)
    right_rows <- Filter(function(r) identical(r$side, "Right"), rows)
    expect_length(left_rows, 1)
    expect_length(right_rows, 0)
})

# ---- End-to-end module smoke test --------------------------------------------------------------

test_that("ComplexHeatmap_HeatmapInputsUI builds for both data shapes", {
    df <- example_heatmap_matrix
    col_df <- example_heatmap_column_data

    expect_no_error(ComplexHeatmap_HeatmapInputsUI("h", df))
    expect_no_error(ComplexHeatmap_HeatmapInputsUI("h", list(matrix = df, column_annotations = col_df)))
})
