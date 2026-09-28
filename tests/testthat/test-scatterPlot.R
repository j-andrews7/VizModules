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

test_that("a size column gives a spread of marker sizes and a custom size legend", {
    p <- dittoViz::scatterPlot(
        example_mtcars,
        x.by = "mpg", y.by = "wt", size = "hp",
        do.hover = TRUE, data.out = TRUE
    )

    # A numeric size mapping must produce a spread of marker diameters so the
    # custom size legend has meaningful breaks to render.
    sizes <- .extract_marker_sizes(p$plot)
    expect_gt(length(sizes), 0)
    expect_gt(diff(range(sizes)), 0)

    anns <- plotly::plotly_build(.custom_legend(
        p$plot,
        data = example_mtcars, size_by = "hp",
        gap = 0.04, title.size = 14, text.size = 12
    ))$x$layout$annotations
    expect_length(Filter(function(a) grepl("font-size", a$text), anns), 5)
    expect_true(length(Filter(function(a) identical(a$text, "hp"), anns)) >= 1)
})

test_that("highlight styling matches points by value on a categorical x-axis", {
    # Matching on coordinates dropped the highlight styling here (issue #309):
    # the raw x values ("A"/"B"/...) can never equal the trace's numeric positions.
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

test_that("highlight values may contain spaces when separated by commas", {
    available <- c("CD4 T", "CD8 T", "B", "P01", "P07")

    expect_equal(.parse_highlight_values("CD4 T, B", available), c("CD4 T", "B"))
    expect_equal(.parse_highlight_values("CD4 T\nCD8 T", available), c("CD4 T", "CD8 T"))
    # Space-separated lists of values without spaces still split as before.
    expect_equal(.parse_highlight_values("P01 P07", available), c("P01", "P07"))
    expect_equal(.parse_highlight_values("P01, P07 B", available), c("P01", "P07", "B"))
    # With nothing to match against, every entry splits on whitespace.
    expect_equal(.parse_highlight_values("a b,c"), c("a", "b", "c"))
    expect_equal(.parse_highlight_values(""), character(0))
    expect_equal(.parse_highlight_values(NULL), character(0))
})
