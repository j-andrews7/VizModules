test_that("piePlot example creates expected pie trace", {
  status_counts <- data.frame(
    status = c("Upregulated", "Downregulated", "Not significant"),
    n = c(12, 7, 3)
  )
  palette <- c("#1B9E77", "#D95F02", "#7570B3")

  fig <- piePlot(
    df = status_counts,
    labels = "status",
    values = "n",
    palette = palette,
    sort = FALSE,
    title.text = "Genes by status"
  )

  expect_s3_class(fig, "plotly")

  built <- plotly::plotly_build(fig)
  trace <- built$x$data[[1]]

  expect_identical(trace$type, "pie")
  expect_equal(as.character(trace$labels), as.character(status_counts$status))
  expect_equal(as.numeric(trace$values), as.numeric(status_counts$n))
  expect_equal(as.character(trace$marker$colors), as.character(palette))
  expect_match(built$x$layout$title$text, "Genes by status")
  expect_true(isTRUE(built$x$layout$showlegend))
})
