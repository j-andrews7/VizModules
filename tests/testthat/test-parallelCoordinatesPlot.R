test_that("parallelCoordinatesPlot draws one parcoords axis per dimension", {
    for (dims in list(c("mpg", "hp"), c("mpg", "cyl", "disp", "hp"), c("mpg", "cyl", "disp", "hp", "wt"))) {
        trace <- plotly::plotly_build(parallelCoordinatesPlot(data = mtcars, dimensions = dims))$x$data[[1]]
        expect_identical(trace$type, "parcoords")
        expect_length(trace$dimensions, length(dims))
    }
})

test_that("parallelCoordinatesPlot colours lines by a numeric column on the chosen scale", {
    line <- plotly::plotly_build(parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        color.by = "hp",
        color.scale = "Viridis"
    ))$x$data[[1]]$line

    expect_equal(as.numeric(line$color), mtcars$hp)
    expect_equal(as.character(line$colorscale), "Viridis")
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
    # plotly's parcoords renderer drops colorscales with duplicate stop
    # positions, so the positions must be strictly increasing.
    positions <- vapply(line$colorscale, function(stop) stop[[1]], numeric(1))
    expect_false(is.unsorted(positions, strictly = TRUE))
    # The custom scale must be respected rather than auto-generated.
    expect_false(isTRUE(line$autocolorscale))
    # Colors used in the scale should match the palette
    scale_colors <- toupper(vapply(line$colorscale, function(stop) stop[[2]], character(1)))
    expect_true(all(toupper(unname(pal)) %in% scale_colors))
    # Colorbar should show categorical tick text
    expect_equal(as.character(line$colorbar$ticktext), c("A", "B", "C"))
    expect_equal(as.numeric(line$colorbar$tickvals), c(1, 2, 3))
    # Range is padded half a step so each integer value centres in its band
    expect_equal(line$cmin, 0.5)
    expect_equal(line$cmax, 3.5)
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

test_that("parallelCoordinatesPlot shows or hides the colorbar", {
    for (show in c(TRUE, FALSE)) {
        line <- plotly::plotly_build(parallelCoordinatesPlot(
            data = mtcars, dimensions = c("mpg", "cyl", "disp"),
            color.by = "hp", show.colorbar = show
        ))$x$data[[1]]$line
        expect_identical(isTRUE(line$showscale), show)
    }
})

test_that("parallelCoordinatesPlot styles its lines, label and tick fonts", {
    trace <- plotly::plotly_build(parallelCoordinatesPlot(
        data = mtcars,
        dimensions = c("mpg", "cyl", "disp"),
        line.width = 2,
        label.font.size = 16, label.font.color = "#FF0000", label.font.family = "Courier",
        tick.font.size = 14, tick.font.color = "#0000FF", tick.font.family = "Times"
    ))$x$data[[1]]

    expect_equal(trace$line$width, 2)
    expect_equal(trace$labelfont$size, 16)
    expect_equal(trace$labelfont$color, "#FF0000")
    expect_equal(trace$labelfont$family, "Courier")
    expect_equal(trace$tickfont$size, 14)
    expect_equal(trace$tickfont$color, "#0000FF")
    expect_equal(trace$tickfont$family, "Times")
})

test_that("parallelCoordinatesPlot Color By keeps numerics but leaves out wide categoricals", {
    df <- .wide_id_df()
    color <- .select_choices(as.character(parallelCoordinatesPlotInputsUI("pc", df)), "pc-color.by")
    # Numeric columns stay for the continuous colour scale; the 60-level ID column is gone.
    expect_true(all(c("val", "val2", "grp", "grp2", "flag") %in% color))
    expect_false("id" %in% color)

    # An explicit default naming the wide column is honoured.
    html <- as.character(parallelCoordinatesPlotInputsUI("pc", df, defaults = list(color.by = "id")))
    expect_true("id" %in% .select_choices(html, "pc-color.by"))
})
