# Tests for organize_inputs() grid-flow behavior.

test_that("organize_inputs drops NULL inputs so they do not create empty cells", {
    ui <- organize_inputs(tagList(div("a"), NULL, div("b")), columns = 2)
    n_cells <- length(gregexpr("vizmodules-input-cell", as.character(ui))[[1]])
    expect_equal(n_cells, 2)
})

test_that("organize_inputs flows a uniform input block into one cell per visible input", {
    ns <- NS("x")
    block <- uniform_axes_inputs_ui(ns)
    expected <- sum(!vapply(block, is.null, logical(1)))

    ui <- organize_inputs(block, columns = 2)
    n_cells <- length(gregexpr("vizmodules-input-cell", as.character(ui))[[1]])
    expect_equal(n_cells, expected)
})

test_that("organize_inputs keeps a tooltip-wrapped input as a single cell", {
    ui <- organize_inputs(
        tagList(shinyBS::tipify(numericInput("a", "A", 1), "tip")),
        columns = 2
    )
    n_cells <- length(gregexpr("vizmodules-input-cell", as.character(ui))[[1]])
    expect_equal(n_cells, 1)
})
