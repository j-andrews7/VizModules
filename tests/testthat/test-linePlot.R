library(testthat)
library(devtools)
library(plotthis)
devtools::load_all()
test_that("linePlot creates expected line trace", {
  palette <<- plotthis::palette_list[["Set2"]]

  fig <<- linePlot(
    reactive.data = mtcars,
    x = "cyl",
    y = "mpg",
    plot.mode = "lines+markers",
    line.type = "solid",
    colour.group.by = plotthis::palette_list[["Set2"]][1],
    palette = palette,
    show.legend = TRUE,
                    #Defaults
                    facet.by = NULL,
                     facet.scales = "fixed",
                     axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, axis.tickfont.size = 12,
                     axis.tickfont.color = "black", axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
                     axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, title.text = "", title.font.size = 14, title.font.family = "Arial",
                     title.text.color = "black", y.title = NULL, x.title = NULL, flip.x = FALSE, flip.y = FALSE,
                     x.adjustment = NULL, y.adjustment = NULL, color.adjustment = NULL, order.by = NULL
    )
  

  expect_s3_class(fig, "plotly")

  built <<- plotly::plotly_build(fig)
  trace <<- built$x$data[[1]]
  
  #General tests of data: 
  expect_identical(trace$type, "scatter")
  expect_equal(sort(trace$x), sort(mtcars$cyl))
  expect_equal(sort(trace$y), sort(mtcars$mpg))
  expect_true(trace$name %in% palette)
})
