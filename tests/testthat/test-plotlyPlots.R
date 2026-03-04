# Tests for plotly plotting functions
# Each test verifies the function returns a plotly object.

# ─── linePlot ─────────────────────────────────────────────────────────────────

test_that("linePlot returns a plotly object", {
    fig <- linePlot(
        reactive.data = mtcars,
        x = "wt",
        y = "mpg",
        plot.mode = "lines",
        line.type = "solid",
        colour.group.by = NULL,
        palette.selection = "Set2",
        show.legend = TRUE
    )
    expect_s3_class(fig, "plotly")
})

# ─── piePlot ──────────────────────────────────────────────────────────────────

test_that("piePlot returns a plotly object", {
    df <- data.frame(
        status = c("Up", "Down", "NS"),
        n = c(12, 7, 3)
    )
    fig <- piePlot(
        df = df,
        labels = "status",
        values = "n"
    )
    expect_s3_class(fig, "plotly")
})

# ─── radarPlot ────────────────────────────────────────────────────────────────

test_that("radarPlot returns a plotly object", {
    df <- data.frame(
        category = c("Speed", "Strength", "Defense", "Stamina"),
        value = c(8, 6, 7, 9)
    )
    fig <- radarPlot(df = df, theta = "category", r = "value")
    expect_s3_class(fig, "plotly")
})

# ─── ternaryPlot ──────────────────────────────────────────────────────────────

test_that("ternaryPlot returns a plotly object", {
    df <- data.frame(a = c(75, 10, 20), b = c(25, 80, 70), c = c(0, 10, 10))
    fig <- ternaryPlot(df = df, a = "a", b = "b", c = "c")
    expect_s3_class(fig, "plotly")
})

# ─── dumbbellPlot ─────────────────────────────────────────────────────────────

test_that("dumbbellPlot returns a plotly object", {
    data <- data.frame(
        School = c("MIT", "Stanford", "Harvard"),
        Women = c(94, 96, 112),
        Men = c(152, 151, 165)
    )
    fig <- dumbbellPlot(
        reactive.data = data,
        x = c("Women", "Men"),
        y = "School",
        palette.selection = c("pink", "blue")
    )
    expect_s3_class(fig, "plotly")
})

# ─── parallelCoordinatesPlot ─────────────────────────────────────────────────

test_that("parallelCoordinatesPlot returns a plotly object", {
    fig <- parallelCoordinatesPlot(
        reactive.data = mtcars,
        dimensions = c("mpg", "cyl", "disp", "hp")
    )
    expect_s3_class(fig, "plotly")
})
