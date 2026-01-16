library(shinytest2)

test_that("{shinytest2} recording: test_boxPlot", {
    local_app_support(test_path("../../inst/apps/test_boxPlot"))
    app <- AppDriver$new(
        test_path("../../inst/apps/test_boxPlot"),
        name = "test_boxPlot",
        seed = 7,
        height = 958,
        width = 1619,
        variant = platform_variant()
    )
    app$set_inputs(`box-x.data` = "group1")

    app$click("box-update")

    app$set_inputs(`box-auto.update` = TRUE)

    app$set_inputs(`box-x.data` = "group2")

    app$set_inputs(`box-x.data` = "x")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-group.by` = "group1")

    app$wait_for_idle(800)
    app$expect_values()
    app$click("box-reset")

    app$set_inputs(`box-pt.color` = "#4472C4")

    app$set_inputs(`box-BoxPlotTabsetPanel` = "Adjustments")

    app$set_inputs(`box-sort_x` = "mean_asc")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-flip` = TRUE)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-stack` = TRUE)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-y.max` = 34)

    app$set_inputs(`box-y.max` = 35)

    app$set_inputs(`box-y.max` = 36)

    app$set_inputs(`box-y.max` = 38)

    app$set_inputs(`box-y.max` = 39)

    app$set_inputs(`box-y.max` = 42)

    app$set_inputs(`box-y.max` = 43)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-y.min` = 11)

    app$set_inputs(`box-y.min` = 12)

    app$set_inputs(`box-y.min` = 13)

    app$set_inputs(`box-y.min` = 14)

    app$set_inputs(`box-y.min` = 15)

    app$set_inputs(`box-y.min` = 16)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-aspect.ratio` = 2)

    app$set_inputs(`box-aspect.ratio` = 3)

    app$set_inputs(`box-aspect.ratio` = 4)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-download.type` = "svg")

    app$wait_for_idle(800)
    app$expect_values()
    app$click("box-reset")

    app$click("box-update")

    app$set_inputs(`box-BoxPlotTabsetPanel` = "Points")

    app$set_inputs(`box-add.points` = TRUE)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-pt.size` = 1.1)

    app$set_inputs(`box-pt.size` = 2.1)

    app$set_inputs(`box-pt.size` = 3.1)

    app$set_inputs(`box-pt.size` = 4.1)

    app$set_inputs(`box-pt.size` = 5.1)

    app$set_inputs(`box-pt.size` = 6.1)

    app$set_inputs(`box-pt.size` = 7.1)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-jitter.width` = 1)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-jitter.height` = 1)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-pt.color` = "#0D1E3D")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-BoxPlotTabsetPanel` = "Annotations")

    app$set_inputs(`box-add.line` = 10.4)

    app$set_inputs(`box-add.line` = 11.4)

    app$set_inputs(`box-highlight` = "y = ")

    app$set_inputs(`box-highlight` = "y = 3")

    app$set_inputs(`box-highlight` = "y  3")

    app$set_inputs(`box-highlight` = "y > 3")

    app$set_inputs(`box-highlight.colour` = "#E61717")

    app$set_inputs(`box-highlight.size` = 2)

    app$set_inputs(`box-highlight.size` = 3)

    app$set_inputs(`box-highlight.size` = 4)

    app$set_inputs(`box-highlight.size` = 5)

    app$set_inputs(`box-text.colour` = "#113ADE")

    app$click("box-update")

    app$click("box-reset")

    app$set_inputs(`box-pt.color` = "#4472C4")

    app$set_inputs(`box-highlight.colour` = "#000000")

    app$set_inputs(`box-text.colour` = "#000000")

    app$set_inputs(`box-BoxPlotTabsetPanel` = "Trajectory")

    app$set_inputs(`box-add.trend` = TRUE)

    app$set_inputs(`box-add.trend` = FALSE)

    app$set_inputs(`box-add.trend` = TRUE)

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-trend.pt.size` = 3)

    app$set_inputs(`box-trend.pt.size` = 4)

    app$set_inputs(`box-trend.pt.size` = 5)

    app$set_inputs(`box-trend.pt.size` = 6)

    app$set_inputs(`box-trend.pt.size` = 7)

    app$set_inputs(`box-trend.line.width` = 2)

    app$set_inputs(`box-trend.line.width` = 3)

    app$set_inputs(`box-trend.line.width` = 4)

    app$set_inputs(`box-trend.line.width` = 6)

    app$set_inputs(`box-trend.line.width` = 7)

    app$set_inputs(`box-trend.line.width` = 8)

    app$set_inputs(`box-trend.colour` = "#E82C2C")

    app$wait_for_idle(800)
    app$expect_values()
    app$click("box-reset")

    app$set_inputs(`box-trend.colour` = "#000000")

    app$set_inputs(`box-BoxPlotTabsetPanel` = "Stats")

    app$set_inputs(`box-add.stat` = "median")

    app$set_inputs(`box-stat.color` = "#E81717")

    app$set_inputs(`box-stat.size` = 2)

    app$set_inputs(`box-stat.size` = 3)

    app$set_inputs(`box-stat.size` = 4)

    app$set_inputs(`box-stat.size` = 6)

    app$set_inputs(`box-stat.size` = 7)

    app$set_inputs(`box-stat.stroke` = 2)

    app$set_inputs(`box-stat.stroke` = 4)

    app$set_inputs(`box-stat.stroke` = 6)

    app$set_inputs(`box-stat.shape` = 26)

    app$set_inputs(`box-stat.shape` = 28)

    app$set_inputs(`box-stat.shape` = 29)

    app$wait_for_idle(800)
    app$expect_values()
    app$click("box-reset")

    app$set_inputs(`box-stat.color` = "#000000")

    app$set_inputs(`box-BoxPlotTabsetPanel` = "Palette")

    app$set_inputs(`box-palette` = "Spectral")

    app$set_inputs(`box-background.colour` = TRUE)

    app$set_inputs(`box-background.palette` = "RdYlGn")

    app$click("box-update")

    app$wait_for_idle(800)
    app$expect_values()
    app$set_inputs(`box-BoxPlotTabsetPanel` = "Facet")

    app$set_inputs(`box-facet.by` = "group1")

    app$set_inputs(`box-facet.scale` = "free")

    app$set_inputs(`box-facet.ncol` = 1)

    app$set_inputs(`box-facet.ncol` = 2)

    app$set_inputs(`box-facet.ncol` = 3)

    app$set_inputs(`box-facet.by.row` = FALSE)

    app$set_inputs(`box-combine` = FALSE)

    app$set_inputs(`box-combine` = TRUE)

    app$wait_for_idle(800)
    app$expect_values()
    app$click("box-reset")

    app$set_inputs(`box-BoxPlotTabsetPanel` = "Axes")

    app$set_inputs(`box-axis.linecolor` = "#E61C1C")

    app$set_inputs(`box-auto.update` = FALSE)

    app$set_inputs(`box-auto.update` = TRUE)

    app$set_inputs(`box-axis.linewidth` = 0.6)

    app$set_inputs(`box-axis.linewidth` = 0.7)

    app$set_inputs(`box-axis.linewidth` = 0.8)

    app$set_inputs(`box-axis.linewidth` = 0.9)

    app$set_inputs(`box-axis.linewidth` = 1)

    app$set_inputs(`box-axis.linewidth` = 1.1)

    app$set_inputs(`box-axis.linewidth` = 1.2)

    app$set_inputs(`box-axis.linewidth` = 1.3)

    app$set_inputs(`box-axis.linewidth` = 1.4)

    app$set_inputs(`box-axis.linewidth` = 1.5)

    app$set_inputs(`box-axis.linewidth` = 1.6)

    app$set_inputs(`box-axis.tickfont.size` = 13)

    app$set_inputs(`box-axis.tickfont.size` = 14)

    app$set_inputs(`box-axis.tickfont.size` = 15)

    app$set_inputs(`box-axis.tickfont.size` = 16)

    app$set_inputs(`box-axis.tickfont.size` = 17)

    app$set_inputs(`box-axis.tickfont.size` = 18)

    app$set_inputs(`box-axis.tickfont.size` = 19)

    app$set_inputs(`box-axis.tickfont.color` = "#A62828")

    app$set_inputs(`box-axis.ticks` = "inside")

    app$click("box-update")

    app$set_inputs(`box-auto.update` = FALSE)

    app$set_inputs(`box-auto.update` = TRUE)

    app$set_inputs(`box-auto.update` = FALSE)

    app$set_inputs(`box-axis.tickwidth` = 1.1)

    app$set_inputs(`box-axis.tickwidth` = 1.2)

    app$set_inputs(`box-axis.tickwidth` = 1.3)

    app$set_inputs(`box-axis.tickwidth` = 1.4)

    app$set_inputs(`box-axis.tickwidth` = 1.5)

    app$set_inputs(`box-axis.tickwidth` = 1.6)

    app$set_inputs(`box-axis.tickwidth` = 1.7)

    app$set_inputs(`box-auto.update` = TRUE)

    app$set_inputs(`box-auto.update` = FALSE)

    app$wait_for_idle(800)
    app$expect_values()
})
