test_that("the helpers extension packages build on are exported", {
    helpers <- c(
        "toggle_facet_title_inputs", "main_title_input_ids", "default_group_colors", "reset_group_colors",
        "uniform_subplot_spacing_inputs_ui", "subplot_spacing_defaults", "with_stable_seed", "nz_value",
        "blank_to_null", "na_to_null", "uniform_stats_inputs_ui", "reset_stats_inputs", "default_stat_pairs",
        "stat_bracket_headroom", "note_brackets_skipped", "require_data_frame", "flatten_palette_options",
        "facet_check", "reset_manual_edits", "as_plotted", "adjusted_values", "adjustment_fn",
        "apply_highlight_styling", "create_highlight_annotations", "create_selected_annotations",
        "merge_annotation_sets", "parse_highlight_values"
    )

    expect_true(all(helpers %in% getNamespaceExports("VizModules")))
})

test_that("with_stable_seed repeats a draw and leaves the caller's random stream alone", {
    set.seed(123)
    before <- .Random.seed

    first <- with_stable_seed(runif(3))
    second <- with_stable_seed(runif(3))

    expect_identical(first, second)
    expect_identical(.Random.seed, before)
    expect_false(identical(with_stable_seed(runif(3), seed = 1L), first))
})

test_that("with_stable_seed restores the absence of a random stream too", {
    if (exists(".Random.seed", envir = globalenv(), inherits = FALSE)) {
        saved <- get(".Random.seed", envir = globalenv(), inherits = FALSE)
        on.exit(assign(".Random.seed", saved, envir = globalenv()), add = TRUE)
        rm(".Random.seed", envir = globalenv())
    }

    with_stable_seed(runif(1))

    expect_false(exists(".Random.seed", envir = globalenv(), inherits = FALSE))
})

test_that("blank_to_null reads anything but one real value as no selection", {
    expect_null(blank_to_null(NULL))
    expect_null(blank_to_null(""))
    expect_null(blank_to_null(NA_character_))
    expect_null(blank_to_null(character(0)))
    expect_null(blank_to_null(c("a", "b")))
    expect_identical(blank_to_null("Species"), "Species")
})

test_that("blank_to_null treats a numeric column as no grouping only when asked", {
    df <- data.frame(g = c("a", "b"), n = c(1, 2))

    expect_identical(blank_to_null("n", df), "n")
    expect_null(blank_to_null("n", df, numeric_is_null = TRUE))
    expect_identical(blank_to_null("g", df, numeric_is_null = TRUE), "g")
})

test_that("na_to_null clears an empty numericInput or textInput, and only those", {
    expect_null(na_to_null(NA))
    expect_null(na_to_null(NA_real_))
    expect_null(na_to_null(""))
    expect_identical(na_to_null(0), 0)
    expect_identical(na_to_null("a"), "a")
    expect_identical(na_to_null(c(1, NA)), c(1, NA))
})

test_that("facet_check offers only categorical columns with fewer than 50 levels", {
    df <- data.frame(
        few = rep(c("a", "b"), 30),
        many = paste0("id", seq_len(60)),
        num = seq_len(60),
        fct = factor(rep(c("x", "y", "z"), 20)),
        stringsAsFactors = FALSE
    )

    expect_identical(facet_check(df), c("few", "fct"))
    expect_identical(facet_check(NULL), character(0))
    expect_identical(facet_check(data.frame()), character(0))
})

test_that("main_title_input_ids names the inputs a faceted plot has no use for", {
    expect_type(main_title_input_ids, "character")
    expect_true(all(c("title.font.family", "title.font.color", "title.font.size") %in% main_title_input_ids))
    expect_false(any(grepl("^facet\\.title", main_title_input_ids)))
})

test_that("flatten_palette_options collapses the palette categories into one lookup", {
    flat <- flatten_palette_options(default_palettes()[["choices"]])

    expect_true(all(c("dittoColors", "viridis", "ggplot2") %in% names(flat)))
    expect_true(all(vapply(flat, is.character, logical(1))))
    expect_identical(flatten_palette_options(NULL), list())
    expect_error(flatten_palette_options("a"), "must be a list")
})

test_that("require_data_frame skips on NULL and coerces other tables", {
    source <- shiny::reactiveVal(NULL)
    guarded <- require_data_frame(source)

    shiny::isolate(expect_error(guarded(), class = "shiny.silent.error"))

    source(as.matrix(data.frame(a = 1:2, b = 3:4)))
    coerced <- shiny::isolate(guarded())
    expect_true(is.data.frame(coerced))
    expect_identical(nrow(coerced), 2L)

    source(data.frame(a = 1:3))
    expect_identical(nrow(shiny::isolate(guarded())), 3L)
})

test_that("reset_group_colors restores the mapping in defaults, or the stock palette", {
    sent <- list()
    testthat::local_mocked_bindings(
        updateMultiColorPicker = function(session, inputId, colors = NULL, reset = FALSE) {
            sent[[length(sent) + 1L]] <<- list(inputId = inputId, colors = colors, reset = reset)
        }
    )

    defaults <- list(palette.colours = c(A = "red", B = "#00FF00"))
    reset_group_colors(NULL, "palette.colours", defaults, c("A", "B"), c("#111111", "#222222"))
    expect_identical(sent[[1]]$inputId, "palette.colours")
    expect_false(sent[[1]]$reset)
    expect_identical(unname(sent[[1]]$colors[c("A", "B")]), c("#FF0000", "#00FF00"))

    reset_group_colors(NULL, "palette.colours", NULL, c("A", "B"), c("#111111", "#222222"))
    expect_true(sent[[2]]$reset)
    expect_null(sent[[2]]$colors)
})

test_that("default_group_colors ignores a mapping that is not fully named", {
    expect_identical(
        default_group_colors(list(k = c(A = "red")), "k"),
        c(A = "#FF0000")
    )
    expect_null(default_group_colors(list(k = c("red", "blue")), "k"))
    expect_null(default_group_colors(list(k = c(A = "red", "blue")), "k"))
    expect_null(default_group_colors(NULL, "k"))
})

test_that("note_brackets_skipped is a no-op outside a session", {
    expect_null(note_brackets_skipped(session = NULL))
})

test_that("stat_bracket_headroom clears the data and falls back to the Stats tab defaults", {
    df <- data.frame(g = rep(c("a", "b", "c"), each = 10), y = c(1:10, 11:20, 21:30))

    from_defaults <- stat_bracket_headroom(df, x = "g", y = "y", input = list())
    picked <- stat_bracket_headroom(df, x = "g", y = "y", input = list(stat.pairs = "a vs b"))

    expect_length(from_defaults, 1L)
    expect_gt(from_defaults, max(df$y))
    expect_gt(picked, max(df$y))
    expect_lte(picked, from_defaults)
})
