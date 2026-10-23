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
#' @param error.width Numeric, thickness of the error bars. Default: `NULL` (plotly's default).
#' @param error.colour Hex colour of the error bars. Default: `NULL` (the series' own colour).
#' @param error.bar Logical, whether to draw the interval `error.type` selects as error bars. Needs a single `y`, and a
#'   single categorical `x` unless `error.type = "columns"`. For `"sd"`, `"sem"` and `"ci95"`, each bar spans the plotted
#'   group mean plus or minus that amount, computed from the group's y-values, where a group is a single x category,
#'   split further by `colour.group.by` and `facet.by` when those are set. A group with fewer than two observations has
#'   no spread and is drawn without a bar. Default: `FALSE`.
#' @param error.type What the error bars and ribbon show, one of `"sd"` (one standard deviation, the default),
#'   `"sem"` (one standard error of the mean, `sd / sqrt(n)`), `"ci95"` (a 95% confidence interval for the mean) or
#'   `"columns"` (the interval between the `error.lower` and `error.upper` columns). Missing values are ignored when
#'   counting `n`. The first three summarise each group, so they need a categorical `x`. `"columns"` works with any
#'   `x`. It suits intervals worked out beforehand, such as a model's confidence or prediction interval, a forecast
#'   range or a min/max range.
#' @param error.ci.method How `error.type = "ci95"` is computed, one of `"normal"` (the default; the standard error
#'   times the 97.5th percentile of the normal distribution, 1.96) or `"t"` (the standard error times the 97.5th
#'   percentile of the t distribution with `n - 1` degrees of freedom). The t interval is wider for small groups and
#'   converges on the normal one as `n` grows. Ignored for the other error types.
#' @param error.lower,error.upper Optional character, names of the numeric columns holding each point's lower and
#'   upper bound, for `error.type = "columns"`. Either order works. The bounds are on the y-axis's scale, so
#'   `y.adjustment` is applied to them too. With a categorical `x`, they are averaged per group, as `y` is, so supply
#'   one row per x position (and colour/facet group). A bound that lies on the wrong side of the line draws no bar on
#'   that side. Default: `NULL`.
#' @param error.ribbon Logical, whether to draw the interval `error.type` selects as a shaded band (a ribbon) behind
#'   each line, in the line's own colour, on its own or alongside the error bars. It has the same requirements as
#'   `error.bar`. A point without an interval leaves a gap in the band, so an isolated point's interval shows only
#'   as a bar. No ribbon is drawn for a numeric `colour.group.by`, which plotly does not split into separate lines.
#'   Hovering a band's edge shows that bound. Default: `FALSE`.
#' @param error.ribbon.opacity Numeric between 0 and 1, the ribbon's fill opacity. Default: 0.25.
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
#'
#' # Each product line's yearly mean revenue, with a 95% confidence interval ribbon.
#' fig2 <- linePlot(
#'     data = example_sales,
#'     x = "year",
#'     y = "revenue",
#'     colour.group.by = "product_line",
#'     palette.selection = palette[1:3],
#'     error.type = "ci95",
#'     error.ribbon = TRUE
#' )
#'
#' # A band from columns holding precomputed bounds, on a numeric x-axis.
#' fit <- data.frame(t = 1:20, est = sqrt(1:20))
#' fit$lo <- fit$est - 0.4
#' fit$hi <- fit$est + 0.4
#' fig3 <- linePlot(
#'     data = fit,
#'     x = "t",
#'     y = "est",
#'     palette.selection = "#1B9E77",
#'     error.type = "columns",
#'     error.lower = "lo",
#'     error.upper = "hi",
#'     error.ribbon = TRUE
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
                     error.type = c("sd", "sem", "ci95", "columns"), error.ci.method = c("normal", "t"),
                     error.lower = NULL, error.upper = NULL, error.ribbon = FALSE, error.ribbon.opacity = 0.25) {
    error.type <- match.arg(error.type)
    error.ci.method <- match.arg(error.ci.method)

    ribbon_opacity <- suppressWarnings(as.numeric(error.ribbon.opacity))
    if (length(ribbon_opacity) != 1 || is.na(ribbon_opacity)) {
        ribbon_opacity <- 0.25
    }
    ribbon_opacity <- min(max(ribbon_opacity, 0), 1)

    # A "columns" interval is read from two bound columns and is tied to a single y.
    bound_cols <- NULL
    if (error.type == "columns" && length(y) == 1 && nz_value(error.lower) && nz_value(error.upper)) {
        bound_cols <- c(error.lower, error.upper)
        numeric_col <- vapply(bound_cols, function(b) is.numeric(data[[b]]), logical(1))
        bad <- unique(bound_cols[!(bound_cols %in% names(data)) | !numeric_col])
        if (length(bad) > 0) {
            stop("error.lower and error.upper must name numeric columns of data; not: ", toString(bad), call. = FALSE)
        }
    }

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

    # The column adjust_column_values() wrote for each of `cols`, or the column itself if it wrote none.
    adjusted_cols <- function(cols) {
        vapply(cols, function(col) {
            adj_name <- paste(col, "adj", sep = ".")
            if (adj_name %in% names(data)) adj_name else col
        }, character(1), USE.NAMES = FALSE)
    }

    if (!is.null(x.adjustment) && nzchar(x.adjustment)) {
        data <- adjust_column_values(df = data, x.col = x, x.adj.fun = x.adjustment)
        x <- adjusted_cols(x)
    }

    # The bounds are on y's scale, so they take y's adjustment too.
    if (!is.null(y.adjustment) && nzchar(y.adjustment)) {
        data <- adjust_column_values(df = data, y.col = c(y, bound_cols), y.adj.fun = y.adjustment)
        y <- adjusted_cols(y)
        if (!is.null(bound_cols)) {
            bound_cols <- adjusted_cols(bound_cols)
        }
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

        # Compute the per-group mean and interval. What `summarise()` sees is data-masked,
        # so a column named like a variable here (`y`, say) would shadow it and silently
        # drop the interval. The closures and column names are injected with `!!`, so
        # nothing is looked up in the data.
        y_col <- y[1]
        halfwidth_of <- if (length(y) == 1 && error.type != "columns") {
            function(values) error_bar_halfwidth(values, error.type, error.ci.method)
        } else {
            function(values) NA_real_
        }
        bound_mean_of <- if (!is.null(bound_cols)) {
            function(values) {
                m <- mean(values, na.rm = TRUE)
                if (is.nan(m)) NA_real_ else m
            }
        } else {
            function(values) NA_real_
        }
        lo_col <- if (!is.null(bound_cols)) bound_cols[1] else y_col
        hi_col <- if (!is.null(bound_cols)) bound_cols[2] else y_col

        group_vars <- x
        if (!is.null(facet.by) && nzchar(facet.by)) {
            group_vars <- c(facet.by, group_vars)
        }

        if (!is.null(colour.group.by) && nzchar(colour.group.by)) {
            group_vars <- c(colour.group.by, group_vars)
        }

        data <- data |>
            dplyr::group_by(dplyr::across(dplyr::all_of(group_vars))) |>
            dplyr::summarise(
                # Before the means below, which overwrite the y column in place.
                err_hw = (!!halfwidth_of)(.data[[!!y_col]]),
                err_lo = (!!bound_mean_of)(.data[[!!lo_col]]),
                err_hi = (!!bound_mean_of)(.data[[!!hi_col]]),
                dplyr::across(
                    dplyr::all_of(y),
                    list(mean = ~ mean(.x, na.rm = TRUE)),
                    .names = "{.col}"
                ),
                .groups = "drop"
            )

        # A computed interval is centred on the plotted mean.
        if (is.null(bound_cols)) {
            data$err_lo <- data[[y_col]] - data$err_hw
            data$err_hi <- data[[y_col]] + data$err_hw
        }
        data$err_hw <- NULL
    } else {
        data$err_lo <- rep(NA_real_, nrow(data))
        data$err_hi <- rep(NA_real_, nrow(data))
        if (!is.null(bound_cols)) {
            data$err_lo <- data[[bound_cols[1]]]
            data$err_hi <- data[[bound_cols[2]]]
        }
    }

    # Either column may hold the lower bound.
    lo <- pmin(data$err_lo, data$err_hi)
    data$err_hi <- pmax(data$err_lo, data$err_hi)
    data$err_lo <- lo

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
    if (isTRUE(error.bar) && !is.null(colour.group.by) && nzchar(colour.group.by) && .has_interval(plot_data)) {
        plot_data <- .group_rows_by_trace(plot_data, colour.group.by)
    }

    multi_axis <- xor(length(x) > 1, length(y) > 1)

    if (!is.null(colour.group.by) && nzchar(colour.group.by)) {
        color <- reformulate(colour.group.by)
    } else {
        color <- NULL
    }

    # plotly only applies `colors` to a mapped colour, so a single series is coloured here.
    series_colour <- NULL
    if (is.null(color)) {
        series_colour <- if (length(palette.selection) > 0) .normalize_hex(unname(palette.selection)[1]) else ""
        if (!nzchar(series_colour)) {
            series_colour <- "#1F77B4"
        }
    }

    # A numeric colour is one trace drawn with a gradient, so there are no separate lines to band.
    draw_ribbon <- isTRUE(error.ribbon) && length(y) == 1 &&
        (is.null(color) || !is.numeric(plot_data[[colour.group.by]]))

    # One panel's ribbon (underneath) and line. `group.legend` ties each series' traces
    # together across facets so one legend click toggles it in every panel; plotly
    # splits `legendgroup` per trace the same way it splits `color`.
    build_panel <- function(panel_data, showlegend, group.legend = FALSE) {
        has_interval <- .has_interval(panel_data)
        ribbon <- if (draw_ribbon && has_interval) .ribbon_rows(panel_data, y, colour.group.by) else NULL
        legendgroup <- if (!is.null(color)) color else y

        line_params <- list(
            data = panel_data,
            x = reformulate(x),
            y = reformulate(y),
            type = "scatter",
            mode = plot.mode,
            color = color,
            colors = palette.selection,
            showlegend = showlegend
        )
        if ((group.legend && !is.null(color)) || !is.null(ribbon)) {
            line_params$legendgroup <- legendgroup
        }
        if (isTRUE(error.bar) && has_interval) {
            line_params$error_y <- .error_y_spec(panel_data, y, error.colour %||% series_colour, error.width)
        }
        # A NULL colour is left out rather than set: plotly merges these over the mapped
        # colour with modifyList(), where a NULL entry deletes it.
        if (plot.mode %in% c("lines", "lines+markers")) {
            line_params$line <- c(list(dash = line.type), if (!is.null(series_colour)) list(color = series_colour))
        }
        if (!is.null(series_colour) && plot.mode %in% c("markers", "lines+markers")) {
            line_params$marker <- list(color = series_colour)
        }

        # Empty, so it adds no placeholder trace, and the ribbon is added first to sit underneath.
        fig <- plot_ly()
        if (!is.null(ribbon)) {
            fig <- .add_ribbon_trace(
                fig, ribbon, x, y, color, palette.selection,
                series.colour = series_colour, opacity = ribbon_opacity, legendgroup = legendgroup
            )
        }
        do.call(add_trace, c(list(fig), line_params))
    }

    if (!is.null(facet.by) && facet.by != "" && !multi_axis) {
        # Split data by facet variable. Every facet draws the same set of colour groups,
        # so only the first contributes legend entries.
        facet_levels <- unique(plot_data[[facet.by]])
        plots <- lapply(seq_along(facet_levels), function(i) {
            facet_data <- plot_data[plot_data[[facet.by]] == facet_levels[i], ]
            build_panel(facet_data, showlegend = show.legend && i == 1L, group.legend = TRUE)
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
        fig <- build_panel(plot_data, showlegend = show.legend)
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


# What the error bars and ribbon can show, and how a confidence interval can be worked out.
# The values are the `error.type` / `error.ci.method` choices linePlot() accepts; the
# names are what the module's selects display.
.error_bar_type_choices <- c(
    "Standard deviation (SD)" = "sd",
    "Standard error of the mean (SEM)" = "sem",
    "95% confidence interval" = "ci95",
    "From columns" = "columns"
)
.error_bar_ci_method_choices <- c("Normal approximation" = "normal", "t distribution" = "t")


#' Whether any row of a linePlot frame has an interval to draw
#'
#' @param df A frame carrying the `err_lo` / `err_hi` bounds [linePlot()] works out.
#'
#' @return `TRUE` if at least one row has both bounds.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_has_interval
#' @keywords internal
.has_interval <- function(df) {
    all(c("err_lo", "err_hi") %in% names(df)) && any(!is.na(df$err_lo) & !is.na(df$err_hi))
}


#' Error bars spanning each row's interval
#'
#' The bars run from the plotted value to each bound, so an interval from columns can be
#' asymmetric. A bound on the wrong side of the value draws no bar on that side.
#'
#' @param df The panel's rows, in the order they are drawn, carrying `err_lo` / `err_hi`.
#' @param y Name of the plotted y column.
#' @param colour Colour of the bars, or `NULL` for the series' own.
#' @param width Thickness of the bars, or `NULL` for plotly's default.
#'
#' @return A list for a trace's `error_y`.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_error_y_spec
#' @keywords internal
.error_y_spec <- function(df, y, colour = NULL, width = NULL) {
    list(
        type = "data",
        symmetric = FALSE,
        array = pmax(df$err_hi - df[[y]], 0),
        arrayminus = pmax(df[[y]] - df$err_lo, 0),
        color = colour,
        thickness = width
    )
}


#' The closed outlines of a linePlot ribbon
#'
#' Turns the rows a line is drawn through into the outline of the band around it, for a
#' `fill = "toself"` trace. Each series (each level of `colour`) is walked in the order its
#' line is drawn. Every unbroken run of rows with both bounds becomes one closed outline, the
#' upper bounds forward and then the lower bounds back, numbered in `.ribbon_part`. Grouping
#' by that column has plotly draw each outline separately, so a row without an interval
#' leaves a gap in the band rather than one being drawn across it.
#'
#' The rows keep all of `df`'s columns and their types, so the same `x`, `y` and colour
#' mappings, axis titles and colour levels apply as for the line itself.
#'
#' @param df The panel's rows, in the order the line is drawn, carrying `err_lo` / `err_hi`.
#' @param y Name of the plotted y column, which takes the bound values.
#' @param colour Name of the discrete column the lines are coloured by, or `NULL`.
#'
#' @return `df`'s rows rearranged into outlines, with a `.ribbon_side` column (`"Upper"` or
#'   `"Lower"`) and a `.ribbon_part` column numbering the outlines within each series, or
#'   `NULL` if no row has an interval.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_ribbon_rows
#' @keywords internal
.ribbon_rows <- function(df, y, colour = NULL) {
    if (!.has_interval(df)) {
        return(NULL)
    }

    series <- if (nz_value(colour) && colour %in% names(df)) {
        split(seq_len(nrow(df)), df[[colour]], drop = TRUE)
    } else {
        list(seq_len(nrow(df)))
    }

    outlines <- function(rows) {
        d <- df[rows, , drop = FALSE]
        runs <- rle(is.finite(d$err_lo) & is.finite(d$err_hi))
        ends <- cumsum(runs$lengths)
        starts <- ends - runs$lengths + 1L
        keep <- which(runs$values)

        lapply(seq_along(keep), function(part) {
            idx <- starts[keep[part]]:ends[keep[part]]
            upper <- d[idx, , drop = FALSE]
            upper[[y]] <- d$err_hi[idx]
            upper$.ribbon_side <- rep("Upper", length(idx))
            lower <- d[rev(idx), , drop = FALSE]
            lower[[y]] <- d$err_lo[rev(idx)]
            lower$.ribbon_side <- rep("Lower", length(idx))
            outline <- dplyr::bind_rows(upper, lower)
            outline$.ribbon_part <- rep(part, nrow(outline))
            outline
        })
    }

    out <- unlist(lapply(series, outlines), recursive = FALSE)
    if (length(out) == 0) {
        return(NULL)
    }
    out <- as.data.frame(dplyr::bind_rows(out))
    rownames(out) <- NULL
    out
}


#' Add a linePlot ribbon to a figure
#'
#' Adds the outlines from [.ribbon_rows()] as filled traces with no edge line, one outline per
#' `.ribbon_part` group. With a
#' colour mapping, the ribbon uses the same `color`/`colors` as its lines plus plotly's
#' `alpha`, so plotly gives each series' band its line's colour (one colour scale is
#' trained over every trace in a figure). A single series is given `series.colour`
#' directly. The ribbon never takes a legend entry of its own; it joins its line's
#' `legendgroup`, so the line's entry toggles both. Hovering a vertex shows that bound.
#'
#' @param fig A plotly figure.
#' @param ribbon Rows from [.ribbon_rows()].
#' @param x,y Names of the plotted x and y columns.
#' @param color The lines' colour mapping (a formula), or `NULL` for a single series.
#' @param colors The lines' palette.
#' @param series.colour Colour of a single series, used when `color` is `NULL`.
#' @param opacity Fill opacity, between 0 and 1.
#' @param legendgroup The lines' legend group (a formula, or a name for a single series).
#'
#' @return `fig` with the ribbon added.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_add_ribbon_trace
#' @keywords internal
.add_ribbon_trace <- function(fig, ribbon, x, y, color, colors, series.colour, opacity, legendgroup) {
    params <- list(
        fig,
        data = dplyr::group_by(ribbon, dplyr::across(dplyr::all_of(".ribbon_part"))),
        x = reformulate(x),
        y = reformulate(y),
        type = "scatter",
        mode = "lines",
        fill = "toself",
        line = list(width = 0),
        hoveron = "points",
        text = ~.ribbon_side,
        showlegend = FALSE,
        legendgroup = legendgroup
    )
    if (!is.null(color)) {
        params$color <- color
        params$colors <- colors
        params$alpha <- opacity
        params$hovertemplate <- "%{text}: %{y}<extra>%{fullData.name}</extra>"
    } else {
        # plotly would otherwise name the trace after its fill colour.
        params$name <- legendgroup
        params$fillcolor <- plotly::toRGB(series.colour, opacity)
        params$hovertemplate <- "%{text}: %{y}<extra></extra>"
    }
    do.call(plotly::add_trace, params)
}


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
#' What [linePlot()] draws either side of a group's mean for `error.type = "sd"`,
#' `"sem"` or `"ci95"`. Missing values are dropped before `n` is counted, so the bar
#' describes the values that went into the mean.
#'
#' A module that summarises its own groups (over a numeric x, say, which linePlot's
#' own summaries do not cover) can work out each interval with this and hand
#' [linePlot()] the bounds through `error.type = "columns"`, so its bars and ribbons
#' match the line plot module's.
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
#' @export
#' @seealso [linePlot()]
#' @examples
#' x <- c(4.1, 5.3, 4.8, 6.0, 5.5)
#' error_bar_halfwidth(x, "sd")
#' error_bar_halfwidth(x, "sem")
#' # The t interval is wider for small groups.
#' error_bar_halfwidth(x, "ci95", "normal")
#' error_bar_halfwidth(x, "ci95", "t")
error_bar_halfwidth <- function(x, type = c("sd", "sem", "ci95"), ci.method = c("normal", "t")) {
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
