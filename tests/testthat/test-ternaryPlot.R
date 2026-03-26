test_that("ternaryPlot creates expected scatterternary trace", {
    df <- data.frame(a = c(75, 10, 20), b = c(25, 80, 70), c = c(0, 10, 10))
    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c")

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    trace <- built$x$data[[1]]
    expect_identical(trace$type, "scatterternary")
})

test_that("ternaryPlot handles grouped data", {
    df <- data.frame(
        a = c(60, 20, 30, 50),
        b = c(30, 50, 40, 30),
        c = c(10, 30, 30, 20),
        team = c("Alpha", "Alpha", "Beta", "Beta")
    )
    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c", group = "team")

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_true(length(built$x$data) >= 2)
})

test_that("ternaryPlot handles marker mode", {
    df <- data.frame(a = c(50, 20), b = c(30, 50), c = c(20, 30))
    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c",
        mode = "markers", marker.size = 12, marker.symbol = "diamond"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$data[[1]]$mode, "markers")
    expect_equal(built$x$data[[1]]$marker$size, 12)
    expect_equal(built$x$data[[1]]$marker$symbol, "diamond")
})

test_that("ternaryPlot handles lines+markers mode", {
    df <- data.frame(a = c(50, 20, 30), b = c(30, 50, 40), c = c(20, 30, 30))
    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c",
        mode = "lines+markers", line.width = 3, line.dash = "dot"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$data[[1]]$mode, "lines+markers")
})

test_that("ternaryPlot handles marker line styling", {
    df <- data.frame(a = c(50, 20), b = c(30, 50), c = c(20, 30))
    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c",
        marker.line.width = 2, marker.line.color = "#FF0000"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$data[[1]]$marker$line$width, 2)
    expect_equal(built$x$data[[1]]$marker$line$color, "#FF0000")
})

test_that("ternaryPlot handles opacity", {
    df <- data.frame(a = c(50, 20), b = c(30, 50), c = c(20, 30))
    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c", opacity = 0.5)

    attrs <- fig$x$attrs[[2]]
    expect_equal(attrs$marker$opacity, 0.5)
})

test_that("ternaryPlot handles axis titles", {
    df <- data.frame(a = c(50, 20), b = c(30, 50), c = c(20, 30))
    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c",
        a.title = "Component A", b.title = "Component B", c.title = "Component C"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$ternary$aaxis$title, "Component A")
    expect_equal(built$x$layout$ternary$baxis$title, "Component B")
    expect_equal(built$x$layout$ternary$caxis$title, "Component C")
})

test_that("ternaryPlot handles axis font sizes", {
    df <- data.frame(a = c(50, 20), b = c(30, 50), c = c(20, 30))
    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c",
        a.titlefont.size = 20, b.titlefont.size = 20, c.titlefont.size = 20
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$ternary$aaxis$titlefont$size, 20)
    expect_equal(built$x$layout$ternary$baxis$titlefont$size, 20)
    expect_equal(built$x$layout$ternary$caxis$titlefont$size, 20)
})

test_that("ternaryPlot handles grid colors", {
    df <- data.frame(a = c(50, 20), b = c(30, 50), c = c(20, 30))
    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c",
        a.gridcolor = "#FF0000", b.gridcolor = "#00FF00", c.gridcolor = "#0000FF"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$ternary$aaxis$gridcolor, "#FF0000")
    expect_equal(built$x$layout$ternary$baxis$gridcolor, "#00FF00")
    expect_equal(built$x$layout$ternary$caxis$gridcolor, "#0000FF")
})

test_that("ternaryPlot handles legend visibility", {
    df <- data.frame(a = c(50, 20), b = c(30, 50), c = c(20, 30))
    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c", show.legend = FALSE)

    built <- plotly::plotly_build(fig)
    expect_false(built$x$layout$showlegend)
})

test_that("ternaryPlot handles custom title", {
    df <- data.frame(a = c(50, 20), b = c(30, 50), c = c(20, 30))
    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c",
        title.text = "My Ternary", title.font.size = 20
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$text, "My Ternary")
    expect_equal(built$x$layout$title$font$size, 20)
})

test_that("ternaryPlot handles background color", {
    df <- data.frame(a = c(50, 20), b = c(30, 50), c = c(20, 30))
    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c", bgcolor = "#F0F0F0")

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$paper_bgcolor, "#F0F0F0")
})

test_that("ternaryPlot handles explicit colors with groups", {
    df <- data.frame(
        a = c(60, 20, 30, 50),
        b = c(30, 50, 40, 30),
        c = c(10, 30, 30, 20),
        team = c("Alpha", "Alpha", "Beta", "Beta")
    )
    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c", group = "team",
        colors = c("#FF0000", "#0000FF")
    )

    expect_s3_class(fig, "plotly")
})

test_that("ternaryPlot handles sum parameter", {
    df <- data.frame(a = c(0.5, 0.2), b = c(0.3, 0.5), c = c(0.2, 0.3))
    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c", sum = 1)

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$ternary$sum, 1)
})
