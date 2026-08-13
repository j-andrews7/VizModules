test_that("resolve_palette recycles the default palette when nothing else applies", {
    expect_null(resolve_palette(character(0), NULL, "#CCCCCC"))
    expect_equal(
        resolve_palette(c("A", "B", "C"), NULL, c("#111111", "#222222")),
        c(A = "#111111", B = "#222222", C = "#111111")
    )
})

test_that("resolve_palette uses manual_colors when the user has picked nothing", {
    expect_equal(
        resolve_palette(c("A", "B"), NULL, "#CCCCCC", c(A = "#FF0000", B = "#00FF00")),
        c(A = "#FF0000", B = "#00FF00")
    )
})

test_that("resolve_palette falls back for groups manual_colors does not name", {
    expect_equal(
        resolve_palette(c("A", "B"), NULL, "#CCCCCC", c(B = "#00FF00")),
        c(A = "#CCCCCC", B = "#00FF00")
    )
})

test_that("resolve_palette lets the user's picks win over manual_colors", {
    expect_equal(
        resolve_palette(
            c("A", "B", "C"),
            c(A = "#FF0000"),
            "#CCCCCC",
            c(A = "#000000", B = "#00FF00")
        ),
        c(A = "#FF0000", B = "#00FF00", C = "#CCCCCC")
    )
})

test_that(".default_group_colors normalizes color names and rejects unnamed vectors", {
    expect_equal(
        .default_group_colors(list(palette.colours = c(A = "red", B = "#0f0")), "palette.colours"),
        c(A = "#FF0000", B = "#00FF00")
    )
    expect_null(.default_group_colors(list(palette.colours = c("red", "blue")), "palette.colours"))
    expect_null(.default_group_colors(list(palette.colours = 1:3), "palette.colours"))
    expect_null(.default_group_colors(NULL, "palette.colours"))
    expect_null(.default_group_colors(list(other = c(A = "red")), "palette.colours"))
})

test_that(".default_group_colors resolves reactive defaults entries", {
    mapping <- shiny::reactiveVal(c(A = "red"))
    shiny::isolate(
        expect_equal(
            .default_group_colors(list(palette.colours = mapping), "palette.colours"),
            c(A = "#FF0000")
        )
    )
})

test_that("reactive default sync reshapes color maps for the multi-color picker", {
    expect_equal(
        .input_sync_message(c(A = "#FF0000", B = "#00FF00")),
        list(value = list(
            list(name = "A", value = "#FF0000"),
            list(name = "B", value = "#00FF00")
        ))
    )
    expect_equal(.input_sync_message("a title"), list(value = "a title"))
    expect_equal(.input_sync_message(c("#FF0000")), list(value = "#FF0000"))
})
