#' Apply the uniform styling inputs to a module's figure
#'
#' The plot modules build their figures in two steps. The first draws the plot
#' itself from the data and every input that changes what is drawn; that is the
#' expensive part (a ggplot built and converted with [plotly::ggplotly()], say),
#' and it is cached. This function is the second step: it applies the inputs
#' that only style the figure -- titles, fonts, ticks, gridlines, reference
#' lines, the modebar, the shape-drawing tool, and the legend -- to the figure
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
#'
#' @return The styled plotly figure.
#'
#' @seealso [apply_title_layout()], [apply_subplot_axis_styling()],
#'   [add_reference_lines()], [add_plot_config()], [apply_plotly_newshape()],
#'   [apply_legend_inputs()], [axis_titles_as_annotations()]
#'
#' @author Jared Andrews
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#' input <- list(
#'     title.font.size = 20, title.font.family = "Arial", title.font.color = "#000000",
#'     axis.title.horizontal.position = 0.5, axis.title.font.size = 16,
#'     axis.tickfont.size = 12, show.grid.x = TRUE, show.grid.y = FALSE,
#'     hline.intercepts = "20", hline.colors = "#D55E00",
#'     download.format = "svg", legend.text.size = 12
#' )
#' apply_uniform_styling(fig, input, isolate_fn = identity)
apply_uniform_styling <- function(fig, input, isolate_fn = isolate, facet.by = NULL,
                                  title_y = 0.95, include.modebar.buttons = TRUE) {
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
        create_axis_styles(input, axis_side = "x", isolate_fn = isolate_fn),
        create_axis_styles(input, axis_side = "y", isolate_fn = isolate_fn)
    )
    if (faceted) {
        fig <- apply_axis_title_to_annotations(fig, input, isolate_fn)
    }

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
    fig <- apply_legend_inputs(fig, input, isolate_fn)

    # Make single-panel x/y axis titles draggable (matches faceted behaviour)
    axis_titles_as_annotations(fig)
}


#' Input ids that only style a figure
#'
#' The ids [apply_uniform_styling()] reads. They are left out of the structure
#' step's cache key, so changing one re-uses the cached plot. A module whose
#' structure step also reads one of them (`legend.show`, where it decides
#' whether a legend is drawn at all) keeps it in the key; see
#' [.cache_structure()].
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
    "axis.tickwidth", "show.grid.x", "show.grid.y", "grid.color",
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


#' Cache a module's structure step
#'
#' Wraps the reactive that draws a module's plot (everything before
#' [apply_uniform_styling()]) in [shiny::bindCache()], keyed on the data and
#' every input except the styling ones, so returning to settings already drawn
#' (toggling an option back, Reset, a second Figure Builder panel) re-uses the
#' figure instead of rebuilding it. The cache is the session's, and the key
#' includes the module's namespace, so modules never see each other's entries.
#'
#' The key is deliberately broad: every input not known to be styling or
#' bookkeeping is in it, so an input the structure step reads can never be left
#' out (that would show a stale plot); an input that does not affect it costs at
#' most a cache miss. Store-backed values the step reads (axis-limit and colour
#' stores, reactive defaults, the selection) go in `extra`.
#'
#' Set `options(VizModules.cache = FALSE)` to turn caching off.
#'
#' @param r The reactive drawing the plot. It must have no side effects, since a
#'   cache hit skips it: anything it used to write elsewhere must be part of the
#'   value it returns.
#' @param input,session The module's `input` and `session`.
#' @param data The module's `data` reactive.
#' @param extra A function of no arguments returning the other reactive values
#'   `r` reads, or `NULL`.
#' @param params The reactive-defaults store from [setup_reactive_defaults()], or
#'   `NULL`.
#' @param keep Styling ids that `r` reads after all, and so belong in the key.
#' @param output_id The plot's output id, whose resize reports are left out.
#'
#' @return The cached reactive (or `r` itself when caching is off).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_cache_structure
#' @keywords internal
.cache_structure <- function(r, input, session, data, extra = NULL, params = NULL,
                             keep = character(0), output_id = NULL) {
    if (isFALSE(getOption("VizModules.cache", TRUE))) {
        return(r)
    }

    # Hashed once per change of the data rather than on every key evaluation.
    data_hash <- reactive(rlang::hash(data()))
    exclude <- setdiff(.style_input_ids, keep)
    id <- session$ns("structure")

    bindCache(
        r,
        .structure_cache_key(input, id, exclude, output_id, params),
        data_hash(),
        # Read like the step reads them: isolated while Auto Update is off.
        if (is.null(extra)) NULL else if (isTRUE(input$auto.update)) extra() else isolate(extra()),
        cache = "session"
    )
}


#' The structure step's cache key
#'
#' Every module input except the styling ones and the bookkeeping that never
#' changes what is drawn: shinyjqui's widget state, the plot's resize reports,
#' the dragged colorbar position (applied at render time), and the Reset and
#' Update buttons. With Auto Update off, the inputs are read isolated and only
#' the Update button invalidates the key, matching the plot.
#'
#' @inheritParams .cache_structure
#' @param id The module's cache namespace.
#' @param exclude Input ids left out of the key.
#'
#' @return A list for [shiny::bindCache()] to hash.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_structure_cache_key
#' @keywords internal
.structure_cache_key <- function(input, id, exclude, output_id = NULL, params = NULL) {
    read_inputs <- function() {
        vals <- reactiveValuesToList(input)
        nms <- names(vals)
        noise <- grepl("__shinyjquiBookmarkState__", nms, fixed = TRUE) |
            nms %in% c("reset", "update", "colorbar.move")
        if (!is.null(output_id)) {
            noise <- noise | nms %in% paste0(output_id, c("_size", "_is_resizing"))
        }
        keep <- !noise & !(nms %in% exclude)
        vals <- vals[keep]
        if (!is.null(params)) {
            for (key in params$keys) {
                vals[[key]] <- params$get(key)
            }
        }
        vals[order(names(vals))]
    }

    auto <- isTRUE(input$auto.update)
    list(
        id = id,
        inputs = if (auto) read_inputs() else list(input$update, isolate(read_inputs()))
    )
}
