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
