test_that(".hide_jitter_from_legend hides scatter marker traces", {
  # Create a mock plotly object with mixed trace types
  fig <- list(
    x = list(
      data = list(
        # Box trace - should be preserved
        list(type = "box", showlegend = TRUE, name = "Group A"),
        # Box trace - should be preserved
        list(type = "box", showlegend = TRUE, name = "Group B"),
        # Scatter with markers (jitter points) - should be hidden
        list(type = "scatter", mode = "markers", showlegend = TRUE, name = "Jitter A"),
        # Scatter with markers (jitter points) - should be hidden
        list(type = "scatter", mode = "markers", showlegend = TRUE, name = "Jitter B"),
        # Scatter with lines - should be preserved
        list(type = "scatter", mode = "lines", showlegend = TRUE, name = "Line")
      )
    )
  )
  class(fig) <- "plotly"

  # Apply the function
  result <- VizModules:::.hide_jitter_from_legend(fig)

  # Verify it returns a plotly object
  expect_s3_class(result, "plotly")

  # Verify box traces are preserved with showlegend = TRUE
  expect_true(result$x$data[[1]]$showlegend)
  expect_equal(result$x$data[[1]]$type, "box")
  expect_true(result$x$data[[2]]$showlegend)
  expect_equal(result$x$data[[2]]$type, "box")

  # Verify scatter marker traces are hidden
  expect_false(result$x$data[[3]]$showlegend)
  expect_equal(result$x$data[[3]]$type, "scatter")
  expect_equal(result$x$data[[3]]$mode, "markers")

  expect_false(result$x$data[[4]]$showlegend)
  expect_equal(result$x$data[[4]]$type, "scatter")
  expect_equal(result$x$data[[4]]$mode, "markers")

  # Verify scatter line trace is preserved
  expect_true(result$x$data[[5]]$showlegend)
  expect_equal(result$x$data[[5]]$type, "scatter")
  expect_equal(result$x$data[[5]]$mode, "lines")
})

test_that(".hide_jitter_from_legend preserves trace count", {
  # Create a mock plotly object
  fig <- list(
    x = list(
      data = list(
        list(type = "box", showlegend = TRUE),
        list(type = "scatter", mode = "markers", showlegend = TRUE),
        list(type = "scatter", mode = "markers", showlegend = TRUE)
      )
    )
  )
  class(fig) <- "plotly"

  result <- VizModules:::.hide_jitter_from_legend(fig)

  # Verify trace count is unchanged
  expect_equal(length(result$x$data), 3)
})

test_that(".hide_jitter_from_legend works with real BoxPlot", {
  # Create a real boxplot using plotthis
  p <- plotthis::BoxPlot(
    data = data.frame(
      x = rep(c("A", "B", "C"), 10),
      y = rnorm(30),
      group = rep(c("G1", "G2"), 15)
    ),
    x = "x",
    y = "y",
    group_by = "group",
    add_point = TRUE
  )

  # Convert to plotly
  fig <- plotly::ggplotly(p)

  # Apply function
  result <- VizModules:::.hide_jitter_from_legend(fig)

  # Verify result is plotly
  expect_s3_class(result, "plotly")

  # Find scatter marker traces
  scatter_markers <- sapply(result$x$data, function(trace) {
    !is.null(trace$type) && trace$type == "scatter" &&
      !is.null(trace$mode) && trace$mode == "markers"
  })

  # All scatter marker traces should have showlegend = FALSE
  for (i in which(scatter_markers)) {
    expect_false(result$x$data[[i]]$showlegend,
      info = sprintf("Scatter marker trace %d should have showlegend=FALSE", i)
    )
  }
})

test_that(".hide_jitter_from_legend handles empty data", {
  fig <- list(x = list(data = list()))
  class(fig) <- "plotly"

  result <- VizModules:::.hide_jitter_from_legend(fig)

  expect_s3_class(result, "plotly")
  expect_equal(length(result$x$data), 0)
})

test_that(".hide_jitter_from_legend handles traces without type", {
  fig <- list(
    x = list(
      data = list(
        list(showlegend = TRUE, name = "No Type"),
        list(type = "scatter", mode = "markers", showlegend = TRUE)
      )
    )
  )
  class(fig) <- "plotly"

  result <- VizModules:::.hide_jitter_from_legend(fig)

  # First trace without type should be preserved
  expect_true(result$x$data[[1]]$showlegend)
  # Second trace should be hidden
  expect_false(result$x$data[[2]]$showlegend)
})

test_that(".hide_jitter_from_legend rejects non-plotly objects", {
  not_plotly <- list(x = list(data = list()))

  expect_error(
    VizModules:::.hide_jitter_from_legend(not_plotly),
    "plotly"
  )
})

test_that(".hide_jitter_from_legend with mtcars dataset", {
  # Use mtcars with jitter
  p <- plotthis::BoxPlot(
    data = data.frame(
      x = factor(mtcars$cyl),
      y = mtcars$mpg,
      group = factor(mtcars$vs)
    ),
    x = "x",
    y = "y",
    group_by = "group",
    add_point = TRUE
  )

  fig <- plotly::ggplotly(p)
  result <- VizModules:::.hide_jitter_from_legend(fig)

  # Count box and scatter traces
  box_traces <- sum(sapply(result$x$data, function(t) !is.null(t$type) && t$type == "box"))
  scatter_markers <- sum(sapply(result$x$data, function(t) {
    !is.null(t$type) && t$type == "scatter" && !is.null(t$mode) && t$mode == "markers"
  }))

  # Should have box traces
  expect_gt(box_traces, 0)

  # Should have scatter marker traces
  expect_gt(scatter_markers, 0)

  # All scatter markers should be hidden from legend
  for (trace in result$x$data) {
    if (!is.null(trace$type) && trace$type == "scatter" &&
      !is.null(trace$mode) && trace$mode == "markers") {
      expect_false(trace$showlegend,
        info = "All scatter marker traces should have showlegend=FALSE"
      )
    }
  }

  # All box traces should remain visible
  for (trace in result$x$data) {
    if (!is.null(trace$type) && trace$type == "box") {
      expect_true(trace$showlegend,
        info = "All box traces should have showlegend=TRUE"
      )
    }
  }
})
