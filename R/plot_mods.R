# Scale factor applied to the maximum Y value for initial axis range.
# Using a named constant avoids magic numbers scattered across modules.
.y_axis_scale_factor <- 1.11

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
#' @rdname INTERNAL_apply_subplot_axis_styling
#' @keywords internal
.apply_subplot_axis_styling <- function(fig, xaxis_style, yaxis_style) {
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

#' Compute linear regression fit line data
#'
#' Computes predicted values from a linear model for plotting a fit line.
#' Can optionally compute separate fit lines for each group in a grouping variable.
#'
#' @param df Data frame containing the data.
#' @param x.col Character. Name of the column for x-axis values.
#' @param y.col Character. Name of the column for y-axis values.
#' @param group.col Character or NULL. Name of the column to group by.
#'   If NULL, computes a single global fit line.
#' @param n.points Integer. Number of points to generate for the fit line.
#'
#' @return If `group.col` is NULL, a data frame with columns `x` and `y`.
#'   If `group.col` is provided, a named list of data frames (one per group).
#' 
#' @importFrom stats lm loess coef predict
#'
#' @author Jared Andrews
#' @rdname INTERNAL_compute_linear_fit
#' @keywords internal
.compute_linear_fit <- function(df, x.col, y.col, group.col = NULL, n.points = 100) {
    compute_for_subset <- function(subset_df) {
        # Remove NA values
        subset_df <- subset_df[!is.na(subset_df[[x.col]]) & !is.na(subset_df[[y.col]]), ]
        if (nrow(subset_df) < 2) {
            return(NULL)
        }

        model <- lm(subset_df[[y.col]] ~ subset_df[[x.col]])

        x_min <- min(subset_df[[x.col]], na.rm = TRUE)
        x_max <- max(subset_df[[x.col]], na.rm = TRUE)
        x_grid <- seq(x_min, x_max, length.out = n.points)
        intercept <- coef(model)[1]
        slope <- coef(model)[2]
        y_grid <- intercept + slope * x_grid

        data.frame(x = x_grid, y = y_grid)
    }

    if (is.null(group.col) || group.col == "") {
        compute_for_subset(df)
    } else {
        groups <- unique(df[[group.col]])
        fits <- lapply(groups, function(g) {
            subset_df <- df[df[[group.col]] == g, ]
            compute_for_subset(subset_df)
        })
        names(fits) <- as.character(groups)
        # Remove NULL entries (groups with insufficient data)
        fits[!vapply(fits, is.null, logical(1))]
    }
}

#' Compute LOESS smooth fit line data
#'
#' Computes predicted values from a LOESS model for plotting a smooth fit line.
#' Can optionally compute separate fit lines for each group in a grouping variable.
#'
#' @param df Data frame containing the data.
#' @param x.col Character. Name of the column for x-axis values.
#' @param y.col Character. Name of the column for y-axis values.
#' @param group.col Character or NULL. Name of the column to group by.
#'   If NULL, computes a single global fit line.
#' @param span Numeric. The span parameter for LOESS smoothing (0 to 1).
#' @param n.points Integer. Number of points to generate for the fit line.
#'
#' @return If `group.col` is NULL, a data frame with columns `x` and `y`.
#'   If `group.col` is provided, a named list of data frames (one per group).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_compute_loess_fit
#' @keywords internal
.compute_loess_fit <- function(df, x.col, y.col, group.col = NULL, span = 0.75, n.points = 100) {
    compute_for_subset <- function(subset_df) {
        # Remove NA values
        subset_df <- subset_df[!is.na(subset_df[[x.col]]) & !is.na(subset_df[[y.col]]), ]
        # LOESS needs at least 4 observations
        if (nrow(subset_df) < 4) {
            return(NULL)
        }

        # Create a local copy with standardized column names for formula
        fit_df <- data.frame(x = subset_df[[x.col]], y = subset_df[[y.col]])

        fit <- tryCatch(
            loess(y ~ x, data = fit_df, span = span),
            error = function(e) NULL
        )
        if (is.null(fit)) {
            return(NULL)
        }

        x_min <- min(fit_df$x, na.rm = TRUE)
        x_max <- max(fit_df$x, na.rm = TRUE)
        x_grid <- seq(x_min, x_max, length.out = n.points)

        y_grid <- predict(fit, newdata = data.frame(x = x_grid))

        data.frame(x = x_grid, y = y_grid)
    }

    if (is.null(group.col) || group.col == "") {
        compute_for_subset(df)
    } else {
        groups <- unique(df[[group.col]])
        fits <- lapply(groups, function(g) {
            subset_df <- df[df[[group.col]] == g, ]
            compute_for_subset(subset_df)
        })
        names(fits) <- as.character(groups)
        # Remove NULL entries (groups with insufficient data)
        fits[!vapply(fits, is.null, logical(1))]
    }
}

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
#' @return A data frame identical to input \code{df} but with transformed columns added
#'   (e.g., \code{mpg.adj}) when valid transformations are specified.
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
#' @details The configuration enables interactive editing of axis titles,
#'   plot title, legend text and position, colorbar position and title, and
#'   annotation tails. It also adds drawing tools (lines, paths, circles,
#'   rectangles, and an eraser) to the modebar.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_add_plot_config
.add_plot_config <- function(download.format = "png", filename = as.character(Sys.Date()),
                             include.modebar.buttons = TRUE, facet.by = NULL) {
    if (is.null(facet.by)) {
        config <- list(
            edits = list(
                axisTitleText = TRUE,
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

#' Create Plotly axis style list
#'
#' Constructs a style list for a Plotly axis using values from a Shiny
#' \code{input} object, including title font, axis lines, tick
#' appearance, and gridline settings.
#'
#' @param input Shiny input object. Expected to contain axis-related fields
#'   such as \code{title.font.family}, \code{text.colour}, \code{axis.showline},
#'   \code{axis.mirror}, \code{axis.linecolor}, \code{axis.linewidth},
#'   \code{axis.tickfont.size}, \code{axis.tickfont.color},
#'   \code{axis.tickfont.family}, \code{axis.tickangle.x},
#'   \code{axis.tickangle.y}, \code{axis.ticks}, \code{axis.tickcolor},
#'   \code{axis.ticklen}, \code{axis.tickwidth}, \code{show.grid.x},
#'   \code{show.grid.y}, and \code{grid.color}.
#' @param axis_side Character. Which axis to style, either \code{"x"} or
#'   \code{"y"}. Determines whether \code{axis.tickangle.x} or
#'   \code{axis.tickangle.y} is used for the tick angle, and which
#'   gridline inputs are applied.
#' @param isolate_fn Function. A function used to isolate Shiny inputs,
#'   typically \code{shiny::isolate}. Defaults to \code{isolate}.
#' @param ggplot.axis.styling Logical. Whether ggplot axis styling is applied.
#'   Defaults to \code{TRUE}.
#' @return A named list containing Plotly-compatible axis styling
#'   components, including title font, line properties, tick label
#'   formatting, and gridline visibility.
#'
#' @details The function collects axis- and font-related settings from
#'   the provided \code{input} object and assembles them into a list
#'   suitable for use as an axis specification in Plotly layouts. The
#'   tick angle and gridline visibility are chosen based on the value
#'   of \code{axis_side}. If gridline inputs are not present in the
#'   input object, defaults to showing gridlines.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_create_axis_styles
.create_axis_styles <- function(input, axis_side = c("x", "y"), isolate_fn = isolate, ggplot.axis.styling = TRUE) {
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
#' @rdname INTERNAL_create_ggplot_axis_style
#' @keywords internal
.create_ggplot_axis_style <- function(input, isolate_fn = isolate) {
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

#' Parse comma-separated numeric string to vector
#'
#' Parses a text string containing comma-separated numeric values into a numeric vector.
#' Used for parsing user input for line intercepts, slopes, etc.
#'
#' @param text Character. A string containing comma-separated numeric values (e.g., "1, 5, 8").
#'
#' @return A numeric vector of parsed values, or NULL if input is empty/invalid.
#'
#' @details Whitespace around values is trimmed. Non-numeric values are converted to NA.
#'   If all values are NA or the input is empty, returns NULL.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_parse_numeric_list
.parse_numeric_list <- function(text) {
    if (is.null(text) || !nzchar(trimws(text))) {
        return(NULL)
    }
    vals <- trimws(unlist(strsplit(text, ",")))
    vals <- suppressWarnings(as.numeric(vals))
    vals <- vals[!is.na(vals)]
    if (length(vals) == 0) {
        return(NULL)
    }
    vals
}

#' Recycle style vector to match line count
#'
#' Extends or truncates a style vector to match the number of lines being drawn.
#' If the input length doesn't match the target length, uses only the first value
#' for all lines (as documented behavior).
#'
#' @param values Vector. Style values (colors, widths, etc.) to recycle.
#' @param n Integer. Target length (number of lines).
#' @param default The default value to use if values is NULL or empty.
#'
#' @return A vector of length n with recycled values.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_recycle_line_style
.recycle_line_style <- function(values, n, default) {
    if (is.null(values) || length(values) == 0) {
        return(rep(default, n))
    }
    if (length(values) == n) {
        return(values)
    }
    # If length doesn't match, use first value for all
    rep(values[1], n)
}

#' Convert linetype name to plotly dash style
#'
#' Maps common linetype names to plotly dash specifications.
#'
#' @param linetype Character. Linetype name: "solid", "dashed", "dotted", "dotdash", "longdash", "twodash".
#'
#' @return Character. Plotly-compatible dash specification.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_linetype_to_dash
.linetype_to_dash <- function(linetype) {
    switch(tolower(linetype),
        "solid" = "solid",
        "dashed" = "dash",
        "dotted" = "dot",
        "dotdash" = "dashdot",
        "longdash" = "longdash",
        "twodash" = "longdashdot",
        "solid" # default
    )
}

#' Build horizontal line shapes for a plotly figure
#'
#' Creates shape specifications for one or more horizontal lines at specified y-intercepts.
#' Supports independent styling for each line.
#'
#' @param intercepts Numeric vector. Y-axis intercepts for horizontal lines.
#' @param colors Character vector. Line colors (hex or named colors).
#' @param widths Numeric vector. Line widths in pixels.
#' @param linetypes Character vector. Line types: "solid", "dashed", "dotted", "dotdash", "longdash", "twodash".
#' @param opacities Numeric vector. Line opacities (0 to 1).
#' @param fig A plotly figure object. Used to detect subplot axes for faceted plots.
#'
#' @return A list of shape specifications for use with plotly::layout().
#'
#' @details If style vector lengths don't match the number of intercepts, only the first
#'   value of each style vector is used for all lines. When the figure contains subplots
#'   (e.g., from faceting), lines are replicated across all panels with correct axis references.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_add_hlines
.add_hlines <- function(fig, intercepts, colors = "#000000", widths = 1, linetypes = "solid", opacities = 1) {
    if (is.null(intercepts) || length(intercepts) == 0) {
        return(list())
    }

    n <- length(intercepts)
    colors <- .recycle_line_style(colors, n, "#000000")
    widths <- .recycle_line_style(widths, n, 1)
    linetypes <- .recycle_line_style(linetypes, n, "solid")
    opacities <- .recycle_line_style(opacities, n, 1)

    # Extract unique axis pairs from traces
    # Each trace has xaxis (e.g., "x", "x2") and yaxis (e.g., "y", "y2") attributes
    axis_pairs <- unique(lapply(fig$x$data, function(tr) {
        xaxis <- if (is.null(tr$xaxis)) "x" else tr$xaxis
        yaxis <- if (is.null(tr$yaxis)) "y" else tr$yaxis
        list(x = xaxis, y = yaxis)
    }))

    # If no traces found, default to main axes
    if (length(axis_pairs) == 0) {
        axis_pairs <- list(list(x = "x", y = "y"))
    }

    all_shapes <- list()

    for (pair in axis_pairs) {
        xref <- paste0(pair$x, " domain")
        yref <- pair$y

        for (i in seq_len(n)) {
            all_shapes <- c(all_shapes, list(list(
                type = "line",
                x0 = 0, x1 = 1, xref = xref,
                y0 = intercepts[i], y1 = intercepts[i], yref = yref,
                line = list(
                    color = colors[i],
                    width = widths[i],
                    dash = .linetype_to_dash(linetypes[i])
                ),
                opacity = opacities[i]
            )))
        }
    }

    all_shapes
}

#' Build vertical line shapes for a plotly figure
#'
#' Creates shape specifications for one or more vertical lines at specified x-intercepts.
#' Supports independent styling for each line.
#'
#' @param intercepts Numeric vector. X-axis intercepts for vertical lines.
#' @param colors Character vector. Line colors (hex or named colors).
#' @param widths Numeric vector. Line widths in pixels.
#' @param linetypes Character vector. Line types: "solid", "dashed", "dotted", "dotdash", "longdash", "twodash".
#' @param opacities Numeric vector. Line opacities (0 to 1).
#' @param fig A plotly figure object. Used to detect subplot axes for faceted plots.
#'
#' @return A list of shape specifications for use with plotly::layout().
#'
#' @details If style vector lengths don't match the number of intercepts, only the first
#'   value of each style vector is used for all lines. When the figure contains subplots
#'   (e.g., from faceting), lines are replicated across all panels with correct axis references.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_add_vlines
.add_vlines <- function(fig, intercepts, colors = "#000000", widths = 1, linetypes = "solid", opacities = 1) {
    if (is.null(intercepts) || length(intercepts) == 0) {
        return(list())
    }

    n <- length(intercepts)
    colors <- .recycle_line_style(colors, n, "#000000")
    widths <- .recycle_line_style(widths, n, 1)
    linetypes <- .recycle_line_style(linetypes, n, "solid")
    opacities <- .recycle_line_style(opacities, n, 1)

    # Extract unique axis pairs from traces
    axis_pairs <- unique(lapply(fig$x$data, function(tr) {
        xaxis <- if (is.null(tr$xaxis)) "x" else tr$xaxis
        yaxis <- if (is.null(tr$yaxis)) "y" else tr$yaxis
        list(x = xaxis, y = yaxis)
    }))

    # If no traces found, default to main axes
    if (length(axis_pairs) == 0) {
        axis_pairs <- list(list(x = "x", y = "y"))
    }

    all_shapes <- list()

    for (pair in axis_pairs) {
        xref <- pair$x
        yref <- paste0(pair$y, " domain")

        for (i in seq_len(n)) {
            all_shapes <- c(all_shapes, list(list(
                type = "line",
                x0 = intercepts[i], x1 = intercepts[i], xref = xref,
                y0 = 0, y1 = 1, yref = yref,
                line = list(
                    color = colors[i],
                    width = widths[i],
                    dash = .linetype_to_dash(linetypes[i])
                ),
                opacity = opacities[i]
            )))
        }
    }

    all_shapes
}

#' Build diagonal (abline) line shapes for a plotly figure
#'
#' Creates shape specifications for one or more diagonal lines defined by slope and intercept.
#' Lines are drawn across the provided or computed axis range.
#'
#' @param fig A plotly figure object (used to determine x-axis range and detect subplots).
#' @param slopes Numeric vector. Slopes for the diagonal lines.
#' @param intercepts Numeric vector. Y-intercepts for the diagonal lines. Must be same length as slopes.
#' @param colors Character vector. Line colors (hex or named colors).
#' @param widths Numeric vector. Line widths in pixels.
#' @param linetypes Character vector. Line types: "solid", "dashed", "dotted", "dotdash", "longdash", "twodash".
#' @param opacities Numeric vector. Line opacities (0 to 1).
#'
#' @return A list of shape specifications for use with plotly::layout().
#'
#' @details If style vector lengths don't match the number of lines, only the first
#'   value of each style vector is used for all lines. If slopes and intercepts have
#'   different lengths, the shorter one is recycled. When the figure contains subplots
#'   (e.g., from faceting), lines are replicated across all panels with correct axis references.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_add_ablines
.add_ablines <- function(fig, slopes, intercepts, colors = "#000000", widths = 1, linetypes = "solid", opacities = 1) {
    if (is.null(slopes) || length(slopes) == 0 || is.null(intercepts) || length(intercepts) == 0) {
        return(list())
    }

    # Ensure slopes and intercepts have same length
    n <- max(length(slopes), length(intercepts))
    if (length(slopes) < n) {
        slopes <- rep(slopes[1], n)
    }
    if (length(intercepts) < n) {
        intercepts <- rep(intercepts[1], n)
    }

    colors <- .recycle_line_style(colors, n, "#000000")
    widths <- .recycle_line_style(widths, n, 1)
    linetypes <- .recycle_line_style(linetypes, n, "solid")
    opacities <- .recycle_line_style(opacities, n, 1)

    # Extract unique axis pairs from traces
    axis_pairs <- unique(lapply(fig$x$data, function(tr) {
        xaxis <- if (is.null(tr$xaxis)) "x" else tr$xaxis
        yaxis <- if (is.null(tr$yaxis)) "y" else tr$yaxis
        list(x = xaxis, y = yaxis)
    }))

    # If no traces found, default to main axes
    if (length(axis_pairs) == 0) {
        axis_pairs <- list(list(x = "x", y = "y"))
    }

    all_shapes <- list()

    for (pair in axis_pairs) {
        # Get axis range for this subplot
        # Convert trace axis ref (x, x2) to layout axis name (xaxis, xaxis2)
        xaxis_name <- paste0("xaxis", sub("^x", "", pair$x))
        if (xaxis_name == "xaxis") xaxis_name <- "xaxis" # Handle main axis
        xaxis <- fig$x$layout[[xaxis_name]]
        x_range <- if (!is.null(xaxis)) xaxis$range else NULL

        if (is.null(x_range)) {
            # Try to get range from data for this subplot
            x_data <- unlist(lapply(fig$x$data, function(tr) {
                tr_xaxis <- if (is.null(tr$xaxis)) "x" else tr$xaxis
                if (tr_xaxis == pair$x) tr$x else NULL
            }))
            if (length(x_data) > 0) {
                x_range <- range(x_data, na.rm = TRUE)
                # Add padding
                padding <- diff(x_range) * 0.1
                x_range <- c(x_range[1] - padding, x_range[2] + padding)
            } else {
                x_range <- c(0, 1)
            }
        }

        xref <- pair$x
        yref <- pair$y

        for (i in seq_len(n)) {
            x0 <- x_range[1]
            x1 <- x_range[2]
            y0 <- intercepts[i] + slopes[i] * x0
            y1 <- intercepts[i] + slopes[i] * x1

            all_shapes <- c(all_shapes, list(list(
                type = "line",
                x0 = x0, x1 = x1, xref = xref,
                y0 = y0, y1 = y1, yref = yref,
                line = list(
                    color = colors[i],
                    width = widths[i],
                    dash = .linetype_to_dash(linetypes[i])
                ),
                opacity = opacities[i]
            )))
        }
    }

    all_shapes
}

#' Add reference lines to a plotly figure from Shiny inputs
#'
#' Convenience wrapper that adds horizontal, vertical, and/or diagonal lines
#' to a plotly figure based on parsed Shiny input values.
#'
#' @param fig A plotly figure object.
#' @param hline.intercepts Character. Comma-separated y-intercepts for horizontal lines.
#' @param hline.colors Character. Comma-separated colors for horizontal lines.
#' @param hline.widths Character. Comma-separated widths for horizontal lines.
#' @param hline.linetypes Character. Comma-separated linetypes for horizontal lines.
#' @param hline.opacities Character. Comma-separated opacities for horizontal lines.
#' @param vline.intercepts Character. Comma-separated x-intercepts for vertical lines.
#' @param vline.colors Character. Comma-separated colors for vertical lines.
#' @param vline.widths Character. Comma-separated widths for vertical lines.
#' @param vline.linetypes Character. Comma-separated linetypes for vertical lines.
#' @param vline.opacities Character. Comma-separated opacities for vertical lines.
#' @param abline.slopes Character. Comma-separated slopes for diagonal lines.
#' @param abline.intercepts Character. Comma-separated y-intercepts for diagonal lines.
#' @param abline.colors Character. Comma-separated colors for diagonal lines.
#' @param abline.widths Character. Comma-separated widths for diagonal lines.
#' @param abline.linetypes Character. Comma-separated linetypes for diagonal lines.
#' @param abline.opacities Character. Comma-separated opacities for diagonal lines.
#'
#' @return The modified plotly figure with all specified lines added.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_add_reference_lines
.add_reference_lines <- function(fig,
                                 hline.intercepts = NULL, hline.colors = NULL, hline.widths = NULL,
                                 hline.linetypes = NULL, hline.opacities = NULL,
                                 vline.intercepts = NULL, vline.colors = NULL, vline.widths = NULL,
                                 vline.linetypes = NULL, vline.opacities = NULL,
                                 abline.slopes = NULL, abline.intercepts = NULL, abline.colors = NULL,
                                 abline.widths = NULL, abline.linetypes = NULL, abline.opacities = NULL) {
    # Collect all shapes in one list
    all_shapes <- list()

    # Get existing shapes from figure
    existing_shapes <- fig$x$layout$shapes
    if (!is.null(existing_shapes)) {
        all_shapes <- existing_shapes
    }

    # Parse and add horizontal line shapes
    h_intercepts <- .parse_numeric_list(hline.intercepts)
    if (!is.null(h_intercepts)) {
        h_colors <- if (!is.null(hline.colors) && nzchar(hline.colors)) {
            trimws(unlist(strsplit(hline.colors, ",")))
        } else {
            "#000000"
        }
        h_widths <- .parse_numeric_list(hline.widths)
        if (is.null(h_widths)) h_widths <- 1
        h_linetypes <- .string_to_linetypes(hline.linetypes)
        h_opacities <- .parse_numeric_list(hline.opacities)
        if (is.null(h_opacities)) h_opacities <- 1
        h_shapes <- .add_hlines(fig, h_intercepts, h_colors, h_widths, h_linetypes, h_opacities)
        all_shapes <- c(all_shapes, h_shapes)
    }

    # Parse and add vertical line shapes
    v_intercepts <- .parse_numeric_list(vline.intercepts)
    if (!is.null(v_intercepts)) {
        v_colors <- if (!is.null(vline.colors) && nzchar(vline.colors)) {
            trimws(unlist(strsplit(vline.colors, ",")))
        } else {
            "#000000"
        }
        v_widths <- .parse_numeric_list(vline.widths)
        if (is.null(v_widths)) v_widths <- 1
        v_linetypes <- .string_to_linetypes(vline.linetypes)
        v_opacities <- .parse_numeric_list(vline.opacities)
        if (is.null(v_opacities)) v_opacities <- 1
        v_shapes <- .add_vlines(fig, v_intercepts, v_colors, v_widths, v_linetypes, v_opacities)
        all_shapes <- c(all_shapes, v_shapes)
    }

    # Parse and add diagonal line shapes
    ab_slopes <- .parse_numeric_list(abline.slopes)
    ab_intercepts <- .parse_numeric_list(abline.intercepts)
    if (!is.null(ab_slopes) && !is.null(ab_intercepts)) {
        ab_colors <- if (!is.null(abline.colors) && nzchar(abline.colors)) {
            trimws(unlist(strsplit(abline.colors, ",")))
        } else {
            "#000000"
        }
        ab_widths <- .parse_numeric_list(abline.widths)
        if (is.null(ab_widths)) ab_widths <- 1
        ab_linetypes <- .string_to_linetypes(abline.linetypes)
        ab_opacities <- .parse_numeric_list(abline.opacities)
        if (is.null(ab_opacities)) ab_opacities <- 1
        ab_shapes <- .add_ablines(fig, ab_slopes, ab_intercepts, ab_colors, ab_widths, ab_linetypes, ab_opacities)
        all_shapes <- c(all_shapes, ab_shapes)
    }

    # Directly modify the figure's shapes (plotly::layout() doesn't merge shapes properly)
    if (length(all_shapes) > 0) {
        fig$x$layout$shapes <- all_shapes
    }

    fig
}


#' Apply Plotly newshape styling from uniform Plotly inputs
#'
#' Applies user-drawn shape styling to a Plotly figure using inputs from
#' [.uniform_plotly_inputs_ui()]. Updates the `newshape` layout property to
#' style shapes drawn with Plotly's drawing tools (rectangles, circles, lines,
#' etc.) in the modebar.
#'
#' @param fig A plotly figure object.
#' @param input Shiny input object containing shape styling fields:
#'   `shape.fill`, `shape.line.color`, `shape.line.width`, `shape.linetype`,
#'   `shape.opacity`.
#' @param isolate_fn Function to isolate reactive values. Defaults to
#'   `shiny::isolate`.
#'
#' @return The modified plotly figure with updated `newshape` layout settings.
#'
#' @importFrom plotly layout
#'
#' @author Jared Andrews
#' @rdname INTERNAL_apply_plotly_newshape
#' @keywords internal
.apply_plotly_newshape <- function(fig, input, isolate_fn = isolate) {
    fig |> plotly::layout(
        newshape = list(
            fillcolor = isolate_fn(input$shape.fill),
            line = list(
                color = isolate_fn(input$shape.line.color),
                width = isolate_fn(input$shape.line.width),
                dash = isolate_fn(input$shape.linetype)
            ),
            opacity = isolate_fn(input$shape.opacity)
        )
    )
}


#' Create download handler for interactive plotly plots
#'
#' Generates a Shiny downloadHandler that saves a plotly widget as an
#' interactive HTML file with resizable functionality. This is used by all
#' VizModules to provide a "Save Interactive" button.
#'
#' @param plot_reactive A reactive expression returning a plotly plot object.
#' @param filename_base Character. Base name for the downloaded file (without extension).
#'   Defaults to "interactive_plot".
#'
#' @return A downloadHandler function that can be assigned to output$download.interactive.
#'
#' @importFrom htmlwidgets saveWidget
#' @importFrom htmltools tagList tags browsable
#' @importFrom shinyjqui jqui_resizable
#'
#' @author Jared Andrews
#' @rdname INTERNAL_create_download_handler
#' @keywords internal
.create_plot_download_handler <- function(plot_reactive, filename_base = "interactive_plot") {
    downloadHandler(
        filename = function() {
            paste0(filename_base, "_", Sys.Date(), ".html")
        },
        content = function(file) {
            plot <- plot_reactive()
            # Ensure it's a plotly widget
            if (!inherits(plot, "plotly")) {
                stop("Plot must be a plotly object")
            }

            # Save as HTML widget
            saveWidget(
                widget = jqui_resizable(plot),
                file = file,
                selfcontained = TRUE
            )
        }
    )
}


#' Create download handler for an interactive plot summary
#'
#' Generates a Shiny [downloadHandler()] that bundles the interactive plot
#' and its supporting data into a single `.zip` archive. The archive contains
#' a self-contained interactive HTML of the plotly plot (rendered via
#' [htmlwidgets::saveWidget()]), a CSV of the plot's underlying data
#' (obtained via [plotly::plotly_data()]), and, when supplied, a CSV of the
#' statistics summary and a CSV snapshot of the current UI input values.
#' Used by all VizModules to provide the "Interactive Summary" download
#' button beside the standard control panel buttons (Auto Update / Update /
#' Reset).
#'
#' @param plot_reactive A reactive expression returning a `plotly` plot object.
#' @param stats_reactive Optional. A reactive expression (e.g. a
#'   [shiny::reactiveVal()]) returning a `data.frame` of summary statistics
#'   to include in the archive. When `NULL` or when the reactive returns
#'   `NULL`, `stats_data.csv` is omitted from the zip.
#' @param inputs_reactive Optional. A reactive expression returning a named
#'   list of UI input values (typically built with
#'   [shiny::reactiveValuesToList()] on the module's `input`). When `NULL`
#'   or empty, `ui_inputs.csv` is omitted from the zip.
#' @param filename_base `character(1)`. Base name for the downloaded `.zip`
#'   file (without extension). The final filename takes the form
#'   `<filename_base>_<Sys.Date()>.zip`. Defaults to `"interactive_summary"`.
#'
#' @return A `downloadHandler` object suitable for direct assignment to a
#'   Shiny output (e.g. `output$download.interactive.summary`). The resulting
#'   `.zip` archive contains:
#'   \describe{
#'     \item{`plot.html`}{Self-contained interactive plotly HTML widget.}
#'     \item{`plot_Data.csv`}{CSV of the data underlying the plot, as
#'       returned by [plotly::plotly_data()].}
#'     \item{`stats_data.csv`}{CSV of the statistics summary (only present
#'       when `stats_reactive` is non-`NULL` and returns non-empty data).}
#'     \item{`ui_inputs.csv`}{CSV of the current UI input names and values
#'       (only present when `inputs_reactive` is non-`NULL` and returns a
#'       non-empty list).}
#'   }
#'
#' @examples
#' if (interactive()) {
#'     library(shiny)
#'     library(plotly)
#'
#'     ui <- fluidPage(
#'         plotlyOutput("plot"),
#'         downloadButton("download_summary", "Download Summary")
#'     )
#'
#'     server <- function(input, output, session) {
#'         # A reactive plotly plot
#'         plot_reactive <- reactive({
#'             plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#'         })
#'
#'         # Optional: a reactive returning a stats data.frame
#'         stats_reactive <- reactive({
#'             data.frame(
#'                 metric = c("mean_mpg", "sd_mpg"),
#'                 value  = c(mean(mtcars$mpg), sd(mtcars$mpg))
#'             )
#'         })
#'
#'         # Optional: capture all UI inputs as a named list
#'         AllInputs <- reactive({
#'             reactiveValuesToList(input)
#'         })
#'
#'         output$plot <- renderPlotly(plot_reactive())
#'
#'         output$download_summary <- create_interactive_summary_download_handler(
#'             plot_reactive   = plot_reactive,
#'             stats_reactive  = stats_reactive,
#'             inputs_reactive = AllInputs(),
#'             filename_base   = "my_plot_summary"
#'         )
#'     }
#'
#'     shinyApp(ui, server)
#' }
#'
#' @importFrom shiny downloadHandler isolate
#' @importFrom withr local_tempdir
#' @importFrom htmlwidgets saveWidget
#' @importFrom shinyjqui jqui_resizable
#' @importFrom plotly plotly_data
#' @importFrom zip zip
#' @importFrom utils write.csv
#'
#' @author Jacob Martin
#' @export
create_interactive_summary_download_handler <- function(plot_reactive,
                                                        stats_reactive = NULL,
                                                        inputs_reactive = NULL,
                                                        filename_base = "interactive_summary") {
    downloadHandler(
        filename = function() {
            paste0(filename_base, "_", Sys.Date(), ".zip")
        },
        content = function(file) {
            tmp <- withr::local_tempdir()
            plot <- plot_reactive()
            plot_data <- as.data.frame(plotly_data(plot))
            
            stats <- NULL
            if (!is.null(stats_reactive)) {
                stats_df <- tryCatch(stats_reactive(), error = function(e) NULL)
                if (!is.null(stats_df)) {
                    stats <- as.data.frame(stats_df)
                    write.csv(stats, paste0(tmp, "/stats_data.csv"), row.names = FALSE)
                }
            }

            ui_inputs <- tryCatch(isolate(inputs_reactive), error = function(e) {
                message("ERROR: ", e$message)
                NULL
            })
                
            inp <- data.frame(
                names  = names(ui_inputs),
                values = unlist(lapply(ui_inputs, function(x) {
                    if (is.null(x)) "NULL"
                    else if (length(x) > 1) paste(x, collapse = ", ")
                    else as.character(x)
            })))
            write.csv(inp, paste0(tmp, "/ui_inputs.csv"))
        
            write.csv(plot_data, paste0(tmp, "/plot_Data.csv"), row.names = FALSE)
        
            saveWidget(
                        widget = jqui_resizable(plot),
                        file = paste0(tmp, "/plot.html"),
                        selfcontained = TRUE
                    )
            zip::zip(file,files = list.files(tmp, full.names = FALSE), root = tmp, mode = "cherry-pick")

        }
    )
}
#' Calculate axis range from data
#'
#' Computes a numeric range for the Y-axis based on specified columns in a
#' data frame, applying a scaling factor to the maximum value. Handles both
#' simple (non-stacked) and stacked bar scenarios, where stacking occurs when
#' \code{group.by} or \code{fill.by} is numeric.
#'
#' @param df Data frame. The data containing the variables to range over.
#' @param data_col_y Character string. Name of the numeric Y-axis data column.
#'   Takes priority over \code{data_col_x} if both are provided.
#' @param data_col_x Character string. Name of the X-axis data column. Required
#'   when \code{grouping = TRUE} or \code{stack_by} is specified, as it defines
#'   the groups over which Y values are summed.
#' @param axis_scale_factor Numeric. Multiplicative factor applied to the
#'   maximum Y value to provide additional headroom on the axis.
#' @param grouping Logical. If \code{TRUE}, bars are treated as stacked and the
#'   maximum is derived from the sum of Y values within each X group rather than
#'   the raw maximum. Defaults to \code{FALSE}.
#' @param stack_by Character string or \code{NULL}. Name of the column used for
#'   stacking (i.e. \code{group.by} or \code{fill.by}). When this column is
#'   numeric, bars are stacked and Y values are summed per X category before
#'   computing the maximum. Ignored if \code{NULL} or if the column is
#'   categorical. Defaults to \code{NULL}.
#'
#' @return A named list with components \code{min} and \code{max} giving the
#'   lower and upper limits for the Y-axis, or \code{NULL} if any required
#'   column is missing, non-numeric, or otherwise invalid.
#'
#' @details
#' The function resolves the primary data column from \code{data_col_y} or
#' \code{data_col_x} and validates that it exists and is numeric in \code{df}.
#'
#' Behaviour depends on whether bars are stacked:
#' \itemize{
#'   \item \strong{Non-stacked} (\code{grouping = FALSE}, categorical or absent
#'     \code{stack_by}): the Y range is computed directly from the raw column
#'     values using \code{min()} and \code{max()}.
#'   \item \strong{Stacked} (\code{grouping = TRUE} or \code{stack_by} is
#'     numeric): Y values are summed within each unique X category using
#'     \code{tapply()}, and the maximum of those sums is used. The minimum is
#'     fixed at 0 since stacked bars always originate from zero.
#' }
#'
#' Non-finite results (e.g. from empty or all-\code{NA} columns) are replaced
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


#' Remove boxplot outliers from plotly figure
#'
#' Hides outlier points in boxplot traces by setting their marker opacity to zero
#' and disabling hover information. The outliers remain in the underlying data
#' but are not visually displayed or interactive.
#'
#' @param fig A plotly figure object containing one or more boxplot traces.
#'
#' @return The modified plotly figure with outliers hidden in all boxplot traces.
#'
#' @details This function iterates through all traces in the plotly figure and
#'   identifies those with type "box". For each boxplot trace, it sets the marker
#'   opacity to 0 and disables hover information, effectively hiding the outlier
#'   points while preserving the box, whiskers, and median line. Non-boxplot traces
#'   are returned unchanged.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_remove_boxplot_outliers
.remove_boxplot_outliers <- function(fig) {
    stopifnot("plotly" %in% class(fig))
    fig$x$data <- lapply(
        fig$x$data,
        function(i) {
            if (i$type != "box") {
                return(i)
            }
            i$marker <- list(opacity = 0)
            i$hoverinfo <- "none"
            i
        }
    )
    fig
}

#' Fix boxplot positioning across faceted subplots
#'
#' Sets the `offsetgroup` property on each box trace to ensure consistent
#' positioning across faceted subplot panels. Without this, plotly.js may
#' calculate different box offsets per subplot when `boxmode = "group"` is used,
#' causing boxes in different facets to appear at different x-positions.
#'
#' @param fig A plotly figure object containing one or more boxplot traces.
#'
#' @return The modified plotly figure with `offsetgroup` set on all box traces.
#'
#' @details When ggplotly converts a faceted ggplot, each facet becomes a
#'   subplot with its own axis pair. Plotly.js calculates box offsets
#'   independently per subplot unless `offsetgroup` is explicitly set on each
#'   trace. This function sets `offsetgroup` to the trace's `name` property
#'   (which corresponds to the color/grouping variable level), ensuring
#'   identical positioning of same-group boxes across all facet panels.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_fix_boxplot_facet_positions
.fix_boxplot_facet_positions <- function(fig) {
    stopifnot("plotly" %in% class(fig))
    fig$x$data <- lapply(
        fig$x$data,
        function(i) {
            if (is.null(i$type) || i$type != "box") {
                return(i)
            }
            i$offsetgroup <- if (!is.null(i$name)) i$name else ""
            i
        }
    )
    fig
}

#' Apply custom subplot spacing to a faceted ggplotly figure
#'
#' `ggplotly()` assigns panel layout via plotly domain coordinates
#' (`fig$x$layout$xaxis*/yaxis*$domain`) rather than honouring the ggplot2
#' `panel.spacing` theme option. This helper rewrites those domains so that
#' each facet panel has a uniform size and the gap between panels is exactly
#' `spacing` (expressed as a fraction of the plot area, e.g. `0.04`).
#'
#' In addition to the axis domains, any paper-anchored layout annotations
#' (e.g. facet strip titles) and shapes (e.g. strip backgrounds, panel
#' borders) are remapped through a piecewise-linear transform built from the
#' old and new domain intervals, so strip labels and panel borders move with
#' their panels. Annotations/shapes whose `xref`/`yref` is tied to an axis
#' (for example `"x"`, `"y2"`, or `"x2 domain"`) are left alone because they
#' follow the rewritten axis automatically.
#'
#' The number of columns and rows can be supplied manually, or detected
#' automatically from the distinct x / y domain starts already present in the
#' ggplotly output.
#'
#' @param fig A plotly figure object (typically the result of `ggplotly()`).
#' @param spacing Numeric fraction of the plot area to leave between panels
#'   (default `0.04`). Must satisfy `spacing * (ncol - 1) < 1` and
#'   `spacing * (nrow - 1) < 1`; otherwise the figure is returned unchanged.
#' @param ncol Optional integer. Number of facet columns. If `NULL` or `NA`,
#'   detected from the number of distinct x-axis domain starts.
#' @param nrow Optional integer. Number of facet rows. If `NULL` or `NA`,
#'   detected from the number of distinct y-axis domain starts.
#'
#' @return The modified plotly figure with rewritten axis domains and
#'   remapped paper-anchored annotations/shapes. Figures with a single panel
#'   (or no layout) are returned unchanged.
#'
#' @author Jacob Martin
#' @importFrom stats approx
#' @keywords internal
#' @rdname INTERNAL_apply_facet_subplot_spacing
.apply_facet_subplot_spacing <- function(fig, spacing = 0.04, ncol = NULL, nrow = NULL) {
    stopifnot("plotly" %in% class(fig))
    if (is.null(fig$x) || is.null(fig$x$layout)) {
        return(fig)
    }

    layout_names <- names(fig$x$layout)
    x_axes <- layout_names[grepl("^xaxis[0-9]*$", layout_names)]
    y_axes <- layout_names[grepl("^yaxis[0-9]*$", layout_names)]

    if (length(x_axes) <= 1 && length(y_axes) <= 1) {
        return(fig)
    }

    # Sort axes by numeric suffix ("xaxis", "xaxis2", ...)
    axis_order <- function(nms) {
        nums <- suppressWarnings(as.integer(sub("^[xy]axis", "", nms)))
        nums[is.na(nums)] <- 1L
        nms[order(nums)]
    }
    x_axes <- axis_order(x_axes)
    y_axes <- axis_order(y_axes)

    # Capture the existing (old) domains for each axis before we rewrite them.
    get_domain <- function(a) {
        d <- fig$x$layout[[a]]$domain
        if (is.numeric(d) && length(d) == 2L) d else c(NA_real_, NA_real_)
    }
    x_old <- lapply(x_axes, get_domain)
    y_old <- lapply(y_axes, get_domain)
    x_starts <- vapply(x_old, `[`, numeric(1), 1)
    y_starts <- vapply(y_old, `[`, numeric(1), 1)

    valid_x <- !is.na(x_starts)
    valid_y <- !is.na(y_starts)
    if (!any(valid_x) || !any(valid_y)) {
        return(fig)
    }

    # Auto-detect grid dimensions from distinct domain starts in the ggplotly output.
    unique_x_starts <- sort(unique(round(x_starts[valid_x], 6)))
    # Largest y-start = top row, so order descending to get row 1 = top.
    unique_y_starts <- sort(unique(round(y_starts[valid_y], 6)), decreasing = TRUE)

    detected_ncol <- length(unique_x_starts)
    detected_nrow <- length(unique_y_starts)

    if (is.null(ncol) || is.na(ncol)) ncol <- detected_ncol
    if (is.null(nrow) || is.na(nrow)) nrow <- detected_nrow
    ncol <- as.integer(ncol)
    nrow <- as.integer(nrow)
    if (!is.finite(ncol) || !is.finite(nrow) || ncol < 1L || nrow < 1L) {
        return(fig)
    }

    # Guard against invalid spacing that would leave no room for panels.
    if (!is.numeric(spacing) || length(spacing) != 1L || is.na(spacing) || spacing < 0) {
        return(fig)
    }
    cell_w <- (1 - spacing * (ncol - 1)) / ncol
    cell_h <- (1 - spacing * (nrow - 1)) / nrow
    if (cell_w <= 0 || cell_h <= 0) {
        return(fig)
    }

    # Map each axis to a column / row using its current domain start relative
    # to the detected unique starts (smallest x = col 1, largest y = row 1).
    col_idx <- match(round(x_starts, 6), unique_x_starts)
    row_idx <- match(round(y_starts, 6), unique_y_starts)

    # Compute the new domains, and build parallel lists of old/new intervals
    # so we can build a piecewise-linear remap for paper coordinates.
    x_new <- x_old
    y_new <- y_old
    for (i in seq_along(x_axes)) {
        c <- col_idx[i]
        if (is.na(c) || c < 1L || c > ncol) next
        x0 <- (c - 1) * (cell_w + spacing)
        new_d <- c(x0, x0 + cell_w)
        fig$x$layout[[x_axes[i]]]$domain <- new_d
        x_new[[i]] <- new_d
    }
    for (i in seq_along(y_axes)) {
        r <- row_idx[i]
        if (is.na(r) || r < 1L || r > nrow) next
        y1 <- 1 - (r - 1) * (cell_h + spacing)
        new_d <- c(y1 - cell_h, y1)
        fig$x$layout[[y_axes[i]]]$domain <- new_d
        y_new[[i]] <- new_d
    }

    # Build piecewise-linear remap: collect (old_start, new_start) and
    # (old_end, new_end) knots per distinct old interval, anchored by (0,0)
    # and (1,1), then linearly interpolate between them.
    build_remap <- function(old_list, new_list) {
        olds <- numeric(0)
        news <- numeric(0)
        seen <- character(0)
        for (k in seq_along(old_list)) {
            od <- old_list[[k]]
            nd <- new_list[[k]]
            if (any(is.na(od)) || any(is.na(nd))) next
            key <- paste(round(od, 6), collapse = "_")
            if (key %in% seen) next
            seen <- c(seen, key)
            olds <- c(olds, od[1], od[2])
            news <- c(news, nd[1], nd[2])
        }
        if (length(olds) == 0L) return(function(p) p)
        olds <- c(0, olds, 1)
        news <- c(0, news, 1)
        ord <- order(olds)
        olds <- olds[ord]
        news <- news[ord]
        # Collapse duplicate old knots (keep the mean of the corresponding new values).
        dup <- duplicated(round(olds, 8))
        if (any(dup)) {
            agg <- tapply(news, round(olds, 8), mean)
            olds <- as.numeric(names(agg))
            news <- as.numeric(agg)
            ord <- order(olds)
            olds <- olds[ord]
            news <- news[ord]
        }
        function(p) {
            if (!is.numeric(p) || length(p) == 0L) return(p)
            out <- suppressWarnings(stats::approx(olds, news, xout = p, rule = 2)$y)
            out
        }
    }
    remap_x <- build_remap(x_old, x_new)
    remap_y <- build_remap(y_old, y_new)

    # A ref is paper-anchored iff it is NULL, "paper", or missing.
    is_paper_ref <- function(ref) is.null(ref) || identical(ref, "paper") || identical(ref, NA)

    # Remap paper-anchored annotations (e.g. facet strip titles).
    anns <- fig$x$layout$annotations
    if (is.list(anns) && length(anns) > 0L) {
        for (i in seq_along(anns)) {
            a <- anns[[i]]
            if (is.null(a)) next
            if (is_paper_ref(a$xref) && is.numeric(a$x)) {
                a$x <- remap_x(a$x)
            }
            if (is_paper_ref(a$yref) && is.numeric(a$y)) {
                a$y <- remap_y(a$y)
            }
            anns[[i]] <- a
        }
        fig$x$layout$annotations <- anns
    }

    # Remap paper-anchored shapes (e.g. strip backgrounds and panel borders).
    shps <- fig$x$layout$shapes
    if (is.list(shps) && length(shps) > 0L) {
        for (i in seq_along(shps)) {
            s <- shps[[i]]
            if (is.null(s)) next
            if (is_paper_ref(s$xref)) {
                if (is.numeric(s$x0)) s$x0 <- remap_x(s$x0)
                if (is.numeric(s$x1)) s$x1 <- remap_x(s$x1)
            }
            if (is_paper_ref(s$yref)) {
                if (is.numeric(s$y0)) s$y0 <- remap_y(s$y0)
                if (is.numeric(s$y1)) s$y1 <- remap_y(s$y1)
            }
            shps[[i]] <- s
        }
        fig$x$layout$shapes <- shps
    }

    fig
}

#' Hide jitter points from plotly legend
#'
#' Hides jitter point traces from the legend by setting showlegend to FALSE.
#' The jitter points remain visible in the plot but do not clutter the legend
#' with individual point entries.
#'
#' @param fig A plotly figure object containing scatter traces for jitter points.
#'
#' @return The modified plotly figure with jitter points hidden from the legend.
#'
#' @details This function iterates through all traces in the plotly figure and
#'   identifies scatter traces that represent jitter points (mode = "markers").
#'   For each jitter trace, it sets showlegend to FALSE, preventing them from
#'   appearing in the legend while keeping them visible in the plot. Box traces
#'   and other trace types are returned unchanged.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_hide_jitter_from_legend
.hide_jitter_from_legend <- function(fig) {
    stopifnot("plotly" %in% class(fig))
    for (i in seq_along(fig$x$data)) {
        fig_data <- fig$x$data[[i]]
        if (!is.null(fig_data$type) && fig_data$type == "scatter" && !is.null(fig_data$mode) && fig_data$mode == "markers") {
            fig_data$showlegend <- FALSE
        }
        fig$x$data[[i]] <- fig_data
    }
    fig
}

#' Normalize DotPlot markers for Plotly rendering
#'
#' `plotthis::DotPlot()` draws its dots with `shape = 21` (a filled circle with
#' a separate outline) and maps `size_by` through `ggplot2::scale_size_area()`.
#' When such a layer is converted with `ggplotly()`, the marker outline keeps a
#' constant pixel width, so small dots can appear as hollow rings dominated by
#' their border rather than filled circles. This helper forces every marker
#' trace to render as a filled circle with a thin, uniform outline so that
#' mapping `size_by` only changes the dot diameter while the fill continues to
#' occupy the entire dot.
#'
#' @param fig A plotly figure object produced by `ggplotly()`.
#'
#' @return The modified plotly figure with normalized dot markers.
#'
#' @details This function iterates through all traces in the plotly figure and
#'   identifies scatter traces drawn in "markers" mode. For each such trace it
#'   forces the marker symbol to a filled "circle" and sets a thin, uniform
#'   black outline, while leaving the marker fill colors and sizes untouched.
#'   Non-marker traces are returned unchanged.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_normalize_dot_markers
.normalize_dot_markers <- function(fig) {
    stopifnot("plotly" %in% class(fig))
    for (i in seq_along(fig$x$data)) {
        trace <- fig$x$data[[i]]
        is_marker <- (is.null(trace$type) || trace$type %in% c("scatter", "scattergl")) &&
            !is.null(trace$mode) && grepl("markers", trace$mode)
        if (!is_marker) {
            next
        }
        if (is.null(trace$marker)) {
            trace$marker <- list()
        }
        trace$marker$symbol <- "circle"
        if (is.null(trace$marker$line)) {
            trace$marker$line <- list()
        }
        trace$marker$line$width <- 0.5
        trace$marker$line$color <- "black"
        fig$x$data[[i]] <- trace
    }
    fig
}


#'
#' Adds linear or LOESS fit line traces to a plotly figure, handling subplot panels
#' when faceting is applied. Determines subplot axes from existing traces and adds
#' fit lines to each panel.
#'
#' @param fig A plotly figure object.
#' @param df Data frame containing the full dataset.
#' @param x.col Character. Name of the column for x-axis values.
#' @param y.col Character. Name of the column for y-axis values.
#' @param split.by Character vector or NULL. Column name(s) used for faceting.
#' @param group.col Character or NULL. Column name for color grouping.
#' @param color_mapping Named character vector or NULL. Mapping of group names to colors.
#' @param line_color Character. Color for ungrouped fit lines.
#' @param fit_type Character. Type of fit: "linear" or "loess".
#' @param span Numeric. Span parameter for LOESS smoothing (ignored for linear).
#' @param line_width Numeric. Width of the fit lines.
#'
#' @return The modified plotly figure with fit lines added to all subplot panels.
#'
#' @author Jared Andrews
#' @keywords internal
#' @rdname INTERNAL_add_fit_lines_to_subplots
.add_fit_lines_to_subplots <- function(fig, df, x.col, y.col, split.by = NULL, group.col = NULL,
                                       color_mapping = NULL, line_color = "#000000",
                                       fit_type = c("linear", "loess"), span = 0.75,
                                       line_width = 3) {
    fit_type <- match.arg(fit_type)

    # Determine facet levels if split.by is provided
    if (!is.null(split.by) && length(split.by) > 0 && all(split.by %in% names(df))) {
        if (length(split.by) == 1) {
            # Preserve factor level order if it's a factor
            if (is.factor(df[[split.by]])) {
                facet_levels <- levels(df[[split.by]])
            } else {
                facet_levels <- unique(as.character(df[[split.by]]))
            }
            df$`.facet_combined` <- as.character(df[[split.by]])
        } else {
            df$`.facet_combined` <- apply(df[, split.by, drop = FALSE], 1, paste, collapse = "_")
            facet_levels <- unique(df$`.facet_combined`)
        }
    } else {
        facet_levels <- NULL
        df$`.facet_combined` <- "all"
    }

    # Extract axis pairs in order by sorting by axis number
    # This ensures x_y comes before x2_y2, etc.
    axis_pairs_raw <- lapply(fig$x$data, function(tr) {
        xaxis <- if (is.null(tr$xaxis)) "x" else tr$xaxis
        yaxis <- if (is.null(tr$yaxis)) "y" else tr$yaxis
        list(x = xaxis, y = yaxis)
    })

    # Get unique pairs while preserving first occurrence order
    seen_keys <- character(0)
    axis_pairs <- list()
    for (pair in axis_pairs_raw) {
        key <- paste0(pair$x, "_", pair$y)
        if (!key %in% seen_keys) {
            seen_keys <- c(seen_keys, key)
            axis_pairs <- c(axis_pairs, list(pair))
        }
    }

    # Sort axis pairs by axis number to match facet order
    # x/y -> 1, x2/y2 -> 2, etc.
    get_axis_num <- function(pair) {
        x_num <- as.numeric(sub("^x", "", pair$x))
        if (is.na(x_num)) x_num <- 1
        x_num
    }
    axis_order <- order(vapply(axis_pairs, get_axis_num, numeric(1)))
    axis_pairs <- axis_pairs[axis_order]

    # If no traces found, default to main axes
    if (length(axis_pairs) == 0) {
        axis_pairs <- list(list(x = "x", y = "y"))
    }

    # Track which trace names we've added to avoid duplicate legend entries
    added_names <- character(0)

    # Process each subplot panel
    for (idx in seq_along(axis_pairs)) {
        pair <- axis_pairs[[idx]]

        # Determine which facet level this panel corresponds to
        if (!is.null(facet_levels) && idx <= length(facet_levels)) {
            facet_val <- facet_levels[idx]
            subset_df <- df[df$`.facet_combined` == facet_val, , drop = FALSE]
        } else if (is.null(facet_levels)) {
            subset_df <- df
        } else {
            # More panels than facet levels - skip
            next
        }

        # Skip if no data in this panel
        if (nrow(subset_df) == 0) {
            next
        }

        # Compute fit data for this panel
        if (fit_type == "linear") {
            fit_data <- .compute_linear_fit(
                df = subset_df,
                x.col = x.col,
                y.col = y.col,
                group.col = group.col
            )
        } else {
            fit_data <- .compute_loess_fit(
                df = subset_df,
                x.col = x.col,
                y.col = y.col,
                group.col = group.col,
                span = span
            )
        }

        if (is.null(fit_data)) {
            next
        }

        fit_name_prefix <- if (fit_type == "linear") "Linear Fit" else "Best Fit"

        if (is.data.frame(fit_data)) {
            # Single global fit line for this panel
            trace_name <- fit_name_prefix
            show_legend <- !trace_name %in% added_names

            fig <- fig |>
                plotly::add_lines(
                    data = fit_data,
                    x = ~x,
                    y = ~y,
                    xaxis = pair$x,
                    yaxis = pair$y,
                    line = list(color = line_color, width = line_width),
                    name = trace_name,
                    legendgroup = trace_name,
                    showlegend = show_legend,
                    inherit = FALSE
                )
            added_names <- c(added_names, trace_name)
        } else {
            # Grouped fit lines (fit_data is a list)
            for (group_name in names(fit_data)) {
                group_fit <- fit_data[[group_name]]
                if (is.null(group_fit) || nrow(group_fit) == 0) {
                    next
                }

                # Get color for this group
                if (!is.null(color_mapping) && group_name %in% names(color_mapping)) {
                    grp_color <- color_mapping[[group_name]]
                } else {
                    grp_color <- line_color
                }

                trace_name <- paste(fit_name_prefix, group_name)
                show_legend <- !trace_name %in% added_names

                fig <- fig |>
                    plotly::add_lines(
                        data = group_fit,
                        x = ~x,
                        y = ~y,
                        xaxis = pair$x,
                        yaxis = pair$y,
                        line = list(color = grp_color, width = line_width),
                        name = trace_name,
                        legendgroup = trace_name,
                        showlegend = show_legend,
                        inherit = FALSE
                    )
                added_names <- c(added_names, trace_name)
            }
        }
    }

    fig
}

#' Create an empty ggplot2 plot or plotly plot with input text
#'
#' This function creates an empty ggplot2 or plotly plot and places a user-provided text
#' string in the middle of the plot.
#'
#' @param text Character scalar to show in plot area.
#' @param plotly Boolean indicating whether to return a plotly object.
#' @return Either a ggplot object or a plotly object if \code{plotly = TRUE}.
#'
#' @author Jared Andrews
#'
#' @rdname INTERNAL_empty_plot
#' @seealso \code{\link[ggplot2]{geom_text}}, \code{\link[ggplot2]{theme_void}}
#' @importFrom ggplot2 theme_void geom_text theme margin ggplot aes
#' @importFrom plotly ggplotly layout
.empty_plot <- function(text = NULL, plotly = FALSE) {
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

    return(plot)
}

#' Check if column inputs contain mixed data types
#'
#' This function validates that a vector of column names from a data frame contains
#' columns of only one data type category: either all numeric OR all categorical
#' (factor/character). Returns \code{FALSE} for mixed numeric + categorical columns.
#' Single columns always return \code{TRUE}. Used for Shiny plotting module input validation.
#'
#' @param inputs Character vector of column names to validate.
#' @param d Data frame containing the columns specified in \code{inputs}.
#'
#' @return Logical scalar: \code{TRUE} if all numeric OR all categorical (factor/character);
#'   \code{FALSE} if mixed numeric + categorical/factor detected.
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
#' @seealso \code{\link[base]{for}}
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

#' Resolve facet axis sharing from facet.scales
#'
#' Converts a \code{facet.scales} string (one of \code{"fixed"}, \code{"free"},
#' \code{"free_x"}, \code{"free_y"}) into the \code{shareX} / \code{shareY}
#' logical values expected by \code{plotly::subplot}.
#'
#' @param facet.scales Character, one of \code{"fixed"} (default),
#'   \code{"free"}, \code{"free_x"}, or \code{"free_y"}.
#'
#' @return A named list with logical elements \code{shareX} and \code{shareY}.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_resolve_facet_sharing
#' @keywords internal
.resolve_facet_sharing <- function(facet.scales = "fixed") {
    shareX <- TRUE
    shareY <- TRUE
    if (facet.scales == "free") {
        shareX <- FALSE
        shareY <- FALSE
    } else if (facet.scales == "free_x") {
        shareX <- FALSE
    } else if (facet.scales == "free_y") {
        shareY <- FALSE
    }
    list(shareX = shareX, shareY = shareY)
}

#' Resolve number of rows for a faceted subplot grid
#'
#' Given the number of facet levels and optional user-supplied
#' \code{facet.nrow} / \code{facet.ncol} values, computes the \code{nrows}
#' argument to pass to \code{plotly::subplot}.
#'
#' Resolution rules:
#' \itemize{
#'   \item Both \code{NULL}/\code{NA}: returns 1 (single row, preserves legacy behaviour).
#'   \item Only \code{facet.nrow} supplied: returns that value.
#'   \item Only \code{facet.ncol} supplied: returns \code{ceiling(n_facets / facet.ncol)}.
#'   \item Both supplied: \code{facet.nrow} wins.
#' }
#' The result is clamped to the range \code{[1, n_facets]}.
#'
#' @param n_facets Integer, number of facet panels.
#' @param facet.nrow Optional integer, user-requested number of rows.
#' @param facet.ncol Optional integer, user-requested number of columns.
#'
#' @return A positive integer giving the number of rows for
#'   \code{plotly::subplot}.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_resolve_facet_layout
#' @keywords internal
.resolve_facet_layout <- function(n_facets, facet.nrow = NULL, facet.ncol = NULL) {
    n_facets <- max(1L, as.integer(n_facets))

    .is_set <- function(x) {
        !is.null(x) && length(x) == 1L && !is.na(x) && is.numeric(x) && as.integer(x) >= 1L
    }

    if (.is_set(facet.nrow)) {
        nrows <- as.integer(facet.nrow)
    } else if (.is_set(facet.ncol)) {
        nrows <- as.integer(ceiling(n_facets / as.integer(facet.ncol)))
    } else {
        nrows <- 1L
    }

    # Clamp to [1, n_facets]
    nrows <- max(1L, min(nrows, n_facets))
    nrows
}

#' Build facet subplot annotations
#'
#' Creates a list of plotly annotation objects suitable for labelling faceted
#' subplots arranged in a grid of \code{nrows} rows. When \code{nrows = 1}
#' (the default) the behaviour matches the previous single-row layout.
#' Optionally appends a shared X-axis title (bottom centre) and a shared,
#' rotated Y-axis title (left centre).
#'
#' @param facet_levels Character vector of facet level labels, one per subplot.
#' @param x.title Optional character, shared X-axis title. Default: \code{NULL}.
#' @param y.title Optional character, shared Y-axis title. Default: \code{NULL}.
#' @param title.font.size Numeric, font size for all annotation text.
#'   Default: 14.
#' @param nrows Integer, number of rows the faceted subplots are arranged in.
#'   Used to compute per-subplot annotation coordinates for multi-row grids
#'   when \code{fig} is not supplied. Default: 1.
#' @param fig Optional plotly figure. When supplied, per-panel title
#'   coordinates are read directly from the figure's xaxis/yaxis domains so
#'   that titles stay aligned with panels after domain-rewriting helpers such
#'   as \code{.apply_facet_subplot_spacing()}. If \code{NULL} (the default),
#'   coordinates are computed from \code{nrows} assuming evenly spaced
#'   panels filling the full paper area.
#' @param title.offset Numeric fraction of the figure height to place each
#'   subplot title above the top of its panel. Default: \code{0.02}.
#'
#' @return A list of annotation lists suitable for \code{plotly::layout(annotations = ...)}.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_build_facet_annotations
#' @keywords internal
.build_facet_annotations <- function(facet_levels, x.title = NULL,
                                     y.title = NULL,
                                     title.font.size = 14,
                                     nrows = 1,
                                     fig = NULL,
                                     title.offset = 0.02) {
    n_facets <- length(facet_levels)

    # Prefer actual axis domains on the figure (if supplied) so titles follow
    # any domain rewriting performed by e.g. .apply_facet_subplot_spacing().
    panel_coords <- NULL
    if (!is.null(fig) && !is.null(fig$x) && !is.null(fig$x$layout)) {
        axis_name <- function(prefix, i) if (i == 1L) prefix else paste0(prefix, i)
        coords <- lapply(seq_len(n_facets), function(i) {
            xa <- fig$x$layout[[axis_name("xaxis", i)]]
            ya <- fig$x$layout[[axis_name("yaxis", i)]]
            if (is.null(xa) || is.null(ya)) {
                return(NULL)
            }
            xd <- xa$domain
            yd <- ya$domain
            if (!is.numeric(xd) || length(xd) != 2L ||
                !is.numeric(yd) || length(yd) != 2L) {
                return(NULL)
            }
            list(x_center = mean(xd), y_title = yd[2] + title.offset)
        })
        if (!any(vapply(coords, is.null, logical(1)))) {
            panel_coords <- coords
        }
    }

    # Fallback: compute from nrows/ncols assuming even, full-paper panels.
    if (is.null(panel_coords)) {
        nrows <- max(1L, as.integer(nrows))
        ncols <- max(1L, as.integer(ceiling(n_facets / nrows)))
        subplot_width <- 1.0 / ncols
        subplot_height <- 1.0 / nrows
        panel_coords <- lapply(seq_len(n_facets), function(i) {
            col_idx <- ((i - 1L) %% ncols)
            row_idx <- ((i - 1L) %/% ncols)
            list(
                x_center = col_idx * subplot_width + (subplot_width / 2),
                y_title = (1 - row_idx * subplot_height) + 0.05 * subplot_height
            )
        })
    }

    # Per-subplot title annotations anchored just above each panel's top edge.
    annotations <- lapply(seq_along(facet_levels), function(i) {
        pc <- panel_coords[[i]]
        list(
            x = pc$x_center,
            y = pc$y_title,
            xref = "paper",
            yref = "paper",
            text = as.character(facet_levels[i]),
            showarrow = FALSE,
            xanchor = "center",
            yanchor = "bottom",
            font = list(size = title.font.size)
        )
    })

    # Shared X-axis title at bottom centre
    if (!is.null(x.title)) {
        annotations <- c(annotations, list(list(
            x = 0.5,
            y = -0.1,
            xref = "paper",
            yref = "paper",
            text = x.title,
            showarrow = FALSE,
            xanchor = "center",
            yanchor = "top",
            font = list(size = title.font.size)
        )))
    }

    # Shared Y-axis title at left centre (rotated)
    if (!is.null(y.title)) {
        annotations <- c(annotations, list(list(
            x = -0.05,
            y = 0.5,
            xref = "paper",
            yref = "paper",
            text = y.title,
            showarrow = FALSE,
            xanchor = "center",
            yanchor = "middle",
            textangle = -90,
            font = list(size = title.font.size)
        )))
    }

    annotations
}

#' Add multi-axis traces to a plotly figure
#'
#' Appends scatter traces for each element of a multi-valued \code{x} or
#' multi-valued \code{y} vector to an existing plotly figure.
#' Handles data ordering, line/marker styling, and palette colouring.
#'
#' @param fig A plotly figure object to add traces to.
#' @param data A data.frame containing the plot data.
#' @param x Character vector of x-column name(s).
#' @param y Character vector of y-column name(s).
#' @param order.cols Character vector of column name(s) used to sort trace
#'   data before plotting.
#' @param plot.mode Character, plotly scatter mode (e.g. \code{"lines"},
#'   \code{"markers"}, \code{"lines+markers"}).
#' @param line.type Character, plotly dash style for lines.
#' @param palette.selection Character vector of hex colours.
#' @param show.legend Logical, whether traces should appear in the legend.
#'   Default: \code{TRUE}.
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
#'   \code{shiny::isolate}.
#'
#' @return The modified plotly figure with updated annotation fonts.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_apply_axis_title_to_annotations
.apply_axis_title_to_annotations <- function(fig, input, isolate_fn = isolate) {
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
#' positioned using the supplied \code{title_y} value in the plotly
#' layout.
#'
#' @param fig A plotly figure object.
#' @param input Shiny input object containing title font fields.
#' @param isolate_fn Function to isolate reactive values.
#' @param title_y Numeric y position for the plot title in the plotly
#'   layout. Defaults to \code{0.05}. 
#' @param title_x Numeric position for the title in the plotly layout.
#' @return The modified plotly figure with updated title styling.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_apply_title_layout
.apply_title_layout <- function(plot, input, isolate_fn, title_y = 0.95, title_x = 0.5){
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
#' The \code{renderPlotly} block in every plot module server applies the same
#' user-configurable margins. This helper extracts that block into one call.
#'
#' @param fig A plotly figure object.
#' @param input Shiny input object. Expected to contain \code{margin.t},
#'   \code{margin.b}, \code{margin.l}, and \code{margin.r}.
#'
#' @return The plotly figure with margins applied.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_apply_render_margins
.apply_render_margins <- function(fig, input) {
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
#' Clean and validate facet dimension value for lineplot module
#'
#' @description Internal helper function that validates and sanitizes a numeric 
#'   value intended for use as a **facet dimension** (rows or columns) in a 
#'   **ggplot2 faceting layout**. Ensures the value is a positive numeric 
#'   greater than or equal to 1, returning `NULL` for invalid inputs to 
#'   gracefully handle missing or malformed facet specifications.
#'
#' @details This function is used within **VizModules** lineplot functions to 
#'   process user-supplied facet dimensions before passing to `facet_grid()` or 
#'   `facet_wrap()`. Invalid values trigger sensible defaults rather than 
#'   breaking the plot layout.
#'   **Valid inputs** return unchanged. **Invalid inputs** (NULL, NA, non-numeric, 
#'   < 1) return `NULL`.
#' @param val `numeric(1)` or `NULL`  
#'   Proposed facet dimension value (number of rows or columns).
#' @return `numeric(1)` or `NULL`  
#'   Validated facet dimension value, or `NULL` if invalid.
#' @author Jacob Martin
#' @keywords internal
#'
.clean_facet_dim <- function(val) {
    if (is.null(val) || length(val) == 0 || is.na(val) ||
        !is.numeric(val) || val < 1) {
        return(NULL)
    }
    val
}
