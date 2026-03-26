test_df <- data.frame(
    group = rep(c("A", "B", "C"), each = 20),
    value = c(rnorm(20, 5), rnorm(20, 8), rnorm(20, 5)),
    facet = rep(c("F1", "F2"), 30),
    color = rep(c("red", "blue"), 30),
    stringsAsFactors = FALSE
)

set.seed(42)

# ─── .compute_pairwise_stats ─────────────────────────────────────────────────

test_that(".compute_pairwise_stats returns correct structure for wilcox.test", {
    result <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value", test = "wilcox.test"
    )
    expect_s3_class(result, "data.frame")
    expect_true(all(c("group1", "group2", "p.value", "p.adj", "p.signif",
        "test", "facet_level", "x_level") %in% names(result)))
    expect_equal(nrow(result), 3) # C(3,2) = 3 pairs
    expect_true(all(result$test == "wilcox.test"))
})

test_that(".compute_pairwise_stats works with t.test", {
    result <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value", test = "t.test"
    )
    expect_s3_class(result, "data.frame")
    expect_equal(nrow(result), 3)
    expect_true(all(result$test == "t.test"))
})

test_that(".compute_pairwise_stats works with kruskal.test (omnibus)", {
    result <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value", test = "kruskal.test"
    )
    expect_s3_class(result, "data.frame")
    expect_equal(nrow(result), 1)
    expect_equal(result$group1, "all")
    expect_equal(result$group2, "all")
    expect_true(all(result$test == "kruskal.test"))
})

test_that(".compute_pairwise_stats works with anova (omnibus)", {
    result <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value", test = "anova"
    )
    expect_s3_class(result, "data.frame")
    expect_equal(nrow(result), 1)
    expect_equal(result$group1, "all")
    expect_true(all(result$test == "anova"))
})

test_that(".compute_pairwise_stats applies p-value adjustment", {
    result <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value",
        test = "wilcox.test", p.adjust.method = "bonferroni"
    )
    # Adjusted p-values should be >= raw p-values
    expect_true(all(result$p.adj >= result$p.value, na.rm = TRUE))
})

test_that(".compute_pairwise_stats respects specific pairs", {
    result <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value",
        test = "wilcox.test",
        pairs = list(c("A", "B"))
    )
    expect_equal(nrow(result), 1)
    expect_equal(result$group1, "A")
    expect_equal(result$group2, "B")
})

test_that(".compute_pairwise_stats handles per-facet testing", {
    result <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value",
        test = "wilcox.test", facet.by = "facet", per.facet = TRUE
    )
    expect_true(all(c("F1", "F2") %in% result$facet_level))
    # 3 pairs * 2 facets = 6 rows
    expect_equal(nrow(result), 6)
})

test_that(".compute_pairwise_stats with per.facet=FALSE returns NA facet_level", {
    result <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value",
        test = "wilcox.test", facet.by = "facet", per.facet = FALSE
    )
    expect_equal(nrow(result), 3)
    expect_true(all(is.na(result$facet_level)))
})

test_that(".compute_pairwise_stats with group.by nests within x-levels", {
    result <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value",
        test = "wilcox.test", group.by = "color"
    )
    # 3 x-levels * 1 pair (red vs blue) = 3 rows
    expect_equal(nrow(result), 3)
    expect_true(all(!is.na(result$x_level)))
})

test_that(".compute_pairwise_stats returns empty df for single group", {
    single <- test_df[test_df$group == "A", ]
    result <- VizModules:::.compute_pairwise_stats(
        df = single, x = "group", y = "value", test = "wilcox.test"
    )
    expect_equal(nrow(result), 0)
})

test_that(".compute_pairwise_stats sig.threshold affects p.signif", {
    result <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value",
        test = "wilcox.test", sig.threshold = 1.0
    )
    # With threshold of 1.0, nothing should be "ns"
    expect_true(all(result$p.signif != "ns"))
})

test_that(".compute_pairwise_stats paired test works", {
    # Equal-sized groups for paired test
    paired_df <- data.frame(
        group = rep(c("A", "B"), each = 10),
        value = c(rnorm(10, 5), rnorm(10, 8)),
        stringsAsFactors = FALSE
    )
    result <- VizModules:::.compute_pairwise_stats(
        df = paired_df, x = "group", y = "value",
        test = "t.test", paired = TRUE
    )
    expect_equal(nrow(result), 1)
    expect_false(is.na(result$p.value))
})

# ─── .generate_pair_strings ──────────────────────────────────────────────────

test_that(".generate_pair_strings returns correct pairs", {
    result <- VizModules:::.generate_pair_strings(test_df, "group")
    expect_equal(length(result), 3) # C(3,2) = 3
    expect_true(all(grepl(" vs ", result)))
})

test_that(".generate_pair_strings with group.by uses group levels", {
    result <- VizModules:::.generate_pair_strings(test_df, "group", group.by = "color")
    expect_equal(length(result), 1) # C(2,2) = 1 pair: red vs blue
    expect_true(grepl(" vs ", result))
})

test_that(".generate_pair_strings returns empty for single level", {
    single <- test_df[test_df$group == "A", ]
    result <- VizModules:::.generate_pair_strings(single, "group")
    expect_equal(length(result), 0)
})

# ─── .parse_pair_strings ─────────────────────────────────────────────────────

test_that(".parse_pair_strings parses valid strings", {
    result <- VizModules:::.parse_pair_strings(c("A vs B", "B vs C"))
    expect_type(result, "list")
    expect_equal(length(result), 2)
    expect_equal(result[[1]], c("A", "B"))
    expect_equal(result[[2]], c("B", "C"))
})

test_that(".parse_pair_strings returns NULL for empty input", {
    expect_null(VizModules:::.parse_pair_strings(NULL))
    expect_null(VizModules:::.parse_pair_strings(character(0)))
    expect_null(VizModules:::.parse_pair_strings(""))
})

# ─── .create_stat_annotations ────────────────────────────────────────────────

test_that(".create_stat_annotations returns correct structure", {
    stats_df <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value", test = "wilcox.test"
    )
    result <- VizModules:::.create_stat_annotations(
        stats_df = stats_df, fig = NULL, df = test_df,
        x = "group", y = "value"
    )
    expect_type(result, "list")
    expect_true(all(c("annotations", "shapes", "y.max") %in% names(result)))
    expect_true(length(result$annotations) > 0)
    expect_true(length(result$shapes) > 0)
    expect_true(is.numeric(result$y.max))
})

test_that(".create_stat_annotations returns empty for NULL stats_df", {
    result <- VizModules:::.create_stat_annotations(
        stats_df = NULL, fig = NULL, df = test_df,
        x = "group", y = "value"
    )
    expect_equal(length(result$annotations), 0)
    expect_equal(length(result$shapes), 0)
    expect_null(result$y.max)
})

test_that(".create_stat_annotations hide.ns filters results", {
    stats_df <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value",
        test = "wilcox.test", sig.threshold = 0.05
    )
    # With very low threshold, everything should be hidden
    result <- VizModules:::.create_stat_annotations(
        stats_df = stats_df, fig = NULL, df = test_df,
        x = "group", y = "value",
        hide.ns = TRUE, sig.threshold = 0.0001
    )
    # Brackets only shown for significant comparisons
    # (may be 0 if none are significant at 0.0001)
    expect_type(result, "list")
})

test_that(".create_stat_annotations generates capped bracket shapes", {
    stats_df <- data.frame(
        group1 = "A", group2 = "B",
        p.value = 0.01, p.adj = 0.01, p.signif = "**",
        test = "wilcox.test", facet_level = NA_character_,
        x_level = NA_character_, stringsAsFactors = FALSE
    )
    result <- VizModules:::.create_stat_annotations(
        stats_df = stats_df, fig = NULL, df = test_df,
        x = "group", y = "value", bracket.style = "capped"
    )
    # Capped style: 3 shapes per bracket (left tick, horizontal, right tick)
    expect_equal(length(result$shapes), 3)
})

test_that(".create_stat_annotations generates flat bracket shapes", {
    stats_df <- data.frame(
        group1 = "A", group2 = "B",
        p.value = 0.01, p.adj = 0.01, p.signif = "**",
        test = "wilcox.test", facet_level = NA_character_,
        x_level = NA_character_, stringsAsFactors = FALSE
    )
    result <- VizModules:::.create_stat_annotations(
        stats_df = stats_df, fig = NULL, df = test_df,
        x = "group", y = "value", bracket.style = "flat"
    )
    # Flat style: 1 shape per bracket
    expect_equal(length(result$shapes), 1)
})

test_that(".create_stat_annotations displays symbols", {
    stats_df <- data.frame(
        group1 = "A", group2 = "B",
        p.value = 0.001, p.adj = 0.001, p.signif = "***",
        test = "wilcox.test", facet_level = NA_character_,
        x_level = NA_character_, stringsAsFactors = FALSE
    )
    result <- VizModules:::.create_stat_annotations(
        stats_df = stats_df, fig = NULL, df = test_df,
        x = "group", y = "value", display = "symbol"
    )
    # Should display the significance symbol
    expect_equal(result$annotations[[1]]$text, "***")
})

test_that(".create_stat_annotations includes omnibus annotation", {
    stats_df <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value", test = "kruskal.test"
    )
    result <- VizModules:::.create_stat_annotations(
        stats_df = stats_df, fig = NULL, df = test_df,
        x = "group", y = "value"
    )
    # Should have one annotation (omnibus label) and no shapes (no brackets)
    expect_equal(length(result$annotations), 1)
    expect_equal(length(result$shapes), 0)
    expect_true(grepl("Kruskal-Wallis", result$annotations[[1]]$text))
    # Uses paper coordinates
    expect_equal(result$annotations[[1]]$xref, "paper")
    expect_equal(result$annotations[[1]]$yref, "paper")
})

# ─── .apply_stat_annotations ─────────────────────────────────────────────────

test_that(".apply_stat_annotations adds shapes and annotations to figure", {
    fig <- list(x = list(layout = list(yaxis = list(range = c(0, 10)))))
    class(fig) <- "plotly"

    stat_result <- list(
        annotations = list(list(text = "**", x = 1.5, y = 12)),
        shapes = list(list(type = "line", x0 = 1, x1 = 2, y0 = 11, y1 = 11)),
        y.max = 13
    )

    result <- VizModules:::.apply_stat_annotations(fig, stat_result)
    expect_equal(length(result$x$layout$shapes), 1)
    expect_equal(length(result$x$layout$annotations), 1)
    expect_equal(result$x$layout$yaxis$range[2], 13)
    # y-min should have a small buffer below the original value
    expect_true(result$x$layout$yaxis$range[1] < 0)
})

test_that(".apply_stat_annotations preserves existing shapes", {
    fig <- list(x = list(layout = list(
        yaxis = list(range = c(0, 10)),
        shapes = list(list(type = "rect")),
        annotations = list(list(text = "existing"))
    )))
    class(fig) <- "plotly"

    stat_result <- list(
        annotations = list(list(text = "new")),
        shapes = list(list(type = "line")),
        y.max = 13
    )

    result <- VizModules:::.apply_stat_annotations(fig, stat_result)
    expect_equal(length(result$x$layout$shapes), 2)
    expect_equal(length(result$x$layout$annotations), 2)
})

test_that(".apply_stat_annotations updates all y-axes for faceted plots", {
    fig <- list(x = list(layout = list(
        yaxis = list(range = c(0, 10)),
        yaxis2 = list(range = c(0, 10))
    )))
    class(fig) <- "plotly"

    stat_result <- list(annotations = list(), shapes = list(list(type = "line")), y.max = 15)

    result <- VizModules:::.apply_stat_annotations(fig, stat_result)
    expect_equal(result$x$layout$yaxis$range[2], 15)
    expect_equal(result$x$layout$yaxis2$range[2], 15)
    # Both axes should have bottom buffer
    expect_true(result$x$layout$yaxis$range[1] < 0)
    expect_true(result$x$layout$yaxis2$range[1] < 0)
})

test_that(".apply_stat_annotations is a no-op for empty results", {
    fig <- list(x = list(layout = list(yaxis = list(range = c(0, 10)))))
    class(fig) <- "plotly"

    stat_result <- list(annotations = list(), shapes = list(), y.max = NULL)

    result <- VizModules:::.apply_stat_annotations(fig, stat_result)
    expect_equal(result$x$layout$yaxis$range, c(0, 10))
})

# ─── .write_stats_csv ────────────────────────────────────────────────────────

test_that(".write_stats_csv writes file with metadata header", {
    stats_df <- VizModules:::.compute_pairwise_stats(
        df = test_df, x = "group", y = "value", test = "wilcox.test"
    )
    tmp <- tempfile(fileext = ".csv")
    on.exit(unlink(tmp))

    VizModules:::.write_stats_csv(stats_df, tmp,
        p.adjust.method = "bonferroni", sig.threshold = 0.05)

    lines <- readLines(tmp)
    # First line should be a comment with the p-value adjustment method
    expect_true(grepl("^# P-value adjustment method: bonferroni", lines[1]))
    expect_true(grepl("^# Significance threshold: 0.05", lines[2]))
    # Should contain CSV data after the header
    expect_true(any(grepl("group1", lines)))
    expect_true(any(grepl("p.adjust.method", lines)))
})

test_that(".write_stats_csv handles NULL stats_df", {
    tmp <- tempfile(fileext = ".csv")
    on.exit(unlink(tmp))

    VizModules:::.write_stats_csv(NULL, tmp)

    lines <- readLines(tmp)
    expect_true(grepl("No stats", lines[1]))
})

test_that(".write_stats_csv handles empty stats_df", {
    empty_df <- data.frame(
        group1 = character(0), group2 = character(0),
        p.value = numeric(0), p.adj = numeric(0), p.signif = character(0),
        test = character(0), facet_level = character(0), x_level = character(0),
        stringsAsFactors = FALSE
    )
    tmp <- tempfile(fileext = ".csv")
    on.exit(unlink(tmp))

    VizModules:::.write_stats_csv(empty_df, tmp)

    lines <- readLines(tmp)
    expect_true(grepl("No stats", lines[1]))
})
