test_that("dumbbellPlot creates expected trace structure", {
    df <- data.frame(
        School = c("MIT", "Stanford", "Harvard"),
        Women = c(94, 96, 112),
        Men = c(152, 151, 165)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue")
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_true(length(built$x$data) >= 2)
})

test_that("dumbbellPlot handles colour.by parameter", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )

    fig_x <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        colour.by = "X variables", palette.selection = c("pink", "blue")
    )
    expect_s3_class(fig_x, "plotly")

    fig_y <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        colour.by = "Y variables", palette.selection = c("red", "green")
    )
    expect_s3_class(fig_y, "plotly")
})

test_that("dumbbellPlot handles custom line colour", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        line.colour = "#FF0000"
    )

    expect_s3_class(fig, "plotly")
})

test_that("dumbbellPlot handles legend visibility", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"), show.legend = FALSE
    )

    built <- plotly::plotly_build(fig)
    expect_false(built$x$layout$showlegend)
})

test_that("dumbbellPlot handles custom titles", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        title.text = "Earnings Gap", x.title = "Salary ($K)", y.title = "School"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$text, "Earnings Gap")
})

test_that("dumbbellPlot handles axis flipping", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        flip.x = TRUE, flip.y = TRUE
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$xaxis$autorange, "reversed")
    expect_equal(built$x$layout$yaxis$autorange, "reversed")
})

test_that("dumbbellPlot handles axis styling", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        axis.showline = FALSE, axis.linecolor = "#999999",
        axis.tickfont.size = 14, axis.tickfont.color = "#333333"
    )

    expect_s3_class(fig, "plotly")
    built <- plotly::plotly_build(fig)
    expect_false(built$x$layout$xaxis$showline)
})

test_that("dumbbellPlot handles faceting", {
    df <- data.frame(
        School = c("MIT", "Stanford", "Harvard", "Yale"),
        Women = c(94, 96, 112, 88),
        Men = c(152, 151, 165, 140),
        Region = c("East", "West", "East", "East")
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        facet.by = "Region"
    )

    expect_s3_class(fig, "plotly")
})

test_that("dumbbellPlot handles x.adjustment", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        x.adjustment = "log2"
    )

    expect_s3_class(fig, "plotly")
})

test_that("dumbbellPlot handles title font styling", {
    df <- data.frame(
        School = c("MIT", "Stanford"),
        Women = c(94, 96),
        Men = c(152, 151)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        title.text = "Test", title.font.size = 30,
        title.font.family = "Courier", title.font.color = "#0000FF"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$font$size, 30)
    expect_equal(built$x$layout$title$font$family, "Courier")
})

test_that("dumbbellPlot honors title.x.position for repositioning the title", {
    df <- data.frame(
        School = c("MIT", "Stanford", "Harvard"),
        Women = c(94, 96, 112),
        Men = c(152, 151, 165)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        title.text = "Custom title",
        title.x.position = 0.2
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$title$x, 0.2)
})

# Axis-title annotations as left by axis_titles_as_annotations() / build_facet_annotations().
.axis_title_anns <- function(fig) {
    Filter(function(a) identical(a$annotationType, "axis"), fig$x$layout$annotations)
}

test_that("dumbbellPlot applies axis title font to single-panel titles (#326)", {
    df <- data.frame(
        School = c("MIT", "Stanford", "Harvard"),
        Women = c(94, 96, 112),
        Men = c(152, 151, 165)
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        x.title = "Value", y.title = "School",
        axis.title.font.size = 36, axis.title.font.color = "#F51313",
        axis.title.font.family = "Courier New"
    )

    built <- plotly::plotly_build(fig)
    expect_equal(built$x$layout$xaxis$title$text, "Value")
    expect_equal(built$x$layout$yaxis$title$text, "School")
    expect_equal(built$x$layout$xaxis$title$font$size, 36)
    expect_equal(built$x$layout$yaxis$title$font$color, "#F51313")

    # The module converts single-panel titles to draggable annotations; the font must survive.
    anns <- .axis_title_anns(axis_titles_as_annotations(fig))
    expect_length(anns, 2)
    for (a in anns) {
        expect_equal(a$font$size, 36)
        expect_equal(a$font$color, "#F51313")
        expect_equal(a$font$family, "Courier New")
    }
})

test_that("dumbbellPlot applies axis title font to faceted shared titles (#326)", {
    df <- data.frame(
        School = c("MIT", "Stanford", "Harvard", "Yale"),
        Women = c(94, 96, 112, 88),
        Men = c(152, 151, 165, 140),
        Region = c("East", "West", "East", "East")
    )
    fig <- dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"), facet.by = "Region",
        x.title = "Value", y.title = "School",
        axis.title.font.size = 30, axis.title.font.color = "#0000FF"
    )

    anns <- .axis_title_anns(plotly::plotly_build(fig))
    expect_length(anns, 2)
    for (a in anns) {
        expect_equal(a$font$size, 30)
        expect_equal(a$font$color, "#0000FF")
    }
})

test_that("dumbbellPlot honours gridline visibility and colour on every panel", {
    df <- data.frame(
        School = c("MIT", "Stanford", "Harvard", "Yale"),
        Women = c(94, 96, 112, 88),
        Men = c(152, 151, 165, 140),
        Region = c("East", "West", "East", "East")
    )
    built <- plotly::plotly_build(dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"),
        show.grid.x = FALSE, grid.color = "#FF0000"
    ))
    expect_false(built$x$layout$xaxis$showgrid)
    expect_true(built$x$layout$yaxis$showgrid)
    expect_equal(built$x$layout$yaxis$gridcolor, "#FF0000")

    built_facet <- plotly::plotly_build(dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("pink", "blue"), facet.by = "Region",
        show.grid.y = FALSE, grid.color = "#FF0000"
    ))
    lay <- built_facet$x$layout
    x_axes <- grep("^xaxis[0-9]*$", names(lay), value = TRUE)
    y_axes <- grep("^yaxis[0-9]*$", names(lay), value = TRUE)
    expect_true("xaxis2" %in% x_axes)
    for (a in x_axes) expect_true(lay[[a]]$showgrid)
    for (a in y_axes) expect_false(lay[[a]]$showgrid)
    for (a in c(x_axes, y_axes)) expect_equal(lay[[a]]$gridcolor, "#FF0000")
})

test_that("dumbbellPlot frames every facet panel, not just the first", {
    # The shared y axis only belongs to the first panel, so axis lines alone left
    # the others without a left/top/right edge.
    df <- data.frame(
        School = c("MIT", "Stanford", "Harvard", "Yale"),
        Women = c(94, 96, 112, 188),
        Men = c(52, 101, 165, 145),
        Grp = c("STEM", "STEM", "LA", "LA")
    )
    build <- function(...) {
        plotly::plotly_build(dumbbellPlot(
            data = df, x = c("Women", "Men"), y = "School",
            palette.selection = c("orange", "skyblue"), facet.by = "Grp", ...
        ))
    }

    built <- build()
    panels <- Filter(function(s) identical(s$type, "rect"), built$x$layout$shapes)
    expect_length(panels, 2)
    for (p in panels) {
        expect_identical(p$xref, "paper")
        expect_equal(c(p$y0, p$y1), c(0, 1))
    }
    expect_equal(c(panels[[1]]$x0, panels[[1]]$x1), built$x$layout$xaxis$domain)
    expect_equal(c(panels[[2]]$x0, panels[[2]]$x1), built$x$layout$xaxis2$domain)

    # Facet titles are centred over the panels rather than over an evenly split paper.
    titles <- Filter(function(a) is.null(a$annotationType), built$x$layout$annotations)
    expect_equal(titles[[2]]$x, mean(built$x$layout$xaxis2$domain))

    edges <- build(axis.mirror = FALSE)$x$layout$shapes
    expect_length(edges, 4)
    expect_true(all(vapply(edges, function(s) identical(s$type, "line"), logical(1))))

    expect_length(build(axis.showline = FALSE)$x$layout$shapes, 0)
})

test_that("dumbbellPlot styles facet panel titles with facet.title.font.*", {
    # Set inside the plot function: the module's later annotation restyle cannot see
    # annotations that layout() holds until build time.
    df <- data.frame(
        School = c("MIT", "Stanford", "Harvard", "Yale"),
        Women = c(94, 96, 112, 188),
        Men = c(52, 101, 165, 145),
        Grp = c("STEM", "STEM", "LA", "LA")
    )
    built <- plotly::plotly_build(dumbbellPlot(
        data = df, x = c("Women", "Men"), y = "School",
        palette.selection = c("orange", "skyblue"), facet.by = "Grp",
        facet.title.font.size = 40, facet.title.font.color = "#0000FF",
        facet.title.font.family = "Courier New"
    ))
    titles <- Filter(function(a) is.null(a$annotationType), built$x$layout$annotations)
    expect_length(titles, 2)
    for (a in titles) {
        expect_equal(a$font, list(size = 40, color = "#0000FF", family = "Courier New"))
    }
})
