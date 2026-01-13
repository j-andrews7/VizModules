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
#' @param simple Logical. If TRUE, returns a simplified config with only basic edits (titleText, axisTitleText).
#'   If FALSE, includes all edit options and drawing tools (default: FALSE).
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
                              include.modebar.buttons = TRUE, simple = FALSE) {
    if (simple) {
        config <- list(
            editable = TRUE,
            edits = list(
                titleText = TRUE,
                axisTitleText = TRUE
            ),
            toImageButtonOptions = list(
                format = download.format,
                filename = filename,
                height = 500,
                width = 700,
                scale = 1
            ),
            displaylogo = FALSE
        )
    } else {
        config <- list(
            edits = list(
                axisTitleText = TRUE,
                titleText = TRUE,
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
    }
    
    return(config)
}


.create_axis_styles <- function (input, axis_side = c("x", "y")){

    axis_side <- match.arg(axis_side)

    list(
        title = list(
            font = list(
                size   = 18,
                family = isolate(input$font.type),
                color  = isolate(input$text.colour)
            )
        ),
        showline  = isolate(input$axis.showline),
        mirror    = isolate(input$axis.mirror),
        linecolor = isolate(input$axis.linecolor),
        linewidth = isolate(input$axis.linewidth),
        tickfont  = list(
            size   = isolate(input$axis.tickfont.size),
            color  = isolate(input$axis.tickfont.color),
            family = isolate(input$axis.tickfont.family)
        ),
        tickangle = if (axis_side == "x") {
            isolate(input$axis.tickangle.x)
        } else {
            isolate(input$axis.tickangle.y)
        },
        ticks     = isolate(input$axis.ticks),
        tickcolor = isolate(input$axis.tickcolor),
        ticklen   = isolate(input$axis.ticklen),
        tickwidth = isolate(input$axis.tickwidth)
    )

}