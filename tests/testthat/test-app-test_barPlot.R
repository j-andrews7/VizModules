library(shinytest2)

test_that("{shinytest2} recording: test_barPlot", {
    local_app_support(test_path("../../inst/apps/test_barPlot"))
    app <- AppDriver$new(
        test_path("../../inst/apps/test_barPlot"),
        name = "test_barPlot",
        seed = 7,
        height = 958,
        width = 1619,
        variant = platform_variant()
    )
    app$set_inputs(`mtcars-y.data` = "hp")

    app$click("mtcars-update")

    app$set_inputs(`mtcars-auto.update` = TRUE)

    app$set_inputs(`mtcars-y.data` = "qsec")

    app$set_inputs(`mtcars-flip` = TRUE)

    app$set_inputs(`mtcars-flip` = FALSE)

    app$set_inputs(`mtcars-y.max` = 28)

    app$set_inputs(`mtcars-y.max` = 29)

    app$set_inputs(`mtcars-y.max` = 31)

    app$set_inputs(`mtcars-y.max` = 32)

    app$set_inputs(`mtcars-y.max` = 34)

    app$set_inputs(`mtcars-y.max` = 35)

    app$set_inputs(`mtcars-y.max` = 36)

    app$set_inputs(`mtcars-y.max` = 37)

    app$set_inputs(`mtcars-y.min` = 15)

    app$set_inputs(`mtcars-y.min` = 17)

    app$set_inputs(`mtcars-y.min` = 18)

    app$set_inputs(`mtcars-y.min` = 19)

    app$set_inputs(`mtcars-y.min` = 20)

    app$set_inputs(`mtcars-y.min` = 21)

    app$wait_for_idle(800)
    app$expect_values()
    app$click("mtcars-reset")

    app$set_inputs(`mtcars-auto.update` = FALSE)

    app$set_inputs(`mtcars-download.type` = "svg")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`mtcars-auto.update` = TRUE)

    app$set_inputs(`mtcars-BarPlotTabsetPanel` = "Grouping")

    app$set_inputs(`mtcars-BarPlotTabsetPanel` = "Data")

    app$set_inputs(`mtcars-BarPlotTabsetPanel` = "Grouping")

    app$set_inputs(`mtcars-group.by` = "vs")

    app$set_inputs(`mtcars-group.by` = "gear")

    app$set_inputs(`mtcars-facet.by` = "vs")

    app$set_inputs(`mtcars-facet.scale` = "free")

    app$set_inputs(`mtcars-facet.by.row` = FALSE)

    app$set_inputs(`mtcars-split.by` = "vs")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`mtcars-BarPlotTabsetPanel` = "Aesthetic")

    app$click("mtcars-reset")

    app$set_inputs(`mtcars-palette` = "Pastel1")

    app$set_inputs(`mtcars-palette.colours` = "#B3CDE3")

    app$set_inputs(`mtcars-palette.colours` = c("#B3CDE3", "#E5D8BD"))

    app$set_inputs(
        `mtcars-palette.colours` = c("#B3CDE3", "#E5D8BD", "#DECBE4")
    )

    app$set_inputs(`mtcars-background.colour` = TRUE)

    app$set_inputs(`mtcars-background.palette` = "Paired")

    app$set_inputs(`mtcars-background.alpha` = 1)

    app$set_inputs(`mtcars-theme` = "theme_minimal")

    app$set_inputs(`mtcars-alpha` = 0.4)

    app$set_inputs(`mtcars-width` = 1)

    app$set_inputs(`mtcars-width` = 2)

    app$set_inputs(`mtcars-width` = 3)

    app$set_inputs(`mtcars-expand` = "1,")

    app$set_inputs(`mtcars-expand` = "1,2")

    app$set_inputs(`mtcars-expand` = "1,2,4")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`mtcars-BarPlotTabsetPanel` = "Line")

    app$click("mtcars-reset")

    app$set_inputs(`mtcars-add.line` = 20)

    app$set_inputs(`mtcars-line.colour` = "#F51313")

    app$set_inputs(`mtcars-line.type` = 2)

    app$set_inputs(`mtcars-line.type` = 3)

    app$set_inputs(`mtcars-line.type` = 4)

    app$set_inputs(`mtcars-line.width` = 1)

    app$set_inputs(`mtcars-line.width` = 2)

    app$set_inputs(`mtcars-line.width` = 3)

    app$set_inputs(`mtcars-line.width` = 4)

    app$set_inputs(`mtcars-line.width` = 5)

    app$set_inputs(`mtcars-line.name` = "Hello")

    app$wait_for_idle(800)
    app$expect_values()
    app$click("mtcars-reset")

    app$set_inputs(`mtcars-line.colour` = "#000000")

    app$set_inputs(`mtcars-BarPlotTabsetPanel` = "Labels")

    app$set_inputs(`mtcars-font.type` = "Courier New")

    app$set_inputs(`mtcars-axis.font.size` = 19)

    app$set_inputs(`mtcars-axis.font.size` = 20)

    app$set_inputs(`mtcars-axis.font.size` = 21)

    app$set_inputs(`mtcars-axis.font.size` = 22)

    app$set_inputs(`mtcars-axis.font.size` = 23)

    app$set_inputs(`mtcars-axis.font.size` = 24)

    app$set_inputs(`mtcars-axis.font.size` = 25)

    app$set_inputs(`mtcars-title.font.size` = 29)

    app$set_inputs(`mtcars-title.font.size` = 31)

    app$set_inputs(`mtcars-title.font.size` = 32)

    app$set_inputs(`mtcars-title.font.size` = 33)

    app$set_inputs(`mtcars-title.font.size` = 34)

    app$set_inputs(`mtcars-text.colour` = "#E63333")

    app$set_inputs(`mtcars-download.type` = "svg")

    app$set_inputs(`mtcars-BarPlotTabsetPanel` = "Axes")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`mtcars-axis.linecolor` = "#D10F0F")

    app$set_inputs(`mtcars-auto.update` = FALSE)

    app$set_inputs(`mtcars-auto.update` = TRUE)

    app$set_inputs(`mtcars-axis.tickfont.color` = "#BD2C2C")

    app$set_inputs(`mtcars-axis.tickcolor` = "#D11717")

    app$set_inputs(`mtcars-axis.ticklen` = 6)

    app$set_inputs(`mtcars-axis.ticklen` = 7)

    app$set_inputs(`mtcars-axis.ticklen` = 8)

    app$set_inputs(`mtcars-axis.ticklen` = 9)

    app$set_inputs(`mtcars-axis.ticks` = "inside")

    app$set_inputs(`mtcars-axis.tickangle.y` = 15)

    app$set_inputs(`mtcars-axis.tickangle.y` = 30)

    app$set_inputs(`mtcars-axis.tickangle.y` = 45)

    app$set_inputs(`mtcars-axis.tickfont.family` = "Courier New")

    app$set_inputs(`mtcars-axis.tickangle.x` = 15)

    app$set_inputs(`mtcars-axis.tickangle.x` = 30)

    app$set_inputs(`mtcars-axis.tickangle.x` = 45)

    app$set_inputs(`mtcars-axis.tickangle.x` = 60)

    app$set_inputs(`mtcars-axis.tickfont.size` = 13)

    app$set_inputs(`mtcars-axis.tickfont.size` = 14)

    app$set_inputs(`mtcars-axis.tickfont.size` = 15)

    app$set_inputs(`mtcars-axis.tickfont.size` = 16)

    app$set_inputs(`mtcars-auto.update` = FALSE)

    app$wait_for_idle(800)
    app$expect_values()
})
