test_that("multiColorPicker builds widget with dependencies and groups", {
    groups <- c("setosa", "virginica")
    widget <- multiColorPicker("species_cols", groups = groups)

    expect_true(inherits(widget, "shiny.tag"))

    deps <- htmltools::findDependencies(widget)
    dep_names <- vapply(deps, `[[`, "", "name")
    expect_true("multi-color-picker" %in% dep_names)
    expect_true("selectize" %in% dep_names)

    container <- widget
    expect_equal(container$attribs$id, "species_cols")
    expect_equal(container$attribs[["data-compact"]], "false")
    data_groups <- jsonlite::fromJSON(container$attribs[["data-groups"]])
    expect_identical(data_groups, groups)

    initial <- jsonlite::fromJSON(container$attribs[["data-initial"]])
    expect_identical(names(initial), groups)
    expect_true(all(grepl("^#[0-9A-F]{6}$", unlist(initial))))
})

test_that("multiColorPicker respects selected palette and manual overrides", {
    palettes <- list(
        Custom = list(
            Bright = c("#111111", "#222222"),
            Pastel = c("#abc", "#123456ff")
        )
    )

    widget <- multiColorPicker(
        "cols",
        groups = c("A", "B", "C"),
        palette_options = palettes,
        selected_palette = "Pastel",
        colors = c(A = "#0f0")
    )

    container <- widget
    expect_match(container$attribs[["data-default-palette"]], "Pastel")

    palette_json <- jsonlite::fromJSON(container$attribs[["data-palettes"]])
    expect_identical(palette_json$Pastel, c("#AABBCC", "#123456"))

    initial <- jsonlite::fromJSON(container$attribs[["data-initial"]])
    expect_identical(initial[["A"]], "#00FF00")
    expect_identical(initial[["B"]], "#123456")
    expect_identical(initial[["C"]], "#AABBCC")
})

test_that("the widget waits out the colour dialog but reports one-shot actions", {
    js <- readLines(
        system.file("src", "multiColorPicker.js", package = "VizModules"),
        warn = FALSE
    )

    handler_body <- function(selector, events) {
        start <- grep(
            paste0("\\$el\\.on\\(\"", events, "[^\"]*\", \"", selector, "\""),
            js
        )
        expect_length(start, 1)
        paste(js[start:(start + 12)], collapse = "\n")
    }

    # The colour dialog gives no close event, so its stream is held until the
    # page sees the user again rather than reported per drag step or on a timer.
    colour_handler <- handler_body("\\.mc-color-input", "input")
    expect_match(colour_handler, "watchForClose\\(\\)")
    expect_false(grepl("callback\\(", colour_handler))
    expect_true(any(grepl("pointerdown", js, fixed = TRUE)))

    # Typing a hex code is coalesced on a timer instead: the page sees those.
    expect_true(any(grepl("TYPING_DEBOUNCE_MS = \\d+", js)))
    expect_match(handler_body("\\.mc-text-input", "input"), "queueReport\\(\\)")

    # Deliberate one-shot actions still report straight away.
    expect_match(handler_body("\\.mc-swatch", "click"), "reportNow\\(\\)")
    expect_match(handler_body("\\.mc-apply-palette", "click"), "reportNow\\(\\)")
    expect_match(handler_body("\\.mc-reset-palette", "click"), "reportNow\\(\\)")
})

test_that("the widget's controls are laid out to reflow in a narrow container", {
    css <- paste(
        readLines(
            system.file("src", "multiColorPicker.css", package = "VizModules"),
            warn = FALSE
        ),
        collapse = "\n"
    )

    rule <- function(selector) {
        m <- regmatches(
            css,
            regexpr(paste0(selector, "\\s*\\{[^}]*\\}"), css)
        )
        expect_length(m, 1)
        m
    }

    # Nothing in the header may hold the panel open at a fixed width: that is
    # what pushed "Apply"/"Reset" outside it in narrow layouts.
    expect_match(rule("\\.multi-color-picker \\.mc-actions"), "flex-wrap:\\s*wrap")
    expect_match(
        rule("\\.multi-color-picker \\.selectize-control\\.mc-palette-select"),
        "min-width:\\s*0"
    )

    # Group rows wrap, and long group names wrap with them rather than running
    # underneath the swatch.
    expect_match(rule("\\.multi-color-picker \\.mc-color-row"), "flex-wrap:\\s*wrap")
    expect_match(
        rule("\\.multi-color-picker \\.mc-group-label"),
        "overflow-wrap:\\s*anywhere"
    )
})

test_that("input handler returns named vector and handles null", {
    .register_multi_color_picker_handler()
    registry <- getFromNamespace("inputHandlers", "shiny")
    handler <- registry$get("VizModules.multiColorPicker")

    data <- list(
        list(name = "setosa", value = "#E69F00"),
        list(name = "virginica", value = "#56B4E9"),
        list(name = "versicolor", value = "#009E73")
    )

    res <- handler(data)
    expect_identical(
        res,
        c("setosa" = "#E69F00", "virginica" = "#56B4E9", "versicolor" = "#009E73")
    )
    expect_identical(handler(list(list(name = "setosa"))), c("setosa" = ""))
    expect_identical(handler(NULL), setNames(character(0), character(0)))
})
