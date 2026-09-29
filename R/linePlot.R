#' Create an Interactive Line Plot with plotly
#'
#' Generates a customizable interactive line plot using plotly, supporting grouping, faceting, axis adjustments, and color palettes.
#'
#' @param data A data.frame or tibble containing the data to plot.
#' @param x Character vector of column name(s) for the x-axis.
#'   Multiple columns create separate traces.
#' @param y Character vector of column name(s) for the y-axis.
#'   Multiple columns create separate traces.
#' @param palette.selection Character vector of hex colors for line colors.
#'   Used to assign colors to groups or traces.
#' @param plot.mode Character, plotly mode for plot type.
#'   Options: "lines", "markers", "lines+markers". Default: "lines".
#' @param line.type Character, line style.
#'   Options: "solid", "dot", "dash", "longdash", "dashdot", "longdashdot". Default: "solid".
#' @param colour.group.by Character or formula, column name(s) to group lines by color.
#'   Can be a formula like `~ column_name`. Ignored if multiple `x` or `y` columns are provided.
#'   Default: `NULL`.
#' @param show.legend Logical, whether to display the legend. Default: TRUE.
#' @param facet.by Optional character, column name to facet plots by.
#'   Creates subplots for each unique value. Default: NULL.
#' @param facet.scales Character, controls axis scaling across facets. Options: "fixed" (same for all), "free" (independent),
#'   "free_x" (independent x-axis), "free_y" (independent y-axis). Default: "fixed".
#' @param facet.nrow Optional integer, number of rows in the faceted subplot grid.
#'   If `NULL` (default), a single row is used unless `facet.ncol` is supplied,
#'   in which case the number of rows is derived from the number of facet levels.
#' @param facet.ncol Optional integer, number of columns in the faceted subplot grid.
#'   If `NULL` (default), columns are derived from `facet.nrow` and the number
#'   of facet levels. Only one of `facet.nrow` / `facet.ncol` needs to be set;
#'   if both are provided, `facet.nrow` takes precedence.
#' @param subplot.margin Numeric, spacing between facet panels as a fraction of the plot area.
#'   May be a single value (applied to both directions) or a length-2 vector
#'   `c(horizontal, vertical)` to control the gap between columns and rows separately. Default: 0.05.
#' @param order.by Optional character vector, column name(s) to order data by before plotting. Default: NULL.
#' @param axis.showline Logical, whether to show axis border lines. Default: TRUE.
#' @param axis.mirror Logical, whether to mirror axis lines on opposite side of plot. Default: TRUE.
#' @param axis.linecolor Character, hex color for axis lines. Default: "black".
#' @param axis.linewidth Numeric, width of axis lines in pixels. Default: 0.5.
#' @param axis.tickfont.size Numeric, font size for axis tick labels. Default: 12.
#' @param axis.tickfont.color Character, hex color for axis tick labels. Default: "black".
#' @param axis.tickfont.family Character, font family for axis tick labels. Default: "Arial".
#' @param axis.tickangle.x Numeric, rotation angle for x-axis tick labels in degrees. Default: 0.
#' @param axis.tickangle.y Numeric, rotation angle for y-axis tick labels in degrees. Default: 0.
#' @param axis.ticks Character, position of tick marks. Options: "outside", "inside", "none". Default: "outside".
#' @param axis.tickcolor Character, hex color for tick marks. Default: "black".
#' @param axis.ticklen Numeric, length of tick marks in pixels. Default: 5.
#' @param axis.tickwidth Numeric, width of tick marks in pixels. Default: 1.
#' @param show.grid.x Logical, whether to show gridlines on the x-axis. Default: TRUE.
#' @param show.grid.y Logical, whether to show gridlines on the y-axis. Default: TRUE.
#' @param grid.color Character, hex color for gridlines. Default: "#CCCCCC".
#' @param axis.title.font.size Numeric, font size for the x/y axis titles. Default: 18.
#' @param axis.title.font.color Character, hex color for the x/y axis titles. Default: "black".
#' @param axis.title.font.family Character, font family for the x/y axis titles. Default: "Arial".
#' @param facet.title.font.size Numeric, font size for the facet panel titles. Default: 18.
#' @param facet.title.font.color Character, hex color for the facet panel titles. Default: "black".
#' @param facet.title.font.family Character, font family for the facet panel titles. Default: "Arial".
#' @param title.text Character, main title text for the plot. Default: "".
#' @param title.font.size Numeric, font size for plot title. Default: 14.
#' @param title.font.family Character, font family for plot title. Default: "Arial".
#' @param title.font.color Character, hex color for plot title text. Default: "black".
#' @param title.x.position Numeric, horizontal position of the plot title in paper coordinates (0 = left, 1 = right). Default: 0.47.
#' @param y.title Optional character, label for y-axis. If NULL, auto-generated from column name.
#'   When `x` is a single categorical column, the plotted y-values are per-group means, so the
#'   title is wrapped as `mean(<y.title>)` to accurately describe the summary displayed. Default: NULL.
#' @param x.title Optional character, label for x-axis. If NULL, auto-generated from column name. Default: NULL.
#' @param flip.x Logical, whether to reverse the x-axis direction. Default: FALSE.
#' @param flip.y Logical, whether to reverse the y-axis direction. Default: FALSE.
#' @param x.adjustment Optional character or function, transformation to apply to x values.
#'   Options: "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt", or custom function. Default: NULL.
#' @param y.adjustment Optional character or function, transformation to apply to y values.
#'   Options: "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt", or custom function. Default: NULL.
#' @param color.adjustment Optional character or function, transformation to apply to color grouping variable.
#'   Same options as x.adjustment and y.adjustment. Default: NULL.
#' @param error.width numeric input to set the width of the error bars on a plot with a categorical X axis and only 1 Y axis variable
#' @param error.colour hex colour input to set the colour of the error bars on a plot with a categorical X axis and only 1 Y axis variable
#' @param error.bar Boolean value to determine if error bars will be on or off on a plot with a categorical X axis
#'   and only 1 Y axis variable. Each bar spans the plotted group mean plus or minus the amount `error.type` selects,
#'   computed from that group's y-values, where a group is a single x category, split further by `colour.group.by` and
#'   `facet.by` when those are set. A group with fewer than two observations has no spread and is drawn without a bar.
#' @param error.type What the error bars show, one of `"sd"` (one standard deviation, the default), `"sem"` (one
#'   standard error of the mean, `sd / sqrt(n)`) or `"ci95"` (a 95% confidence interval for the mean). Missing values
#'   are ignored when counting `n`.
#' @param error.ci.method How `error.type = "ci95"` is computed, one of `"normal"` (the default; the standard error
#'   times the 97.5th percentile of the normal distribution, 1.96) or `"t"` (the standard error times the 97.5th
#'   percentile of the t distribution with `n - 1` degrees of freedom). The t interval is wider for small groups and
#'   converges on the normal one as `n` grows. Ignored for the other error types.
#'
#' @return A plotly object representing the interactive line plot.
#'
#' @import plotly
#' @importFrom dplyr group_by summarise across all_of mutate
#'
#' @author Jacob Martin, Jared Andrews
#' @export
#'
#' @examples
#' palette <- plotthis::palette_list[["Set2"]]
#' fig <- linePlot(
#'     data = mtcars,
#'     x = "cyl",
#'     y = "mpg",
#'     plot.mode = "lines",
#'     line.type = "solid",
#'     colour.group.by = "mpg",
#'     palette.selection = palette,
#'     show.legend = TRUE
#' )
linePlot <- function(data, x, y, palette.selection, 
                     plot.mode = "lines", line.type = "solid", 
                     colour.group.by = NULL,
                     show.legend = TRUE, facet.by = NULL,
                     facet.scales = "fixed",
                     facet.nrow = NULL, facet.ncol = NULL,
                     subplot.margin = 0.05,
                     axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, axis.tickfont.size = 12,
                     axis.tickfont.color = "black", axis.tickfont.family = "Arial", axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
                     axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1, show.grid.x = TRUE, show.grid.y = TRUE,
                     grid.color = "#CCCCCC",
                     axis.title.font.size = 18, axis.title.font.color = "black", axis.title.font.family = "Arial",
                     facet.title.font.size = 18, facet.title.font.color = "black", facet.title.font.family = "Arial",
                     title.text = "", title.font.size = 14, title.font.family = "Arial",
                     title.font.color = "black", title.x.position = 0.47, y.title = NULL, x.title = NULL, flip.x = FALSE, flip.y = FALSE,
                     x.adjustment = NULL, y.adjustment = NULL, color.adjustment = NULL, order.by = NULL, error.colour = NULL, error.width = NULL, error.bar = FALSE,
                     error.type = c("sd", "sem", "ci95"), error.ci.method = c("normal", "t")) {
    error.type <- match.arg(error.type)
    error.ci.method <- match.arg(error.ci.method)

    axis_title_font <- list(size = axis.title.font.size, color = axis.title.font.color, family = axis.title.font.family)
    facet_title_font <- list(
        size = facet.title.font.size, color = facet.title.font.color, family = facet.title.font.family
    )

    # Unique x axis styling for linePlot. plotly's default zero line is turned off:
    # it cannot be removed from the UI, and a reference line adds one on request.
    xaxis_style <- list(
        showline = axis.showline, mirror = axis.mirror, linecolor = axis.linecolor, linewidth = axis.linewidth,
        tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
        tickangle = axis.tickangle.x, ticks = axis.ticks, tickcolor = axis.tickcolor, ticklen = axis.ticklen, tickwidth = axis.tickwidth,
        title = .axis_title_spec(x.title, axis_title_font), autorange = TRUE,
        showgrid = show.grid.x, gridcolor = grid.color, zeroline = FALSE
    )

    multi_axis <- xor(length(x) > 1, length(y) > 1)

    # subplot.margin may be a single value (applied to all sides) or a length-2
    # vector c(horizontal, vertical). plotly::subplot() expects a single value or
    # c(left, right, top, bottom), so expand a length-2 vector accordingly.
    subplot_margin_sides <- if (length(subplot.margin) >= 2L) {
        c(subplot.margin[1], subplot.margin[1], subplot.margin[2], subplot.margin[2])
    } else {
        subplot.margin
    }

    cat.choices <- c("", names(data)[vapply(data, function(x) !is.numeric(x), logical(1))])

    if (!is.null(x.adjustment) && nzchar(x.adjustment)) {
        data <- adjust_column_values(df = data, x.col = x, x.adj.fun = x.adjustment)
        x.new <- x
        for (i in seq_along(x)) {
            adj_name <- paste(x[i], "adj", sep = ".")
            if (adj_name %in% names(data)) {
                x.new[i] <- adj_name
            }
        }
        x <- x.new
    }

    if (!is.null(y.adjustment) && nzchar(y.adjustment)) {
        data <- adjust_column_values(df = data, y.col = y, y.adj.fun = y.adjustment)
        y.new <- y
        for (i in seq_along(y)) {
            adj_name <- paste(y[i], "adj", sep = ".")
            if (adj_name %in% names(data)) {
                y.new[i] <- adj_name
            }
        }
        y <- y.new
    }

    if (!is.null(color.adjustment) && nzchar(color.adjustment) && !is.null(colour.group.by) && nzchar(colour.group.by)) {
        data <- adjust_column_values(df = data, color.col = colour.group.by, color.adj.fun = color.adjustment)
        adj_name <- paste(colour.group.by, "adj", sep = ".")

        if (adj_name %in% names(data)) {
            colour.group.by <- adj_name
        }
    }

    if (length(x) == 1 && x %in% cat.choices) {
        # A categorical x-axis means each x position can have multiple y-values, so the
        # per-group mean is what actually gets plotted. Reflect that summary in the
        # y-axis title (e.g. "units" -> "mean(units)") so the axis is not misleading.
        if (length(y) == 1 && is.numeric(data[[y[1]]])) {
            y_label <- if (is.null(y.title) || !nzchar(y.title)) y[1] else y.title
            y.title <- paste0("mean(", y_label, ")")
        }

        # Compute the per-group mean and error bar half-width. What `summarise()` sees is
        # data-masked, so a column named like one of this function's arguments (`y`,
        # say) would shadow it and silently drop the bars. Everything it needs from
        # here is resolved first, and only the closure is named inside it.
        single_y <- length(y) == 1
        y_col <- y[1]
        error_fn <- function(values) .error_bar_halfwidth(values, error.type, error.ci.method)

        group_vars <- x
        if (!is.null(facet.by) && nzchar(facet.by)) {
            group_vars <- c(facet.by, group_vars)
        }

        if (!is.null(colour.group.by) && nzchar(colour.group.by)) {
            group_vars <- c(colour.group.by, group_vars)
        }

        ex <- data |>
            dplyr::group_by(dplyr::across(dplyr::all_of(group_vars))) |>
            dplyr::summarise(
                # Before the means below, which overwrite the y column in place.
                err_y = if (single_y) error_fn(.data[[y_col]]) else NA_real_,
                dplyr::across(
                    dplyr::all_of(y),
                    list(mean = ~ mean(.x, na.rm = TRUE)),
                    .names = "{.col}"
                ),
                .groups = "drop"
            )
        data <- ex
    } else {
        data <- data |>
            dplyr::mutate(err_y = NA)
    }

    # Y axis styling by editing unique aspects of the x axis styling
    yaxis_style <- xaxis_style
    yaxis_style$tickangle <- axis.tickangle.y
    yaxis_style$title <- .axis_title_spec(y.title, axis_title_font)
    yaxis_style$showgrid <- show.grid.y

    if (flip.x) {
        xaxis_style$autorange <- "reversed"
    }

    if (flip.y) {
        yaxis_style$autorange <- "reversed"
    }

    # Clear per-axis titles when faceting - single titles added as annotations instead
    if (!is.null(facet.by) && facet.by != "") {
        xaxis_style$title <- NULL
        yaxis_style$title <- NULL
    }

    order.cols <- order.by
    if (is.null(order.cols)) {
        order.cols <- x
    }

    plot_data <- data
    if (!is.null(order.cols) && length(order.cols) > 0 && order.cols[1] %in% names(data)) {
        plot_data <- data[order(data[[order.cols[1]]]), ]
    }

    # plotly re-sorts the data by the colour column before splitting it into traces, but
    # not an error bar array passed by value, so ordering by x alone (which interleaves the
    # groups) put bars on other groups' points. Only drawn bars care, so nothing else moves.
    if (isTRUE(error.bar) && !is.null(colour.group.by) && nzchar(colour.group.by) &&
        "err_y" %in% names(plot_data) && any(!is.na(plot_data$err_y))) {
        plot_data <- .group_rows_by_trace(plot_data, colour.group.by)
    }

    multi_axis <- xor(length(x) > 1, length(y) > 1)

    if (!is.null(colour.group.by) && nzchar(colour.group.by)) {
        color <- reformulate(colour.group.by)
    } else {
        color <- NULL
    }

    if (!is.null(facet.by) && facet.by != "" && !multi_axis) {
        # Split data by facet variable
        facet_levels <- unique(plot_data[[facet.by]])
        plots <- lapply(seq_along(facet_levels), function(i) {
            facet_data <- plot_data[plot_data[[facet.by]] == facet_levels[i], ]
            # Build plot parameters conditionally. Every facet draws the same set of
            # colour groups, so only the first contributes legend entries.
            plot_params <- list(
                data = facet_data,
                x = reformulate(x),
                y = reformulate(y),
                type = "scatter",
                mode = plot.mode,
                color = color,
                colors = palette.selection,
                showlegend = show.legend && i == 1L
            )
            # Tie each colour group's traces together across facets so one legend click
            # toggles the series in every panel. plotly splits `legendgroup` per trace
            # the same way it splits `color`.
            if (!is.null(color)) {
                plot_params$legendgroup <- color
            }
            # Only add error_y if err_y exists and has non-NA values
            if ("err_y" %in% names(facet_data) && any(!is.na(facet_data$err_y)) && error.bar) {
                plot_params$error_y <- list(array = facet_data$err_y, color = error.colour, thickness = error.width)
            }
            # Only add line parameter if mode is "lines" or "lines+markers"
            if (plot.mode %in% c("lines", "lines+markers")) {
                plot_params$line <- list(dash = line.type)
            }
            do.call(plot_ly, plot_params)
        })

        sharing <- resolve_facet_sharing(facet.scales)
        nrows <- resolve_facet_layout(length(facet_levels), facet.nrow, facet.ncol)
        fig <- subplot(
            plots, nrows = nrows, shareX = sharing$shareX, shareY = sharing$shareY,
            titleX = FALSE, titleY = FALSE, margin = subplot_margin_sides
        )

        ncols <- max(1L, as.integer(ceiling(length(facet_levels) / nrows)))
        fig <- apply_facet_subplot_spacing(
                    fig,
                    spacing = subplot.margin,
                    ncol = ncols,
                    nrow = nrows
                )    
      
        annotations <- build_facet_annotations(
            facet_levels, x.title = x.title, y.title = y.title,
            nrows = nrows, fig = fig, axis.title.font = axis_title_font,
            facet.title.font = facet_title_font
        )

        borders <- build_facet_panel_borders(
            fig, length(facet_levels),
            showline = axis.showline, mirror = axis.mirror,
            linecolor = axis.linecolor, linewidth = axis.linewidth,
            ncol = ncols, nrow = nrows
        )

        fig <- fig |> layout(annotations = annotations)
        if (length(borders) > 0) {
            fig$x$layout$shapes <- c(fig$x$layout$shapes, borders)
        }
        
  
      
    } else if (!is.null(facet.by) && facet.by != "" && multi_axis) {
        # Faceting with multi-axis: create subplots where each subplot contains all traces
        facet_levels <- unique(plot_data[[facet.by]])
        sharing <- resolve_facet_sharing(facet.scales)
        nrows <- resolve_facet_layout(length(facet_levels), facet.nrow, facet.ncol)

        plots <- list()
        first_facet <- TRUE
        for (n in seq_along(facet_levels)) {
            facet_data <- plot_data[plot_data[[facet.by]] == facet_levels[n], ]
            # No data/type here - passing them emits a placeholder trace that
            # claims a nameless legend entry in every facet.
            facet_fig <- plot_ly()
            facet_fig <- .add_multi_axis_traces(
                facet_fig, facet_data, x, y, order.cols, plot.mode,
                line.type, palette.selection,
                show.legend = first_facet
            )
            plots[[length(plots) + 1]] <- facet_fig
            first_facet <- FALSE
        }

        fig <- subplot(
            plots, nrows = nrows, shareX = sharing$shareX, shareY = sharing$shareY,
            titleX = FALSE, titleY = FALSE
        )
      
        ncols <- max(1L, as.integer(ceiling(length(facet_levels) / nrows)))
        fig <- apply_facet_subplot_spacing(
                    fig,
                    spacing = subplot.margin,
                    ncol = ncols,
                    nrow = nrows
                ) 
      
        annotations <- build_facet_annotations(
            facet_levels, x.title = x.title, y.title = y.title,
            nrows = nrows, fig = fig, axis.title.font = axis_title_font,
            facet.title.font = facet_title_font
        )
      
        borders <- build_facet_panel_borders(
            fig, length(facet_levels),
            showline = axis.showline, mirror = axis.mirror,
            linecolor = axis.linecolor, linewidth = axis.linewidth,
            ncol = ncols, nrow = nrows
        )

        fig <- fig |> layout(annotations = annotations)
        if (length(borders) > 0) {
            fig$x$layout$shapes <- c(fig$x$layout$shapes, borders)
        }
      

    } else if (multi_axis) {
        # Initialize empty plot for multi-axis to avoid creating initial trace.
        # Supplying data/type here would emit a placeholder trace with no name
        # that still takes up a legend entry.
        fig <- plot_ly()
    } else {
        # Build plot parameters conditionally
        plot_params <- list(
            data = plot_data,
            x = reformulate(x),
            y = reformulate(y),
            type = "scatter",
            mode = plot.mode,
            color = color,
            colors = palette.selection,
            showlegend = show.legend
        )

        # Only add error_y if err_y exists and has non-NA values
        if ("err_y" %in% names(plot_data) && any(!is.na(plot_data$err_y)) && error.bar) {
            plot_params$error_y <- list(array = plot_data$err_y, color = error.colour, thickness = error.width)
        }
        # Only add line parameter if mode is "lines" or "lines+markers"
        if (plot.mode %in% c("lines", "lines+markers")) {
            plot_params$line <- list(dash = line.type)
        }
        fig <- do.call(plot_ly, plot_params)
    }

    if (multi_axis && (is.null(facet.by) || facet.by == "")) {
        fig <- .add_multi_axis_traces(
            fig, data, x, y, order.cols, plot.mode,
            line.type, palette.selection,
            show.legend = show.legend
        )
    }

    fig <- fig |> layout(
        title = list(
            text = title.text,
            font = list(size = title.font.size, family = title.font.family, color = title.font.color),
            x = title.x.position, xanchor = "center", y = 0.95, yanchor = "top", pad = list(t = 20)
        ),
        margin = list(t = 70),
        showlegend = isTRUE(show.legend),
        xaxis = xaxis_style,
        yaxis = yaxis_style
    )

    # Apply axis styling to all subplot axes (handles faceting)
    fig <- apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

    return(fig)
}


# What the error bars can show, and how a confidence interval can be worked out.
# The values are the `error.type` / `error.ci.method` choices linePlot() accepts; the
# names are what the module's selects display.
.error_bar_type_choices <- c(
    "Standard deviation (SD)" = "sd",
    "Standard error of the mean (SEM)" = "sem",
    "95% confidence interval" = "ci95"
)
.error_bar_ci_method_choices <- c("Normal approximation" = "normal", "t distribution" = "t")


#' Sort rows the way plotly sorts them before splitting a discrete colour into traces
#'
#' Before it splits a discrete `color` into one trace per group, plotly
#' [dplyr::arrange()]s its own copy of the data by that column (level order for a factor,
#' sorted order for characters). Mapped variables such as `x` and `y` travel with that sort,
#' but an array handed to a trace attribute by value, such as `error_y$array`, does not, and
#' the trace that takes rows 1-4 of the sorted data would take entries 1-4 of the unsorted
#' array: every group but one gets other groups' error bars. Sorting the data here first
#' leaves plotly's sort with nothing to move, so the two stay in step. The sort is stable,
#' so each trace is drawn exactly as before.
#'
#' @param df The data frame [linePlot()] is about to plot.
#' @param col Name of the column mapped to `color`. Only a factor, character or logical
#'   column is split into traces (a numeric one becomes a colour scale), so `df` is
#'   returned as it is for anything else.
#'
#' @return `df`, sorted by `col`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_group_rows_by_trace
#' @keywords internal
.group_rows_by_trace <- function(df, col) {
    vals <- df[[col]]
    if (!(is.factor(vals) || is.character(vals) || is.logical(vals))) {
        return(df)
    }

    dplyr::arrange(df, .data[[col]])
}


#' Half-width of a group's error bar
#'
#' What [linePlot()] draws either side of a group's mean. Missing values are dropped
#' before `n` is counted, so the bar describes the values that went into the mean.
#'
#' @param x Numeric vector of one group's y-values.
#' @param type One of `"sd"` (standard deviation), `"sem"` (standard error of the mean,
#'   `sd / sqrt(n)`) or `"ci95"` (95% confidence interval for the mean).
#' @param ci.method For `type = "ci95"`, `"normal"` scales the standard error by the
#'   97.5th percentile of the normal distribution (1.96) and `"t"` by that of the t
#'   distribution on `n - 1` degrees of freedom. Ignored for the other types.
#'
#' @return A single number, or `NA_real_` for fewer than two non-missing values, which
#'   have no spread to draw.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_error_bar_halfwidth
#' @keywords internal
.error_bar_halfwidth <- function(x, type = c("sd", "sem", "ci95"), ci.method = c("normal", "t")) {
    type <- match.arg(type)
    ci.method <- match.arg(ci.method)

    x <- x[!is.na(x)]
    n <- length(x)
    if (n < 2L) {
        return(NA_real_)
    }

    spread <- stats::sd(x)
    switch(type,
        sd = spread,
        sem = spread / sqrt(n),
        ci95 = {
            crit <- if (ci.method == "t") stats::qt(0.975, df = n - 1L) else stats::qnorm(0.975)
            crit * spread / sqrt(n)
        }
    )
}
