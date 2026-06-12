test_that("scatterPlot UI exposes a numeric 'Size By' selector", {
    data(example_mtcars)
    ui <- dittoViz_scatterPlotInputsUI("scatter", example_mtcars)
    html <- as.character(ui)

    # The new size.by input is namespaced and labelled "Size By".
    expect_true(grepl("scatter-size.by", html, fixed = TRUE))
    expect_true(grepl("Size By", html, fixed = TRUE))
})

test_that("scatterPlot size column yields variable marker sizes for the legend", {
    skip_if_not_installed("dittoViz")
    data(example_mtcars)

    p <- dittoViz::scatterPlot(
        example_mtcars,
        x.by = "mpg", y.by = "wt", size = "hp",
        do.hover = TRUE, data.out = TRUE
    )

    sizes <- VizModules:::.extract_marker_sizes(p$plot)
    # A numeric size mapping must produce a spread of marker diameters so the
    # custom size legend has meaningful breaks to render.
    expect_gt(length(sizes), 0)
    expect_gt(diff(range(sizes)), 0)
})

test_that("scatterPlot draws a custom size legend when size encodes a column", {
    skip_if_not_installed("dittoViz")
    data(example_mtcars)

    p <- dittoViz::scatterPlot(
        example_mtcars,
        x.by = "mpg", y.by = "wt", size = "hp",
        do.hover = TRUE, data.out = TRUE
    )

    fig <- VizModules:::.custom_legend(
        p$plot,
        data = example_mtcars, size_by = "hp",
        gap = 0.04, title.size = 14, text.size = 12
    )
    built <- plotly::plotly_build(fig)
    anns <- built$x$layout$annotations

    circle_anns <- Filter(function(a) grepl("font-size", a$text), anns)
    title_ann <- Filter(function(a) identical(a$text, "hp"), anns)

    expect_equal(length(circle_anns), 5)
    expect_true(length(title_ann) >= 1)
})

test_that("scatterPlot custom legend is omitted when size is not a column", {
    data(example_mtcars)
    fig <- plotly::plot_ly(
        data = example_mtcars, x = ~mpg, y = ~wt,
        type = "scatter", mode = "markers"
    )

    # No size mapping (size.by unset) -> figure returned unchanged.
    expect_identical(
        VizModules:::.custom_legend(fig, example_mtcars, size_by = NULL), fig
    )
})
