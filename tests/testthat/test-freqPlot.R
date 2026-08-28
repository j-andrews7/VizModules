# Tests for the dittoViz_freqPlot module.
#
# freqPlot() does not plot columns of its input -- it tabulates how often each
# level of `var` occurs within each sample and plots that summary. Most of what
# is worth pinning here is therefore about the summarised frame: that the module
# computes the same one the plot is drawn from, and that everything derived from
# it (axis limits, statistics, annotations, the source download) reads it rather
# than the input rows.

# A small frame with samples nested inside groups, which is the shape freqPlot()
# requires. Six samples, three per condition, crossed with two batches.
.freq_fixture <- function() {
    set.seed(42)
    samples <- paste0("s", 1:6)
    data.frame(
        cell_id = sprintf("c%03d", 1:120),
        sample = rep(samples, each = 20),
        condition = rep(c("Healthy", "Disease"), each = 60),
        batch = rep(c("B1", "B2", "B1", "B2", "B1", "B2"), each = 20),
        cell_type = sample(c("T", "B", "Mono"), 120, replace = TRUE),
        n_genes = as.integer(round(rnorm(120, 2000, 200))),
        stringsAsFactors = FALSE
    )
}


# --- 1. Nesting detection ----------------------------------------------------

test_that(".freq_maps_one_per detects nesting in both directions", {
    df <- .freq_fixture()

    # Each sample sits inside exactly one condition and one batch.
    expect_true(.freq_maps_one_per(df$sample, df$condition))
    expect_true(.freq_maps_one_per(df$sample, df$batch))

    # Conditions span several samples, so the reverse does not hold.
    expect_false(.freq_maps_one_per(df$condition, df$sample))

    # Batch and condition are crossed, so neither nests inside the other.
    expect_false(.freq_maps_one_per(df$batch, df$condition))

    expect_false(.freq_maps_one_per(character(0), character(0)))
    expect_false(.freq_maps_one_per(df$sample, df$condition[1:5]))
})

test_that(".freq_sample_choices offers only columns that nest inside the grouping", {
    df <- .freq_fixture()

    expect_equal(.freq_sample_choices(df, "condition"), "sample")
    expect_equal(.freq_sample_choices(df, c("condition", "batch")), "sample")

    # cell_type is not constant within a sample, so it can never be the sample
    # column; offering it would make freqPlot() error.
    expect_false("cell_type" %in% .freq_sample_choices(df, "condition"))

    # A row identifier structurally "nests" inside everything but would give one
    # observation per sample, so a frequency of 0 or 1 everywhere.
    expect_false("cell_id" %in% .freq_sample_choices(df, "condition"))

    # The grouping columns themselves are excluded.
    expect_false("condition" %in% .freq_sample_choices(df, "condition"))

    # batch is crossed with condition rather than nested inside it, so it is not
    # a legal sample column for that grouping either -- freqPlot() would stop()
    # on the pair. Its own shape is fine; it is the grouping that rules it out.
    expect_false("batch" %in% .freq_sample_choices(df, "condition"))
    expect_true("batch" %in% .freq_sample_choices(df, character(0)))
})

test_that(".freq_sample_choices allows more samples than .facet_check() would", {
    # Samples are the unit of observation rather than a facet, so a study with
    # more than the fifty levels .facet_check() caps at is still valid.
    set.seed(1)
    n <- 60
    df <- data.frame(
        sample = rep(sprintf("s%02d", seq_len(n)), each = 4),
        condition = rep(c("A", "B"), each = n * 2),
        cell_type = sample(c("T", "B"), n * 4, replace = TRUE),
        stringsAsFactors = FALSE
    )

    expect_false("sample" %in% .facet_check(df))
    expect_true("sample" %in% .freq_sample_choices(df, "condition"))
})


# --- 2. Small input normalizers ----------------------------------------------

test_that(".freq_selected_vars keeps multi-value selections that .blank_to_null() would drop", {
    # .blank_to_null() returns NULL for anything not length one, so a two-level
    # selection would read as "no selection" and every facet would be drawn.
    expect_null(.blank_to_null(c("T", "B")))
    expect_equal(.freq_selected_vars(c("T", "B")), c("T", "B"))

    expect_null(.freq_selected_vars(NULL))
    expect_null(.freq_selected_vars(""))
    expect_null(.freq_selected_vars(c("", "")))
    expect_null(.freq_selected_vars(character(0)))
    expect_equal(.freq_selected_vars(c("T", "", NA)), "T")
})

test_that(".freq_y_col names the column freqPlot() actually plots", {
    expect_equal(.freq_y_col("percent", FALSE), "percent")
    expect_equal(.freq_y_col("count", FALSE), "count")
    expect_equal(.freq_y_col("percent", TRUE), "percent.norm")
    expect_equal(.freq_y_col("count", TRUE), "count.norm")
})

test_that(".freq_stats_group_col only nests when color.by is a genuinely different column", {
    expect_null(.freq_stats_group_col("condition", ""))
    expect_null(.freq_stats_group_col("condition", NULL))
    expect_null(.freq_stats_group_col("condition", "condition"))
    expect_equal(.freq_stats_group_col("condition", "batch"), "batch")
})


# --- 3. The summarised frame -------------------------------------------------

test_that(".freq_summary returns the per-sample frequency table", {
    df <- .freq_fixture()

    summ <- .freq_summary(df, var = "cell_type", sample.by = "sample", group.by = "condition")

    expect_s3_class(summ, "data.frame")
    # One row per sample per level: 6 samples x 3 cell types.
    expect_equal(nrow(summ), 18)
    expect_true(all(c("label", "grouping", "count", "percent", "sample") %in% names(summ)))
    expect_setequal(unique(summ$grouping), c("Healthy", "Disease"))
    expect_setequal(unique(as.character(summ$label)), c("T", "B", "Mono"))

    # Frequencies within a sample sum to 1, and the counts to that sample's cells.
    by_sample <- tapply(summ$percent, summ$sample, sum)
    expect_equal(as.numeric(by_sample), rep(1, 6))
    expect_equal(as.numeric(tapply(summ$count, summ$sample, sum)), rep(20, 6))
})

test_that(".freq_summary reapplies the vars.use subsetting freqPlot() skips", {
    df <- .freq_fixture()

    # Upstream returns before applying its own vars.use, so the frame it hands
    # back disagrees with the plot. This pins that behaviour: if dittoViz fixes
    # it, this expectation fails and the workaround can be dropped.
    upstream <- dittoViz::freqPlot(
        df, var = "cell_type", sample.by = "sample", group.by = "condition",
        vars.use = "T", data.only = TRUE
    )
    expect_setequal(unique(as.character(upstream$label)), c("T", "B", "Mono"))

    summ <- .freq_summary(
        df, var = "cell_type", sample.by = "sample", group.by = "condition",
        vars.use = "T"
    )
    expect_equal(unique(as.character(summ$label)), "T")
    expect_equal(nrow(summ), 6)

    # And that it matches what is actually drawn for the same vars.use.
    plotted <- plotly::plotly_data(dittoViz::freqPlot(
        df, var = "cell_type", sample.by = "sample", group.by = "condition",
        vars.use = "T", do.hover = TRUE
    ))
    expect_setequal(unique(as.character(plotted$label)), unique(as.character(summ$label)))
})

test_that(".freq_summary follows scale and max.normalize", {
    df <- .freq_fixture()

    counts <- .freq_summary(df, var = "cell_type", sample.by = "sample",
        group.by = "condition", scale = "count")
    expect_true("count" %in% names(counts))

    normed <- .freq_summary(df, var = "cell_type", sample.by = "sample",
        group.by = "condition", max.normalize = TRUE)
    expect_true(all(c("percent.norm", "count.norm") %in% names(normed)))
    # Each label is scaled to its own maximum, so every facet peaks at 1.
    expect_equal(max(normed$percent.norm), 1)
})

test_that(".freq_summary carries a distinct color column through", {
    df <- .freq_fixture()

    summ <- .freq_summary(df, var = "cell_type", sample.by = "sample",
        group.by = "condition", color.by = "batch")
    expect_true("batch" %in% names(summ))
    expect_setequal(unique(summ$batch), c("B1", "B2"))
})

test_that(".freq_summary returns NULL rather than erroring on unusable input", {
    df <- .freq_fixture()

    expect_null(.freq_summary(df, var = "", group.by = "condition"))
    expect_null(.freq_summary(df, var = "not_a_column", group.by = "condition"))
    expect_null(.freq_summary(df, var = "cell_type", group.by = ""))
    expect_null(.freq_summary(NULL, var = "cell_type", group.by = "condition"))

    # cell_type is not constant within a sample, so freqPlot() would stop(); the
    # module surfaces that as "no summary" instead of an error.
    expect_null(.freq_summary(df, var = "n_genes", sample.by = "cell_type",
        group.by = "condition"))
})


# --- 4. The inputs UI --------------------------------------------------------

test_that("the inputs UI exposes the freqPlot-specific controls", {
    df <- .freq_fixture()
    html <- as.character(dittoViz_freqPlotInputsUI("freq", df))

    for (id in c("freq-var", "freq-sample.by", "freq-group.by", "freq-color.by",
                 "freq-vars.use", "freq-scale", "freq-max.normalize", "freq-plots")) {
        expect_true(grepl(id, html, fixed = TRUE), info = id)
    }

    # freqPlot() always facets on the frequency variable, so there is no split.by
    # to expose; vars.use picks which of those facets are drawn instead.
    expect_false(grepl("freq-split.by", html, fixed = TRUE))
    expect_true(grepl("Levels To Show", html, fixed = TRUE))

    # The facet controls that do apply are still there.
    expect_true(grepl("freq-split.ncol", html, fixed = TRUE))
    expect_true(grepl("freq-split.nrow", html, fixed = TRUE))
    expect_true(grepl("freq-split.adjust", html, fixed = TRUE))

    # Statistics are supported, comparing per-sample frequencies between groups.
    expect_true(grepl("freq-stats.enabled", html, fixed = TRUE))
})

test_that("the inputs UI honours defaults and offers only nesting sample columns", {
    df <- .freq_fixture()
    html <- as.character(dittoViz_freqPlotInputsUI("freq", df,
        defaults = list(var = "cell_type", sample.by = "sample", group.by = "condition")))

    expect_true(grepl('"selectedValue":"cell_type"', html, fixed = TRUE))
    expect_true(grepl('"selectedValue":"sample"', html, fixed = TRUE))
    expect_true(grepl('"selectedValue":"condition"', html, fixed = TRUE))

    # The "Levels To Show" choices are the levels of the default var.
    expect_true(grepl("Mono", html, fixed = TRUE))
})

test_that("the inputs UI is namespaced per instance", {
    df <- .freq_fixture()
    a <- as.character(dittoViz_freqPlotInputsUI("first", df))
    b <- as.character(dittoViz_freqPlotInputsUI("second", df))

    expect_true(grepl("first-var", a, fixed = TRUE))
    expect_false(grepl("second-var", a, fixed = TRUE))
    expect_true(grepl("second-var", b, fixed = TRUE))
    expect_false(grepl("first-var", b, fixed = TRUE))
})


# --- 5. The module server ----------------------------------------------------

test_that("the server summarises from the current inputs", {
    df <- .freq_fixture()

    shiny::testServer(
        dittoViz_freqPlotServer,
        args = list(id = "freq", data = shiny::reactive(df)),
        {
            session$setInputs(
                var = "cell_type", sample.by = "sample", group.by = "condition",
                color.by = "", vars.use = "", scale = "percent", max.normalize = FALSE
            )
            session$flushReact()

            summ <- summary_df()
            expect_s3_class(summ, "data.frame")
            expect_equal(nrow(summ), 18)
            expect_setequal(unique(summ$grouping), c("Healthy", "Disease"))

            # Restricting the visible levels restricts the frame everything else
            # is computed from, not just the picture.
            session$setInputs(vars.use = "T")
            expect_equal(unique(as.character(summary_df()$label)), "T")

            # Counts and percentages are different columns of that same frame.
            session$setInputs(vars.use = "", scale = "count")
            expect_true("count" %in% names(summary_df()))
        }
    )
})

test_that("the y-axis limits are computed from the frequencies, not the input columns", {
    df <- .freq_fixture()

    shiny::testServer(
        dittoViz_freqPlotServer,
        args = list(id = "freq", data = shiny::reactive(df)),
        {
            session$setInputs(
                var = "cell_type", sample.by = "sample", group.by = "condition",
                color.by = "", vars.use = "", scale = "percent", max.normalize = FALSE,
                stats.enabled = FALSE, y.min = 0, y.max = NA
            )
            session$flushReact()

            limits <- y_range_store()
            summ <- summary_df()

            # Percentages are fractions, so the limit tracks them rather than any
            # column of the 120-row input (n_genes runs into the thousands).
            expect_lte(limits$max, 2)
            expect_gte(limits$max, max(summ$percent))

            # Switching to counts rescales the axis to the count column.
            session$setInputs(scale = "count")
            session$flushReact()
            expect_gte(y_range_store()$max, max(summary_df()$count))
            expect_gt(y_range_store()$max, 2)
        }
    )
})

test_that("the palette is keyed by the column the plot fills by", {
    df <- .freq_fixture()

    shiny::testServer(
        dittoViz_freqPlotServer,
        args = list(id = "freq", data = shiny::reactive(df)),
        {
            session$setInputs(
                var = "cell_type", sample.by = "sample", group.by = "condition",
                color.by = ""
            )
            session$flushReact()
            # With no color.by the fill follows the grouping.
            expect_setequal(palette_groups(), c("Healthy", "Disease"))

            session$setInputs(color.by = "batch")
            session$flushReact()
            expect_setequal(palette_groups(), c("B1", "B2"))
        }
    )
})

test_that("a defaults palette seeds the picker", {
    df <- .freq_fixture()

    shiny::testServer(
        dittoViz_freqPlotServer,
        args = list(
            id = "freq", data = shiny::reactive(df),
            defaults = list(palette.colours = c(Healthy = "red", Disease = "#00FF00"))
        ),
        {
            session$setInputs(
                var = "cell_type", sample.by = "sample", group.by = "condition",
                color.by = ""
            )
            session$flushReact()
            # Keyed by group name, so the picker order (the fill column's factor
            # levels) is irrelevant to which group gets which colour.
            resolved <- palette_store()
            expect_equal(resolved[["Healthy"]], "#FF0000")
            expect_equal(resolved[["Disease"]], "#00FF00")
        }
    )
})

test_that("two instances hold independent state", {
    df <- .freq_fixture()

    first <- NULL
    shiny::testServer(
        dittoViz_freqPlotServer,
        args = list(id = "first", data = shiny::reactive(df)),
        {
            session$setInputs(
                var = "cell_type", sample.by = "sample", group.by = "condition",
                color.by = "", vars.use = "T", scale = "percent", max.normalize = FALSE
            )
            session$flushReact()
            first <<- list(labels = unique(as.character(summary_df()$label)),
                           groups = palette_groups())
        }
    )

    second <- NULL
    shiny::testServer(
        dittoViz_freqPlotServer,
        args = list(id = "second", data = shiny::reactive(df)),
        {
            session$setInputs(
                var = "cell_type", sample.by = "sample", group.by = "condition",
                color.by = "batch", vars.use = "", scale = "count", max.normalize = FALSE
            )
            session$flushReact()
            second <<- list(labels = unique(as.character(summary_df()$label)),
                            groups = palette_groups())
        }
    )

    expect_equal(first$labels, "T")
    expect_setequal(second$labels, c("T", "B", "Mono"))
    expect_setequal(first$groups, c("Healthy", "Disease"))
    expect_setequal(second$groups, c("B1", "B2"))
})


# --- 6. Statistics run against the summary, per facet ------------------------

test_that("statistics compare per-sample frequencies within each facet", {
    df <- .freq_fixture()
    summ <- .freq_summary(df, var = "cell_type", sample.by = "sample", group.by = "condition")

    stats_df <- compute_pairwise_stats(
        df = summ, x = "grouping", y = "percent",
        pairs = parse_pair_strings("Healthy vs Disease"),
        test = "t.test", p.adjust.method = "none", paired = FALSE,
        group.by = NULL, facet.by = "label", per.facet = TRUE,
        sig.threshold = 0.05
    )

    expect_s3_class(stats_df, "data.frame")
    # One comparison per facet, never pooled across them: the frequencies of two
    # different cell types are not comparable quantities.
    expect_equal(nrow(stats_df), 3)
    expect_setequal(unique(as.character(stats_df$facet)), c("T", "B", "Mono"))
})

test_that("the comparison pairs come from the grouping column's levels", {
    df <- .freq_fixture()

    # The x-axis is the summary's "grouping" column, but its levels are exactly
    # the levels of group.by in the input, so the pairs can be built from either.
    from_input <- generate_pair_strings(df, "condition", NULL)
    summ <- .freq_summary(df, var = "cell_type", sample.by = "sample", group.by = "condition")
    from_summary <- generate_pair_strings(summ, "grouping", NULL)

    expect_setequal(from_input, from_summary)
})


# --- 7. Driving the module's own build ---------------------------------------

# The plot output cannot be driven from testServer (the mock session never
# renders the renderUI()-built colour picker and never registers plotly events),
# but the reactive that builds the figure can, given a complete set of inputs.
.freq_inputs <- function(...) {
    base <- list(
        var = "cell_type", sample.by = "sample", group.by = "condition", color.by = "",
        vars.use = "", scale = "percent", max.normalize = FALSE,
        plots = c("boxplot", "jitter"),
        y.min = 0, y.max = NA, auto.update = TRUE,
        split.adjust = "fixed", split.ncol = NA, split.nrow = NA,
        subplot.margin.x = 30, subplot.margin.y = 30,
        jitter.size = 1, jitter.width = 0.2, jitter.color = "#000000",
        hover.round.digits = 5, do.raster = FALSE, raster.dpi = 600,
        boxplot.show.outliers = FALSE, boxplot.color = "#000000", boxplot.fill = TRUE,
        boxplot.lineweight = 0.5, boxgap = 0.3, boxgroupgap = 0.2,
        vlnplot.lineweight = 0.5, vlnplot.scaling = "area",
        ridgeplot.lineweight = 0.5, ridgeplot.scale = 1.25,
        ridgeplot.ymax.expansion = NA, ridgeplot.shape = "smooth",
        ridgeplot.bins = 30, ridgeplot.binwidth = NA,
        stats.enabled = FALSE, stat.test = "t.test", stat.p.adjust = "none",
        stat.display = "stars", stat.sig.threshold = 0.05, stat.hide.ns = FALSE,
        stat.paired = FALSE, stat.pairs = "", stat.per.facet = TRUE,
        stat.bracket.style = "bracket", stat.bracket.inset = 0.1,
        stat.step.increase = 0.1, stat.text.bump = 0.02,
        stat.line.color = "black", stat.line.width = 1,
        annotate.by = "", highlight.points = "", highlight.auto.annotate = TRUE,
        highlight.color = "#00FFF7", highlight.size = 7,
        highlight.border.color = "#000000", highlight.border.width = 1,
        annotation.color = "black", annotation.ax = 20, annotation.ay = -20,
        annotation.size = 10, annotation.showarrow = TRUE,
        annotation.arrowcolor = "black", annotation.arrowhead = 2,
        annotation.arrowwidth = 1.5,
        download.format = "png", legend.title.size = 14, legend.text.size = 12,
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 14,
        facet.title.font.color = "black", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "",
        margin.l = 80, margin.r = 80, margin.t = 80, margin.b = 80
    )
    utils::modifyList(base, list(...))
}

test_that("the module builds a figure over the summarised frequencies", {
    df <- .freq_fixture()

    shiny::testServer(
        dittoViz_freqPlotServer,
        args = list(id = "freq", data = shiny::reactive(df)),
        {
            do.call(session$setInputs, .freq_inputs())
            session$flushReact()

            fig <- generate_freqPlot()
            expect_s3_class(fig, "plotly")

            # The figure carries the frequency table, not the 120 input rows, so
            # the source download built from it is the data actually plotted.
            src <- as.data.frame(plotly::plotly_data(fig))
            expect_equal(nrow(src), 18)
            expect_true(all(c("label", "grouping", "count", "percent") %in% names(src)))
            expect_false("cell_id" %in% names(src))
        }
    )
})

test_that("restricting the visible levels restricts the figure", {
    df <- .freq_fixture()

    shiny::testServer(
        dittoViz_freqPlotServer,
        args = list(id = "freq", data = shiny::reactive(df)),
        {
            do.call(session$setInputs, .freq_inputs(vars.use = "T"))
            session$flushReact()

            src <- as.data.frame(plotly::plotly_data(generate_freqPlot()))
            # Upstream ignores vars.use on its data.only path; the drawn figure
            # does not, and the module's frame has to agree with the figure.
            expect_equal(unique(as.character(src$label)), "T")
            expect_equal(nrow(src), 6)
        }
    )
})

test_that("the module builds every plot type and both scales", {
    df <- .freq_fixture()

    for (variant in list(
        list(plots = "boxplot"),
        list(plots = "vlnplot"),
        list(plots = "ridgeplot"),
        list(plots = c("boxplot", "jitter"), scale = "count"),
        list(plots = c("vlnplot", "jitter"), max.normalize = TRUE),
        list(color.by = "batch")
    )) {
        shiny::testServer(
            dittoViz_freqPlotServer,
            args = list(id = "freq", data = shiny::reactive(df)),
            {
                do.call(session$setInputs, do.call(.freq_inputs, variant))
                session$flushReact()
                fig <- suppressWarnings(generate_freqPlot())
                expect_s3_class(fig, "plotly")
            }
        )
    }
})

test_that("enabled statistics add brackets drawn from the frequency table", {
    df <- .freq_fixture()

    shiny::testServer(
        dittoViz_freqPlotServer,
        args = list(id = "freq", data = shiny::reactive(df)),
        {
            do.call(session$setInputs, .freq_inputs(
                stats.enabled = TRUE, stat.hide.ns = FALSE
            ))
            session$flushReact()
            # Selecting a comparison freezes stat.pairs and repopulates it; the
            # mock session never echoes that back, so supply the echo by hand.
            session$setInputs(stat.pairs = "Healthy vs Disease")
            session$flushReact()

            fig <- generate_freqPlot()
            expect_s3_class(fig, "plotly")

            # One comparison per facet, never pooled: the tests are forced
            # per-facet because frequencies of different levels are not
            # comparable quantities.
            stats_df <- last_stats_df()
            expect_s3_class(stats_df, "data.frame")
            expect_equal(nrow(stats_df), 3)
            expect_setequal(unique(as.character(stats_df$facet_level)), c("T", "B", "Mono"))

            # The tests run on the per-sample frequencies, so each group
            # contributes its three samples rather than its sixty input rows.
            summ <- .freq_summary(df, var = "cell_type", sample.by = "sample",
                group.by = "condition")
            for (lvl in c("T", "B", "Mono")) {
                panel <- summ[summ$label == lvl, ]
                direct <- stats::t.test(percent ~ grouping, data = panel)$p.value
                reported <- stats_df$p.value[as.character(stats_df$facet_level) == lvl]
                expect_equal(reported, direct, tolerance = 1e-8)
            }
        }
    )
})

test_that("annotations label points by sample", {
    df <- .freq_fixture()

    shiny::testServer(
        dittoViz_freqPlotServer,
        args = list(id = "freq", data = shiny::reactive(df)),
        {
            do.call(session$setInputs, .freq_inputs(
                annotate.by = "sample", highlight.points = "s1"
            ))
            session$flushReact()

            fig <- generate_freqPlot()
            expect_s3_class(fig, "plotly")

            # A label is added for the highlighted sample in each facet, on top of
            # the facet strip labels rather than replacing them.
            annos <- fig$x$layout$annotations
            texts <- vapply(annos, function(a) a$text %||% "", character(1))
            expect_true(any(texts == "s1"))
            expect_true(any(texts %in% c("T", "B", "Mono")))
        }
    )
})


# --- 8. Registration ---------------------------------------------------------

test_that("the module is registered with the figure builder against a suitable dataset", {
    registry <- .figure_builder_registry()
    datasets <- .figure_builder_data()

    expect_true("freq" %in% names(registry))
    entry <- registry[["freq"]]

    expect_identical(entry$server_fn, dittoViz_freqPlotServer)
    expect_identical(entry$inputs_ui, dittoViz_freqPlotInputsUI)
    expect_identical(entry$output_ui, dittoViz_freqPlotOutputUI)

    # The defaults are written against this dataset, so it has to be in the
    # catalogue and the columns they name have to exist in it.
    expect_true(entry$dataset %in% names(datasets))
    df <- datasets[[entry$dataset]]
    for (col in unlist(entry$defaults)) {
        expect_true(col %in% names(df), info = col)
    }

    # And the pairing has to be one freqPlot() accepts: samples nested inside
    # the grouping, and the frequency variable varying within a sample.
    expect_true(entry$defaults[["sample.by"]] %in%
        .freq_sample_choices(df, entry$defaults[["group.by"]]))
    expect_s3_class(
        .freq_summary(df, var = entry$defaults[["var"]],
            sample.by = entry$defaults[["sample.by"]],
            group.by = entry$defaults[["group.by"]]),
        "data.frame"
    )
})

test_that("the bundled example dataset has samples nested inside groups", {
    df <- example_composition

    # This is the shape freqPlot() needs and that no other bundled dataset has;
    # without it the demo opens on a single point per group.
    expect_true(.freq_maps_one_per(df$sample, df$condition))
    expect_true(.freq_maps_one_per(df$sample, df$batch))
    expect_equal(length(unique(df$sample)), 12)

    # Batch is crossed with condition rather than confounded with it, so it is a
    # usable color.by that does not simply restate the grouping.
    per_sample <- unique(df[, c("sample", "condition", "batch")])
    expect_equal(as.vector(table(per_sample$condition, per_sample$batch)), rep(3, 4))

    summ <- .freq_summary(df, var = "cell_type", sample.by = "sample", group.by = "condition")
    # Six samples per group in every facet, so the boxes have real spread.
    expect_equal(nrow(summ), 12 * length(unique(df$cell_type)))
    expect_true(all(table(summ$grouping, summ$label) == 6))
})


# --- 9. The figure the module builds -----------------------------------------

test_that("the built figure plots the summarised frequencies", {
    df <- .freq_fixture()
    summ <- .freq_summary(df, var = "cell_type", sample.by = "sample", group.by = "condition")

    fig <- .with_stable_seed(dittoViz::freqPlot(
        df, var = "cell_type", sample.by = "sample", group.by = "condition",
        plots = c("boxplot", "jitter"), do.hover = TRUE
    ))

    expect_s3_class(fig, "plotly")

    # plotly_data() is what the source download is built from, so it has to be
    # the frequency table rather than the 120 input rows.
    src <- as.data.frame(plotly::plotly_data(fig))
    expect_equal(nrow(src), nrow(summ))
    expect_true(all(c("label", "grouping", "percent", "count") %in% names(src)))
    expect_equal(sort(src$percent), sort(summ$percent))
})

test_that("a named palette reaches the fill for every plot type", {
    df <- .freq_fixture()
    pal <- c(Healthy = "#FF0000", Disease = "#0000FF")

    for (plots in list("boxplot", "vlnplot", "ridgeplot", c("boxplot", "jitter"))) {
        p <- suppressWarnings(dittoViz::freqPlot(
            df, var = "cell_type", sample.by = "sample", group.by = "condition",
            plots = plots, color.panel = pal, colors = seq_along(pal)
        ))
        built <- suppressWarnings(ggplot2::ggplot_build(p))
        fills <- unique(unlist(lapply(built$data, function(d) {
            if ("fill" %in% names(d)) d$fill else NULL
        })))
        fills <- fills[!is.na(fills)]

        # Names match the fill column's levels, so the mapping survives rather
        # than silently dropping every group to grey.
        expect_true(all(fills %in% unname(pal)), info = paste(plots, collapse = "+"))
        expect_setequal(fills, unname(pal))
    }
})
