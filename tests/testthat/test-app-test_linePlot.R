library(shinytest2)

test_that("{shinytest2} recording: test_linePlot", {
    local_app_support(test_path("../../inst/apps/test_linePlot"))
    app <- AppDriver$new(test_path("../../inst/apps/test_linePlot"),
        name = "test_linePlot",
        seed = 7, height = 911, width = 1619
    )
    app$set_inputs(`iris-linePlot__shinyjquiBookmarkState__resizable` = c(
        1039.33,
        400
    ), allow_no_input_binding_ = TRUE)
    app$set_inputs(`iris-linePlot_size` = c(1039.33, 400), allow_no_input_binding_ = TRUE)
    app$set_inputs(`iris-linePlot_is_resizing` = FALSE, allow_no_input_binding_ = TRUE)
    app$set_inputs(`mtcars-linePlot__shinyjquiBookmarkState__resizable` = c(
        1039.33,
        400
    ), allow_no_input_binding_ = TRUE)
    app$set_inputs(`mtcars-linePlot_size` = c(1039.33, 400), allow_no_input_binding_ = TRUE)
    app$set_inputs(`mtcars-linePlot_is_resizing` = FALSE, allow_no_input_binding_ = TRUE)
    app$expect_values()
    app$set_inputs(`mtcars-x.value` = c("mpg", "disp"))
    app$set_inputs(`mtcars-line.type` = "dash")
    app$set_inputs(`mtcars-plot.type` = "markers")
    app$set_inputs(`mtcars-palette` = "SunsetDark")
    app$click("mtcars-update")
    app$expect_values()
    app$set_inputs(`mtcars-plot.type` = "lines+markers")
    app$click("mtcars-update")
    app$expect_values()
    app$set_inputs(`mtcars-flip.x` = TRUE)
    app$set_inputs(`mtcars-flip.y` = TRUE)
    app$click("mtcars-update")
    app$expect_values()
    app$set_inputs(`mtcars-x.adjustment` = "log2")
    app$click("mtcars-update")
    app$expect_values()
    app$set_inputs(`mtcars-order.by` = TRUE)
    app$click("mtcars-update")
    app$expect_values()
    app$set_inputs(`mtcars-facet.by` = "gear")
    app$expect_values()
    app$set_inputs(
        `plotly_hover-A` = "[{\"curveNumber\":1,\"pointNumber\":7,\"x\":4.419538891513785,\"y\":4}]",
        allow_no_input_binding_ = TRUE, priority_ = "event"
    )
    app$set_inputs(
        `plotly_hover-A` = character(0), allow_no_input_binding_ = TRUE,
        priority_ = "event"
    )
    app$set_inputs(`mtcars-facet.scales` = "free")
    app$click("mtcars-update")
    app$expect_values()
    app$set_inputs(`mtcars-linePlotTabsetPanel` = "Axes")
    app$set_inputs(
        `plotly_afterplot-A` = "\"mtcars-linePlot\"", allow_no_input_binding_ = TRUE,
        priority_ = "event"
    )
    app$set_inputs(
        `plotly_afterplot-A` = "\"iris-linePlot\"", allow_no_input_binding_ = TRUE,
        priority_ = "event"
    )
    app$set_inputs(
        `plotly_relayout-A` = "{\"width\":1039.328125,\"height\":400}",
        allow_no_input_binding_ = TRUE, priority_ = "event"
    )
    app$set_inputs(
        `plotly_relayout-A` = "{\"width\":1039.328125,\"height\":400}",
        allow_no_input_binding_ = TRUE, priority_ = "event"
    )
    app$set_inputs(`mtcars-axis.showline` = FALSE)
    app$set_inputs(`mtcars-axis.mirror` = FALSE)
    app$click("mtcars-update")
    app$expect_values()
    app$set_inputs(`mtcars-axis.mirror` = TRUE)
    app$set_inputs(`mtcars-axis.showline` = TRUE)
    app$set_inputs(`mtcars-axis.linecolor` = "#F01111")
    app$set_inputs(`mtcars-axis.linewidth` = 2)
    app$set_inputs(`mtcars-axis.tickfont.size` = 18)
    app$set_inputs(`mtcars-axis.tickfont.family` = "Droid Sans")
    app$set_inputs(`mtcars-axis.tickfont.color` = "#D200F7")
    app$set_inputs(`mtcars-axis.tickangle.y` = 15)
    app$set_inputs(`mtcars-axis.tickangle.y` = 30)
    app$set_inputs(`mtcars-axis.tickangle.y` = 45)
    app$set_inputs(`mtcars-axis.ticks` = "inside")
    app$set_inputs(`mtcars-axis.tickangle.x` = -15)
    app$set_inputs(`mtcars-axis.tickangle.x` = -30)
    app$set_inputs(`mtcars-axis.tickangle.x` = -45)
    app$set_inputs(`mtcars-axis.ticklen` = 6)
    app$set_inputs(`mtcars-axis.ticklen` = 7)
    app$set_inputs(`mtcars-axis.ticklen` = 8)
    app$set_inputs(`mtcars-axis.ticklen` = 9)
    app$set_inputs(`mtcars-axis.ticklen` = 10)
    app$set_inputs(`mtcars-axis.ticklen` = 11)
    app$set_inputs(`mtcars-axis.ticklen` = 12)
    app$set_inputs(`mtcars-axis.ticklen` = 13)
    app$set_inputs(`mtcars-axis.ticklen` = 14)
    app$set_inputs(`mtcars-axis.tickcolor` = "#0D00FF")
    app$set_inputs(`mtcars-axis.tickwidth` = 3.5)
    app$click("mtcars-update")
    app$set_inputs(
        `plotly_hover-A` = "[{\"curveNumber\":4,\"pointNumber\":0,\"x\":4.426264754702098,\"y\":4}]",
        allow_no_input_binding_ = TRUE, priority_ = "event"
    )
    app$set_inputs(
        `plotly_hover-A` = character(0), allow_no_input_binding_ = TRUE,
        priority_ = "event"
    )
    app$expect_values()
})
