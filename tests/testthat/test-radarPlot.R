test_that("radarPlot creates expected scatterpolar trace", {
    df <- data.frame(
        category = c("Speed", "Strength", "Defense", "Stamina", "Agility"),
        value = c(8, 6, 7, 9, 5)
    )
    fig <- radarPlot(df = df, theta = "category", r = "value")

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    trace <- built$x$data[[1]]
    expect_identical(trace$type, "scatterpolar")
})

test_that("radarPlot handles grouped traces", {
    df <- data.frame(
        category = rep(c("Speed", "Strength", "Defense"), 2),
        value = c(8, 6, 7, 5, 9, 4),
        player = rep(c("Alice", "Bob"), each = 3)
    )
    fig <- radarPlot(df = df, theta = "category", r = "value", group = "player")

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_true(length(built$x$data) >= 2)
})

test_that("radarPlot handles fill parameter", {
    df <- data.frame(
        category = c("A", "B", "C", "D"),
        value = c(4, 7, 2, 9)
    )
    fig <- radarPlot(df = df, theta = "category", r = "value", fill = "toself")

    attrs <- fig$x$attrs[[2]]
    expect_equal(attrs$fill, "toself")

    fig_none <- radarPlot(df = df, theta = "category", r = "value", fill = "none")
    attrs_none <- fig_none$x$attrs[[2]]
    expect_equal(attrs_none$fill, "none")
})

test_that("radarPlot handles line styling", {
    df <- data.frame(
        category = c("A", "B", "C"),
        value = c(4, 7, 2)
    )
    fig <- radarPlot(
        df = df, theta = "category", r = "value",
        line.width = 4, line.dash = "dash"
    )

    attrs <- fig$x$attrs[[2]]
    expect_equal(attrs$line$width, 4)
    expect_equal(attrs$line$dash, "dash")
})

test_that("radarPlot handles marker styling", {
    df <- data.frame(
        category = c("A", "B", "C"),
        value = c(4, 7, 2)
    )
    fig <- radarPlot(
        df = df, theta = "category", r = "value",
        marker.size = 10, marker.symbol = "square"
    )

    attrs <- fig$x$attrs[[2]]
    expect_equal(attrs$marker$size, 10)
    expect_equal(attrs$marker$symbol, "square")
})

test_that("radarPlot handles opacity", {
    df <- data.frame(
        category = c("A", "B", "C"),
        value = c(4, 7, 2)
    )
    fig <- radarPlot(df = df, theta = "category", r = "value", opacity = 0.3)

    attrs <- fig$x$attrs[[2]]
    expect_equal(attrs$opacity, 0.3)
})

test_that("radarPlot handles radial axis options", {
    df <- data.frame(
        category = c("A", "B", "C"),
        value = c(4, 7, 2)
    )
    fig <- radarPlot(
        df = df, theta = "category", r = "value",
        radial.visible = FALSE, radial.range = c(0, 10)
    )

    built <- plotly::plotly_build(fig)
    expect_false(built$x$layout$polar$radialaxis$visible)
    expect_equal(built$x$layout$polar$radialaxis$range, c(0, 10))
})

test_that("radarPlot handles angular axis options", {
    df <- data.frame(
        category = c("A", "B", "C"),
        value = c(4, 7, 2)
    )
    fig <- radarPlot(
        df = df, theta = "category", r = "value",
        angular.direction = "counterclockwise", angular.rotation = 45
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$polar$angularaxis$direction, "counterclockwise")
    expect_equal(built$x$layout$polar$angularaxis$rotation, 45)
})

test_that("radarPlot handles legend visibility", {
    df <- data.frame(
        category = c("A", "B", "C"),
        value = c(4, 7, 2)
    )
    fig_no_legend <- radarPlot(
        df = df, theta = "category", r = "value",
        show.legend = FALSE
    )

    built <- plotly::plotly_build(fig_no_legend)
    expect_false(built$x$layout$showlegend)
})

test_that("radarPlot handles custom title", {
    df <- data.frame(
        category = c("A", "B", "C"),
        value = c(4, 7, 2)
    )
    fig <- radarPlot(
        df = df, theta = "category", r = "value",
        title.text = "My Radar", title.font.size = 24,
        title.font.color = "#FF0000"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$text, "My Radar")
    expect_equal(built$x$layout$title$font$size, 24)
})

test_that("radarPlot handles background colors", {
    df <- data.frame(
        category = c("A", "B", "C"),
        value = c(4, 7, 2)
    )
    fig <- radarPlot(
        df = df, theta = "category", r = "value",
        bgcolor = "#F0F0F0", polar.bgcolor = "#EAEAEA"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$paper_bgcolor, "#F0F0F0")
    expect_equal(built$x$layout$polar$bgcolor, "#EAEAEA")
})

test_that("radarPlot handles explicit colors", {
    df <- data.frame(
        category = rep(c("A", "B", "C"), 2),
        value = c(4, 7, 2, 5, 3, 8),
        group = rep(c("G1", "G2"), each = 3)
    )
    fig <- radarPlot(
        df = df, theta = "category", r = "value",
        group = "group", colors = c("#FF0000", "#0000FF")
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_true(length(built$x$data) >= 2)
})
