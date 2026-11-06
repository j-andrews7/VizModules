# split_color_shape_legend() gives colour and shape their own legend sections,
# in place of ggplotly's entry per combination.

.tag <- function(tr) tr$meta$vizmodules_legend
.entries <- function(fig, section) {
    Filter(function(tr) identical(.tag(tr)$entry, section), fig$x$data)
}
.entry_names <- function(fig, section) vapply(.entries(fig, section), function(tr) tr$name, "")

.combo_fig <- function(color = c("a", "b"), shape = c("p", "q"), title = "col<br />shp") {
    traces <- list()
    for (cl in color) for (sh in shape) {
        traces[[length(traces) + 1]] <- list(
            type = "scatter", mode = "markers", x = 1:2, y = 1:2, xaxis = "x", yaxis = "y",
            name = sprintf("(%s,%s)", cl, sh), legendgroup = sprintf("(%s,%s)", cl, sh), showlegend = TRUE,
            marker = list(
                color = if (identical(sh, shape[2])) "transparent" else paste0("#", cl, cl, cl),
                symbol = if (identical(sh, shape[1])) "circle" else "diamond",
                line = list(color = paste0("#", cl, cl, cl), width = 2)
            )
        )
    }
    fig <- plotly::plot_ly()
    fig$x$data <- traces
    fig$x$layout <- list(legend = list(title = list(text = title)))
    fig
}

test_that("colour and shape each get a titled section, with the combinations out of the legend", {
    fig <- split_color_shape_legend(.combo_fig(c("1", "2", "3")), c("1", "2", "3"), c("p", "q"))

    expect_identical(.entry_names(fig, "color"), c("1", "2", "3"))
    expect_identical(.entry_names(fig, "shape"), c("p", "q"))
    for (tr in .entries(fig, "color")) {
        expect_identical(tr$legendgroup, "vizmodules-color")
        expect_identical(tr$legendgrouptitle$text, "col")
        expect_identical(tr$marker$symbol, "circle")
    }
    expect_identical(.entries(fig, "color")[[2]]$marker$color, "#222")
    for (tr in .entries(fig, "shape")) {
        expect_identical(tr$legendgroup, "vizmodules-shape")
        expect_identical(tr$legendgrouptitle$text, "shp")
    }
    # Shapes in black, keeping a shape drawn without a fill unfilled.
    expect_identical(.entries(fig, "shape")[[1]]$marker$color, "#000000")
    expect_identical(.entries(fig, "shape")[[2]]$marker$color, "transparent")
    expect_identical(.entries(fig, "shape")[[2]]$marker$symbol, "diamond")
    # Colour first, each in level order.
    ranks <- vapply(c(.entries(fig, "color"), .entries(fig, "shape")), function(tr) tr$legendrank, numeric(1))
    expect_identical(ranks, as.numeric(1:5))
    expect_identical(fig$x$layout$legend$title$text, "")

    combos <- fig$x$data[1:6]
    for (tr in combos) {
        expect_false(tr$showlegend)
        expect_setequal(names(.tag(tr)), c("color", "shape"))
    }
    expect_identical(.tag(combos[[4]]), list(color = "2", shape = "q"))
})

test_that("the entries are appended, so no trace's curve number moves", {
    before <- .combo_fig()
    fig <- split_color_shape_legend(before, c("a", "b"), c("p", "q"))
    expect_length(fig$x$data, 4 + 2 + 2)
    expect_identical(
        vapply(fig$x$data[1:4], function(tr) tr$name, ""),
        vapply(before$x$data, function(tr) tr$name, "")
    )
    for (tr in fig$x$data[5:8]) {
        expect_identical(tr$x, list(NA))
        expect_identical(tr$hoverinfo, "skip")
    }
    # The clicks are handled in the browser.
    expect_true(any(vapply(fig$dependencies, function(d) d$name, "") == "vizmodules-legend-sections"))
    expect_length(fig$jsHooks$render, 1)
})

test_that("levels holding commas, or starting with another level, still match", {
    fig <- .combo_fig(color = "x", shape = "y")
    points <- function(name) {
        list(type = "scatter", mode = "markers", name = name, marker = list(color = "red", symbol = "circle"))
    }
    fig$x$data <- list(points("(a, b,North)"), points("(a,North)"), points("(a,South, East)"))
    out <- split_color_shape_legend(fig, c("a", "a, b"), c("North", "South, East"))
    expect_identical(.tag(out$x$data[[1]]), list(color = "a, b", shape = "North"))
    expect_identical(.tag(out$x$data[[2]]), list(color = "a", shape = "North"))
    expect_identical(.tag(out$x$data[[3]]), list(color = "a", shape = "South, East"))
})

test_that("a trace drawn for a colour alone becomes its level's entry", {
    # A yPlot's boxes: "(colour,1)", ggplot's placeholder shape. Facet copies are
    # already out of the legend.
    fig <- .combo_fig(c("a", "b"), "p")
    boxes <- list(
        list(type = "box", name = "(a,1)", legendgroup = "(a,1)", showlegend = TRUE, fillcolor = "red"),
        list(type = "box", name = "(b,1)", legendgroup = "(b,1)", showlegend = TRUE, fillcolor = "blue"),
        list(type = "box", name = "(a,1)", legendgroup = "(a,1)", showlegend = FALSE, fillcolor = "red")
    )
    fig$x$data <- c(boxes, fig$x$data)
    out <- split_color_shape_legend(fig, c("a", "b"), "p")

    expect_identical(.entry_names(out, "color"), c("a", "b"))
    expect_identical(vapply(.entries(out, "color"), function(tr) tr$type, ""), c("box", "box"))
    expect_identical(.tag(out$x$data[[3]]), list(color = "a"))
    expect_false(out$x$data[[3]]$showlegend)
    expect_identical(out$x$data[[3]]$name, "a")
    # So only the shape needs entries of its own.
    expect_length(out$x$data, length(fig$x$data) + 1)
})

test_that("traces grouped under a colour level are hidden with it, keeping their legend entries", {
    fig <- .combo_fig()
    fig$x$data[[5]] <- list(type = "histogram", name = "a", legendgroup = "a", showlegend = FALSE)
    fig$x$data[[6]] <- list(type = "scatter", mode = "lines", name = "Linear fit a", legendgroup = "Linear fit a")
    out <- split_color_shape_legend(fig, c("a", "b"), c("p", "q"))
    expect_identical(.tag(out$x$data[[5]]), list(color = "a"))
    expect_identical(out$x$data[[5]]$legendgroup, "a")
    expect_null(.tag(out$x$data[[6]]))
})

test_that("a legend without a colour and shape combination is left alone", {
    fig <- .combo_fig()
    # Colour only, or shape only: names are bare levels.
    fig$x$data <- lapply(fig$x$data, function(tr) utils::modifyList(tr, list(name = "a")))
    expect_identical(split_color_shape_legend(fig, c("a", "b"), c("p", "q")), fig)
    fig <- .combo_fig()
    expect_identical(split_color_shape_legend(fig, character(0), c("p", "q")), fig)
    # The shape half of a name has to be a shape level.
    expect_identical(split_color_shape_legend(fig, c("a", "b"), c("r", "s")), fig)
})

test_that("given titles replace the ones ggplotly wrote", {
    fig <- split_color_shape_legend(.combo_fig(), c("a", "b"), c("p", "q"), color.title = "C", shape.title = "S")
    expect_identical(.entries(fig, "color")[[1]]$legendgrouptitle$text, "C")
    expect_identical(.entries(fig, "shape")[[1]]$legendgrouptitle$text, "S")
})

test_that("the legend inputs style the section titles too", {
    fig <- plotly::plot_ly(x = 1:2, y = 1:2, type = "scatter", mode = "markers")
    fig <- apply_legend_styling(fig, title.size = 17, font.family = "Courier New")
    built <- plotly::plotly_build(fig)
    expect_identical(built$x$layout$legend$grouptitlefont, list(family = "Courier New", size = 17))
})

test_that("scatterPlot gives colour and shape their own sections", {
    testServer(dittoViz_scatterPlotServer, args = list(data = reactive(example_sales)), {
        do.call(session$setInputs, .scatter_inputs(color.by = "product_line", shape.by = "region"))
        fig <- suppressWarnings(generate_scatterPlot())
        expect_setequal(.entry_names(fig, "color"), unique(as.character(example_sales$product_line)))
        expect_setequal(.entry_names(fig, "shape"), unique(as.character(example_sales$region)))
        expect_false(any(vapply(fig$x$data, function(tr) {
            !isFALSE(tr$showlegend) && startsWith(as.character(tr$name %||% ""), "(")
        }, logical(1))))

        # Split: one entry per level, not one per panel.
        session$setInputs(shape.by = "year", split.by = "region")
        fig <- suppressWarnings(generate_scatterPlot())
        expect_length(.entries(fig, "shape"), length(unique(example_sales$year)))
        expect_length(.entries(fig, "color"), length(unique(example_sales$product_line)))

        # Colour alone keeps ggplotly's legend.
        session$setInputs(shape.by = "", split.by = "")
        fig <- suppressWarnings(generate_scatterPlot())
        expect_length(.entries(fig, "color"), 0)
    })
})

test_that("yPlot's boxes become the colour entries, with a shape section beside them", {
    testServer(dittoViz_yPlotServer, args = list(data = reactive(example_demographics)), {
        do.call(session$setInputs, .yplot_inputs(color.by = "department", shape.by = "gender"))
        fig <- suppressWarnings(generate_yPlot())
        colors <- .entries(fig, "color")
        expect_setequal(vapply(colors, function(tr) tr$name, ""), unique(as.character(example_demographics$department)))
        expect_true(all(vapply(colors, function(tr) tr$type, "") == "box"))
        expect_setequal(.entry_names(fig, "shape"), c("Female", "Male"))

        # Shape alone: the colour is the Group By.
        session$setInputs(color.by = "")
        fig <- suppressWarnings(generate_yPlot())
        expect_setequal(.entry_names(fig, "color"), unique(as.character(example_demographics$job_level)))

        # The shape legend switched off: nothing to split.
        session$setInputs(color.by = "department", jitter.shape.legend.show = FALSE)
        fig <- suppressWarnings(generate_yPlot())
        expect_length(.entries(fig, "shape"), 0)
    })
})
