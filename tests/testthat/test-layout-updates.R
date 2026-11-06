# finalize_manual_edits() sends a render that changes only the layout as a
# layout-only message, cancelling the render (see .send_layout_only()).

# A stand-in for a module session, inside the render of output `mod-plot`
# (or of none, with `output = NULL`), recording the custom messages sent.
.layout_session <- function(output = "mod-plot") {
    env <- new.env()
    env$messages <- list()
    env$getCurrentOutputInfo <- function() if (!is.null(output)) list(name = output)
    env$sendCustomMessage <- function(type, message) {
        env$messages[[length(env$messages) + 1]] <- list(type = type, message = message)
    }
    env$ns <- function(id) paste0("mod-", id)
    env
}

.layout_store <- function() {
    list(
        edits = reactiveValues(legend = NULL, annotations = list(), colorbar = NULL),
        rendered_fig = reactiveVal(NULL),
        sent = new.env(parent = emptyenv()),
        refresh = reactiveVal(0)
    )
}

.layout_fig <- function(title = "A", y = mtcars$mpg) {
    plotly::plot_ly(x = mtcars$wt, y = y, type = "scatter", mode = "markers") |>
        plotly::layout(title = list(text = title), margin = list(t = 40))
}

.finalize <- function(fig, store, session) {
    isolate(finalize_manual_edits(fig, "mod-src", store, session))
}

test_that("a render changing only the layout sends just the new layout", {
    session <- .layout_session()
    store <- .layout_store()

    first <- .finalize(.layout_fig("A"), store, session)
    expect_s3_class(first, "plotly")
    expect_null(first$preRenderHook) # built here; renderPlotly() builds it once more
    expect_length(session$messages, 0)

    expect_error(.finalize(.layout_fig("B"), store, session), class = "shiny.output.cancel")
    expect_length(session$messages, 1)
    msg <- session$messages[[1]]
    expect_identical(msg$type, "vizmodules-plotly-layout")
    expect_identical(msg$message$id, "mod-plot")
    expect_identical(msg$message$refresh, "mod-plot.refresh")
    layout <- jsonlite::fromJSON(msg$message$layout, simplifyVector = FALSE)
    expect_identical(layout$title$text, "B")
    expect_true(layout$transition)
    expect_false(grepl(as.character(mtcars$mpg[1]), msg$message$layout, fixed = TRUE)) # no trace data
    # The figure recorded for mapping relayout events is the one now drawn.
    expect_identical(isolate(store$rendered_fig())$x$layout$title$text, "B")

    # Nothing changed: still a message, so a browser that cannot apply it can ask
    # for the whole figure, but with no layout to apply.
    expect_error(.finalize(.layout_fig("B"), store, session), class = "shiny.output.cancel")
    expect_length(session$messages, 2)
    expect_null(session$messages[[2]]$message$layout)

    # New trace data goes out whole.
    out <- .finalize(.layout_fig("B", y = mtcars$mpg * 2), store, session)
    expect_s3_class(out, "plotly")
    expect_length(session$messages, 2)
})

test_that("figures update in place without plotly.js animating them", {
    # The widget only needs layout.transition set. An object would make plotly.js
    # animate a colour-only update, which never redraws the legend.
    fig <- .update_in_place(.layout_fig("A"))
    expect_true(fig$x$layout$transition)
    built <- plotly::plotly_build(fig)
    expect_true(built$x$layout$transition)

    # A transition the figure already has is its own.
    own <- plotly::plotly_build(plotly::layout(.layout_fig("A"), transition = list(duration = 500)))
    expect_identical(.update_in_place(own)$x$layout$transition, list(duration = 500))
})

test_that("a figure without a uirevision keeps the view until its traces change", {
    session <- .layout_session()
    store <- .layout_store()
    first <- .finalize(.layout_fig("A"), store, session)
    expect_identical(first$x$layout$uirevision, "mod-plot-traces-1")
    expect_error(.finalize(.layout_fig("B"), store, session), class = "shiny.output.cancel")
    sent <- jsonlite::fromJSON(session$messages[[1]]$message$layout, simplifyVector = FALSE)
    expect_identical(sent$uirevision, "mod-plot-traces-1")
    expect_identical(.finalize(.layout_fig("B", y = mtcars$mpg * 2), store, session)$x$layout$uirevision,
        "mod-plot-traces-2")

    # One set by the module, as the cached modules do per build, is left alone.
    own <- function(title) plotly::layout(.layout_fig(title), uirevision = "build-7")
    store <- .layout_store()
    expect_identical(.finalize(own("A"), store, .layout_session())$x$layout$uirevision, "build-7")
})

test_that("a new uirevision is sent whole, however little else changed", {
    session <- .layout_session()
    store <- .layout_store()
    fig <- function(title, revision) plotly::layout(.layout_fig(title), uirevision = revision)
    .finalize(fig("A", "build-1"), store, session)

    # The same plot restyled: its traces stay, and with them the view.
    expect_error(.finalize(fig("B", "build-1"), store, session), class = "shiny.output.cancel")
    expect_length(session$messages, 1)

    # A redraw that only changes the layout (the annotations for a selection, say)
    # is a new plot: the traces in the browser hold its selected points and hidden
    # legend entries, which only fresh ones clear.
    out <- .finalize(fig("B", "build-2"), store, session)
    expect_s3_class(out, "plotly")
    expect_identical(out$x$layout$uirevision, "build-2")
    expect_length(session$messages, 1)

    # And it is what the next update is compared with.
    expect_error(.finalize(fig("C", "build-2"), store, session), class = "shiny.output.cancel")
})

test_that("the layout sent decodes as it would inside a full render", {
    session <- .layout_session()
    store <- .layout_store()
    .finalize(.layout_fig("A"), store, session)
    fig <- .layout_fig("A") |> plotly::layout(xaxis = list(range = c(1, 5)), shapes = list(list(type = "line")))
    expect_error(.finalize(fig, store, session), class = "shiny.output.cancel")

    full <- plotly::plotly_build(fig)
    full_json <- jsonlite::fromJSON(htmlwidgets:::toJSON(list(x = full$x)), simplifyVector = FALSE)$x
    sent <- jsonlite::fromJSON(session$messages[[1]]$message$layout, simplifyVector = FALSE)
    expect_identical(sent$xaxis$range, list(1L, 5L))
    expect_identical(sent$shapes, list(list(type = "line")))
    expect_identical(sent$margin, full_json$layout$margin)
})

test_that("a changed config, hook, or JavaScript in the layout sends the whole figure", {
    session <- .layout_session()
    store <- .layout_store()
    .finalize(.layout_fig("A"), store, session)

    expect_s3_class(.finalize(plotly::config(.layout_fig("A"), displaylogo = TRUE), store, session), "plotly")
    with_hook <- htmlwidgets::onRender(.layout_fig("A"), "function(el) {}")
    expect_s3_class(.finalize(with_hook, store, session), "plotly")
    with_js <- with_hook
    with_js$x$layout$meta <- htmlwidgets::JS("1 + 1")
    expect_s3_class(.finalize(with_js, store, session), "plotly")
    expect_length(session$messages, 0)
})

test_that("layout-only updates need a render, the option, and a figure sent to that output", {
    fig <- .layout_fig("A")

    # Outside a render, finalize_manual_edits() returns the figure as before, unbuilt.
    session <- .layout_session(output = NULL)
    store <- .layout_store()
    out <- .finalize(fig, store, session)
    expect_false(is.null(out$preRenderHook))
    expect_identical(.finalize(fig, store, session)$x$source, "mod-src")

    # Turned off.
    session <- .layout_session()
    withr::local_options(VizModules.layout.updates = FALSE)
    .finalize(fig, store, session)
    expect_s3_class(.finalize(.layout_fig("B"), store, session), "plotly")
    expect_length(session$messages, 0)
    withr::local_options(VizModules.layout.updates = NULL)

    # Another output, or a store whose record was cleared (the browser asked for
    # the whole figure), sends it whole.
    store <- .layout_store()
    .finalize(fig, store, session)
    expect_s3_class(.finalize(.layout_fig("B"), store, .layout_session("mod-other")), "plotly")
    store$sent$rest <- NULL
    expect_s3_class(.finalize(.layout_fig("C"), store, session), "plotly")
    expect_length(session$messages, 0)
})

test_that("a module re-renders a styling change as a layout-only update", {
    testServer(plotthis_BoxPlotServer, args = list(data = reactive(example_demographics)), {
        do.call(session$setInputs, .box_inputs())
        expect_no_error(output$BoxPlot)
        # testServer() re-raises the cancelled render when the output is read.
        session$setInputs(title.font.size = 30)
        expect_error(output$BoxPlot, class = "shiny.output.cancel")
        session$setInputs(y.data = "age")
        expect_identical(jsonlite::fromJSON(output$BoxPlot)$x$layout$title$font$size, 30L)

        # The browser asking for the whole figure gets it.
        session$setInputs(title.font.size = 31)
        expect_error(output$BoxPlot, class = "shiny.output.cancel")
        session$setInputs(plot.refresh = 1)
        expect_identical(jsonlite::fromJSON(output$BoxPlot)$x$layout$title$font$size, 31L)
    })
})
