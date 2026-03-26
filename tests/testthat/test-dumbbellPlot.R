test_that("dumbbellPlot creates expected trace structure", {
    df <- data.frame(
        School = c("MIT", "Stanford", "Harvard"),
        Women = c(94, 96, 112),
        Men = c(152, 151, 165)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue")
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_true(length(built$x$data) >= 2)
})

test_that("dumbbellPlot handles colour.by parameter", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )

    fig_x <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        colour.by = "X variables", palette.selection = c("pink", "blue")
    )
    expect_s3_class(fig_x, "plotly")

    fig_y <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        colour.by = "Y variables", palette.selection = c("red", "green")
    )
    expect_s3_class(fig_y, "plotly")
})

test_that("dumbbellPlot handles custom line colour", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        line.colour = "#FF0000"
    )

    expect_s3_class(fig, "plotly")
})

test_that("dumbbellPlot handles legend visibility", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"), show.legend = FALSE
    )

    built <- plotly::plotly_build(fig)
    expect_false(built$x$layout$showlegend)
})

test_that("dumbbellPlot handles custom titles", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        title.text = "Earnings Gap", x.title = "Salary ($K)", y.title = "School"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$text, "Earnings Gap")
})

test_that("dumbbellPlot handles axis flipping", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        flip.x = TRUE, flip.y = TRUE
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$xaxis$autorange, "reversed")
    expect_equal(built$x$layout$yaxis$autorange, "reversed")
})

test_that("dumbbellPlot handles axis styling", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        axis.showline = FALSE, axis.linecolor = "#999999",
        axis.tickfont.size = 14, axis.tickfont.color = "#333333"
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_false(built$x$layout$xaxis$showline)
})

test_that("dumbbellPlot handles faceting", {
    df <- data.frame(
        School = c("MIT", "Stanford", "Harvard", "Yale"),
        Women = c(94, 96, 112, 88),
        Men = c(152, 151, 165, 140),
        Region = c("East", "West", "East", "East")
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        facet.by = "Region"
    )

    expect_s3_class(fig, "plotly")
})

test_that("dumbbellPlot handles x.adjustment", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        x.adjustment = "log2"
    )

    expect_s3_class(fig, "plotly")
})

test_that("dumbbellPlot handles title font styling", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        title.text = "Test", title.font.size = 30,
        title.font.family = "Courier", title.font.color = "#0000FF"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$font$size, 30)
    expect_equal(built$x$layout$title$font$family, "Courier")
})
