# ─── ternaryPlot ──────────────────────────────────────────────────────────────

test_that("ternaryPlot returns a plotly object", {
    df <- data.frame(a = c(75, 10, 20), b = c(25, 80, 70), c = c(0, 10, 10))

    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c")

    expect_s3_class(fig, "plotly")
})

test_that("ternaryPlot creates scatterternary trace", {
    df <- data.frame(a = c(75, 10, 20), b = c(25, 80, 70), c = c(0, 10, 10))

    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c")
    built <- plotly::plotly_build(fig)
    trace <- built$x$data[[1]]

    expect_equal(trace$type, "scatterternary")
    expect_equal(trace$mode, "markers")
})

test_that("ternaryPlot handles multiple groups", {
    df <- data.frame(
        a = c(75, 10, 20, 5),
        b = c(25, 80, 70, 60),
        c = c(0, 10, 10, 35),
        team = c("A", "A", "B", "B")
    )

    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c", group = "team")
    built <- plotly::plotly_build(fig)

    expect_s3_class(fig, "plotly")
    expect_equal(length(built$x$data), 2)
    expect_equal(built$x$data[[1]]$name, "A")
    expect_equal(built$x$data[[2]]$name, "B")
})

test_that("ternaryPlot sets axis titles", {
    df <- data.frame(a = c(75, 10), b = c(25, 80), c = c(0, 10))

    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c",
        a.title = "Journalist", b.title = "Developer", c.title = "Designer"
    )
    built <- plotly::plotly_build(fig)

    expect_equal(built$x$layout$ternary$aaxis$title, "Journalist")
    expect_equal(built$x$layout$ternary$baxis$title, "Developer")
    expect_equal(built$x$layout$ternary$caxis$title, "Designer")
})

test_that("ternaryPlot sets title correctly", {
    df <- data.frame(a = c(75, 10), b = c(25, 80), c = c(0, 10))

    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c",
        title.text = "My Ternary"
    )
    built <- plotly::plotly_build(fig)

    expect_equal(built$x$layout$title$text, "My Ternary")
})

test_that("ternaryPlot supports lines+markers mode", {
    df <- data.frame(a = c(75, 10, 20), b = c(25, 80, 70), c = c(0, 10, 10))

    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c", mode = "lines+markers")
    built <- plotly::plotly_build(fig)

    expect_equal(built$x$data[[1]]$mode, "lines+markers")
})

test_that("ternaryPlot validates input columns exist", {
    df <- data.frame(a = c(75, 10), b = c(25, 80), c = c(0, 10))

    expect_error(ternaryPlot(df = df, a = "missing", b = "b", c = "c"))
    expect_error(ternaryPlot(df = df, a = "a", b = "missing", c = "c"))
    expect_error(ternaryPlot(df = df, a = "a", b = "b", c = "missing"))
})

test_that("ternaryPlot validates numeric columns", {
    df <- data.frame(a = c("x", "y"), b = c(25, 80), c = c(0, 10))

    expect_error(ternaryPlot(df = df, a = "a", b = "b", c = "c"))
})

test_that("ternaryPlot respects custom colors", {
    df <- data.frame(a = c(75, 10), b = c(25, 80), c = c(0, 10))

    fig <- ternaryPlot(
        df = df, a = "a", b = "b", c = "c",
        colors = c("#FF0000")
    )
    built <- plotly::plotly_build(fig)

    expect_equal(built$x$data[[1]]$marker$color, "#FF0000")
})
