test_that("piePlot example creates expected pie trace", {
    status_counts <- data.frame(
        status = c("Upregulated", "Downregulated", "Not significant"),
        n = c(12, 7, 3)
    )
    palette <- c("#1B9E77", "#D95F02", "#7570B3")

    fig <- piePlot(
        df = status_counts,
        labels = "status",
        values = "n",
        palette = palette,
        sort = FALSE,
        title.text = "Genes by status"
    )

    expect_s3_class(fig, "plotly")

    built <- plotly::plotly_build(fig)
    trace <- built$x$data[[1]]

    expect_identical(trace$type, "pie")
    expect_equal(as.character(trace$labels), as.character(status_counts$status))
    expect_equal(as.numeric(trace$values), as.numeric(status_counts$n))
    expect_equal(as.character(trace$marker$colors), as.character(palette))
    expect_match(built$x$layout$title$text, "Genes by status")
    expect_true(isTRUE(built$x$layout$showlegend))
})

test_that("piePlot creates donut chart with hole parameter", {
    df <- data.frame(category = c("A", "B", "C"), count = c(5, 10, 15))
    fig <- piePlot(df = df, labels = "category", values = "count", hole = 0.4)

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_equal(built$x$data[[1]]$hole, 0.4)
})

test_that("piePlot respects sort and direction parameters", {
    df <- data.frame(category = c("X", "Y", "Z"), count = c(3, 1, 2))

    fig_sorted <- piePlot(df = df, labels = "category", values = "count", sort = TRUE)
    expect_s3_class(fig_sorted, "plotly")

    fig_unsorted <- piePlot(df = df, labels = "category", values = "count", sort = FALSE)
    expect_s3_class(fig_unsorted, "plotly")

    fig_cw <- piePlot(
        df = df, labels = "category", values = "count",
        direction = "clockwise"
    )
    built_cw <- plotly::plotly_build(fig_cw)
    expect_equal(built_cw$x$data[[1]]$direction, "clockwise")
})

test_that("piePlot handles rotation parameter", {
    df <- data.frame(category = c("A", "B"), count = c(10, 20))
    fig <- piePlot(df = df, labels = "category", values = "count", rotation = 90)

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$data[[1]]$rotation, 90)
})

test_that("piePlot handles textinfo and textposition", {
    df <- data.frame(category = c("A", "B", "C"), count = c(5, 10, 15))

    fig <- piePlot(
        df = df, labels = "category", values = "count",
        textinfo = "value", textposition = "inside"
    )
    built <- plotly::plotly_build(fig)
    expect_equal(built$x$data[[1]]$textinfo, "value")
    expect_true(all(built$x$data[[1]]$textposition == "inside"))
})

test_that("piePlot handles legend visibility", {
    df <- data.frame(category = c("A", "B"), count = c(10, 20))

    fig_legend <- piePlot(df = df, labels = "category", values = "count", show.legend = TRUE)
    built_legend <- plotly::plotly_build(fig_legend)
    expect_true(built_legend$x$layout$showlegend)

    fig_no_legend <- piePlot(df = df, labels = "category", values = "count", show.legend = FALSE)
    built_no_legend <- plotly::plotly_build(fig_no_legend)
    expect_false(built_no_legend$x$layout$showlegend)
})

test_that("piePlot handles custom title styling", {
    df <- data.frame(category = c("A", "B"), count = c(10, 20))
    fig <- piePlot(
        df = df, labels = "category", values = "count",
        title.text = "My Pie", title.font.size = 24,
        title.font.family = "Courier", title.font.color = "#FF0000"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$text, "My Pie")
    expect_equal(built$x$layout$title$font$size, 24)
    expect_equal(built$x$layout$title$font$family, "Courier")
    expect_equal(built$x$layout$title$font$color, "#FF0000")
})

test_that("piePlot handles explicit colors vector", {
    df <- data.frame(category = c("A", "B", "C"), count = c(5, 10, 15))
    custom_colors <- c("#FF0000", "#00FF00", "#0000FF")
    fig <- piePlot(df = df, labels = "category", values = "count", colors = custom_colors)

    built <- plotly::plotly_build(fig)
    expect_equal(as.character(built$x$data[[1]]$marker$colors), custom_colors)
})

test_that("piePlot handles slice line styling", {
    df <- data.frame(category = c("A", "B"), count = c(10, 20))
    fig <- piePlot(
        df = df, labels = "category", values = "count",
        slice.line.color = "#000000", slice.line.width = 2
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$data[[1]]$marker$line$color, "#000000")
    expect_equal(built$x$data[[1]]$marker$line$width, 2)
})

test_that("piePlot handles legend positioning", {
    df <- data.frame(category = c("A", "B"), count = c(10, 20))
    fig <- piePlot(
        df = df, labels = "category", values = "count",
        legend.orientation = "v", legend.x = 1.0, legend.y = 0.5
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$legend$orientation, "v")
    expect_equal(built$x$layout$legend$x, 1.0)
    expect_equal(built$x$layout$legend$y, 0.5)
})
