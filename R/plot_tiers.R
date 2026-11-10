#' Apply the uniform styling inputs to a module's figure
#'
#' The plot modules build their figures in two steps. The first draws the plot
#' itself from the data and every input that changes what is drawn; that is the
#' expensive part (a ggplot built and converted with [plotly::ggplotly()], say),
#' and it is cached. This function is the second step: it applies the inputs
#' that only style the figure -- titles, fonts, ticks and their notation,
#' gridlines, the padding around the data, reference lines, the modebar, the
#' shape-drawing tool, and the legend -- to the figure
#' the first step returned. Changing one of those inputs re-runs only this step,
#' which takes a few milliseconds rather than a full rebuild.
#'
#' The figure passed in is never modified (R copies on write), so each call
#' styles the cached figure afresh and nothing appended here (reference lines,
#' say) accumulates across calls.
#'
#' Axes used only by overlay panels drawn alongside the plot (the scatter
#' plot's marginal distributions, see [add_marginal_plots()]) keep their own
#' styling and get no reference lines.
#'
#' @param fig A plotly figure: the module's plot, before styling.
#' @param input The module's Shiny `input`, holding the uniform inputs from
#'   [uniform_axes_inputs_ui()], [uniform_lines_inputs_ui()],
#'   [uniform_plotly_inputs_ui()], and [uniform_legend_inputs_ui()].
#' @param isolate_fn The function from [setup_auto_update_logic()] that every
#'   input read goes through.
#' @param facet.by The facetting column(s), or `NULL`. A faceted figure has
#'   shared axis titles drawn as annotations, which are styled to match, and no
#'   main title (see [add_plot_config()]).
#' @param title_y Vertical position of the main title, in paper coordinates.
#' @param include.modebar.buttons Passed to [add_plot_config()].
#' @param fig.fn Optional `function(fig, input, isolate_fn)` returning the figure,
#'   run after the legend is styled and before the axis titles become draggable
#'   annotations, so any axis title text it sets is the one made draggable. Read
#'   inputs in it as `isolate_fn(input$key)`. It runs after any overlay panels are
#'   drawn, so anything it places on `"paper"` coordinates can land on them; use
#'   `xref = "x domain"` and `yref = "y domain"` to stay within the plot's panel.
#' @param ggplot.axis.styling Passed to [create_axis_styles()]. `TRUE` for a figure
#'   whose axis lines come from its ggplot theme (see
#'   [create_ggplot_axis_style()]); `FALSE` sets them from the Axes inputs here.
#' @param legend.position Passed to [apply_legend_inputs()]; `NULL` keeps the
#'   legend where it is.
#' @param padding.axes Which of the module's axes, `"x"` and `"y"`, take the
#'   `axis.padding.x`/`axis.padding.y` inputs (see [apply_axis_padding()]). Leave
#'   out an axis with its own limit inputs, so its limits stand. When `input$rotate`
#'   is `TRUE` the padding follows the variables onto the swapped axes.
#'
#' @return The styled plotly figure.
#'
#' @seealso [apply_title_layout()], [apply_subplot_axis_styling()],
#'   [apply_tick_notation()], [apply_axis_padding()], [add_reference_lines()], [add_plot_config()], [apply_plotly_newshape()],
#'   [apply_legend_inputs()], [axis_titles_as_annotations()]
#'
#' @author Jared Andrews
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#' # The uniform inputs, as a module's `input` would hold them.
#' input <- list(
#'     title.font.size = 20, title.font.family = "Arial", title.font.color = "#000000",
#'     axis.title.horizontal.position = 0.5, axis.title.font.size = 16,
#'     axis.title.font.family = "Arial", axis.title.font.color = "#000000",
#'     axis.tickfont.size = 12, axis.tickfont.family = "Arial", axis.tickfont.color = "#000000",
#'     axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
#'     axis.tickcolor = "#000000", axis.ticklen = 5, axis.tickwidth = 1,
#'     show.grid.x = TRUE, show.grid.y = FALSE, grid.color = "#CCCCCC",
#'     hline.intercepts = "20", hline.colors = "#D55E00",
#'     download.format = "svg", legend.text.size = 12, legend.title.size = 14
#' )
#' apply_uniform_styling(fig, input, isolate_fn = identity)
apply_uniform_styling <- function(fig, input, isolate_fn = isolate, facet.by = NULL,
                                  title_y = 0.95, include.modebar.buttons = TRUE, fig.fn = NULL,
                                  ggplot.axis.styling = TRUE, legend.position = NULL,
                                  padding.axes = c("x", "y")) {
    if (is.null(fig)) {
        return(fig)
    }
    faceted <- length(facet.by) > 0 && !isFALSE(facet.by) && any(nzchar(as.character(facet.by)))

    fig <- apply_title_layout(
        fig, input, isolate_fn,
        title_y = title_y, title_x = isolate_fn(input$axis.title.horizontal.position)
    )

    fig <- apply_subplot_axis_styling(
        fig,
        create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn, ggplot.axis.styling = ggplot.axis.styling),
        create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn, ggplot.axis.styling = ggplot.axis.styling)
    )
    if (faceted) {
        fig <- apply_axis_title_to_annotations(fig, input, isolate_fn)
    }

    fig <- apply_tick_notation(fig, scientific = isolate_fn(input$axis.scientific))
    fig <- apply_axis_padding(fig,
        x = if ("x" %in% padding.axes) isolate_fn(input$axis.padding.x),
        y = if ("y" %in% padding.axes) isolate_fn(input$axis.padding.y),
        swap = isTRUE(isolate_fn(input$rotate))
    )

    fig <- add_reference_lines(fig,
        hline.intercepts = isolate_fn(input$hline.intercepts),
        hline.colors = isolate_fn(input$hline.colors),
        hline.widths = isolate_fn(input$hline.widths),
        hline.linetypes = isolate_fn(input$hline.linetypes),
        hline.opacities = isolate_fn(input$hline.opacities),
        vline.intercepts = isolate_fn(input$vline.intercepts),
        vline.colors = isolate_fn(input$vline.colors),
        vline.widths = isolate_fn(input$vline.widths),
        vline.linetypes = isolate_fn(input$vline.linetypes),
        vline.opacities = isolate_fn(input$vline.opacities),
        abline.slopes = isolate_fn(input$abline.slopes),
        abline.intercepts = isolate_fn(input$abline.intercepts),
        abline.colors = isolate_fn(input$abline.colors),
        abline.widths = isolate_fn(input$abline.widths),
        abline.linetypes = isolate_fn(input$abline.linetypes),
        abline.opacities = isolate_fn(input$abline.opacities)
    )

    config_list <- add_plot_config(
        download.format = isolate_fn(input$download.format),
        include.modebar.buttons = include.modebar.buttons,
        facet.by = facet.by
    )
    fig <- do.call(plotly::config, c(list(p = fig), config_list))
    fig <- apply_plotly_newshape(fig, input, isolate_fn)
    fig <- apply_legend_inputs(fig, input, isolate_fn, position = legend.position)

    # A wrapper's additions, before the axis titles become annotations so any
    # title text it sets is the one made draggable.
    if (!is.null(fig.fn)) {
        fig <- fig.fn(fig, input, isolate_fn)
    }

    # Make single-panel x/y axis titles draggable (matches faceted behaviour)
    axis_titles_as_annotations(fig)
}


#' Input ids that only style a figure
#'
#' The ids [apply_uniform_styling()] reads. The cached plot step keys its cache
#' only on the inputs it reads itself (see [cached_structure()]), so changing
#' one of these re-uses the cached plot, unless a module's plot step reads it
#' too (DotPlot draws its size legend in the legend fonts, for instance).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_style_input_ids
#' @keywords internal
.style_input_ids <- c(
    # Titles
    "title.font.family", "title.font.color", "title.font.size", "axis.title.horizontal.position",
    "axis.title.font.size", "axis.title.font.color", "axis.title.font.family",
    "facet.title.font.size", "facet.title.font.color", "facet.title.font.family",
    # Ticks and gridlines
    "axis.tickfont.size", "axis.tickfont.color", "axis.tickfont.family",
    "axis.tickangle.x", "axis.tickangle.y", "axis.ticks", "axis.tickcolor", "axis.ticklen",
    "axis.tickwidth", "show.grid.x", "show.grid.y", "grid.color", "axis.scientific",
    # Padding around the data
    "axis.padding.x", "axis.padding.y",
    # Reference lines
    paste0("hline.", c("intercepts", "colors", "widths", "linetypes", "opacities")),
    paste0("vline.", c("intercepts", "colors", "widths", "linetypes", "opacities")),
    paste0("abline.", c("slopes", "intercepts", "colors", "widths", "linetypes", "opacities")),
    # Modebar, shape drawing and margins (margins are applied at render time)
    "download.format", "shape.fill", "shape.line.color", "shape.line.width", "shape.linetype",
    "shape.opacity", "margin.t", "margin.b", "margin.l", "margin.r",
    # Legend
    "legend.show", "legend.font.family", "legend.font.color", "legend.title.size", "legend.text.size"
)


#' Cache a module's plot step
#'
#' Draws a module's plot (everything before [apply_uniform_styling()]) and keeps
#' it in the session's cache, keyed on the data, the module's other reactive
#' values the step reads (`extra`), and the inputs the step reads, so a styling
#' change never redraws the plot and going back to settings already drawn
#' (toggling an option back, Reset) re-uses the figure. The figure is built here
#' ([plotly::plotly_build()]), so the styling step does not repeat that work.
#'
#' The inputs in the key are exactly those the step reads through the
#' `isolate_fn` it is given: every `isolate_fn(input$<key>)` read is recorded,
#' and the set only grows. So an input the step reads is always in the key (a
#' stale plot otherwise), while inputs it never reads (the styling ones, widget
#' bookkeeping, an input frozen by an update the step does not care about) are
#' never in it. An entry stored before the set grew has a key of a different
#' shape from every later one, so it can never be served for settings it was
#' not drawn with.
#'
#' On a miss the step is evaluated reactively, so it depends on what it reads in
#' the usual way; on a hit the key's reads stand in for it. Errors are not
#' cached. The key includes the module's namespace, so modules sharing a session
#' never see each other's entries. Set `options(VizModules.cache = FALSE)` to
#' turn caching off.
#'
#' @section Three rules keep the cache honest:
#'
#' A step that breaks one of these does not fail: it draws a stale plot.
#'
#' * Read every input in the literal form `isolate_fn(input$key)`. A wrapped read
#'   such as `isolate_fn(as.numeric(input$size))` cannot be recognised, and a bare
#'   `input$size` bypasses `isolate_fn` altogether, so that input never reaches
#'   the key. Convert outside the call.
#' * Name every other reactive the step reads in `extra`: colour and axis-limit
#'   stores, a debounced text input, a reactive argument. The exception is a
#'   reactive that only derives from `data`, which the key already covers.
#' * Give it no side effects (notifications, `reactiveVal()` writes), since a cache
#'   hit skips them. Return anything else the module needs in the list instead.
#'
#' @param build A function of `isolate_fn` that draws the plot and returns a
#'   list with at least `fig`. See the rules above.
#' @param input,session The module's `input` and `session`.
#' @param data The module's `data` reactive.
#' @param params The reactive-defaults store from [setup_reactive_defaults()], or
#'   `NULL`.
#' @param extra A function of no arguments returning the module's other reactive
#'   values `build` reads (axis-limit and colour stores, the selection, ...), or
#'   `NULL`.
#'
#' @return A reactive returning `build`'s value, with `.build` added: a number
#'   unique to each time the plot was drawn, kept with the value in the cache.
#'   The figure's `layout.uirevision` is set from it, so a styling change keeps
#'   the user's zoom while a different plot resets it.
#'
#' @seealso [apply_uniform_styling()] for the styling step,
#'   [finalize_manual_edits()] for sending a restyle as a layout-only update.
#' @author Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Inside moduleServer(), with `params` from setup_reactive_defaults():
#' draw_myPlot <- function(isolate_fn) {
#'     p <- my_plot_fn(data(), x = isolate_fn(input$x.by), colors = palette_store())
#'     list(fig = plotly::ggplotly(p))
#' }
#' base_myPlot <- cached_structure(draw_myPlot, input, session, data,
#'     params = params, extra = function() list(palette_store())
#' )
#' generate_myPlot <- reactive({
#'     isolate_fn <- setup_auto_update_logic(input, params)
#'     apply_uniform_styling(base_myPlot()$fig, input, isolate_fn)
#' })
#' }
cached_structure <- function(build, input, session, data, params = NULL, extra = NULL) {
    id <- session$ns("structure")
    builds <- 0L
    numbered <- function(value) {
        builds <<- builds + 1L
        value$.build <- builds
        # The view (zoom, pan, legend toggles) survives re-renders of the same
        # build, i.e. styling changes, but not a new or different plot; see
        # finalize_manual_edits().
        if (inherits(value$fig, "plotly")) {
            value$fig <- .ensure_built(value$fig)
            value$fig$x$layout$uirevision <- paste0(id, "-", builds)
        }
        value
    }
    tracked <- character(0)
    track <- function(key) {
        if (!key %in% tracked) {
            tracked <<- c(tracked, key)
        }
    }
    # Hashed once per change of the data rather than on every lookup.
    data_hash <- reactive(rlang::hash(data()))

    reactive({
        isolate_fn <- setup_auto_update_logic(input, params, track = track)
        if (isFALSE(getOption("VizModules.cache", TRUE))) {
            return(numbered(build(isolate_fn)))
        }

        # Read the key the way the step reads its inputs: isolated while Auto
        # Update is off, through the reactive-defaults store where one backs them.
        make_key <- function(ids) {
            values <- lapply(ids, function(key) {
                if (!is.null(params) && params$has(key)) {
                    isolate_fn(params$get(key))
                } else {
                    isolate_fn(input[[key]])
                }
            })
            rlang::hash(list(id, ids, values, data_hash(), if (is.null(extra)) NULL else isolate_fn(extra())))
        }

        cache <- session$cache
        before <- sort(tracked)
        key <- make_key(before)
        if (cache$exists(key)) {
            return(cache$get(key))
        }
        value <- numbered(build(isolate_fn))
        # A build that read inputs outside the key depends on them too, so file
        # it under the key of everything it read; a module recreated under this
        # id (whose set of reads grows the same way) can then never be served it
        # for settings it was not drawn with.
        after <- sort(tracked)
        cache$set(if (identical(after, before)) key else make_key(after), value)
        value
    })
}


#' A reactive that only invalidates when its value changes
#'
#' Reactives invalidate their readers whenever anything they read changes, even
#' if their value comes out the same. This passes one through a
#' [shiny::reactiveVal()], which ignores a value `identical()` to the one it holds,
#' so an expensive reader runs only for a real change. It suits a reactive
#' returning plain values; closures and environments never compare equal, so
#' anything holding those always counts as a change.
#'
#' The value is read at `priority = 1000`, like other stores a render reads, so a
#' change reaches its readers in the same flush. An error is held like a value and
#' raised to the readers, so `req()` and `validate()` work through it as usual.
#'
#' @param x A reactive.
#'
#' @return A reactive returning `x`'s value.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_settled_reactive
#' @keywords internal
.settled_reactive <- function(x) {
    held <- reactiveVal(NULL)
    observe(held(tryCatch(x(), error = identity)), priority = 1000)
    reactive({
        value <- held()
        req(!is.null(value))
        if (inherits(value, "error")) {
            stop(value)
        }
        value
    })
}


#' A notification raised while drawing a plot
#'
#' The structure step is cached, so it cannot show notifications itself (a cache
#' hit would skip them). It returns them instead, built with this, and
#' the function [.structure_notifier()] returns shows them the first time the
#' styling step sees each build.
#'
#' @param message The notification text.
#' @param id An id, namespaced on display, so a repeat replaces the last one.
#' @param type Passed to [shiny::showNotification()].
#' @return A list.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_structure_note
#' @keywords internal
.structure_note <- function(message, id, type = "message") {
    list(message = message, id = id, type = type)
}


#' Show the notifications a structure step returned
#'
#' Returns a function for the module's styling step to call with the cached
#' step's value; it shows that value's notes the first time it sees each build,
#' so restyling a plot does not repeat them but drawing (or restoring) one does.
#' It is called from the styling step rather than an observer so the cached step
#' is only evaluated when the plot is, never eagerly (an input frozen by an
#' update mid-flush would otherwise stop it).
#'
#' @param session The module's session.
#' @return A function of the cached step's value, whose `notes` is a list of
#'   [.structure_note()]s.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_structure_notifier
#' @keywords internal
.structure_notifier <- function(session) {
    shown <- NULL
    function(value) {
        if (identical(value$.build, shown)) {
            return(invisible())
        }
        shown <<- value$.build
        for (note in value$notes) {
            showNotification(note$message, id = session$ns(note$id), type = note$type, session = session)
        }
        invisible()
    }
}
