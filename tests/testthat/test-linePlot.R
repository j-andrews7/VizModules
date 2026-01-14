library(testthat)
library(devtools)
devtools::load_all()
# tests/testthat/test-linePlot.R

test_that("linePlot returns a plotly object with minimal required args", {
  plt <- linePlot(
    reactive.data = mtcars,
    x = "mpg",
    y = "hp",
    plot.mode = "lines",
    line.type = "solid",
    colour.group.by = NULL,
    palette.selection = "Set1",
    show.legend = TRUE
  )
  expect_s3_class(plt, "plotly")
})

test_that("linePlot works with grouping", {
  plt <- linePlot(
    reactive.data = mtcars,
    x = "mpg",
    y = "hp",
    plot.mode = "lines+markers",
    line.type = "dash",
    colour.group.by = "cyl",
    palette.selection = c("red", "blue", "green"),
    show.legend = TRUE
  )
  expect_s3_class(plt, "plotly")
})

test_that("linePlot errors with missing columns", {
  expect_error(
    linePlot(
      reactive.data = mtcars,
      x = "not_a_col",
      y = "hp",
      plot.mode = "lines",
      line.type = "solid",
      colour.group.by = NULL,
      palette.selection = "Set1",
      show.legend = TRUE
    )
  )
})

test_that("linePlot errors with non-data.frame input", {
  expect_error(
    linePlot(
      reactive.data = 1:10,
      x = "mpg",
      y = "hp",
      plot.mode = "lines",
      line.type = "solid",
      colour.group.by = NULL,
      palette.selection = "Set1",
      show.legend = TRUE
    )
  )
})