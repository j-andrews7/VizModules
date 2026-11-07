stops_of <- function(scale) {
    data.frame(
        at = vapply(scale$colorscale, `[[`, numeric(1), 1),
        color = vapply(scale$colorscale, `[[`, character(1), 2)
    )
}

test_that("resolve_colorscale spaces the stops evenly either side of the midpoint", {
    five <- c("#111111", "#222222", "#333333", "#444444", "#555555")

    even <- stops_of(resolve_colorscale(five, min = 0, max = 1))
    expect_equal(even$at, c(0, 0.25, 0.5, 0.75, 1))
    expect_identical(even$color, five)

    skewed <- stops_of(resolve_colorscale(five, min = 0, mid = 0.2, max = 1))
    expect_equal(skewed$at, c(0, 0.1, 0.2, 0.6, 1))
})

test_that("resolve_colorscale fills blank limits from the data", {
    expect_equal(resolve_colorscale(data.range = c(2, 9))[c("cmin", "cmax")], list(cmin = 2, cmax = 9))
    expect_equal(resolve_colorscale(min = 0, data.range = c(2, 9))[c("cmin", "cmax")], list(cmin = 0, cmax = 9))

    # A cleared numeric input reports NA or NULL, and whole data vectors are accepted.
    cleared <- resolve_colorscale(min = NULL, max = NA, data.range = c(5, NA, 1, Inf, 3))
    expect_equal(cleared[c("cmin", "cmax")], list(cmin = 1, cmax = 5))

    empty <- resolve_colorscale(data.range = c(NA_real_, NaN))
    expect_equal(empty[c("cmin", "cmax")], list(cmin = 0, cmax = 1))
})

test_that("resolve_colorscale keeps the scale valid for plotly", {
    # Constant data, limits the wrong way around, and a midpoint outside them.
    constant <- resolve_colorscale(data.range = c(3, 3))
    expect_equal(constant[c("cmin", "cmax")], list(cmin = 2.5, cmax = 3.5))

    swapped <- resolve_colorscale(min = 1, max = 0)
    expect_equal(swapped[c("cmin", "cmax")], list(cmin = 0, cmax = 1))

    for (mid in c(-5, 5)) {
        at <- stops_of(resolve_colorscale(c("red", "white", "blue"), min = 0, mid = mid, max = 1))$at
        expect_false(is.unsorted(at, strictly = TRUE))
        expect_identical(at[c(1, 3)], c(0, 1))
    }
})

test_that("resolve_colorscale takes the colours as a picker reports them", {
    picked <- c(Lowest = "#000000", Highest = "#FFFFFF")
    expect_identical(stops_of(resolve_colorscale(picked))$color, c("#000000", "#FFFFFF"))
    expect_identical(stops_of(resolve_colorscale(picked, reverse = TRUE))$color, c("#FFFFFF", "#000000"))

    expect_identical(stops_of(resolve_colorscale())$color, .colorscale_presets[[1]])
    expect_length(resolve_colorscale("#123456")$colorscale, 2)
})

test_that("every colour scale preset has one colour per stop", {
    expect_true(all(lengths(.colorscale_presets) == length(.colorscale_stops)))
})

test_that("uniform_colorscale_inputs_ui builds its inputs from defaults", {
    ns <- shiny::NS("mod")
    html <- as.character(uniform_colorscale_inputs_ui(ns, defaults = list(
        colorscale.palette = "Viridis", colorscale.min = 0.25, colorscale.reverse = TRUE,
        colorbar.title = "Beta value"
    )))

    for (id in c("colorscale.colors", "colorscale.reverse", "colorscale.min", "colorscale.mid", "colorscale.max",
                 "colorbar.title")) {
        expect_match(html, paste0("mod-", id), fixed = TRUE)
    }
    expect_match(html, "Beta value", fixed = TRUE)
    expect_match(html, "0.25", fixed = TRUE)
    # The stops take the preset's colours.
    expect_match(html, .colorscale_presets$Viridis[1], fixed = TRUE)
})

test_that("organize_inputs gives each colour scale input a cell of its own", {
    html <- as.character(organize_inputs(uniform_colorscale_inputs_ui(shiny::NS("mod")), columns = 2))
    cells <- gregexpr("vizmodules-input-cell", html, fixed = TRUE)[[1]]
    expect_length(cells, 6)
})

test_that("reset_colorscale_inputs restores the picker and clears the limits", {
    values <- list()
    record <- function(session, inputId, label = NULL, value = NULL, ...) {
        values[[inputId]] <<- value
        invisible(NULL)
    }
    picker <- NULL
    local_mocked_bindings(
        updateMultiColorPicker = function(session, inputId, reset = FALSE, ...) {
            picker <<- list(id = inputId, reset = reset)
            invisible(NULL)
        },
        updateMaterialSwitch = function(session, inputId, value = NULL) record(session, inputId, value = value),
        updateNumericInput = record,
        updateTextInput = record
    )
    reset_colorscale_inputs(NULL, defaults = list(colorscale.min = 0))

    expect_identical(picker, list(id = "colorscale.colors", reset = TRUE))
    expect_identical(values[["colorscale.min"]], 0)
    expect_true(is.na(values[["colorscale.max"]]))
    expect_identical(values[["colorbar.title"]], "Value")
    expect_false(values[["colorscale.reverse"]])
})

test_that("mark_overlay_axes exempts axes from the shared styling", {
    fig <- plotly::plot_ly()
    fig <- plotly::add_trace(fig, x = 1:3, y = 1:3, type = "scatter", mode = "lines")
    fig <- plotly::add_trace(fig,
        x = 1:3, y = 3:1, type = "scatter", mode = "lines", xaxis = "x2", yaxis = "y2"
    )
    fig <- plotly::layout(fig,
        yaxis = list(domain = c(0, 0.8)),
        xaxis2 = list(anchor = "y2", ticks = "", matches = "x"),
        yaxis2 = list(domain = c(0.85, 1), ticks = "")
    )
    fig <- mark_overlay_axes(plotly::plotly_build(fig), c("xaxis2", "yaxis2"))
    expect_identical(mark_overlay_axes(fig, "yaxis2")$x$.vizmodules_overlay_axes, c("xaxis2", "yaxis2"))

    input <- list(
        axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "#123456", axis.linewidth = 2,
        show.grid.x = FALSE, show.grid.y = FALSE, grid.color = "#CCCCCC", axis.ticks = "outside",
        axis.tickangle.x = 0, axis.tickangle.y = 0, axis.tickfont.size = 20,
        download.format = "svg", legend.show = TRUE
    )
    styled <- plotly::plotly_build(apply_uniform_styling(fig, input, identity, ggplot.axis.styling = FALSE))

    expect_identical(styled$x$layout$xaxis$ticks, "outside")
    expect_identical(styled$x$layout$yaxis2$ticks, "")
    expect_null(styled$x$layout$yaxis2$tickfont$size)
})
