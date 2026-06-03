## Helper to create mock plotly objects for testing
make_plotly <- function(data = list(), layout = list()) {
    fig <- list(x = list(data = data, layout = layout))
    class(fig) <- "plotly"
    fig
}

# ─── .hide_jitter_from_legend ─────────────────────────────────────────────────

test_that(".hide_jitter_from_legend hides scatter marker traces", {
  fig <- make_plotly(data = list(
    list(type = "box", showlegend = TRUE, name = "Group A"),
    list(type = "box", showlegend = TRUE, name = "Group B"),
    list(type = "scatter", mode = "markers", showlegend = TRUE, name = "Jitter A"),
    list(type = "scatter", mode = "markers", showlegend = TRUE, name = "Jitter B"),
    list(type = "scatter", mode = "lines", showlegend = TRUE, name = "Line")
  ))

  result <- VizModules:::.hide_jitter_from_legend(fig)

  expect_s3_class(result, "plotly")
  expect_true(result$x$data[[1]]$showlegend)
  expect_true(result$x$data[[2]]$showlegend)
  expect_false(result$x$data[[3]]$showlegend)
  expect_false(result$x$data[[4]]$showlegend)
  expect_true(result$x$data[[5]]$showlegend)
})

test_that(".hide_jitter_from_legend preserves trace count", {
  fig <- make_plotly(data = list(
    list(type = "box", showlegend = TRUE),
    list(type = "scatter", mode = "markers", showlegend = TRUE),
    list(type = "scatter", mode = "markers", showlegend = TRUE)
  ))

  result <- VizModules:::.hide_jitter_from_legend(fig)
  expect_equal(length(result$x$data), 3)
})

test_that(".hide_jitter_from_legend works with real BoxPlot", {
  p <- plotthis::BoxPlot(
    data = data.frame(
      x = rep(c("A", "B", "C"), 10),
      y = rnorm(30),
      group = rep(c("G1", "G2"), 15)
    ),
    x = "x", y = "y", group_by = "group", add_point = TRUE
  )
  fig <- plotly::ggplotly(p)
  result <- VizModules:::.hide_jitter_from_legend(fig)

  expect_s3_class(result, "plotly")
  scatter_markers <- vapply(result$x$data, function(trace) {
    !is.null(trace$type) && trace$type == "scatter" &&
      !is.null(trace$mode) && trace$mode == "markers"
  }, logical(1))

  for (i in which(scatter_markers)) {
    expect_false(result$x$data[[i]]$showlegend,
      info = sprintf("Scatter marker trace %d should have showlegend=FALSE", i)
    )
  }
})

test_that(".hide_jitter_from_legend handles empty data", {
  fig <- make_plotly(data = list())
  result <- VizModules:::.hide_jitter_from_legend(fig)
  expect_s3_class(result, "plotly")
  expect_equal(length(result$x$data), 0)
})

test_that(".hide_jitter_from_legend handles traces without type", {
  fig <- make_plotly(data = list(
    list(showlegend = TRUE, name = "No Type"),
    list(type = "scatter", mode = "markers", showlegend = TRUE)
  ))

  result <- VizModules:::.hide_jitter_from_legend(fig)
  expect_true(result$x$data[[1]]$showlegend)
  expect_false(result$x$data[[2]]$showlegend)
})

test_that(".hide_jitter_from_legend rejects non-plotly objects", {
  expect_error(
    VizModules:::.hide_jitter_from_legend(list(x = list(data = list()))),
    "plotly"
  )
})

test_that(".hide_jitter_from_legend with mtcars dataset", {
  p <- plotthis::BoxPlot(
    data = data.frame(
      x = factor(mtcars$cyl), y = mtcars$mpg, group = factor(mtcars$vs)
    ),
    x = "x", y = "y", group_by = "group", add_point = TRUE
  )
  fig <- plotly::ggplotly(p)
  result <- VizModules:::.hide_jitter_from_legend(fig)

  box_traces <- sum(vapply(result$x$data, function(t) {
    !is.null(t$type) && t$type == "box"
  }, logical(1)))
  scatter_markers <- sum(vapply(result$x$data, function(t) {
    !is.null(t$type) && t$type == "scatter" && !is.null(t$mode) && t$mode == "markers"
  }, logical(1)))

  expect_gt(box_traces, 0)
  expect_gt(scatter_markers, 0)

  for (trace in result$x$data) {
    if (!is.null(trace$type) && trace$type == "scatter" &&
      !is.null(trace$mode) && trace$mode == "markers") {
      expect_false(trace$showlegend)
    }
    if (!is.null(trace$type) && trace$type == "box") {
      expect_true(trace$showlegend)
    }
  }
})

# ─── .parse_numeric_list ──────────────────────────────────────────────────────

test_that(".parse_numeric_list parses comma-separated numbers", {
  expect_equal(VizModules:::.parse_numeric_list("1, 5, 8"), c(1, 5, 8))
  expect_equal(VizModules:::.parse_numeric_list("3.14"), 3.14)
  expect_equal(VizModules:::.parse_numeric_list("-1, 0, 2.5"), c(-1, 0, 2.5))
})

test_that(".parse_numeric_list returns NULL for empty/invalid input", {
  expect_null(VizModules:::.parse_numeric_list(NULL))
  expect_null(VizModules:::.parse_numeric_list(""))
  expect_null(VizModules:::.parse_numeric_list("   "))
  expect_null(VizModules:::.parse_numeric_list("abc, def"))
})

test_that(".parse_numeric_list drops non-numeric values", {
  expect_equal(VizModules:::.parse_numeric_list("1, abc, 3"), c(1, 3))
})

# ─── .recycle_line_style ──────────────────────────────────────────────────────

test_that(".recycle_line_style returns default when values is NULL or empty", {
  expect_equal(VizModules:::.recycle_line_style(NULL, 3, "red"), rep("red", 3))
  expect_equal(VizModules:::.recycle_line_style(character(0), 2, 1), rep(1, 2))
})

test_that(".recycle_line_style returns values unchanged when length matches", {
  expect_equal(VizModules:::.recycle_line_style(c("a", "b", "c"), 3, "x"), c("a", "b", "c"))
})

test_that(".recycle_line_style recycles first value when length mismatch", {
  expect_equal(VizModules:::.recycle_line_style(c("a", "b"), 4, "x"), rep("a", 4))
  expect_equal(VizModules:::.recycle_line_style(c(1, 2, 3), 2, 0), rep(1, 2))
})

# ─── .linetype_to_dash ───────────────────────────────────────────────────────

test_that(".linetype_to_dash maps all known linetypes", {
  expect_equal(VizModules:::.linetype_to_dash("solid"), "solid")
  expect_equal(VizModules:::.linetype_to_dash("dashed"), "dash")
  expect_equal(VizModules:::.linetype_to_dash("dotted"), "dot")
  expect_equal(VizModules:::.linetype_to_dash("dotdash"), "dashdot")
  expect_equal(VizModules:::.linetype_to_dash("longdash"), "longdash")
  expect_equal(VizModules:::.linetype_to_dash("twodash"), "longdashdot")
})

test_that(".linetype_to_dash is case-insensitive and defaults to solid", {
  expect_equal(VizModules:::.linetype_to_dash("SOLID"), "solid")
  expect_equal(VizModules:::.linetype_to_dash("Dashed"), "dash")
  expect_equal(VizModules:::.linetype_to_dash("unknown"), "solid")
})

# ─── adjust_column_values ───────────────────────────────────────────────────

test_that("adjust_column_values applies log2 transformation", {
  df <- data.frame(x = c(1, 2, 4, 8))
  result <- VizModules::adjust_column_values(df, x.col = "x", x.adj.fun = "log2")
  expect_true("x.adj" %in% names(result))
  expect_equal(result$x.adj, c(0, 1, 2, 3))
})

test_that("adjust_column_values applies transformations to multiple axes", {
  df <- data.frame(x = c(1, 10, 100), y = c(2, 4, 8))
  result <- VizModules::adjust_column_values(df, x.col = "x", y.col = "y",
    x.adj.fun = "log10", y.adj.fun = "sqrt")
  expect_equal(result$x.adj, c(0, 1, 2))
  expect_equal(result$y.adj, sqrt(c(2, 4, 8)))
})

test_that("adjust_column_values returns unchanged df for NULL/empty fun", {
  df <- data.frame(x = 1:3)
  expect_identical(VizModules::adjust_column_values(df, x.col = "x", x.adj.fun = NULL), df)
  expect_identical(VizModules::adjust_column_values(df, x.col = "x", x.adj.fun = ""), df)
})

test_that("adjust_column_values ignores non-numeric columns", {
  df <- data.frame(x = letters[1:3], stringsAsFactors = FALSE)
  result <- VizModules::adjust_column_values(df, x.col = "x", x.adj.fun = "log2")
  expect_false("x.adj" %in% names(result))
})

test_that("adjust_column_values handles invalid expression gracefully", {
  df <- data.frame(x = 1:3)
  result <- VizModules::adjust_column_values(df, x.col = "x", x.adj.fun = "{{invalid")
  expect_identical(result, df)
})

# ─── .add_plot_config ────────────────────────────────────────────────────────

test_that(".add_plot_config returns default config without facet", {
  config <- VizModules:::.add_plot_config()
  expect_true(config$edits$axisTitleText)
  expect_true(config$edits$titleText)
  expect_false(config$displaylogo)
  expect_equal(config$toImageButtonOptions$format, "png")
  expect_true(length(config$modeBarButtonsToAdd) > 0)
})

test_that(".add_plot_config with facet.by disables axisTitleText editing", {
  config <- VizModules:::.add_plot_config(facet.by = "group")
  expect_false(config$edits$axisTitleText)
  expect_true(config$edits$titleText)
})

test_that(".add_plot_config respects download format and filename", {
  config <- VizModules:::.add_plot_config(download.format = "svg", filename = "my_plot")
  expect_equal(config$toImageButtonOptions$format, "svg")
  expect_equal(config$toImageButtonOptions$filename, "my_plot")
})

test_that(".add_plot_config excludes modebar buttons when requested", {
  config <- VizModules:::.add_plot_config(include.modebar.buttons = FALSE)
  expect_null(config$modeBarButtonsToAdd)
})

# ─── .apply_subplot_axis_styling ─────────────────────────────────────────────

test_that(".apply_subplot_axis_styling returns NULL/empty fig unchanged", {
  expect_null(VizModules:::.apply_subplot_axis_styling(NULL, list(), list()))

  fig_no_x <- list(y = 1)
  expect_identical(VizModules:::.apply_subplot_axis_styling(fig_no_x, list(), list()), fig_no_x)
})

test_that(".apply_subplot_axis_styling applies style to single axes", {
  fig <- make_plotly(layout = list(
    xaxis = list(title = "X"),
    yaxis = list(title = "Y")
  ))

  result <- VizModules:::.apply_subplot_axis_styling(
    fig,
    xaxis_style = list(showgrid = FALSE),
    yaxis_style = list(showgrid = TRUE)
  )

  # plotly::layout() stores updates in layoutAttrs
  layout_update <- result$x$layoutAttrs[[1]]
  expect_false(layout_update$xaxis$showgrid)
  expect_true(layout_update$yaxis$showgrid)
  # Existing properties preserved
  expect_equal(layout_update$xaxis$title, "X")
})

test_that(".apply_subplot_axis_styling applies style to multiple subplot axes", {
  fig <- make_plotly(layout = list(
    xaxis = list(title = "X1"),
    xaxis2 = list(title = "X2"),
    yaxis = list(title = "Y1"),
    yaxis2 = list(title = "Y2")
  ))

  result <- VizModules:::.apply_subplot_axis_styling(
    fig,
    xaxis_style = list(linecolor = "red"),
    yaxis_style = list(linecolor = "blue")
  )

  layout_update <- result$x$layoutAttrs[[1]]
  expect_equal(layout_update$xaxis$linecolor, "red")
  expect_equal(layout_update$xaxis2$linecolor, "red")
  expect_equal(layout_update$yaxis$linecolor, "blue")
  expect_equal(layout_update$yaxis2$linecolor, "blue")
})

test_that(".apply_subplot_axis_styling handles empty layout names", {
  fig <- make_plotly(layout = list())
  result <- VizModules:::.apply_subplot_axis_styling(fig, list(a = 1), list(b = 2))
  expect_s3_class(result, "plotly")
})

# ─── .compute_linear_fit ─────────────────────────────────────────────────────

test_that(".compute_linear_fit returns data frame for global fit", {
  df <- data.frame(x = 1:10, y = 2 * (1:10) + 1)
  result <- VizModules:::.compute_linear_fit(df, "x", "y")

  expect_s3_class(result, "data.frame")
  expect_true(all(c("x", "y") %in% names(result)))
  expect_equal(nrow(result), 100)
  # Check fit is close to y = 2x + 1
  expect_equal(result$y[1], 2 * result$x[1] + 1, tolerance = 0.01)
})

test_that(".compute_linear_fit returns named list for grouped fit", {
  df <- data.frame(
    x = rep(1:10, 2),
    y = c(1:10, 2 * (1:10)),
    g = rep(c("A", "B"), each = 10)
  )
  result <- VizModules:::.compute_linear_fit(df, "x", "y", group.col = "g")

  expect_type(result, "list")
  expect_true(all(c("A", "B") %in% names(result)))
  expect_s3_class(result$A, "data.frame")
  expect_s3_class(result$B, "data.frame")
})

test_that(".compute_linear_fit returns NULL with fewer than 2 points", {
  df <- data.frame(x = 1, y = 1)
  expect_null(VizModules:::.compute_linear_fit(df, "x", "y"))
})

test_that(".compute_linear_fit handles NAs in data", {
  df <- data.frame(x = c(1, NA, 3, 4, 5), y = c(2, 4, NA, 8, 10))
  result <- VizModules:::.compute_linear_fit(df, "x", "y")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 100)
})

test_that(".compute_linear_fit treats empty group.col like NULL", {
  df <- data.frame(x = 1:5, y = 1:5)
  result_null <- VizModules:::.compute_linear_fit(df, "x", "y", group.col = NULL)
  result_empty <- VizModules:::.compute_linear_fit(df, "x", "y", group.col = "")
  expect_equal(nrow(result_null), nrow(result_empty))
})

# ─── .compute_loess_fit ──────────────────────────────────────────────────────

test_that(".compute_loess_fit returns data frame for global fit", {
  set.seed(42)
  df <- data.frame(x = 1:20, y = sin(1:20) + rnorm(20, sd = 0.1))
  result <- VizModules:::.compute_loess_fit(df, "x", "y")

  expect_s3_class(result, "data.frame")
  expect_true(all(c("x", "y") %in% names(result)))
  expect_equal(nrow(result), 100)
})

test_that(".compute_loess_fit returns NULL with fewer than 4 points", {
  df <- data.frame(x = 1:3, y = 1:3)
  expect_null(VizModules:::.compute_loess_fit(df, "x", "y"))
})

test_that(".compute_loess_fit returns named list for grouped fit", {
  set.seed(42)
  df <- data.frame(
    x = rep(1:20, 2),
    y = c(sin(1:20), cos(1:20)) + rnorm(40, sd = 0.1),
    g = rep(c("A", "B"), each = 20)
  )
  result <- VizModules:::.compute_loess_fit(df, "x", "y", group.col = "g")

  expect_type(result, "list")
  expect_true(all(c("A", "B") %in% names(result)))
})

test_that(".compute_loess_fit removes groups with insufficient data", {
  df <- data.frame(
    x = c(1:20, 1, 2),
    y = c(sin(1:20), 1, 2),
    g = c(rep("A", 20), "B", "B")
  )
  result <- VizModules:::.compute_loess_fit(df, "x", "y", group.col = "g")

  expect_true("A" %in% names(result))
  expect_false("B" %in% names(result))
})

# ─── .add_hlines ─────────────────────────────────────────────────────────────

test_that(".add_hlines returns empty list for NULL/empty intercepts", {
  fig <- make_plotly()
  expect_equal(VizModules:::.add_hlines(fig, NULL), list())
  expect_equal(VizModules:::.add_hlines(fig, numeric(0)), list())
})

test_that(".add_hlines creates correct shape for single line", {
  fig <- make_plotly(data = list(list(type = "scatter", x = 1:5, y = 1:5)))
  shapes <- VizModules:::.add_hlines(fig, intercepts = 3)

  expect_equal(length(shapes), 1)
  expect_equal(shapes[[1]]$type, "line")
  expect_equal(shapes[[1]]$y0, 3)
  expect_equal(shapes[[1]]$y1, 3)
  expect_equal(shapes[[1]]$x0, 0)
  expect_equal(shapes[[1]]$x1, 1)
  expect_equal(shapes[[1]]$line$color, "#000000")
})

test_that(".add_hlines creates multiple shapes with per-line styling", {
  fig <- make_plotly(data = list(list(type = "scatter", x = 1:5, y = 1:5)))
  shapes <- VizModules:::.add_hlines(fig, intercepts = c(1, 5),
    colors = c("red", "blue"), widths = c(2, 3))

  expect_equal(length(shapes), 2)
  expect_equal(shapes[[1]]$line$color, "red")
  expect_equal(shapes[[2]]$line$color, "blue")
  expect_equal(shapes[[1]]$line$width, 2)
  expect_equal(shapes[[2]]$line$width, 3)
})

# ─── .add_vlines ─────────────────────────────────────────────────────────────

test_that(".add_vlines returns empty list for NULL/empty intercepts", {
  fig <- make_plotly()
  expect_equal(VizModules:::.add_vlines(fig, NULL), list())
  expect_equal(VizModules:::.add_vlines(fig, numeric(0)), list())
})

test_that(".add_vlines creates correct shape for single line", {
  fig <- make_plotly(data = list(list(type = "scatter", x = 1:5, y = 1:5)))
  shapes <- VizModules:::.add_vlines(fig, intercepts = 2)

  expect_equal(length(shapes), 1)
  expect_equal(shapes[[1]]$x0, 2)
  expect_equal(shapes[[1]]$x1, 2)
  expect_equal(shapes[[1]]$y0, 0)
  expect_equal(shapes[[1]]$y1, 1)
})

# ─── .add_ablines ───────────────────────────────────────────────────────────

test_that(".add_ablines returns empty list for NULL slopes or intercepts", {
  fig <- make_plotly()
  expect_equal(VizModules:::.add_ablines(fig, NULL, c(0)), list())
  expect_equal(VizModules:::.add_ablines(fig, c(1), NULL), list())
  expect_equal(VizModules:::.add_ablines(fig, numeric(0), c(0)), list())
})

test_that(".add_ablines creates y = mx + b line", {
  fig <- make_plotly(
    data = list(list(type = "scatter", x = c(0, 10), y = c(0, 10))),
    layout = list(xaxis = list(range = c(0, 10)))
  )
  shapes <- VizModules:::.add_ablines(fig, slopes = 2, intercepts = 1)

  expect_equal(length(shapes), 1)
  # y0 = intercept + slope * x0 = 1 + 2*0 = 1
  expect_equal(shapes[[1]]$y0, 1 + 2 * shapes[[1]]$x0)
  expect_equal(shapes[[1]]$y1, 1 + 2 * shapes[[1]]$x1)
})

test_that(".add_ablines recycles shorter slopes/intercepts vector", {
  fig <- make_plotly(
    data = list(list(type = "scatter", x = 1:5, y = 1:5)),
    layout = list(xaxis = list(range = c(0, 5)))
  )
  # 2 slopes, 1 intercept -> intercept recycled to length 2
  shapes <- VizModules:::.add_ablines(fig, slopes = c(1, 2), intercepts = 0)
  expect_equal(length(shapes), 2)
})

# ─── .add_reference_lines ────────────────────────────────────────────────────

test_that(".add_reference_lines adds horizontal lines to figure", {
  fig <- make_plotly(data = list(list(type = "scatter", x = 1:5, y = 1:5)))
  result <- VizModules:::.add_reference_lines(fig, hline.intercepts = "2, 4")

  expect_true(length(result$x$layout$shapes) >= 2)
  expect_equal(result$x$layout$shapes[[1]]$y0, 2)
  expect_equal(result$x$layout$shapes[[2]]$y0, 4)
})

test_that(".add_reference_lines adds vertical lines to figure", {
  fig <- make_plotly(data = list(list(type = "scatter", x = 1:5, y = 1:5)))
  result <- VizModules:::.add_reference_lines(fig, vline.intercepts = "3")

  expect_true(length(result$x$layout$shapes) >= 1)
  expect_equal(result$x$layout$shapes[[1]]$x0, 3)
})

test_that(".add_reference_lines returns figure unchanged with no lines", {
  fig <- make_plotly(data = list(list(type = "scatter", x = 1:5, y = 1:5)))
  result <- VizModules:::.add_reference_lines(fig)
  expect_null(result$x$layout$shapes)
})

test_that(".add_reference_lines preserves existing shapes", {
  existing_shape <- list(type = "rect", x0 = 0, x1 = 1, y0 = 0, y1 = 1)
  fig <- make_plotly(
    data = list(list(type = "scatter", x = 1:5, y = 1:5)),
    layout = list(shapes = list(existing_shape))
  )
  result <- VizModules:::.add_reference_lines(fig, hline.intercepts = "5")

  expect_true(length(result$x$layout$shapes) >= 2)
  expect_equal(result$x$layout$shapes[[1]]$type, "rect")
})

# ─── .calculate_range ────────────────────────────────────────────────────────

test_that(".calculate_range returns correct min/max for numeric column", {
  df <- data.frame(val = c(2, 5, 10))
  result <- VizModules:::.calculate_range(df, data_col_y = "val", axis_scale_factor = 1.1)

  expect_equal(result$min, 2)
  expect_equal(result$max, 10 * 1.1)
})

test_that(".calculate_range returns NULL for missing or non-numeric column", {
  df <- data.frame(val = c("a", "b", "c"))
  expect_null(VizModules:::.calculate_range(df, data_col_y = "val", axis_scale_factor = 1))
  expect_null(VizModules:::.calculate_range(df, data_col_y = "", axis_scale_factor = 1))
  expect_null(VizModules:::.calculate_range(df, data_col_y = "nonexistent", axis_scale_factor = 1))
})

test_that(".calculate_range handles all NA values", {
  df <- data.frame(val = c(NA_real_, NA_real_))
  result <- VizModules:::.calculate_range(df, data_col_y = "val", axis_scale_factor = 1)
  expect_equal(result$min, 0)
  expect_equal(result$max, 1)
})

test_that(".calculate_range works with x column", {
  df <- data.frame(x = c(1, 3, 5))
  result <- VizModules:::.calculate_range(df, data_col_x = "x", axis_scale_factor = 1)
  expect_equal(result$min, 1)
  expect_equal(result$max, 5)
})

test_that(".calculate_range works in grouping mode", {
  df <- data.frame(
    vals = c(10, 20, 30, 5, 2, 1),
    grp = c("A", "A", "A", "B", "B", "B")
  )
  result <- VizModules:::.calculate_range(df, data_col_x = "grp", data_col_y = "vals",
    axis_scale_factor = 1, grouping = TRUE)

  expect_equal(result$min, 0)
  expect_equal(result$max, 60)
})

# ─── .remove_boxplot_outliers ────────────────────────────────────────────────

test_that(".remove_boxplot_outliers hides box trace markers", {
  fig <- make_plotly(data = list(
    list(type = "box", marker = list(opacity = 1), hoverinfo = "all"),
    list(type = "box", marker = list(opacity = 1), hoverinfo = "all")
  ))
  result <- VizModules:::.remove_boxplot_outliers(fig)

  for (trace in result$x$data) {
    expect_equal(trace$marker$opacity, 0)
    expect_equal(trace$hoverinfo, "none")
  }
})

test_that(".remove_boxplot_outliers leaves non-box traces unchanged", {
  fig <- make_plotly(data = list(
    list(type = "box", marker = list(opacity = 1), hoverinfo = "all"),
    list(type = "scatter", mode = "markers", marker = list(opacity = 0.8))
  ))
  result <- VizModules:::.remove_boxplot_outliers(fig)

  expect_equal(result$x$data[[1]]$marker$opacity, 0)
  expect_equal(result$x$data[[2]]$marker$opacity, 0.8)
})

test_that(".remove_boxplot_outliers rejects non-plotly objects", {
  expect_error(
    VizModules:::.remove_boxplot_outliers(list(x = list(data = list()))),
    "plotly"
  )
})

# ─── .empty_plot ─────────────────────────────────────────────────────────────

test_that(".empty_plot returns ggplot by default", {
  p <- VizModules:::.empty_plot(text = "No data")
  expect_s3_class(p, "ggplot")
})

test_that(".empty_plot returns plotly when requested", {
  p <- VizModules:::.empty_plot(text = "No data", plotly = TRUE)
  expect_s3_class(p, "plotly")
})

test_that(".empty_plot works with NULL text", {
  p <- VizModules:::.empty_plot(text = NULL)
  expect_s3_class(p, "ggplot")
})

# ─── is_pure_type ────────────────────────────────────────────────────────────

test_that("is_pure_type returns TRUE for all numeric columns", {
  df <- data.frame(a = 1:3, b = 4:6)
  expect_true(is_pure_type(c("a", "b"), df))
})

test_that("is_pure_type returns TRUE for all categorical columns", {
  df <- data.frame(a = letters[1:3], b = factor(c("x", "y", "z")), stringsAsFactors = FALSE)
  expect_true(is_pure_type(c("a", "b"), df))
})

test_that("is_pure_type returns FALSE for mixed numeric and categorical", {
  df <- data.frame(num = 1:3, cat = letters[1:3], stringsAsFactors = FALSE)
  expect_false(is_pure_type(c("num", "cat"), df))
})

test_that("is_pure_type returns TRUE for single column", {
  df <- data.frame(a = 1:3)
  expect_true(is_pure_type("a", df))
})

test_that("is_pure_type returns TRUE for empty or nonexistent columns", {
  df <- data.frame(a = 1:3)
  expect_true(is_pure_type("", df))
  expect_true(is_pure_type("nonexistent", df))
  expect_true(is_pure_type(character(0), df))
})

# ─── get_documentation ───────────────────────────────────────────────────────

test_that("get_documentation returns named list for valid function", {
  result <- VizModules::get_documentation("stats::lm", selected = c("formula"))
  expect_type(result, "list")
  expect_true(nzchar(result$formula))
})

test_that("get_documentation capitalizes when cap = TRUE", {
  result <- VizModules::get_documentation("stats::lm", selected = c("formula"), cap = TRUE)
  first_char <- substring(result$formula, 1, 1)
  expect_equal(first_char, toupper(first_char))
})

# ─── .create_axis_styles ────────────────────────────────────────────────────

test_that(".create_axis_styles returns expected structure for x axis", {
  mock_input <- list(
    axis.title.font.size = 14,
    axis.title.font.family = "Arial",
    axis.title.font.color = "black",
    axis.tickfont.size = 12,
    axis.tickfont.color = "#333",
    axis.tickfont.family = "Arial",
    axis.tickangle.x = -45,
    axis.tickangle.y = 0,
    axis.ticks = "outside",
    axis.tickcolor = "black",
    axis.ticklen = 5,
    axis.tickwidth = 1,
    show.grid.x = TRUE,
    show.grid.y = FALSE,
    grid.color = "#CCCCCC",
    axis.showline = TRUE,
    axis.mirror = FALSE,
    axis.linecolor = "black",
    axis.linewidth = 1
  )

  result <- VizModules:::.create_axis_styles(mock_input, axis_side = "x", isolate_fn = identity)

  expect_equal(result$title$font$size, 14)
  expect_equal(result$title$font$family, "Arial")
  expect_equal(result$tickangle, -45)
  expect_true(result$showgrid)
  expect_equal(result$gridcolor, "#CCCCCC")
})

test_that(".create_axis_styles returns expected structure for y axis", {
  mock_input <- list(
    axis.title.font.size = 14,
    axis.title.font.family = "Arial",
    axis.title.font.color = "black",
    axis.tickfont.size = 12,
    axis.tickfont.color = "#333",
    axis.tickfont.family = "Arial",
    axis.tickangle.x = 0,
    axis.tickangle.y = -90,
    axis.ticks = "outside",
    axis.tickcolor = "black",
    axis.ticklen = 5,
    axis.tickwidth = 1,
    show.grid.x = TRUE,
    show.grid.y = FALSE,
    grid.color = "#CCCCCC",
    axis.showline = TRUE,
    axis.mirror = FALSE,
    axis.linecolor = "black",
    axis.linewidth = 1
  )

  result <- VizModules:::.create_axis_styles(mock_input, axis_side = "y", isolate_fn = identity)

  expect_equal(result$tickangle, -90)
  expect_false(result$showgrid)
  expect_equal(result$gridcolor, "#CCCCCC")
})

test_that(".create_axis_styles excludes line props when ggplot.axis.styling is TRUE", {
  mock_input <- list(
    axis.title.font.size = 14, axis.title.font.family = "Arial",
    axis.title.font.color = "black", axis.tickfont.size = 12,
    axis.tickfont.color = "#333", axis.tickfont.family = "Arial",
    axis.tickangle.x = 0, axis.tickangle.y = 0,
    axis.ticks = "outside", axis.tickcolor = "black",
    axis.ticklen = 5, axis.tickwidth = 1,
    show.grid.x = TRUE, show.grid.y = TRUE,
    grid.color = "#CCCCCC",
    axis.showline = TRUE, axis.mirror = TRUE,
    axis.linecolor = "red", axis.linewidth = 2
  )

  result <- VizModules:::.create_axis_styles(mock_input, axis_side = "x",
    isolate_fn = identity, ggplot.axis.styling = TRUE)
  expect_null(result$showline)
  expect_null(result$mirror)

  result2 <- VizModules:::.create_axis_styles(mock_input, axis_side = "x",
    isolate_fn = identity, ggplot.axis.styling = FALSE)
  expect_true(result2$showline)
  expect_true(result2$mirror)
  expect_equal(result2$linecolor, "red")
})

# ─── .create_ggplot_axis_style ───────────────────────────────────────────────

test_that(".create_ggplot_axis_style returns full border when showline + mirror", {
  mock_input <- list(
    axis.showline = TRUE,
    axis.mirror = TRUE,
    axis.linecolor = "red",
    axis.linewidth = 2
  )
  result <- VizModules:::.create_ggplot_axis_style(mock_input, isolate_fn = identity)

  expect_true(inherits(result$panel.border, "element_rect"))
  expect_true(inherits(result$axis.line, "element_blank"))
})

test_that(".create_ggplot_axis_style returns axis lines only when showline but no mirror", {
  mock_input <- list(
    axis.showline = TRUE,
    axis.mirror = FALSE,
    axis.linecolor = "blue",
    axis.linewidth = 1
  )
  result <- VizModules:::.create_ggplot_axis_style(mock_input, isolate_fn = identity)

  expect_true(inherits(result$axis.line, "element_line"))
  expect_true(inherits(result$panel.border, "element_blank"))
})

test_that(".create_ggplot_axis_style returns no borders when showline is FALSE", {
  mock_input <- list(
    axis.showline = FALSE,
    axis.mirror = FALSE,
    axis.linecolor = "black",
    axis.linewidth = 1
  )
  result <- VizModules:::.create_ggplot_axis_style(mock_input, isolate_fn = identity)

  expect_true(inherits(result$panel.border, "element_blank"))
  expect_true(inherits(result$axis.line, "element_blank"))
})

# ─── .normalize_dot_markers ───────────────────────────────────────────────────

test_that(".normalize_dot_markers forces filled circles with thin outline", {
  fig <- make_plotly(data = list(
    list(type = "scatter", mode = "markers", marker = list(symbol = "circle-open")),
    list(type = "scatter", mode = "lines"),
    list(type = "bar")
  ))

  result <- VizModules:::.normalize_dot_markers(fig)

  expect_s3_class(result, "plotly")
  expect_equal(result$x$data[[1]]$marker$symbol, "circle")
  expect_equal(result$x$data[[1]]$marker$line$width, 0.5)
  expect_equal(result$x$data[[1]]$marker$line$color, "black")
  # Non-marker traces are left untouched
  expect_null(result$x$data[[2]]$marker)
  expect_null(result$x$data[[3]]$marker)
})

test_that(".normalize_dot_markers rejects non-plotly objects", {
  expect_error(
    VizModules:::.normalize_dot_markers(list(x = list(data = list()))),
    "plotly"
  )
})

# ─── .custom_legend ───────────────────────────────────────────────────────────

test_that(".custom_legend returns the figure unchanged when size_by is missing", {
  fig <- make_plotly()
  data <- data.frame(cell_type = c("A", "B"), pct_expressed = c(10, 20))

  expect_identical(VizModules:::.custom_legend(fig, data, size_by = NULL), fig)
  expect_identical(VizModules:::.custom_legend(fig, data, size_by = ""), fig)
  expect_identical(VizModules:::.custom_legend(fig, data, size_by = "absent"), fig)
})

test_that(".custom_legend returns the figure unchanged for non-numeric size_by", {
  fig <- make_plotly()
  data <- data.frame(cell_type = c("A", "B"), pct_expressed = c(10, 20))

  expect_identical(VizModules:::.custom_legend(fig, data, size_by = "cell_type"), fig)
})

test_that(".custom_legend appends size-legend annotations for numeric size_by", {
  data <- data.frame(
    cell_type = rep(c("A", "B"), each = 3),
    pct_expressed = c(5, 25, 50, 10, 40, 90)
  )
  fig <- plotly::plot_ly(
    data = data, x = ~cell_type, y = ~pct_expressed, type = "scatter", mode = "markers"
  )

  result <- VizModules:::.custom_legend(fig, data, size_by = "pct_expressed",
    size_values = c(10, 20, 30, 40, 50))

  expect_s3_class(result, "plotly")
  built <- plotly::plotly_build(result)
  # 1 title annotation + 5 circle glyphs + 5 numeric labels
  expect_equal(length(built$x$layout$annotations), 16)
  ann_text <- vapply(built$x$layout$annotations, function(a) a$text, character(1))
  expect_true("pct_expressed" %in% ann_text)
})
