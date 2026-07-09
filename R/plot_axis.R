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

    # Build a list of layout updates
    layout_updates <- list()

    # Apply x-axis styling to all x-axes
    for (xaxis_name in xaxis_names) {
        # Preserve existing axis properties and merge with new styling
        existing_axis <- fig$x$layout[[xaxis_name]]
        if (!is.null(existing_axis)) {
            layout_updates[[xaxis_name]] <- modifyList(existing_axis, xaxis_style)
        } else {
            layout_updates[[xaxis_name]] <- xaxis_style
        }
    }

    # Apply y-axis styling to all y-axes
    for (yaxis_name in yaxis_names) {
        # Preserve existing axis properties and merge with new styling
        existing_axis <- fig$x$layout[[yaxis_name]]
        if (!is.null(existing_axis)) {
            layout_updates[[yaxis_name]] <- modifyList(existing_axis, yaxis_style)
        } else {
            layout_updates[[yaxis_name]] <- yaxis_style
        }

        # For subplots with matched axes (yaxis2, yaxis3, etc.), explicitly ensure
        # showline and mirror properties are set even if matches="y" is present.
        # This forces plotly to render the axis lines on all subplot borders.
        if (yaxis_name != "yaxis" && !is.null(layout_updates[[yaxis_name]]$matches)) {
            # Force border styling properties for matched axes
            # This overrides plotly's default behavior of hiding borders on matched axes
            style_props <- c("showline", "mirror", "linecolor", "linewidth")
            for (prop in style_props) {
                if (!is.null(yaxis_style[[prop]])) {
                    layout_updates[[yaxis_name]][[prop]] <- yaxis_style[[prop]]
                }
            }
        }
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
#' [build_facet_annotations()]), which the plot configuration makes
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
    # consolidated into fig$x$layout. Idempotent for already-built figures.
    fig <- plotly::plotly_build(fig)

    if (is.null(fig$x) || is.null(fig$x$layout)) {
        return(fig)
    }

    layout_names <- names(fig$x$layout)

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
    if (has_x) {
        new_anns[[length(new_anns) + 1L]] <- list(
            x = 0.5, y = -0.1, xref = "paper", yref = "paper",
            text = x_axis$text, showarrow = FALSE, xanchor = "center",
            yanchor = "top", annotationType = "axis", font = x_axis$font
        )
    }
    if (has_y) {
        new_anns[[length(new_anns) + 1L]] <- list(
            x = -0.05, y = 0.5, xref = "paper", yref = "paper",
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


#' Build an adjustment-aware axis label
#'
#' Wraps a base column name with the names of any data adjustments that are
#' applied to it before plotting, so that an axis title accurately describes the
#' values displayed. The wrapping order mirrors how the adjustments are applied
#' in dittoViz (the recognized `adjustment` is applied first, then the
#' `adj.fxn`), producing labels such as `"log2(z-score(units))"`.
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

    if (is_set(adjustment)) {
        label <- paste0(adjustment[1], "(", label, ")")
    }
    if (is_set(adj.fxn)) {
        label <- paste0(adj.fxn[1], "(", label, ")")
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
        is_facet_title <- is.null(ann$annotationType) && ann$xanchor == "center"
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


