## Helper to create mock plotly objects for testing
make_plotly <- function(data = list(), layout = list()) {
    fig <- list(x = list(data = data, layout = layout))
    class(fig) <- "plotly"
    fig
}

# ─── .hide_jitter_from_legend ─────────────────────────────────────────────────

test_that(".hide_jitter_from_legend hides only scatter marker traces", {
    fig <- make_plotly(data = list(
        list(type = "box", showlegend = TRUE, name = "Group A"),
        list(type = "box", showlegend = TRUE, name = "Group B"),
        list(type = "scatter", mode = "markers", showlegend = TRUE, name = "Jitter A"),
        list(type = "scatter", mode = "markers", showlegend = TRUE, name = "Jitter B"),
        list(type = "scatter", mode = "lines", showlegend = TRUE, name = "Line"),
        list(showlegend = TRUE, name = "No Type")
    ))

    result <- VizModules:::.hide_jitter_from_legend(fig)

    expect_s3_class(result, "plotly")
    expect_equal(
        vapply(result$x$data, function(tr) tr$showlegend, logical(1)),
        c(TRUE, TRUE, FALSE, FALSE, TRUE, TRUE)
    )
    expect_length(VizModules:::.hide_jitter_from_legend(make_plotly(data = list()))$x$data, 0)
})

test_that(".hide_jitter_from_legend rejects non-plotly objects", {
    expect_error(
        VizModules:::.hide_jitter_from_legend(list(x = list(data = list()))),
        "plotly"
    )
})

test_that(".hide_jitter_from_legend with mtcars dataset", {
    p <- plotthis::BoxPlot(
        data = data.frame(
            x = factor(mtcars$cyl), y = mtcars$mpg, group = factor(mtcars$vs)
        ),
        x = "x", y = "y", group_by = "group", add_point = TRUE
    )
    fig <- plotly::ggplotly(p)
    result <- VizModules:::.hide_jitter_from_legend(fig)

    box_traces <- sum(vapply(result$x$data, function(t) {
        !is.null(t$type) && t$type == "box"
    }, logical(1)))
    scatter_markers <- sum(vapply(result$x$data, function(t) {
        !is.null(t$type) && t$type == "scatter" && !is.null(t$mode) && t$mode == "markers"
    }, logical(1)))

    expect_gt(box_traces, 0)
    expect_gt(scatter_markers, 0)

    for (trace in result$x$data) {
        if (!is.null(trace$type) && trace$type == "scatter" &&
            !is.null(trace$mode) && trace$mode == "markers") {
            expect_false(trace$showlegend)
        }
        if (!is.null(trace$type) && trace$type == "box") {
            expect_true(trace$showlegend)
        }
    }
})

# ─── .align_box_positions ───────────────────────────────────────

# "blood" carries all three groups, the other two only A and B. This uneven
# coverage is what #356 is about: ggplot dodges two slots at lung/liver while
# plotly.js reserves three everywhere.
.uneven_group_data <- function(seed = 42) {
    withr::with_seed(seed, {
        df <- rbind(
            data.frame(tissue = "blood", grp = rep(c("A", "B", "C"), each = 8)),
            data.frame(tissue = "lung", grp = rep(c("A", "B"), each = 8)),
            data.frame(tissue = "liver", grp = rep(c("A", "B"), each = 8))
        )
        df$val <- rnorm(nrow(df))
        df$tissue <- factor(df$tissue, levels = c("blood", "lung", "liver"))
        df$grp <- factor(df$grp, levels = c("A", "B", "C"))
        df
    })
}

# The grouped box figure over that data, built once and shared.
.uneven_box_fig <- local({
    fig <- NULL
    function() {
        if (is.null(fig)) {
            fig <<- plotly::ggplotly(plotthis::BoxPlot(
                .uneven_group_data(),
                x = "tissue", y = "val", group_by = "grp"
            ))
        }
        fig
    }
})

# The x each box trace sits at, one entry per distinct position, named by trace.
.box_trace_positions <- function(fig) {
    out <- list()
    for (trace in fig$x$data) {
        if (is.null(trace$type) || trace$type != "box") next
        out[[trace$name]] <- sort(unique(as.numeric(trace$x)))
    }
    out
}

test_that(".align_box_positions dodges only the groups present at each x", {
    fig <- .uneven_box_fig()

    # Before: every box trace still carries the raw category index.
    expect_equal(.box_trace_positions(fig)$A, c(1, 2, 3))

    result <- VizModules:::.align_box_positions(fig, dodge.width = 1, box.width = 0.8)
    pos <- .box_trace_positions(result)

    # blood splits three ways, lung and liver two.
    expect_equal(pos$A, c(1 - 1 / 3, 2 - 0.25, 3 - 0.25), tolerance = 1e-8)
    expect_equal(pos$B, c(1, 2 + 0.25, 3 + 0.25), tolerance = 1e-8)
    expect_equal(pos$C, 1 + 1 / 3, tolerance = 1e-8)
    expect_equal(result$x$layout$boxmode, "overlay")
})

test_that(".align_box_positions puts boxes over their jitter points (#356)", {
    fig <- plotly::ggplotly(plotthis::BoxPlot(
        .uneven_group_data(),
        x = "tissue", y = "val", group_by = "grp", add_point = TRUE
    ))
    result <- VizModules:::.align_box_positions(
        fig,
        dodge.width = VizModules:::.PLOTTHIS_DODGE_WIDTH, box.width = 0.8
    )

    # Jitter traces were never moved, so their clusters are ggplot's own
    # positions. Every box has to sit at the centre of the matching cluster.
    for (trace in result$x$data) {
        if (is.null(trace$type) || trace$type != "scatter") next
        if (is.null(trace$mode) || trace$mode != "markers") next

        boxes <- .box_trace_positions(result)[[trace$name]]
        expect_false(is.null(boxes))
        cluster <- vapply(as.numeric(trace$x), function(v) boxes[which.min(abs(boxes - v))], numeric(1))
        centres <- vapply(split(as.numeric(trace$x), cluster), mean, numeric(1))

        expect_equal(as.numeric(centres), as.numeric(names(centres)),
            tolerance = 0.05,
            info = sprintf("jitter cluster centres for group %s", trace$name)
        )
    }
})

test_that(".align_box_positions scales offsets with dodge.width and sets width", {
    fig <- .uneven_box_fig()

    wide <- VizModules:::.align_box_positions(fig, dodge.width = 1, box.width = 0.8)
    narrow <- VizModules:::.align_box_positions(fig, dodge.width = 0.5, box.width = 0.8)

    # Halving the dodge halves every offset from the category centre.
    expect_equal(
        .box_trace_positions(narrow)$A - c(1, 2, 3),
        (.box_trace_positions(wide)$A - c(1, 2, 3)) / 2,
        tolerance = 1e-8
    )

    # One width for the whole figure, taken from the most crowded x position.
    widths <- vapply(
        Filter(function(tr) identical(tr$type, "box"), wide$x$data),
        function(tr) tr$width, numeric(1)
    )
    expect_equal(unname(widths), rep(1 / 3 * 0.8, 3), tolerance = 1e-8)
})

test_that(".align_box_positions leaves boxes centred when there is no grouping", {
    df <- .uneven_group_data()
    fig <- plotly::ggplotly(plotthis::BoxPlot(df, x = "tissue", y = "val"))
    result <- VizModules:::.align_box_positions(fig, dodge.width = 1, box.width = 0.8)

    # Ungrouped, plotthis emits one box trace per x category, so every position
    # has a single occupant and nothing should be dodged off the tick.
    positions <- sort(unlist(lapply(result$x$data, function(trace) {
        if (is.null(trace$type) || trace$type != "box") NULL else unique(as.numeric(trace$x))
    })))
    expect_equal(positions, c(1, 2, 3), tolerance = 1e-8)
})

test_that(".align_box_positions is a no-op without box traces", {
    fig <- make_plotly(data = list(
        list(type = "scatter", mode = "markers", x = c(1, 2, 3))
    ))
    result <- VizModules:::.align_box_positions(fig, dodge.width = 1)
    expect_equal(result$x$data[[1]]$x, c(1, 2, 3))
    expect_null(result$x$layout$boxmode)
})

test_that(".align_box_positions rejects non-plotly objects", {
    expect_error(VizModules:::.align_box_positions(list(), dodge.width = 1))
})

# A facet grid more than one row deep, with the x scale left fixed. ggplotly
# shares one x axis down each facet column then, so a panel is only identified by
# its (xaxis, yaxis) pair -- keying on the x axis alone merges the panels stacked
# in a column and invents dodge slots ggplot2 never used.
.faceted_uneven_fig <- function(add_point = FALSE, ncol = 2) {
    df <- .uneven_group_data()
    # Group C lands in panel p1 only, so that panel mixes a three-way position
    # with two-way ones while the others are two-way throughout.
    df <- do.call(rbind, lapply(paste0("p", 1:4), function(p) transform(df, panel = p)))
    df <- df[!(df$grp == "C" & df$panel != "p1"), ]
    plotly::ggplotly(plotthis::BoxPlot(
        df,
        x = "tissue", y = "val", group_by = "grp",
        facet_by = "panel", facet_ncol = ncol, add_point = add_point
    ))
}

# The (xaxis, yaxis) pair of every box trace, as .align_box_positions keys them.
.box_panel_keys <- function(fig) {
    vapply(
        Filter(function(tr) identical(tr$type, "box"), fig$x$data),
        function(tr) paste0(tr$xaxis %||% "x", "|", tr$yaxis %||% "y"),
        character(1)
    )
}

test_that(".align_box_positions treats a shared x axis as several panels", {
    fig <- .faceted_uneven_fig()

    # The condition the bug needed: fewer x axes than panels, because the x scale
    # is fixed. Without this the test would pass on the old xaxis-only keying.
    axes <- vapply(
        Filter(function(tr) identical(tr$type, "box"), fig$x$data),
        function(tr) tr$xaxis %||% "x", character(1)
    )
    expect_lt(length(unique(axes)), length(unique(.box_panel_keys(fig))))

    result <- VizModules:::.align_box_positions(fig, dodge.width = 1, box.width = 0.8)
    boxes <- Filter(function(tr) identical(tr$type, "box"), result$x$data)
    keys <- .box_panel_keys(result)

    # Each panel dodges on its own, so the three panels without group C put their
    # boxes on two slots at every position -- including "blood", which splits
    # three ways in p1. Keyed on the x axis the two panels sharing it would have
    # collided into one four-way position.
    for (k in unique(keys)) {
        xs <- unlist(lapply(boxes[keys == k], function(tr) unique(as.numeric(tr$x))))
        for (p in unique(round(xs))) {
            here <- sort(xs[round(xs) == p] - p)
            n <- length(here)
            expect_equal(here, (seq_len(n) - 0.5) / n - 0.5,
                tolerance = 1e-8,
                info = sprintf("panel %s, position %s", k, p)
            )
        }
    }

    occupancy <- vapply(unique(keys), function(k) {
        xs <- unlist(lapply(boxes[keys == k], function(tr) unique(as.numeric(tr$x))))
        max(table(round(xs)))
    }, numeric(1))
    expect_equal(sort(unname(occupancy)), c(2, 2, 2, 3))

    # Panels differ in occupancy, but plotly takes one width per trace, so every
    # box is sized from the most crowded position anywhere in the figure rather
    # than its own panel's.
    widths <- vapply(boxes, function(tr) tr$width, numeric(1))
    expect_equal(unname(widths), rep(1 / 3 * 0.8, length(widths)), tolerance = 1e-8)
})

test_that(".align_box_positions puts boxes over their jitter across facet rows", {
    result <- VizModules:::.align_box_positions(
        .faceted_uneven_fig(add_point = TRUE),
        dodge.width = VizModules:::.PLOTTHIS_DODGE_WIDTH, box.width = 0.8
    )

    # Jitter traces were never moved, so their clusters are ggplot's own
    # positions. Match each box to the points of the same group in the same
    # panel: with a shared x axis the group name alone spans several panels.
    boxes <- Filter(function(tr) identical(tr$type, "box"), result$x$data)
    keys <- .box_panel_keys(result)

    checked <- 0
    for (trace in result$x$data) {
        if (is.null(trace$type) || trace$type != "scatter") next
        if (is.null(trace$mode) || trace$mode != "markers") next

        key <- paste0(trace$xaxis %||% "x", "|", trace$yaxis %||% "y")
        mine <- boxes[keys == key & vapply(boxes, function(tr) {
            identical(as.character(tr$name), as.character(trace$name))
        }, logical(1))]
        if (length(mine) == 0) next

        pos <- sort(unique(unlist(lapply(mine, function(tr) as.numeric(tr$x)))))
        x <- as.numeric(trace$x)
        cluster <- vapply(x, function(v) pos[which.min(abs(pos - v))], numeric(1))
        centres <- vapply(split(x, cluster), mean, numeric(1))

        expect_equal(as.numeric(centres), as.numeric(names(centres)),
            tolerance = 0.05,
            info = sprintf("jitter centres for group %s in panel %s", trace$name, key)
        )
        checked <- checked + 1
    }
    expect_gt(checked, 0)
})

test_that(".align_box_positions leaves a categorical x axis alone", {
    fig <- make_plotly(data = list(
        list(type = "box", x = c("a", "a", "b"), y = c(1, 2, 3))
    ))
    result <- VizModules:::.align_box_positions(fig, dodge.width = 1, box.width = 0.8)

    # Nothing was repositioned, so plotly.js must keep doing the dodge itself --
    # switching to "overlay" here would stack the boxes on the tick.
    expect_equal(result$x$data[[1]]$x, c("a", "a", "b"))
    expect_null(result$x$data[[1]]$width)
    expect_null(result$x$layout$boxmode)
})

test_that(".box_num falls back when a numeric control is blank", {
    expect_equal(VizModules:::.box_num(0.4, 0.3), 0.4)
    expect_equal(VizModules:::.box_num(NA_real_, 0.3), 0.3)
    expect_equal(VizModules:::.box_num(NULL, 0.3), 0.3)
    expect_equal(VizModules:::.box_num(c(1, 2), 0.3), 0.3)
    expect_equal(VizModules:::.box_num("x", 0.3), 0.3)
})

# ─── parse_numeric_list ──────────────────────────────────────────────────────

test_that("parse_numeric_list parses comma-separated numbers, dropping the rest", {
    expect_equal(VizModules::parse_numeric_list("1, 5, 8"), c(1, 5, 8))
    expect_equal(VizModules::parse_numeric_list("3.14"), 3.14)
    expect_equal(VizModules::parse_numeric_list("-1, 0, 2.5"), c(-1, 0, 2.5))
    expect_equal(VizModules::parse_numeric_list("1, abc, 3"), c(1, 3))
    for (none in list(NULL, "", "   ", "abc, def")) {
        expect_null(VizModules::parse_numeric_list(none))
    }
})

# ─── recycle_line_style ──────────────────────────────────────────────────────

test_that("recycle_line_style defaults, keeps a matching length, and recycles the first value otherwise", {
    expect_equal(VizModules::recycle_line_style(NULL, 3, "red"), rep("red", 3))
    expect_equal(VizModules::recycle_line_style(character(0), 2, 1), rep(1, 2))
    expect_equal(VizModules::recycle_line_style(c("a", "b", "c"), 3, "x"), c("a", "b", "c"))
    expect_equal(VizModules::recycle_line_style(c("a", "b"), 4, "x"), rep("a", 4))
    expect_equal(VizModules::recycle_line_style(c(1, 2, 3), 2, 0), rep(1, 2))
})

# ─── linetype_to_dash ───────────────────────────────────────────────────────

test_that("linetype_to_dash maps every linetype, case-insensitively, defaulting to solid", {
    map <- c(
        solid = "solid", dashed = "dash", dotted = "dot", dotdash = "dashdot",
        longdash = "longdash", twodash = "longdashdot",
        SOLID = "solid", Dashed = "dash", unknown = "solid"
    )
    for (lt in names(map)) {
        expect_equal(VizModules::linetype_to_dash(lt), map[[lt]], info = lt)
    }
})

# ─── adjust_column_values ───────────────────────────────────────────────────

test_that("adjust_column_values applies a transform per axis", {
    result <- VizModules::adjust_column_values(data.frame(x = c(1, 2, 4, 8)), x.col = "x", x.adj.fun = "log2")
    expect_equal(result$x.adj, c(0, 1, 2, 3))

    result <- VizModules::adjust_column_values(
        data.frame(x = c(1, 10, 100), y = c(2, 4, 8)),
        x.col = "x", y.col = "y", x.adj.fun = "log10", y.adj.fun = "sqrt"
    )
    expect_equal(result$x.adj, c(0, 1, 2))
    expect_equal(result$y.adj, sqrt(c(2, 4, 8)))
})

test_that("adjust_column_values returns df unchanged for no, invalid or non-numeric input", {
    df <- data.frame(x = 1:3)
    for (fun in list(NULL, "")) {
        expect_identical(VizModules::adjust_column_values(df, x.col = "x", x.adj.fun = fun), df)
    }
    expect_warning(
        expect_identical(VizModules::adjust_column_values(df, x.col = "x", x.adj.fun = "{{invalid"), df),
        "Unrecognized adjustment function"
    )
    chr <- data.frame(x = letters[1:3], stringsAsFactors = FALSE)
    expect_false("x.adj" %in% names(VizModules::adjust_column_values(chr, x.col = "x", x.adj.fun = "log2")))
    expect_false("x.adj" %in% names(VizModules::adjust_column_values(chr, x.col = "x", x.adjustment = "z-score")))
})

test_that("adjust_column_values applies the function, then rescales, as the modules do", {
    df <- data.frame(x = c(2, 4, 8), y = c(1, 2, 3))
    z <- VizModules::adjust_column_values(df, x.col = "x", x.adjustment = "z-score")
    expect_equal(z$x.adj, as.numeric(scale(df$x)))

    rel <- VizModules::adjust_column_values(df, y.col = "y", y.adjustment = "relative.to.max", y.adj.fun = "log2")
    expect_equal(rel$y.adj, log2(df$y) / log2(3))

    # Blank adjustments leave the frame alone.
    expect_identical(VizModules::adjust_column_values(df, x.col = "x", x.adjustment = ""), df)
})

# ─── add_plot_config ────────────────────────────────────────────────────────

test_that("add_plot_config builds its defaults, download options and modebar", {
    config <- VizModules::add_plot_config()
    # Axis titles are rendered as draggable annotations, so native axis-title
    # text editing is disabled even in the non-faceted configuration.
    expect_false(config$edits$axisTitleText)
    expect_true(config$edits$titleText)
    expect_false(config$displaylogo)
    expect_equal(config$toImageButtonOptions$format, "png")
    expect_true(length(config$modeBarButtonsToAdd) > 0)

    config <- VizModules::add_plot_config(download.format = "svg", filename = "my_plot")
    expect_equal(config$toImageButtonOptions$format, "svg")
    expect_equal(config$toImageButtonOptions$filename, "my_plot")

    expect_null(VizModules::add_plot_config(include.modebar.buttons = FALSE)$modeBarButtonsToAdd)
})

test_that("add_plot_config only treats a real facet selection as faceted", {
    for (facet in list(TRUE, "group", c("", "var.which"))) {
        config <- VizModules::add_plot_config(facet.by = facet)
        expect_false(config$edits$axisTitleText)
        # The empty title's "Click to enter Plot title" placeholder overlaps the facet titles.
        expect_false(config$edits$titleText)
        expect_true(config$edits$annotationText)
        expect_true(config$edits$annotationPosition)
    }
    for (facet in list(NULL, FALSE, "", character(0))) {
        expect_true(VizModules::add_plot_config(facet.by = facet)$edits$titleText)
    }
})

# ─── apply_subplot_axis_styling ─────────────────────────────────────────────

test_that("apply_subplot_axis_styling passes through a NULL, axis-less or empty-layout figure", {
    expect_null(VizModules::apply_subplot_axis_styling(NULL, list(), list()))

    fig_no_x <- list(y = 1)
    expect_identical(VizModules::apply_subplot_axis_styling(fig_no_x, list(), list()), fig_no_x)

    result <- VizModules::apply_subplot_axis_styling(make_plotly(layout = list()), list(a = 1), list(b = 2))
    expect_s3_class(result, "plotly")
})

test_that("apply_subplot_axis_styling styles every subplot axis, keeping their properties", {
    fig <- make_plotly(layout = list(
        xaxis = list(title = "X1"),
        xaxis2 = list(title = "X2"),
        yaxis = list(title = "Y1"),
        yaxis2 = list(title = "Y2")
    ))

    result <- VizModules::apply_subplot_axis_styling(
        fig,
        xaxis_style = list(linecolor = "red", showgrid = FALSE),
        yaxis_style = list(linecolor = "blue")
    )

    # plotly::layout() stores updates in layoutAttrs; only the styling is queued
    layout_update <- result$x$layoutAttrs[[1]]
    expect_equal(layout_update$xaxis$linecolor, "red")
    expect_equal(layout_update$xaxis2$linecolor, "red")
    expect_false(layout_update$xaxis2$showgrid)
    expect_equal(layout_update$yaxis$linecolor, "blue")
    expect_equal(layout_update$yaxis2$linecolor, "blue")
    expect_null(layout_update$xaxis$title)

    # Existing properties are preserved once the figure is built
    real <- plotly::plotly_build(
        plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "markers") |>
            plotly::layout(xaxis = list(title = "X1"), yaxis = list(title = "Y1"))
    )
    built <- plotly::plotly_build(
        VizModules::apply_subplot_axis_styling(real, list(linecolor = "red"), list(linecolor = "blue"))
    )
    expect_equal(built$x$layout$xaxis$title, "X1")
    expect_equal(built$x$layout$yaxis$title, "Y1")
    expect_equal(built$x$layout$xaxis$linecolor, "red")
    expect_equal(built$x$layout$yaxis$linecolor, "blue")
})

test_that("apply_subplot_axis_styling does not revert layout written after it", {
    # The styling used to queue a copy of each whole axis, which at build time
    # overwrote any range written since -- e.g. the raise that makes room for
    # significance brackets (#319).
    fig <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "markers") |>
        plotly::layout(yaxis = list(range = c(0, 4)))
    fig <- plotly::plotly_build(fig)

    styled <- VizModules::apply_subplot_axis_styling(fig, list(showgrid = FALSE), list(showgrid = FALSE))
    styled$x$layout$yaxis$range <- c(0, 10)
    built <- plotly::plotly_build(styled)

    expect_equal(built$x$layout$yaxis$range, c(0, 10))
    expect_false(built$x$layout$yaxis$showgrid)
})

test_that("apply_subplot_axis_styling leaves a property alone when its style is NULL", {
    fig <- plotly::plotly_build(
        plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "markers") |>
            plotly::layout(yaxis = list(title = list(text = "Y", font = list(size = 14))))
    )
    styled <- VizModules::apply_subplot_axis_styling(
        fig, list(), list(title = list(font = list(size = NULL, color = "red")))
    )
    built <- plotly::plotly_build(styled)
    expect_equal(built$x$layout$yaxis$title$font$size, 14)
    expect_equal(built$x$layout$yaxis$title$font$color, "red")
    expect_equal(built$x$layout$yaxis$title$text, "Y")
})

# ─── axis_titles_as_annotations ─────────────────────────────────────────────

test_that("axis_titles_as_annotations converts single-panel titles to annotations", {
    fig <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "lines") |>
        plotly::layout(xaxis = list(title = "Weight"), yaxis = list(title = "MPG"))

    result <- VizModules::axis_titles_as_annotations(fig)
    built <- plotly::plotly_build(result)

    ann_text <- vapply(built$x$layout$annotations, function(a) a$text, character(1))
    expect_true("Weight" %in% ann_text)
    expect_true("MPG" %in% ann_text)

    # Native axis titles cleared so they do not render twice
    expect_identical(built$x$layout$xaxis$title$text, "")
    expect_identical(built$x$layout$yaxis$title$text, "")

    # Annotations are paper-anchored and the y title is rotated
    x_ann <- Filter(function(a) identical(a$text, "Weight"), built$x$layout$annotations)[[1]]
    y_ann <- Filter(function(a) identical(a$text, "MPG"), built$x$layout$annotations)[[1]]
    expect_identical(x_ann$xref, "paper")
    expect_identical(x_ann$yref, "paper")
    expect_equal(y_ann$textangle, -90)
})

test_that("axis_titles_as_annotations preserves the native axis title font", {
    fig <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter") |>
        plotly::layout(
            xaxis = list(title = list(text = "Cyl", font = list(size = 18, color = "red"))),
            yaxis = list(title = list(text = "MPG", font = list(size = 18)))
        )

    built <- plotly::plotly_build(VizModules::axis_titles_as_annotations(fig))
    x_ann <- Filter(function(a) identical(a$text, "Cyl"), built$x$layout$annotations)[[1]]
    expect_equal(x_ann$font$size, 18)
    expect_equal(x_ann$font$color, "red")
})

test_that("axis_titles_as_annotations preserves pre-existing annotations", {
    fig <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter") |>
        plotly::layout(
            xaxis = list(title = "X"), yaxis = list(title = "Y"),
            annotations = list(list(x = 1, y = 1, text = "stat", showarrow = FALSE))
        )

    built <- plotly::plotly_build(VizModules::axis_titles_as_annotations(fig))
    ann_text <- vapply(built$x$layout$annotations, function(a) a$text, character(1))
    expect_true(all(c("stat", "X", "Y") %in% ann_text))
})

test_that("axis_titles_as_annotations leaves multi-panel figures unchanged", {
    # A subplot figure has secondary axes (xaxis2/yaxis2); its shared titles
    # are already draggable annotations, so the helper must not alter it.
    fig <- plotly::plotly_build(plotly::subplot(
        plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter"),
        plotly::plot_ly(x = 1:3, y = 3:1, type = "scatter"),
        nrows = 1
    ))
    n_before <- length(fig$x$layout$annotations)
    result <- VizModules::axis_titles_as_annotations(fig)
    expect_equal(length(result$x$layout$annotations), n_before)
})

test_that("axis_titles_as_annotations is a no-op without axis titles or a figure", {
    fig <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter")
    built <- plotly::plotly_build(VizModules::axis_titles_as_annotations(fig))
    expect_null(built$x$layout$annotations)
    expect_null(VizModules::axis_titles_as_annotations(NULL))
})


# ─── apply_legend_styling ───────────────────────────────────────────────────

test_that("apply_legend_styling sets legend title and text font sizes", {
    fig <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "lines")
    built <- plotly::plotly_build(
        VizModules::apply_legend_styling(fig, title.size = 20, text.size = 9)
    )
    expect_equal(built$x$layout$legend$font$size, 9)
    expect_equal(built$x$layout$legend$title$font$size, 20)
})

test_that("apply_legend_styling ignores NULL/NA sizes", {
    fig <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter")
    # Both NULL -> figure returned unchanged (no legend args added).
    expect_identical(
        VizModules::apply_legend_styling(fig, title.size = NULL, text.size = NULL),
        fig
    )
    # Only text.size supplied -> title font untouched.
    built <- plotly::plotly_build(
        VizModules::apply_legend_styling(fig, text.size = 11)
    )
    expect_equal(built$x$layout$legend$font$size, 11)
    expect_null(built$x$layout$legend$title$font$size)

    expect_null(VizModules::apply_legend_styling(NULL, title.size = 12))
})

test_that("apply_legend_styling preserves existing legend position", {
    fig <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter") |>
        plotly::layout(legend = list(x = 0.8, y = 0.2, orientation = "h"))
    built <- plotly::plotly_build(
        VizModules::apply_legend_styling(fig, text.size = 14)
    )
    expect_equal(built$x$layout$legend$x, 0.8)
    expect_equal(built$x$layout$legend$y, 0.2)
    expect_equal(built$x$layout$legend$orientation, "h")
    expect_equal(built$x$layout$legend$font$size, 14)
})

test_that("apply_legend_styling styles continuous colorbar legends", {
    # Numeric colour mappings render a colorbar rather than a categorical
    # legend, so the title/tick fonts live on the trace's marker$colorbar.
    fig <- plotly::plot_ly(
        x = 1:3, y = 1:3, type = "scatter", mode = "markers",
        marker = list(
            color = c(1, 2, 3),
            colorbar = list(title = "value")
        )
    )
    built <- plotly::plotly_build(
        VizModules::apply_legend_styling(fig, title.size = 18, text.size = 8)
    )
    cb <- NULL
    for (tr in built$x$data) {
        if (!is.null(tr$marker$colorbar)) {
            cb <- tr$marker$colorbar
            break
        }
    }
    expect_false(is.null(cb))
    title_size <- if (is.list(cb$title)) cb$title$font$size else cb$titlefont$size
    expect_equal(title_size, 18)
    expect_equal(cb$tickfont$size, 8)
})

# A ggplotly figure with a continuous colour scale, whose colorbar sits on a
# dummy trace of its own that layout.showlegend does not hide.
.ggplotly_colorbar_fig <- function() {
    suppressWarnings(plotly::ggplotly(
        ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg, colour = hp)) + ggplot2::geom_point()
    ))
}

# Every colorbar-carrying part (marker, line, or the trace itself) of a built figure.
.colorbar_parts <- function(built) {
    parts <- list()
    for (tr in built$x$data) {
        for (part in list(tr$marker, tr$line, tr)) {
            if (is.list(part) && !is.null(part$colorbar)) parts[[length(parts) + 1L]] <- part
        }
    }
    parts
}

test_that("apply_legend_styling sets the legend font family and colour (#360)", {
    fig <- plotly::plot_ly(iris, x = ~Sepal.Length, y = ~Sepal.Width, color = ~Species,
        type = "scatter", mode = "markers")
    built <- VizModules::apply_legend_styling(fig,
        title.size = 20, text.size = 9, font.family = "Courier New", font.color = "#FF0000"
    )
    expect_equal(built$x$layout$legend$font, list(family = "Courier New", color = "#FF0000", size = 9))
    expect_equal(built$x$layout$legend$title$font, list(family = "Courier New", color = "#FF0000", size = 20))

    # Blank values leave the font alone.
    expect_identical(VizModules::apply_legend_styling(fig, font.family = "", font.color = NA), fig)

    # A colorbar gets the same fonts.
    cbs <- .colorbar_parts(VizModules::apply_legend_styling(.ggplotly_colorbar_fig(),
        title.size = 18, font.family = "Courier New", font.color = "#0000FF"
    ))
    expect_length(cbs, 1)
    cb <- cbs[[1]]$colorbar
    title_font <- if (is.list(cb$title)) cb$title$font else cb$titlefont
    expect_equal(title_font$family, "Courier New")
    expect_equal(title_font$color, "#0000FF")
    expect_equal(title_font$size, 18)
    expect_equal(cb$tickfont$family, "Courier New")
    expect_equal(cb$tickfont$color, "#0000FF")
})

test_that("apply_legend_styling(show = FALSE) hides the legend and every colorbar (#362)", {
    fig <- plotly::plot_ly(iris, x = ~Sepal.Length, y = ~Sepal.Width, color = ~Species,
        type = "scatter", mode = "markers")
    expect_false(VizModules::apply_legend_styling(fig, show = FALSE)$x$layout$showlegend)
    # TRUE or NULL leave the visibility to the figure.
    expect_false(isFALSE(VizModules::apply_legend_styling(fig, show = TRUE)$x$layout$showlegend))
    expect_identical(VizModules::apply_legend_styling(fig, show = NULL), fig)

    shown <- .colorbar_parts(plotly::plotly_build(.ggplotly_colorbar_fig()))
    expect_true(length(shown) > 0)
    hidden <- VizModules::apply_legend_styling(.ggplotly_colorbar_fig(), show = FALSE)
    expect_false(hidden$x$layout$showlegend)
    parts <- .colorbar_parts(hidden)
    expect_length(parts, length(shown))
    for (p in parts) expect_false(p$showscale)

    # A shared coloraxis colorbar is hidden too.
    ca <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "markers",
        marker = list(color = 1:3, coloraxis = "coloraxis")) |>
        plotly::layout(coloraxis = list(colorbar = list(title = "v")))
    expect_false(VizModules::apply_legend_styling(ca, show = FALSE)$x$layout$coloraxis$showscale)
})

test_that("apply_legend_inputs applies the uniform Legend inputs", {
    fig <- plotly::plot_ly(iris, x = ~Sepal.Length, y = ~Sepal.Width, color = ~Species,
        type = "scatter", mode = "markers")
    built <- VizModules::apply_legend_inputs(fig, list(
        legend.show = FALSE, legend.font.family = "Courier New", legend.font.color = "#333333",
        legend.title.size = 16, legend.text.size = 11
    ), isolate_fn = identity)
    expect_false(built$x$layout$showlegend)
    expect_equal(built$x$layout$legend$font, list(family = "Courier New", color = "#333333", size = 11))
    expect_equal(built$x$layout$legend$title$font$size, 16)

    # Inputs that have not reported yet change nothing.
    expect_identical(VizModules::apply_legend_inputs(fig, list(), isolate_fn = identity), fig)
})


# ─── apply_facet_subplot_spacing ────────────────────────────────────────────

test_that("apply_facet_subplot_spacing supports separate horizontal/vertical spacing", {
    grid <- plotly::subplot(
        plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter"),
        plotly::plot_ly(x = 1:3, y = 3:1, type = "scatter"),
        plotly::plot_ly(x = 1:3, y = 2:4, type = "scatter"),
        plotly::plot_ly(x = 1:3, y = 4:2, type = "scatter"),
        nrows = 2
    )

    result <- VizModules:::apply_facet_subplot_spacing(
        grid, spacing = c(0.2, 0.05), ncol = 2, nrow = 2
    )

    layout_names <- names(result$x$layout)
    x_axes <- layout_names[grepl("^xaxis[0-9]*$", layout_names)]
    y_axes <- layout_names[grepl("^yaxis[0-9]*$", layout_names)]

    x_starts <- sort(unique(round(vapply(
        x_axes, function(a) result$x$layout[[a]]$domain[1], numeric(1)
    ), 6)))
    x_ends <- sort(unique(round(vapply(
        x_axes, function(a) result$x$layout[[a]]$domain[2], numeric(1)
    ), 6)))
    # Horizontal gap between the two columns equals spacing[1] = 0.2.
    expect_equal(x_starts[2] - x_ends[1], 0.2, tolerance = 1e-6)

    y_starts <- sort(unique(round(vapply(
        y_axes, function(a) result$x$layout[[a]]$domain[1], numeric(1)
    ), 6)))
    y_ends <- sort(unique(round(vapply(
        y_axes, function(a) result$x$layout[[a]]$domain[2], numeric(1)
    ), 6)))
    # Vertical gap between the two rows equals spacing[2] = 0.05.
    expect_equal(y_starts[2] - y_ends[1], 0.05, tolerance = 1e-6)

    # A single panel has nothing to space.
    one <- plotly::plotly_build(plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "markers"))
    expect_identical(VizModules:::apply_facet_subplot_spacing(one), one)

    # A single value applies to both directions.
    single <- VizModules:::apply_facet_subplot_spacing(grid, spacing = 0.1, ncol = 2, nrow = 2)
    vec <- VizModules:::apply_facet_subplot_spacing(grid, spacing = c(0.1, 0.1), ncol = 2, nrow = 2)
    get_domains <- function(fig, prefix) {
        nms <- names(fig$x$layout)
        axes <- nms[grepl(paste0("^", prefix, "[0-9]*$"), nms)]
        lapply(axes, function(a) fig$x$layout[[a]]$domain)
    }
    expect_equal(get_domains(single, "xaxis"), get_domains(vec, "xaxis"))
    expect_equal(get_domains(single, "yaxis"), get_domains(vec, "yaxis"))
})

# ─── .compute_linear_fit ─────────────────────────────────────────────────────

test_that(".compute_linear_fit fits globally over complete rows, needing at least 2 points", {
    df <- data.frame(x = 1:10, y = 2 * (1:10) + 1)
    result <- VizModules:::.compute_linear_fit(df, "x", "y")

    expect_s3_class(result, "data.frame")
    expect_true(all(c("x", "y") %in% names(result)))
    expect_equal(nrow(result), 100)
    # Check fit is close to y = 2x + 1
    expect_equal(result$y[1], 2 * result$x[1] + 1, tolerance = 0.01)

    # An empty group.col means no grouping.
    expect_equal(VizModules:::.compute_linear_fit(df, "x", "y", group.col = ""), result)

    with_na <- data.frame(x = c(1, NA, 3, 4, 5), y = c(2, 4, NA, 8, 10))
    expect_equal(nrow(VizModules:::.compute_linear_fit(with_na, "x", "y")), 100)

    expect_null(VizModules:::.compute_linear_fit(data.frame(x = 1, y = 1), "x", "y"))
})

test_that(".compute_linear_fit ignores non-finite values rather than failing on them", {
    # log10(0) is -Inf; ggplot does not draw it, so the fit must not use it.
    df <- data.frame(x = c(-Inf, 1:10), y = c(0, 2 * (1:10) + 1))
    result <- VizModules:::.compute_linear_fit(df, "x", "y")
    expect_equal(range(result$x), c(1, 10))
    expect_equal(result$y[1], 3, tolerance = 1e-8)

    expect_null(VizModules:::.compute_linear_fit(data.frame(x = c(-Inf, Inf), y = 1:2), "x", "y"))
    # A constant x has no slope to fit.
    expect_null(VizModules:::.compute_linear_fit(data.frame(x = rep(1, 5), y = 1:5), "x", "y"))
})

test_that(".compute_linear_fit returns named list for grouped fit", {
    df <- data.frame(
        x = rep(1:10, 2),
        y = c(1:10, 2 * (1:10)),
        g = rep(c("A", "B"), each = 10)
    )
    result <- VizModules:::.compute_linear_fit(df, "x", "y", group.col = "g")

    expect_type(result, "list")
    expect_true(all(c("A", "B") %in% names(result)))
    expect_s3_class(result$A, "data.frame")
    expect_s3_class(result$B, "data.frame")
})

# ─── .compute_loess_fit ──────────────────────────────────────────────────────

test_that(".compute_loess_fit fits globally, needing at least 4 points", {
    set.seed(42)
    df <- data.frame(x = 1:20, y = sin(1:20) + rnorm(20, sd = 0.1))
    result <- VizModules:::.compute_loess_fit(df, "x", "y")

    expect_s3_class(result, "data.frame")
    expect_true(all(c("x", "y") %in% names(result)))
    expect_equal(nrow(result), 100)

    expect_null(VizModules:::.compute_loess_fit(data.frame(x = 1:3, y = 1:3), "x", "y"))
})

test_that(".compute_loess_fit returns one fit per group, dropping groups too small to fit", {
    set.seed(42)
    df <- data.frame(
        x = rep(1:20, 2),
        y = c(sin(1:20), cos(1:20)) + rnorm(40, sd = 0.1),
        g = rep(c("A", "B"), each = 20)
    )
    result <- VizModules:::.compute_loess_fit(df, "x", "y", group.col = "g")
    expect_type(result, "list")
    expect_true(all(c("A", "B") %in% names(result)))

    df <- data.frame(
        x = c(1:20, 1, 2),
        y = c(sin(1:20), 1, 2),
        g = c(rep("A", 20), "B", "B")
    )
    result <- VizModules:::.compute_loess_fit(df, "x", "y", group.col = "g")
    expect_true("A" %in% names(result))
    expect_false("B" %in% names(result))
})

# ─── add_hlines ─────────────────────────────────────────────────────────────

test_that("add_hlines, add_vlines and add_ablines return no shapes without intercepts", {
    fig <- make_plotly()
    for (none in list(NULL, numeric(0))) {
        expect_equal(VizModules::add_hlines(fig, none), list())
        expect_equal(VizModules::add_vlines(fig, none), list())
    }
    expect_equal(VizModules::add_ablines(fig, NULL, c(0)), list())
    expect_equal(VizModules::add_ablines(fig, c(1), NULL), list())
    expect_equal(VizModules::add_ablines(fig, numeric(0), c(0)), list())
})

test_that("add_hlines creates one full-width shape per intercept, styled per line", {
    fig <- make_plotly(data = list(list(type = "scatter", x = 1:5, y = 1:5)))
    shapes <- VizModules::add_hlines(fig, intercepts = 3)

    expect_equal(length(shapes), 1)
    expect_equal(shapes[[1]]$type, "line")
    expect_equal(shapes[[1]]$y0, 3)
    expect_equal(shapes[[1]]$y1, 3)
    expect_equal(shapes[[1]]$x0, 0)
    expect_equal(shapes[[1]]$x1, 1)
    expect_equal(shapes[[1]]$line$color, "#000000")

    shapes <- VizModules::add_hlines(fig,
        intercepts = c(1, 5),
        colors = c("red", "blue"), widths = c(2, 3)
    )
    expect_equal(length(shapes), 2)
    expect_equal(shapes[[1]]$line$color, "red")
    expect_equal(shapes[[2]]$line$color, "blue")
    expect_equal(shapes[[1]]$line$width, 2)
    expect_equal(shapes[[2]]$line$width, 3)
})

# ─── add_vlines ─────────────────────────────────────────────────────────────

test_that("add_vlines creates correct shape for single line", {
    fig <- make_plotly(data = list(list(type = "scatter", x = 1:5, y = 1:5)))
    shapes <- VizModules::add_vlines(fig, intercepts = 2)

    expect_equal(length(shapes), 1)
    expect_equal(shapes[[1]]$x0, 2)
    expect_equal(shapes[[1]]$x1, 2)
    expect_equal(shapes[[1]]$y0, 0)
    expect_equal(shapes[[1]]$y1, 1)
})

# ─── add_ablines ───────────────────────────────────────────────────────────

test_that("add_ablines creates y = mx + b line", {
    fig <- make_plotly(
        data = list(list(type = "scatter", x = c(0, 10), y = c(0, 10))),
        layout = list(xaxis = list(range = c(0, 10)))
    )
    shapes <- VizModules::add_ablines(fig, slopes = 2, intercepts = 1)

    expect_equal(length(shapes), 1)
    # y0 = intercept + slope * x0 = 1 + 2*0 = 1
    expect_equal(shapes[[1]]$y0, 1 + 2 * shapes[[1]]$x0)
    expect_equal(shapes[[1]]$y1, 1 + 2 * shapes[[1]]$x1)

    # 2 slopes, 1 intercept -> intercept recycled to length 2
    shapes <- VizModules::add_ablines(fig, slopes = c(1, 2), intercepts = 0)
    expect_equal(length(shapes), 2)
})

# ─── add_reference_lines ────────────────────────────────────────────────────

test_that("add_reference_lines adds parsed horizontal and vertical lines, and nothing by default", {
    fig <- make_plotly(data = list(list(type = "scatter", x = 1:5, y = 1:5)))

    result <- VizModules::add_reference_lines(fig, hline.intercepts = "2, 4")
    expect_true(length(result$x$layout$shapes) >= 2)
    expect_equal(result$x$layout$shapes[[1]]$y0, 2)
    expect_equal(result$x$layout$shapes[[2]]$y0, 4)

    result <- VizModules::add_reference_lines(fig, vline.intercepts = "3")
    expect_true(length(result$x$layout$shapes) >= 1)
    expect_equal(result$x$layout$shapes[[1]]$x0, 3)

    expect_null(VizModules::add_reference_lines(fig)$x$layout$shapes)
})

test_that("add_reference_lines preserves existing shapes", {
    existing_shape <- list(type = "rect", x0 = 0, x1 = 1, y0 = 0, y1 = 1)
    fig <- make_plotly(
        data = list(list(type = "scatter", x = 1:5, y = 1:5)),
        layout = list(shapes = list(existing_shape))
    )
    result <- VizModules::add_reference_lines(fig, hline.intercepts = "5")

    expect_true(length(result$x$layout$shapes) >= 2)
    expect_equal(result$x$layout$shapes[[1]]$type, "rect")
})

# ─── .calculate_range ────────────────────────────────────────────────────────

test_that(".calculate_range returns the scaled range of a y or x column", {
    df <- data.frame(val = c(2, 5, 10))
    result <- VizModules:::.calculate_range(df, data_col_y = "val", axis_scale_factor = 1.1)
    expect_equal(result$min, 2)
    expect_equal(result$max, 10 * 1.1)

    result <- VizModules:::.calculate_range(data.frame(x = c(1, 3, 5)), data_col_x = "x", axis_scale_factor = 1)
    expect_equal(result$min, 1)
    expect_equal(result$max, 5)

    # All NA falls back to 0-1.
    result <- VizModules:::.calculate_range(data.frame(val = c(NA_real_, NA_real_)), data_col_y = "val",
        axis_scale_factor = 1
    )
    expect_equal(result$min, 0)
    expect_equal(result$max, 1)
})

test_that(".calculate_range returns NULL for a missing, blank or non-numeric selection", {
    df <- data.frame(a = c(2, 5, 10), b = c("x", "y", "z"), stringsAsFactors = FALSE)
    for (col in list("b", "", "nonexistent", c("a", "b"), character(0), NA_character_)) {
        expect_null(VizModules:::.calculate_range(df, data_col_y = col, axis_scale_factor = 1), info = toString(col))
    }

    # A blank name alongside a real column is ignored rather than rejected.
    dropped <- VizModules:::.calculate_range(df, data_col_y = c("a", ""), axis_scale_factor = 1)
    expect_equal(dropped$min, 2)
    expect_equal(dropped$max, 10)
})

test_that(".calculate_range sums each x group in grouping mode, across every selected column", {
    df <- data.frame(
        vals = c(10, 20, 30, 5, 2, 1),
        grp = c("A", "A", "A", "B", "B", "B")
    )
    result <- VizModules:::.calculate_range(df,
        data_col_x = "grp", data_col_y = "vals",
        axis_scale_factor = 1, grouping = TRUE
    )
    expect_equal(result$min, 0)
    expect_equal(result$max, 60)

    df <- data.frame(
        a = c(10, 20, 5, 2),
        b = c(1, 2, 3, 4),
        grp = c("A", "A", "B", "B")
    )
    result <- VizModules:::.calculate_range(df,
        data_col_x = "grp", data_col_y = c("a", "b"),
        axis_scale_factor = 1, grouping = TRUE
    )
    # Stacked bars total both columns within each x group: A = 10+20+1+2.
    expect_equal(result$min, 0)
    expect_equal(result$max, 33)
})

test_that(".calculate_range spans every column of a multi-column selection", {
    df <- data.frame(a = c(2, 5, 10), b = c(-3, 0, 4))

    result <- VizModules:::.calculate_range(df, data_col_y = c("a", "b"), axis_scale_factor = 1.1)

    # Both columns share one axis, so the limits must fit the widest of them.
    expect_equal(result$min, -3)
    expect_equal(result$max, 10 * 1.1)
})

test_that(".calculate_range pads a negative maximum upward and ignores non-finite values", {
    # log10 of values below 1 (or neg_log10 of values above it) is all negative;
    # scaling the maximum by the factor would pull it down into the data.
    result <- VizModules:::.calculate_range(data.frame(v = c(-5, -4)), data_col_y = "v", axis_scale_factor = 1.1)
    expect_equal(result$min, -5)
    expect_equal(result$max, -4 + 0.4)
    expect_gt(result$max, -4)

    # log10(0) is -Inf, which is not plotted and must not set the limits.
    result <- VizModules:::.calculate_range(data.frame(v = c(-Inf, 1, 2)), data_col_y = "v", axis_scale_factor = 1)
    expect_equal(result$min, 1)
    expect_equal(result$max, 2)
})

# ─── .multivar_long_df ───────────────────────────────────────────────────────

test_that(".multivar_long_df stacks columns the way dittoViz does internally", {
    df <- data.frame(grp = c("A", "B"), a = c(1, 2), b = c(3, 4), stringsAsFactors = FALSE)

    long <- VizModules:::.multivar_long_df(df, c("a", "b"))

    expect_equal(nrow(long), 4)
    expect_equal(long$var.which, c("a", "a", "b", "b"))
    expect_equal(long$var.multi, c(1, 2, 3, 4))
    # The original columns ride along so grouping/faceting variables stay usable.
    expect_equal(long$grp, c("A", "B", "A", "B"))
})

# ─── empty_plot ─────────────────────────────────────────────────────────────

test_that("empty_plot returns a ggplot by default, or plotly when requested", {
    expect_s3_class(VizModules::empty_plot(text = "No data"), "ggplot")
    expect_s3_class(VizModules::empty_plot(text = NULL), "ggplot")
    expect_s3_class(VizModules::empty_plot(text = "No data", plotly = TRUE), "plotly")
})

# ─── is_pure_type ────────────────────────────────────────────────────────────

test_that("is_pure_type is TRUE only when every column is numeric or every one categorical", {
    df <- data.frame(
        a = 1:3, b = 4:6, chr = letters[1:3], fct = factor(c("x", "y", "z")), stringsAsFactors = FALSE
    )
    for (cols in list(c("a", "b"), c("chr", "fct"), "a", "", "nonexistent", character(0))) {
        expect_true(is_pure_type(cols, df), info = toString(cols))
    }
    expect_false(is_pure_type(c("a", "chr"), df))

    # Every non-numeric column counts as categorical.
    df <- data.frame(
        num = 1:3, lgl = c(TRUE, FALSE, TRUE), chr = c("a", "b", "c"),
        date = as.Date("2024-01-01") + 0:2
    )
    expect_true(is_pure_type(c("lgl", "chr"), df))
    expect_true(is_pure_type(c("date", "lgl"), df))
    expect_false(is_pure_type(c("num", "lgl"), df))
    expect_false(is_pure_type(c("date", "num"), df))
})

# ─── get_documentation ───────────────────────────────────────────────────────

test_that("get_documentation returns the selected parameter docs, capitalised on request", {
    result <- VizModules::get_documentation("stats::lm", selected = c("formula"))
    expect_type(result, "list")
    expect_true(nzchar(result$formula))

    result <- VizModules::get_documentation("stats::lm", selected = c("formula"), cap = TRUE)
    first_char <- substring(result$formula, 1, 1)
    expect_equal(first_char, toupper(first_char))
})

# ─── create_axis_styles ────────────────────────────────────────────────────

# Every input create_axis_styles() reads, overridable per test.
.axis_input <- function(...) {
    utils::modifyList(list(
        axis.title.font.size = 14, axis.title.font.family = "Arial", axis.title.font.color = "black",
        axis.tickfont.size = 12, axis.tickfont.color = "#333", axis.tickfont.family = "Arial",
        axis.tickangle.x = -45, axis.tickangle.y = -90,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1,
        show.grid.x = TRUE, show.grid.y = FALSE, grid.color = "#CCCCCC",
        axis.showline = TRUE, axis.mirror = FALSE, axis.linecolor = "black", axis.linewidth = 1
    ), list(...))
}

test_that("create_axis_styles styles each side from its own tick angle and grid inputs", {
    x <- VizModules::create_axis_styles(.axis_input(), axis_side = "x", isolate_fn = identity)
    expect_equal(x$title$font$size, 14)
    expect_equal(x$title$font$family, "Arial")
    expect_equal(x$tickangle, -45)
    expect_true(x$showgrid)
    expect_equal(x$gridcolor, "#CCCCCC")

    y <- VizModules::create_axis_styles(.axis_input(), axis_side = "y", isolate_fn = identity)
    expect_equal(y$tickangle, -90)
    expect_false(y$showgrid)
    expect_equal(y$gridcolor, "#CCCCCC")
})

test_that("create_axis_styles excludes line props when ggplot.axis.styling is TRUE", {
    mock_input <- .axis_input(axis.mirror = TRUE, axis.linecolor = "red", axis.linewidth = 2)

    result <- VizModules::create_axis_styles(mock_input,
        axis_side = "x",
        isolate_fn = identity, ggplot.axis.styling = TRUE
    )
    expect_null(result$showline)
    expect_null(result$mirror)

    result2 <- VizModules::create_axis_styles(mock_input,
        axis_side = "x",
        isolate_fn = identity, ggplot.axis.styling = FALSE
    )
    expect_true(result2$showline)
    expect_true(result2$mirror)
    expect_equal(result2$linecolor, "red")
})

# ─── create_ggplot_axis_style ───────────────────────────────────────────────

test_that("create_ggplot_axis_style draws a full border, axis lines only, or neither", {
    cases <- list(
        list(showline = TRUE, mirror = TRUE, border = "element_rect", line = "element_blank"),
        list(showline = TRUE, mirror = FALSE, border = "element_blank", line = "element_line"),
        list(showline = FALSE, mirror = FALSE, border = "element_blank", line = "element_blank")
    )
    for (case in cases) {
        mock_input <- list(
            axis.showline = case$showline, axis.mirror = case$mirror,
            axis.linecolor = "red", axis.linewidth = 2
        )
        result <- VizModules::create_ggplot_axis_style(mock_input, isolate_fn = identity)
        info <- paste("showline", case$showline, "mirror", case$mirror)
        expect_true(inherits(result$panel.border, case$border), info = info)
        expect_true(inherits(result$axis.line, case$line), info = info)
    }
})

# ─── add_size_legend() ─────────────────────────────────────────────────────────

# A two-group dot plot and its data, for the size legend to read.
.size_legend_fixture <- function(...) {
    data <- data.frame(
        cell_type = rep(c("A", "B"), each = 3),
        pct_expressed = c(5, 25, 50, 10, 40, 90)
    )
    list(data = data, fig = plotly::plot_ly(
        data = data, x = ~cell_type, y = ~pct_expressed, type = "scatter", mode = "markers", ...
    ))
}

# The built size legend over that fixture, with five fixed breaks.
.size_legend <- function(fx, ...) {
    plotly::plotly_build(add_size_legend(fx$fig, fx$data,
        size.by = "pct_expressed", size.values = c(10, 20, 30, 40, 50), ...
    ))
}

test_that("add_size_legend() styles its title and labels with the legend font", {
    # The title and the break labels, not the circle glyphs.
    text_anns <- function(...) {
        anns <- .size_legend(.size_legend_fixture(), ...)$x$layout$annotations
        Filter(function(a) !grepl("font-size", a$text), anns)
    }
    styled <- text_anns(font.family = "Courier New", font.color = "#FF0000")
    expect_length(styled, 6)
    for (a in styled) {
        expect_equal(a$font$family, "Courier New", info = a$text)
        expect_equal(a$font$color, "#FF0000", info = a$text)
    }
    # Without them the text stays black in plotly's default font.
    for (a in text_anns()) {
        expect_equal(a$font$color, "#000000")
        expect_null(a$font$family)
    }
})

test_that("add_size_legend() returns the figure unchanged for a missing or non-numeric size.by", {
    fig <- make_plotly()
    data <- data.frame(cell_type = c("A", "B"), pct_expressed = c(10, 20))

    for (size_by in list(NULL, "", "absent", "cell_type")) {
        expect_identical(add_size_legend(fig, data, size.by = size_by), fig, info = toString(size_by))
    }
})

test_that("add_size_legend() appends one title, and one circle and label per break, for numeric size.by", {
    built <- .size_legend(.size_legend_fixture(), title.size = 22, text.size = 9)
    anns <- built$x$layout$annotations

    # 1 title annotation + 5 circle glyphs + 5 numeric labels
    expect_equal(length(anns), 11)
    title_ann <- Filter(function(a) identical(a$text, "pct_expressed"), anns)
    expect_length(title_ann, 1)
    expect_equal(title_ann[[1]]$font$size, 22)

    # Each of the 5 numeric break labels appears exactly once, at the requested text size.
    label_anns <- Filter(function(a) grepl("^[0-9.]+$", a$text), anns)
    labels <- vapply(label_anns, function(a) a$text, character(1))
    expect_equal(length(labels), 5)
    expect_equal(length(unique(labels)), 5)
    expect_true(all(vapply(label_anns, function(a) a$font$size, numeric(1)) == 9))

    # Labels are anchored at the circle x (paper) and offset purely in pixels,
    # so the marker-to-label spacing is independent of plot width.
    expect_true(all(vapply(label_anns, function(a) isTRUE(a$xanchor == "left"), logical(1))))
    expect_true(all(vapply(label_anns, function(a) !is.null(a$xshift) && a$xshift > 0, logical(1))))
    # The xshift grows with the glyph size (larger circles push labels further).
    shifts <- vapply(label_anns, function(a) a$xshift, numeric(1))
    expect_equal(shifts, sort(shifts))

    # Annotations live in the built layout, so a second build does not double them.
    rebuilt <- plotly::plotly_build(built)
    expect_equal(length(rebuilt$x$layout$annotations), length(anns))
})

test_that("add_size_legend() derives circle sizes from marker sizes when size.values is NULL", {
    fx <- .size_legend_fixture(marker = list(size = ~pct_expressed))
    fig <- fx$fig

    result <- add_size_legend(fig, fx$data, size.by = "pct_expressed")
    built <- plotly::plotly_build(result)
    anns <- built$x$layout$annotations
    circle_text <- Filter(function(a) grepl("font-size", a$text), anns)
    expect_equal(length(circle_text), 5)

    sizes <- as.numeric(sub(".*font-size:([0-9.]+)px.*", "\\1", vapply(
        circle_text, function(a) a$text, character(1)
    )))
    # The glyph font-sizes are the marker pixel diameters scaled up by the
    # circle-glyph ink ratio so the rendered circles match the plotted dots.
    msizes <- VizModules:::.extract_marker_sizes(fig)
    ratio <- VizModules:::.CIRCLE_GLYPH_DIAMETER_RATIO
    expect_equal(min(sizes), min(msizes) / ratio)
    expect_equal(max(sizes), max(msizes) / ratio)
    # Sizes increase monotonically.
    expect_false(is.unsorted(sizes))
})

test_that("add_size_legend() strips the size variable from a combined legend title", {
    fx <- .size_legend_fixture()
    strip <- function(title) {
        fx$fig$x$layout$legend$title$text <- title
        add_size_legend(fx$fig, fx$data,
            size.by = "pct_expressed",
            size.values = c(10, 20, 30, 40, 50)
        )$x$layout$legend$title$text
    }
    expect_equal(strip("cell_type<br />pct_expressed"), "cell_type")
    # A standalone (already-merged) title is left untouched.
    expect_equal(strip("pct_expressed"), "pct_expressed")
})

test_that("add_size_legend() takes a title and rounds its break labels", {
    fx <- .size_legend_fixture()
    texts <- function(b) vapply(b$x$layout$annotations, function(a) a$text, character(1))

    # Breaks run evenly from 5 to 90: 26.25 and 68.75 are not round.
    raw <- texts(.size_legend(fx))
    expect_true(all(c("pct_expressed", "26.25", "68.75") %in% raw))

    tidy <- texts(.size_legend(fx, title = "% expressing", digits = 0))
    expect_true("% expressing" %in% tidy)
    expect_false("pct_expressed" %in% tidy)
    expect_true(all(c("5", "26", "48", "69", "90") %in% tidy))
})

test_that("add_size_legend() start.x and start.y move the legend column, ignoring invalid values", {
    fx <- .size_legend_fixture()
    max_at <- function(b, coord) max(vapply(b$x$layout$annotations, function(a) a[[coord]], numeric(1)))

    high <- .size_legend(fx, start.y = 0.95)
    expect_true(max_at(.size_legend(fx, start.y = 0.45), "y") < max_at(high, "y"))
    # An invalid start.y falls back to the default placement.
    expect_equal(max_at(.size_legend(fx, start.y = NA), "y"), max_at(high, "y"))

    default <- .size_legend(fx)
    expect_true(max_at(.size_legend(fx, start.x = 1.2), "x") > max_at(default, "x"))
    expect_equal(max_at(.size_legend(fx, start.x = NA), "x"), max_at(default, "x"))
})

# Pixel diameters of a built size legend's circles, top to bottom.
.size_legend_diameters <- function(built) {
    circles <- Filter(function(a) grepl("font-size", a$text), built$x$layout$annotations)
    font_px <- as.numeric(sub(".*font-size:([0-9.eE+-]+)px.*", "\\1", vapply(circles, function(a) a$text, character(1))))
    font_px * VizModules:::.CIRCLE_GLYPH_DIAMETER_RATIO
}

# The break labels of a built size legend, top to bottom.
.size_legend_labels <- function(built) {
    texts <- vapply(built$x$layout$annotations, function(a) a$text, character(1))
    texts[grepl("^-?[0-9.]+$", texts)]
}

test_that("add_size_legend() spans its breaks across the size scale's limits", {
    fx <- .size_legend_fixture()
    expect_equal(.size_legend_labels(.size_legend(fx, limits = c(0, 100))), c("0", "25", "50", "75", "100"))
    # A missing end takes the data's (5 to 90 here).
    expect_equal(.size_legend_labels(.size_legend(fx, limits = c(0, NA))), c("0.0", "22.5", "45.0", "67.5", "90.0"))
    expect_equal(
        .size_legend_labels(.size_legend(fx, limits = c(NA, 10))),
        c("5.00", "6.25", "7.50", "8.75", "10.00")
    )
    # Limits that do not increase fall back to the data's range.
    data_range <- .size_legend_labels(.size_legend(fx))
    expect_equal(.size_legend_labels(.size_legend(fx, limits = c(100, 0))), data_range)
    expect_equal(.size_legend_labels(.size_legend(fx, limits = c(95, NA))), data_range)
})

test_that("add_size_legend() circles match the points a size scale draws", {
    df <- data.frame(x = 1:5, y = 1:5, n = c(0, 25, 50, 75, 100))
    p <- ggplot2::ggplot(df, ggplot2::aes(x, y, size = n)) +
        ggplot2::geom_point() +
        VizModules:::.size_scale(c(2, 8), c(0, 100))
    fig <- plotly::ggplotly(p)
    markers <- VizModules:::.extract_marker_sizes(fig)

    built <- add_size_legend(fig, df, size.by = "n", limits = c(0, 100), size.range = c(2, 8))
    expect_equal(.size_legend_labels(built), c("0", "25", "50", "75", "100"))
    expect_equal(.size_legend_diameters(built), sort(markers))
})

test_that("add_size_legend() reads circles from the markers when the limits are wider than the data", {
    # Only 20 to 80 are drawn, on a 0 to 100 scale, and no size.range is given.
    df <- data.frame(x = 1:4, y = 1:4, n = c(20, 40, 60, 80))
    p <- ggplot2::ggplot(df, ggplot2::aes(x, y, size = n)) +
        ggplot2::geom_point() +
        VizModules:::.size_scale(c(2, 8), c(0, 100))

    built <- add_size_legend(plotly::ggplotly(p), df, size.by = "n", limits = c(0, 100))
    expected <- VizModules:::.size_scale_px(c(0, 25, 50, 75, 100), c(2, 8), c(0, 100))
    expect_equal(.size_legend_diameters(built), expected, tolerance = 1e-6)
})

test_that("the size scale draws values beyond its limits at the end sizes", {
    df <- data.frame(x = 1:4, y = 1:4, n = c(-10, 0, 100, 150))
    p <- ggplot2::ggplot(df, ggplot2::aes(x, y, size = n)) +
        ggplot2::geom_point() +
        VizModules:::.size_scale(c(2, 8), c(0, 100))
    markers <- VizModules:::.extract_marker_sizes(plotly::ggplotly(p))

    # No point is dropped, and each takes the size of the limit it is beyond.
    expect_length(markers, 4)
    expect_equal(markers, VizModules:::.size_scale_px(c(0, 0, 100, 100), c(2, 8), c(0, 100)))
})

test_that(".size_range and .size_limits fill what is missing", {
    expect_equal(VizModules:::.size_range(2, 10), c(2, 10))
    expect_equal(VizModules:::.size_range(NA, NULL), c(1, 6))
    expect_equal(VizModules:::.size_range("a", 9), c(1, 9))

    vals <- c(5, NA, 90, Inf)
    expect_equal(VizModules:::.size_limits(vals), c(5, 90))
    expect_equal(VizModules:::.size_limits(vals, 0, 100), c(0, 100))
    expect_equal(VizModules:::.size_limits(vals, NA, 100), c(5, 100))
    expect_equal(VizModules:::.size_limits(vals, 100, NA), c(5, 90))
    expect_null(VizModules:::.size_limits(c(NA, NaN)))
    expect_null(VizModules:::.size_limits(c("a", "b")))
})

test_that(".extract_marker_sizes collects numeric marker sizes", {
    fig <- plotly::plot_ly(
        x = 1:3, y = 1:3, type = "scatter", mode = "markers",
        marker = list(size = c(4, 8, 12))
    )
    expect_equal(sort(VizModules:::.extract_marker_sizes(fig)), c(4, 8, 12))

    # No marker sizes -> empty numeric vector.
    fig2 <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "lines")
    expect_equal(VizModules:::.extract_marker_sizes(fig2), numeric(0))
})

# ─── adjusted_axis_label ────────────────────────────────────────────────────

test_that("adjusted_axis_label wraps the label in the function, then the data adjustment", {
    cases <- list(
        list(adj = NULL, fun = NULL, out = "units"),
        list(adj = "", fun = "", out = "units"),
        list(adj = NA, fun = NULL, out = "units"),
        list(adj = "z-score", fun = NULL, out = "z-score(units)"),
        list(adj = "relative.to.max", fun = NULL, out = "relative.to.max(units)"),
        list(adj = NULL, fun = "log2", out = "log2(units)"),
        list(adj = "z-score", fun = "log2", out = "z-score(log2(units))")
    )
    for (case in cases) {
        expect_equal(VizModules::adjusted_axis_label("units", case$adj, case$fun), case$out, info = case$out)
    }
})

test_that(".annotation_edit_key keys axis titles by side and others by text", {
    expect_equal(
        VizModules:::.annotation_edit_key(list(annotationType = "axis", textangle = 0)),
        "axis:x"
    )
    expect_equal(
        VizModules:::.annotation_edit_key(list(annotationType = "axis", textangle = -90)),
        "axis:y"
    )
    expect_equal(VizModules:::.annotation_edit_key(list(text = "p = 0.01")), "text:p = 0.01")
    expect_null(VizModules:::.annotation_edit_key(list(text = "")))
    expect_null(VizModules:::.annotation_edit_key(NULL))

    # Text a wrapper built from a factor column keys like its label, and text
    # that is not a single value has no key rather than an error.
    expect_equal(VizModules:::.annotation_edit_key(list(text = factor("PLK1"))), "text:PLK1")
    expect_equal(VizModules:::.annotation_edit_key(list(text = 5)), "text:5")
    expect_null(VizModules:::.annotation_edit_key(list(text = character(0))))
    expect_null(VizModules:::.annotation_edit_key(list(text = NA_character_)))
    expect_null(VizModules:::.annotation_edit_key(list(text = list("a"))))
    expect_identical(
        VizModules:::.annotation_edit_keys(list(list(text = factor("A")), list(text = factor("A")))),
        c("text:A#1", "text:A#2")
    )
})

test_that(".capture_manual_edits records legend, annotation and colorbar drags, not zooms", {
    fig <- list(x = list(layout = list(annotations = list(
        list(text = "X", annotationType = "axis", textangle = 0)
    ))))
    empty <- list(legend = NULL, annotations = list())
    edits <- .capture_manual_edits(
        empty,
        list(
            `legend.x` = 0.2, `legend.y` = 0.3, `legend.xanchor` = "left", `legend.yanchor` = "top",
            `annotations[0].x` = 0.8, `coloraxis.colorbar.x` = 1.2, `coloraxis.colorbar.y` = 0.4
        ),
        fig
    )
    expect_equal(edits$legend$x, 0.2)
    expect_equal(edits$legend$y, 0.3)
    expect_equal(edits$legend$xanchor, "left")
    expect_equal(edits$legend$yanchor, "top")
    expect_equal(edits$annotations[["axis:x#1"]]$x, 0.8)
    expect_equal(edits$colorbar$x, 1.2)
    expect_equal(edits$colorbar$y, 0.4)

    edits <- .capture_manual_edits(empty, list(`xaxis.range[0]` = 1, `xaxis.range[1]` = 2), NULL)
    expect_null(edits$legend)
    expect_length(edits$annotations, 0)
})

test_that(".capture_manual_edits disambiguates repeated annotation text", {
    fig <- list(x = list(layout = list(annotations = list(
        list(text = "P"), list(text = "P")
    ))))
    edits <- .capture_manual_edits(
        list(legend = NULL, annotations = list()),
        list(`annotations[0].x` = 0.1, `annotations[1].x` = 0.9),
        fig
    )
    expect_equal(edits$annotations[["text:P#1"]]$x, 0.1)
    expect_equal(edits$annotations[["text:P#2"]]$x, 0.9)
})

test_that(".reapply_manual_edits restores legend, annotation, arrow and colorbar positions", {
    edits <- list(
        legend = list(x = 0.2, y = 0.3),
        annotations = list(
            "axis:x#1" = list(x = 0.8, y = 0.9),
            "text:Pt#1" = list(x = 1, y = 2, ax = 30, ay = -40)
        ),
        colorbar = list(x = 1.2, y = 0.4)
    )
    # The axis title moved from index 1 to 2; its key, not its index, finds it.
    fig <- list(x = list(
        data = list(list(marker = list(colorbar = list(x = 1, y = 0.5)))),
        layout = list(
            legend = list(x = 1, y = 1),
            annotations = list(
                list(text = "stat"),
                list(text = "X", annotationType = "axis", textangle = 0, x = 0.5, y = -0.1),
                list(text = "Pt", x = 0, y = 0, ax = 20, ay = -20)
            )
        )
    ))
    out <- .reapply_manual_edits(fig, edits)
    expect_equal(out$x$layout$legend$x, 0.2)
    expect_equal(out$x$layout$annotations[[2]]$x, 0.8)
    expect_equal(out$x$layout$annotations[[2]]$y, 0.9)
    expect_equal(out$x$layout$annotations[[3]]$ax, 30)
    expect_equal(out$x$layout$annotations[[3]]$ay, -40)
    expect_equal(out$x$data[[1]]$marker$colorbar$x, 1.2)
    expect_equal(out$x$data[[1]]$marker$colorbar$y, 0.4)
})

test_that(".reapply_manual_edits keeps repeated-text annotations independent", {
    edits <- list(
        legend = NULL,
        annotations = list("text:P#1" = list(x = 0.1), "text:P#2" = list(x = 0.9))
    )
    fig <- list(x = list(layout = list(annotations = list(
        list(text = "P", x = 0), list(text = "P", x = 0)
    ))))
    out <- .reapply_manual_edits(fig, edits)
    expect_equal(out$x$layout$annotations[[1]]$x, 0.1)
    expect_equal(out$x$layout$annotations[[2]]$x, 0.9)
})

test_that(".reapply_manual_edits regenerates only the named axis titles, keeping their position", {
    edits <- list(legend = NULL, annotations = list(
        "axis:x#1" = list(text = "custom X"),
        "axis:y#1" = list(text = "old label", x = 0.9, y = 0.4)
    ))
    fig <- list(x = list(layout = list(annotations = list(
        list(text = "grp", annotationType = "axis", textangle = 0),
        list(text = "log2(units)", annotationType = "axis", textangle = -90, x = -0.05, y = 0.5)
    ))))
    out <- .reapply_manual_edits(fig, edits, regen_keys = "axis:y")
    expect_equal(out$x$layout$annotations[[1]]$text, "custom X")    # x not regenerated
    expect_equal(out$x$layout$annotations[[2]]$text, "log2(units)") # regenerated, not clobbered
    expect_equal(out$x$layout$annotations[[2]]$x, 0.9)              # drag position persists
    expect_equal(out$x$layout$annotations[[2]]$y, 0.4)

    # With no adjustment active (regen_keys defaults to none), a manual edit persists.
    out <- .reapply_manual_edits(fig, edits)
    expect_equal(out$x$layout$annotations[[2]]$text, "old label")
    expect_equal(out$x$layout$annotations[[2]]$x, 0.9)
})

test_that("build_facet_annotations keys shared axis titles by side, not text", {
    anns <- build_facet_annotations(c("A", "B"), x.title = "grp", y.title = "units", nrows = 1)
    keys <- VizModules:::.annotation_edit_keys(anns)
    expect_true("axis:x#1" %in% keys)
    expect_true("axis:y#1" %in% keys)
    expect_false(any(c("text:grp#1", "text:units#1") %in% keys))
})

test_that("build_facet_annotations styles axis and facet titles independently", {
    font <- list(size = 30, color = "#0000FF", family = "Courier New")
    anns <- build_facet_annotations(
        c("A", "B"), x.title = "grp", y.title = "units", axis.title.font = font
    )
    is_axis <- vapply(anns, function(a) identical(a$annotationType, "axis"), logical(1))
    expect_equal(sum(is_axis), 2)
    for (a in anns[is_axis]) expect_equal(a$font, font)
    for (a in anns[!is_axis]) expect_equal(a$font, list(size = 14)) # facet titles untouched

    facet_font <- list(size = 20, color = "red", family = "Arial")
    anns_facet <- build_facet_annotations(c("A", "B"), x.title = "grp", facet.title.font = facet_font)
    for (a in anns_facet) {
        is_axis <- identical(a$annotationType, "axis")
        expect_equal(a$font, if (is_axis) list(size = 14) else facet_font)
    }

    # Without either, everything falls back to title.font.size as before.
    anns_default <- build_facet_annotations(c("A", "B"), x.title = "grp", title.font.size = 11)
    for (a in anns_default) expect_equal(a$font, list(size = 11))
})

test_that("faceted shared-axis-title position survives a label text change", {
    # Position captured on the pre-adjustment faceted figure...
    anns_before <- build_facet_annotations(c("A", "B"), x.title = "grp", y.title = "units")
    fig_before <- list(x = list(layout = list(annotations = anns_before)))
    yi <- which(VizModules:::.annotation_edit_keys(anns_before) == "axis:y#1") - 1L
    rl <- setNames(list(0.02, 0.55), sprintf(c("annotations[%d].x", "annotations[%d].y"), yi))
    edits <- .capture_manual_edits(list(legend = NULL, annotations = list()), rl, fig_before)
    # ...re-applied on the rebuilt faceted figure whose y label changed to log2(units).
    anns_after <- build_facet_annotations(c("A", "B"), x.title = "grp", y.title = "log2(units)")
    out <- .reapply_manual_edits(
        list(x = list(layout = list(annotations = anns_after))),
        edits, regen_keys = "axis:y"
    )
    kk <- VizModules:::.annotation_edit_keys(out$x$layout$annotations)
    ya <- out$x$layout$annotations[[which(kk == "axis:y#1")]]
    expect_equal(ya$x, 0.02) # dragged position kept
    expect_equal(ya$y, 0.55)
    expect_equal(ya$text, "log2(units)") # regenerated label wins
})

test_that("reset_axis_title_text drops text for the named side, keeping position and others", {
    store <- list(edits = shiny::reactiveValues(annotations = list(
        "axis:y#1" = list(text = "custom", x = 0.9, y = 0.4),
        "axis:x#1" = list(text = "keep x"),
        "text:Pt#1" = list(text = "stay", x = 1)
    )))
    shiny::isolate({
        changed <- reset_axis_title_text(store, "axis:y")
        expect_true(changed)
        anns <- store$edits$annotations
        expect_null(anns[["axis:y#1"]]$text)             # text dropped
        expect_equal(anns[["axis:y#1"]]$x, 0.9)          # dragged position kept
        expect_equal(anns[["axis:x#1"]]$text, "keep x")  # other axis untouched
        expect_equal(anns[["text:Pt#1"]]$text, "stay")   # non-axis annotation untouched
    })

    # A text-only entry goes entirely, and a second reset is a no-op.
    store <- list(edits = shiny::reactiveValues(annotations = list(
        "axis:y#1" = list(text = "custom")
    )))
    shiny::isolate({
        expect_true(reset_axis_title_text(store, "axis:y"))
        expect_false("axis:y#1" %in% names(store$edits$annotations))
        expect_false(reset_axis_title_text(store, "axis:y"))
    })
})

test_that(".add_colorbar_listener attaches a render hook to the figure", {
    p <- plotly::plot_ly(x = 1:3, y = 1:3, type = "scatter", mode = "markers")
    out <- .add_colorbar_listener(p, "mod-colorbar.move")
    expect_s3_class(out, "plotly")
    expect_false(is.null(out$jsHooks$render))
})

test_that("reset_manual_edits clears the store a module reads, not a copy", {
    shiny::testServer(function(input, output, session) {
        store <- setup_manual_edits(input, session, "src")
    }, {
        store$edits$legend <- list(x = 0.2, y = 0.9)
        store$edits$annotations <- list(`axis:x#1` = list(x = 0.4))
        store$edits$colorbar <- list(x = 1.1)

        reset_manual_edits(store)

        edits <- shiny::isolate(shiny::reactiveValuesToList(store$edits))
        expect_null(edits$legend)
        expect_equal(edits$annotations, list())
        expect_null(edits$colorbar)
    })
})

test_that(".split_bar_range clears the longest bar on either side", {
    df <- data.frame(term = c("a", "b", "c"), score = c(2, -30, 3))
    r <- .split_bar_range(df, "score", "term", scale_factor = 1)
    expect_equal(r, list(min = -30, max = 30))

    # A category's bars stack on each side of zero rather than netting out.
    stacked <- data.frame(term = c("a", "a", "a"), score = c(10, -8, -4))
    expect_equal(.split_bar_range(stacked, "score", "term")$max, 12)

    # All-negative data no longer inverts the range.
    neg <- data.frame(term = c("a", "b"), score = c(-5, -2))
    r <- .split_bar_range(neg, "score", "term", scale_factor = 1.2)
    expect_equal(r, list(min = -6, max = 6))

    expect_null(.split_bar_range(df, "term", "score"))
    expect_null(.split_bar_range(df, "", "term"))
})

test_that("apply_axis_title_to_annotations tolerates an annotation with no xanchor", {
    fig <- plotly::plotly_build(plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers"))
    fig$x$layout$annotations <- list(list(x = 0.5, y = 1, xref = "paper", yref = "paper", text = "note"))
    input <- list(
        axis.title.font.size = 12, axis.title.font.family = "Arial", axis.title.font.color = "black",
        facet.title.font.size = 14, facet.title.font.family = "Arial", facet.title.font.color = "black"
    )
    out <- apply_axis_title_to_annotations(fig, input, identity)
    expect_null(out$x$layout$annotations[[1]]$font)
})

test_that("parallelCoordinatesPlot tolerates a blank line width", {
    expect_s3_class(
        parallelCoordinatesPlot(mtcars, dimensions = c("mpg", "hp"), color.by = "cyl", line.width = NA),
        "plotly"
    )
})

test_that("AreaPlot offers every categorical column except X for Group By", {
    seen <- new.env()
    real_select <- viz_select_input
    local_mocked_bindings(viz_select_input = function(inputId, label, choices, selected = NULL, ...) {
        seen[[inputId]] <- list(choices = choices, selected = selected)
        real_select(inputId, label, choices, selected = selected, ...)
    })

    # region is the first categorical column; it used to be left out of Group By
    # whatever X was, so this default was silently dropped.
    df <- data.frame(
        region = c("N", "S"), year = factor(c("2020", "2021")), product = c("x", "y"),
        value = 1:2, stringsAsFactors = FALSE
    )
    plotthis_AreaPlotInputsUI("area", df, defaults = list(x.data = "year", group.by = "region"))
    expect_equal(seen[["area-group.by"]]$selected, "region")
    expect_setequal(setdiff(seen[["area-group.by"]]$choices, ""), c("region", "product"))

    # Without a default, Group By falls back to a column other than X.
    plotthis_AreaPlotInputsUI("area", df, defaults = list(x.data = "product"))
    expect_equal(seen[["area-group.by"]]$selected, "region")
    expect_false("product" %in% seen[["area-group.by"]]$choices)
})

test_that("plotthis Group By and Fill By leave out categoricals with too many levels", {
    df <- .wide_id_df()
    cases <- list(
        list(ui = plotthis_BarPlotInputsUI, id = "bar", input = "group.by", numeric = FALSE),
        list(ui = plotthis_BarPlotInputsUI, id = "bar", input = "fill.by", numeric = TRUE),
        list(ui = plotthis_DensityPlotInputsUI, id = "dens", input = "group.by", numeric = FALSE),
        list(ui = plotthis_HistogramInputsUI, id = "hist", input = "group.by", numeric = FALSE),
        list(ui = plotthis_SplitBarPlotInputsUI, id = "split", input = "fill.by", numeric = TRUE)
    )
    for (case in cases) {
        info <- paste(case$id, case$input)
        input_id <- paste0(case$id, "-", case$input)
        ch <- .select_choices(as.character(case$ui(case$id, df)), input_id)
        expect_true(all(c("grp", "grp2", "flag") %in% ch), info = info)
        expect_false("id" %in% ch, info = info)
        # A fill gradient takes a numeric column; a grouping does not.
        expect_identical(all(c("val", "val2") %in% ch), case$numeric, info = info)

        # An explicit default naming the wide column is honoured.
        html <- as.character(case$ui(case$id, df, defaults = setNames(list("id"), case$input)))
        expect_true("id" %in% .select_choices(html, input_id), info = info)
    }
})

test_that("AreaPlot Group By drops wide categoricals as well as X, at startup and when X changes", {
    df <- .wide_id_df()
    html <- as.character(plotthis_AreaPlotInputsUI("area", df, defaults = list(x.data = "grp")))
    expect_setequal(setdiff(.select_choices(html, "area-group.by"), ""), c("grp2", "flag"))

    sent <- new.env()
    local_mocked_bindings(update_viz_select = function(session, inputId, label = NULL, choices = NULL, ...) {
        if (!is.null(choices)) {
            sent[[inputId]] <- choices
        }
        invisible(NULL)
    })
    shiny::testServer(
        plotthis_AreaPlotServer,
        args = list(id = "area", data = shiny::reactive(df), defaults = list(x.data = "grp")),
        {
            suppressWarnings(session$setInputs(x.data = "grp", y.data = "val", group.by = "grp2", facet.by = ""))
            suppressWarnings(session$setInputs(x.data = "grp2"))
            expect_setequal(setdiff(sent[["group.by"]], ""), c("grp", "flag"))
            # Facet By keeps to the facet_check() columns the UI offers.
            expect_setequal(setdiff(sent[["facet.by"]], ""), "grp")
        }
    )
})
