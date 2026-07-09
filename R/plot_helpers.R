# Scale factor applied to the maximum Y value for initial axis range.
# Using a named constant avoids magic numbers scattered across modules.
.y_axis_scale_factor <- 1.11

#' Adjust numeric column values in a data frame using mathematical transformations
#'
#' Applies a named mathematical transformation to a specified numeric column in a data frame,
#' adding the transformed values as a new column (original column name + ".adj").
#' The transformation name must be one of the allowed functions listed in `safe_resolve_adj_fxn`
#' (e.g., "log2", "log10", "sqrt", "abs", "as.factor"). The original data frame is returned unchanged
#' if no transformation is specified or if the supplied name is invalid.
#'
#' @param df A data frame containing the column to be transformed.
#' @param x.col Character scalar. Name of the column for x‑axis values (optional).
#' @param y.col Character scalar. Name of the column for y‑axis values (optional).
#' @param color.col Character scalar. Name of the column for color values (optional).
#' @param x.adj.fun Character scalar. Name of a transformation function to apply to x‑axis values,
#'   as accepted by `safe_resolve_adj_fxn` (e.g., "log2", "log10", "sqrt"). If `NULL` or an empty string,
#'   x‑axis values are left unchanged.
#' @param y.adj.fun Character scalar. Name of a transformation function to apply to y‑axis values,
#'   as accepted by `safe_resolve_adj_fxn`. If `NULL` or an empty string, y‑axis values are left unchanged.
#' @param color.adj.fun Character scalar. Name of a transformation function to apply to color values,
#'   as accepted by `safe_resolve_adj_fxn`. If `NULL` or an empty string, color values are left unchanged.
#'
#' @return A data frame identical to input `df` but with transformed columns added
#'   (e.g., `mpg.adj`) when valid transformations are specified.
#'
#' @examples
#' data(mtcars)
#' mtcars_mod <- adjust_column_values(mtcars, x.col = "mpg", x.adj.fun = "log2")
#' head(mtcars_mod$mpg.adj)
#'
#' @author Jacob Martin, Jared Andrews
#' @export
adjust_column_values <- function(df, x.col = NULL, y.col = NULL, color.col = NULL,
                                  x.adj.fun = NULL, y.adj.fun = NULL, color.adj.fun = NULL) {

  apply_trans <- function(d, cols, adj_name) {
    out <- d

    if (!is.null(adj_name) && nzchar(as.character(adj_name))) {
      adj_fun <- safe_resolve_adj_fxn(adj_name) #Safety check for string input

      if (!is.null(adj_fun)) {
        for (col in cols) {
          if (col %in% names(out) && is.numeric(out[[col]])) {
            out[[paste(col, "adj", sep = ".")]] <- adj_fun(out[[col]])
          }
        }
      }
    }
    return(out)
  }

  df <- apply_trans(df, x.col,       x.adj.fun)
  df <- apply_trans(df, y.col,       y.adj.fun)
  df <- apply_trans(df, color.col,   color.adj.fun)

  return(df)
}


#' Create default Plotly configuration
#'
#' Constructs a configuration list for Plotly plots, enabling interactive
#' editing of titles and legends, export options, and additional drawing tools
#' in the modebar.
#'
#' @param download.format Character. The image format for downloads (e.g., "png", "svg", "jpeg").
#' @param filename Character. The filename for downloaded images (default: current date).
#' @param include.modebar.buttons Logical. Whether to include drawing tool buttons in the modebar (default: TRUE).
#' @param facet.by Logical. Whether the figure is facetted to determine if axes labels for each plot should be editable or not.
#'
#' @return A named list suitable for use as the `config` argument in Plotly
#'   calls, containing edit options, image download settings, extra modebar
#'   buttons, and logo display preferences.
#'
#' @details The configuration enables interactive editing of the
#'   plot title, legend text and position, colorbar position and title, and
#'   annotation tails. It also adds drawing tools (lines, paths, circles,
#'   rectangles, and an eraser) to the modebar. Native cartesian axis-title
#'   text editing is disabled because axis titles are rendered as draggable,
#'   editable annotations (see [axis_titles_as_annotations()] and
#'   `build_facet_annotations()`).
#'
#' @author Jacob Martin
#' @export
#' @examples
#' add_plot_config()
#' add_plot_config(download.format = "svg", include.modebar.buttons = FALSE)
add_plot_config <- function(download.format = "png", filename = as.character(Sys.Date()),
                             include.modebar.buttons = TRUE, facet.by = NULL) {
    if (is.null(facet.by)) {
        config <- list(
            edits = list(
                # Native axis titles are replaced with draggable annotations via
                # axis_titles_as_annotations(), so disable native axis-title text
                # editing to avoid misclicks competing with the annotation titles.
                axisTitleText = FALSE,
                titleText = TRUE,
                annotationText = TRUE,
                legendText = TRUE,
                legendPosition = TRUE,
                colorbarPosition = TRUE,
                colorbarTitleText = TRUE,
                annotationTail = TRUE,
                editText = TRUE,
                editTitle = TRUE,
                annotationPosition = TRUE
            ),
            toImageButtonOptions = list(
                format = download.format,
                filename = filename
            ),
            displaylogo = FALSE
        )
    } else {
        config <- list(
            edits = list(
                axisTitleText = FALSE,
                titleText = TRUE,
                annotationText = TRUE,
                legendText = TRUE,
                legendPosition = TRUE,
                colorbarPosition = TRUE,
                colorbarTitleText = TRUE,
                annotationTail = TRUE,
                annotationPosition = TRUE
            ),
            toImageButtonOptions = list(
                format = download.format,
                filename = filename
            ),
            displaylogo = FALSE
        )
    }
    if (include.modebar.buttons) {
        config$modeBarButtonsToAdd <- list(
            "drawline",
            "drawopenpath",
            "drawclosedpath",
            "drawcircle",
            "drawrect",
            "eraseshape"
        )
    }


    return(config)
}


#' Derive a stable key for a manually-editable annotation
#'
#' Manual edits (drag/text changes) are captured against annotation indices,
#' but those indices shift between rebuilds (e.g. when statistical brackets or
#' reference labels are added/removed). To re-apply edits reliably, annotations
#' are matched by a stable key derived from their content rather than position:
#' draggable axis titles are keyed by axis side, all other annotations by their
#' text. Returns `NULL` for annotations that cannot be keyed.
#'
#' @param ann A single annotation list from `fig$x$layout$annotations`.
#'
#' @return A character key (e.g. `"axis:x"`, `"axis:y"`, or
#'   `"text:Sepal.Length"`), or `NULL` if no stable key applies.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_annotation_edit_key
.annotation_edit_key <- function(ann) {
    if (is.null(ann)) {
        return(NULL)
    }

    if (!is.null(ann$annotationType) && identical(ann$annotationType, "axis")) {
        return(if (!is.null(ann$textangle) && ann$textangle == -90) "axis:y" else "axis:x")
    }

    if (!is.null(ann$text) && nzchar(ann$text)) {
        return(paste0("text:", ann$text))
    }

    NULL
}


#' Build occurrence-disambiguated keys for a list of annotations
#'
#' Several annotations can share the same text (e.g. point labels for repeated
#' categories), which would otherwise collapse to one key and cause a single
#' drag to move every match. This appends a per-key occurrence index so each
#' annotation maps to a distinct, rebuild-stable slot. Order is preserved across
#' rebuilds because annotations are regenerated deterministically.
#'
#' @param anns A list of annotations from `fig$x$layout$annotations`.
#'
#' @return A character vector the same length as `anns`; entries are
#'   `NA` for annotations that cannot be keyed.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_annotation_edit_keys
.annotation_edit_keys <- function(anns) {
    bases <- vapply(anns, function(a) {
        base <- .annotation_edit_key(a)
        if (is.null(base)) NA_character_ else base
    }, character(1))

    keys <- rep(NA_character_, length(bases))
    seen <- list()

    for (i in seq_along(bases)) {
        base <- bases[i]
        if (is.na(base)) next
        prev <- seen[[base]]
        n <- if (is.null(prev)) 1L else prev + 1L
        seen[[base]] <- n
        keys[i] <- paste0(base, "#", n)
    }

    keys
}


#' Capture manual plot edits from a plotly relayout event
#'
#' Reads a `plotly_relayout` event payload and records user-driven
#' repositioning/edits of the legend and annotations (including draggable axis
#' titles) into a persistent list. Annotation entries are keyed via
#' [.annotation_edit_key()] so they survive index shifts on rebuild.
#' Range/zoom and autosize keys are ignored so panning does not pin the axes.
#'
#' @param edits A list with components `legend` and `annotations`
#'   (typically `reactiveValuesToList()` of the module's edit store).
#' @param relayout The named list returned by `event_data("plotly_relayout")`.
#' @param fig The most recently rendered plotly figure, used to map annotation
#'   indices in the event to stable keys.
#'
#' @return The updated `edits` list.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_capture_manual_edits
.capture_manual_edits <- function(edits, relayout, fig) {
    if (is.null(relayout) || length(relayout) == 0) {
        return(edits)
    }

    if (is.null(edits$annotations)) {
        edits$annotations <- list()
    }

    keys <- names(relayout)

    # Legend position/anchors, e.g. "legend.x", "legend.y", "legend.xanchor".
    # Dragging an editable legend emits anchors alongside x/y, so capture them
    # all to reproduce the dropped position faithfully on rebuild.
    legend_keys <- grep("^legend\\.", keys, value = TRUE)
    if (length(legend_keys) > 0) {
        if (is.null(edits$legend)) {
            edits$legend <- list()
        }

        for (k in legend_keys) {
            edits$legend[[sub("^legend\\.", "", k)]] <- relayout[[k]]
        }
    }

    # Continuous-colour legends are colorbars, whose drag emits keys containing
    # ".colorbar.x"/".colorbar.y" (per-trace or via coloraxis). 
    cb_keys <- grep("colorbar\\.(x|y)$", keys, value = TRUE)
    if (length(cb_keys) > 0) {
        if (is.null(edits$colorbar)) {
            edits$colorbar <- list()
        }

        for (k in cb_keys) {
            edits$colorbar[[sub(".*colorbar\\.", "", k)]] <- relayout[[k]]
        }
    }

    # Annotation moves/edits, e.g. "annotations[0].x", "annotations[1].text"
    ann_keys <- grep("^annotations\\[[0-9]+\\]\\.", keys, value = TRUE)
    anns <- if (!is.null(fig)) fig$x$layout$annotations else NULL
    edit_keys <- .annotation_edit_keys(anns)

    for (k in ann_keys) {
        m <- regmatches(k, regexec("^annotations\\[([0-9]+)\\]\\.([a-zA-Z]+)$", k))[[1]]

        if (length(m) != 3) next

        idx <- as.integer(m[2]) + 1L
        prop <- m[3]

        if (is.null(anns) || idx > length(anns)) next

        ann_key <- edit_keys[idx]
        if (is.na(ann_key)) next

        if (is.null(edits$annotations[[ann_key]])) {
            edits$annotations[[ann_key]] <- list()
        }

        edits$annotations[[ann_key]][[prop]] <- relayout[[k]]
    }

    edits
}


#' Re-apply captured manual edits onto a freshly built plotly figure
#'
#' Merges legend position and annotation position/text edits (captured by
#' [.capture_manual_edits()]) into a rebuilt figure so manual layout
#' tweaks persist across re-renders. Annotations are matched by stable key, so
#' edits are preserved even if their order changed.
#'
#' @param fig A plotly figure object.
#' @param edits A list with components `legend` and `annotations`.
#'
#' @return The figure with manual edits re-applied.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_reapply_manual_edits
.reapply_manual_edits <- function(fig, edits) {
    if (is.null(fig) || is.null(edits)) {
        return(fig)
    }

    if (!is.null(edits$legend)) {
        if (is.null(fig$x$layout$legend)) fig$x$layout$legend <- list()
        for (k in names(edits$legend)) {
            fig$x$layout$legend[[k]] <- edits$legend[[k]]
        }
    }

    # Restore a dragged colorbar onto whichever trace/coloraxis carries one.
    if (!is.null(edits$colorbar)) {
        if (!is.null(fig$x$layout$coloraxis$colorbar)) {
            for (k in names(edits$colorbar)) {
                fig$x$layout$coloraxis$colorbar[[k]] <- edits$colorbar[[k]]
            }
        }

        if (!is.null(fig$x$data)) {
            for (i in seq_along(fig$x$data)) {
                if (!is.null(fig$x$data[[i]]$marker$colorbar)) {
                    for (k in names(edits$colorbar)) {
                        fig$x$data[[i]]$marker$colorbar[[k]] <- edits$colorbar[[k]]
                    }
                }
            }
        }
    }

    anns <- fig$x$layout$annotations
    if (!is.null(anns) && length(edits$annotations) > 0) {
        edit_keys <- .annotation_edit_keys(anns)

        for (i in seq_along(anns)) {
            ann_key <- edit_keys[i]
            if (is.na(ann_key)) next
            e <- edits$annotations[[ann_key]]
            if (is.null(e)) next
            for (prop in names(e)) {
                anns[[i]][[prop]] <- e[[prop]]
            }
        }

        fig$x$layout$annotations <- anns
    }

    fig
}


#' Forward colorbar drag events to a Shiny input
#'
#' Continuous-colour legends (colorbars) live on a trace's marker, so dragging
#' one fires a `plotly_restyle` event, which `event_data()` does not
#' expose. This attaches an `onRender` listener that reports the dropped
#' colorbar x/y to a Shiny input so the position can be captured and re-applied
#' across rebuilds.
#'
#' @param fig A plotly figure object.
#' @param input_id Fully namespaced input id to receive the position (a list
#'   with `x`/`y`).
#'
#' @return The figure with the listener attached.
#'
#' @importFrom htmlwidgets onRender JS
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_add_colorbar_listener
.add_colorbar_listener <- function(fig, input_id) {
    if (is.null(fig)) {
        return(fig)
    }

    js <- sprintf(
        "function(el){ el.on('plotly_restyle', function(d){ var u = d[0] || {};
            var x, y;
            for (var k in u) {
                if (k.indexOf('colorbar.x') !== -1) x = u[k];
                if (k.indexOf('colorbar.y') !== -1) y = u[k];
            }
            if (x !== undefined || y !== undefined) {
                Shiny.setInputValue('%s', {x: x, y: y}, {priority: 'event'});
            }
        }); }",
        input_id
    )

    htmlwidgets::onRender(fig, htmlwidgets::JS(js))
}


#' Set up persistent manual plot layout edits across re-renders
#'
#' VizModules plots are fully rebuilt on every input change, which would normally
#' discard any layout tweaks a user made by hand: dragging the legend, moving or
#' editing annotations, repositioning the (draggable) axis titles, or sliding a
#' continuous-colour legend (colorbar). `setup_manual_edits()` together with
#' its companion [finalize_manual_edits()] add this persistence to a
#' plotting module with two short lines of wiring, so manually repositioned
#' elements survive subsequent rebuilds.
#'
#' Call `setup_manual_edits()` **once**, near the top of your module's
#' [shiny::moduleServer()] body, so the observers it registers belong
#' to the module's reactive domain. It creates a reactive store and registers the
#' observers that capture `plotly_relayout` events (legend, annotation, and
#' axis-title drags) plus the JavaScript-forwarded colorbar drag. Then, inside
#' your [plotly::renderPlotly()], pass the freshly built figure through
#' [finalize_manual_edits()] before returning it.
#'
#' @param input The module's `input` object.
#' @param session The module's `session` object.
#' @param plot_source Character scalar. A unique plotly event source id for this
#'   module instance, typically `session$ns("<plot-type>")` (e.g.
#'   `session$ns("scatter")`). It scopes the captured `plotly_relayout`
#'   events to this plot and **must match** the `plot_source` later
#'   passed to [finalize_manual_edits()].
#'
#' @return A list (the "edit store") to hand to [finalize_manual_edits()],
#'   with components:
#'   \describe{
#'     \item{`edits`}{A [shiny::reactiveValues()] holding the
#'       captured `legend`, `annotations`, and `colorbar` edits.}
#'     \item{`rendered_fig`}{A [shiny::reactiveVal()] holding the
#'       most recently rendered figure, used to map relayout annotation indices to
#'       stable, rebuild-proof keys.}
#'   }
#'
#' @section Module wiring (three steps):
#'
#' ```
#' myPlotServer <- function(id, data) {
#'     moduleServer(id, function(input, output, session) {
#'         # 1. Unique event source + edit store (once, near the top).
#'         plot_source <- session$ns("myplot")
#'         edit_store <- setup_manual_edits(input, session, plot_source)
#'
#'         output$myPlot <- renderPlotly({
#'             # 2. Create your plotly plot
#'             fig <- build_my_plotly_figure(data(), input)
#'             # 3. Finalize on the rebuilt figure, then return it.
#'             finalize_manual_edits(fig, plot_source, edit_store, session)
#'         })
#'     })
#' }
#' ```
#'
#' @seealso [finalize_manual_edits()] for the render-step companion.
#' @author Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Call once inside a module server's moduleServer() body:
#' plot_source <- session$ns("myplot")
#' edit_store <- setup_manual_edits(input, session, plot_source)
#' }
setup_manual_edits <- function(input, session, plot_source) {
    edits <- reactiveValues(legend = NULL, annotations = list(), colorbar = NULL)
    rendered_fig <- reactiveVal(NULL)

    observeEvent(event_data("plotly_relayout", source = plot_source), {
        rl <- event_data("plotly_relayout", source = plot_source)
        new <- .capture_manual_edits(reactiveValuesToList(edits), rl, rendered_fig())
        edits$legend <- new$legend
        edits$annotations <- new$annotations
    })

    # Colorbars live on a trace marker, so their drag arrives via JS (see
    # .add_colorbar_listener) rather than the relayout event.
    observeEvent(input$colorbar.move, {
        pos <- input$colorbar.move
        cb <- edits$colorbar %||% list()
        if (!is.null(pos$x)) cb$x <- pos$x
        if (!is.null(pos$y)) cb$y <- pos$y
        edits$colorbar <- cb
    })

    list(edits = edits, rendered_fig = rendered_fig)
}


#' Render persistent manual plot layout edits across re-renders
#'
#' Render-step companion to [setup_manual_edits()]. Call this inside
#' your module's [plotly::renderPlotly()] on the freshly rebuilt
#' figure, immediately before returning it.
#' 
#' It performs four jobs:
#'
#' 1. tags the figure with the module's plotly event `source` so its
#'   `plotly_relayout` events are captured by `setup_manual_edits()`;
#' 2. restores any manually repositioned legend, annotations, axis titles,
#'   and colorbar captured so far;
#' 3. records the figure so future relayout events can be matched to stable
#'   annotation keys (surviving re-ordering on rebuild); and
#' 4. attaches the JavaScript listener that forwards colorbar drags.
#'
#' Restored edits are applied under [shiny::isolate()] so re-applying
#' them never triggers an additional re-render.
#'
#' @param fig A plotly figure object, typically the result of your
#'   plotting pipeline. If `NULL`, it is returned
#'   unchanged.
#' @param plot_source Character scalar. The **same** plotly event source id
#'   passed to [setup_manual_edits()]; assigned to `fig$x$source`.
#' @param store The list returned by [setup_manual_edits()].
#' @param session The module's `session` object, used to namespace the
#'   colorbar drag input.
#'
#' @return The finalized plotly figure, ready to be returned from
#'   [plotly::renderPlotly()].
#'
#' @seealso [setup_manual_edits()] for the setup-step companion.
#' @author Jared Andrews
#' @export
#' @examples
#' \dontrun{
#' # Inside renderPlotly(), after building `fig`:
#' fig <- finalize_manual_edits(fig, plot_source, edit_store, session)
#' fig
#' }
finalize_manual_edits <- function(fig, plot_source, store, session) {
    if (is.null(fig)) {
        return(fig)
    }

    fig$x$source <- plot_source
    fig <- .reapply_manual_edits(fig, isolate(reactiveValuesToList(store$edits)))
    store$rendered_fig(fig)
    .add_colorbar_listener(fig, session$ns("colorbar.move"))
}


#' Calculate axis range from data
#'
#' Computes a numeric range for the Y-axis based on specified columns in a
#' data frame, applying a scaling factor to the maximum value. Handles both
#' simple (non-stacked) and stacked bar scenarios, where stacking occurs when
#' `group.by` or `fill.by` is numeric.
#'
#' @param df Data frame. The data containing the variables to range over.
#' @param data_col_y Character string. Name of the numeric Y-axis data column.
#'   Takes priority over `data_col_x` if both are provided.
#' @param data_col_x Character string. Name of the X-axis data column. Required
#'   when `grouping = TRUE` or `stack_by` is specified, as it defines
#'   the groups over which Y values are summed.
#' @param axis_scale_factor Numeric. Multiplicative factor applied to the
#'   maximum Y value to provide additional headroom on the axis.
#' @param grouping Logical. If `TRUE`, bars are treated as stacked and the
#'   maximum is derived from the sum of Y values within each X group rather than
#'   the raw maximum. Defaults to `FALSE`.
#' @param stack_by Character string or `NULL`. Name of the column used for
#'   stacking (i.e. `group.by` or `fill.by`). When this column is
#'   numeric, bars are stacked and Y values are summed per X category before
#'   computing the maximum. Ignored if `NULL` or if the column is
#'   categorical. Defaults to `NULL`.
#'
#' @return A named list with components `min` and `max` giving the
#'   lower and upper limits for the Y-axis, or `NULL` if any required
#'   column is missing, non-numeric, or otherwise invalid.
#'
#' @details
#' The function resolves the primary data column from `data_col_y` or
#' `data_col_x` and validates that it exists and is numeric in `df`.
#'
#' Behaviour depends on whether bars are stacked:
#'
#' - **Non-stacked** (`grouping = FALSE`, categorical or absent
#'   `stack_by`): the Y range is computed directly from the raw column
#'   values using `min()` and `max()`.
#' - **Stacked** (`grouping = TRUE` or `stack_by` is
#'   numeric): Y values are summed within each unique X category using
#'   `tapply()`, and the maximum of those sums is used. The minimum is
#'   fixed at 0 since stacked bars always originate from zero.
#'
#' Non-finite results (e.g. from empty or all-`NA` columns) are replaced
#' with default values of 0 for the minimum and 1 for the maximum.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_calculate_range
.calculate_range <- function(df, data_col_x = NULL, data_col_y = NULL,
                             axis_scale_factor, grouping = FALSE,
                             stack_by = NULL) {
    # Resolve primary data column
    data_col <- if (!is.null(data_col_y)) data_col_y else data_col_x

    # Basic guards
    if (is.null(data_col) || !nzchar(data_col)) {
        return(NULL)
    }
    if (!data_col %in% names(df)) {
        return(NULL)
    }
    if (!is.numeric(df[[data_col]])) {
        return(NULL)
    }

    if (!grouping) {
        # --- Non-stacked: bars are NOT stacked, just find the max single value ---
        # If stack_by is provided and numeric, bars ARE stacked → sum per x group
        if (!is.null(stack_by) && stack_by %in% names(df) && is.numeric(df[[stack_by]])) {
            # Numeric stack_by: stacked bars, sum y per x category
            if (is.null(data_col_x) || !data_col_x %in% names(df)) {
                return(NULL)
            }
            x_sums <- tapply(df[[data_col]], df[[data_col_x]], function(v) sum(v, na.rm = TRUE))
            max_val <- max(x_sums, na.rm = TRUE) * axis_scale_factor
            min_val <- 0
        } else {
            # Categorical or no stack_by: bars dodged/ungrouped, max of raw values
            max_val <- max(df[[data_col]], na.rm = TRUE) * axis_scale_factor
            min_val <- min(df[[data_col]], na.rm = TRUE)
        }

        if (!is.finite(min_val)) min_val <- 0
        if (!is.finite(max_val)) max_val <- 1

        return(list(min = min_val, max = max_val))
    } else {
        # --- Stacked grouping: sum y values per x group ---
        if (is.null(data_col_x) || !data_col_x %in% names(df)) {
            return(NULL)
        }
        x_sums <- tapply(df[[data_col]], df[[data_col_x]], function(v) sum(v, na.rm = TRUE))
        max_val <- max(x_sums, na.rm = TRUE) * axis_scale_factor
        min_val <- 0

        if (!is.finite(max_val)) max_val <- 1

        return(list(min = min_val, max = max_val))
    }
}


#' Create an empty ggplot2 plot or plotly plot with input text
#'
#' This function creates an empty ggplot2 or plotly plot and places a user-provided text
#' string in the middle of the plot.
#'
#' @param text Character scalar to show in plot area.
#' @param plotly Boolean indicating whether to return a plotly object.
#' @return Either a ggplot object or a plotly object if `plotly = TRUE`.
#'
#' @importFrom ggplot2 theme_void geom_text theme margin ggplot aes
#' @importFrom plotly ggplotly layout
#'
#' @author Jared Andrews
#'
#' @seealso [ggplot2::geom_text()], [ggplot2::theme_void()]
#' @export
#' @examples
#' library(VizModules)
#' empty_plot("No data to display")
empty_plot <- function(text = NULL, plotly = FALSE) {
    if (length(text) > 1) {
        text <- paste(text, collapse = "\n")
    }

    plot <- ggplot() +
        theme_void() +
        theme(plot.margin = margin(1, 1, 1, 1, "cm")) +
        geom_text(aes(x = 0.5, y = 0.5, label = text),
            inherit.aes = FALSE, check_overlap = TRUE
        )

    if (plotly) {
        plot <- ggplotly(plot)
        plot <- plot |> layout(
            xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, showline = FALSE),
            yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, showline = FALSE),
            plot_bgcolor = "white",
            showlegend = FALSE,
            autosize = TRUE,
            margin = list(l = 0, r = 0, b = 0, t = 0)
        )
    }

    plot
}


#' Check if column inputs contain mixed data types
#'
#' This function validates that a vector of column names from a data frame contains
#' columns of only one data type category: either all numeric OR all categorical
#' (factor/character). Returns `FALSE` for mixed numeric + categorical columns.
#' Single columns always return `TRUE`. Used for Shiny plotting module input validation.
#'
#' @param inputs Character vector of column names to validate.
#' @param d Data frame containing the columns specified in `inputs`.
#'
#' @return Logical scalar: `TRUE` if all numeric OR all categorical (factor/character);
#'   `FALSE` if mixed numeric + categorical/factor detected.
#'
#' @author Jacob Martin
#'
#' @examples
#' df <- data.frame(num1 = 1:3, num2 = 4:6, cat1 = letters[1:3], fac1 = factor(1:3))
#' is_pure_type(c("num1", "num2"), df) # TRUE (all numeric)
#' is_pure_type(c("cat1", "fac1"), df) # TRUE (all categorical)
#' is_pure_type(c("num1"), df) # TRUE (single)
#' is_pure_type(c("num1", "cat1"), df) # FALSE (mixed numeric + cat)
#'
#' @rdname is_pure_type
#' @seealso [base::for()]
#' @export
is_pure_type <- function(inputs, d) {
    cols <- inputs[nzchar(inputs) & inputs %in% names(d)]

    # Single column or empty always pure
    if (length(cols) <= 1) {
        return(TRUE)
    }

    # Classify first column to establish reference type
    first_col <- d[[cols[1]]]
    ref_type <- if (is.numeric(first_col)) {
        "numeric"
    } else if (is.factor(first_col) || is.character(first_col)) "categorical"

    # Check all remaining columns match reference
    for (i in 2:length(cols)) {
        col <- d[[cols[i]]]
        col_type <- if (is.numeric(col)) {
            "numeric"
        } else if (is.factor(col) || is.character(col)) "categorical"

        if (col_type != ref_type) {
            return(FALSE)
        }
    }

    TRUE
}


#' Add multi-axis traces to a plotly figure
#'
#' Appends scatter traces for each element of a multi-valued `x` or
#' multi-valued `y` vector to an existing plotly figure.
#' Handles data ordering, line/marker styling, and palette colouring.
#'
#' @param fig A plotly figure object to add traces to.
#' @param data A data.frame containing the plot data.
#' @param x Character vector of x-column name(s).
#' @param y Character vector of y-column name(s).
#' @param order.cols Character vector of column name(s) used to sort trace
#'   data before plotting.
#' @param plot.mode Character, plotly scatter mode (e.g. `"lines"`,
#'   `"markers"`, `"lines+markers"`).
#' @param line.type Character, plotly dash style for lines.
#' @param palette.selection Character vector of hex colours.
#' @param show.legend Logical, whether traces should appear in the legend.
#'   Default: `TRUE`.
#'
#' @return The modified plotly figure with added traces.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_add_multi_axis_traces
#' @keywords internal
.add_multi_axis_traces <- function(fig, data, x, y, order.cols, plot.mode,
                                   line.type, palette.selection,
                                   show.legend = TRUE) {
    .add_traces_for <- function(iter_var, fixed_var, is_x_multi) {
        for (i in seq_along(iter_var)) {
            trace_data <- data

            sort_column <- order.cols[1]
            if (!is.null(order.cols) && length(order.cols) >= i &&
                order.cols[i] %in% names(trace_data)) {
                sort_column <- order.cols[i]
            }
            if (!is.null(sort_column) && sort_column %in% names(trace_data)) {
                trace_data <- trace_data[order(trace_data[[sort_column]]), ]
            }

            if (is_x_multi) {
                xvals <- trace_data[[iter_var[i]]]
                yvals <- trace_data[[fixed_var[1]]]
                trace_name <- iter_var[i]
            } else {
                xvals <- trace_data[[fixed_var[1]]]
                yvals <- trace_data[[iter_var[i]]]
                trace_name <- iter_var[i]
            }

            trace_params <- list(
                x = xvals,
                y = yvals,
                type = "scatter",
                mode = plot.mode,
                name = trace_name,
                showlegend = show.legend
            )

            if (plot.mode %in% c("lines", "lines+markers")) {
                trace_params$line <- list(
                    dash = line.type,
                    color = palette.selection[i]
                )
            }
            if (plot.mode %in% c("markers", "lines+markers")) {
                trace_params$marker <- list(color = palette.selection[i])
            }

            fig <<- do.call(plotly::add_trace, c(list(fig), trace_params))
        }
    }

    if (length(x) > 1) {
        .add_traces_for(x, y, is_x_multi = TRUE)
    }
    if (length(y) > 1) {
        .add_traces_for(y, x, is_x_multi = FALSE)
    }

    fig
}


