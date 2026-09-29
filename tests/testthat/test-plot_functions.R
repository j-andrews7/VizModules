# The plain plotly functions share their title, legend and background arguments,
# so those are checked here once, across a minimal call to each, rather than
# repeated in every function's own test file.

.plot_functions <- list(
    pie = function(...) {
        piePlot(df = data.frame(category = c("A", "B"), count = c(10, 20)), labels = "category", values = "count", ...)
    },
    radar = function(...) {
        radarPlot(df = data.frame(category = c("A", "B", "C"), value = c(4, 7, 2)), theta = "category", r = "value", ...)
    },
    parallel = function(...) {
        parallelCoordinatesPlot(data = mtcars, dimensions = c("mpg", "cyl", "disp"), ...)
    },
    dumbbell = function(...) {
        dumbbellPlot(
            data = data.frame(School = c("MIT", "Stanford"), Women = c(94, 96), Men = c(152, 151)),
            x = c("Women", "Men"), y = "School", palette.selection = c("pink", "blue"), ...
        )
    },
    line = function(...) {
        linePlot(data = mtcars, x = "wt", y = "mpg", palette.selection = "Set2", ...)
    }
)

.build <- function(fn, ...) suppressWarnings(plotly::plotly_build(fn(...)))

test_that("every plot function applies its title text and font", {
    for (nm in names(.plot_functions)) {
        title <- .build(.plot_functions[[nm]],
            title.text = "My Title", title.font.size = 24,
            title.font.family = "Courier", title.font.color = "#FF0000"
        )$x$layout$title

        expect_equal(title$text, "My Title", info = nm)
        expect_equal(title$font$size, 24, info = nm)
        expect_equal(title$font$family, "Courier", info = nm)
        expect_equal(title$font$color, "#FF0000", info = nm)
    }
})

test_that("title.x.position moves the title where it is offered", {
    for (nm in c("dumbbell", "line")) {
        title <- .build(.plot_functions[[nm]], title.text = "Custom title", title.x.position = 0.2)$x$layout$title
        expect_equal(title$x, 0.2, info = nm)
    }
})

test_that("show.legend = FALSE hides the legend", {
    for (nm in c("pie", "radar", "dumbbell", "line")) {
        expect_false(.build(.plot_functions[[nm]], show.legend = FALSE)$x$layout$showlegend, info = nm)
    }
})

test_that("linePlot and dumbbellPlot draw no zero line on any panel (#363)", {
    facet_df <- data.frame(
        School = c("MIT", "Stanford", "Harvard", "Yale"),
        Women = c(-94, 96, 112, 88), Men = c(152, -151, 165, 140),
        Grp = c("STEM", "STEM", "LA", "LA")
    )
    figs <- list(
        dumbbell = .build(.plot_functions$dumbbell),
        line = .build(.plot_functions$line),
        dumbbell_facet = .build(function(...) dumbbellPlot(
            data = facet_df, x = c("Women", "Men"), y = "School",
            palette.selection = c("pink", "blue"), facet.by = "Grp", ...
        )),
        line_facet = .build(.plot_functions$line, facet.by = "am"),
        line_multi = .build(function(...) linePlot(
            data = mtcars, x = "wt", y = c("mpg", "qsec"), palette.selection = "Set2", ...
        ))
    )
    for (nm in names(figs)) {
        lay <- figs[[nm]]$x$layout
        axes <- grep("^[xy]axis[0-9]*$", names(lay), value = TRUE)
        expect_true(length(axes) >= 2, info = nm)
        for (a in axes) expect_false(lay[[a]]$zeroline, info = paste(nm, a))
    }
})

test_that("bgcolor sets the paper background", {
    for (nm in c("radar", "parallel")) {
        expect_equal(.build(.plot_functions[[nm]], bgcolor = "#F5F5F5")$x$layout$paper_bgcolor, "#F5F5F5", info = nm)
    }
})
