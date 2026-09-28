test_that("linePlot creates expected line trace", {
    built <- plotly::plotly_build(linePlot(
        data = mtcars, x = "cyl", y = "mpg", plot.mode = "lines+markers",
        colour.group.by = "gear", palette.selection = "Set2"
    ))
    trace <- built$x$data[[1]]

    expect_identical(trace$type, "scatter")
    expect_identical(trace$mode, "lines+markers")
})

test_that("linePlot errors on missing data or columns", {
    expect_error(linePlot(data = NULL, x = "wt", y = "mpg", palette.selection = "Set2"))
    for (cols in list(c("-random_column", "mpg"), c("wt", "fake_column"))) {
        fig <- linePlot(data = mtcars, x = cols[1], y = cols[2], palette.selection = "Set2")
        expect_error(suppressWarnings(plotly::plotly_build(fig)), info = paste(cols, collapse = " ~ "))
    }
})

test_that("linePlot draws the requested plot mode and line type", {
    for (mode in c("lines", "markers")) {
        trace <- plotly::plotly_build(linePlot(
            data = mtcars, x = "wt", y = "mpg", plot.mode = mode, palette.selection = "Set2"
        ))$x$data[[1]]
        expect_identical(trace$mode, mode)
    }
    trace <- plotly::plotly_build(linePlot(
        data = mtcars, x = "wt", y = "mpg", plot.mode = "lines", line.type = "dash", palette.selection = "Set2"
    ))$x$data[[1]]
    expect_equal(trace$line$dash, "dash")
})

test_that("linePlot handles axis flipping", {
    built <- plotly::plotly_build(linePlot(
        data = mtcars, x = "wt", y = "mpg", palette.selection = "Set2",
        flip.x = TRUE, flip.y = TRUE
    ))
    expect_equal(built$x$layout$xaxis$autorange, "reversed")
    expect_equal(built$x$layout$yaxis$autorange, "reversed")
})

# Regression data for the faceted-legend tests (#357): 2 facets x 3 colour groups.
.line_facet_data <- function() {
    set.seed(1)
    d <- expand.grid(
        x = factor(1:4), grp = c("A", "B", "C"), fct = c("p", "q"),
        rep = 1:5, stringsAsFactors = FALSE
    )
    d$y <- rnorm(nrow(d))
    d$y2 <- rnorm(nrow(d))
    d
}

# Traces plotly will draw a legend entry for - showlegend defaults to TRUE when unset.
.legend_traces <- function(built) {
    Filter(function(tr) !identical(tr$showlegend, FALSE), built$x$data)
}

# plotly keeps a factor grouping column as a factor on the R side; the widget is
# serialised from its labels, so compare labels.
.trace_field <- function(built, field) {
    vapply(built$x$data, function(tr) {
        val <- tr[[field]]
        if (is.null(val)) NA_character_ else as.character(val)
    }, character(1))
}

test_that("linePlot shows each colour group once, and groups it across facets (#357)", {
    built <- suppressWarnings(plotly::plotly_build(linePlot(
        data = .line_facet_data(), x = "x", y = "y",
        colour.group.by = "grp", facet.by = "fct",
        palette.selection = c("#1b9e77", "#d95f02", "#7570b3"), show.legend = TRUE
    )))

    # 2 facets x 3 groups are still drawn, but only one facet feeds the legend.
    expect_equal(length(built$x$data), 6)
    expect_equal(length(.legend_traces(built)), 3)
    expect_setequal(
        vapply(.legend_traces(built), function(tr) tr$name, character(1)),
        c("A", "B", "C")
    )

    # Every trace is grouped under its own series name, and both facets use the
    # same set of groups, so one legend click toggles the series in every panel.
    groups <- .trace_field(built, "legendgroup")
    expect_false(any(is.na(groups)))
    expect_identical(groups, .trace_field(built, "name"))
    expect_setequal(groups[1:3], groups[4:6])
})

test_that("linePlot groups faceted traces when the colour column is a factor", {
    # example_sales$region is a factor and product_line has 3 levels - the case the
    # module actually hits, and the one that regressed in #357.
    fig <- linePlot(
        data = example_sales,
        x = "month",
        y = "revenue",
        colour.group.by = "region",
        facet.by = "product_line",
        palette.selection = plotthis::palette_list[["Set2"]][1:6],
        show.legend = TRUE
    )

    built <- suppressWarnings(plotly::plotly_build(fig))
    groups <- .trace_field(built, "legendgroup")

    # 3 facets x 6 regions, but only 6 legend entries.
    expect_equal(length(built$x$data), 18)
    expect_equal(length(.legend_traces(built)), 6)

    # Grouped by the factor's labels, not its integer codes, and the same groups
    # repeat in every panel so one click reaches all three.
    expect_identical(groups, .trace_field(built, "name"))
    expect_setequal(groups[1:6], levels(example_sales$region))
    expect_setequal(groups[7:12], groups[1:6])
    expect_setequal(groups[13:18], groups[1:6])
})

test_that("linePlot legend is unchanged without faceting", {
    d <- .line_facet_data()

    fig <- linePlot(
        data = d,
        x = "x",
        y = "y",
        colour.group.by = "grp",
        palette.selection = c("#1b9e77", "#d95f02", "#7570b3"),
        show.legend = TRUE
    )

    built <- suppressWarnings(plotly::plotly_build(fig))

    expect_equal(length(built$x$data), 3)
    expect_equal(length(.legend_traces(built)), 3)
})

test_that("linePlot faceted multi-axis traces are grouped and carry no placeholder", {
    d <- .line_facet_data()

    fig <- linePlot(
        data = d,
        x = "rep",
        y = c("y", "y2"),
        facet.by = "fct",
        palette.selection = c("#1b9e77", "#d95f02"),
        show.legend = TRUE
    )

    built <- suppressWarnings(plotly::plotly_build(fig))

    # 2 facets x 2 y columns, with no empty initialiser trace padding the legend.
    expect_equal(length(built$x$data), 4)
    expect_false(any(vapply(built$x$data, function(tr) is.null(tr$name), logical(1))))
    expect_equal(length(.legend_traces(built)), 2)
    expect_false(any(vapply(built$x$data, function(tr) is.null(tr$legendgroup), logical(1))))
})

test_that("linePlot honours show.legend in the layout", {
    d <- .line_facet_data()

    fig <- linePlot(
        data = d,
        x = "x",
        y = "y",
        palette.selection = "#1b9e77",
        show.legend = FALSE
    )

    built <- suppressWarnings(plotly::plotly_build(fig))
    expect_false(built$x$layout$showlegend)

    fig_legend <- linePlot(
        data = d,
        x = "x",
        y = "y",
        colour.group.by = "grp",
        palette.selection = c("#1b9e77", "#d95f02", "#7570b3"),
        show.legend = TRUE
    )

    expect_true(suppressWarnings(plotly::plotly_build(fig_legend))$x$layout$showlegend)
})

test_that("linePlot frames every facet panel only when axis lines are on", {
    for (showline in c(TRUE, FALSE)) {
        fig <- linePlot(
            data = mtcars, x = "wt", y = "mpg", palette.selection = "Set2",
            facet.by = "cyl", axis.showline = showline, axis.mirror = showline
        )
        rect_shapes <- Filter(function(s) identical(s$type, "rect"), fig$x$layout$shapes)

        # One full box per facet panel, or none at all.
        expect_length(rect_shapes, if (showline) length(unique(mtcars$cyl)) else 0)
        for (s in rect_shapes) {
            expect_identical(s$xref, "paper")
            expect_identical(s$yref, "paper")
        }
    }
})

test_that("build_facet_panel_borders honours showline and mirror", {
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
    full <- build_facet_panel_borders(fig, 2, showline = TRUE, mirror = TRUE)
    expect_equal(length(full), 2)
    expect_true(all(vapply(full, function(s) identical(s$type, "rect"), logical(1))))

    # Left + bottom edges per panel when mirror is FALSE.
    edges <- build_facet_panel_borders(fig, 2, showline = TRUE, mirror = FALSE)
    expect_equal(length(edges), 4)
    expect_true(all(vapply(edges, function(s) identical(s$type, "line"), logical(1))))

    # No shapes when showline is FALSE.
    none <- build_facet_panel_borders(fig, 2, showline = FALSE, mirror = TRUE)
    expect_equal(length(none), 0)
})

test_that("build_facet_panel_borders draws a distinct box per panel across rows", {
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

    borders <- build_facet_panel_borders(
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

    # 5 panels in the same 3x2 grid leave the bottom-right cell empty.
    expect_length(build_facet_panel_borders(fig, 5, showline = TRUE, mirror = TRUE, ncol = 3, nrow = 2), 5)
})

test_that("linePlot facet titles sit just above their own panel when axes are shared", {
    # Fixed scales share axes, so plotly keeps one y axis per row and the second row
    # has no yaxis3/yaxis4 to read a domain from. Titles used to fall back to an
    # even grid that ignored the panel gaps, putting row 2's titles up against row 1.
    set.seed(1)
    d <- data.frame(x = rep(1:5, 3), y = rnorm(15), f = rep(c("A", "B", "C"), each = 5))
    for (scales in c("fixed", "free")) {
        built <- plotly::plotly_build(linePlot(
            data = d, x = "x", y = "y", palette.selection = "red",
            facet.by = "f", facet.nrow = 2, facet.scales = scales,
            subplot.margin = c(0.08, 0.12)
        ))
        panels <- Filter(function(s) identical(s$type, "rect"), built$x$layout$shapes)
        titles <- Filter(function(a) is.null(a$annotationType), built$x$layout$annotations)
        expect_length(panels, 3)
        expect_length(titles, 3)
        for (i in seq_along(titles)) {
            expect_equal(titles[[i]]$x, mean(c(panels[[i]]$x0, panels[[i]]$x1)))
            expect_equal(titles[[i]]$y, panels[[i]]$y1 + 0.02)
        }
    }
})

# Axis-title annotations as left by axis_titles_as_annotations() / build_facet_annotations().
.line_axis_title_anns <- function(fig) {
    Filter(function(a) identical(a$annotationType, "axis"), fig$x$layout$annotations)
}

test_that("linePlot applies axis title font to single-panel titles (#326)", {
    fig <- linePlot(
        data = mtcars, x = "wt", y = "mpg",
        palette.selection = "Set2", show.legend = FALSE,
        x.title = "wt", y.title = "mpg",
        axis.title.font.size = 36, axis.title.font.color = "#F51313",
        axis.title.font.family = "Courier New"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$xaxis$title$text, "wt")
    expect_equal(built$x$layout$yaxis$title$text, "mpg")
    expect_equal(built$x$layout$xaxis$title$font$size, 36)
    expect_equal(built$x$layout$yaxis$title$font$family, "Courier New")

    anns <- .line_axis_title_anns(axis_titles_as_annotations(fig))
    expect_length(anns, 2)
    for (a in anns) {
        expect_equal(a$font$size, 36)
        expect_equal(a$font$color, "#F51313")
        expect_equal(a$font$family, "Courier New")
    }
})

test_that("linePlot relabels the y title mean() only for a categorical x, keeping its font", {
    d <- data.frame(grp = rep(c("a", "b"), each = 3), val = 1:6)
    built <- plotly::plotly_build(linePlot(
        data = d, x = "grp", y = "val", palette.selection = "Set2",
        x.title = "grp", y.title = "val", axis.title.font.size = 25
    ))
    expect_equal(built$x$layout$yaxis$title$text, "mean(val)")
    expect_equal(built$x$layout$yaxis$title$font$size, 25)

    # A numeric x plots the values themselves, so the title stays plain.
    built <- plotly::plotly_build(linePlot(
        data = mtcars, x = "wt", y = "mpg", palette.selection = "Set2", y.title = "mpg"
    ))
    expect_equal(built$x$layout$yaxis$title$text, "mpg")
})

test_that("linePlot applies axis title font to faceted shared titles (#326)", {
    d <- .line_facet_data()
    single <- linePlot(
        data = d, x = "x", y = "y", colour.group.by = "grp", facet.by = "fct",
        palette.selection = c("red", "green", "blue"),
        x.title = "x", y.title = "y",
        axis.title.font.size = 30, axis.title.font.color = "#0000FF"
    )
    multi <- linePlot(
        data = d, x = "x", y = c("y", "y2"), facet.by = "fct",
        palette.selection = c("red", "green"),
        x.title = "x", y.title = "Value",
        axis.title.font.size = 30, axis.title.font.color = "#0000FF"
    )

    for (fig in list(single, multi)) {
        anns <- .line_axis_title_anns(plotly::plotly_build(fig))
        expect_length(anns, 2)
        for (a in anns) {
            expect_equal(a$font$size, 30)
            expect_equal(a$font$color, "#0000FF")
        }
    }
})

test_that("linePlot honours gridline colour", {
    built <- plotly::plotly_build(linePlot(
        data = mtcars, x = "wt", y = "mpg", palette.selection = "Set2",
        show.grid.x = FALSE, grid.color = "#FF0000"
    ))
    expect_false(built$x$layout$xaxis$showgrid)
    expect_equal(built$x$layout$xaxis$gridcolor, "#FF0000")
    expect_equal(built$x$layout$yaxis$gridcolor, "#FF0000")
})

test_that("linePlot styles facet panel titles with facet.title.font.*", {
    d <- .line_facet_data()
    single <- linePlot(
        data = d, x = "x", y = "y", facet.by = "fct", palette.selection = "red",
        facet.title.font.size = 40, facet.title.font.color = "#0000FF"
    )
    multi <- linePlot(
        data = d, x = "x", y = c("y", "y2"), facet.by = "fct",
        palette.selection = c("red", "green"),
        facet.title.font.size = 40, facet.title.font.color = "#0000FF"
    )
    for (fig in list(single, multi)) {
        titles <- Filter(function(a) is.null(a$annotationType), plotly::plotly_build(fig)$x$layout$annotations)
        expect_length(titles, 2)
        for (a in titles) {
            expect_equal(a$font$size, 40)
            expect_equal(a$font$color, "#0000FF")
        }
    }
})
