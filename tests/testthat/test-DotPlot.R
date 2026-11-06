# Build the dot plot figure for `inputs` in a fresh session.
.dot_figure <- function(df, inputs) {
    fig <- NULL
    shiny::testServer(
        plotthis_DotPlotServer,
        args = list(id = "dot", data = shiny::reactive(df)),
        {
            suppressWarnings({
                do.call(session$setInputs, inputs)
                session$flushReact()
            })
            fig <<- suppressWarnings(generate_DotPlot())
        }
    )
    fig
}

# The size legend's break labels and circle diameters (px), top to bottom.
.dot_size_legend <- function(fig) {
    texts <- vapply(plotly::plotly_build(fig)$x$layout$annotations, function(a) a$text, character(1))
    circles <- texts[grepl("font-size", texts)]
    font_px <- as.numeric(sub(".*font-size:([0-9.eE+-]+)px.*", "\\1", circles))
    list(labels = texts[grepl("^[0-9.]+$", texts)], diameters = font_px * .CIRCLE_GLYPH_DIAMETER_RATIO)
}

test_that("Size Scale Min/Max set the values the dot sizes and the size legend span (#359)", {
    pct <- example_markers$pct_expressed

    fig <- .dot_figure(example_markers, .dot_inputs(size.scale.min = 0, size.scale.max = 100))
    legend <- .dot_size_legend(fig)
    expect_equal(legend$labels, c("0", "25", "50", "75", "100"))
    expect_equal(legend$diameters, .size_scale_px(c(0, 25, 50, 75, 100), c(1, 6), c(0, 100)))
    # The dots are drawn on the same scale as the legend.
    expect_equal(sort(.extract_marker_sizes(fig)), sort(.size_scale_px(pct, c(1, 6), c(0, 100))))

    # Left blank, both follow the data's range, as before.
    fig <- .dot_figure(example_markers, .dot_inputs())
    expect_equal(sort(.extract_marker_sizes(fig)), sort(.size_scale_px(pct, c(1, 6), range(pct))))
    labels <- as.numeric(.dot_size_legend(fig)$labels)
    expect_equal(range(labels), range(pct))
})

test_that("dots beyond the Size Scale limits are drawn at the end sizes, not dropped", {
    pct <- example_markers$pct_expressed
    fig <- .dot_figure(example_markers, .dot_inputs(size.min = 2, size.max = 8, size.scale.min = 20, size.scale.max = 60))
    sizes <- .extract_marker_sizes(fig)
    expect_length(sizes, length(pct))
    expect_equal(range(sizes), .size_scale_px(c(20, 60), c(2, 8), c(20, 60)))
})
