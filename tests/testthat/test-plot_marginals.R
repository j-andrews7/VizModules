.iris_fig <- function() {
    plotly::plot_ly(example_iris,
        x = ~Sepal.Length, y = ~Sepal.Width, type = "scatter", mode = "markers"
    )
}

.iris_colors <- c(setosa = "#E69F00", versicolor = "#56B4E9", virginica = "#009E73")

.iris_marginals <- function(fig = .iris_fig(), ...) {
    add_marginal_plots(fig,
        x = example_iris$Sepal.Length, y = example_iris$Sepal.Width,
        groups = example_iris$Species, colors = .iris_colors, ...
    )
}

# The traces drawn off the main panel, i.e. the marginals.
.marginal_traces_of <- function(fig) {
    Filter(function(tr) !identical(tr$xaxis %||% "x", "x") || !identical(tr$yaxis %||% "y", "y"), fig$x$data)
}

.axis_of <- function(fig, ref) fig$x$layout[[sub("^([xy])", "\\1axis", ref)]]

test_that("no marginals leaves the figure as it was", {
    fig <- .iris_fig()
    expect_identical(add_marginal_plots(fig, example_iris$Sepal.Length, example_iris$Sepal.Width), fig)
})

test_that("a top density draws one curve per group on an axis matched to the plot's X", {
    fig <- .iris_marginals(top = "density")
    traces <- .marginal_traces_of(fig)

    expect_length(traces, 3)
    expect_equal(vapply(traces, `[[`, character(1), "name"), names(.iris_colors))
    expect_equal(vapply(traces, function(tr) tr$line$color, character(1)), unname(.iris_colors))
    expect_equal(vapply(traces, `[[`, character(1), "legendgroup"), names(.iris_colors))
    expect_true(all(vapply(traces, function(tr) identical(tr$mode, "lines") && isFALSE(tr$showlegend), logical(1))))

    value.axis <- .axis_of(fig, traces[[1]]$xaxis)
    expect_identical(value.axis$matches, "x")
    expect_equal(value.axis$domain, fig$x$layout$xaxis$domain)
    expect_lt(fig$x$layout$yaxis$domain[2], 1)
    expect_equal(fig$x$layout$xaxis$domain, c(0, 1))

    # Each curve spans its own group's values, as ggplot2's densities do.
    for (tr in traces) {
        v <- example_iris$Sepal.Length[example_iris$Species == tr$name]
        expect_equal(range(tr$x), range(v))
    }
})

test_that("a right histogram counts every point, in bins the groups share", {
    fig <- .iris_marginals(right = "histogram", bins = 12)
    traces <- .marginal_traces_of(fig)
    expect_length(traces, 3)
    expect_identical(.axis_of(fig, traces[[1]]$yaxis)$matches, "y")

    for (tr in traces) {
        # The step outline's vertices pair up as (left, top) and (right, top) of each bin.
        counts <- tr$x[seq(2, length(tr$x) - 1, by = 2)]
        expect_length(counts, 12)
        expect_equal(sum(counts), sum(example_iris$Species == tr$name))
    }
    expect_identical(traces[[1]]$y, traces[[2]]$y)
    expect_identical(traces[[1]]$y, traces[[3]]$y)
})

test_that("a bin width aligns the histogram's bins to its multiples", {
    traces <- .marginal_traces_of(.iris_marginals(top = "histogram", binwidth = 0.5))
    edges <- unique(traces[[1]]$x)
    expect_equal(diff(edges), rep(0.5, length(edges) - 1))
    expect_equal(edges[1] %% 0.5, 0)
    expect_lte(edges[1], min(example_iris$Sepal.Length))
    expect_gte(edges[length(edges)], max(example_iris$Sepal.Length))
})

test_that("with a density, the histogram is drawn first and scaled to match it", {
    traces <- .marginal_traces_of(.iris_marginals(top = c("density", "histogram"), bins = 10))
    expect_length(traces, 6)
    # Histograms carry per-vertex hover text, densities a hovertemplate.
    is.hist <- vapply(traces, function(tr) !is.null(tr$text), logical(1))
    expect_equal(is.hist, rep(c(TRUE, FALSE), each = 3))

    for (tr in traces[is.hist]) {
        edges <- unique(tr$x)
        heights <- tr$y[seq(2, length(tr$y) - 1, by = 2)]
        expect_equal(sum(heights * diff(edges)), 1)
    }
    # Both share one strip.
    expect_length(unique(vapply(traces, `[[`, character(1), "yaxis")), 1)
})

test_that("the rug gives each group its own lane, one tick per point", {
    fig <- .iris_marginals(top = "rug", right = "rug", rug.length = 0.8, rug.width = 3)
    traces <- .marginal_traces_of(fig)
    top <- Filter(function(tr) identical(.axis_of(fig, tr$xaxis)$matches, "x"), traces)
    right <- Filter(function(tr) identical(.axis_of(fig, tr$yaxis)$matches, "y"), traces)
    expect_length(top, 3)
    expect_length(right, 3)
    expect_true(all(vapply(traces, function(tr) tr$line$width == 3, logical(1))))

    lane <- function(v) range(v, na.rm = TRUE)
    # The first group takes the top lane above the plot and the leftmost beside it.
    expect_equal(lapply(top, function(tr) lane(tr$y)), list(c(2.1, 2.9), c(1.1, 1.9), c(0.1, 0.9)))
    expect_equal(lapply(right, function(tr) lane(tr$x)), list(c(0.1, 0.9), c(1.1, 1.9), c(2.1, 2.9)))
    expect_equal(.axis_of(fig, top[[1]]$yaxis)$range, c(0, 3))

    for (tr in top) {
        ticks <- tr$x[!is.na(tr$x)]
        v <- example_iris$Sepal.Length[example_iris$Species == tr$name]
        expect_equal(sort(ticks[c(TRUE, FALSE)]), sort(v))
    }
})

test_that("a rug and a density on one side get their own strips, the rug nearest the plot", {
    fig <- .iris_marginals(top = c("density", "rug"), top.size = 0.2, rug.size = 0.25, gap = 0.02)
    traces <- .marginal_traces_of(fig)
    expect_length(unique(vapply(traces, `[[`, character(1), "xaxis")), 1)

    strips <- split(traces, vapply(traces, function(tr) is.null(tr$hovertemplate), logical(1)))
    rug.axis <- .axis_of(fig, strips[["TRUE"]][[1]]$yaxis)
    dist.axis <- .axis_of(fig, strips[["FALSE"]][[1]]$yaxis)

    expect_equal(rug.axis$domain[1], 0.8)
    expect_equal(dist.axis$domain[2], 1)
    expect_lt(rug.axis$domain[2], dist.axis$domain[1])
    # The rug takes its share of the side, the split sitting midway in the inner gap.
    expect_equal(mean(c(rug.axis$domain[2], dist.axis$domain[1])), 0.8 + 0.2 * 0.25)
    expect_equal(fig$x$layout$yaxis$domain, c(0, 0.78))
})

test_that("the panel border and axis titles move into the shrunk panel", {
    fig <- plotly::layout(.iris_fig(),
        xaxis = list(title = "Length"), yaxis = list(title = "Width"),
        shapes = list(list(type = "rect", xref = "paper", yref = "paper", x0 = 0, x1 = 1, y0 = 0, y1 = 1))
    )
    fig <- .iris_marginals(axis_titles_as_annotations(fig), top = "density", right = "density",
        top.size = 0.2, right.size = 0.1, gap = 0.02
    )
    expect_equal(fig$x$layout$xaxis$domain, c(0, 0.88))
    expect_equal(fig$x$layout$yaxis$domain, c(0, 0.78))

    border <- fig$x$layout$shapes[[1]]
    expect_equal(c(border$x0, border$x1, border$y0, border$y1), c(0, 0.88, 0, 0.78))

    titles <- Filter(function(a) identical(a$annotationType, "axis"), fig$x$layout$annotations)
    x.title <- titles[[which(vapply(titles, function(a) is.null(a$textangle), logical(1)))]]
    y.title <- titles[[which(vapply(titles, function(a) !is.null(a$textangle), logical(1)))]]
    expect_equal(c(x.title$x, x.title$y), c(0.44, -0.1))
    expect_equal(c(y.title$x, y.title$y), c(-0.05, 0.39))
})

test_that("ungrouped marginals take the single colour, and non-finite values are dropped", {
    x <- c(example_iris$Sepal.Length, NA, Inf)
    y <- c(example_iris$Sepal.Width, 1, NA)
    fig <- add_marginal_plots(.iris_fig(), x, y, colors = "#123456", top = "rug", right = "density")
    traces <- .marginal_traces_of(fig)
    expect_length(traces, 2)
    expect_null(traces[[1]]$legendgroup)
    expect_equal(traces[[2]]$line$color, "#123456")
    expect_equal(sum(!is.na(traces[[1]]$x)) / 2, nrow(example_iris))
})

test_that("marginals are WebGL-ready and add no build warnings", {
    fig <- .iris_marginals(plotly::toWebGL(.iris_fig()), top = c("density", "rug"), right = "histogram")
    expect_no_warning(built <- plotly::plotly_build(fig))
    types <- vapply(.marginal_traces_of(built), `[[`, character(1), "type")
    expect_true(all(types == "scattergl"))
})
