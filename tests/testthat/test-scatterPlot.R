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

test_that("scatterPlot Color By and Shape By leave out categoricals with too many levels", {
    df <- data.frame(
        x = seq_len(60),
        y = rev(seq_len(60)),
        id = paste0("gene", seq_len(60)),
        grp = rep(c("a", "b", "c"), 20),
        flag = rep(c(TRUE, FALSE), 30),
        stringsAsFactors = FALSE
    )
    choices_of <- function(html, input) {
        pat <- paste0("data-for=\"scatter-", input, "\">.*?</script>")
        config <- regmatches(html, regexpr(pat, html))
        jsonlite::fromJSON(sub("</script>$", "", sub("^data-for=\"[^\"]+\">", "", config)))$options$choices$value
    }

    html <- as.character(dittoViz_scatterPlotInputsUI("scatter", df))
    color <- choices_of(html, "color.by")
    shape <- choices_of(html, "shape.by")
    # Numeric columns stay for a continuous colour; the 60-level ID column is gone.
    expect_true(all(c("x", "y", "grp", "flag") %in% color))
    expect_false("id" %in% color)
    expect_true(all(c("grp", "flag") %in% shape))
    expect_false(any(c("id", "x") %in% shape))

    # An explicit default naming the wide column is honoured.
    html <- as.character(dittoViz_scatterPlotInputsUI("scatter", df, defaults = list(color.by = "id")))
    expect_true("id" %in% choices_of(html, "color.by"))
    expect_false("id" %in% choices_of(html, "shape.by"))
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

    anns <- plotly::plotly_build(add_size_legend(
        p$plot,
        data = example_mtcars, size.by = "hp",
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

    expect_equal(parse_highlight_values("CD4 T, B", available), c("CD4 T", "B"))
    expect_equal(parse_highlight_values("CD4 T\nCD8 T", available), c("CD4 T", "CD8 T"))
    # Space-separated lists of values without spaces still split as before.
    expect_equal(parse_highlight_values("P01 P07", available), c("P01", "P07"))
    expect_equal(parse_highlight_values("P01, P07 B", available), c("P01", "P07", "B"))
    # With nothing to match against, every entry splits on whitespace.
    expect_equal(parse_highlight_values("a b,c"), c("a", "b", "c"))
    expect_equal(parse_highlight_values(""), character(0))
    expect_equal(parse_highlight_values(NULL), character(0))
})

# --- Driving the module's own build ------------------------------------------

# The plot output cannot be driven from testServer, but the reactive that builds
# the figure can, given a complete set of inputs.
.scatter_inputs <- function(...) {
    base <- list(
        x.by = "units", y.by = "revenue", color.by = "", shape.by = "", size.by = "", split.by = "",
        x.adjustment = "", y.adjustment = "", color.adjustment = "",
        x.adj.fxn = "", y.adj.fxn = "", color.adj.fxn = "",
        size = 1, size.min = 1, size.max = 6, size.scale.min = NA, size.scale.max = NA,
        opacity = 1, show.others = FALSE, split.show.all.others = FALSE,
        plot.order = "unordered", shape.panel = "16, 15, 17, 23, 25, 8",
        min.color = "#F0E442", max.color = "#0072B2", min.value = NA, max.value = NA,
        do.contour = FALSE, contour.color = "black", contour.linetype = "solid", do.ellipse = FALSE,
        trajectory.group.by = "", add.trajectory.by.groups = list(), trajectory.arrow.size = 0.1,
        split.nrow = NA, split.ncol = NA, split.adjust.scales = "fixed", multivar.split.dir = "col",
        subplot.margin.x = 0.03, subplot.margin.y = 0.1,
        legend.show = TRUE, legend.color.title = "make", legend.color.breaks = "",
        legend.title.size = 14, legend.text.size = 12, size.legend.x = 1.03, size.legend.y = 0.35,
        hover.data = "", hover.round.digits = 5, webgl = FALSE, single.point.color = "#000000",
        linear.model = FALSE, best.fit = FALSE, line.best.smoothness = 1, line.best.colour = "#000000",
        custom.model.enable = FALSE, custom.models = NULL,
        marginal.x = character(0), marginal.y = character(0), marginal.x.size = 0.15, marginal.y.size = 0.15,
        marginal.opacity = 0.5, marginal.bins = 30, marginal.binwidth = NA, marginal.density.adjust = 1,
        marginal.rug.height = 0.3, marginal.rug.width = 1,
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
.scatter_figure <- function(df, inputs, defaults = NULL) {
    fig <- NULL
    shiny::testServer(
        dittoViz_scatterPlotServer,
        args = list(id = "scatter", data = shiny::reactive(df), defaults = defaults),
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
        px <- VizModules:::adjusted_values(df$units, adj$x.adjustment, adj$x.adj.fxn)
        py <- VizModules:::adjusted_values(df$revenue, adj$y.adjustment, adj$y.adj.fxn)
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

.iris_trajectory <- function(paths, ...) {
    .scatter_inputs(
        x.by = "Sepal.Length", y.by = "Sepal.Width", color.by = "Species",
        trajectory.group.by = "Species", add.trajectory.by.groups = VizModules:::.trajectory_rows(paths), ...
    )
}

test_that("trajectories run through the plotted group medians and end in an arrowhead (#231)", {
    df <- example_iris
    # The path doubles back: virginica's median lies right of versicolor's, so a path
    # sorted by x would visit the groups in another order.
    visit <- c("setosa", "virginica", "versicolor")
    for (adj in list(list(), list(x.adj.fxn = "log2", y.adjustment = "z-score"))) {
        info <- paste(names(adj), unlist(adj), collapse = ", ")
        fig <- .scatter_figure(df, do.call(.iris_trajectory, c(list(list(visit)), adj)))
        expect_s3_class(fig, "plotly")
        paths <- expect_fit_lines_on_points(fig, "Trajectory")
        heads <- expect_arrows_on_points(fig)
        expect_length(paths, 1)
        expect_length(heads, 1)

        px <- VizModules:::adjusted_values(df$Sepal.Length, adj$x.adjustment, adj$x.adj.fxn)
        py <- VizModules:::adjusted_values(df$Sepal.Width, adj$y.adjustment, adj$y.adj.fxn)
        mx <- vapply(split(px, df$Species), stats::median, numeric(1))
        my <- vapply(split(py, df$Species), stats::median, numeric(1))
        expect_equal(as.numeric(unlist(paths[[1]]$x)), unname(mx[visit]), info = info)
        expect_equal(as.numeric(unlist(paths[[1]]$y)), unname(my[visit]), info = info)

        # The head points along the last segment, from virginica to versicolor.
        h <- heads[[1]]
        expect_equal(
            as.numeric(c(h$ax, h$ay, h$x, h$y)),
            unname(c(mx["virginica"], my["virginica"], mx["versicolor"], my["versicolor"])),
            info = info
        )

        # dittoViz's own path, which lost its head in ggplotly, is not drawn as well.
        lines <- Filter(function(tr) grepl("lines", tr$mode %||% ""), plotly::plotly_build(fig)$x$data)
        expect_equal(vapply(lines, function(tr) tr$name %||% "", character(1)), "Trajectory", info = info)
    }
})

test_that("each facet panel's trajectory runs through the medians of its own points", {
    # Each panel's points lie apart from the other's, so a path drawn from the other
    # panel's medians, or from the whole data's, lies off them. Panel A has no "late"
    # points, so the path through "late" is left out of it. That path doubles back in
    # x, so it must keep the order it visits its groups in.
    df <- data.frame(
        x = c(1:30, 101:130),
        y = c(1:30, 101:130),
        g = rep(c("B", "A"), each = 30),
        stage = rep(rep(c("early", "mid", "late"), each = 10), 2),
        stringsAsFactors = FALSE
    )
    df <- df[!(df$g == "A" & df$stage == "late"), ]

    fig <- .scatter_figure(df, .scatter_inputs(
        x.by = "x", y.by = "y", split.by = "g",
        trajectory.group.by = "stage",
        add.trajectory.by.groups = VizModules:::.trajectory_rows(list(c("late", "early", "mid"), c("early", "mid")))
    ))
    paths <- expect_fit_lines_on_points(fig, "Trajectory", min.count = 3)
    heads <- expect_arrows_on_points(fig, min.count = 3)
    expect_length(paths, 3)
    expect_length(heads, 3)
    in_a <- vapply(paths, function(tr) min(as.numeric(unlist(tr$x))) > 100, logical(1))
    expect_equal(sum(in_a), 1)
    expect_length(unlist(paths[in_a][[1]]$x), 2)

    # Panel B's medians are 5.5 (early), 15.5 (mid) and 25.5 (late).
    long <- Filter(function(tr) length(unlist(tr$x)) == 3, paths)
    expect_length(long, 1)
    expect_equal(as.numeric(unlist(long[[1]]$x)), c(25.5, 5.5, 15.5))
    expect_true(any(vapply(heads, function(h) isTRUE(all.equal(as.numeric(c(h$ax, h$x)), c(5.5, 15.5))),
        logical(1))))
})

test_that("no trajectory is drawn along a categorical axis, nor through a group with no points", {
    trajectory_count <- function(fig) {
        built <- plotly::plotly_build(fig)
        names <- vapply(built$x$data, function(tr) tr$name %||% "", character(1))
        c(paths = sum(names == "Trajectory"), heads = length(.data_arrows(built)))
    }

    categorical <- .scatter_figure(
        example_iris, .iris_trajectory(list(c("setosa", "virginica")), x.adj.fxn = "as.factor")
    )
    expect_s3_class(categorical, "plotly")
    expect_equal(trajectory_count(categorical), c(paths = 0, heads = 0))

    # A group with no points (a misspelt default, or one filtered out) leaves out only
    # the path through it.
    missing <- .scatter_figure(
        example_iris, .iris_trajectory(list(c("setosa", "virginca"), c("setosa", "versicolor")))
    )
    expect_equal(trajectory_count(missing), c(paths = 1, heads = 1))
    expect_arrows_on_points(missing)
})

test_that("trajectory paths are read from the Trajectories rows and from each defaults form", {
    rows <- list(trajectories1 = list(groups = c("B", "A")), trajectories2 = list(groups = character(0)))
    expect_identical(VizModules:::.trajectory_paths(rows), list(c("B", "A")))
    expect_identical(VizModules:::.trajectory_paths(list(c("A", "B"), c("C", "", "D"))), list(c("A", "B"), c("C", "D")))
    expect_identical(VizModules:::.trajectory_paths(c("A", "B")), list(c("A", "B")))
    expect_identical(VizModules:::.trajectory_paths("[A, B], [C,D,E]"), list(c("A", "B"), c("C", "D", "E")))
    expect_identical(VizModules:::.trajectory_paths(""), list())
    expect_identical(VizModules:::.trajectory_paths(NULL), list())
    expect_identical(VizModules:::.trajectory_rows(list(c("B", "A"))), list(trajectories1 = list(groups = c("B", "A"))))
})

test_that("default trajectories are drawn before the Trajectories list reports", {
    inputs <- .iris_trajectory(list())
    inputs$add.trajectory.by.groups <- NULL
    fig <- .scatter_figure(example_iris, inputs, defaults = list(
        trajectory.group.by = "Species", add.trajectory.by.groups = list(c("setosa", "virginica"))
    ))
    heads <- expect_arrows_on_points(fig)
    expect_length(heads, 1)
    mx <- vapply(split(example_iris$Sepal.Length, example_iris$Species), stats::median, numeric(1))
    expect_equal(as.numeric(c(heads[[1]]$ax, heads[[1]]$x)), unname(mx[c("setosa", "virginica")]))
})

test_that("the Trajectories list offers the group column's levels and clears when the column changes", {
    # The rows a rendered list starts with, from its data-initial attribute.
    initial_rows <- function(html) {
        attr <- regmatches(html, regexpr('data-initial="[^"]*"', html))
        rows <- jsonlite::fromJSON(gsub("&quot;", "\"", sub('^data-initial="(.*)"$', "\\1", attr)),
            simplifyVector = FALSE)
        lapply(rows, function(r) unlist(r$fields[[1]]$value))
    }
    shiny::testServer(
        dittoViz_scatterPlotServer,
        args = list(id = "scatter", data = shiny::reactive(example_iris), defaults = list(
            trajectory.group.by = "Species", add.trajectory.by.groups = list(c("virginica", "setosa"))
        )),
        {
            session$setInputs(trajectory.group.by = "Species")
            html <- output$add.trajectory.by.groups.ui$html
            expect_match(html, "<select[^>]*multiple", perl = TRUE)
            for (lvl in levels(example_iris$Species)) expect_match(html, sprintf('<option value="%s"', lvl))
            expect_identical(initial_rows(html), list(c("virginica", "setosa")))

            # Rows the user made carry over while the column stays the same...
            session$setInputs(add.trajectory.by.groups = list(trajectories1 = list(groups = c("setosa", "versicolor"))))
            session$setInputs(trajectory.group.by = "Group")
            html <- output$add.trajectory.by.groups.ui$html
            expect_match(html, '<option value="D"')
            expect_identical(initial_rows(html), list())

            # ...and the default column brings back the default paths.
            session$setInputs(trajectory.group.by = "Species")
            expect_identical(initial_rows(output$add.trajectory.by.groups.ui$html), list(c("virginica", "setosa")))
        }
    )
})

test_that("group colours follow their names when a factor level has no points", {
    # "B" is a level with no rows, as a filtered table or a wrapper's fixed
    # levels leave it. Positional colours would hand C the colour meant for B.
    df <- data.frame(x = 1:4, y = 4:1, grp = factor(c("A", "A", "C", "C"), levels = c("A", "B", "C")))
    fig <- NULL
    shiny::testServer(
        dittoViz_scatterPlotServer,
        args = list(
            id = "scatter", data = shiny::reactive(df),
            defaults = list(color.panel = c(A = "#FF0000", B = "#00FF00", C = "#0000FF"))
        ),
        {
            suppressWarnings({
                do.call(session$setInputs, .scatter_inputs(x.by = "x", y.by = "y", color.by = "grp"))
                session$flushReact()
            })
            fig <<- suppressWarnings(generate_scatterPlot())
        }
    )
    traces <- Filter(function(tr) identical(tr$mode, "markers") && !is.null(tr$name),
        plotly::plotly_build(fig)$x$data)
    colours <- vapply(traces, function(tr) as.character(tr$marker$color[1]), character(1))
    names(colours) <- vapply(traces, function(tr) tr$name, character(1))
    expect_identical(unname(colours[c("A", "C")]), c("rgba(255,0,0,1)", "rgba(0,0,255,1)"))
})

test_that("fig.fn lets a wrapper add layers and retitle an axis", {
    hook <- function(fig, input, isolate_fn) {
        fig$x$layout$xaxis$title$text <- paste(isolate_fn(input$x.by), "(hooked)")
        plotly::add_annotations(fig, x = 0.5, y = 0.5, xref = "paper", yref = "paper",
            text = "hook-marker", showarrow = FALSE)
    }
    fig <- NULL
    shiny::testServer(
        dittoViz_scatterPlotServer,
        args = list(id = "scatter", data = shiny::reactive(example_sales), fig.fn = hook),
        {
            suppressWarnings({
                do.call(session$setInputs, .scatter_inputs())
                session$flushReact()
            })
            fig <<- suppressWarnings(generate_scatterPlot())
        }
    )
    annos <- plotly::plotly_build(fig)$x$layout$annotations
    texts <- vapply(annos, function(a) as.character(a$text %||% ""), character(1))

    expect_true("hook-marker" %in% texts)
    # The retitled axis is the one made draggable, not the column name.
    expect_true("units (hooked)" %in% texts)

    unhooked <- .scatter_figure(example_sales, .scatter_inputs())
    unhooked_texts <- vapply(plotly::plotly_build(unhooked)$x$layout$annotations,
        function(a) as.character(a$text %||% ""), character(1))
    expect_false("hook-marker" %in% unhooked_texts)
    expect_true("units" %in% unhooked_texts)

    expect_error(dittoViz_scatterPlotServer("x", shiny::reactive(example_sales), fig.fn = "not a function"))
})

test_that("a Size By column spans the chosen point sizes and limits, and the size legend follows (#364)", {
    units <- example_sales$units
    markers <- function(fig) sort(.extract_marker_sizes(fig))
    legend_of <- function(fig) {
        anns <- plotly::plotly_build(fig)$x$layout$annotations
        texts <- vapply(anns, function(a) a$text, character(1))
        circles <- texts[grepl("font-size", texts)]
        font_px <- as.numeric(sub(".*font-size:([0-9.eE+-]+)px.*", "\\1", circles))
        list(labels = texts[grepl("^[0-9.]+$", texts)], diameters = font_px * .CIRCLE_GLYPH_DIAMETER_RATIO)
    }

    # Left alone, the column spans ggplot2's default sizes over its own range.
    fig <- .scatter_figure(example_sales, .scatter_inputs(size.by = "units"))
    expect_equal(markers(fig), sort(.size_scale_px(units, c(1, 6), range(units))))

    fig <- .scatter_figure(example_sales, .scatter_inputs(
        size.by = "units", size.min = 2, size.max = 10, size.scale.min = 0, size.scale.max = 2000
    ))
    expect_equal(markers(fig), sort(.size_scale_px(units, c(2, 10), c(0, 2000))))
    legend <- legend_of(fig)
    expect_equal(legend$labels, c("0", "500", "1000", "1500", "2000"))
    expect_equal(legend$diameters, .size_scale_px(c(0, 500, 1000, 1500, 2000), c(2, 10), c(0, 2000)))

    # A lower limit above some of the values draws them at the smallest size
    # rather than dropping them.
    fig <- .scatter_figure(example_sales, .scatter_inputs(size.by = "units", size.scale.min = 200))
    expect_length(markers(fig), length(units))
    expect_equal(min(markers(fig)), .size_scale_px(200, c(1, 6), c(200, max(units))))
})

# --- Marginal plots (#113) ----------------------------------------------------

# Marginal traces sit off the main x/y pair.
.scatter_marginals <- function(fig) {
    Filter(
        function(tr) !identical(tr$xaxis %||% "x", "x") || !identical(tr$yaxis %||% "y", "y"),
        plotly::plotly_build(fig)$x$data
    )
}

test_that("the marginals follow Color By, in the points' colours", {
    fig <- .scatter_figure(example_sales, .scatter_inputs(
        color.by = "product_line", linear.model = TRUE, marginal.x = "density", marginal.y = "density"
    ))
    built <- plotly::plotly_build(fig)
    marginals <- .scatter_marginals(fig)
    expect_length(marginals, 6)

    points <- Filter(function(tr) identical(tr$mode, "markers") && !is.null(tr$name), built$x$data)
    point.colors <- stats::setNames(
        vapply(points, function(tr) as.character(tr$marker$color[1]), character(1)),
        vapply(points, `[[`, character(1), "name")
    )
    for (tr in marginals) {
        expect_identical(plotly::toRGB(tr$line$color), point.colors[[tr$name]])
        expect_identical(tr$legendgroup, tr$name)
    }

    # Fit lines stay on the main panel.
    expect_fit_lines_on_points(fig, paste("Linear Fit", names(point.colors)), min.count = 3)
    fit.axes <- unique(unlist(lapply(
        Filter(function(tr) grepl("^Linear Fit", tr$name %||% ""), built$x$data),
        function(tr) paste(tr$xaxis, tr$yaxis)
    )))
    expect_identical(fit.axes, "x y")
})

test_that("the marginals are drawn from the plotted values, after an adjustment", {
    fig <- .scatter_figure(example_sales, .scatter_inputs(
        x.adj.fxn = "log10", marginal.x = "rug", marginal.rug.width = 2.5
    ))
    rug <- .scatter_marginals(fig)
    expect_length(rug, 1)
    expect_equal(rug[[1]]$line$width, 2.5)
    ticks <- rug[[1]]$x[!is.na(rug[[1]]$x)][c(TRUE, FALSE)]
    expect_equal(sort(ticks), sort(log10(example_sales$units)))
})

test_that("no marginals are drawn on a split plot, nor along a categorical axis", {
    split <- .scatter_figure(example_sales, .scatter_inputs(
        split.by = "product_line", marginal.x = "density", marginal.y = "rug"
    ))
    fills <- vapply(plotly::plotly_build(split)$x$data, function(tr) tr$fill %||% "", character(1))
    expect_false(any(fills %in% c("tozeroy", "tozerox")))
    expect_false(any(vapply(plotly::plotly_build(split)$x$data, function(tr) identical(tr$hoverinfo, "skip") &&
        identical(tr$mode, "lines"), logical(1))))

    # A categorical X keeps the Y marginal only.
    categorical <- .scatter_figure(example_sales, .scatter_inputs(
        x.adj.fxn = "as.factor", marginal.x = "density", marginal.y = "density"
    ))
    fills <- vapply(.scatter_marginals(categorical), function(tr) tr$fill %||% "", character(1))
    expect_identical(fills, "tozerox")
})

test_that("the Marginals tab seeds its inputs from defaults", {
    selected <- function(html, id) {
        html <- paste(html, collapse = "")
        config <- regmatches(html, regexpr(paste0('data-for="', id, '">.*?</script>'), html, perl = TRUE))
        json <- sub("</script>$", "", sub('^data-for="[^"]+">', "", config))
        unlist(jsonlite::fromJSON(json)$config$selectedValue)
    }
    plain <- as.character(dittoViz_scatterPlotInputsUI("scatter", example_sales))
    expect_length(selected(plain, "scatter-marginal.x"), 0)
    expect_identical(.select_choices(plain, "scatter-marginal.x"), c("density", "histogram", "rug"))

    seeded <- paste(as.character(dittoViz_scatterPlotInputsUI("scatter", example_sales, defaults = list(
        marginal.x = c("density", "rug"), marginal.y = "histogram", marginal.bins = 12, marginal.rug.height = 0.4
    ))), collapse = "")
    expect_identical(selected(seeded, "scatter-marginal.x"), c("density", "rug"))
    expect_identical(selected(seeded, "scatter-marginal.y"), "histogram")
    expect_match(seeded, 'id="scatter-marginal.bins" type="number" class="shiny-input-number form-control" value="12"',
        fixed = TRUE
    )
    expect_match(seeded,
        'id="scatter-marginal.rug.height" type="number" class="shiny-input-number form-control" value="0.4"',
        fixed = TRUE
    )

    # An unknown marginal type falls back to none.
    bad <- as.character(dittoViz_scatterPlotInputsUI("scatter", example_sales,
        defaults = list(marginal.x = "violin")
    ))
    expect_length(selected(bad, "scatter-marginal.x"), 0)
})
