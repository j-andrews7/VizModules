test_that("collect_source_data handles zero-length (non-NULL) UI input values", {
    fig <- plotly::plot_ly(mtcars, x = ~mpg, y = ~hp, type = "scatter", mode = "markers")

    # A multi-select input with nothing chosen can report `character(0)`
    # rather than `NULL`, which previously made `names`/`values` mismatch in
    # length and crash `data.frame()`.
    result <- collect_source_data(
        plot_reactive = function() fig,
        inputs_reactive = list(x.by = "mpg", y.by = "hp", hover.data = character(0), title = "t")
    )

    expect_equal(nrow(result$inputs), length(result$inputs$names))
    expect_equal(result$inputs$values[result$inputs$names == "hover.data"], "")
})

test_that("collect_source_data limits plot_data to plotted columns and rows", {
    df <- mtcars
    df$carname <- rownames(df)
    df$gear_f <- factor(df$gear)

    fig <- plotly::ggplotly(
        dittoViz::scatterPlot(df, x.by = "mpg", y.by = "hp", color.by = "cyl", shape.by = "gear_f", data.out = FALSE)
    )

    result <- collect_source_data(
        plot_reactive = function() fig,
        inputs_reactive = list(x.by = "mpg", y.by = "hp", color.by = "cyl", shape.by = "gear_f", split.by = "")
    )

    expect_setequal(names(result$plot_data), c("mpg", "hp", "cyl", "gear_f"))
    expect_equal(nrow(result$plot_data), nrow(df))
})

test_that("collect_source_data recovers split.by/facet columns from UI inputs", {
    df <- mtcars
    df$am <- factor(df$am)

    fig <- plotly::ggplotly(
        dittoViz::scatterPlot(df, x.by = "mpg", y.by = "hp", color.by = "cyl", split.by = "am", data.out = FALSE)
    )

    result <- collect_source_data(
        plot_reactive = function() fig,
        inputs_reactive = list(x.by = "mpg", y.by = "hp", color.by = "cyl", split.by = "am")
    )

    expect_true("am" %in% names(result$plot_data))
    expect_setequal(names(result$plot_data), c("mpg", "hp", "cyl", "am"))
})

test_that("collect_source_data drops rows with NA in a plotted column", {
    df <- mtcars
    df$hp[c(2, 5)] <- NA

    fig <- plotly::ggplotly(
        dittoViz::scatterPlot(df, x.by = "mpg", y.by = "hp", color.by = "cyl", data.out = FALSE)
    )

    result <- collect_source_data(
        plot_reactive = function() fig,
        inputs_reactive = list(x.by = "mpg", y.by = "hp", color.by = "cyl")
    )

    expect_equal(nrow(result$plot_data), nrow(df) - 2)
    expect_false(anyNA(result$plot_data$hp))
})

test_that("collect_source_data falls back to full data when no plotted vars are detected", {
    fig <- plotly::plot_ly(mtcars)

    result <- collect_source_data(plot_reactive = function() fig, inputs_reactive = list(title = "My Plot"))

    expect_setequal(names(result$plot_data), names(mtcars))
    expect_equal(nrow(result$plot_data), nrow(mtcars))
})

test_that("collect_source_data scopes dumbbellPlot data to the plotted x/y columns", {
    ddata <- data.frame(
        School = c("MIT", "Stanford", "Harvard"),
        Women = c(152, 96, 112),
        Men = c(95, 151, 165),
        Extra = c(1, 2, 3)
    )
    fig <- dumbbellPlot(
        data = ddata, x = c("Women", "Men"), y = "School",
        colour.by = "X variables", palette.selection = c("green", "blue")
    )

    result <- collect_source_data(
        plot_reactive = function() fig,
        inputs_reactive = list(x.value = c("Women", "Men"), y.value = "School", colour.by = "X variables")
    )

    expect_setequal(names(result$plot_data), c("School", "Women", "Men"))
})

test_that("collect_source_data scopes parallelCoordinatesPlot data to the selected dimensions", {
    fig <- parallelCoordinatesPlot(data = mtcars, dimensions = c("mpg", "cyl", "hp"), color.by = "mpg")

    result <- collect_source_data(
        plot_reactive = function() fig,
        inputs_reactive = list(dimensions = c("mpg", "cyl", "hp"), color.by = "mpg")
    )

    expect_setequal(names(result$plot_data), c("mpg", "cyl", "hp"))
    expect_equal(nrow(result$plot_data), nrow(mtcars))
})
