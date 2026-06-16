test_that("linePlot creates expected line trace", {
    palette <- plotthis::palette_list[["Set2"]]

    fig <- linePlot(
        data = mtcars,
        x = "cyl",
        y = "mpg",
        plot.mode = "lines+markers",
        line.type = "solid",
        colour.group.by = "gear",
        palette.selection = "Set2",
        show.legend = TRUE,
        facet.by = NULL,
        facet.scales = "fixed",
        axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, axis.tickfont.size = 12,
        axis.tickfont.color = "black", axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
        axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, title.text = "", title.font.size = 14, title.font.family = "Arial",
        title.font.color = "black", y.title = NULL, x.title = NULL, flip.x = FALSE, flip.y = FALSE,
        x.adjustment = NULL, y.adjustment = NULL, color.adjustment = NULL, order.by = NULL
    )

    expect_s3_class(fig, "plotly")

    built <- plotly::plotly_build(fig)
    trace <- built$x$data[[1]]

    expect_identical(trace$type, "scatter")
    expect_true(trace$mode %in% c("lines", "markers", "lines+markers"))
})

test_that("Test Incorrect Inputs", {
    fig <- linePlot(
        data = mtcars,
        x = "-random_column",
        y = "mpg",
        plot.mode = "lines+markers",
        line.type = "solid",
        colour.group.by = "gear",
        palette.selection = "Set2",
        show.legend = TRUE
    )

    expect_error(print(fig))
})

test_that("linePlot returns plotly object", {
    fig <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = TRUE
    )

    expect_s3_class(fig, "plotly")
})

test_that("linePlot handles different plot modes", {
    # Lines only
    fig_lines <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE
    )
    expect_s3_class(fig_lines, "plotly")

    # Markers only
    fig_markers <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "markers",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE
    )
    expect_s3_class(fig_markers, "plotly")
})

test_that("linePlot handles different line types", {
    fig_dash <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "dash",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE
    )

    expect_s3_class(fig_dash, "plotly")
    built <- plotly::plotly_build(fig_dash)
    expect_equal(built$x$data[[1]]$line$dash, "dash")
})

test_that("linePlot handles legend visibility", {
    fig_no_legend <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = "gear",
        palette.selection = "Set2",
        show.legend = FALSE
    )

    expect_s3_class(fig_no_legend, "plotly")
})

test_that("linePlot handles custom titles", {
    fig <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE,
        title.text = "My Custom Title",
        x.title = "Weight (1000 lbs)",
        y.title = "Miles Per Gallon"
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$text, "My Custom Title")
})

test_that("linePlot handles axis flipping", {
    fig <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE,
        flip.x = TRUE,
        flip.y = TRUE
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$xaxis$autorange, "reversed")
    expect_equal(built$x$layout$yaxis$autorange, "reversed")
})

test_that("linePlot handles faceting", {
    fig <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE,
        facet.by = "cyl"
    )

    expect_s3_class(fig, "plotly")
})

test_that("linePlot errors with NULL data", {
    expect_error(
        linePlot(
            data = NULL,
            x = "wt",
            y = "mpg",
            plot.mode = "lines",
            line.type = "solid",
            colour.group.by = NULL,
            palette.selection = "Set2",
            show.legend = FALSE
        )
    )
})

test_that("linePlot errors with invalid y column", {
    fig <- linePlot(
        data = mtcars,
        x = "wt",
        y = "fake_column",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE
    )

    expect_error(print(fig))
})

test_that("linePlot handles different datasets", {
    fig <- linePlot(
        data = iris,
        x = "Sepal.Length",
        y = "Sepal.Width",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = "Species",
        palette.selection = "Set1",
        show.legend = TRUE
    )

    expect_s3_class(fig, "plotly")
})

test_that("linePlot honors title.x.position for repositioning the title", {
    fig <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = TRUE,
        title.text = "Custom title",
        title.x.position = 0.2
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$x, 0.2)
})

test_that("linePlot wraps y-axis title with mean() for a categorical x-axis", {
    df <- data.frame(
        grp = factor(c("a", "a", "b", "b", "c", "c")),
        val = c(1, 3, 5, 7, 9, 11)
    )

    fig <- linePlot(
        data = df,
        x = "grp",
        y = "val",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE,
        y.title = "val"
    )

    built <- plotly::plotly_build(fig)
    y_title <- built$x$layout$yaxis$title
    if (is.list(y_title)) y_title <- y_title$text
    expect_equal(y_title, "mean(val)")
})

test_that("linePlot keeps a plain y-axis title for a numeric x-axis", {
    fig <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE,
        y.title = "mpg"
    )

    built <- plotly::plotly_build(fig)
    y_title <- built$x$layout$yaxis$title
    if (is.list(y_title)) y_title <- y_title$text
    expect_equal(y_title, "mpg")
})

test_that("linePlot adds panel border shapes to every facet", {
    fig <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE,
        facet.by = "cyl",
        axis.showline = TRUE,
        axis.mirror = TRUE
    )

    n_facets <- length(unique(mtcars$cyl))
    shapes <- fig$x$layout$shapes
    rect_shapes <- Filter(function(s) identical(s$type, "rect"), shapes)

    # One rectangular border (full box) per facet panel.
    expect_equal(length(rect_shapes), n_facets)
    for (s in rect_shapes) {
        expect_identical(s$xref, "paper")
        expect_identical(s$yref, "paper")
    }
})

test_that("linePlot omits panel borders when axis lines are disabled", {
    fig <- linePlot(
        data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = FALSE,
        facet.by = "cyl",
        axis.showline = FALSE,
        axis.mirror = FALSE
    )

    shapes <- fig$x$layout$shapes
    rect_shapes <- Filter(function(s) identical(s$type, "rect"), shapes)
    expect_equal(length(rect_shapes), 0)
})

test_that(".build_facet_panel_borders honours showline and mirror", {
    fig <- structure(
        list(x = list(layout = list(
            xaxis = list(domain = c(0, 0.45)),
            yaxis = list(domain = c(0, 1)),
            xaxis2 = list(domain = c(0.55, 1)),
            yaxis2 = list(domain = c(0, 1))
        ))),
        class = "plotly"
    )

    # Full box per panel when showline and mirror are TRUE.
    full <- .build_facet_panel_borders(fig, 2, showline = TRUE, mirror = TRUE)
    expect_equal(length(full), 2)
    expect_true(all(vapply(full, function(s) identical(s$type, "rect"), logical(1))))

    # Left + bottom edges per panel when mirror is FALSE.
    edges <- .build_facet_panel_borders(fig, 2, showline = TRUE, mirror = FALSE)
    expect_equal(length(edges), 4)
    expect_true(all(vapply(edges, function(s) identical(s$type, "line"), logical(1))))

    # No shapes when showline is FALSE.
    none <- .build_facet_panel_borders(fig, 2, showline = FALSE, mirror = TRUE)
    expect_equal(length(none), 0)
})

test_that(".build_facet_panel_borders draws a distinct box per panel across rows", {
    # Emulate a 3-column x 2-row shared-axis subplot: plotly only keeps one axis
    # per column (x) and one per row (y), so the per-panel index lookup breaks.
    fig <- structure(
        list(x = list(layout = list(
            xaxis = list(domain = c(0.00, 0.30)),
            xaxis2 = list(domain = c(0.35, 0.65)),
            xaxis3 = list(domain = c(0.70, 1.00)),
            yaxis = list(domain = c(0.52, 1.00)),
            yaxis2 = list(domain = c(0.00, 0.48))
        ))),
        class = "plotly"
    )

    borders <- .build_facet_panel_borders(
        fig, 6, showline = TRUE, mirror = TRUE, ncol = 3, nrow = 2
    )
    expect_equal(length(borders), 6)
    expect_true(all(vapply(borders, function(s) identical(s$type, "rect"), logical(1))))

    # Every panel must have a unique rectangle (no collapsing onto the base axis).
    keys <- vapply(borders, function(s) paste(s$x0, s$x1, s$y0, s$y1), character(1))
    expect_equal(length(unique(keys)), 6)

    # Panels are filled row-major: first three on the top row, next three below.
    top_y <- vapply(borders[1:3], function(s) s$y0, numeric(1))
    bottom_y <- vapply(borders[4:6], function(s) s$y0, numeric(1))
    expect_true(all(top_y == 0.52))
    expect_true(all(bottom_y == 0.00))
})

test_that(".build_facet_panel_borders skips empty cells in a partial grid", {
    # 5 panels in a 3x2 grid leaves the bottom-right cell empty.
    fig <- structure(
        list(x = list(layout = list(
            xaxis = list(domain = c(0.00, 0.30)),
            xaxis2 = list(domain = c(0.35, 0.65)),
            xaxis3 = list(domain = c(0.70, 1.00)),
            yaxis = list(domain = c(0.52, 1.00)),
            yaxis2 = list(domain = c(0.00, 0.48))
        ))),
        class = "plotly"
    )

    borders <- .build_facet_panel_borders(
        fig, 5, showline = TRUE, mirror = TRUE, ncol = 3, nrow = 2
    )
    expect_equal(length(borders), 5)
})
