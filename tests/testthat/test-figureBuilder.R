test_that("figureBuilderUI namespaces its ids and canvas markup", {
    ui <- figureBuilderUI("figure_builder")
    html <- as.character(ui)
    # The bundled CSS/JS is hoisted into the document head, so pull that slot too.
    head_html <- as.character(htmltools::renderTags(ui)$head)

    # Every control id must be namespaced so the module can be embedded/reused.
    expect_true(grepl("figure_builder-pb_canvas", html))
    expect_true(grepl("figure_builder-pb_add", html))
    expect_true(grepl("figure_builder-download.source", html))

    # Canvas is styled/targeted by class (not a hardcoded id) so the JS/CSS work
    # under any namespace and for multiple instances.
    expect_true(grepl("pb-canvas a4-portrait", html))
    expect_true(grepl("pb-canvas-scroll", html))
    expect_true(grepl("\\.pb-canvas", head_html))

    # The SVG download uses a delegated, class-based handler (no inline onclick
    # to a global function, which would collide across instances). The bundled
    # JS wires that handler up and resolves each button's sibling canvas.
    expect_true(grepl("pb-download-svg", html))
    expect_false(grepl("pbDownloadSVG\\(\\)", html))
    expect_true(grepl("addEventListener\\('click'", head_html))
    expect_true(grepl("pbCanvasForControl", head_html))

    # Panel labels render live on the canvas: the menu is tagged so a delegated
    # change handler can find it, the bundled JS assigns/reorders labels, and the
    # label element is styled by class.
    expect_true(grepl("pb-label-case", html))
    expect_true(grepl("pbAssignLabels", head_html))
    expect_true(grepl("\\.viz-panel-label", head_html))
})

test_that("figureBuilderUI can omit its header title", {
    with_title <- as.character(figureBuilderUI("fb", title = "My Builder"))
    expect_true(grepl("My Builder", with_title))

    no_title <- as.character(figureBuilderUI("fb", title = NULL))
    expect_false(grepl("<h2", no_title))
})

test_that("figureBuilderServer adds and removes panels within its namespace", {
    # A minimal fake module keeps the test independent of the plot modules.
    fake_reg <- list(
        demo = list(
            label = "Demo", dataset = "d1",
            inputs_ui = function(id, data, defaults = NULL) {
                shiny::tags$div(id = shiny::NS(id)("inp"), "controls")
            },
            output_ui = function(id, resizable = TRUE) {
                shiny::tags$div(id = shiny::NS(id)("out"), "plot")
            },
            server_fn = function(id, data) {
                shiny::moduleServer(id, function(input, output, session) {
                    shiny::reactive(list(data = data()))
                })
            },
            defaults = list()
        )
    )
    dl <- list(d1 = data.frame(a = 1:3, b = 4:6))

    shiny::testServer(
        figureBuilderServer,
        args = list(data_list = dl, module_registry = fake_reg),
        {
            session$setInputs(pb_orientation = "landscape")
            session$setInputs(pb_add = 1)
            session$setInputs(pb_new_module = "demo", pb_new_dataset = "d1")
            session$setInputs(pb_add_confirm = 1)

            expect_equal(rv$panel_ids, "panel1")
            expect_equal(rv$labels[["panel1"]], "Demo #1 (d1)")

            session$setInputs(pb_controls_select = "panel1")
            session$setInputs(pb_table_select = "panel1")

            # The remove button's input arrives under the module namespace.
            session$setInputs(panel1_remove = 1)
            expect_length(rv$panel_ids, 0)
        }
    )
})

test_that("figureBuilderServer validates its inputs", {
    expect_error(
        figureBuilderServer("fb", data_list = list()),
        "length"
    )
    expect_error(
        figureBuilderServer("fb", data_list = list(a = 1:3)),
        "is.data.frame"
    )
})

test_that("figureBuilderApp returns UI and server components", {
    parts <- figureBuilderApp(
        data_list = list(d1 = data.frame(a = 1:3)),
        return_components = TRUE
    )
    expect_named(parts, c("ui", "server"))
    expect_true(is.function(parts$server))
    expect_true(grepl("figure_builder-pb_canvas", as.character(parts$ui)))
})
