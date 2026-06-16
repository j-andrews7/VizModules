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

