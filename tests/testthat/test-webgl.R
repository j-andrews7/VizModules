# Point layers switch to WebGL once a plot has enough points (auto_webgl()).

.box_points_fig <- function(n_copies = 1) {
    d <- example_demographics[rep(seq_len(nrow(example_demographics)), n_copies), ]
    suppressWarnings(plotly::ggplotly(
        plotthis::BoxPlot(d, x = "job_level", y = "salary", add_point = TRUE)
    ))
}

.trace_types <- function(fig) vapply(fig$x$data, function(tr) tr$type %||% "scatter", character(1))

test_that("points switch to WebGL at the threshold, and boxes stay SVG", {
    fig <- .box_points_fig()
    n_points <- sum(vapply(Filter(function(tr) identical(tr$type, "scatter"), fig$x$data),
        function(tr) length(tr$x), numeric(1)))

    below <- auto_webgl(fig, threshold = n_points + 1)
    expect_identical(below, fig)

    at <- auto_webgl(fig, threshold = n_points)
    expect_setequal(unique(.trace_types(at)), c("box", "scattergl"))
    expect_true(all(.trace_types(at)[.trace_types(fig) == "box"] == "box"))

    # The result builds without plotly complaining about scatter-only attributes.
    expect_no_warning(plotly::plotly_build(at))
})

test_that("lines and filled areas stay SVG", {
    fig <- plotly::plot_ly()
    fig$x$data <- list(
        list(type = "scatter", mode = "markers", x = 1:10, y = 1:10),
        list(type = "scatter", mode = "lines", x = 1:10, y = 1:10),
        list(type = "scatter", mode = "markers", fill = "tozeroy", x = 1:10, y = 1:10)
    )
    out <- auto_webgl(fig, threshold = 1)
    expect_identical(.trace_types(out), c("scattergl", "scatter", "scatter"))
})

test_that("the threshold follows the VizModules.webgl.threshold option", {
    withr::local_options(VizModules.webgl.threshold = 12345)
    expect_equal(VizModules:::.webgl_threshold(), 12345)
    withr::local_options(VizModules.webgl.threshold = "nonsense")
    expect_equal(VizModules:::.webgl_threshold(), 5000)
})

test_that("the BoxPlot's jitter stays out of the legend once drawn with WebGL", {
    fig <- auto_webgl(.box_points_fig(), threshold = 1)
    fig <- VizModules:::.hide_jitter_from_legend(fig)
    gl <- Filter(function(tr) identical(tr$type, "scattergl"), fig$x$data)
    expect_gt(length(gl), 0)
    expect_true(all(vapply(gl, function(tr) isFALSE(tr$showlegend), logical(1))))
})

test_that("the module toggle switches a large BoxPlot's points, and off keeps them SVG", {
    d <- example_demographics[rep(seq_len(nrow(example_demographics)), 12), ]
    shiny::testServer(plotthis_BoxPlotServer, args = list(id = "box", data = shiny::reactive(d)), {
        suppressWarnings(do.call(session$setInputs, .box_inputs(add.points = TRUE, webgl = TRUE)))
        expect_true("scattergl" %in% .trace_types(suppressWarnings(generate_BoxPlot())))

        suppressWarnings(session$setInputs(webgl = FALSE))
        expect_false("scattergl" %in% .trace_types(suppressWarnings(generate_BoxPlot())))
    })
})

test_that("overlays switch unfilled lines with the points, which alone reach the threshold", {
    fig <- plotly::plot_ly()
    fig$x$data <- list(
        list(type = "scatter", mode = "markers", x = 1:10, y = 1:10),
        list(type = "scatter", mode = "lines", x = 1:10, y = 1:10, hoveron = "points"),
        list(type = "scatter", mode = "lines", fill = "toself", x = 1:10, y = 1:10)
    )
    out <- auto_webgl(fig, threshold = 1, overlays = TRUE)
    expect_identical(.trace_types(out), c("scattergl", "scattergl", "scatter"))
    expect_null(out$x$data[[2]]$hoveron)

    # Twenty points are drawn in the first two traces, but only ten are points.
    expect_identical(auto_webgl(fig, threshold = 11, overlays = TRUE), fig)
})

test_that("webgl_input() takes its value from defaults", {
    on <- as.character(webgl_input(shiny::NS("m")))
    off <- as.character(webgl_input(shiny::NS("m"), defaults = list(webgl = FALSE)))
    expect_match(on, 'id="m-webgl"', fixed = TRUE)
    expect_match(on, "checked", fixed = TRUE)
    expect_no_match(off, 'checked="checked"', fixed = TRUE)
})
