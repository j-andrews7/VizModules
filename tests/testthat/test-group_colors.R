test_that("resolve_palette prefers user picks, then manual colours, then the recycled default", {
    expect_null(resolve_palette(character(0), NULL, "#CCCCCC"))

    # Nothing else applies: the default palette is recycled.
    expect_equal(
        resolve_palette(c("A", "B", "C"), NULL, c("#111111", "#222222")),
        c(A = "#111111", B = "#222222", C = "#111111")
    )
    # manual_colors apply where the user has picked nothing, and groups they do
    # not name fall back.
    expect_equal(
        resolve_palette(c("A", "B"), NULL, "#CCCCCC", c(A = "#FF0000", B = "#00FF00")),
        c(A = "#FF0000", B = "#00FF00")
    )
    expect_equal(
        resolve_palette(c("A", "B"), NULL, "#CCCCCC", c(B = "#00FF00")),
        c(A = "#CCCCCC", B = "#00FF00")
    )
    # The user's picks win over manual_colors.
    expect_equal(
        resolve_palette(c("A", "B", "C"), c(A = "#FF0000"), "#CCCCCC", c(A = "#000000", B = "#00FF00")),
        c(A = "#FF0000", B = "#00FF00", C = "#CCCCCC")
    )
})

test_that("default_group_colors normalizes color names, resolves reactives, and rejects unnamed vectors", {
    expect_equal(
        default_group_colors(list(palette.colours = c(A = "red", B = "#0f0")), "palette.colours"),
        c(A = "#FF0000", B = "#00FF00")
    )
    mapping <- shiny::reactiveVal(c(A = "red"))
    expect_equal(
        shiny::isolate(default_group_colors(list(palette.colours = mapping), "palette.colours")),
        c(A = "#FF0000")
    )
    expect_null(default_group_colors(list(palette.colours = c("red", "blue")), "palette.colours"))
    expect_null(default_group_colors(list(palette.colours = 1:3), "palette.colours"))
    expect_null(default_group_colors(NULL, "palette.colours"))
    expect_null(default_group_colors(list(other = c(A = "red")), "palette.colours"))
})

# A minimal module assembled from the real helpers, wired exactly as every plot
# module wires its colour picker: the mapping is resolved server-side into a
# store, the store is seeded when the picker is (re)built, and the plot reads the
# store rather than the picker's raw input.
mini_color_server <- function(id, groups, defaults = NULL, runs) {
    shiny::moduleServer(id, function(input, output, session) {
        params <- setup_reactive_defaults(defaults, input, session)
        fallback <- c("#111111", "#222222", "#333333")

        palette_store <- setup_group_colors(
            input, "palette.colours", groups,
            default_palette = fallback, defaults = defaults, params = params
        )

        # Stands in for the picker's renderUI, which seeds the store with the
        # same colours the widget itself is built from.
        seed_picker <- function() {
            initial <- shiny::isolate(resolve_palette(
                groups(), input$palette.colours, fallback,
                default_group_colors(defaults, "palette.colours")
            ))
            palette_store(initial)
            initial
        }

        generate <- shiny::reactive({
            isolate_fn <- setup_auto_update_logic(input, params)
            runs(shiny::isolate(runs()) + 1L)
            isolate_fn(palette_store())
        })

        # Stands in for the plot output that pulls the reactive on every flush.
        shiny::observe(generate())
    })
}


test_that("before the picker reports, the store holds the default palette, or nothing without groups", {
    cases <- list(list(groups = c("A", "B"), expected = c(A = "#111111", B = "#222222")),
                  list(groups = character(0), expected = NULL))
    for (case in cases) {
        shiny::testServer(
            mini_color_server,
            args = list(groups = shiny::reactive(case$groups), runs = shiny::reactiveVal(0L)),
            {
                session$setInputs(auto.update = TRUE)
                expect_equal(palette_store(), case$expected)
                expect_equal(generate(), case$expected)
            }
        )
    }
})

test_that("the picker echoing the palette already in use costs no extra render", {
    runs <- shiny::reactiveVal(0L)

    shiny::testServer(
        mini_color_server,
        args = list(groups = shiny::reactive(c("A", "B")), runs = runs),
        {
            session$setInputs(auto.update = TRUE)
            initial <- seed_picker()
            session$flushReact()

            # This is the client round-trip that #338 was about: the freshly built
            # widget reports exactly what the server seeded it with.
            before <- runs()
            session$setInputs(palette.colours = initial)

            expect_equal(generate(), initial)
            expect_equal(runs(), before)
        }
    )
})

test_that("a colour the user actually picks reaches the plot in one re-run", {
    runs <- shiny::reactiveVal(0L)

    shiny::testServer(
        mini_color_server,
        args = list(groups = shiny::reactive(c("A", "B")), runs = runs),
        {
            session$setInputs(auto.update = TRUE)
            session$setInputs(palette.colours = c(A = "#111111", B = "#222222"))

            before <- runs()
            session$setInputs(palette.colours = c(A = "#FF0000", B = "#222222"))

            expect_equal(generate(), c(A = "#FF0000", B = "#222222"))
            expect_equal(runs(), before + 1L)
        }
    )
})

test_that("the store follows a reactive defaults entry rather than the client input", {
    mapping <- shiny::reactiveVal(c(A = "#FF0000", B = "#00FF00"))
    runs <- shiny::reactiveVal(0L)

    shiny::testServer(
        mini_color_server,
        args = list(
            groups = shiny::reactive(c("A", "B")),
            defaults = list(palette.colours = mapping),
            runs = runs
        ),
        {
            session$setInputs(auto.update = TRUE)
            expect_equal(generate(), c(A = "#FF0000", B = "#00FF00"))

            before <- runs()
            mapping(c(A = "#0000FF", B = "#00FF00"))
            session$flushReact()

            expect_equal(generate(), c(A = "#0000FF", B = "#00FF00"))
            expect_equal(runs(), before + 1L)
        }
    )
})




# The axis-range store, wired the way the plot modules wire it: the limits are
# pushed into the controls and the plot reads the store rather than the inputs.
mini_range_server <- function(id, headroom = NULL, runs) {
    shiny::moduleServer(id, function(input, output, session) {
        y_range_store <- setup_axis_range(input, session, headroom = headroom)

        seed <- function(lo, hi) {
            y_range_store(list(min = lo, max = hi))
            shiny::updateNumericInput(session, "y.min", value = lo)
            shiny::updateNumericInput(session, "y.max", value = hi)
        }

        generate <- shiny::reactive({
            runs(shiny::isolate(runs()) + 1L)
            y_range_store()
        })

        shiny::observe(generate())
    })
}


test_that("the echo of a limit the server just set costs no extra render", {
    runs <- shiny::reactiveVal(0L)

    shiny::testServer(mini_range_server, args = list(runs = runs), {
        session$setInputs(y.min = 0, y.max = 10)
        seed(0, 8.690000000000001)
        session$flushReact()

        before <- runs()
        # The browser echoes the value back, and a JSON round-trip need not
        # return the same bits it was handed.
        session$setInputs(y.min = 0, y.max = 8.69)

        expect_equal(generate()$max, 8.690000000000001)
        expect_equal(runs(), before)
    })
})

test_that("a limit the user types reaches the plot in one re-run", {
    runs <- shiny::reactiveVal(0L)

    shiny::testServer(mini_range_server, args = list(runs = runs), {
        session$setInputs(y.min = 0, y.max = 10)
        session$flushReact()

        before <- runs()
        session$setInputs(y.max = 42)

        expect_equal(generate()$max, 42)
        expect_equal(runs(), before + 1L)
    })
})

test_that("the maximum is raised to clear headroom, and the control follows", {
    runs <- shiny::reactiveVal(0L)
    needed <- shiny::reactiveVal(NULL)

    shiny::testServer(
        mini_range_server,
        args = list(headroom = function() needed(), runs = runs),
        {
            session$setInputs(y.min = 0, y.max = 10)
            session$flushReact()
            expect_equal(generate()$max, 10)

            # Brackets need more room than the current limit gives them.
            needed(25)
            session$flushReact()
            expect_equal(generate()$max, 25)

            # The control is told about it, so the number on screen is the one
            # actually in use rather than one the plot quietly overrode. Its
            # echo then changes nothing.
            before <- runs()
            session$setInputs(y.max = 25)
            expect_equal(generate()$max, 25)
            expect_equal(runs(), before)
        }
    )
})

test_that("headroom only ever raises a limit, and ignores a blank one", {
    cases <- list(
        # A larger limit the user chose is never lowered.
        list(headroom = function() 25, inputs = list(y.min = 0, y.max = 100), expected = list(min = 0, max = 100)),
        # No headroom leaves the requested limits alone.
        list(headroom = function() NULL, inputs = list(y.min = -3, y.max = 7), expected = list(min = -3, max = 7)),
        # A blank numeric control reports NA, which must not be mistaken for a
        # limit that already clears the headroom.
        list(headroom = function() 12, inputs = list(y.min = 0, y.max = NA), expected = list(min = 0, max = 12))
    )
    for (case in cases) {
        shiny::testServer(
            mini_range_server,
            args = list(headroom = case$headroom, runs = shiny::reactiveVal(0L)),
            {
                do.call(session$setInputs, case$inputs)
                session$flushReact()
                expect_equal(generate(), case$expected)
            }
        )
    }
})
