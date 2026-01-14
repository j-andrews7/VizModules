library(testthat)
library(devtools)
library(plotthis)
devtools::load_all()

test_that("linePlot creates expected line trace", {
  palette <- plotthis::palette_list[["Set2"]]

  fig <- linePlot(
    reactive.data = mtcars,
    x = "cyl",
    y = "mpg",
    plot.mode = "lines+markers",
    line.type = "solid",
    colour.group.by = "gear",
    palette.selection = "Set2", 
    show.legend = TRUE,
    facet.by = NULL,
    facet.scales = "fixed",
    axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, axis.tickfont.size = 12,
    axis.tickfont.color = "black", axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
    axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, title.text = "", title.font.size = 14, title.font.family = "Arial",
    title.text.color = "black", y.title = NULL, x.title = NULL, flip.x = FALSE, flip.y = FALSE,
    x.adjustment = NULL, y.adjustment = NULL, color.adjustment = NULL, order.by = NULL
  )

  expect_s3_class(fig, "plotly")

  built <- plotly::plotly_build(fig)
  trace <- built$x$data[[1]]
  
  expect_identical(trace$type, "scatter")
  expect_true(trace$name %in% names(mtcars))
})

test_that("Test Incorrect Inputs", {
  fig <- linePlot(
    reactive.data = mtcars,
    x = "-random_column",
    y = "mpg",
    plot.mode = "lines+markers",
    line.type = "solid",
    colour.group.by = "gear",
    palette.selection = "Set2", 
    show.legend = TRUE)
  
  expect_error(print(fig))
})

test_that("linePlot returns plotly object", {
  fig <- linePlot(
    reactive.data = mtcars,
    x = "wt",
    y = "mpg",
    plot.mode = "lines",
    line.type = "solid",
    colour.group.by = NULL,
    palette.selection = "Set2",
    show.legend = TRUE
  )
  
  expect_s3_class(fig, "plotly")
})

test_that("linePlot handles different plot modes", {
  # Lines only
  fig_lines <- linePlot(
    reactive.data = mtcars,
    x = "wt",
    y = "mpg",
    plot.mode = "lines",
    line.type = "solid",
    colour.group.by = NULL,
    palette.selection = "Set2",
    show.legend = FALSE
  )
  expect_s3_class(fig_lines, "plotly")
  
  # Markers only
  fig_markers <- linePlot(
    reactive.data = mtcars,
    x = "wt",
    y = "mpg",
    plot.mode = "markers",
    line.type = "solid",
    colour.group.by = NULL,
    palette.selection = "Set2",
    show.legend = FALSE
  )
  expect_s3_class(fig_markers, "plotly")
})

test_that("linePlot handles different line types", {
  fig_dash <- linePlot(
    reactive.data = mtcars,
    x = "wt",
    y = "mpg",
    plot.mode = "lines",
    line.type = "dash",
    colour.group.by = NULL,
    palette.selection = "Set2",
    show.legend = FALSE
  )
  
  expect_s3_class(fig_dash, "plotly")
  built <- plotly::plotly_build(fig_dash)
  expect_equal(built$x$data[[1]]$line$dash, "dash")
})

test_that("linePlot handles legend visibility", {
  fig_no_legend <- linePlot(
    reactive.data = mtcars,
    x = "wt",
    y = "mpg",
    plot.mode = "lines",
    line.type = "solid",
    colour.group.by = "gear",
    palette.selection = "Set2",
    show.legend = FALSE
  )
  
  expect_s3_class(fig_no_legend, "plotly")
})

test_that("linePlot handles custom titles", {
  fig <- linePlot(
    reactive.data = mtcars,
    x = "wt",
    y = "mpg",
    plot.mode = "lines",
    line.type = "solid",
    colour.group.by = NULL,
    palette.selection = "Set2",
    show.legend = FALSE,
    title.text = "My Custom Title",
    x.title = "Weight (1000 lbs)",
    y.title = "Miles Per Gallon"
  )
  
  expect_s3_class(fig, "plotly")
  built <- plotly::plotly_build(fig)
  expect_equal(built$x$layout$title$text, "My Custom Title")
})

test_that("linePlot handles axis flipping", {
  fig <- linePlot(
    reactive.data = mtcars,
    x = "wt",
    y = "mpg",
    plot.mode = "lines",
    line.type = "solid",
    colour.group.by = NULL,
    palette.selection = "Set2",
    show.legend = FALSE,
    flip.x = TRUE,
    flip.y = TRUE
  )
  
  expect_s3_class(fig, "plotly")
  built <- plotly::plotly_build(fig)
  expect_equal(built$x$layout$xaxis$autorange, "reversed")
  expect_equal(built$x$layout$yaxis$autorange, "reversed")
})

test_that("linePlot handles faceting", {
  fig <- linePlot(
    reactive.data = mtcars,
    x = "wt",
    y = "mpg",
    plot.mode = "lines",
    line.type = "solid",
    colour.group.by = NULL,
    palette.selection = "Set2",
    show.legend = FALSE,
    facet.by = "cyl"
  )
  
  expect_s3_class(fig, "plotly")
})

test_that("linePlot errors with NULL data", {
  expect_error(
    linePlot(
      reactive.data = NULL,
      x = "wt",
      y = "mpg",
      plot.mode = "lines",
      line.type = "solid",
      colour.group.by = NULL,
      palette.selection = "Set2",
      show.legend = FALSE
    )
  )
})

test_that("linePlot errors with invalid y column", {
  fig <- linePlot(
    reactive.data = mtcars,
    x = "wt",
    y = "fake_column",
    plot.mode = "lines",
    line.type = "solid",
    colour.group.by = NULL,
    palette.selection = "Set2",
    show.legend = FALSE
  )
  
  expect_error(print(fig))
})

test_that("linePlot handles different datasets", {
  fig <- linePlot(
    reactive.data = iris,
    x = "Sepal.Length",
    y = "Sepal.Width",
    plot.mode = "lines",
    line.type = "solid",
    colour.group.by = "Species",
    palette.selection = "Set1",
    show.legend = TRUE
  )
  
  expect_s3_class(fig, "plotly")
})







