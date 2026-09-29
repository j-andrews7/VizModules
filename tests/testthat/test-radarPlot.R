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

test_that("radarPlot draws one coloured trace per group", {
    df <- data.frame(
        category = rep(c("Speed", "Strength", "Defense"), 2),
        value = c(8, 6, 7, 5, 9, 4),
        player = rep(c("Alice", "Bob"), each = 3)
    )
    built <- plotly::plotly_build(radarPlot(
        df = df, theta = "category", r = "value", group = "player",
        colors = c("#FF0000", "#0000FF")
    ))

    groups <- Filter(function(tr) !is.null(tr$name), built$x$data)
    expect_equal(vapply(groups, function(tr) tr$name, character(1)), c("Alice", "Bob"))
    expect_equal(vapply(groups, function(tr) tr$line$color, character(1)), c("#FF0000", "#0000FF"))

    # Without colours, each group still gets its own from the fallback palette.
    built <- plotly::plotly_build(radarPlot(df = df, theta = "category", r = "value", group = "player"))
    groups <- Filter(function(tr) !is.null(tr$name), built$x$data)
    expect_length(unique(vapply(groups, function(tr) tr$line$color, character(1))), 2)
})

test_that("radarPlot passes its trace styling through", {
    df <- data.frame(category = c("A", "B", "C"), value = c(4, 7, 2))
    attrs <- radarPlot(
        df = df, theta = "category", r = "value",
        fill = "none", line.width = 4, line.dash = "dash",
        marker.size = 10, marker.symbol = "square", opacity = 0.3
    )$x$attrs[[2]]

    expect_equal(attrs$fill, "none")
    expect_equal(attrs$line$width, 4)
    expect_equal(attrs$line$dash, "dash")
    expect_equal(attrs$marker$size, 10)
    expect_equal(attrs$marker$symbol, "square")
    expect_equal(attrs$opacity, 0.3)
    expect_equal(radarPlot(df = df, theta = "category", r = "value", fill = "toself")$x$attrs[[2]]$fill, "toself")
})

test_that("radarPlot applies its polar layout options", {
    df <- data.frame(category = c("A", "B", "C"), value = c(4, 7, 2))
    polar <- plotly::plotly_build(radarPlot(
        df = df, theta = "category", r = "value",
        radial.visible = FALSE, radial.range = c(0, 10),
        angular.direction = "counterclockwise", angular.rotation = 45,
        polar.bgcolor = "#EAEAEA"
    ))$x$layout$polar

    expect_false(polar$radialaxis$visible)
    expect_equal(polar$radialaxis$range, c(0, 10))
    expect_equal(polar$angularaxis$direction, "counterclockwise")
    expect_equal(polar$angularaxis$rotation, 45)
    expect_equal(polar$bgcolor, "#EAEAEA")
})
