# The plot output cannot be driven from testServer, but the reactive that builds
# the figure can, given a complete set of inputs.
.dot_inputs <- function(...) {
    base <- list(
        x.data = "gene", y.data = "cell_type", rotate = FALSE,
        size.by = "pct_expressed", fill.by = "avg_expression",
        fill.cutoff = NA, fill.cutoff.direction = "<",
        size.min = 1, size.max = 6, size.scale.min = NA, size.scale.max = NA,
        facet.by = "", facet.scale = "fixed", facet.ncol = NA, facet.nrow = NA, facet.by.row = TRUE,
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        palette.name = "Spectral", palreverse = FALSE, alpha = 1,
        border.color = "black", border.size = 0.5,
        lower.quantile = 0, upper.quantile = 1, lower.cutoff = NA, upper.cutoff = NA,
        auto.update = TRUE, update = 0,
        size.legend.x = 1.04, size.legend.y = 0.35,
        legend.show = TRUE, legend.font.family = "Arial", legend.font.color = "#000000",
        legend.title.size = 14, legend.text.size = 12,
        download.format = "svg",
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        grid.color = "#CCCCCC", axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 18,
        facet.title.font.color = "#000000", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "", abline.intercepts = "",
        shape.fill = "rgba(0, 0, 0, 0)", shape.line.color = "black", shape.line.width = 4,
        shape.linetype = "solid", shape.opacity = 1,
        margin.l = 70, margin.r = 140, margin.t = 70, margin.b = 70
    )
    utils::modifyList(base, list(...))
}

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
