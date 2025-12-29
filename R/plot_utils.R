#' Create a plotly pie chart
#'
#' @param reactive.data A data frame containing the data to plot.
#' @param plot.labels A formula for the labels.
#' @param plot.values A formula for the values.
#' @param make.hole A numeric value between 0 and 1 for the hole size (0 for pie, >0 for donut).
#' @param palette A character vector of colors to use if `col_palette` is NULL.
#' @param col_palette A character vector of colors to use.
#' @param plot.text A character string for the text info to show.
#' @return A plotly object.
#'
#' @importFrom plotly plot_ly
#'
#' @export
#' @author Jacob Martin
piePlot <- function(reactive.data, plot.labels, plot.values, make.hole = 0,
                    palette, col_palette = NULL, plot.text = "label+percent") {
    colours <- if (is.null(col_palette)) palette else col_palette

    pie.chart <- plot_ly(
        data = reactive.data,
        type = "pie",
        labels = plot.labels,
        values = plot.values,
        hole = make.hole,
        marker = list(colors = colours),
        textinfo = plot.text
    )
    return(pie.chart)
}

#' Compute linear regression fit line data
#'
#' Computes predicted values from a linear model for plotting a fit line.
#' Can optionally compute separate fit lines for each group in a grouping variable.
#'
#' @param df Data frame containing the data.
#' @param x_col Character. Name of the column for x-axis values.
#' @param y_col Character. Name of the column for y-axis values.
#' @param group_col Character or NULL. Name of the column to group by.
#'   If NULL, computes a single global fit line.
#' @param n_points Integer. Number of points to generate for the fit line.
#'
#' @return If `group_col` is NULL, a data frame with columns `x` and `y`.
#'   If `group_col` is provided, a named list of data frames (one per group).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_compute_linear_fit
#' @keywords internal
.compute_linear_fit <- function(df, x_col, y_col, group_col = NULL, n_points = 100) {
    compute_for_subset <- function(subset_df) {
        # Remove NA values
        subset_df <- subset_df[!is.na(subset_df[[x_col]]) & !is.na(subset_df[[y_col]]), ]
        if (nrow(subset_df) < 2) {
            return(NULL)
        }

        model <- lm(subset_df[[y_col]] ~ subset_df[[x_col]])

        x_min <- min(subset_df[[x_col]], na.rm = TRUE)
        x_max <- max(subset_df[[x_col]], na.rm = TRUE)
        x_grid <- seq(x_min, x_max, length.out = n_points)

        intercept <- coef(model)[1]
        slope <- coef(model)[2]
        y_grid <- intercept + slope * x_grid

        data.frame(x = x_grid, y = y_grid)
    }

    if (is.null(group_col) || group_col == "") {
        compute_for_subset(df)
    } else {
        groups <- unique(df[[group_col]])
        fits <- lapply(groups, function(g) {
            subset_df <- df[df[[group_col]] == g, ]
            compute_for_subset(subset_df)
        })
        names(fits) <- as.character(groups)
        # Remove NULL entries (groups with insufficient data)
        fits[!sapply(fits, is.null)]
    }
}

#' Compute LOESS smooth fit line data
#'
#' Computes predicted values from a LOESS model for plotting a smooth fit line.
#' Can optionally compute separate fit lines for each group in a grouping variable.
#'
#' @param df Data frame containing the data.
#' @param x_col Character. Name of the column for x-axis values.
#' @param y_col Character. Name of the column for y-axis values.
#' @param group_col Character or NULL. Name of the column to group by.
#'   If NULL, computes a single global fit line.
#' @param span Numeric. The span parameter for LOESS smoothing (0 to 1).
#' @param n_points Integer. Number of points to generate for the fit line.
#'
#' @return If `group_col` is NULL, a data frame with columns `x` and `y`.
#'   If `group_col` is provided, a named list of data frames (one per group).
#'
#' @author Jared Andrews
#' @rdname INTERNAL_compute_loess_fit
#' @keywords internal
.compute_loess_fit <- function(df, x_col, y_col, group_col = NULL, span = 0.75, n_points = 100) {
    compute_for_subset <- function(subset_df) {
        # Remove NA values
        subset_df <- subset_df[!is.na(subset_df[[x_col]]) & !is.na(subset_df[[y_col]]), ]
        # LOESS needs at least 4 observations
        if (nrow(subset_df) < 4) {
            return(NULL)
        }

        # Create a local copy with standardized column names for formula
        fit_df <- data.frame(x = subset_df[[x_col]], y = subset_df[[y_col]])

        fit <- tryCatch(
            loess(y ~ x, data = fit_df, span = span),
            error = function(e) NULL
        )
        if (is.null(fit)) {
            return(NULL)
        }

        x_min <- min(fit_df$x, na.rm = TRUE)
        x_max <- max(fit_df$x, na.rm = TRUE)
        x_grid <- seq(x_min, x_max, length.out = n_points)

        y_grid <- predict(fit, newdata = data.frame(x = x_grid))

        data.frame(x = x_grid, y = y_grid)
    }

    if (is.null(group_col) || group_col == "") {
        compute_for_subset(df)
    } else {
        groups <- unique(df[[group_col]])
        fits <- lapply(groups, function(g) {
            subset_df <- df[df[[group_col]] == g, ]
            compute_for_subset(subset_df)
        })
        names(fits) <- as.character(groups)
        # Remove NULL entries (groups with insufficient data)
        fits[!sapply(fits, is.null)]
    }
}
