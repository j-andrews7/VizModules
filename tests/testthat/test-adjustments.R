# Everything VizModules draws over an adjusted plot -- significance brackets,
# fit lines, axis limits -- is computed from adjusted_values(), and the modules
# hand dittoViz that same transform as one function (adjustment_fn()). These
# check the two agree for every choice the module UIs offer, so a new choice, or
# a change in how dittoViz applies its function, is caught here rather than as
# brackets or lines drawn off the plot.

.adjustment_grid <- function() {
    grid <- expand.grid(
        adjustment = c("", VizModules:::.adjustment_choices),
        fxn = c("", VizModules:::.adj_fxn_choices),
        stringsAsFactors = FALSE
    )
    grid[nzchar(grid$adjustment) | nzchar(grid$fxn), ]
}

# Values that exercise every transform: a zero (log gives -Inf), fractions
# (log gives negatives), and a spread for z-scores.
.adjustment_df <- function() {
    data.frame(
        id = 1:8,
        v = c(0, 0.25, 0.5, 1, 2, 5, 10, 40),
        w = c(3, 1, 4, 1, 5, 9, 2, 6),
        g = rep(c("a", "b"), 4),
        stringsAsFactors = FALSE
    )
}

.as_compared <- function(values) {
    if (is.factor(values)) as.character(values) else unname(values)
}

test_that("the adjustment function choices are exactly those safe_resolve_adj_fxn allows", {
    for (fxn in VizModules:::.adj_fxn_choices) {
        expect_true(is.function(safe_resolve_adj_fxn(fxn)), info = fxn)
    }
    for (ui in list(
        dittoViz_yPlotInputsUI("y", .adjustment_df()),
        dittoViz_scatterPlotInputsUI("s", .adjustment_df())
    )) {
        html <- as.character(ui)
        for (choice in c(VizModules:::.adjustment_choices, VizModules:::.adj_fxn_choices)) {
            expect_true(grepl(paste0('"', choice, '"'), html, fixed = TRUE), info = choice)
        }
    }
})

test_that("the adjustment function is applied first, then the rescaling", {
    v <- c(1, 10, 100, 1000)
    # log10 first, then z-scored: every value stays finite. The other way round,
    # everything below the mean would be the log of a negative number.
    expect_equal(VizModules:::adjusted_values(v, "z-score", "log10"), as.numeric(scale(log10(v))))
    expect_equal(VizModules:::adjusted_values(v, "relative.to.max", "sqrt"), sqrt(v) / max(sqrt(v)))
    # Either one alone is unchanged.
    expect_equal(VizModules:::adjusted_values(v, "z-score"), as.numeric(scale(v)))
    expect_equal(VizModules:::adjusted_values(v, NULL, "log10"), log10(v))
})

test_that("the rescaling ignores values the function leaves non-finite", {
    # log10(0) is -Inf, which is not drawn; it must not turn every value into NaN.
    z <- VizModules:::adjusted_values(c(0, 1, 10, 100), "z-score", "log10")
    expect_equal(z[1], -Inf)
    expect_equal(z[-1], as.numeric(scale(0:2)))

    rel <- VizModules:::adjusted_values(c(NA, 2, 4), "relative.to.max")
    expect_equal(rel, c(NA, 0.5, 1))
})

test_that("dittoViz::yPlot plots exactly what adjusted_values computes", {
    df <- .adjustment_df()
    grid <- .adjustment_grid()
    for (i in seq_len(nrow(grid))) {
        adj <- grid$adjustment[i]
        fxn <- grid$fxn[i]
        info <- paste(adj, fxn)
        # A factor on the continuous axis is not something yPlot draws.
        if (identical(fxn, "as.factor")) next

        out <- suppressWarnings(dittoViz::yPlot(
            df, var = "v", group.by = "g", plots = "boxplot",
            var.adj.fxn = VizModules:::adjustment_fn(adj, fxn),
            data.out = TRUE
        ))
        plotted <- out$data[order(out$data$id), out$cols_used$var]
        ours <- suppressWarnings(VizModules:::adjusted_values(df$v, adj, fxn))
        expect_equal(ours, .as_compared(plotted), info = info)

        # The exported and in-place forms agree with it too.
        exported <- suppressWarnings(adjust_column_values(df, y.col = "v", y.adj.fun = fxn, y.adjustment = adj))
        expect_equal(exported$v.adj, ours, info = info)
        in_place <- suppressWarnings(VizModules:::as_plotted(df, "v", adj, fxn))
        expect_equal(in_place$v, ours, info = info)
    }
})

test_that("dittoViz::scatterPlot plots exactly what adjusted_values computes on either axis", {
    df <- .adjustment_df()
    grid <- .adjustment_grid()
    for (i in seq_len(nrow(grid))) {
        adj <- grid$adjustment[i]
        fxn <- grid$fxn[i]
        info <- paste(adj, fxn)

        out <- suppressWarnings(dittoViz::scatterPlot(
            df, x.by = "v", y.by = "w",
            x.adj.fxn = VizModules:::adjustment_fn(adj, fxn),
            y.adj.fxn = VizModules:::adjustment_fn(adj, fxn),
            data.out = TRUE
        ))
        td <- out$Target_data[order(out$Target_data$id), ]
        expect_equal(
            .as_compared(suppressWarnings(VizModules:::adjusted_values(df$v, adj, fxn))),
            .as_compared(td[[out$cols_used$x.by]]),
            info = paste("x:", info)
        )
        expect_equal(
            .as_compared(suppressWarnings(VizModules:::adjusted_values(df$w, adj, fxn))),
            .as_compared(td[[out$cols_used$y.by]]),
            info = paste("y:", info)
        )
    }
})

test_that("several Y variables are each adjusted on their own, as dittoViz stacks them", {
    df <- .adjustment_df()
    out <- dittoViz::yPlot(
        df, var = c("v", "w"), group.by = "g", plots = "boxplot",
        var.adj.fxn = VizModules:::adjustment_fn("z-score", "sqrt"), data.out = TRUE
    )
    ours <- VizModules:::.multivar_long_df(
        VizModules:::as_plotted(df, c("v", "w"), "z-score", "sqrt"), c("v", "w")
    )
    key <- function(d) order(d$var.which, d$id)
    expect_equal(ours$var.multi[key(ours)], unname(out$data$var.multi[key(out$data)]))
})

test_that("adjustment_fn is NULL without an adjustment, and as_plotted leaves the frame alone", {
    expect_null(VizModules:::adjustment_fn())
    expect_null(VizModules:::adjustment_fn("", ""))
    expect_true(is.function(VizModules:::adjustment_fn("z-score")))

    df <- .adjustment_df()
    expect_identical(VizModules:::as_plotted(df, "v"), df)
    expect_identical(VizModules:::as_plotted(df, "v", "", ""), df)
    expect_identical(VizModules:::as_plotted(df, "missing", "z-score"), df)
})
