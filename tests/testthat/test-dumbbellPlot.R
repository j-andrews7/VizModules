# ─── dumbbellPlot ─────────────────────────────────────────────────────────────

test_that("dumbbellPlot returns a plotly object in dumbbell mode", {
    data <- data.frame(
        School = c("MIT", "Stanford", "Harvard"),
        Women = c(94, 96, 112),
        Men = c(152, 151, 165)
    )

    fig <- dumbbellPlot(
        reactive.data = data,
        x = c("Women", "Men"),
        y = "School",
        colour.by = "X variables",
        palette.selection = c("pink", "blue"),
        show.legend = TRUE
    )

    expect_s3_class(fig, "plotly")
})

test_that("dumbbellPlot returns a plotly object in single dot mode", {
    data <- data.frame(
        School = c("MIT", "Stanford", "Harvard"),
        Score = c(94, 96, 112)
    )

    fig <- dumbbellPlot(
        reactive.data = data,
        x = "Score",
        y = "School",
        colour.by = "X variables",
        palette.selection = c("steelblue"),
        show.legend = TRUE
    )

    expect_s3_class(fig, "plotly")
})

test_that("dumbbellPlot creates scatter traces", {
    data <- data.frame(
        School = c("MIT", "Stanford", "Harvard"),
        Women = c(94, 96, 112),
        Men = c(152, 151, 165)
    )

    fig <- dumbbellPlot(
        reactive.data = data,
        x = c("Women", "Men"),
        y = "School",
        colour.by = "X variables",
        palette.selection = c("pink", "blue"),
        show.legend = TRUE
    )
    built <- plotly::plotly_build(fig)

    # Should contain scatter traces
    trace_types <- vapply(built$x$data, function(t) t$type, character(1))
    expect_true("scatter" %in% trace_types)
})

test_that("dumbbellPlot handles colour by Y variables", {
    data <- data.frame(
        School = c("MIT", "Stanford", "Harvard"),
        Women = c(94, 96, 112),
        Men = c(152, 151, 165)
    )

    fig <- dumbbellPlot(
        reactive.data = data,
        x = c("Women", "Men"),
        y = "School",
        colour.by = "Y variables",
        palette.selection = c("red", "green", "blue"),
        show.legend = TRUE
    )

    expect_s3_class(fig, "plotly")
})

test_that("dumbbellPlot sets title correctly", {
    data <- data.frame(
        School = c("MIT", "Stanford"),
        Score = c(94, 96)
    )

    fig <- dumbbellPlot(
        reactive.data = data,
        x = "Score",
        y = "School",
        palette.selection = c("blue"),
        title.text = "My Dumbbell"
    )
    built <- plotly::plotly_build(fig)

    expect_equal(built$x$layout$title$text, "My Dumbbell")
})

test_that("dumbbellPlot handles axis flipping", {
    data <- data.frame(
        School = c("MIT", "Stanford"),
        Score = c(94, 96)
    )

    fig <- dumbbellPlot(
        reactive.data = data,
        x = "Score",
        y = "School",
        palette.selection = c("blue"),
        flip.x = TRUE
    )
    built <- plotly::plotly_build(fig)

    expect_equal(built$x$layout$xaxis$autorange, "reversed")
})

test_that("dumbbellPlot truncates x to max 2 variables", {
    data <- data.frame(
        School = c("MIT", "Stanford"),
        A = c(1, 2), B = c(3, 4), C = c(5, 6)
    )

    # Should not error even with 3 x values (truncated to 2)
    fig <- dumbbellPlot(
        reactive.data = data,
        x = c("A", "B", "C"),
        y = "School",
        palette.selection = c("red", "blue"),
        show.legend = TRUE
    )

    expect_s3_class(fig, "plotly")
})

test_that("dumbbellPlot handles faceting", {
    data <- data.frame(
        School = c("MIT", "Stanford", "Harvard", "Yale"),
        Score = c(94, 96, 112, 105),
        Region = c("East", "West", "East", "East")
    )

    fig <- dumbbellPlot(
        reactive.data = data,
        x = "Score",
        y = "School",
        palette.selection = c("blue"),
        facet.by = "Region"
    )

    expect_s3_class(fig, "plotly")
})
