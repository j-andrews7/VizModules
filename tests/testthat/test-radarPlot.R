# ─── radarPlot ────────────────────────────────────────────────────────────────

test_that("radarPlot returns a plotly object", {
    skills <- data.frame(
        category = c("Speed", "Strength", "Defense", "Stamina"),
        value = c(8, 6, 7, 9)
    )

    fig <- radarPlot(df = skills, theta = "category", r = "value")

    expect_s3_class(fig, "plotly")
})

test_that("radarPlot creates scatterpolar trace with lines+markers", {
    skills <- data.frame(
        category = c("Speed", "Strength", "Defense", "Stamina"),
        value = c(8, 6, 7, 9)
    )

    fig <- radarPlot(df = skills, theta = "category", r = "value")
    built <- plotly::plotly_build(fig)

    # plotly_build adds an empty initial trace; the data trace is at index 2
    data_trace <- built$x$data[[2]]
    expect_equal(data_trace$type, "scatterpolar")
    expect_equal(data_trace$mode, "lines+markers")
})

test_that("radarPlot closes the polygon by repeating the first point", {
    skills <- data.frame(
        category = c("Speed", "Strength", "Defense"),
        value = c(8, 6, 7)
    )

    fig <- radarPlot(df = skills, theta = "category", r = "value")
    built <- plotly::plotly_build(fig)
    data_trace <- built$x$data[[2]]

    # Polygon should be closed: 3 original + 1 repeated = 4 points
    expect_equal(length(data_trace$r), 4)
    expect_equal(data_trace$r[1], data_trace$r[4])
})

test_that("radarPlot handles multiple groups", {
    team_stats <- data.frame(
        category = rep(c("Speed", "Strength", "Defense"), 2),
        value = c(8, 6, 7, 5, 9, 8),
        player = rep(c("Player A", "Player B"), each = 3)
    )

    fig <- radarPlot(
        df = team_stats, theta = "category", r = "value",
        group = "player"
    )
    built <- plotly::plotly_build(fig)

    expect_s3_class(fig, "plotly")
    # plotly_build adds an empty initial trace; data traces start at index 2
    expect_equal(built$x$data[[2]]$name, "Player A")
    expect_equal(built$x$data[[3]]$name, "Player B")
})

test_that("radarPlot sets title correctly", {
    skills <- data.frame(
        category = c("Speed", "Strength", "Defense"),
        value = c(8, 6, 7)
    )

    fig <- radarPlot(
        df = skills, theta = "category", r = "value",
        title.text = "My Radar"
    )
    built <- plotly::plotly_build(fig)

    expect_equal(built$x$layout$title$text, "My Radar")
})

test_that("radarPlot respects custom styling parameters", {
    skills <- data.frame(
        category = c("Speed", "Strength", "Defense"),
        value = c(8, 6, 7)
    )

    fig <- radarPlot(
        df = skills, theta = "category", r = "value",
        line.width = 4, line.dash = "dash",
        opacity = 0.3, marker.size = 10
    )
    built <- plotly::plotly_build(fig)
    data_trace <- built$x$data[[2]]

    expect_equal(data_trace$line$width, 4)
    expect_equal(data_trace$line$dash, "dash")
    expect_equal(data_trace$opacity, 0.3)
    expect_equal(data_trace$marker$size, 10)
})

test_that("radarPlot validates input columns", {
    skills <- data.frame(
        category = c("Speed", "Strength"),
        value = c(8, 6)
    )

    expect_error(radarPlot(df = skills, theta = "missing_col", r = "value"))
    expect_error(radarPlot(df = skills, theta = "category", r = "missing_col"))
    expect_error(radarPlot(df = skills, theta = "category", r = "value", group = "missing_col"))
})

test_that("radarPlot rejects non-data.frame input", {
    expect_error(radarPlot(df = "not a data frame", theta = "x", r = "y"))
})
