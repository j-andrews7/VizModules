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
#' @importFrom stats lm coef
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
#' @importFrom stats loess predict
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
#' Applies supplied transformation
#' to a specified numeric column in a data frame, adding the transformation as a new column.
#' Returns original data frame unchanged when no transformation is specified or input is invalid.
#'
#' @param df A data frame containing the column to be transformed
#' @param x.col Character. Name of the column for x-axis values.
#' @param y.col Character. Name of the column for y-axis values.
#' @param color.col Character. Name of the column for color values.
#' @param x.adj.fun Character. Transformation function to apply to x-axis values, interpretable by `eval`.
#' @param y.adj.fun Character. Transformation function to apply to y-axis values, interpretable by `eval`.
#' @param color.adj.fun Character. Transformation function to apply to color values, interpretable by `eval`.
#'
#' @return A data frame identical to input \code{df} but with transformed columns added.
#'
#' @examples
#' data(mtcars)
#' mtcars_mod <- .adjust_column_values(mtcars, x.col = "mpg", x.adj.fun = "log2")
#' head(mtcars_mod$mpg.adj)
#'
#' @author Jacob Martin, Jared Andrews
#' @keywords internal
#' @export
.adjust_column_values <- function(df, x.col = NULL, y.col = NULL, color.col = NULL, x.adj.fun = NULL, y.adj.fun = NULL, color.adj.fun = NULL) {
    apply_trans <- function(d, cols, fun) {
        if (is.null(fun) || is.null(cols) || fun == "") {
            return(d)
        }

        fun_expr <- tryCatch(parse(text = fun), error = function(e) NULL)
        if (is.null(fun_expr)) {
            return(d)
        }

        for (col in cols) {
            if (col %in% names(d) && is.numeric(d[[col]])) {
                d[[paste(col, "adj", sep = ".")]] <- eval(fun_expr)(d[[col]])
            }
        }
        return(d)
    }

    df <- apply_trans(df, x.col, x.adj.fun)
    df <- apply_trans(df, y.col, y.adj.fun)
    df <- apply_trans(df, color.col, color.adj.fun)

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
                annotationTail = TRUE
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
                titleText = FALSE,
                annotationText = TRUE,
                legendText = TRUE,
                legendPosition = TRUE,
                colorbarPosition = TRUE,
                colorbarTitleText = TRUE,
                annotationTail = TRUE
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
#'   such as \code{font.type}, \code{text.colour}, \code{axis.showline},
#'   \code{axis.mirror}, \code{axis.linecolor}, \code{axis.linewidth},
#'   \code{axis.tickfont.size}, \code{axis.tickfont.color},
#'   \code{axis.tickfont.family}, \code{axis.tickangle.x},
#'   \code{axis.tickangle.y}, \code{axis.ticks}, \code{axis.tickcolor},
#'   \code{axis.ticklen}, \code{axis.tickwidth}, \code{show.major.grid.x},
#'   and \code{show.major.grid.y}.
#' @param axis_side Character. Which axis to style, either \code{"x"} or
#'   \code{"y"}. Determines whether \code{axis.tickangle.x} or
#'   \code{axis.tickangle.y} is used for the tick angle, and which
#'   gridline inputs are applied.
#' @param isolate_fn Function. A function used to isolate Shiny inputs,
#'   typically \code{shiny::isolate}. Defaults to \code{isolate}.
#'
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
.create_axis_styles <- function(input, axis_side = c("x", "y"), isolate_fn = isolate) {
    axis_side <- match.arg(axis_side)

    # Determine gridline visibility based on axis side
    # Use defaults if inputs are not present (for backwards compatibility)
    show_grid <- ifelse(axis_side == "x",
        isolate_fn(input$show.major.grid.x),
        isolate_fn(input$show.major.grid.y)
    )


    style <- list(
        title = list(
            font = list(
                size   = isolate_fn(input$axis.title.font.size),
                family = isolate_fn(input$axis.title.font.family),
                color  = isolate_fn(input$axis.title.font.color),
            )
        ),
        showline = isolate_fn(input$axis.showline),
        mirror = isolate_fn(input$axis.mirror),
        linecolor = isolate_fn(input$axis.linecolor),
        linewidth = isolate_fn(input$axis.linewidth),
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
        showgrid = show_grid
    )

    return(style)
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
        "solid"  # default
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
        if (xaxis_name == "xaxis") xaxis_name <- "xaxis"  # Handle main axis
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
#'
#' @examples
#' \dontrun{
#' # In a Shiny module server:
#' output$download.interactive <- .create_plot_download_handler(
#'   plot_reactive = reactive({my_plotly_plot}),
#'   filename_base = "my_plot"
#' )
#' }
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

#' Calculate Y-axis range from data
#'
#' Computes a numeric range for the Y-axis based on a specified column in a
#' data frame, applying a scaling factor to the maximum value. This is useful
#' for deriving dynamic axis limits directly from the underlying data.
#'
#' @param df Data frame. The data containing the Y variable.
#' @param y_data_col Character. Name of the column in \code{df} to use for
#'   calculating the Y-axis range.
#' @param y_axis_scale_factor Numeric. Multiplicative factor applied to the
#'   maximum Y value to provide additional headroom on the axis.
#'
#' @return A named list with components \code{min} and \code{max} giving the
#'   lower and upper limits for the Y-axis, or \code{NULL} if the input column
#'   is missing, non-numeric, or otherwise invalid.
#'
#' @details The function first validates that \code{y_data_col} is specified
#'   and corresponds to a numeric column in \code{df}. It then computes the
#'   minimum and maximum of that column, ignoring \code{NA} values, and scales
#'   the maximum by \code{y_axis_scale_factor}. Non-finite results are replaced
#'   by default values of 0 for the minimum and 1 for the maximum.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_calculate_y_range
.calculate_y_range <- function(df, y_data_col, y_axis_scale_factor) {
    if (is.null(y_data_col) || y_data_col == "") {
        return(NULL)
    }

    if (!y_data_col %in% names(df) || !is.numeric(df[[y_data_col]])) {
        return(NULL)
    }

    # Calculate min and max from raw data
    min.y <- min(df[[y_data_col]], na.rm = TRUE)
    max.y <- max(df[[y_data_col]], na.rm = TRUE) * y_axis_scale_factor

    # Handle edge cases
    if (!is.finite(min.y)) min.y <- 0
    if (!is.finite(max.y)) max.y <- 1

    return(list(min = min.y, max = max.y))
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
.hide_jitter_from_legend <- function(fig){

    stopifnot("plotly" %in% class(fig))
    for (i in seq_along(fig$x$data)) {
        fig_data <- fig$x$data[[i]]
        if (!is.null(fig_data$type) && fig_data$type == "scatter" && !is.null(fig_data$mode) && fig_data$mode =="markers"){
            fig_data$showlegend <- FALSE
        }
        fig$x$data[[i]] <- fig_data
    }
    fig 
}

#' Add fit line traces to all subplot panels
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

            fig <- fig %>%
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

                fig <- fig %>%
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