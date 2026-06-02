test_that("parallelCoordinatesPlot creates expected parcoords trace", {
    fig <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp", "hp")
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    trace <- built$x$data[[1]]
    expect_identical(trace$type, "parcoords")
})

test_that("parallelCoordinatesPlot handles color.by parameter", {
    fig <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        color.by = "hp"
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_false(is.null(built$x$data[[1]]$line$color))
})

test_that("parallelCoordinatesPlot handles color.scale parameter", {
    fig <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        color.by = "hp",
        color.scale = "Viridis"
    )

    expect_s3_class(fig, "plotly")
})

test_that("parallelCoordinatesPlot uses palette.selection for categorical color.by", {
    df <- mtcars
    df$grp <- rep(c("A", "B", "C"), length.out = nrow(df))
    pal <- c(A = "#FF0000", B = "#00FF00", C = "#0000FF")

    fig <- parallelCoordinatesPlot(
        data = df,
        dimensions = c("mpg", "cyl", "disp"),
        color.by = "grp",
        palette.selection = pal
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    line <- built$x$data[[1]]$line

    # Discrete colorscale should be a list of [position, color] stops, not a string
    expect_true(is.list(line$colorscale))
    # Colors used in the scale should match the palette
    scale_colors <- toupper(vapply(line$colorscale, function(stop) stop[[2]], character(1)))
    expect_true(all(toupper(unname(pal)) %in% scale_colors))
    # Colorbar should show categorical tick text
    expect_equal(as.character(line$colorbar$ticktext), c("A", "B", "C"))
    expect_equal(as.numeric(line$colorbar$tickvals), c(1, 2, 3))
    expect_equal(line$cmin, 1)
    expect_equal(line$cmax, 3)
})

test_that("parallelCoordinatesPlot falls back to color.scale when palette.selection is NULL", {
    df <- mtcars
    df$grp <- rep(c("A", "B"), length.out = nrow(df))

    fig <- parallelCoordinatesPlot(
        data = df,
        dimensions = c("mpg", "cyl", "disp"),
        color.by = "grp",
        color.scale = "Viridis"
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    # When no palette.selection is given, the colorscale stays as the named plotly scale string
    expect_true(is.character(built$x$data[[1]]$line$colorscale))
    expect_equal(as.character(built$x$data[[1]]$line$colorscale), "Viridis")
})

test_that("parallelCoordinatesPlot handles line styling", {
    fig <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        line.opacity = 0.3, line.width = 2
    )

    expect_s3_class(fig, "plotly")
})

test_that("parallelCoordinatesPlot handles colorbar visibility", {
    fig_bar <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        color.by = "hp", show.colorbar = TRUE
    )
    expect_s3_class(fig_bar, "plotly")

    fig_no_bar <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        color.by = "hp", show.colorbar = FALSE
    )
    expect_s3_class(fig_no_bar, "plotly")
})

test_that("parallelCoordinatesPlot handles label font styling", {
    fig <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        label.font.size = 16, label.font.color = "#FF0000",
        label.font.family = "Courier"
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_equal(built$x$data[[1]]$labelfont$size, 16)
    expect_equal(built$x$data[[1]]$labelfont$color, "#FF0000")
    expect_equal(built$x$data[[1]]$labelfont$family, "Courier")
})

test_that("parallelCoordinatesPlot handles tick font styling", {
    fig <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        tick.font.size = 14, tick.font.color = "#0000FF",
        tick.font.family = "Times"
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_equal(built$x$data[[1]]$tickfont$size, 14)
    expect_equal(built$x$data[[1]]$tickfont$color, "#0000FF")
    expect_equal(built$x$data[[1]]$tickfont$family, "Times")
})

test_that("parallelCoordinatesPlot handles custom title", {
    fig <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        title.text = "Car Dimensions",
        title.font.size = 24,
        title.font.family = "Helvetica",
        title.font.color = "#333333"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$text, "Car Dimensions")
    expect_equal(built$x$layout$title$font$size, 24)
    expect_equal(built$x$layout$title$font$family, "Helvetica")
})

test_that("parallelCoordinatesPlot handles background color", {
    fig <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        bgcolor = "#F5F5F5"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$paper_bgcolor, "#F5F5F5")
})

test_that("parallelCoordinatesPlot creates correct number of dimensions", {
    dims <- c("mpg", "cyl", "disp", "hp", "wt")
    fig <- parallelCoordinatesPlot(data = mtcars, dimensions = dims)

    built <- plotly::plotly_build(fig)
    expect_equal(length(built$x$data[[1]]$dimensions), length(dims))
})

test_that("parallelCoordinatesPlot handles two dimensions", {
    fig <- parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "hp")
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_equal(length(built$x$data[[1]]$dimensions), 2)
})
