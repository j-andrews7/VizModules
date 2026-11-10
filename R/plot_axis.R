#' Apply axis styling to all subplot axes in a plotly figure
#'
#' When using plotly subplots (e.g., via split.by in dittoViz), axis styling
#' must be applied to all subplot axes (xaxis, xaxis2, xaxis3, etc.) individually.
#' This helper function detects how many subplots exist and applies the provided
#' axis styling to all of them.
#'
#' @param fig A plotly figure object.
#' @param xaxis_style A named list of axis styling parameters for x-axes.
#' @param yaxis_style A named list of axis styling parameters for y-axes.
#'
#' @return The modified plotly figure with axis styling applied to all subplots.
#'
#' @details
#' The styling is queued with [plotly::layout()], which merges it into each
#' axis when the figure is built, so the axes' other properties (range, domain,
#' title text, ...) are kept. Only the styling is queued, never a copy of the
#' axis as it stands, so a property written to the figure's layout after this
#' call (such as a range raised by [apply_stat_annotations()]) is not reverted
#' at build time.
#'
#' Axes recorded as belonging to overlay panels drawn beside the plot, such as
#' the marginal distributions [add_marginal_plots()] adds, are left alone.
#'
#' @importFrom utils modifyList
#'
#' @author Jared Andrews
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#' xaxis_style <- list(showline = TRUE, linecolor = "black", linewidth = 1)
#' yaxis_style <- list(showline = TRUE, linecolor = "black", linewidth = 1)
#' apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)
apply_subplot_axis_styling <- function(fig, xaxis_style, yaxis_style) {
    # Extract the layout to determine how many subplots exist
    if (is.null(fig) || is.null(fig$x) || is.null(fig$x$layout)) {
        return(fig)
    }

    layout_names <- names(fig$x$layout)

    # Handle empty layout
    if (is.null(layout_names) || length(layout_names) == 0) {
        return(fig)
    }

    # Find all xaxis and yaxis entries (xaxis, xaxis2, xaxis3, etc.)
    xaxis_names <- grep("^xaxis[0-9]*$", layout_names, value = TRUE)
    yaxis_names <- grep("^yaxis[0-9]*$", layout_names, value = TRUE)

    # If no subplot x-axes detected, apply to main xaxis
    if (length(xaxis_names) == 0) {
        xaxis_names <- "xaxis"
    }

    # If no subplot y-axes detected, apply to main yaxis
    if (length(yaxis_names) == 0) {
        yaxis_names <- "yaxis"
    }

    # Axes of overlay panels drawn beside the plot (marginal distributions) keep
    # the styling they were drawn with.
    overlay <- fig$x$.vizmodules_overlay_axes
    xaxis_names <- setdiff(xaxis_names, overlay)
    yaxis_names <- setdiff(yaxis_names, overlay)

    # Build a list of layout updates. Only the styling is queued: plotly_build()
    # merges queued updates recursively into the existing axis, so its other
    # properties survive anyway. Queuing a copy of the whole axis instead would
    # freeze it as it stands now, and at build time that copy would overwrite
    # anything written to the layout since (e.g. the range raised to fit
    # significance brackets).
    layout_updates <- list()

    # A NULL in the style (an input that has not reported) means "leave this
    # alone"; queued as is, the recursive merge would delete the property instead.
    drop_nulls <- function(x) {
        if (!is.list(x)) {
            return(x)
        }
        x <- lapply(x, drop_nulls)
        x[!vapply(x, is.null, logical(1))]
    }
    xaxis_style <- drop_nulls(xaxis_style)
    yaxis_style <- drop_nulls(yaxis_style)

    # Apply x-axis styling to all x-axes
    for (xaxis_name in xaxis_names) {
        layout_updates[[xaxis_name]] <- xaxis_style
    }

    # Apply y-axis styling to all y-axes. Matched subplot axes (yaxis2 with
    # matches = "y", ...) get the full style too, border properties included, so
    # plotly draws their axis lines rather than hiding them.
    for (yaxis_name in yaxis_names) {
        layout_updates[[yaxis_name]] <- yaxis_style
    }

    # Apply all updates at once using do.call
    fig <- do.call(plotly::layout, c(list(p = fig), layout_updates))

    fig
}

#' Convert native cartesian axis titles to draggable annotations
#'
#' Plotly's native axis titles can have their text edited interactively but
#' cannot be dragged to a new position. Faceted figures already render their
#' shared x/y axis titles as paper-anchored annotations (via
#' `build_facet_annotations()`), which the plot configuration makes
#' both editable and draggable. This helper brings the same behaviour to
#' single-panel (non-faceted) figures by replacing the native x/y axis titles
#' with equivalent paper-anchored annotations.
#'
#' The figure is first built with `plotly::plotly_build()` so that titles
#' assigned via `layout()` (which are otherwise held in
#' `layoutAttrs` until build time) are consolidated into the layout. Any
#' pre-existing annotations (for example statistical brackets or facet labels)
#' are preserved, and the font already applied to each native axis title is
#' carried over to the corresponding annotation.
#'
#' Multi-panel figures (faceting or `split.by`, detected by the presence
#' of secondary axes such as `xaxis2`/`yaxis2`) are returned
#' unchanged, since their shared titles are already draggable annotations.
#'
#' @param fig A plotly figure object.
#'
#' @return The plotly figure with single-panel axis titles converted to
#'   paper-anchored, draggable annotations. Returns the figure unchanged when
#'   it is faceted/split or has no axis titles.
#'
#' @author Jared Andrews
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#' fig <- plotly::layout(fig, xaxis = list(title = "Weight"), yaxis = list(title = "MPG"))
#' axis_titles_as_annotations(fig)
axis_titles_as_annotations <- function(fig) {
    if (is.null(fig)) {
        return(fig)
    }

    # Build so that titles set via layout() (held in layoutAttrs) are
    # consolidated into fig$x$layout. Skipped when nothing is queued.
    fig <- .ensure_built(fig)

    if (is.null(fig$x) || is.null(fig$x$layout)) {
        return(fig)
    }

    # Overlay panels drawn beside the plot (marginal distributions) are not facets.
    layout_names <- setdiff(names(fig$x$layout), fig$x$.vizmodules_overlay_axes)

    # Multi-panel (faceted / split) figures already render their shared axis
    # titles as draggable annotations, so leave them untouched.
    has_secondary_axes <- any(grepl("^xaxis[2-9][0-9]*$", layout_names)) ||
        any(grepl("^yaxis[2-9][0-9]*$", layout_names))
    if (has_secondary_axes) {
        return(fig)
    }

    extract <- function(title) {
        if (is.null(title)) {
            return(list(text = NULL, font = NULL))
        }
        if (is.character(title)) {
            return(list(text = title, font = NULL))
        }
        if (is.list(title)) {
            return(list(text = title$text, font = title$font))
        }
        list(text = NULL, font = NULL)
    }

    x_axis <- extract(fig$x$layout$xaxis$title)
    y_axis <- extract(fig$x$layout$yaxis$title)

    has_x <- !is.null(x_axis$text) && nzchar(x_axis$text)
    has_y <- !is.null(y_axis$text) && nzchar(y_axis$text)
    if (!has_x && !has_y) {
        return(fig)
    }

    # Clear native titles so they do not render alongside the annotations.
    if (!is.null(fig$x$layout$xaxis)) {
        fig$x$layout$xaxis$title <- list(text = "")
    }

    if (!is.null(fig$x$layout$yaxis)) {
        fig$x$layout$yaxis$title <- list(text = "")
    }

    new_anns <- list()

    # Centred on the plot panel, which overlay panels beside it can narrow.
    centre <- function(domain) {
        d <- suppressWarnings(as.numeric(unlist(domain)))
        if (length(d) == 2 && all(is.finite(d))) mean(d) else 0.5
    }

    if (has_x) {
        new_anns[[length(new_anns) + 1L]] <- list(
            x = centre(fig$x$layout$xaxis$domain), y = -0.1, xref = "paper", yref = "paper",
            text = x_axis$text, showarrow = FALSE, xanchor = "center",
            yanchor = "top", annotationType = "axis", font = x_axis$font
        )
    }

    if (has_y) {
        new_anns[[length(new_anns) + 1L]] <- list(
            x = -0.05, y = centre(fig$x$layout$yaxis$domain), xref = "paper", yref = "paper",
            text = y_axis$text, showarrow = FALSE, xanchor = "center",
            yanchor = "middle", textangle = -90, annotationType = "axis",
            font = y_axis$font
        )
    }

    existing <- fig$x$layout$annotations

    if (is.null(existing)) {
        existing <- list()
    }

    fig$x$layout$annotations <- c(existing, new_anns)

    fig
}


#' Build a plotly axis title spec carrying its font
#'
#' Plot functions that set an axis title as a bare string leave it without a font, so
#' [axis_titles_as_annotations()] has nothing to carry over to the draggable annotation. This
#' returns the `list(text, font)` form instead, omitting `text` when it is `NULL` so no
#' empty title is serialised.
#'
#' @param text Character scalar or `NULL`. The axis title text.
#' @param font Named list of plotly font properties (`size`, `color`, `family`).
#'
#' @return A named list suitable for a plotly axis `title`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_axis_title_spec
#' @keywords internal
.axis_title_spec <- function(text, font) {
    if (is.null(text)) {
        return(list(font = font))
    }
    list(text = text, font = font)
}


#' Build an adjustment-aware axis label
#'
#' Wraps a base column name with the names of any data adjustments that are
#' applied to it before plotting, so that an axis title accurately describes the
#' values displayed. The wrapping order mirrors how the modules apply the
#' adjustments (the `adj.fxn` first, then the recognized `adjustment` rescales
#' the result), producing labels such as `"z-score(log2(units))"`.
#'
#' Empty strings, `NA`, and `NULL` adjustments are ignored, so when no
#' adjustment is requested the base label is returned unchanged.
#'
#' @param base Character scalar. The base axis label (typically the column name).
#' @param adjustment Character scalar. A recognized data adjustment such as
#'   `"z-score"` or `"relative.to.max"`. Optional.
#' @param adj.fxn Character scalar. The name of a transformation function such as
#'   `"log2"` or `"sqrt"`. Optional.
#'
#' @return A character scalar containing the (possibly wrapped) axis label.
#'
#' @author Jared Andrews
#' @export
#' @examples
#' adjusted_axis_label("units")
#' adjusted_axis_label("units", adjustment = "z-score")
#' adjusted_axis_label("units", adjustment = "z-score", adj.fxn = "log2")
adjusted_axis_label <- function(base, adjustment = NULL, adj.fxn = NULL) {
    if (is.null(base) || length(base) == 0 || is.na(base[1]) || !nzchar(base[1])) {
        return(base)
    }

    label <- base[1]

    is_set <- function(x) {
        !is.null(x) && length(x) > 0 && !is.na(x[1]) && nzchar(as.character(x[1]))
    }

    if (is_set(adj.fxn)) {
        label <- paste0(adj.fxn[1], "(", label, ")")
    }
    if (is_set(adjustment)) {
        label <- paste0(adjustment[1], "(", label, ")")
    }

    label
}


#' Create Plotly axis style list
#'
#' Constructs a style list for a Plotly axis using values from a Shiny
#' `input` object, including title font, axis lines, tick
#' appearance, and gridline settings.
#'
#' @param input Shiny input object. Expected to contain axis-related fields
#'   such as `title.font.family`, `text.colour`, `axis.showline`,
#'   `axis.mirror`, `axis.linecolor`, `axis.linewidth`,
#'   `axis.tickfont.size`, `axis.tickfont.color`,
#'   `axis.tickfont.family`, `axis.tickangle.x`,
#'   `axis.tickangle.y`, `axis.ticks`, `axis.tickcolor`,
#'   `axis.ticklen`, `axis.tickwidth`, `show.grid.x`,
#'   `show.grid.y`, and `grid.color`.
#' @param axis_side Character. Which axis to style, either `"x"` or
#'   `"y"`. Determines whether `axis.tickangle.x` or
#'   `axis.tickangle.y` is used for the tick angle, and which
#'   gridline inputs are applied.
#' @param isolate_fn Function. A function used to isolate Shiny inputs,
#'   typically `shiny::isolate`. Defaults to `isolate`.
#' @param ggplot.axis.styling Logical. Whether ggplot axis styling is applied.
#'   Defaults to `TRUE`.
#' @return A named list containing Plotly-compatible axis styling
#'   components, including title font, line properties, tick label
#'   formatting, and gridline visibility.
#'
#' @details The function collects axis- and font-related settings from
#'   the provided `input` object and assembles them into a list
#'   suitable for use as an axis specification in Plotly layouts. The
#'   tick angle and gridline visibility are chosen based on the value
#'   of `axis_side`. If gridline inputs are not present in the
#'   input object, defaults to showing gridlines.
#'
#' @author Jacob Martin
#' @export
#' @examples
#' # Build a fake input list and use identity as the isolate function
#' input <- list(
#'     axis.title.font.size = 14, axis.title.font.family = "Arial",
#'     axis.title.font.color = "black", axis.tickfont.size = 10,
#'     axis.tickfont.color = "black", axis.tickfont.family = "Arial",
#'     axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
#'     axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1,
#'     show.grid.x = TRUE, show.grid.y = TRUE, grid.color = "grey90"
#' )
#' create_axis_styles(input, axis_side = "x", isolate_fn = identity)
create_axis_styles <- function(input, axis_side = c("x", "y"), isolate_fn = isolate, ggplot.axis.styling = TRUE) {
    axis_side <- match.arg(axis_side)

    # Determine gridline visibility based on axis side
    # Use defaults if inputs are not present (for backwards compatibility)
    show_grid <- ifelse(axis_side == "x",
        isolate_fn(input$show.grid.x),
        isolate_fn(input$show.grid.y)
    )
    style <- list(
        title = list(
            font = list(
                size   = isolate_fn(input$axis.title.font.size),
                family = isolate_fn(input$axis.title.font.family),
                color  = isolate_fn(input$axis.title.font.color)
            )
        ),
        tickfont = list(
            size   = isolate_fn(input$axis.tickfont.size),
            color  = isolate_fn(input$axis.tickfont.color),
            family = isolate_fn(input$axis.tickfont.family)
        ),
        tickangle = ifelse(axis_side == "x",
            isolate_fn(input$axis.tickangle.x),
            isolate_fn(input$axis.tickangle.y)
        ),
        ticks = isolate_fn(input$axis.ticks),
        tickcolor = isolate_fn(input$axis.tickcolor),
        ticklen = isolate_fn(input$axis.ticklen),
        tickwidth = isolate_fn(input$axis.tickwidth),
        showgrid = show_grid,
        gridcolor = isolate_fn(input$grid.color)
    )
    if (!ggplot.axis.styling) {
        style$showline <- isolate_fn(input$axis.showline)
        style$mirror <- isolate_fn(input$axis.mirror)
        style$linecolor <- isolate_fn(input$axis.linecolor)
        style$linewidth <- isolate_fn(input$axis.linewidth)
    }

    return(style)
}


#' Create ggplot axis styling theme arguments
#'
#' Creates ggplot2 theme arguments for axis borders and lines based on user inputs.
#' This function handles axis styling through ggplot2 themes rather than plotly overlays,
#' which provides better control especially when faceting is used.
#'
#' When faceting is enabled, panel borders are always shown for the full plot.
#' When faceting is disabled:
#' - If both axis.showline and axis.mirror are TRUE: Full panel border
#' - If only axis.showline is TRUE: Axis lines on x and y axes only
#' - Otherwise: No borders
#'
#' @param input Shiny input object containing axis styling parameters.
#' @param isolate_fn Function to use for isolating reactive values (default: isolate).
#'
#' @return A named list of ggplot2 theme arguments to be passed to theme_args parameter.
#'
#' @importFrom ggplot2 element_rect element_line element_blank
#'
#' @author Jacob Martin
#' @export
#' @examples
#' input <- list(
#'     axis.showline = TRUE, axis.mirror = TRUE,
#'     axis.linecolor = "black", axis.linewidth = 1
#' )
#' create_ggplot_axis_style(input, isolate_fn = identity)
create_ggplot_axis_style <- function(input, isolate_fn = isolate) {
    if (isolate_fn(input$axis.showline) && isolate_fn(input$axis.mirror)) {
        # Return full axis border when both show line and mirror are on
        theme_args <- list(
            panel.border = ggplot2::element_rect(
                colour = isolate_fn(input$axis.linecolor),
                fill = NA,
                linewidth = isolate_fn(input$axis.linewidth)
            ),
            axis.line = element_blank(),
            axis.ticks = element_blank()
        )
    } else if (isolate_fn(input$axis.showline) && !isolate_fn(input$axis.mirror)) {
        # Set it so the axis line is only shown on x and y axis
        theme_args <- list(
            axis.line = ggplot2::element_line(
                colour = isolate_fn(input$axis.linecolor),
                linewidth = isolate_fn(input$axis.linewidth)
            ),
            panel.border = element_blank(),
            axis.ticks = element_blank()
        )
    } else {
        # No borders when axis.showline is FALSE
        theme_args <- list(
            panel.border = element_blank(),
            axis.line = element_blank(),
            axis.ticks = element_blank()
        )
    }
    return(theme_args)
}

#' Apply axis title font styling to shared facet axis annotations
#'
#' When ggplotly converts a faceted ggplot, shared axis titles become
#' annotations rather than axis title properties. This function finds
#' those shared title annotations and applies the user's axis title
#' font settings to them.
#'
#' @param fig A plotly figure object.
#' @param input Shiny input object containing axis title font fields.
#' @param isolate_fn Function to isolate reactive values. Defaults to
#'   `shiny::isolate`.
#'
#' @return The modified plotly figure with updated annotation fonts.
#'
#' @author Jacob Martin
#' @export
#' @examples
#' \dontrun{
#' p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
#'     ggplot2::geom_point() +
#'     ggplot2::facet_wrap(~cyl)
#' fig <- plotly::ggplotly(p)
#' input <- list(
#'     axis.title.font.size = 14, axis.title.font.family = "Arial",
#'     axis.title.font.color = "black", facet.title.font.size = 12,
#'     facet.title.font.family = "Arial", facet.title.font.color = "black"
#' )
#' apply_axis_title_to_annotations(fig, input, isolate_fn = identity)
#' }
apply_axis_title_to_annotations <- function(fig, input, isolate_fn = isolate) {
    annotations <- fig$x$layout$annotations
    if (is.null(annotations) || length(annotations) == 0) {
        return(fig)
    }

    axis_font <- list(
        size   = isolate_fn(input$axis.title.font.size),
        family = isolate_fn(input$axis.title.font.family),
        color  = isolate_fn(input$axis.title.font.color)
    )

    facet_font <- list(
        size   = isolate_fn(input$facet.title.font.size),
        family = isolate_fn(input$facet.title.font.family),
        color  = isolate_fn(input$facet.title.font.color)
    )

    for (i in seq_along(annotations)) {
        ann <- annotations[[i]]

        # Skip annotations that aren't paper-referenced
        if (is.null(ann$xref) || ann$xref != "paper" ||
            is.null(ann$yref) || ann$yref != "paper") {
            next
        }



        # Shared Y-axis title: near left of plot, rotated -90
        is_axis <- !is.null(ann$annotationType) && ann$annotationType == "axis"

        if (is_axis) {
            fig$x$layout$annotations[[i]]$font <- axis_font
        }
        # identical(): an annotation without an xanchor is not a facet title,
        # and `NULL == "center"` would make this condition an error.
        is_facet_title <- is.null(ann$annotationType) && identical(ann$xanchor, "center")
        if (is_facet_title){
            fig$x$layout$annotations[[i]]$font <- facet_font
        }
    }

    fig
}


#' Apply plot title styling to a plotly figure
#'
#' Applies title font settings from the Shiny input object to an
#' existing plotly figure. The title is centered horizontally and
#' positioned using the supplied `title_y` value in the plotly
#' layout.
#'
#' @param plot A plotly figure object.
#' @param input Shiny input object containing title font fields.
#' @param isolate_fn Function to isolate reactive values.
#' @param title_y Numeric y position for the plot title in the plotly
#'   layout. Defaults to `0.95`. 
#' @param title_x Numeric position for the title in the plotly layout.
#' @return The modified plotly figure with updated title styling.
#'
#' @author Jacob Martin
#' @export
#' @examples
#' \dontrun{
#' p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) + ggplot2::geom_point()
#' input <- list(
#'     title.font.size = 16, title.font.family = "Arial", title.font.color = "black"
#' )
#' apply_title_layout(p, input, isolate_fn = identity)
#' }
apply_title_layout <- function(plot, input, isolate_fn, title_y = 0.95, title_x = 0.5){
    fig <- ggplotly(plot) |> 
        layout(
            title = list(
                font = list(
                    size = isolate_fn(input$title.font.size),
                    family = isolate_fn(input$title.font.family),
                    color = isolate_fn(input$title.font.color)
                ),
                x = title_x, xanchor = "center", y = title_y, yanchor = "top"
            )
        )
    return(fig)
}


#' Apply standard render-time margin layout to a plotly figure
#'
#' The `renderPlotly` block in every plot module server applies the same
#' user-configurable margins. This helper extracts that block into one call.
#'
#' @param fig A plotly figure object.
#' @param input Shiny input object. Expected to contain `margin.t`,
#'   `margin.b`, `margin.l`, and `margin.r`.
#'
#' @return The plotly figure with margins applied.
#'
#' @author Jacob Martin
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#' input <- list(margin.t = 40, margin.b = 40, margin.l = 40, margin.r = 40)
#' apply_render_margins(fig, input)
apply_render_margins <- function(fig, input) {
    fig |>
        layout(
            margin = list(
                t = input$margin.t,
                b = input$margin.b,
                l = input$margin.l,
                r = input$margin.r,
                autoexpand = TRUE
            )
        )
}




#' Set the notation of a figure's numeric tick labels
#'
#' Tick labels of large or small numbers can come out in scientific notation
#' (`1e+05`) or not depending only on which breaks an axis happens to get, since
#' a ggplot converted with [plotly::ggplotly()] carries the labels R's
#' [format()] gave its breaks as fixed tick text. This sets the notation
#' explicitly instead, for every x and y axis of the figure.
#'
#' Fixed tick text is rewritten only on axes whose labels are all numbers that
#' match the tick positions (or are 10, 2, or e raised to them, for a log scale),
#' so categorical axes, even ones whose categories look like numbers, and
#' formatted labels (`"25%"`, `"$1,000"`) are left alone. With
#' `scientific = FALSE`, only labels already in scientific notation are rewritten;
#' with `TRUE`, every numeric label is written as a power of ten (1.5 times 10 to the 5th).
#' Axes plotly labels itself get `exponentformat = "power"` when `scientific` is
#' `TRUE`, and are otherwise left to plotly, whose default abbreviates large
#' numbers (`100k`) rather than using scientific notation.
#'
#' Axes marked with [mark_overlay_axes()] are left alone.
#'
#' @param fig A plotly figure.
#' @param scientific Logical. Whether numeric tick labels use scientific
#'   notation. Default `FALSE`.
#'
#' @return The built plotly figure with its tick labels updated.
#'
#' @seealso [apply_uniform_styling()], which applies this from the Axes tab's
#'   "Scientific Notation Ticks" input.
#'
#' @author Jared Andrews
#' @export
#' @examples
#' p <- ggplot2::ggplot(data.frame(x = c("a", "b"), y = c(1e5, 3e5)), ggplot2::aes(x, y)) +
#'     ggplot2::geom_col()
#' fig <- plotly::ggplotly(p)
#' apply_tick_notation(fig)$x$layout$yaxis$ticktext
#' apply_tick_notation(fig, scientific = TRUE)$x$layout$yaxis$ticktext
apply_tick_notation <- function(fig, scientific = FALSE) {
    if (is.null(fig)) {
        return(fig)
    }
    scientific <- isTRUE(scientific)
    fig <- .ensure_built(fig)

    for (name in .styled_axis_names(fig)) {
        ax <- fig$x$layout[[name]]
        if (length(ax$ticktext)) {
            nums <- .numeric_tick_labels(ax$ticktext, ax$tickvals)
            if (is.null(nums)) {
                next
            }
            if (scientific) {
                fig$x$layout[[name]]$ticktext <- .power_labels(nums)
            } else if (any(grepl("[0-9][eE][+-]?[0-9]", unlist(ax$ticktext)))) {
                fig$x$layout[[name]]$ticktext <- format(nums, scientific = FALSE, trim = TRUE, drop0trailing = TRUE)
            }
        } else if (scientific && !isTRUE(ax$type %in% c("category", "multicategory", "date"))) {
            fig$x$layout[[name]]$exponentformat <- "power"
            fig$x$layout[[name]]$showexponent <- "all"
        }
    }
    fig
}


#' Set the padding between a figure's data and the edges of its plot area
#'
#' Sets each x and y axis range to the extent of the data drawn on it, widened
#' at each end by a fraction of that extent: `0` makes the data fill the plot
#' area, `0.05` matches ggplot2's default expansion. The extent is read from the
#' figure's traces as drawn: points and lines, bars from their base, error bars,
#' and fills down to zero. A categorical axis (as [plotly::ggplotly()] draws one)
#' spans its categories' bands, each one unit wide, so `0` puts the outer bands'
#' edges on the plot area's.
#'
#' Axes that share a scale (matched axes, or the identical ranges of a faceted
#' plot's fixed scales) get the same range, so they still line up. Reversed axes
#' stay reversed, and log axes are padded in log units. Axes holding dates or
#' plotly categories, or with no numeric data on them, are left alone, as are
#' axes marked with [mark_overlay_axes()].
#'
#' Only what the traces draw counts. Annotations and shapes, such as
#' significance brackets or reference lines, do not widen the range and can be
#' cut off, so use axis limits instead on an axis that carries them.
#'
#' @param fig A plotly figure.
#' @param x,y Padding for the x and y axes, as a fraction of the data's extent
#'   added at each end. `NULL` or `NA` leaves that axis as it is.
#' @param swap Logical. Apply `x` to the figure's y axes and `y` to its x axes,
#'   for a plot drawn with its axes swapped (a rotated or flipped plot), so the
#'   padding follows the variable rather than the screen direction.
#'
#' @return The built plotly figure with the axis ranges set.
#'
#' @seealso [apply_uniform_styling()], which applies this from the Axes tab's
#'   "X Axis Padding" and "Y Axis Padding" inputs.
#'
#' @author Jared Andrews
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars,
#'     x = ~wt, y = ~mpg, type = "scatter", mode = "markers"
#' )
#' # Points reaching the edges of the plot area.
#' apply_axis_padding(fig, x = 0, y = 0)$x$layout$xaxis$range
#'
#' # A ggplot area plot with its default expansion removed along x only.
#' df <- data.frame(year = 2000:2020, n = cumsum(c(5, rep(1, 20))))
#' p <- ggplot2::ggplot(df, ggplot2::aes(year, n)) +
#'     ggplot2::geom_area()
#' apply_axis_padding(plotly::ggplotly(p), x = 0)
apply_axis_padding <- function(fig, x = NULL, y = NULL, swap = FALSE) {
    pad <- list(x = .padding_value(x), y = .padding_value(y))
    if (isTRUE(swap)) {
        pad <- list(x = pad$y, y = pad$x)
    }
    if (is.null(fig) || (is.null(pad$x) && is.null(pad$y))) {
        return(fig)
    }
    fig <- .ensure_built(fig)

    names <- .styled_axis_names(fig)
    extents <- .axis_data_extents(fig, names)

    for (letter in c("x", "y")) {
        p <- pad[[letter]]
        axes <- grep(paste0("^", letter, "axis[0-9]*$"), names, value = TRUE)
        if (is.null(p) || !length(axes)) {
            next
        }
        log_axis <- vapply(axes, function(a) identical(fig$x$layout[[a]]$type, "log"), logical(1))
        keys <- vapply(axes, function(a) .shared_scale_key(fig$x$layout, a), character(1))

        for (key in unique(keys)) {
            group <- axes[keys == key]
            ext <- unlist(extents[group], use.names = FALSE)
            if (any(log_axis[group])) {
                ext <- log10(ext[ext > 0])
            }
            ext <- ext[is.finite(ext)]
            if (!length(ext)) {
                next
            }
            lo <- min(ext)
            hi <- max(ext)
            if (hi - lo <= 0) {
                lo <- lo - 0.5
                hi <- hi + 0.5
            }
            span <- hi - lo
            new_range <- c(lo - p * span, hi + p * span)

            for (a in group) {
                ax <- fig$x$layout[[a]]
                reversed <- identical(ax$autorange, "reversed") ||
                    (is.numeric(ax$range) && length(ax$range) == 2 && isTRUE(ax$range[1] > ax$range[2]))
                fig$x$layout[[a]]$range <- if (reversed) rev(new_range) else new_range
                fig$x$layout[[a]]$autorange <- FALSE
            }
        }
    }
    fig
}


# A padding input's value: a single finite, non-negative number, or NULL.
.padding_value <- function(value) {
    value <- suppressWarnings(as.numeric(value)[1])
    if (length(value) == 0 || !is.finite(value)) {
        return(NULL)
    }
    max(value, 0)
}


# The figure's x/y axes the Axes tab styles: those in its layout or referenced by a
# trace, less the overlay panels' (see mark_overlay_axes()).
.styled_axis_names <- function(fig) {
    in_layout <- grep("^[xy]axis[0-9]*$", names(fig$x$layout), value = TRUE)
    in_traces <- unlist(lapply(fig$x$data, function(tr) {
        c(.axis_layout_name(tr$xaxis %||% "x"), .axis_layout_name(tr$yaxis %||% "y"))
    }))
    setdiff(unique(c(in_layout, in_traces)), fig$x$.vizmodules_overlay_axes)
}


# Tick labels as numbers, when every label is one and they label the tick positions
# themselves (or 10, 2, or e raised to them, on a log scale); NULL otherwise, as for
# a categorical axis whose categories merely look like numbers.
.numeric_tick_labels <- function(ticktext, tickvals) {
    txt <- gsub("\u2212", "-", trimws(as.character(unlist(ticktext))), fixed = TRUE)
    nums <- suppressWarnings(as.numeric(txt))
    vals <- suppressWarnings(as.numeric(unlist(tickvals)))
    if (!length(nums) || anyNA(nums) || length(vals) != length(nums) || anyNA(vals)) {
        return(NULL)
    }
    same <- function(a) isTRUE(all.equal(nums, a, tolerance = 1e-6, check.attributes = FALSE))
    if (same(vals) || same(10^vals) || same(2^vals) || same(exp(vals))) nums else NULL
}


# Numbers as powers of ten, mantissa first: 150000 -> "1.5x10<sup>5</sup>" (with a
# multiplication sign); zero stays "0".
.power_labels <- function(nums) {
    out <- format(nums, scientific = TRUE, trim = TRUE)
    out <- sub("^(-?[0-9.]+)[eE]([+-]?)0*([0-9]+)$", "\\1\u00d710<sup>\\2\\3</sup>", out)
    out <- sub("<sup>+", "<sup>", out, fixed = TRUE)
    out[nums == 0] <- "0"
    out
}


# Axes sharing a scale get the same key: an axis that `matches` another takes that
# axis' key, and axes with identical fixed ranges (a faceted ggplot's fixed scales)
# share one.
.shared_scale_key <- function(layout, name, depth = 0L) {
    ax <- layout[[name]]
    if (!is.null(ax$matches) && depth < 10L) {
        return(.shared_scale_key(layout, .axis_layout_name(ax$matches), depth + 1L))
    }
    if (is.numeric(ax$range) && length(ax$range) == 2 && all(is.finite(ax$range))) {
        return(paste(substr(name, 1, 1), paste(signif(sort(ax$range), 10), collapse = ",")))
    }
    name
}


# Whether an axis is categorical as ggplotly draws one: labels that are not the
# numbers at their positions, at consecutive whole-number positions.
.is_band_axis <- function(ax) {
    vals <- suppressWarnings(as.numeric(unlist(ax$tickvals)))
    length(ax$ticktext) > 0 && length(vals) > 0 && !anyNA(vals) &&
        is.null(.numeric_tick_labels(ax$ticktext, ax$tickvals)) &&
        all(vals == round(vals)) && (length(vals) == 1 || all(diff(sort(vals)) == 1))
}


# The extent of the data drawn on each of `axes`: a named list holding, for each
# axis padding can be computed for, a numeric vector whose range is that extent.
.axis_data_extents <- function(fig, axes) {
    layout <- fig$x$layout
    ext <- list()
    # Axes whose extent is settled (categorical bands) or cannot be computed.
    done <- character(0)
    bad <- character(0)

    # Category axes place category i (counting from 0) at i, in categoryarray's
    # order or else the order the traces first show them.
    categories <- list()
    for (a in axes) {
        ax <- layout[[a]]
        if (isTRUE(ax$type %in% c("multicategory", "date"))) {
            bad <- c(bad, a)
        } else if (identical(ax$type, "category")) {
            categories[[a]] <- .axis_categories(fig, a)
        } else if (.is_band_axis(ax)) {
            ext[[a]] <- range(as.numeric(unlist(ax$tickvals))) + c(-0.5, 0.5)
            done <- c(done, a)
        }
    }

    add <- function(axis, v) {
        if (!axis %in% axes || axis %in% c(done, bad)) {
            return(invisible())
        }
        v <- unlist(v, use.names = FALSE)
        if (is.null(v)) {
            return(invisible())
        }
        if (axis %in% names(categories) && !is.numeric(v)) {
            v <- match(as.character(v), categories[[axis]]) - 1
        }
        if (!is.numeric(v) && !is.logical(v)) {
            # Text or dates: no padding can be computed for this axis.
            bad <<- c(bad, axis)
            return(invisible())
        }
        v <- as.numeric(v)
        v <- v[is.finite(v)]
        if (length(v)) {
            ext[[axis]] <<- range(c(ext[[axis]], v))
        }
        invisible()
    }
    errors <- function(err, centre) {
        if (is.null(err) || isFALSE(err$visible) || is.null(err$array)) {
            return(NULL)
        }
        centre <- suppressWarnings(as.numeric(unlist(centre)))
        plus <- suppressWarnings(as.numeric(unlist(err$array)))
        minus <- if (is.null(err$arrayminus)) plus else suppressWarnings(as.numeric(unlist(err$arrayminus)))
        if (length(plus) != length(centre) || length(minus) != length(centre)) {
            return(NULL)
        }
        c(centre + plus, centre - minus)
    }

    for (tr in fig$x$data) {
        if (isFALSE(tr$visible)) {
            next
        }
        xa <- .axis_layout_name(tr$xaxis %||% "x")
        ya <- .axis_layout_name(tr$yaxis %||% "y")
        type <- tr$type %||% "scatter"

        if (identical(type, "bar")) {
            horizontal <- identical(tr$orientation, "h")
            pos <- unlist(if (horizontal) tr$y else tr$x, use.names = FALSE)
            val <- suppressWarnings(as.numeric(unlist(if (horizontal) tr$x else tr$y)))
            base <- suppressWarnings(as.numeric(unlist(tr$base %||% 0)))
            width <- suppressWarnings(as.numeric(unlist(tr$width %||% 0.8)))
            pos_axis <- if (horizontal) ya else xa
            val_axis <- if (horizontal) xa else ya
            if (pos_axis %in% names(categories) && !is.numeric(pos)) {
                pos <- match(as.character(pos), categories[[pos_axis]]) - 1
            }
            add(pos_axis, if (is.numeric(pos)) c(pos - width / 2, pos + width / 2) else pos)
            if (length(val)) {
                add(val_axis, c(base, base + val))
            }
        } else if (type %in% c("scatter", "scattergl", "box", "violin")) {
            add(xa, tr$x)
            add(ya, tr$y)
            add(xa, errors(tr$error_x, tr$x))
            add(ya, errors(tr$error_y, tr$y))
            if (identical(tr$fill, "tozeroy")) add(ya, 0)
            if (identical(tr$fill, "tozerox")) add(xa, 0)
        } else {
            # Heatmaps, histograms plotly bins itself, and the like: their extent
            # is not in the trace, so their axes are left alone.
            bad <- c(bad, setdiff(c(xa, ya), done))
        }
    }
    ext[setdiff(names(ext), bad)]
}


# A category axis' categories in the order plotly places them: its categoryarray
# when it has one, else every category in the order the axis' traces first show it
# (or sorted, under an alphabetical categoryorder).
.axis_categories <- function(fig, axis) {
    ax <- fig$x$layout[[axis]]
    if (length(ax$categoryarray) && identical(ax$categoryorder %||% "array", "array")) {
        return(as.character(unlist(ax$categoryarray)))
    }
    letter <- substr(axis, 1, 1)
    values <- lapply(fig$x$data, function(tr) {
        if (!identical(.axis_layout_name(tr[[paste0(letter, "axis")]] %||% letter), axis)) {
            return(NULL)
        }
        as.character(unlist(tr[[letter]]))
    })
    values <- unique(unlist(values))
    switch(ax$categoryorder %||% "trace",
        "category ascending" = sort(values),
        "category descending" = sort(values, decreasing = TRUE),
        values
    )
}
