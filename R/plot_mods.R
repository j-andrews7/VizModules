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
#' Applies common mathematical transformations (logarithmic, absolute value, square root) 
#' to a specified numeric column in a data frame. Returns original data frame unchanged 
#' when no transformation is specified or input is invalid.
#' 
#' @param df A data frame containing the column to be transformed
#' @param col_names \code{character(1)} Name of the column to transform Must be a vector e.g. c("Species", "Region")
#' @param transformation \code{character(1)} or \code{NULL}. One of \code{c("", "log2", 
#'   "log", "log10", "neg_log10", "log1p", "abs", "sqrt")}. Use \code{""} or \code{NULL} 
#'   for no transformation.
#'   
#' @return A data frame identical to input \code{df} but with specified column transformed
#' 
#' @details 
#' Supported transformations include:
#' \describe{
#'   \item{\code{"log2"}}{\eqn{\log_2(x)} - base 2 logarithm}
#'   \item{\code{"log"}}{\eqn{\ln(x)} - natural logarithm (base \eqn{e \approx 2.718})}
#'   \item{\code{"log10"}}{\eqn{\log_{10}(x)} - base 10 logarithm}
#'   \item{\code{"neg_log10"}}{\eqn{-\log_{10}(x)} - negative base 10 logarithm (p-values)}
#'   \item{\code{"log1p"}}{\eqn{\ln(1+x)} - natural log of (1 + x), stable for values near 0}
#'   \item{\code{"abs"}}{\eqn{|x|} - absolute value}
#'   \item{\code{"sqrt"}}{\eqn{\sqrt{x}} - square root}
#' }
#'
#' @author Jacob Martin
#' @keywords internal
#' @export
.adjust_column_values <- function(df, col_names, transformation = NULL) {
    if (is.null(transformation) || transformation == ""){
        return(df)
    }

    for (i in seq_along(col_names)){
        col_vector <- df[[col_names[i]]]

        if (!is.numeric(col_vector)){
            stop(paste("Column", col_names[i], "is not numeric"))
        }

        if (transformation == "log2"){
            df[[col_names[i]]] <- log2(col_vector)
        } else if (transformation == "log"){
            df[[col_names[i]]] <- log(col_vector)
        } else if (transformation == "log10"){
            df[[col_names[i]]] <- log10(col_vector)
        } else if (transformation == "neg_log10"){
            df[[col_names[i]]] <- -log10(col_vector)
        } else if (transformation == "log1p"){
            df[[col_names[i]]] <- log1p(col_vector)
        } else if (transformation == "abs"){
            df[[col_names[i]]] <- abs(col_vector)
        } else if (transformation == "sqrt"){
            df[[col_names[i]]] <- sqrt(col_vector)
        } else {
            stop(paste("Unkown Transformation: ", transformation))
        }
    }
    return(df)

}

#' Match plotly trace points to original data points with panel awareness
#'
#' When faceting is applied with show.others=TRUE or split.show.all.others=TRUE,
#' points appear in multiple panels but should only be highlighted/annotated in
#' their "home" panel. This function matches trace points to data points while
#' considering panel membership.
#'
#' @param trace A plotly trace object.
#' @param plot_data Data frame containing the original plot data.
#' @param x_match_col Name of the column in plot_data for x coordinates.
#' @param y_match_col Name of the column in plot_data for y coordinates.
#' @param split.by Character vector of split.by variable names (length 0-2).
#' @param panel_filter Named list of filter values for the panel this trace belongs to.
#'
#' @return A list with:
#'   - `data_indices`: Indices in plot_data that match this trace AND belong to same panel
#'   - `trace_indices`: Corresponding indices within the trace
#'
#' @author Jared Andrews
#' @rdname INTERNAL_match_trace_to_data_with_panel
#' @keywords internal
.match_trace_to_data_with_panel <- function(trace, plot_data, x_match_col, y_match_col,
                                             split.by, panel_filter) {
    # If no coordinates in trace, return empty
    if (is.null(trace$x) || is.null(trace$y) || !is.numeric(trace$x) || !is.numeric(trace$y)) {
        return(list(data_indices = integer(0), trace_indices = integer(0)))
    }

    # Create coordinate strings for matching (rounded to avoid floating point issues)
    trace_coords <- paste0(round(trace$x, 10), "_", round(trace$y, 10))
    plot_coords <- paste0(
        round(plot_data[[x_match_col]], 10), "_",
        round(plot_data[[y_match_col]], 10)
    )

    # If no split.by, simple coordinate matching
    if (is.null(split.by) || length(split.by) == 0) {
        matches <- match(trace_coords, plot_coords)
        valid_idx <- which(!is.na(matches))
        return(list(
            data_indices = matches[valid_idx],
            trace_indices = valid_idx
        ))
    }

    # With faceting, we need to check panel membership
    # Find points that match BOTH coordinates AND panel membership
    data_indices <- integer(0)
    trace_indices <- integer(0)

    for (i in seq_along(trace_coords)) {
        # Find data points with matching coordinates
        coord_matches <- which(plot_coords == trace_coords[i])

        if (length(coord_matches) > 0) {
            # Among coordinate matches, find the one that belongs to this panel
            for (data_idx in coord_matches) {
                # Check if this data point belongs to the trace's panel
                point_matches_panel <- .check_point_panel_membership(
                    plot_data[data_idx, , drop = FALSE],
                    split.by,
                    panel_filter
                )

                if (point_matches_panel) {
                    data_indices <- c(data_indices, data_idx)
                    trace_indices <- c(trace_indices, i)
                    break # Only match once per trace point
                }
            }
        }
    }

    list(data_indices = data_indices, trace_indices = trace_indices)
}

#' Check if a data point belongs to a panel
#'
#' Checks if a data point's split.by values match the panel's filter values.
#'
#' @param point_data Single-row data frame for the point.
#' @param split.by Character vector of split.by variable names.
#' @param panel_filter Named list of filter values for the panel (can be NULL).
#'
#' @return Logical indicating if point belongs to panel.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_check_point_panel_membership
#' @keywords internal
.check_point_panel_membership <- function(point_data, split.by, panel_filter) {
    # If no panel filter, assume it matches
    if (is.null(panel_filter)) {
        return(TRUE)
    }

    # Check each split.by variable
    for (var in split.by) {
        if (!is.null(panel_filter[[var]])) {
            if (as.character(point_data[[var]]) != panel_filter[[var]]) {
                return(FALSE)
            }
        }
    }

    TRUE
}

#' Build panel filter map from plotly figure
#'
#' Analyzes a plotly figure to determine which panel (subplot) each trace belongs to
#' and what filter values define each panel based on split.by variables.
#'
#' @param fig A plotly figure object.
#' @param split.by Character vector of split.by variable names (length 0-2).
#' @param plot_data Data frame containing the original plot data.
#'
#' @return A list with:
#'   - `trace_to_panel`: Integer vector mapping trace index (1-based R indexing) to panel index
#'   - `panel_to_filter`: List mapping panel index to filter values (named list)
#'   - `n_panels`: Total number of panels
#'
#' @author Jared Andrews
#' @rdname INTERNAL_build_panel_filter_map
#' @keywords internal
.build_panel_filter_map <- function(fig, split.by, plot_data) {
    result <- list(
        trace_to_panel = integer(0),
        panel_to_filter = list(),
        n_panels = 1
    )

    if (is.null(fig) || is.null(fig$x) || is.null(fig$x$data) || length(fig$x$data) == 0) {
        return(result)
    }

    # If no splitting, all traces belong to panel 1
    if (is.null(split.by) || length(split.by) == 0) {
        result$trace_to_panel <- rep(1L, length(fig$x$data))
        result$panel_to_filter[[1]] <- list()
        return(result)
    }

    # Map traces to panels based on xaxis/yaxis references
    trace_to_panel <- integer(length(fig$x$data))
    panel_axes <- list()
    panel_counter <- 0

    for (i in seq_along(fig$x$data)) {
        trace <- fig$x$data[[i]]

        # Get xaxis and yaxis references
        xaxis <- if (!is.null(trace$xaxis)) trace$xaxis else "x"
        yaxis <- if (!is.null(trace$yaxis)) trace$yaxis else "y"

        # Find or create panel for this axis combination
        panel_key <- paste0(xaxis, "_", yaxis)
        existing_panel <- NULL

        for (j in seq_along(panel_axes)) {
            if (identical(panel_axes[[j]], panel_key)) {
                existing_panel <- j
                break
            }
        }

        if (is.null(existing_panel)) {
            panel_counter <- panel_counter + 1
            panel_axes[[panel_counter]] <- panel_key
            trace_to_panel[i] <- panel_counter
        } else {
            trace_to_panel[i] <- existing_panel
        }
    }

    result$n_panels <- panel_counter
    result$trace_to_panel <- trace_to_panel

    # Extract panel filters from subplot titles in layout annotations
    annotations <- fig$x$layout$annotations
    if (!is.null(annotations) && length(annotations) > 0) {
        title_annotations <- Filter(function(a) {
            isFALSE(a$showarrow) && !is.null(a$text) && a$text != ""
        }, annotations)

        # Match annotations to panels by their yref/xref
        for (panel_idx in seq_len(panel_counter)) {
            # Find the axis references for this panel
            panel_key <- panel_axes[[panel_idx]]
            axes <- strsplit(panel_key, "_", fixed = TRUE)[[1]]
            xaxis_ref <- axes[1]
            yaxis_ref <- axes[2]

            # Find annotation for this panel
            for (anno in title_annotations) {
                anno_xref <- if (!is.null(anno$xref)) gsub(" domain", "", anno$xref) else "x"
                anno_yref <- if (!is.null(anno$yref)) gsub(" domain", "", anno$yref) else "y"

                # Handle NA values in comparisons
                xref_match <- !is.na(anno_xref) && !is.na(xaxis_ref) && anno_xref == xaxis_ref
                yref_match <- !is.na(anno_yref) && !is.na(yaxis_ref) && anno_yref == yaxis_ref

                if (xref_match || yref_match) {
                    # Parse the title text to extract filter values
                    filter_values <- .parse_panel_title(anno$text, split.by)
                    result$panel_to_filter[[panel_idx]] <- filter_values
                    break
                }
            }
        }
    }

    result
}

#' Parse panel title to extract filter values
#'
#' Parses a plotly subplot title to extract the values of split.by variables.
#'
#' @param title_text Character string of the panel title.
#' @param split.by Character vector of split.by variable names.
#'
#' @return Named list of filter values.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_parse_panel_title
#' @keywords internal
.parse_panel_title <- function(title_text, split.by) {
    filter_values <- list()

    if (length(split.by) == 1) {
        # Single variable: "Species: setosa"
        value <- sub(paste0("^", split.by[1], ":\\s*"), "", title_text)
        value <- gsub("<br>.*$", "", value, fixed = FALSE)
        filter_values[[split.by[1]]] <- trimws(value)
    } else if (length(split.by) == 2) {
        # Two variables: "Species: setosa<br>Group: A"
        lines <- strsplit(title_text, "<br>", fixed = TRUE)[[1]]
        for (j in seq_along(split.by)) {
            if (j <= length(lines)) {
                value <- sub(paste0("^", split.by[j], ":\\s*"), "", lines[j])
                filter_values[[split.by[j]]] <- trimws(value)
            }
        }
    }

    filter_values
}