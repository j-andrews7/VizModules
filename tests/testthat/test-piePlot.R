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

test_that("piePlot passes its slice arguments through to the trace", {
    df <- data.frame(category = c("A", "B", "C"), count = c(5, 10, 15))
    custom_colors <- c("#FF0000", "#00FF00", "#0000FF")

    trace <- plotly::plotly_build(piePlot(
        df = df, labels = "category", values = "count",
        hole = 0.4, direction = "clockwise", rotation = 90,
        textinfo = "value", textposition = "inside",
        colors = custom_colors,
        slice.line.color = "#000000", slice.line.width = 2
    ))$x$data[[1]]

    expect_equal(trace$hole, 0.4)
    expect_equal(trace$direction, "clockwise")
    expect_equal(trace$rotation, 90)
    expect_equal(trace$textinfo, "value")
    expect_true(all(trace$textposition == "inside"))
    # `colors` is its own argument, separate from `palette`.
    expect_equal(as.character(trace$marker$colors), custom_colors)
    expect_equal(trace$marker$line$color, "#000000")
    expect_equal(trace$marker$line$width, 2)
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
