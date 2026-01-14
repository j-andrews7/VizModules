library(shinytest2)


test_that("{shinytest2} recording: test_linePlot_init", {
  local_app_support(test_path("../../inst/apps/test_linePlot"))
  app <- AppDriver$new(test_path("../../inst/apps/test_linePlot"), variant = platform_variant(), 
      name = "test_linePlot_init", seed = 7, height = 911, width = 1619)
  app$set_inputs(`iris-linePlot__shinyjquiBookmarkState__resizable` = c(1039.33, 
      400), allow_no_input_binding_ = TRUE)
  app$set_inputs(`iris-linePlot_size` = c(1039.33, 400), allow_no_input_binding_ = TRUE)
  app$set_inputs(`iris-linePlot_is_resizing` = FALSE, allow_no_input_binding_ = TRUE)
  app$set_inputs(`mtcars-linePlot__shinyjquiBookmarkState__resizable` = c(1039.33, 
      400), allow_no_input_binding_ = TRUE)
  app$set_inputs(`mtcars-linePlot_size` = c(1039.33, 400), allow_no_input_binding_ = TRUE)
  app$set_inputs(`mtcars-linePlot_is_resizing` = FALSE, allow_no_input_binding_ = TRUE)
  app$expect_values()
  app$expect_screenshot()
})


test_that("{shinytest2} recording: test_linePlot_Data", {
  local_app_support(test_path("../../inst/apps/test_linePlot"))
  app <- AppDriver$new(test_path("../../inst/apps/test_linePlot"), variant = platform_variant(), 
      name = "test_linePlot_Data", seed = 7, height = 911, width = 1619)
  app$set_inputs(`iris-linePlot__shinyjquiBookmarkState__resizable` = c(1039.33, 
      400), allow_no_input_binding_ = TRUE)
  app$set_inputs(`iris-linePlot_size` = c(1039.33, 400), allow_no_input_binding_ = TRUE)
  app$set_inputs(`iris-linePlot_is_resizing` = FALSE, allow_no_input_binding_ = TRUE)
  app$set_inputs(`mtcars-linePlot__shinyjquiBookmarkState__resizable` = c(1039.33, 
      400), allow_no_input_binding_ = TRUE)
  app$set_inputs(`mtcars-linePlot_size` = c(1039.33, 400), allow_no_input_binding_ = TRUE)
  app$set_inputs(`mtcars-linePlot_is_resizing` = FALSE, allow_no_input_binding_ = TRUE)
  app$set_inputs(`mtcars-x.value` = c("mpg", "hp"))
  app$click("mtcars-update")
  app$set_inputs(`mtcars-plot.type` = "markers")
  app$expect_values()
  app$expect_screenshot()
  app$click("mtcars-update")
  app$expect_values()
  app$expect_screenshot()
  app$set_inputs(`mtcars-plot.type` = "lines+markers")
  app$click("mtcars-update")
  app$expect_values()
  app$expect_screenshot()
  app$set_inputs(`mtcars-line.type` = "dash")
  app$set_inputs(`mtcars-palette` = "simpsons")
  app$set_inputs(`mtcars-flip.x` = TRUE)
  app$set_inputs(`mtcars-flip.y` = TRUE)
  app$click("mtcars-update")
  app$expect_values()
  app$expect_screenshot()
  app$set_inputs(`mtcars-facet.by` = "gear")
  app$expect_values()
  app$expect_screenshot()
  app$set_inputs(`mtcars-x.adjustment` = "log2")
  app$click("mtcars-update")
  app$expect_values()
  app$expect_screenshot()
  app$set_inputs(`mtcars-order.by` = TRUE)
  app$click("mtcars-update")
  app$expect_values()
  app$expect_screenshot()
})
