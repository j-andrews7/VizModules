library(shinytest2)

test_that("{shinytest2} recording: test_areaPlot", {
    local_app_support(test_path("../../inst/apps/test_areaPlot"))
    app <- AppDriver$new(
        test_path("../../inst/apps/test_areaPlot"),
        name = "test_areaPlot",
        seed = 7,
        height = 958,
        width = 1619
    )
    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`mtcars-y.data` = "wt")

    app$set_inputs(`mtcars-auto.update` = TRUE)

    app$set_inputs(`mtcars-download.type` = "svg")
    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`mtcars-AreaPlotTabsetPanel` = "Facet")

    app$set_inputs(`mtcars-AreaPlotTabsetPanel` = "Data")

    app$set_inputs(`mtcars-AreaPlotTabsetPanel` = "Facet")

    app$set_inputs(`mtcars-facet.by` = "gear")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`mtcars-facet.scale` = "free")

    app$set_inputs(`mtcars-split.by` = "gear")

    app$set_inputs(`mtcars-facet.by.row` = FALSE)

    app$set_inputs(`mtcars-design` = "NUL")

    app$set_inputs(`mtcars-design` = "100")

    app$set_inputs(`mtcars-design` = "100\n20")

    app$set_inputs(`mtcars-design` = "100\n200")

    app$wait_for_idle(800)
    app$expect_values()
    app$click("mtcars-reset")

    app$click("mtcars-update")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`mtcars-auto.update` = FALSE)

    app$set_inputs(`mtcars-AreaPlotTabsetPanel` = "Aesthetic")

    app$set_inputs(`mtcars-auto.update` = TRUE)

    app$set_inputs(`mtcars-palette` = "Dark2")

    app$set_inputs(`mtcars-palette.colours` = "#66A61E")

    app$set_inputs(`mtcars-palette.colours` = c("#66A61E", "#7570B3"))

    app$set_inputs(
        `mtcars-palette.colours` = c("#66A61E", "#7570B3", "#D95F02")
    )

    app$set_inputs(`mtcars-theme` = "theme_light")

    app$set_inputs(`mtcars-alpha` = character(0))

    app$set_inputs(`mtcars-alpha` = 0)

    app$set_inputs(`mtcars-alpha` = 0.4)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`mtcars-AreaPlotTabsetPanel` = "Labels")

    app$click("mtcars-reset")

    app$click("mtcars-update")

    app$set_inputs(`mtcars-font.type` = "Droid Sans")

    app$set_inputs(`mtcars-axis.font.size` = 17)

    app$set_inputs(`mtcars-axis.font.size` = 18)

    app$set_inputs(`mtcars-axis.font.size` = 19)

    app$set_inputs(`mtcars-axis.font.size` = 20)

    app$set_inputs(`mtcars-axis.font.size` = 21)

    app$set_inputs(`mtcars-axis.font.size` = 22)

    app$set_inputs(`mtcars-axis.font.size` = 23)

    app$set_inputs(`mtcars-axis.font.size` = 24)

    app$set_inputs(`mtcars-axis.font.size` = 25)

    app$set_inputs(`mtcars-axis.font.size` = 26)

    app$set_inputs(`mtcars-axis.font.size` = 27)

    app$set_inputs(`mtcars-axis.font.size` = 28)

    app$set_inputs(`mtcars-title.font.size` = 29)

    app$set_inputs(`mtcars-title.font.size` = 30)

    app$set_inputs(`mtcars-title.font.size` = 31)

    app$set_inputs(`mtcars-title.font.size` = 32)

    app$set_inputs(`mtcars-title.font.size` = 33)

    app$set_inputs(`mtcars-title.font.size` = 34)

    app$set_inputs(`mtcars-axis.font.size` = 29)

    app$set_inputs(`mtcars-axis.font.size` = 30)

    app$set_inputs(`mtcars-axis.font.size` = 31)

    app$set_inputs(`mtcars-axis.font.size` = 32)

    app$set_inputs(`mtcars-text.colour` = "#E81515")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`mtcars-AreaPlotTabsetPanel` = "Axes")

    app$set_inputs(`mtcars-axis.mirror` = FALSE)

    app$set_inputs(`mtcars-axis.showline` = FALSE)

    app$set_inputs(`mtcars-auto.update` = FALSE)

    app$set_inputs(`mtcars-axis.linecolor` = "#CF2121")

    app$set_inputs(`mtcars-axis.tickfont.color` = "#F52C2C")

    app$set_inputs(`mtcars-axis.tickfont.family` = "Droid Sans")

    app$set_inputs(`mtcars-axis.tickangle.x` = 15)

    app$set_inputs(`mtcars-axis.tickangle.x` = 30)

    app$set_inputs(`mtcars-axis.tickangle.x` = 45)

    app$set_inputs(`mtcars-axis.tickangle.x` = 60)

    app$set_inputs(`mtcars-axis.tickangle.x` = 75)

    app$set_inputs(`mtcars-axis.tickangle.x` = 90)

    app$click("mtcars-update")

    app$set_inputs(`mtcars-axis.tickangle.x` = 105)

    app$set_inputs(`mtcars-axis.tickangle.x` = 120)

    app$set_inputs(`mtcars-axis.tickangle.x` = 135)

    app$click("mtcars-update")

    app$set_inputs(`mtcars-axis.tickangle.y` = -15)

    app$set_inputs(`mtcars-axis.tickangle.y` = 0)

    app$set_inputs(`mtcars-axis.tickangle.y` = 15)

    app$set_inputs(`mtcars-axis.tickangle.y` = 30)

    app$set_inputs(`mtcars-axis.tickangle.y` = 45)

    app$set_inputs(`mtcars-axis.tickangle.y` = 60)

    app$click("mtcars-update")

    app$set_inputs(`mtcars-axis.ticks` = "inside")

    app$click("mtcars-update")

    app$set_inputs(`mtcars-axis.tickcolor` = "#EB3636")

    app$click("mtcars-update")

    app$set_inputs(`mtcars-axis.ticklen` = 6)

    app$set_inputs(`mtcars-axis.ticklen` = 7)

    app$set_inputs(`mtcars-axis.ticklen` = 8)

    app$set_inputs(`mtcars-axis.ticklen` = 9)

    app$set_inputs(`mtcars-axis.ticklen` = 10)

    app$click("mtcars-update")

    app$set_inputs(`mtcars-axis.tickwidth` = 1.1)

    app$set_inputs(`mtcars-axis.tickwidth` = 1.2)

    app$set_inputs(`mtcars-axis.tickwidth` = 1.3)

    app$set_inputs(`mtcars-axis.tickwidth` = 1.4)

    app$set_inputs(`mtcars-axis.tickwidth` = 1.5)

    app$set_inputs(`mtcars-axis.tickwidth` = 3.5)

    app$click("mtcars-update")

    app$set_inputs(`mtcars-axis.tickfont.family` = "Droid Sans Mono")

    app$click("mtcars-update")

    app$click("mtcars-reset")

    app$set_inputs(`mtcars-text.colour` = "#000000")

    app$set_inputs(`mtcars-axis.linecolor` = "#000000")

    app$set_inputs(`mtcars-axis.tickfont.color` = "#000000")

    app$set_inputs(`mtcars-axis.tickcolor` = "#000000")

    app$click("mtcars-update")

    app$wait_for_idle(800)
    app$expect_values()
})
