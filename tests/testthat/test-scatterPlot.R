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

# --- Driving the module's own build ------------------------------------------

# The plot output cannot be driven from testServer, but the reactive that builds
# the figure can, given a complete set of inputs.
.scatter_inputs <- function(...) {
    base <- list(
        x.by = "units", y.by = "revenue", color.by = "", shape.by = "", size.by = "", split.by = "",
        x.adjustment = "", y.adjustment = "", color.adjustment = "",
        x.adj.fxn = "", y.adj.fxn = "", color.adj.fxn = "",
        size = 1, opacity = 1, show.others = FALSE, split.show.all.others = FALSE,
        plot.order = "unordered", shape.panel = "16, 15, 17, 23, 25, 8",
        min.color = "#F0E442", max.color = "#0072B2", min.value = NA, max.value = NA,
        do.contour = FALSE, contour.color = "black", contour.linetype = "solid", do.ellipse = FALSE,
        trajectory.group.by = "", add.trajectory.by.groups = "", trajectory.arrow.size = 0.15,
        split.nrow = NA, split.ncol = NA, split.adjust.scales = "fixed", multivar.split.dir = "col",
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        legend.show = TRUE, legend.color.title = "make", legend.color.breaks = "",
        legend.title.size = 14, legend.text.size = 12, size.legend.x = 1.03, size.legend.y = 0.35,
        hover.data = "", hover.round.digits = 5, webgl = FALSE, single.point.color = "#000000",
        linear.model = FALSE, best.fit = FALSE, line.best.smoothness = 1, line.best.colour = "#000000",
        custom.model.enable = FALSE, custom.models = NULL,
        annotate.by = "", highlight.points = "", highlight.auto.annotate = TRUE,
        highlight.color = "#00FFF7", highlight.size = 7,
        highlight.border.color = "#000000", highlight.border.width = 1,
        annotation.color = "black", annotation.ax = 20, annotation.ay = -20,
        annotation.size = 10, annotation.showarrow = TRUE,
        annotation.arrowcolor = "black", annotation.arrowhead = 2, annotation.arrowwidth = 1.5,
        download.format = "png", auto.update = TRUE, update = 0,
        title.font.size = 26, title.font.family = "Arial", title.font.color = "#000000",
        axis.title.font.size = 18, axis.title.font.color = "#000000",
        axis.title.font.family = "Arial", axis.title.horizontal.position = 0.5,
        axis.showline = TRUE, axis.mirror = TRUE, show.grid.x = TRUE, show.grid.y = TRUE,
        grid.color = "#CCCCCC", axis.linecolor = "black", axis.linewidth = 0.5,
        axis.tickfont.size = 12, axis.tickfont.color = "black",
        axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0,
        axis.ticks = "outside", axis.tickcolor = "black", axis.ticklen = 5,
        axis.tickwidth = 1, facet.title.font.size = 14,
        facet.title.font.color = "black", facet.title.font.family = "Arial",
        hline.intercepts = "", vline.intercepts = "", abline.slopes = "", abline.intercepts = "",
        shape.fill = "rgba(0, 0, 0, 0)", shape.line.color = "black", shape.line.width = 4,
        shape.linetype = "solid", shape.opacity = 1,
        margin.l = 80, margin.r = 80, margin.t = 80, margin.b = 80
    )
    utils::modifyList(base, list(...))
}

# Build the scatter figure for `inputs` in a fresh session.
.scatter_figure <- function(df, inputs) {
    fig <- NULL
    shiny::testServer(
        dittoViz_scatterPlotServer,
        args = list(id = "scatter", data = shiny::reactive(df)),
        {
            suppressWarnings({
                do.call(session$setInputs, inputs)
                session$flushReact()
            })
            fig <<- suppressWarnings(generate_scatterPlot())
        }
    )
    fig
}

.custom_lm <- function(formula) {
    list(Custom = list(model_type = "lm", formula = formula, line_colour = "#FF0000", line_width = "2"))
}

test_that("fit and model lines are fit to the plotted values under every axis adjustment (#365)", {
    df <- example_sales
    for (adj in list(
        list(),
        list(x.adjustment = "z-score", y.adj.fxn = "log10"),
        list(x.adjustment = "relative.to.max", y.adj.fxn = "sqrt"),
        list(x.adj.fxn = "log2", y.adjustment = "z-score", y.adj.fxn = "abs"),
        list(y.adj.fxn = "neg_log10")
    )) {
        info <- paste(names(adj), unlist(adj), collapse = ", ")

        # The formula names the raw columns; it models the values as plotted.
        linear <- .scatter_figure(df, do.call(.scatter_inputs, c(adj, list(
            linear.model = TRUE, custom.model.enable = TRUE, custom.models = .custom_lm("revenue ~ units")
        ))))
        lines <- expect_fit_lines_on_points(linear, c("Linear Fit", "Custom"), min.count = 2, full.span = TRUE)

        # ...and is the least-squares line through them.
        px <- VizModules:::.adjusted_values(df$units, adj$x.adjustment, adj$x.adj.fxn)
        py <- VizModules:::.adjusted_values(df$revenue, adj$y.adjustment, adj$y.adj.fxn)
        expected <- stats::coef(stats::lm(py ~ px))
        for (ln in lines) {
            lx <- unlist(ln$x)
            ly <- unlist(ln$y)
            slope <- (ly[length(ly)] - ly[1]) / (lx[length(lx)] - lx[1])
            expect_equal(slope, unname(expected[2]), tolerance = 1e-6, info = paste(info, ln$name))
        }

        loess <- .scatter_figure(df, do.call(.scatter_inputs, c(adj, list(best.fit = TRUE))))
        expect_fit_lines_on_points(loess, "Best Fit", full.span = TRUE)
    }
})

test_that("fit lines land in the facet panel whose points they were fit to", {
    # Character facets are laid out alphabetically, not in the order they appear,
    # and each panel's x-range is disjoint from the other's, so a line drawn in
    # the wrong panel lies off its points.
    set.seed(3)
    df <- data.frame(
        x = c(1:10, 101:110, 201:210, 301:310),
        y = rnorm(40),
        g = rep(c("B", "A"), each = 20),
        h = rep(c("Q", "P"), each = 10, times = 2),
        stringsAsFactors = FALSE
    )

    wrap <- .scatter_figure(df, .scatter_inputs(x.by = "x", y.by = "y", split.by = "g", linear.model = TRUE))
    expect_fit_lines_on_points(wrap, "Linear Fit", min.count = 2, full.span = TRUE)

    # Two split columns lay the panels out as a grid, one axis per row and column.
    grid <- .scatter_figure(df, .scatter_inputs(
        x.by = "x", y.by = "y", split.by = c("g", "h"), linear.model = TRUE,
        custom.model.enable = TRUE, custom.models = .custom_lm("y ~ x")
    ))
    expect_fit_lines_on_points(grid, c("Linear Fit", "Custom"), min.count = 8, full.span = TRUE)
})

test_that("a numeric color.by gives one fit line, not one per value", {
    fig <- .scatter_figure(example_sales, .scatter_inputs(color.by = "profit", linear.model = TRUE))
    built <- plotly::plotly_build(fig)
    fit_names <- vapply(built$x$data, function(tr) tr$name %||% "", character(1))
    expect_equal(sum(grepl("^Linear Fit", fit_names)), 1)
    expect_fit_lines_on_points(fig, "Linear Fit", full.span = TRUE)
})

test_that("no fit lines are drawn while an adjustment makes an axis categorical", {
    fig <- .scatter_figure(example_sales, .scatter_inputs(
        x.adj.fxn = "as.factor", linear.model = TRUE,
        custom.model.enable = TRUE, custom.models = .custom_lm("revenue ~ units")
    ))
    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    fit_names <- vapply(built$x$data, function(tr) tr$name %||% "", character(1))
    expect_false(any(fit_names %in% c("Linear Fit", "Custom")))
})
