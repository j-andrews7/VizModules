# Helper: pull the non-empty hover strings out of a plotly figure produced by
# dittoViz::yPlot(do.hover = TRUE) (which returns a plotly object directly).
.yplot_hover_text <- function(fig) {
    txt <- unlist(lapply(fig$x$data, function(tr) tr$text))
    txt[!is.na(txt) & nzchar(txt)]
}

test_that("yPlot UI exposes the hover and point annotation inputs", {
    df <- data.frame(
        num1 = c(1, 2, 3),
        num2 = c(4.5, 5.5, 6.5),
        cat1 = c("a", "b", "c"),
        stringsAsFactors = FALSE
    )
    html <- as.character(dittoViz_yPlotInputsUI("yplot", df))

    for (id in c("hover.data", "hover.round.digits", "annotate.by", "highlight.points",
                 "highlight.auto.annotate", "annotation.clear")) {
        expect_true(grepl(paste0("yplot-", id), html, fixed = TRUE), info = id)
    }
    expect_true(grepl("Hover Data", html, fixed = TRUE))
    expect_true(grepl("Hover Round Digits", html, fixed = TRUE))
})

test_that("yPlot UI takes several Y variables, with limits spanning all of them", {
    df <- data.frame(
        num1 = c(1, 2, 3),
        num2 = c(4.5, 5.5, 6.5),
        cat1 = c("a", "b", "c"),
        stringsAsFactors = FALSE
    )
    html <- as.character(dittoViz_yPlotInputsUI("yplot", df, defaults = list(var = c("num1", "num2"))))

    # The Y Data select is a multi-select and honours a multi-column default.
    expect_true(grepl('"multiple":true', html, fixed = TRUE))
    expect_true(grepl('"selectedValue":["num1","num2"]', html, fixed = TRUE))

    # The controls for how those variables are displayed are present.
    expect_true(grepl("yplot-multivar.aes", html, fixed = TRUE))
    expect_true(grepl("Multivar Aesthetic", html, fixed = TRUE))
    expect_true(grepl("yplot-multivar.split.dir", html, fixed = TRUE))

    # Both variables share one axis, so its limits must fit the pair, not just
    # the first column.
    expect_match(html, paste0('id="yplot-y\\.max"[^>]*value="', 6.5 * 1.11, '"'))
    expect_match(html, 'id="yplot-y\\.min"[^>]*value="1"')
})

test_that("the palette follows the Y variables when they drive the fill", {
    set.seed(1)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 10),
        zeta = rnorm(20),
        alpha = rnorm(20) + 2,
        stringsAsFactors = FALSE
    )

    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(id = "yplot", data = shiny::reactive(df)),
        {
            # dittoViz fills by its "var.which" column for this aesthetic, so the
            # palette (and the colour picker built from it) has to be keyed by
            # variable name. Names that miss the fill values leave the plot grey.
            session$setInputs(
                var = c("zeta", "alpha"), group.by = "grp", color.by = "",
                multivar.aes = "color"
            )
            expect_equal(palette_groups(), c("alpha", "zeta"))

            # Every other layout still fills by the grouping column.
            session$setInputs(multivar.aes = "split")
            expect_equal(palette_groups(), c("A", "B"))

            session$setInputs(multivar.aes = "group")
            expect_equal(palette_groups(), c("A", "B"))

            session$setInputs(var = "zeta", multivar.aes = "color")
            expect_equal(palette_groups(), c("A", "B"))
        }
    )
})

test_that("a rebuilt colour picker reporting the same palette does not rebuild the plot", {
    set.seed(1)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 8),
        v1 = rnorm(16),
        v2 = rnorm(16) + 3,
        stringsAsFactors = FALSE
    )

    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(id = "yplot", data = shiny::reactive(df)),
        {
            session$setInputs(
                var = c("v1", "v2"), group.by = "grp", color.by = "",
                multivar.aes = "color"
            )
            session$flushReact()

            # The palette the picker is seeded with is settled server-side, so the
            # first draw is on the right colours rather than a fallback.
            settled <- palette_store()
            expect_equal(settled, c(v1 = "#E69F00", v2 = "#56B4E9"))

            # The client reporting that same seed back changes nothing.
            session$setInputs(palette.colours = settled)
            expect_identical(palette_store(), settled)

            # The picker is rebuilt whenever the group set changes and is re-seeded
            # from this same resolution, so what it reports afterwards - on opening
            # the tab it lives in, say - resolves to the palette already drawn. The
            # plot reads the resolution, so that costs no rebuild.
            session$setInputs(
                palette.colours = c(v1 = "#E69F00", v2 = "#56B4E9", Sales = "#000000")
            )
            expect_false(identical(input$palette.colours, settled))
            expect_identical(palette_store(), settled)

            # A colour the user actually picked still comes through.
            session$setInputs(palette.colours = c(v1 = "#123456", v2 = "#56B4E9"))
            expect_identical(palette_store(), c(v1 = "#123456", v2 = "#56B4E9"))
        }
    )
})

test_that("stats for several Y variables are computed within each variable's facet", {
    set.seed(2)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 12),
        val1 = c(rnorm(12), rnorm(12) + 3),
        val2 = c(rnorm(12), rnorm(12) - 3),
        stringsAsFactors = FALSE
    )

    long <- VizModules:::.multivar_long_df(df, c("val1", "val2"))
    stats_df <- compute_pairwise_stats(
        df = long, x = "grp", y = "var.multi",
        test = "wilcox.test", facet.by = "var.which", per.facet = TRUE
    )

    # One A-vs-B comparison per variable, each run on that variable's values only.
    expect_equal(nrow(stats_df), 2)
    expect_setequal(stats_df$facet_level, c("val1", "val2"))

    per_var <- vapply(c("val1", "val2"), function(v) {
        compute_pairwise_stats(
            df = df, x = "grp", y = v, test = "wilcox.test"
        )$p.value
    }, numeric(1))
    expect_equal(
        stats_df$p.value[match(c("val1", "val2"), stats_df$facet_level)],
        unname(per_var)
    )

    # Each variable's bracket must land on its own panel rather than stacking up
    # on the first one.
    fig <- dittoViz::yPlot(
        df,
        var = c("val1", "val2"), group.by = "grp", plots = "boxplot",
        multivar.aes = "split", do.hover = TRUE
    )
    # One panel per variable, each labelled by its column name.
    strips <- vapply(fig$x$layout$annotations, function(a) {
        if (is.null(a$text)) "" else as.character(a$text)
    }, character(1))
    expect_true(all(c("val1", "val2") %in% strips))
    stat_result <- create_stat_annotations(
        stats_df = stats_df, fig = fig, df = long,
        x = "grp", y = "var.multi", facet.by = "var.which", display = "symbol"
    )
    xrefs <- vapply(stat_result$annotations, function(a) {
        if (is.null(a$xref)) NA_character_ else a$xref
    }, character(1))
    expect_length(xrefs, 2)
    expect_equal(length(unique(xrefs)), 2)
})

test_that("the module's default hover set reproduces dittoViz's own, and a selection controls it", {
    set.seed(1)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 10),
        val = round(c(rnorm(10), rnorm(10) + 2), 4),
        lab = paste0("cell", seq_len(20)),
        stringsAsFactors = FALSE
    )
    hover_of <- function(...) {
        .yplot_hover_text(dittoViz::yPlot(df, var = "val", group.by = "grp", plots = "jitter", do.hover = TRUE, ...))
    }

    # Passing the module's reconstructed default must reproduce the package's
    # default hover content exactly, so users who never touch Hover Data see no
    # change.
    expect_identical(hover_of(hover.data = .yplot_default_hover("val", "grp", "grp")), hover_of())

    # A selection controls which columns appear, and nothing else leaks in.
    txt <- hover_of(hover.data = c("lab", "grp"))
    expect_true(all(grepl("lab:", txt, fixed = TRUE)))
    expect_true(all(grepl("grp:", txt, fixed = TRUE)))
    expect_false(any(grepl("val:", txt, fixed = TRUE)))

    # hover.round.digits rounds numeric values (e.g. "val: 1.23"), never more.
    vals <- sub(".*val: ", "", hover_of(hover.data = "val", hover.round.digits = 2))
    decimals <- ifelse(grepl(".", vals, fixed = TRUE), nchar(sub(".*[.]", "", vals)), 0L)
    expect_true(all(decimals <= 2))
})

test_that("yPlot seeds its palette from defaults", {
    df <- data.frame(
        grp = rep(c("A", "B"), each = 4),
        val = as.numeric(1:8),
        stringsAsFactors = FALSE
    )

    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(
            id = "yplot", data = shiny::reactive(df),
            defaults = list(palette.colours = c(A = "red", B = "#00FF00"))
        ),
        {
            session$setInputs(var = "val", group.by = "grp", color.by = "")
            session$flushReact()
            expect_equal(palette_store(), c(A = "#FF0000", B = "#00FF00"))
        }
    )
})

# Helper: a small frame plus the box+jitter figure the annotation helpers run on.
.yplot_jitter_fixture <- function(plots = c("boxplot", "jitter")) {
    set.seed(1)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 5),
        val = round(rnorm(10), 3),
        lab = paste0("cell", seq_len(10)),
        stringsAsFactors = FALSE
    )
    list(
        df = df,
        fig = dittoViz::yPlot(
            df, var = "val", group.by = "grp", plots = plots,
            do.hover = TRUE, hover.data = c("val", "grp", "lab")
        )
    )
}

test_that("highlighting restyles only the jitter points that match", {
    fixture <- .yplot_jitter_fixture()
    fig <- fixture$fig
    before <- fig$x$data

    out <- .apply_highlight_styling(
        fig,
        annotate.by = "lab",
        highlight_vals = c("cell1", "cell7"),
        style = list(
            color = "#00FFF7", size = 9,
            border.color = "#FF0000", border.width = 2
        ),
        default.size = 1,
        require.markers = TRUE
    )

    # The box traces carry the same data, so they must come through untouched.
    box_idx <- which(vapply(before, function(tr) identical(tr$type, "box"), logical(1)))
    expect_gt(length(box_idx), 0)
    for (i in box_idx) {
        expect_identical(out$x$data[[i]], before[[i]])
    }

    marker_idx <- setdiff(seq_along(out$x$data), box_idx)
    colors <- unlist(lapply(out$x$data[marker_idx], function(tr) tr$marker$color))
    sizes <- unlist(lapply(out$x$data[marker_idx], function(tr) tr$marker$size))
    expect_equal(sum(colors == "#00FFF7"), 2)
    expect_equal(sum(sizes == 9), 2)
    # Every other point keeps its original styling.
    expect_equal(sum(sizes != 9), 8)
})

test_that("auto-annotations label each highlighted jitter point where it is drawn", {
    fixture <- .yplot_jitter_fixture()

    annos <- .create_highlight_annotations(
        plot_data = fixture$df,
        fig = fixture$fig,
        annotate.by = "lab",
        highlight_vals = c("cell1", "cell7"),
        x_col = "grp", y_col = "val",
        annotation_params = list(
            ax = 20, ay = -20, showarrow = TRUE, arrowcolor = "black",
            arrowhead = 2, arrowwidth = 1.5, size = 10, color = "black"
        ),
        require.markers = TRUE
    )

    expect_length(annos, 2)
    expect_setequal(vapply(annos, function(a) a$text, character(1)), c("cell1", "cell7"))
    # Positions are read off the traces, so they land on the plotted values.
    expect_setequal(
        vapply(annos, function(a) a$y, numeric(1)),
        fixture$df$val[fixture$df$lab %in% c("cell1", "cell7")]
    )
})

test_that("only jitter marker traces are matched when violins are drawn", {
    fig <- .yplot_jitter_fixture(plots = c("vlnplot", "jitter"))$fig

    included <- vapply(
        fig$x$data, function(tr) .should_include_trace(tr, require.markers = TRUE), logical(1)
    )
    expect_true(any(included))
    # Violin outlines are scatter traces too, so the mode check is what excludes them.
    expect_true(all(vapply(
        fig$x$data[included], function(tr) any(grepl("markers", tr$mode)), logical(1)
    )))
    expect_true(all(vapply(
        fig$x$data[included], function(tr) length(tr$text) == length(tr$x), logical(1)
    )))
})

test_that("hand-selected and highlighted labels for the same point merge into one", {
    a <- list(x = 1, y = 2, text = "cell1")
    b <- list(x = 3, y = 4, text = "cell2")

    expect_equal(.merge_annotation_sets(list(a), list(a)), list(a))
    expect_equal(.merge_annotation_sets(list(a), list(b)), list(a, b))
    expect_equal(.merge_annotation_sets(NULL, list(b)), list(b))
    expect_equal(.merge_annotation_sets(list(a), NULL), list(a))
})

test_that("selected points are labelled even after the jitter has been re-drawn", {
    fig <- .yplot_jitter_fixture()$fig
    marker_idx <- which(vapply(
        fig$x$data, function(tr) .should_include_trace(tr, require.markers = TRUE), logical(1)
    ))
    expect_gt(length(marker_idx), 0)

    curve <- marker_idx[1]
    trace <- fig$x$data[[curve]]

    # Selecting rebuilds the plot, which re-jitters the points, so the coordinates
    # the browser reported no longer match anything in the figure being annotated.
    selected <- data.frame(
        curveNumber = curve - 1,
        pointNumber = c(0, 2),
        x = trace$x[c(1, 3)] + 0.137,
        y = trace$y[c(1, 3)]
    )

    annos <- .create_selected_annotations(
        selected_data = selected,
        fig = fig,
        annotate.by = "lab",
        annotation_params = list(
            ax = 20, ay = -20, showarrow = TRUE, arrowcolor = "black",
            arrowhead = 2, arrowwidth = 1.5, size = 10, color = "black"
        ),
        require.markers = TRUE
    )

    expect_length(annos, 2)
    expect_equal(
        vapply(annos, function(a) a$text, character(1)),
        vapply(trace$text[c(1, 3)], function(t) .extract_annotation_from_text(t, "lab"), character(1),
            USE.NAMES = FALSE
        )
    )
    # Labels sit on the points as currently drawn, not on the stale coordinates.
    expect_equal(vapply(annos, function(a) a$x, numeric(1)), trace$x[c(1, 3)])
})

test_that("a fixed seed keeps jitter positions stable across rebuilds", {
    build <- function() {
        .with_stable_seed(dittoViz::yPlot(
            data.frame(
                grp = rep(c("A", "B"), each = 5),
                val = as.numeric(1:10),
                stringsAsFactors = FALSE
            ),
            var = "val", group.by = "grp", plots = c("boxplot", "jitter"), do.hover = TRUE
        ))
    }

    jitter_x <- function(fig) {
        idx <- vapply(fig$x$data, function(tr) .should_include_trace(tr, require.markers = TRUE), logical(1))
        unlist(lapply(fig$x$data[idx], function(tr) tr$x))
    }

    expect_equal(jitter_x(build()), jitter_x(build()))
})

test_that("the y.min and y.max defaults seed the Y axis limits and survive startup", {
    df <- data.frame(
        num1 = c(1, 2, 3),
        num2 = c(4.5, 5.5, 6.5),
        cat1 = c("a", "b", "c"),
        stringsAsFactors = FALSE
    )
    defaults <- list(var = "num1", group.by = "cat1", y.min = -5, y.max = 50)

    html <- as.character(dittoViz_yPlotInputsUI("yplot", df, defaults = defaults))
    expect_match(html, 'id="yplot-y\\.max"[^>]*value="50"')
    expect_match(html, 'id="yplot-y\\.min"[^>]*value="-5"')

    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(id = "yplot", data = shiny::reactive(df), defaults = defaults),
        {
            # The first var is the one the limits were given for, so they stand...
            suppressWarnings(session$setInputs(var = "num1"))
            expect_equal(y_range_store()$max, 50)
            expect_equal(y_range_store()$min, -5)

            # ...and a new var gets limits from its own data.
            suppressWarnings(session$setInputs(var = "num2"))
            expect_equal(y_range_store()$max, 6.5 * .y_axis_scale_factor)
        }
    )
})

# --- Driving the module's own build ------------------------------------------

# The plot output cannot be driven from testServer, but the reactive that builds
# the figure can, given a complete set of inputs.
.yplot_inputs <- function(...) {
    base <- list(
        var = "salary", group.by = "job_level", color.by = "", shape.by = "", split.by = "",
        plots = c("boxplot", "jitter"), var.adjustment = "", var.adj.fxn = "",
        y.min = NA, y.max = NA, auto.update = TRUE, update = 0,
        multivar.aes = "split", multivar.split.dir = "col",
        split.adjust = "fixed", split.ncol = NA, split.nrow = NA,
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        do.raster = FALSE, raster.dpi = 600,
        jitter.size = 1, jitter.width = 0.2, jitter.color = "#000000",
        jitter.shape.legend.size = 5, jitter.shape.legend.show = TRUE,
        boxplot.show.outliers = FALSE, boxplot.color = "#000000", boxplot.fill = TRUE,
        boxplot.lineweight = 0.5, boxgap = 0.3, boxgroupgap = 0.2,
        vlnplot.lineweight = 0.5, vlnplot.scaling = "area",
        ridgeplot.lineweight = 0.5, ridgeplot.scale = 1.25, ridgeplot.ymax.expansion = NA,
        ridgeplot.shape = "smooth", ridgeplot.bins = 30, ridgeplot.binwidth = NA,
        hover.data = "", hover.round.digits = 5,
        stats.enabled = FALSE, stat.test = "t.test", stat.p.adjust = "none",
        stat.display = "p.adj", stat.sig.threshold = 0.05, stat.hide.ns = FALSE,
        stat.paired = FALSE, stat.pairs = "", stat.per.facet = TRUE,
        stat.bracket.style = "capped", stat.bracket.inset = 0.025,
        stat.step.increase = 0.06, stat.text.bump = 0.04,
        stat.line.color = "#000000", stat.line.width = 1,
        annotate.by = "", highlight.points = "", highlight.auto.annotate = TRUE,
        highlight.color = "#00FFF7", highlight.size = 7,
        highlight.border.color = "#000000", highlight.border.width = 1,
        annotation.color = "black", annotation.ax = 20, annotation.ay = -20,
        annotation.size = 10, annotation.showarrow = TRUE,
        annotation.arrowcolor = "black", annotation.arrowhead = 2, annotation.arrowwidth = 1.5,
        download.format = "png", legend.title.size = 14, legend.text.size = 12,
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        grid.color = "#CCCCCC", axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 14,
        facet.title.font.color = "black", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "", abline.intercepts = "",
        shape.fill = "rgba(0, 0, 0, 0)", shape.line.color = "black", shape.line.width = 4,
        shape.linetype = "solid", shape.opacity = 1,
        margin.l = 80, margin.r = 80, margin.t = 80, margin.b = 80
    )
    utils::modifyList(base, list(...))
}

# Start the module on `inputs` and settle it. Selecting comparisons freezes
# stat.pairs and repopulates it; the mock session never echoes that back, so the
# echo is supplied by hand.
.yplot_settle <- function(session, inputs) {
    suppressWarnings({
        do.call(session$setInputs, inputs)
        session$flushReact()
        session$setInputs(stat.pairs = "")
        session$flushReact()
    })
}

test_that("significance brackets are tested on and drawn over the plotted values (#319)", {
    df <- example_demographics
    # One session each: the mock session never echoes the controls the server
    # updates, so a second variant in the same session would wait on them.
    for (adj in list(
        c("", ""), c("z-score", ""), c("relative.to.max", ""),
        c("", "log10"), c("", "neg_log10"), c("relative.to.max", "sqrt")
    )) {
        info <- paste("adjustment:", toString(adj))
        shiny::testServer(
            dittoViz_yPlotServer,
            args = list(id = "yplot", data = shiny::reactive(df)),
            {
                .yplot_settle(session, .yplot_inputs(
                    stats.enabled = TRUE, var.adjustment = adj[1], var.adj.fxn = adj[2]
                ))
                fig <- suppressWarnings(generate_yPlot())
                expect_brackets_within_axes(fig, min.count = 6)

                # The tests ran on the values drawn, not the raw column: t-test
                # p-values change under a rescaling or a log.
                plotted <- VizModules:::.adjusted_values(df$salary, adj[1], adj[2])
                stats_df <- last_stats_df()
                for (i in seq_len(nrow(stats_df))) {
                    a <- plotted[as.character(df$job_level) == stats_df$group1[i]]
                    b <- plotted[as.character(df$job_level) == stats_df$group2[i]]
                    expect_equal(stats_df$p.value[i], stats::t.test(a, b)$p.value,
                        tolerance = 1e-8, info = info)
                }
            }
        )
    }
})

test_that("the adjustment function is applied before the z-score, so every point is drawn", {
    # z-scoring first and then taking log10 made every below-average salary the
    # log of a negative number: those points vanished, the limits came from what
    # was left, and a label for one of them (E137) floated off in empty space.
    df <- example_demographics
    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(id = "yplot", data = shiny::reactive(df)),
        {
            .yplot_settle(session, .yplot_inputs(
                group.by = "job_level", color.by = "department", split.by = "gender",
                var.adjustment = "z-score", var.adj.fxn = "log10", stats.enabled = TRUE,
                stat.hide.ns = TRUE, annotate.by = "employee_id", highlight.points = "E042, E137"
            ))
            fig <- suppressWarnings(generate_yPlot())
            built <- expect_brackets_within_axes(fig)
            expect_point_labels_on_points(fig, min.count = 2)

            # Every salary is drawn, as its z-scored log.
            expected <- as.numeric(scale(log10(df$salary)))
            jitter_y <- unlist(lapply(built$x$data, function(tr) {
                if (.should_include_trace(tr, require.markers = TRUE)) tr$y
            }))
            expect_length(jitter_y, nrow(df))
            expect_true(all(is.finite(jitter_y)))
            expect_equal(range(jitter_y), range(expected))

            titles <- vapply(built$x$layout$annotations, function(a) a$text %||% "", character(1))
            expect_true("z-score(log10(salary))" %in% titles)
        }
    )
})

test_that("points the adjustment leaves undrawable get no label", {
    df <- data.frame(
        grp = rep(c("A", "B"), each = 5),
        value = c(-3, 1, 2, 3, 4, -1, 5, 6, 7, 8),
        id = paste0("p", 1:10),
        stringsAsFactors = FALSE
    )
    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(id = "yplot", data = shiny::reactive(df)),
        {
            # log10 of p1's -3 is NaN, so p1 is not drawn; p2 is.
            .yplot_settle(session, .yplot_inputs(
                var = "value", group.by = "grp", var.adj.fxn = "log10",
                annotate.by = "id", highlight.points = "p1, p2"
            ))
            labels <- expect_point_labels_on_points(suppressWarnings(generate_yPlot()))
            expect_equal(vapply(labels, function(a) a$text, character(1)), "p2")
        }
    )
})

test_that("the Y Axis limits follow the Y adjustment and are applied in its units", {
    df <- example_demographics
    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(id = "yplot", data = shiny::reactive(df)),
        {
            suppressWarnings({
                do.call(session$setInputs, .yplot_inputs())
                session$flushReact()
            })
            expect_equal(y_range_store()$max, max(df$salary) * .y_axis_scale_factor)

            suppressWarnings(session$setInputs(var.adj.fxn = "log10"))
            expect_equal(y_range_store()$min, log10(min(df$salary)))
            expect_equal(y_range_store()$max, log10(max(df$salary)) * .y_axis_scale_factor)

            # The limits reach the plot rather than being dropped for the adjustment.
            built <- plotly::plotly_build(suppressWarnings(generate_yPlot()))
            shown <- unlist(built$x$layout$yaxis$range)
            expect_lt(shown[2], log10(max(df$salary)) * .y_axis_scale_factor * 1.1)
            expect_gt(shown[2], log10(max(df$salary)))
        }
    )
})

test_that("under a free y facet scale each panel's brackets sit on its own data", {
    set.seed(7)
    df <- data.frame(
        grp = rep(rep(c("A", "B"), each = 10), 2),
        panel = rep(c("small", "large"), each = 20),
        value = c(rnorm(10, 5), rnorm(10, 7), rnorm(10, 500, 20), rnorm(10, 700, 20)),
        stringsAsFactors = FALSE
    )
    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(id = "yplot", data = shiny::reactive(df)),
        {
            .yplot_settle(session, .yplot_inputs(
                var = "value", group.by = "grp", split.by = "panel", split.adjust = "free_y",
                stats.enabled = TRUE
            ))
            built <- expect_brackets_within_axes(suppressWarnings(generate_yPlot()), min.count = 2)

            # The small panel keeps its own scale, brackets included.
            tops <- vapply(c("yaxis", "yaxis2"), function(a) max(unlist(built$x$layout[[a]]$range)), numeric(1))
            expect_lt(min(tops), 50)
            expect_gt(max(tops), 700)
        }
    )
})

test_that("no brackets are drawn once a ridge plot puts the values on the x-axis", {
    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(id = "yplot", data = shiny::reactive(example_demographics)),
        {
            .yplot_settle(session, .yplot_inputs(plots = c("boxplot", "ridgeplot"), stats.enabled = TRUE))
            built <- plotly::plotly_build(suppressWarnings(generate_yPlot()))

            brackets <- Filter(function(s) identical(s$type, "line") && .data_ref(s$yref), built$x$layout$shapes)
            expect_length(brackets, 0)
            # The tests still run, for the source download.
            expect_s3_class(last_stats_df(), "data.frame")
            expect_gt(nrow(last_stats_df()), 0)
        }
    )
})

test_that("the Legend tab hides the legend and sets its font (#360, #362)", {
    # One session each, as above.
    for (show in c(TRUE, FALSE)) {
        shiny::testServer(
            dittoViz_yPlotServer,
            args = list(id = "yplot", data = shiny::reactive(example_demographics)),
            {
                .yplot_settle(session, .yplot_inputs(
                    legend.show = show, legend.font.family = "Courier New", legend.font.color = "#FF0000"
                ))
                lay <- suppressWarnings(generate_yPlot())$x$layout
                expect_equal(isFALSE(lay$showlegend), !show, info = show)
                expect_equal(lay$legend$font$family, "Courier New", info = show)
                expect_equal(lay$legend$font$color, "#FF0000", info = show)
            }
        )
    }
})
