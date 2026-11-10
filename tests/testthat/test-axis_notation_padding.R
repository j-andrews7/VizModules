# apply_tick_notation() and apply_axis_padding(), the Axes tab's tick notation and
# padding, and their wiring into the modules' styling step.

.big_bars <- function() {
    p <- ggplot2::ggplot(data.frame(x = c("a", "b"), y = c(1e5, 3e5)), ggplot2::aes(x, y)) +
        ggplot2::geom_col()
    plotly::ggplotly(p)
}

test_that("apply_tick_notation keeps ggplotly's ticks out of scientific notation unless asked", {
    fig <- .big_bars()
    expect_true(any(grepl("e+", plotly::plotly_build(fig)$x$layout$yaxis$ticktext, fixed = TRUE)))

    plain <- apply_tick_notation(fig)$x$layout
    expect_identical(plain$yaxis$ticktext, c("0", "100000", "200000", "300000"))
    expect_identical(plain$xaxis$ticktext, c("a", "b"))

    sci <- apply_tick_notation(fig, scientific = TRUE)$x$layout
    expect_identical(sci$yaxis$ticktext, c("0", paste0(1:3, "×10<sup>5</sup>")))
    expect_identical(sci$xaxis$ticktext, c("a", "b"))
})

test_that("apply_tick_notation leaves categories that look like numbers and plain labels alone", {
    box <- plotly::ggplotly(ggplot2::ggplot(mtcars, ggplot2::aes(factor(cyl), mpg)) + ggplot2::geom_boxplot())
    expect_identical(apply_tick_notation(box, TRUE)$x$layout$xaxis$ticktext, c("4", "6", "8"))

    # Labels without e-notation are kept as ggplot wrote them when it is off.
    small <- plotly::ggplotly(ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point())
    before <- plotly::plotly_build(small)$x$layout$yaxis$ticktext
    expect_identical(apply_tick_notation(small)$x$layout$yaxis$ticktext, before)
})

test_that("apply_tick_notation sets plotly's own exponent format on a native axis", {
    fig <- plotly::plot_ly(x = c(1, 2), y = c(1e5, 3e5), type = "scatter", mode = "markers")
    expect_null(apply_tick_notation(fig)$x$layout$yaxis$exponentformat)
    sci <- apply_tick_notation(fig, scientific = TRUE)$x$layout$yaxis
    expect_identical(sci$exponentformat, "power")
    expect_identical(sci$showexponent, "all")
})

test_that("apply_axis_padding fits each axis to the data drawn on it", {
    fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
    padded <- apply_axis_padding(fig, x = 0, y = 0.1)$x$layout
    expect_equal(padded$xaxis$range, range(mtcars$wt))
    expect_equal(padded$yaxis$range, range(mtcars$mpg) + c(-0.1, 0.1) * diff(range(mtcars$mpg)))
    expect_false(padded$xaxis$autorange)

    # NULL or NA leaves an axis as it was.
    expect_null(apply_axis_padding(fig, x = 0)$x$layout$yaxis$range)
    expect_identical(apply_axis_padding(fig, x = NA, y = NULL), fig)
})

test_that("apply_axis_padding removes ggplot's expansion, from bars' base and categories' bands", {
    df <- data.frame(year = 2000:2020, n = cumsum(c(5, rep(1, 20))))
    area <- plotly::ggplotly(ggplot2::ggplot(df, ggplot2::aes(year, n)) + ggplot2::geom_area())
    expect_equal(apply_axis_padding(area, x = 0)$x$layout$xaxis$range, c(2000, 2020))

    bars <- apply_axis_padding(.big_bars(), x = 0, y = 0)$x$layout
    expect_equal(bars$yaxis$range, c(0, 3e5))
    expect_equal(bars$xaxis$range, c(0.5, 2.5))
})

test_that("apply_axis_padding keeps fixed facet scales shared and swaps for a rotated plot", {
    faceted <- plotly::ggplotly(
        ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point() + ggplot2::facet_wrap(~cyl)
    )
    layout <- apply_axis_padding(faceted, x = 0)$x$layout
    ranges <- lapply(grep("^xaxis", names(layout), value = TRUE), function(a) layout[[a]]$range)
    expect_length(unique(ranges), 1)
    expect_equal(ranges[[1]], range(mtcars$wt))

    fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
    swapped <- apply_axis_padding(fig, x = 0, swap = TRUE)$x$layout
    expect_equal(swapped$yaxis$range, range(mtcars$mpg))
    expect_null(swapped$xaxis$range)
})

test_that("apply_axis_padding keeps reversed axes reversed and skips overlay axes", {
    fig <- plotly::layout(
        plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers"),
        xaxis = list(autorange = "reversed")
    )
    expect_equal(apply_axis_padding(fig, x = 0)$x$layout$xaxis$range, rev(range(mtcars$wt)))

    marg <- add_marginal_plots(
        plotly::plot_ly(example_iris, x = ~Sepal.Length, y = ~Sepal.Width, type = "scatter", mode = "markers"),
        x = example_iris$Sepal.Length, y = example_iris$Sepal.Width, top = "density"
    )
    strip <- marg$x$layout$yaxis2$range
    padded <- apply_axis_padding(marg, x = 0, y = 0)$x$layout
    expect_equal(padded$yaxis2$range, strip)
    expect_equal(padded$xaxis$range, range(example_iris$Sepal.Length))
})

test_that("apply_axis_padding fits category axes by category position", {
    # linePlot's x is a category axis when x is a factor: the categories sit at 0 to n - 1.
    lines <- plotly::plot_ly(
        x = factor(c("2015", "2016", "2017")), y = c(3, 5, 4), type = "scatter", mode = "lines"
    )
    expect_equal(apply_axis_padding(lines, x = 0)$x$layout$xaxis$range, c(0, 2))
    expect_equal(apply_axis_padding(lines, x = 0.5)$x$layout$xaxis$range, c(-1, 3))

    # Bars span their width around each category; an alphabetical order is followed.
    bars <- plotly::layout(
        plotly::plot_ly(x = c("b", "a", "c"), y = 1:3, type = "bar"),
        xaxis = list(categoryorder = "category ascending")
    )
    expect_equal(apply_axis_padding(bars, x = 0)$x$layout$xaxis$range, c(-0.4, 2.4))
    expect_equal(.axis_categories(plotly::plotly_build(bars), "xaxis"), c("a", "b", "c"))
})

test_that("the Axes tab offers padding only on axes without their own limits", {
    ns <- shiny::NS("m")
    html <- as.character(uniform_axes_inputs_ui(ns))
    for (id in c("m-axis.padding.x", "m-axis.padding.y", "m-axis.scientific")) {
        expect_true(grepl(id, html, fixed = TRUE), info = id)
    }
    html <- as.character(uniform_axes_inputs_ui(ns, include.padding = "x"))
    expect_true(grepl("m-axis.padding.x", html, fixed = TRUE))
    expect_false(grepl("m-axis.padding.y", html, fixed = TRUE))
})

test_that("apply_uniform_styling applies the padding and notation inputs", {
    input <- list(
        title.font.size = 20, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.horizontal.position = 0.5, axis.title.font.size = 16,
        axis.title.font.family = "Arial", axis.title.font.color = "#000000",
        axis.tickfont.size = 12, axis.tickfont.family = "Arial", axis.tickfont.color = "#000000",
        axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
        axis.tickcolor = "#000000", axis.ticklen = 5, axis.tickwidth = 1,
        show.grid.x = TRUE, show.grid.y = FALSE, grid.color = "#CCCCCC", download.format = "svg",
        axis.scientific = FALSE, axis.padding.x = 0, axis.padding.y = 0
    )
    fig <- plotly::plotly_build(apply_uniform_styling(.big_bars(), input, isolate_fn = identity))
    expect_equal(fig$x$layout$yaxis$range, c(0, 3e5))
    expect_false(any(grepl("e+", fig$x$layout$yaxis$ticktext, fixed = TRUE)))

    # An axis left out of padding.axes keeps its range.
    kept <- plotly::plotly_build(apply_uniform_styling(.big_bars(), input, isolate_fn = identity, padding.axes = "x"))
    expect_false(isTRUE(all.equal(kept$x$layout$yaxis$range, c(0, 3e5))))
    expect_equal(kept$x$layout$xaxis$range, c(0.5, 2.5))
})
