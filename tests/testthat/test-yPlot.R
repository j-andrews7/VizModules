# Helper: pull the non-empty hover strings out of a plotly figure produced by
# dittoViz::yPlot(do.hover = TRUE) (which returns a plotly object directly).
.yplot_hover_text <- function(fig) {
    txt <- unlist(lapply(fig$x$data, function(tr) tr$text))
    txt[!is.na(txt) & nzchar(txt)]
}

test_that("yPlot UI exposes the Hover Data and Hover Round Digits inputs", {
    df <- data.frame(
        num1 = c(1, 2, 3),
        num2 = c(4.5, 5.5, 6.5),
        cat1 = c("a", "b", "c"),
        stringsAsFactors = FALSE
    )
    ui <- dittoViz_yPlotInputsUI("yplot", df)
    html <- as.character(ui)

    # Both hover controls are namespaced and present in the rendered UI.
    expect_true(grepl("yplot-hover.data", html, fixed = TRUE))
    expect_true(grepl("Hover Data", html, fixed = TRUE))
    expect_true(grepl("yplot-hover.round.digits", html, fixed = TRUE))
    expect_true(grepl("Hover Round Digits", html, fixed = TRUE))
})

test_that("yPlot UI takes several Y variables and exposes the multivar controls", {
    df <- data.frame(
        num1 = c(1, 2, 3),
        num2 = c(4.5, 5.5, 6.5),
        cat1 = c("a", "b", "c"),
        stringsAsFactors = FALSE
    )
    ui <- dittoViz_yPlotInputsUI("yplot", df, defaults = list(var = c("num1", "num2")))
    html <- as.character(ui)

    # The Y Data select is a multi-select and honours a multi-column default.
    expect_true(grepl('"multiple":true', html, fixed = TRUE))
    expect_true(grepl('"selectedValue":["num1","num2"]', html, fixed = TRUE))

    # The controls for how those variables are displayed are present.
    expect_true(grepl("yplot-multivar.aes", html, fixed = TRUE))
    expect_true(grepl("Multivar Aesthetic", html, fixed = TRUE))
    expect_true(grepl("yplot-multivar.split.dir", html, fixed = TRUE))
})

test_that("the seeded Y axis limits span every default Y variable", {
    df <- data.frame(
        num1 = c(1, 2, 3),
        num2 = c(4.5, 5.5, 6.5),
        cat1 = c("a", "b", "c"),
        stringsAsFactors = FALSE
    )
    ui <- dittoViz_yPlotInputsUI("yplot", df, defaults = list(var = c("num1", "num2")))
    html <- as.character(ui)

    # Both variables share one axis, so its limits must fit the pair, not just
    # the first column.
    expect_match(html, paste0('id="yplot-y\\.max"[^>]*value="', 6.5 * 1.11, '"'))
    expect_match(html, 'id="yplot-y\\.min"[^>]*value="1"')
})

test_that("dittoViz facets by variable when the module passes several vars", {
    skip_if_not_installed("dittoViz")
    skip_if_not_installed("plotly")

    set.seed(1)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 10),
        val1 = round(rnorm(20), 4),
        val2 = round(rnorm(20) + 5, 4),
        stringsAsFactors = FALSE
    )

    # The arguments the module now builds for a two-variable selection.
    fig <- dittoViz::yPlot(
        df,
        var = c("val1", "val2"), group.by = "grp", plots = "jitter",
        multivar.aes = "split", multivar.split.dir = "col",
        do.hover = TRUE,
        hover.data = unique(c(
            c("val1", "val2"), paste0(c("val1", "val2"), ".adj"),
            "var.multi", "var.which", "grp"
        ))
    )

    # One panel per variable, each labelled by its column name.
    axes <- grep("^xaxis", names(fig$x$layout), value = TRUE)
    expect_gt(length(axes), 1)
    strips <- vapply(fig$x$layout$annotations, function(a) {
        if (is.null(a$text)) "" else as.character(a$text)
    }, character(1))
    expect_true(all(c("val1", "val2") %in% strips))
})

test_that("the palette follows the Y variables when they drive the fill", {
    skip_if_not_installed("dittoViz")

    set.seed(1)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 10),
        zeta = rnorm(20),
        alpha = rnorm(20) + 2,
        stringsAsFactors = FALSE
    )

    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(id = "yplot", data = shiny::reactive(df)),
        {
            # dittoViz fills by its "var.which" column for this aesthetic, so the
            # palette (and the colour picker built from it) has to be keyed by
            # variable name. Names that miss the fill values leave the plot grey.
            session$setInputs(
                var = c("zeta", "alpha"), group.by = "grp", color.by = "",
                multivar.aes = "color"
            )
            expect_equal(palette_groups(), c("alpha", "zeta"))

            # Every other layout still fills by the grouping column.
            session$setInputs(multivar.aes = "split")
            expect_equal(palette_groups(), c("A", "B"))

            session$setInputs(multivar.aes = "group")
            expect_equal(palette_groups(), c("A", "B"))

            session$setInputs(var = "zeta", multivar.aes = "color")
            expect_equal(palette_groups(), c("A", "B"))
        }
    )
})

test_that("a rebuilt colour picker reporting the same palette does not rebuild the plot", {
    skip_if_not_installed("dittoViz")

    set.seed(1)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 8),
        v1 = rnorm(16),
        v2 = rnorm(16) + 3,
        stringsAsFactors = FALSE
    )

    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(id = "yplot", data = shiny::reactive(df)),
        {
            session$setInputs(
                var = c("v1", "v2"), group.by = "grp", color.by = "",
                multivar.aes = "color"
            )
            session$flushReact()

            # The palette the picker is seeded with is settled server-side, so the
            # first draw is on the right colours rather than a fallback.
            settled <- resolved_palette()
            expect_equal(settled, c(v1 = "#E69F00", v2 = "#56B4E9"))

            # The client reporting that same seed back changes nothing.
            session$setInputs(palette.colours = settled)
            expect_identical(resolved_palette(), settled)

            # The picker is rebuilt whenever the group set changes and is re-seeded
            # from this same resolution, so what it reports afterwards - on opening
            # the tab it lives in, say - resolves to the palette already drawn. The
            # plot reads the resolution, so that costs no rebuild.
            session$setInputs(
                palette.colours = c(v1 = "#E69F00", v2 = "#56B4E9", Sales = "#000000")
            )
            expect_false(identical(input$palette.colours, settled))
            expect_identical(resolved_palette(), settled)

            # A colour the user actually picked still comes through.
            session$setInputs(palette.colours = c(v1 = "#123456", v2 = "#56B4E9"))
            expect_identical(resolved_palette(), c(v1 = "#123456", v2 = "#56B4E9"))
        }
    )
})

test_that("stats for several Y variables are computed within each variable's facet", {
    skip_if_not_installed("dittoViz")

    set.seed(2)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 12),
        val1 = c(rnorm(12), rnorm(12) + 3),
        val2 = c(rnorm(12), rnorm(12) - 3),
        stringsAsFactors = FALSE
    )

    long <- VizModules:::.multivar_long_df(df, c("val1", "val2"))
    stats_df <- compute_pairwise_stats(
        df = long, x = "grp", y = "var.multi",
        test = "wilcox.test", facet.by = "var.which", per.facet = TRUE
    )

    # One A-vs-B comparison per variable, each run on that variable's values only.
    expect_equal(nrow(stats_df), 2)
    expect_setequal(stats_df$facet_level, c("val1", "val2"))

    per_var <- vapply(c("val1", "val2"), function(v) {
        compute_pairwise_stats(
            df = df, x = "grp", y = v, test = "wilcox.test"
        )$p.value
    }, numeric(1))
    expect_equal(
        stats_df$p.value[match(c("val1", "val2"), stats_df$facet_level)],
        unname(per_var)
    )

    # Each variable's bracket must land on its own panel rather than stacking up
    # on the first one.
    fig <- dittoViz::yPlot(
        df,
        var = c("val1", "val2"), group.by = "grp", plots = "boxplot",
        multivar.aes = "split", do.hover = TRUE
    )
    stat_result <- create_stat_annotations(
        stats_df = stats_df, fig = fig, df = long,
        x = "grp", y = "var.multi", facet.by = "var.which", display = "symbol"
    )
    xrefs <- vapply(stat_result$annotations, function(a) {
        if (is.null(a$xref)) NA_character_ else a$xref
    }, character(1))
    expect_length(xrefs, 2)
    expect_equal(length(unique(xrefs)), 2)
})

test_that("module default hover.data reconstructs dittoViz's internal default", {
    skip_if_not_installed("dittoViz")
    skip_if_not_installed("plotly")

    set.seed(1)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 10),
        val = round(c(rnorm(10), rnorm(10) + 2), 4),
        lab = paste0("cell", seq_len(20)),
        stringsAsFactors = FALSE
    )

    # The module reconstructs this set (see dittoViz_yPlotServer's generate_yPlot)
    # when the user makes no explicit Hover Data selection.
    var.name <- "val"
    group.by <- "grp"
    color.by <- "grp"
    reconstructed <- unique(c(
        var.name, paste0(var.name, ".adj"),
        "var.multi", "var.which",
        group.by, color.by, NULL, NULL
    ))

    default_fig <- dittoViz::yPlot(
        df, var = "val", group.by = "grp", plots = "jitter", do.hover = TRUE
    )
    reconstructed_fig <- dittoViz::yPlot(
        df, var = "val", group.by = "grp", plots = "jitter",
        do.hover = TRUE, hover.data = reconstructed
    )

    # Passing the reconstructed default must reproduce the package default hover
    # content exactly, so users who never touch Hover Data see no change.
    expect_identical(
        .yplot_hover_text(reconstructed_fig),
        .yplot_hover_text(default_fig)
    )
})

test_that("a custom hover.data selection controls which columns appear on hover", {
    skip_if_not_installed("dittoViz")
    skip_if_not_installed("plotly")

    set.seed(1)
    df <- data.frame(
        grp = rep(c("A", "B"), each = 10),
        val = round(c(rnorm(10), rnorm(10) + 2), 4),
        lab = paste0("cell", seq_len(20)),
        stringsAsFactors = FALSE
    )

    fig <- dittoViz::yPlot(
        df, var = "val", group.by = "grp", plots = "jitter",
        do.hover = TRUE, hover.data = c("lab", "grp")
    )
    txt <- .yplot_hover_text(fig)

    expect_true(all(grepl("lab:", txt, fixed = TRUE)))
    expect_true(all(grepl("grp:", txt, fixed = TRUE)))
    # A column that was not selected must not leak into the hover text.
    expect_false(any(grepl("val:", txt, fixed = TRUE)))
})

test_that("hover.round.digits controls rounding of numeric hover values", {
    skip_if_not_installed("dittoViz")
    skip_if_not_installed("plotly")

    df <- data.frame(
        grp = rep(c("A", "B"), each = 3),
        val = c(1.234567, 2.345678, 3.456789, 4.567891, 5.678912, 6.789123),
        stringsAsFactors = FALSE
    )

    fig <- dittoViz::yPlot(
        df, var = "val", group.by = "grp", plots = "jitter",
        do.hover = TRUE, hover.data = "val", hover.round.digits = 2
    )
    txt <- .yplot_hover_text(fig)

    # Every value is rounded to two decimals (e.g. "val: 1.23"), never more.
    vals <- sub(".*val: ", "", txt)
    decimals <- ifelse(grepl("\\.", vals), nchar(sub(".*\\.", "", vals)), 0L)
    expect_true(all(decimals <= 2))
})

test_that("yPlot seeds its palette from defaults", {
    skip_if_not_installed("dittoViz")

    df <- data.frame(
        grp = rep(c("A", "B"), each = 4),
        val = as.numeric(1:8),
        stringsAsFactors = FALSE
    )

    shiny::testServer(
        dittoViz_yPlotServer,
        args = list(
            id = "yplot", data = shiny::reactive(df),
            defaults = list(palette.colours = c(A = "red", B = "#00FF00"))
        ),
        {
            session$setInputs(var = "val", group.by = "grp", color.by = "")
            session$flushReact()
            expect_equal(resolved_palette(), c(A = "#FF0000", B = "#00FF00"))
        }
    )
})
