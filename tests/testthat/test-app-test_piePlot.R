library(shinytest2)

test_that("{shinytest2} recording: test_piePlot", {
	local_app_support(test_path("../../inst/apps/test_piePlot"))
	app <- AppDriver$new(
		test_path("../../inst/apps/test_piePlot"),
		name = "test_piePlot",
		seed = 7,
		height = 958,
		width = 1619
	)
	app$set_inputs(`mtcars-hole` = 0.28)
	app$click("mtcars-update")

	app$set_inputs(`mtcars-hole` = 0)
	app$click("mtcars-update")

	app$set_inputs(`mtcars-rotation` = 175)
	app$click("mtcars-update")

	app$set_inputs(`mtcars-rotation` = 0)
	app$click("mtcars-update")

	app$set_inputs(`mtcars-sort.slices` = FALSE)
	app$click("mtcars-update")

	app$wait_for_idle(800)
	app$expect_values()
	app$set_inputs(`mtcars-direction` = "clockwise")
	app$click("mtcars-update")

	app$wait_for_idle(800)
	app$expect_values()
	app$set_inputs(`mtcars-auto.update` = TRUE)
	app$set_inputs(`mtcars-rotation` = 15)

	app$set_inputs(`mtcars-rotation` = 125)

	app$set_inputs(`mtcars-rotation` = 0)

	app$wait_for_idle(800)
	app$expect_values()
	app$set_inputs(`mtcars-auto.update` = FALSE)
	app$set_inputs(`mtcars-piePlotTabsetPanel` = "Colors")
	app$set_inputs(
		`mtcars-slice.colors` = c(
			"4",
			"#e69f00",
			"6",
			"#56b4e9",
			"8",
			"#009e73"
		)
	)
	app$set_inputs(`mtcars-slice.colors-palette` = "dittoColors")
	app$set_inputs(`mtcars-slice.line.color` = "#F52020")
	app$set_inputs(`mtcars-auto.update` = TRUE)
	app$set_inputs(`mtcars-slice.colors-palette` = "inferno")

	app$set_inputs(`mtcars-slice.colors-palette` = "Paired")

	app$set_inputs(
		`mtcars-slice.colors` = c(
			"4",
			"#ffff99",
			"6",
			"#56b4e9",
			"8",
			"#009e73"
		)
	)

	app$set_inputs(
		`mtcars-slice.colors` = c(
			"4",
			"#ffff99",
			"6",
			"#33a02c",
			"8",
			"#009e73"
		)
	)

	app$set_inputs(
		`mtcars-slice.colors` = c(
			"4",
			"#ffff99",
			"6",
			"#33a02c",
			"8",
			"#ff7f00"
		)
	)

	app$set_inputs(`mtcars-slice.line.width` = 0.5)

	app$set_inputs(`mtcars-slice.line.width` = 1)

	app$set_inputs(`mtcars-slice.line.width` = 1.5)

	app$set_inputs(`mtcars-slice.line.width` = 2)

	app$set_inputs(`mtcars-slice.line.width` = 2.5)

	app$set_inputs(`mtcars-slice.line.width` = 3)

	app$set_inputs(`mtcars-slice.line.width` = 3.5)

	app$click("mtcars-reset")

	app$set_inputs(`mtcars-slice.line.color` = "#FFFFFF")

	app$wait_for_idle(800)
	app$expect_values()
	app$set_inputs(`mtcars-piePlotTabsetPanel` = "Labels & Text")
	app$set_inputs(`mtcars-auto.update` = FALSE)
	app$set_inputs(`mtcars-textinfo` = c("label", "percent", "value"))
	app$set_inputs(`mtcars-textposition` = "inside")
	app$set_inputs(`mtcars-auto.update` = TRUE)
	app$set_inputs(`mtcars-textposition` = "outside")

	app$set_inputs(`mtcars-textposition` = "none")

	app$set_inputs(`mtcars-textposition` = "auto")

	app$set_inputs(`mtcars-insidetextorientation` = "tangential")

	app$set_inputs(`mtcars-text.font.size` = 13)

	app$set_inputs(`mtcars-text.font.size` = 14)

	app$set_inputs(`mtcars-text.font.size` = 15)

	app$set_inputs(`mtcars-text.font.size` = 16)

	app$set_inputs(`mtcars-text.font.size` = 17)

	app$set_inputs(`mtcars-text.font.size` = 18)

	app$set_inputs(`mtcars-text.font.family` = "Droid Sans")

	app$set_inputs(`mtcars-text.font.color` = "#F50505")

	app$wait_for_idle(800)
	app$expect_values()
	app$set_inputs(`mtcars-download.type` = "svg")

	app$wait_for_idle(800)
	app$expect_values()
	app$click("mtcars-reset")

	app$set_inputs(`mtcars-text.font.color` = "#000000")
	app$set_inputs(`mtcars-auto.update` = FALSE)
	app$set_inputs(`mtcars-piePlotTabsetPanel` = "Title & Legend")
	app$set_inputs(`mtcars-title.x` = 0.78)
	app$set_inputs(`mtcars-auto.update` = TRUE)
	app$set_inputs(`mtcars-title.x` = 0.87)

	app$set_inputs(`mtcars-title.x` = 0.26)

	app$set_inputs(`mtcars-auto.update` = FALSE)
	app$set_inputs(`mtcars-auto.update` = TRUE)
	app$set_inputs(`mtcars-title.x` = 0.77)

	app$click("mtcars-reset")

	app$set_inputs(`mtcars-title.x` = 0)

	app$set_inputs(`mtcars-title.x` = 0.17)

	app$set_inputs(`mtcars-title.x` = 0.42)

	app$set_inputs(`mtcars-title.x` = 0.62)

	app$click("mtcars-update")

	app$wait_for_idle(800)
	app$expect_values()
	app$click("mtcars-reset")

	app$click("mtcars-update")

	app$set_inputs(`mtcars-title.font.size` = 29)

	app$set_inputs(`mtcars-title.font.size` = 30)

	app$set_inputs(`mtcars-title.font.size` = 31)

	app$set_inputs(`mtcars-title.font.size` = 32)

	app$set_inputs(`mtcars-title.font.size` = 33)

	app$set_inputs(`mtcars-title.font.size` = 34)

	app$set_inputs(`mtcars-title.font.size` = 35)

	app$set_inputs(`mtcars-title.font.size` = 36)

	app$wait_for_idle(800)
	app$expect_values()
	app$set_inputs(`mtcars-title.font.family` = "Droid Sans")

	app$wait_for_idle(800)
	app$expect_values()
	app$set_inputs(`mtcars-title.font.color` = "#E81717")

	app$set_inputs(`mtcars-legend.font.family` = "Droid Sans")

	app$set_inputs(`mtcars-legend.font.family` = "Gravitas One")

	app$set_inputs(`mtcars-legend.font.color` = "#C91414")

	app$set_inputs(`mtcars-legend.font.size` = 13)

	app$set_inputs(`mtcars-legend.font.size` = 14)

	app$set_inputs(`mtcars-legend.font.size` = 15)

	app$set_inputs(`mtcars-legend.font.size` = 16)

	app$set_inputs(`mtcars-legend.font.size` = 17)

	app$set_inputs(`mtcars-legend.font.size` = 18)

	app$set_inputs(`mtcars-legend.font.size` = 19)

	app$set_inputs(`mtcars-legend.font.size` = 20)

	app$set_inputs(`mtcars-legend.font.size` = 21)

	app$set_inputs(`mtcars-legend.font.size` = 22)

	app$set_inputs(`mtcars-legend.font.size` = 23)

	app$set_inputs(`mtcars-legend.orientation` = "v")

	app$set_inputs(`mtcars-legend.font.size` = 22)

	app$set_inputs(`mtcars-legend.font.size` = 21)

	app$set_inputs(`mtcars-legend.font.size` = 20)

	app$set_inputs(`mtcars-legend.font.size` = 19)

	app$set_inputs(`mtcars-legend.font.size` = 18)

	app$set_inputs(`mtcars-legend.font.size` = 1)

	app$set_inputs(`mtcars-legend.font.size` = 2)

	app$set_inputs(`mtcars-legend.font.size` = 3)

	app$set_inputs(`mtcars-legend.font.size` = 4)

	app$set_inputs(`mtcars-legend.font.size` = 5)

	app$set_inputs(`mtcars-legend.font.size` = 13)

	app$set_inputs(`mtcars-legend.font.size` = 14)

	app$wait_for_idle(800)
	app$expect_values()
	app$click("mtcars-reset")

	app$set_inputs(`mtcars-title.font.color` = "#000000")

	app$set_inputs(`mtcars-legend.font.color` = "#000000")

	app$wait_for_idle(800)
	app$expect_values()
})
