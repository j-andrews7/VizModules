test_that("scatterPlot UI exposes a numeric 'Size By' selector", {
    df <- data.frame(
        num1 = c(1, 2, 3),
        num2 = c(4.5, 5.5, 6.5),
        cat1 = c("a", "b", "c"),
        stringsAsFactors = FALSE
    )
    ui <- dittoViz_scatterPlotInputsUI("scatter", df)
    html <- as.character(ui)

    # The new size.by input is namespaced and labelled "Size By".
    expect_true(grepl("scatter-size.by", html, fixed = TRUE))
    expect_true(grepl("Size By", html, fixed = TRUE))

    # The size.by selector must only offer numeric columns, never categorical
    # ones, since point size mapping requires a numeric variable.
    config <- regmatches(
        html, regexpr("data-for=\"scatter-size.by\">.*?</script>", html)
    )
    size_by_choices <- jsonlite::fromJSON(
        sub("</script>$", "", sub("^data-for=\"scatter-size.by\">", "", config))
    )$options$choices$value

    expect_true("num1" %in% size_by_choices)
    expect_true("num2" %in% size_by_choices)
    expect_false("cat1" %in% size_by_choices)
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

test_that("highlight styling matches points by value on a categorical x-axis", {
    skip_if_not_installed("dittoViz")
    skip_if_not_installed("plotly")

    set.seed(1)
    df <- data.frame(
        grp = rep(c("A", "B", "C"), each = 5),
        val = rnorm(15),
        lab = paste0("pt", seq_len(15)),
        stringsAsFactors = FALSE
    )

    p <- dittoViz::scatterPlot(
        df,
        x.by = "grp", y.by = "val",
        do.hover = TRUE, hover.data = c("lab", "grp", "val"),
        data.out = TRUE
    )
    fig <- plotly::ggplotly(p$plot)
    tr <- fig$x$data[[1]]

    # ggplotly encodes a categorical (factor) x-axis as numeric positions, so
    # the trace x-coordinates never equal the raw category values in the data.
    expect_true(is.numeric(tr$x))

    trace_map <- VizModules:::.build_trace_anno_map(tr, "lab")
    highlight_vals <- c("pt1", "pt7")

    # Value-based matching (the fix) identifies exactly the highlighted points
    # regardless of the categorical axis encoding.
    value_mask <- trace_map$anno_value %in% highlight_vals
    expect_equal(sum(value_mask), length(highlight_vals))
    expect_setequal(trace_map$anno_value[value_mask], highlight_vals)

    # The previous coordinate-based matching fails for categorical axes because
    # the raw data x-values ("A"/"B"/...) cannot match the trace's numeric
    # positions, which is what dropped the highlight styling (issue #309).
    highlight_idx <- which(as.character(df[["lab"]]) %in% highlight_vals)
    highlight_coords <- VizModules:::.create_coord_id(
        df[["grp"]][highlight_idx], df[["val"]][highlight_idx]
    )
    coord_mask <- trace_map$coord_id %in% highlight_coords & value_mask
    expect_equal(sum(coord_mask), 0)
})

test_that("scatterPlot seeds group colors from defaults but yields to the picker", {
    df <- data.frame(
        x = 1:6, y = 6:1,
        grp = rep(c("A", "B", "C"), each = 2),
        stringsAsFactors = FALSE
    )

    shiny::testServer(
        dittoViz_scatterPlotServer,
        args = list(
            id = "scatter", data = shiny::reactive(df),
            defaults = list(color.panel = c(A = "red", B = "#00FF00"))
        ),
        {
            session$setInputs(color.by = "grp", auto.update = TRUE)

            # C is unnamed by the defaults, so it falls back to the stock palette.
            resolved <- color.panel()
            expect_equal(resolved[["A"]], "#FF0000")
            expect_equal(resolved[["B"]], "#00FF00")
            expect_false(resolved[["C"]] %in% c("#FF0000", "#00FF00"))

            # A user's pick wins; groups they leave alone keep the supplied color.
            session$setInputs(color.panel = c(A = "#0000FF"))
            expect_equal(color.panel()[["A"]], "#0000FF")
            expect_equal(color.panel()[["B"]], "#00FF00")
        }
    )
})

test_that("scatterPlot uses the default single point color when nothing is grouped", {
    df <- data.frame(x = 1:4, y = 4:1)

    shiny::testServer(
        dittoViz_scatterPlotServer,
        args = list(
            id = "scatter", data = shiny::reactive(df),
            defaults = list(single.point.color = "#ABCDEF")
        ),
        {
            session$setInputs(color.by = "", auto.update = TRUE)
            expect_equal(color.panel(), "#ABCDEF")
        }
    )
})
