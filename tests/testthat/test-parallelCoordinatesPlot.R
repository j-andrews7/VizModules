# ─── parallelCoordinatesPlot ──────────────────────────────────────────────────

test_that("parallelCoordinatesPlot returns a plotly object", {
    fig <- parallelCoordinatesPlot(
        reactive.data = mtcars,
        dimensions = c("mpg", "cyl", "disp", "hp")
    )

    expect_s3_class(fig, "plotly")
})

test_that("parallelCoordinatesPlot creates parcoords trace", {
    fig <- parallelCoordinatesPlot(
        reactive.data = mtcars,
        dimensions = c("mpg", "cyl", "disp")
    )
    built <- plotly::plotly_build(fig)
    trace <- built$x$data[[1]]

    expect_equal(trace$type, "parcoords")
})

test_that("parallelCoordinatesPlot includes correct number of dimensions", {
    dims <- c("mpg", "cyl", "disp", "hp", "wt")
    fig <- parallelCoordinatesPlot(
        reactive.data = mtcars,
        dimensions = dims
    )
    built <- plotly::plotly_build(fig)
    trace <- built$x$data[[1]]

    expect_equal(length(trace$dimensions), length(dims))
})

test_that("parallelCoordinatesPlot handles color.by with numeric column", {
    fig <- parallelCoordinatesPlot(
        reactive.data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        color.by = "mpg",
        color.scale = "Viridis"
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    trace <- built$x$data[[1]]
    expect_equal(trace$line$colorscale, "Viridis")
})

test_that("parallelCoordinatesPlot sets title correctly", {
    fig <- parallelCoordinatesPlot(
        reactive.data = mtcars,
        dimensions = c("mpg", "cyl"),
        title.text = "My Parallel Coords"
    )
    built <- plotly::plotly_build(fig)

    expect_equal(built$x$layout$title$text, "My Parallel Coords")
})

test_that("parallelCoordinatesPlot handles categorical dimensions", {
    df <- data.frame(
        num = 1:6,
        cat = c("A", "B", "C", "A", "B", "C"),
        val = c(10, 20, 30, 15, 25, 35)
    )

    fig <- parallelCoordinatesPlot(
        reactive.data = df,
        dimensions = c("num", "cat", "val")
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    # Categorical dimension should have ticktext
    cat_dim <- built$x$data[[1]]$dimensions[[2]]
    expect_true(!is.null(cat_dim$ticktext))
})

test_that("parallelCoordinatesPlot works without color.by", {
    fig <- parallelCoordinatesPlot(
        reactive.data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        color.by = NULL
    )

    expect_s3_class(fig, "plotly")
})

test_that("parallelCoordinatesPlot respects styling parameters", {
    fig <- parallelCoordinatesPlot(
        reactive.data = mtcars,
        dimensions = c("mpg", "cyl"),
        label.font.size = 16,
        title.text = "Styled Plot",
        bgcolor = "#F0F0F0"
    )
    built <- plotly::plotly_build(fig)

    expect_equal(built$x$layout$paper_bgcolor, "#F0F0F0")
    expect_equal(built$x$data[[1]]$labelfont$size, 16)
})
