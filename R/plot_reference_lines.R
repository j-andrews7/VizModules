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
#' @export
#' @examples
#' parse_numeric_list("1, 5, 8")
#' parse_numeric_list("")
parse_numeric_list <- function(text) {
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
#' @export
#' @examples
#' recycle_line_style(c("red", "blue"), 2, "black")
#' recycle_line_style(NULL, 3, "black")
recycle_line_style <- function(values, n, default) {
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
#' @export
#' @examples
#' linetype_to_dash("dashed")
#' linetype_to_dash("dotted")
linetype_to_dash <- function(linetype) {
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
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#' add_hlines(fig, intercepts = c(20, 30), colors = c("red", "blue"))
add_hlines <- function(fig, intercepts, colors = "#000000", widths = 1, linetypes = "solid", opacities = 1) {
    if (is.null(intercepts) || length(intercepts) == 0) {
        return(list())
    }

    n <- length(intercepts)
    colors <- recycle_line_style(colors, n, "#000000")
    widths <- recycle_line_style(widths, n, 1)
    linetypes <- recycle_line_style(linetypes, n, "solid")
    opacities <- recycle_line_style(opacities, n, 1)

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
                    dash = linetype_to_dash(linetypes[i])
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
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#' add_vlines(fig, intercepts = c(3, 4), colors = c("red", "blue"))
add_vlines <- function(fig, intercepts, colors = "#000000", widths = 1, linetypes = "solid", opacities = 1) {
    if (is.null(intercepts) || length(intercepts) == 0) {
        return(list())
    }

    n <- length(intercepts)
    colors <- recycle_line_style(colors, n, "#000000")
    widths <- recycle_line_style(widths, n, 1)
    linetypes <- recycle_line_style(linetypes, n, "solid")
    opacities <- recycle_line_style(opacities, n, 1)

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
                    dash = linetype_to_dash(linetypes[i])
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
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#' add_ablines(fig, slopes = 1, intercepts = 0, colors = "red")
add_ablines <- function(fig, slopes, intercepts, colors = "#000000", widths = 1, linetypes = "solid", opacities = 1) {
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

    colors <- recycle_line_style(colors, n, "#000000")
    widths <- recycle_line_style(widths, n, 1)
    linetypes <- recycle_line_style(linetypes, n, "solid")
    opacities <- recycle_line_style(opacities, n, 1)

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
                    dash = linetype_to_dash(linetypes[i])
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
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#' add_reference_lines(fig,
#'     hline.intercepts = "20, 30", hline.colors = "red, blue",
#'     vline.intercepts = "3", abline.slopes = "5", abline.intercepts = "0"
#' )
add_reference_lines <- function(fig,
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
    h_intercepts <- parse_numeric_list(hline.intercepts)
    if (!is.null(h_intercepts)) {
        h_colors <- if (!is.null(hline.colors) && nzchar(hline.colors)) {
            trimws(unlist(strsplit(hline.colors, ",")))
        } else {
            "#000000"
        }
        h_widths <- parse_numeric_list(hline.widths)
        if (is.null(h_widths)) h_widths <- 1
        h_linetypes <- string_to_linetypes(hline.linetypes)
        h_opacities <- parse_numeric_list(hline.opacities)
        if (is.null(h_opacities)) h_opacities <- 1
        h_shapes <- add_hlines(fig, h_intercepts, h_colors, h_widths, h_linetypes, h_opacities)
        all_shapes <- c(all_shapes, h_shapes)
    }

    # Parse and add vertical line shapes
    v_intercepts <- parse_numeric_list(vline.intercepts)
    if (!is.null(v_intercepts)) {
        v_colors <- if (!is.null(vline.colors) && nzchar(vline.colors)) {
            trimws(unlist(strsplit(vline.colors, ",")))
        } else {
            "#000000"
        }
        v_widths <- parse_numeric_list(vline.widths)
        if (is.null(v_widths)) v_widths <- 1
        v_linetypes <- string_to_linetypes(vline.linetypes)
        v_opacities <- parse_numeric_list(vline.opacities)
        if (is.null(v_opacities)) v_opacities <- 1
        v_shapes <- add_vlines(fig, v_intercepts, v_colors, v_widths, v_linetypes, v_opacities)
        all_shapes <- c(all_shapes, v_shapes)
    }

    # Parse and add diagonal line shapes
    ab_slopes <- parse_numeric_list(abline.slopes)
    ab_intercepts <- parse_numeric_list(abline.intercepts)
    if (!is.null(ab_slopes) && !is.null(ab_intercepts)) {
        ab_colors <- if (!is.null(abline.colors) && nzchar(abline.colors)) {
            trimws(unlist(strsplit(abline.colors, ",")))
        } else {
            "#000000"
        }
        ab_widths <- parse_numeric_list(abline.widths)
        if (is.null(ab_widths)) ab_widths <- 1
        ab_linetypes <- string_to_linetypes(abline.linetypes)
        ab_opacities <- parse_numeric_list(abline.opacities)
        if (is.null(ab_opacities)) ab_opacities <- 1
        ab_shapes <- add_ablines(fig, ab_slopes, ab_intercepts, ab_colors, ab_widths, ab_linetypes, ab_opacities)
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
#' [uniform_plotly_inputs_ui()]. Updates the `newshape` layout property to
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
#' @export
#' @examples
#' fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
#' shape_input <- list(
#'     shape.fill = "#ff000030", shape.line.color = "#ff0000",
#'     shape.line.width = 2, shape.linetype = "solid", shape.opacity = 0.5
#' )
#' apply_plotly_newshape(fig, shape_input, isolate_fn = identity)
apply_plotly_newshape <- function(fig, input, isolate_fn = isolate) {
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

