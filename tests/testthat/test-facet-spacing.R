## Regression test for uneven facet panel widths caused by panel.spacing
## being supplied in "npc" units. See issue where a 20-facet BoxPlot with
## facet_scales = "free_x" rendered panels with ~2.17x width asymmetry.
## Using "pt" keeps the ratio close to what native ggplot/ggplotly produce.

skip_if_not_installed("plotthis")
skip_if_not_installed("plotly")
skip_if_not_installed("ggplot2")

test_that("BoxPlot facet panels have uniform widths with default subplot spacing", {
    set.seed(42)
    n_facets <- 20
    df <- do.call(rbind, lapply(seq_len(n_facets), function(i) {
        data.frame(
            facet = paste0("facet_", sprintf("%02d", i)),
            category = "Group_A",
            value = rnorm(30, mean = 15, sd = 5),
            stringsAsFactors = FALSE
        )
    }))

    # Replicate exactly what the BoxPlot module server does:
    # theme_args$panel.spacing <- unit(input$subplot.margin, "pt")
    # with the new default value (5).
    theme_args <- list(panel.spacing = grid::unit(5, "pt"))

    p <- plotthis::BoxPlot(
        data = df, x = "category", y = "value",
        facet_by = "facet", facet_scales = "free_x", facet_ncol = 7,
        theme = "theme_this", theme_args = theme_args
    )

    fig <- plotly::ggplotly(p)
    xaxes <- fig$x$layout[grepl("^xaxis[0-9]*$", names(fig$x$layout))]
    expect_gt(length(xaxes), 1)

    widths <- vapply(xaxes, function(a) a$domain[2] - a$domain[1], numeric(1))

    # Edge columns in a ggplotly facet layout are naturally a few percent wider
    # than interior columns (they absorb space freed by axis labels/mirror).
    # The bug where panels were >= 2x different would fail this assertion.
    # Allow up to 15% deviation, which comfortably covers the ggplotly-native
    # asymmetry (~7%) while catching the npc-unit regression (>100%).
    expect_lt(max(widths) / min(widths), 1.15)
})
