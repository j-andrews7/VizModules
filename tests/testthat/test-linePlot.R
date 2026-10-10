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

# ---- Error bars: SD, SEM and 95% CI (#368) ------------------------------------------------------

# Independent of error_bar_halfwidth(), so the two cannot drift together.
.expected_bar <- function(v, type, ci.method = "normal") {
    v <- v[!is.na(v)]
    n <- length(v)
    if (n < 2) {
        return(NA_real_)
    }
    sem <- sd(v) / sqrt(n)
    switch(type,
        sd = sd(v),
        sem = sem,
        ci95 = sem * if (ci.method == "t") qt(0.975, n - 1) else 1.959964
    )
}

# The error bar half-widths each drawn trace carries, in trace order.
.line_error_bars <- function(fig) {
    built <- suppressWarnings(plotly::plotly_build(fig))
    lapply(built$x$data, function(tr) as.numeric(tr$error_y$array))
}

# Three groups of 4, 6 and 1 (no spread to draw), so the sizes differ enough to tell the types apart.
.bar_data <- function() {
    data.frame(
        g = factor(rep(c("a", "b", "c"), c(4, 6, 1))),
        v = c(1, 3, 2, 8, 5, 7, 6, 9, 4, 10, 5)
    )
}

test_that("error_bar_halfwidth works out the SD, the SEM and both kinds of 95% CI", {
    x <- c(2, 4, 4, 4, 5, 5, 7, 9)
    spread <- sd(x)
    sem <- spread / sqrt(8)

    expect_equal(error_bar_halfwidth(x, "sd"), spread)
    expect_equal(error_bar_halfwidth(x, "sem"), sem)
    expect_equal(error_bar_halfwidth(x, "ci95", "normal"), qnorm(0.975) * sem)
    expect_equal(error_bar_halfwidth(x, "ci95", "t"), qt(0.975, 7) * sem)
    # The t interval is the wider one, and the method is ignored by the other types.
    expect_gt(error_bar_halfwidth(x, "ci95", "t"), error_bar_halfwidth(x, "ci95", "normal"))
    expect_equal(error_bar_halfwidth(x, "sd", "t"), spread)
    expect_equal(error_bar_halfwidth(x, "sem", "t"), sem)
    # SD is the default, and the normal interval the default CI.
    expect_equal(error_bar_halfwidth(x), spread)
    expect_equal(error_bar_halfwidth(x, "ci95"), qnorm(0.975) * sem)
    # A big group's t interval converges on the normal one.
    big <- seq(0, 1, length.out = 5000)
    expect_equal(
        error_bar_halfwidth(big, "ci95", "t"), error_bar_halfwidth(big, "ci95", "normal"),
        tolerance = 1e-3
    )
    expect_error(error_bar_halfwidth(x, "sdev"))
    expect_error(error_bar_halfwidth(x, "ci95", "z"))
})

test_that(".error_bar_halfwidth counts only the non-missing values and needs two of them", {
    x <- c(1, 3, NA, 5, 9, NA)
    complete <- x[!is.na(x)]
    for (type in c("sd", "sem", "ci95")) {
        expect_equal(error_bar_halfwidth(x, type), error_bar_halfwidth(complete, type))
    }
    # n is 4 here, not 6.
    expect_equal(error_bar_halfwidth(x, "sem"), sd(complete) / 2)

    for (type in c("sd", "sem", "ci95")) {
        expect_true(is.na(error_bar_halfwidth(5, type)))
        expect_true(is.na(error_bar_halfwidth(c(5, NA), type)))
        expect_true(is.na(error_bar_halfwidth(NA_real_, type)))
        expect_true(is.na(error_bar_halfwidth(numeric(0), type)))
    }
})

test_that("the error bar choices offered by the module are the ones linePlot() accepts", {
    expect_identical(unname(.error_bar_type_choices), eval(formals(linePlot)$error.type))
    expect_identical(unname(.error_bar_ci_method_choices), eval(formals(linePlot)$error.ci.method))
})

test_that("linePlot draws each group's SD, SEM or CI as its error bar (#368)", {
    d <- .bar_data()
    draw <- function(...) {
        .line_error_bars(linePlot(
            d, x = "g", y = "v", palette.selection = "black",
            error.bar = TRUE, error.colour = "#000000", error.width = 1, ...
        ))[[1]]
    }
    per_group <- function(type, ci.method = "normal") {
        as.numeric(tapply(d$v, d$g, .expected_bar, type = type, ci.method = ci.method))
    }

    expect_equal(draw(error.type = "sd"), per_group("sd"))
    expect_equal(draw(error.type = "sem"), per_group("sem"))
    expect_equal(draw(error.type = "ci95"), per_group("ci95", "normal"))
    expect_equal(draw(error.type = "ci95", error.ci.method = "normal"), per_group("ci95", "normal"))
    expect_equal(draw(error.type = "ci95", error.ci.method = "t"), per_group("ci95", "t"))

    # The single observation in group c has no spread, whatever the type.
    for (type in c("sd", "sem", "ci95")) {
        expect_true(is.na(draw(error.type = type)[3]))
    }
    # In the groups that do have one, SD > normal CI > SEM, and the t interval is wider than the normal one.
    expect_true(all(draw(error.type = "sd")[1:2] > draw(error.type = "sem")[1:2]))
    expect_true(all(draw(error.type = "ci95")[1:2] > draw(error.type = "sem")[1:2]))
    expect_true(all(draw(error.type = "ci95", error.ci.method = "t")[1:2] > draw(error.type = "ci95")[1:2]))
})

test_that("linePlot's error bars stay the SD unless asked otherwise, and reject unknown types", {
    d <- .bar_data()
    bars <- function(...) {
        .line_error_bars(linePlot(
            d, x = "g", y = "v", palette.selection = "black", error.bar = TRUE,
            error.colour = "#000000", error.width = 1, ...
        ))[[1]]
    }
    sd_bars <- as.numeric(tapply(d$v, d$g, .expected_bar, type = "sd"))

    expect_equal(bars(), sd_bars)
    expect_equal(bars(error.type = "sd"), sd_bars)
    # An input that has not reported yet arrives as NULL.
    expect_equal(bars(error.type = NULL, error.ci.method = NULL), sd_bars)

    expect_error(bars(error.type = "sdev"))
    expect_error(bars(error.type = "ci95", error.ci.method = "z"))
    # Off means no bars, whatever the type.
    off <- linePlot(d, x = "g", y = "v", palette.selection = "black", error.bar = FALSE, error.type = "sem")
    expect_null(plotly::plotly_build(off)$x$data[[1]]$error_y$array)
})

test_that("linePlot's error bars sit on their own colour group's points, however the column is stored", {
    # plotly re-sorts the data by the colour column but not an error bar array passed by value, so
    # bars used to land on other groups' points whenever the groups interleaved (any shared x).
    # .line_facet_data() also names its columns `x` and `y`, which used to shadow linePlot()'s
    # own arguments inside summarise() and silently drop the bars.
    base <- .line_facet_data()
    palette <- c("#1b9e77", "#d95f02", "#7570b3")
    stored_as <- list(
        character = function(g) g,
        # Mixed case, and not in alphabetical order of first appearance.
        mixed_case = function(g) unname(c(A = "m", B = "Z", C = "a")[g]),
        factor = function(g) factor(g, levels = c("B", "C", "A")),
        ordered = function(g) factor(g, levels = c("C", "A", "B"), ordered = TRUE)
    )

    for (repr in names(stored_as)) {
        d <- base
        d$grp <- stored_as[[repr]](d$grp)
        for (type in c("sd", "sem", "ci95")) {
            info <- paste(repr, type)
            fig <- linePlot(
                d, x = "x", y = "y", colour.group.by = "grp", palette.selection = palette,
                error.bar = TRUE, error.colour = "#000000", error.width = 1,
                error.type = type, error.ci.method = "t"
            )
            built <- suppressWarnings(plotly::plotly_build(fig))
            expect_length(built$x$data, 3)
            for (tr in built$x$data) {
                in_grp <- as.character(d$grp) == tr$name
                by_x <- tapply(d$y[in_grp], d$x[in_grp], .expected_bar, type = type, ci.method = "t")
                # Matched on the x each bar hangs from, not on position.
                expect_equal(
                    as.numeric(tr$error_y$array), as.numeric(by_x[as.character(tr$x)]),
                    info = paste(info, tr$name)
                )
            }

            # Faceted: each panel's groups are summarised on their own, not pooled across panels,
            # and every panel's bars sit on that panel's points.
            faceted <- suppressWarnings(plotly::plotly_build(linePlot(
                d, x = "x", y = "y", colour.group.by = "grp", facet.by = "fct", palette.selection = palette,
                error.bar = TRUE, error.colour = "#000000", error.width = 1, error.type = type
            )))
            expect_length(faceted$x$data, 6)
            for (tr in faceted$x$data) {
                # A trace's panel is not named on it, but only one panel has this group's
                # bars at these x positions.
                in_grp <- as.character(d$grp) == tr$name
                candidates <- lapply(split(d[in_grp, ], d$fct[in_grp]), function(s) {
                    as.numeric(tapply(s$y, s$x, .expected_bar, type = type)[as.character(tr$x)])
                })
                expect_true(
                    any(vapply(candidates, function(v) isTRUE(all.equal(v, as.numeric(tr$error_y$array))), logical(1))),
                    info = paste(info, "faceted", tr$name)
                )
            }
        }
    }
})

test_that(".group_rows_by_trace sorts by the colour column, keeping each group's row order", {
    d <- data.frame(g = c("b", "a", "c", "b", "a", "c"), id = 1:6, stringsAsFactors = FALSE)

    # Sorted order for characters, rows keeping their relative order within a group.
    expect_equal(.group_rows_by_trace(d, "g")$id, c(2, 5, 1, 4, 3, 6))

    # Level order for a factor, and for an ordered one too (plotly only reverses the traces).
    f <- transform(d, g = factor(g, levels = c("c", "b", "a")))
    expect_equal(.group_rows_by_trace(f, "g")$id, c(3, 6, 1, 4, 2, 5))
    o <- transform(d, g = factor(g, levels = c("c", "b", "a"), ordered = TRUE))
    expect_equal(.group_rows_by_trace(o, "g")$id, c(3, 6, 1, 4, 2, 5))
    l <- transform(d, g = c(TRUE, FALSE, TRUE, TRUE, FALSE, FALSE))
    expect_equal(.group_rows_by_trace(l, "g")$id, c(2, 5, 6, 1, 3, 4))

    # A level with no rows is skipped, and a numeric column is never split into traces.
    unused <- transform(d, g = factor(g, levels = c("z", "a", "b", "c")))
    expect_equal(.group_rows_by_trace(unused, "g")$id, c(2, 5, 1, 4, 3, 6))
    num <- transform(d, g = c(3, 1, 2, 3, 1, 2))
    expect_identical(.group_rows_by_trace(num, "g"), num)
})

test_that("linePlot's error bars describe the adjusted values the line is drawn from", {
    d <- .bar_data()
    bars <- .line_error_bars(linePlot(
        d, x = "g", y = "v", palette.selection = "black", y.adjustment = "log10",
        error.bar = TRUE, error.colour = "#000000", error.width = 1, error.type = "sem"
    ))[[1]]
    expect_equal(bars, as.numeric(tapply(log10(d$v), d$g, .expected_bar, type = "sem")))
})

# The inputs generate_linePlot() reads; testServer cannot drive the plot output, but the reactive
# that builds the figure can.
.line_inputs <- function(...) {
    utils::modifyList(list(
        x.value = "region", y.value = "revenue", group.by = "", order.by = FALSE,
        error.bar = TRUE, error.bar.colour = "#000000", error.bar.width = 1,
        auto.update = TRUE, update = 0, plot.mode = "lines", line.type = "solid",
        facet.by = "", facet.scales = "fixed", flip.x = FALSE, flip.y = FALSE, legend.show = TRUE
    ), list(...))
}

# The value a select is seeded with, read out of its rendered JSON config.
.seeded_select <- function(html, id) {
    m <- regmatches(html, regexec(
        paste0('data-for="', id, '">[^<]*?"selectedValue":"([^"]+)"'), html, perl = TRUE
    ))[[1]]
    m[2]
}

test_that("the linePlot module offers the error bar type and seeds it from defaults (#368)", {
    ui <- function(...) paste(as.character(linePlotInputsUI("lp", example_sales, ...)), collapse = "")

    plain <- ui()
    expect_equal(.seeded_select(plain, "lp-error.bar.type"), "sd")
    expect_equal(.seeded_select(plain, "lp-error.bar.ci.method"), "normal")

    seeded <- ui(defaults = list(error.bar.type = "ci95", error.bar.ci.method = "t"))
    expect_equal(.seeded_select(seeded, "lp-error.bar.type"), "ci95")
    expect_equal(.seeded_select(seeded, "lp-error.bar.ci.method"), "t")

    # A value that is not one of the choices falls back rather than seeding a blank select.
    bogus <- ui(defaults = list(error.bar.type = "variance", error.bar.ci.method = "z"))
    expect_equal(.seeded_select(bogus, "lp-error.bar.type"), "sd")
    expect_equal(.seeded_select(bogus, "lp-error.bar.ci.method"), "normal")
})

test_that("the linePlot module draws the error bar type and CI method chosen (#368)", {
    by_region <- function(type, ci.method = "normal") {
        as.numeric(tapply(example_sales$revenue, example_sales$region, .expected_bar,
            type = type, ci.method = ci.method))
    }

    shiny::testServer(
        linePlotServer,
        args = list(id = "lp", data = shiny::reactive(example_sales)),
        {
            drawn <- function(...) {
                do.call(session$setInputs, .line_inputs(...))
                suppressWarnings(session$flushReact())
                .line_error_bars(generate_linePlot())[[1]]
            }

            expect_equal(drawn(error.bar.type = "sem"), by_region("sem"))
            expect_equal(drawn(error.bar.type = "ci95", error.bar.ci.method = "normal"), by_region("ci95", "normal"))
            expect_equal(drawn(error.bar.type = "ci95", error.bar.ci.method = "t"), by_region("ci95", "t"))
            # The method only matters to a CI.
            expect_equal(drawn(error.bar.type = "sd", error.bar.ci.method = "t"), by_region("sd"))
        }
    )

    # Before either input has reported, the bars are the SD.
    shiny::testServer(
        linePlotServer,
        args = list(id = "lp", data = shiny::reactive(example_sales)),
        {
            do.call(session$setInputs, .line_inputs())
            suppressWarnings(session$flushReact())
            expect_equal(.line_error_bars(generate_linePlot())[[1]], by_region("sd"))
        }
    )
})

test_that("linePlot Group By leaves out categoricals with too many levels", {
    df <- .wide_id_df()
    group <- .select_choices(as.character(linePlotInputsUI("line", df)), "line-group.by")
    expect_true(all(c("grp", "grp2", "flag") %in% group))
    expect_false(any(c("id", "val") %in% group))

    # An explicit default naming the wide column is honoured.
    html <- as.character(linePlotInputsUI("line", df, defaults = list(group.by = "id")))
    expect_true("id" %in% .select_choices(html, "line-group.by"))
})

# ---- Ribbons, and intervals from columns (#371) -------------------------------------------------

# The ribbon traces of a figure, in trace order.
.line_ribbons <- function(fig) {
    built <- suppressWarnings(plotly::plotly_build(fig))
    Filter(function(tr) identical(tr$fill, "toself"), built$x$data)
}

# One side's vertices of a ribbon trace, named by the x each sits at.
.ribbon_edge <- function(tr, side) {
    on_side <- as.character(unlist(tr$text)) %in% side
    stats::setNames(as.numeric(unlist(tr$y))[on_side], as.character(unlist(tr$x))[on_side])
}

# A numeric x with each point's bounds; the bounds at t = 3 are missing.
.bound_data <- function() {
    data.frame(t = 1:6, est = c(2, 3, 5, 4, 6, 7), lo = c(1, 2, NA, 3, 5, 6), hi = c(3, 4.5, 6, 5, 7, 9))
}

test_that(".ribbon_rows outlines each unbroken run of intervals, series by series", {
    d <- data.frame(
        g = c("b", "b", "b", "b", "a", "a"), x = c(1, 2, 3, 4, 1, 2), y = c(1, 2, 3, 4, 5, 6),
        err_lo = c(0, 1, NA, 3, 4, 5), err_hi = c(2, 3, NA, 5, 6, 7)
    )
    rows <- .ribbon_rows(d, "y", "g")

    # Upper bounds forward, then lower bounds back.
    a <- rows[rows$g == "a", ]
    expect_equal(a$x, c(1, 2, 2, 1))
    expect_equal(a$y, c(6, 7, 5, 4))
    expect_equal(a$.ribbon_side, c("Upper", "Upper", "Lower", "Lower"))
    expect_equal(unique(a$.ribbon_part), 1)

    # The missing interval at x = 3 splits series b into two outlines rather than being bridged.
    b <- rows[rows$g == "b", ]
    expect_equal(b$x, c(1, 2, 2, 1, 4, 4))
    expect_equal(b$y, c(2, 3, 1, 0, 5, 3))
    expect_equal(b$.ribbon_part, c(1, 1, 1, 1, 2, 2))

    # Without a colour column the rows are one series, and every column keeps its type.
    expect_equal(.ribbon_rows(d[1:4, ], "y")$.ribbon_part, c(1, 1, 1, 1, 2, 2))
    for (stored in list(factor(d$g, levels = c("b", "a")), factor(d$g, levels = c("b", "a"), ordered = TRUE))) {
        typed <- d
        typed$g <- stored
        kept <- .ribbon_rows(typed, "y", "g")$g
        expect_identical(class(kept), class(stored))
        expect_identical(levels(kept), levels(stored))
    }

    expect_null(.ribbon_rows(transform(d, err_lo = NA_real_), "y", "g"))
    expect_null(.ribbon_rows(d[, c("g", "x", "y")], "y", "g"))
})

test_that("linePlot draws each group's SD, SEM or CI as a ribbon around its line (#371)", {
    d <- .bar_data()
    means <- c(tapply(d$v, d$g, mean))
    for (type in c("sd", "sem", "ci95")) {
        for (ci.method in c("normal", "t")) {
            info <- paste(type, ci.method)
            fig <- linePlot(
                d, x = "g", y = "v", palette.selection = "#1B9E77",
                error.type = type, error.ci.method = ci.method, error.ribbon = TRUE
            )
            ribbons <- expect_ribbons_on_lines(fig)
            expect_length(ribbons, 1)

            # Group c has a single value and no interval, so the band spans a and b only.
            hw <- c(tapply(d$v, d$g, .expected_bar, type = type, ci.method = ci.method))
            expect_equal(.ribbon_edge(ribbons[[1]], "Upper"), (means + hw)[c("a", "b")], info = info)
            expect_equal(.ribbon_edge(ribbons[[1]], "Lower"), (means - hw)[c("b", "a")], info = info)
        }
    }

    # Off by default.
    expect_length(.line_ribbons(linePlot(d, x = "g", y = "v", palette.selection = "#1B9E77")), 0)
})

test_that("linePlot's ribbons sit under their own colour group's line, in its colour (#371)", {
    base <- .line_facet_data()
    palette <- c("#1b9e77", "#d95f02", "#7570b3")
    stored_as <- list(
        character = function(g) g,
        factor = function(g) factor(g, levels = c("B", "C", "A")),
        ordered = function(g) factor(g, levels = c("C", "A", "B"), ordered = TRUE)
    )

    for (repr in names(stored_as)) {
        d <- base
        d$grp <- stored_as[[repr]](d$grp)
        fig <- linePlot(
            d, x = "x", y = "y", colour.group.by = "grp", palette.selection = palette,
            error.ribbon = TRUE, error.ribbon.opacity = 0.4, error.type = "sem"
        )
        built <- suppressWarnings(plotly::plotly_build(fig))
        is_ribbon <- vapply(built$x$data, function(tr) identical(tr$fill, "toself"), logical(1))
        expect_equal(sum(is_ribbon), 3, info = repr)
        # Added first, so they are drawn underneath.
        expect_true(max(which(is_ribbon)) < min(which(!is_ribbon)), info = repr)
        expect_ribbons_on_lines(fig, min.count = 3)

        lines <- built$x$data[!is_ribbon]
        for (rb in built$x$data[is_ribbon]) {
            ln <- Filter(function(tr) identical(as.character(tr$name), as.character(rb$name)), lines)[[1]]
            expect_identical(rb$fillcolor, sub(",1\\)$", ",0.4)", ln$line$color), info = paste(repr, rb$name))

            in_grp <- as.character(d$grp) == as.character(rb$name)
            by_x <- tapply(d$y[in_grp], d$x[in_grp], function(v) mean(v) + .expected_bar(v, "sem"))
            upper <- .ribbon_edge(rb, "Upper")
            expect_equal(unname(upper), as.numeric(by_x[names(upper)]), info = paste(repr, rb$name))
        }

        # Faceted: each panel's bands are worked out from that panel's rows.
        faceted <- linePlot(
            d, x = "x", y = "y", colour.group.by = "grp", facet.by = "fct", palette.selection = palette,
            error.ribbon = TRUE, error.bar = TRUE, error.colour = "#000000", error.width = 1
        )
        expect_length(expect_ribbons_on_lines(faceted, min.count = 6), 6)
    }
})

test_that("linePlot draws an interval from bound columns on a numeric x (#371)", {
    bd <- .bound_data()
    draw <- function(...) {
        linePlot(
            bd, x = "t", y = "est", palette.selection = "#1B9E77", error.type = "columns",
            error.ribbon = TRUE, error.bar = TRUE, ...
        )
    }
    fig <- draw(error.lower = "lo", error.upper = "hi")
    ribbons <- expect_ribbons_on_lines(fig)
    expect_length(ribbons, 1)
    # The point without bounds at t = 3 leaves a gap: two outlines, each upper edge forward and
    # lower edge back.
    ok <- !is.na(bd$lo)
    expect_equal(unname(.ribbon_edge(ribbons[[1]], "Upper")), bd$hi[ok])
    expect_equal(unname(.ribbon_edge(ribbons[[1]], "Lower")), c(rev(bd$lo[1:2]), rev(bd$lo[4:6])))
    expect_equal(sum(is.na(unlist(ribbons[[1]]$y))), 1)

    # The bars reach each bound, so they need not be symmetric. Half an interval is none.
    line <- suppressWarnings(plotly::plotly_build(fig))$x$data[[2]]
    expect_equal(as.numeric(line$error_y$array), ifelse(ok, bd$hi - bd$est, NA))
    expect_equal(as.numeric(line$error_y$arrayminus), bd$est - bd$lo)

    # Either column may hold the lower bound.
    swapped <- suppressWarnings(plotly::plotly_build(draw(error.lower = "hi", error.upper = "lo")))$x$data
    expect_equal(swapped[[1]]$y, ribbons[[1]]$y)
    expect_equal(as.numeric(swapped[[2]]$error_y$array), ifelse(ok, bd$hi - bd$est, NA))

    # Without both bounds there is nothing to draw, and a bound must be a numeric column.
    expect_length(.line_ribbons(draw(error.lower = "lo")), 0)
    expect_error(draw(error.lower = "lo", error.upper = "nope"), "numeric columns")
    expect_error(
        linePlot(transform(bd, label = "a"), x = "t", y = "est", palette.selection = "red",
            error.type = "columns", error.lower = "lo", error.upper = "label"),
        "numeric columns"
    )
})

test_that("linePlot's bound columns take the y adjustment and are averaged per category (#371)", {
    bd <- .bound_data()
    fig <- linePlot(
        bd, x = "t", y = "est", palette.selection = "#1B9E77", y.adjustment = "log10",
        error.type = "columns", error.lower = "lo", error.upper = "hi", error.ribbon = TRUE, error.bar = TRUE
    )
    ribbons <- expect_ribbons_on_lines(fig)
    ok <- !is.na(bd$lo)
    expect_equal(unname(.ribbon_edge(ribbons[[1]], "Upper")), log10(bd$hi[ok]))
    line <- suppressWarnings(plotly::plotly_build(fig))$x$data[[2]]
    expect_equal(as.numeric(line$error_y$array), ifelse(ok, log10(bd$hi) - log10(bd$est), NA))

    # A categorical x plots each category's mean, and its bounds are averaged the same way.
    d <- data.frame(g = c("a", "a", "b", "b"), v = c(1, 3, 5, 7), lo = c(0, 2, 4, 4), hi = c(2, 6, 8, 10))
    ribbons <- .line_ribbons(linePlot(
        d, x = "g", y = "v", palette.selection = "red",
        error.type = "columns", error.lower = "lo", error.upper = "hi", error.ribbon = TRUE
    ))
    expect_equal(.ribbon_edge(ribbons[[1]], "Upper"), c(a = 4, b = 9))
    expect_equal(.ribbon_edge(ribbons[[1]], "Lower"), c(b = 4, a = 1))
})

test_that("linePlot only draws a ribbon where there are separate lines to band (#371)", {
    # A numeric colour is one trace drawn with a gradient.
    cars <- transform(mtcars, lo = mpg - 1, hi = mpg + 1)
    expect_length(.line_ribbons(linePlot(
        cars, x = "wt", y = "mpg", colour.group.by = "gear", palette.selection = "Set2",
        error.type = "columns", error.lower = "lo", error.upper = "hi", error.ribbon = TRUE
    )), 0)
    # Several y columns have no single interval.
    d <- .line_facet_data()
    expect_length(.line_ribbons(linePlot(
        d, x = "rep", y = c("y", "y2"), palette.selection = c("red", "blue"), error.ribbon = TRUE
    )), 0)
    # SD, SEM and CI need a categorical x.
    expect_length(.line_ribbons(linePlot(
        mtcars, x = "wt", y = "mpg", palette.selection = "red", error.ribbon = TRUE
    )), 0)
})

test_that("linePlot's ribbon leaves a character x-axis in the order its lines give it (#371)", {
    d <- data.frame(
        g = rep(c("A", "B"), each = 8),
        x = c(rep(c("q", "r", "s", "t"), each = 2), "q", "q", "r", "s", "s", "t", "t", "t"),
        v = c(1:8, 2:9)
    )
    order_of <- function(ribbon) {
        built <- suppressWarnings(plotly::plotly_build(linePlot(
            d, x = "x", y = "v", colour.group.by = "g", palette.selection = c("red", "blue"),
            order.by = "v", error.ribbon = ribbon
        )))
        built$x$layout$xaxis$categoryarray
    }
    # B's single "r" has no interval, so its band skips that category.
    expect_identical(order_of(TRUE), order_of(FALSE))
})

test_that("a single line takes its colour from the palette, as do its ribbon and bars (#371)", {
    built <- suppressWarnings(plotly::plotly_build(linePlot(
        .bar_data(), x = "g", y = "v", palette.selection = c("#E41A1C", "#377EB8"), plot.mode = "lines+markers",
        error.ribbon = TRUE, error.bar = TRUE
    )))
    ribbon <- built$x$data[[1]]
    line <- built$x$data[[2]]
    expect_identical(ribbon$fill, "toself")
    expect_equal(line$line$color, "#E41A1C")
    expect_equal(line$marker$color, "#E41A1C")
    expect_equal(line$error_y$color, "#E41A1C")
    expect_equal(ribbon$fillcolor, plotly::toRGB("#E41A1C", 0.25))

    # A palette plotly resolves itself still builds, falling back to plotly's first colour.
    line <- plotly::plotly_build(linePlot(mtcars, x = "wt", y = "mpg", palette.selection = "Set2"))$x$data[[1]]
    expect_equal(line$line$color, "#1F77B4")
})

test_that("linePlot keeps the ribbon opacity between 0 and 1, falling back to 0.25", {
    opacity_of <- function(opacity) {
        ribbon <- .line_ribbons(linePlot(
            .bar_data(), x = "g", y = "v", palette.selection = "#E41A1C",
            error.ribbon = TRUE, error.ribbon.opacity = opacity
        ))[[1]]
        as.numeric(sub(".*,([0-9.]+)\\)$", "\\1", ribbon$fillcolor))
    }
    expect_equal(opacity_of(0.6), 0.6)
    expect_equal(opacity_of(NULL), 0.25)
    expect_equal(opacity_of(NA), 0.25)
    expect_equal(opacity_of("lots"), 0.25)
    expect_equal(opacity_of(3), 1)
    expect_equal(opacity_of(-1), 0)
})

test_that("the linePlot module seeds the ribbon and bound inputs from defaults (#371)", {
    html <- paste(as.character(linePlotInputsUI("lp", example_sales, defaults = list(
        error.bar.type = "columns", error.lower = "profit", error.upper = "units",
        error.ribbon = TRUE, error.ribbon.opacity = 0.6
    ))), collapse = "")
    expect_equal(.seeded_select(html, "lp-error.bar.type"), "columns")
    expect_equal(.seeded_select(html, "lp-error.lower"), "profit")
    expect_equal(.seeded_select(html, "lp-error.upper"), "units")
    expect_match(html, '<input id="lp-error.ribbon" type="checkbox" checked', fixed = TRUE)
    expect_match(html, 'id="lp-error.ribbon.opacity" type="number" class="shiny-input-number form-control" value="0.6"',
        fixed = TRUE)

    # The bounds are numeric columns only; anything else falls back to none.
    expect_false("region" %in% .select_choices(html, "lp-error.lower"))
    plain <- paste(as.character(linePlotInputsUI("lp", example_sales, defaults = list(error.lower = "region"))),
        collapse = "")
    expect_true(is.na(.seeded_select(plain, "lp-error.lower")))
    expect_match(plain, '<input id="lp-error.ribbon" type="checkbox"/>', fixed = TRUE)
})

test_that("the linePlot module draws ribbons and intervals from columns (#371)", {
    by_region <- function(f, col = "revenue") as.numeric(tapply(example_sales[[col]], example_sales$region, f))
    shiny::testServer(
        linePlotServer,
        args = list(id = "lp", data = shiny::reactive(example_sales)),
        {
            ribbons <- function(...) {
                do.call(session$setInputs, .line_inputs(error.ribbon = TRUE, ...))
                suppressWarnings(session$flushReact())
                .line_ribbons(generate_linePlot())
            }

            rb <- ribbons(error.bar.type = "sem")
            expect_length(rb, 1)
            expect_equal(
                unname(.ribbon_edge(rb[[1]], "Upper")),
                by_region(mean) + by_region(function(v) .expected_bar(v, "sem"))
            )

            rb <- ribbons(error.bar.type = "columns", error.lower = "profit", error.upper = "units")
            expect_equal(unname(.ribbon_edge(rb[[1]], "Upper")), by_region(mean, "units"))
            expect_equal(rev(unname(.ribbon_edge(rb[[1]], "Lower"))), by_region(mean, "profit"))

            # A bound left over from another dataset, or a blank one, draws nothing rather than failing.
            expect_length(ribbons(error.bar.type = "columns", error.lower = "gone", error.upper = "units"), 0)
            expect_length(ribbons(error.bar.type = "columns", error.lower = "", error.upper = "units"), 0)
            # Switched off, there is no ribbon.
            do.call(session$setInputs, .line_inputs(error.ribbon = FALSE, error.bar.type = "sem"))
            suppressWarnings(session$flushReact())
            expect_length(.line_ribbons(generate_linePlot()), 0)
        }
    )
})
