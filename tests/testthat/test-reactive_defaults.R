# A minimal module assembled from the real helpers, so these tests exercise the
# same code path every plot module uses.
mini_plot_server <- function(id, data, defaults = NULL, runs) {
    shiny::moduleServer(id, function(input, output, session) {
        params <- setup_reactive_defaults(defaults, input, session)

        generate <- shiny::reactive({
            isolate_fn <- setup_auto_update_logic(input, params)
            runs(shiny::isolate(runs()) + 1L)
            list(data = data(), main = isolate_fn(input$main))
        })

        # Stands in for the plot output that pulls the reactive on every flush.
        shiny::observe(generate())
    })
}


test_that("get_default resolves reactive entries to their current value", {
    title <- shiny::reactiveVal("first")

    expect_equal(get_default(list(main = title), "main", "fallback"), "first")

    title("second")
    expect_equal(get_default(list(main = title), "main", "fallback"), "second")

    expect_equal(
        get_default(list(main = shiny::reactive("from reactive")), "main", "fallback"),
        "from reactive"
    )
})

test_that("get_default validates the resolved value, not the reactive itself", {
    expect_equal(get_default(list(n = shiny::reactiveVal(10)), "n", 5, is.numeric), 10)
    expect_equal(get_default(list(n = shiny::reactiveVal("x")), "n", 5, is.numeric), 5)
})

test_that("get_default keeps plain functions as literal values", {
    fn <- function() "not a reactive"
    expect_identical(get_default(list(main = fn), "main", "fallback"), fn)
})

test_that(".input_key recognises direct input accesses only", {
    expect_equal(.input_key(quote(input$main)), "main")
    expect_equal(.input_key(quote(input[["main"]])), "main")

    expect_null(.input_key(quote(as.numeric(input$size))))
    expect_null(.input_key(quote(palette_groups())))
    expect_null(.input_key(quote(input)))
    expect_null(.input_key(quote("main")))
    expect_null(.input_key(quote(other$main)))
    expect_null(.input_key(quote(input[[key]])))
})

test_that("setup_reactive_defaults returns NULL when nothing is reactive", {
    expect_null(setup_reactive_defaults(NULL, NULL, NULL))
    expect_null(setup_reactive_defaults(list(), NULL, NULL))
    expect_null(setup_reactive_defaults(list(main = "fixed", size = 3), NULL, NULL))
    expect_null(setup_reactive_defaults(list(function() 1), NULL, NULL))
})

test_that("static defaults leave the input-reading path untouched", {
    shiny::testServer(
        mini_plot_server,
        args = list(
            data = shiny::reactive("d"),
            defaults = list(main = "fixed"),
            runs = shiny::reactiveVal(0L)
        ),
        {
            expect_null(params)

            session$setInputs(auto.update = TRUE, main = "typed")
            expect_equal(generate()$main, "typed")
        }
    )
})

test_that("a reactive default reaches the render in a single re-run", {
    data_rv <- shiny::reactiveVal("S1")
    title_rv <- shiny::reactiveVal("S1")
    runs <- shiny::reactiveVal(0L)

    shiny::testServer(
        mini_plot_server,
        args = list(
            data = shiny::reactive(data_rv()),
            defaults = list(main = title_rv),
            runs = runs
        ),
        {
            session$setInputs(auto.update = TRUE)
            expect_equal(generate()$main, "S1")

            # Data and title change together, exactly as they do in a parent app.
            before <- runs()
            data_rv("S2")
            title_rv("S2")
            session$flushReact()

            expect_equal(generate()$main, "S2")
            expect_equal(runs(), before + 1L)

            # The client echo of sendInputMessage() must not cost a second run.
            before <- runs()
            session$setInputs(main = "S2")
            expect_equal(generate()$main, "S2")
            expect_equal(runs(), before)
        }
    )
})

test_that("user edits win locally and are overwritten by the next external change", {
    title_rv <- shiny::reactiveVal("S1")
    runs <- shiny::reactiveVal(0L)

    shiny::testServer(
        mini_plot_server,
        args = list(
            data = shiny::reactive("d"),
            defaults = list(main = title_rv),
            runs = runs
        ),
        {
            session$setInputs(auto.update = TRUE)

            before <- runs()
            session$setInputs(main = "user typed")
            expect_equal(generate()$main, "user typed")
            expect_equal(runs(), before + 1L)

            title_rv("S2")
            session$flushReact()
            expect_equal(generate()$main, "S2")
        }
    )
})

test_that("reset restores the reactive default's current value", {
    title_rv <- shiny::reactiveVal("S1")
    defaults <- list(main = title_rv)

    # Mirrors what a module's reset observer passes to update*Input().
    expect_equal(get_default(defaults, "main", ""), "S1")

    title_rv("S2")
    expect_equal(get_default(defaults, "main", ""), "S2")
})

test_that("auto.update = FALSE still gates a reactive default behind the update button", {
    title_rv <- shiny::reactiveVal("S1")
    runs <- shiny::reactiveVal(0L)

    shiny::testServer(
        mini_plot_server,
        args = list(
            data = shiny::reactive("d"),
            defaults = list(main = title_rv),
            runs = runs
        ),
        {
            session$setInputs(auto.update = FALSE, update = 0)
            expect_equal(generate()$main, "S1")

            before <- runs()
            title_rv("S2")
            session$flushReact()
            expect_equal(runs(), before)
            expect_equal(generate()$main, "S1")

            session$setInputs(update = 1)
            expect_equal(runs(), before + 1L)
            expect_equal(generate()$main, "S2")
        }
    )
})

test_that("a real module server accepts a reactive default without disturbing static ones", {
    title_rv <- shiny::reactiveVal("First title")

    shiny::testServer(
        plotthis_BoxPlotServer,
        args = list(
            data = shiny::reactive(example_iris),
            defaults = list(x.data = "Species", y.data = "Sepal.Length", main = title_rv)
        ),
        {
            expect_false(is.null(params))
            expect_true(params$has("main"))
            expect_false(params$has("x.data"))

            title_rv("Second title")
            # The module's plotly event observers warn without a browser attached.
            suppressWarnings(session$flushReact())
            expect_equal(params$get("main"), "Second title")
        }
    )
})
