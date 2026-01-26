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
                size   = 18,
                family = isolate_fn(input$font.type),
                color  = isolate_fn(input$text.colour)
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
