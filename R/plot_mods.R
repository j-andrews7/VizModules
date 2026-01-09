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

#' Determine which points belong to which subplot facet
#'
#' When using split.by with show.others = TRUE, each subplot contains both "real"
#' points (matching the facet's split.by values) and "others" points (not matching).
#' This function creates a mapping to identify which data points belong to which facet.
#'
#' @param plot_data Data frame from dittoViz with all plot data
#' @param split.by Character vector of column name(s) used for faceting (NULL if no faceting)
#' @param fig Plotly figure object containing the layout information
#'
#' @return A list with two elements:
#'   - facet_map: A list where each element corresponds to a subplot and contains
#'                the indices of plot_data rows that are "real" data for that facet
#'   - axis_to_facet: A named list mapping axis references (e.g., "x", "x2") to facet indices
#'
#' @author Jared Andrews
#' @rdname INTERNAL_get_facet_membership
#' @keywords internal
.get_facet_membership <- function(plot_data, split.by, fig) {
    # If no faceting, all points belong to the single plot
    if (is.null(split.by) || length(split.by) == 0 || all(split.by == "")) {
        return(list(
            facet_map = list(seq_len(nrow(plot_data))),
            axis_to_facet = list("x" = 1, "y" = 1)
        ))
    }

    # Get unique combinations of split.by values (these define the facets)
    # Handle both single and multiple split.by variables
    split_data <- plot_data[, split.by, drop = FALSE]
    unique_combinations <- unique(split_data)

    # Create a mapping of each row to its facet
    facet_map <- list()
    for (i in seq_len(nrow(unique_combinations))) {
        # Find all rows that match this combination
        matches <- rep(TRUE, nrow(plot_data))
        for (col in split.by) {
            matches <- matches & (as.character(plot_data[[col]]) == as.character(unique_combinations[[col]][i]))
        }
        facet_map[[i]] <- which(matches)
    }

    # Create axis-to-facet mapping based on plotly layout
    # Inspect the actual layout to find which axes exist
    axis_to_facet <- list()
    n_facets <- length(facet_map)

    # Default mapping: x/y for first subplot, x2/y2 for second, etc.
    # This is how dittoViz/plotly typically structures faceted plots
    for (i in seq_len(n_facets)) {
        if (i == 1) {
            axis_to_facet[["x"]] <- 1
            axis_to_facet[["y"]] <- 1
        } else {
            axis_to_facet[[paste0("x", i)]] <- i
            axis_to_facet[[paste0("y", i)]] <- i
        }
    }

    list(
        facet_map = facet_map,
        axis_to_facet = axis_to_facet
    )
}

#' Filter highlight indices to only include "real" points in each trace's facet
#'
#' When highlighting points in a faceted plot with show.others = TRUE, we only want
#' to highlight points that are "real" data in each facet, not "others" points.
#'
#' @param plot_data Data frame from dittoViz with all plot data
#' @param highlight_idx Integer vector of indices in plot_data to highlight
#' @param trace Plotly trace object
#' @param trace_coords Character vector of coordinate strings for the trace
#' @param plot_coords Character vector of coordinate strings for plot_data
#' @param facet_membership List returned by .get_facet_membership()
#'
#' @return Logical vector indicating which points in the trace should be highlighted
#'
#' @author Jared Andrews
#' @rdname INTERNAL_filter_highlight_by_facet
#' @keywords internal
.filter_highlight_by_facet <- function(plot_data, highlight_idx, trace, trace_coords, 
                                        plot_coords, facet_membership) {
    # Start with coordinate-based matching
    trace_highlight_mask <- trace_coords %in% plot_coords[highlight_idx]

    # If no faceting, return as-is
    if (length(facet_membership$facet_map) == 1) {
        return(trace_highlight_mask)
    }

    # Determine which facet this trace belongs to
    trace_xaxis <- if (!is.null(trace$xaxis)) trace$xaxis else "x"
    trace_facet_idx <- facet_membership$axis_to_facet[[trace_xaxis]]

    # If we can't determine the facet, return as-is (shouldn't happen)
    if (is.null(trace_facet_idx)) {
        return(trace_highlight_mask)
    }

    # Get the plot_data indices that are "real" for this facet
    facet_real_idx <- facet_membership$facet_map[[trace_facet_idx]]

    # Filter highlight_idx to only include points that are "real" in this facet
    facet_highlight_idx <- intersect(highlight_idx, facet_real_idx)

    # Update the mask to only highlight points that are both:
    # 1. In the highlight list
    # 2. "Real" data for this facet
    facet_highlight_coords <- plot_coords[facet_highlight_idx]
    trace_highlight_mask <- trace_coords %in% facet_highlight_coords

    trace_highlight_mask
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