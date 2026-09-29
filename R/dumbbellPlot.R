#' Create an Interactive Dumbbell Plot with plotly
#'
#' Generates a customizable interactive dumbbell plot using plotly. Supports single dot mode (1 x variable)
#' or dumbbell mode (2 x variables), with flexible coloring by either X or Y variables, faceting, and transformations.
#'
#' @param data A data.frame or tibble containing the data to plot.
#' @param x Character vector of column name(s) for x-axis values. Maximum 2 values allowed.
#'   If 1 value: creates single dot plot. If 2 values: creates dumbbell plot with connecting segments.
#' @param y Character, column name for the y-axis (categorical variable recommended).
#' @param colour.by Character, how to color the markers. Options: "X variables" (different colors for each x variable)
#'   or "Y variables" (different colors for each y category). Default: "X variables".
#' @param palette.selection Character vector of hex colors for marker colors. A named vector
#'   is matched by name to the x variables (`colour.by = "X variables"`) or the y categories
#'   (`"Y variables"`); an unnamed one is assigned in order, to the x variables as given or to
#'   the y categories in their order of appearance in `data`. Either way a category keeps its
#'   colour in every facet.
#' @param show.legend Logical, whether to display the legend. Default: TRUE.
#' @param facet.by Optional character, column name to facet plots by. Creates subplots for each unique value. Default: NULL.
#' @param line.colour Character, hex color for the connecting lines between dumbbell points. Default: "gray80".
#' @param point.size Numeric, diameter of the markers in pixels. Default: 12.
#' @param facet.scales Character, controls axis scaling across facets. Options: "fixed" (same for all), "free" (independent),
#'   "free_x" (independent x-axis), "free_y" (independent y-axis). Default: "fixed".
#' @param subplot.margin Numeric, spacing between facet panels as a fraction of the plot area.
#'   May be a single value (applied to both directions) or a length-2 vector
#'   `c(horizontal, vertical)` to control the gap between columns and rows separately. Default: 0.06.
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
#' @param axis.title.font.size Numeric, font size for the x/y axis titles. Default: 18.
#' @param axis.title.font.color Character, hex color for the x/y axis titles. Default: "black".
#' @param axis.title.font.family Character, font family for the x/y axis titles. Default: "Arial".
#' @param show.grid.x Logical, whether to show gridlines on the x-axis. Default: TRUE.
#' @param show.grid.y Logical, whether to show gridlines on the y-axis. Default: TRUE.
#' @param grid.color Character, hex color for gridlines. Default: "#CCCCCC".
#' @param facet.title.font.size Numeric, font size for the facet panel titles. Default: 18.
#' @param facet.title.font.color Character, hex color for the facet panel titles. Default: "black".
#' @param facet.title.font.family Character, font family for the facet panel titles. Default: "Arial".
#' @param title.text Character, main title text for the plot. Default: "".
#' @param title.font.size Numeric, font size for plot title. Default: 26.
#' @param title.font.family Character, font family for plot title. Default: "Arial".
#' @param title.font.color Character, hex color for plot title text. Default: "black".
#' @param title.x.position Numeric, horizontal position of the plot title in paper coordinates (0 = left, 1 = right). Default: 0.47.
#' @param y.title Optional character, label for y-axis. If NULL, auto-generated from column name. Default: NULL.
#' @param x.title Optional character, label for x-axis. If NULL, auto-generated from column name. Default: NULL.
#' @param flip.x Logical, whether to reverse the x-axis direction. Default: FALSE.
#' @param flip.y Logical, whether to reverse the y-axis direction. Default: FALSE.
#' @param x.adjustment Optional character or function, transformation to apply to x values.
#'   Options: "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt", or custom function. Default: NULL.
#' @param order.by Optional character vector, column name(s) to order data by before plotting. Default: NULL.
#'
#' @return A plotly object representing the interactive dumbbell plot.
#'
#' @details
#' The dumbbell plot is designed for comparing two values across categories.
#'
#' **Modes:**
#' - **Single dot mode** (1 x variable): Shows one marker per y category
#' - **Dumbbell mode** (2 x variables): Shows two markers connected by a line per y category
#'
#' **Coloring options:**
#' - **By X variables**: Each x variable gets a different color (e.g., Male=blue, Female=pink)
#' - **By Y variables**: Each y category gets a different color (e.g., School A=red, School B=blue)
#'
#' @import plotly
#'
#' @author Jacob Martin
#' @export
#'
#' @examples
#' data <- data.frame(
#'     School = c("MIT", "Stanford", "Harvard"),
#'     Women = c(152, 96, 112),
#'     Men = c(95, 151, 165)
#' )
#'
#' fig <- dumbbellPlot(
#'     data = data,
#'     x = c("Women", "Men"),
#'     y = "School",
#'     colour.by = "X variables",
#'     palette.selection = c("green", "blue"),
#'     show.legend = TRUE,
#'     line.colour = "gray80"
#' )
dumbbellPlot <- function(data, x, y, colour.by = "X variables", palette.selection, show.legend = TRUE, 
                        facet.by = NULL, line.colour = "gray80", point.size = 12,
                        facet.scales = "fixed",
                        subplot.margin = 0.05,
                        axis.showline = TRUE, axis.mirror = TRUE, axis.linecolor = "black", axis.linewidth = 0.5, 
                        axis.tickfont.size = 12, axis.tickfont.color = "black", axis.tickfont.family = "Arial", 
                        axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
                        axis.tickcolor = "black", axis.ticklen = 5, axis.tickwidth = 1,
                        axis.title.font.size = 18, axis.title.font.color = "black",
                        axis.title.font.family = "Arial",
                        show.grid.x = TRUE, show.grid.y = TRUE, grid.color = "#CCCCCC",
                        facet.title.font.size = 18, facet.title.font.color = "black",
                        facet.title.font.family = "Arial",
                        title.text = "", title.font.size = 26, title.font.family = "Arial",
                        title.font.color = "black", title.x.position = 0.47, y.title = NULL, x.title = NULL, 
                        flip.x = FALSE, flip.y = FALSE,
                        x.adjustment = NULL, order.by = NULL) {
    
    # Ensure max 2 x values
    if (!is.null(x) && length(x) > 2) {
        x <- x[1:2]
    }

    # A blank numeric input reports NA; fall back to the default marker size.
    if (!is.numeric(point.size) || length(point.size) != 1L || is.na(point.size)) {
        point.size <- 12
    }

    # subplot.margin may be a single value (applied to all sides) or a length-2
    # vector c(horizontal, vertical). plotly::subplot() expects a single value or
    # c(left, right, top, bottom), so expand a length-2 vector accordingly.
    subplot_margin_sides <- if (length(subplot.margin) >= 2L) {
        c(subplot.margin[1], subplot.margin[1], subplot.margin[2], subplot.margin[2])
    } else {
        subplot.margin
    }

    axis_title_font <- list(size = axis.title.font.size, color = axis.title.font.color, family = axis.title.font.family)

    # Unique x axis styling for dumbbellPlot. plotly's default zero line is turned
    # off: it cannot be removed from the UI, and a reference line adds one on request.
    xaxis_style <- list(
        showline = axis.showline, mirror = axis.mirror, linecolor = axis.linecolor, linewidth = axis.linewidth,
        tickfont = list(size = axis.tickfont.size, color = axis.tickfont.color, family = axis.tickfont.family),
        tickangle = axis.tickangle.x, ticks = axis.ticks, tickcolor = axis.tickcolor, ticklen = axis.ticklen,
        tickwidth = axis.tickwidth,
        title = .axis_title_spec(x.title, axis_title_font), autorange = TRUE,
        showgrid = show.grid.x, gridcolor = grid.color, zeroline = FALSE
    )

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

    # Making axis adjustments if the parameters are not NULL
    if (!is.null(x.adjustment) && x.adjustment != "") {
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

    # Colour each group by name rather than by position. The rows are reordered
    # (and split into facets) below, so a positional palette would follow the
    # order the groups happen to land in there -- which is neither the order the
    # caller built the palette in nor the same from one facet to the next. The
    # groups are taken in their order of appearance, matching the module's picker.
    colour.groups <- if (identical(colour.by, "Y variables")) {
        unique(stats::na.omit(as.character(data[[y]])))
    } else {
        x
    }
    if (length(palette.selection) > 0 && length(colour.groups) > 0) {
        palette.selection <- resolve_palette(
            colour.groups, palette.selection, unname(palette.selection)
        )
    }

    # Order data if needed
    order.cols <- order.by
    if (is.null(order.cols) && !is.null(x) && length(x) > 0) {
        order.cols <- x[1]
    }

    plot_data <- data
    if (!is.null(order.cols) && length(order.cols) > 0 && order.cols[1] %in% names(data)) {
        plot_data <- data[order(data[[order.cols[1]]]), ]
    }

    sharing <- resolve_facet_sharing(facet.scales)

    # Clear per-axis titles when faceting - single titles added as annotations instead
    if (!is.null(facet.by) && facet.by != "") {
        xaxis_style$title <- NULL
        yaxis_style$title <- NULL
    }

    # Main plotting logic
    if (!is.null(facet.by) && facet.by != "") {
        # WITH FACETING
        facet_levels <- unique(plot_data[[facet.by]])

        plots <- list()
        first <- TRUE # Ensure figure legend only added to the first subplot
        for (level in facet_levels) {
            facet_data <- plot_data[plot_data[[facet.by]] == level, ]
            plots[[length(plots) + 1]] <- .create_dumbbell_plot(
                facet_data, x, y, colour.by, palette.selection,
                line.colour,
                show.legend = show.legend && first,
                point.size = point.size
            )
            first <- FALSE
        }

        fig <- subplot(
            plots, nrows = 1, shareX = sharing$shareX, shareY = sharing$shareY,
            titleX = FALSE, titleY = FALSE, margin = subplot_margin_sides
        )

        annotations <- build_facet_annotations(
            facet_levels, x.title = x.title, y.title = y.title,
            fig = fig, axis.title.font = axis_title_font,
            facet.title.font = list(
                size = facet.title.font.size, color = facet.title.font.color, family = facet.title.font.family
            )
        )

        # Shared axes leave later panels without a y axis of their own, so the
        # axis lines alone never frame them; draw each panel's border as a shape.
        borders <- build_facet_panel_borders(
            fig, length(facet_levels),
            showline = axis.showline, mirror = axis.mirror,
            linecolor = axis.linecolor, linewidth = axis.linewidth,
            ncol = length(facet_levels), nrow = 1
        )

        fig <- fig |> layout(annotations = annotations)
        if (length(borders) > 0) {
            fig$x$layout$shapes <- c(fig$x$layout$shapes, borders)
        }
    } else {
        # WITHOUT FACETING
        fig <- .create_dumbbell_plot(
            plot_data, x, y, colour.by, palette.selection, line.colour, show.legend,
            point.size = point.size
        )
    }

    fig <- fig |> layout(
        title = list(
            text = title.text,
            font = list(size = title.font.size, family = title.font.family, color = title.font.color),
            x = title.x.position, xanchor = "center", y = 0.95, yanchor = "top", pad = list(t = 20)
        ),
        margin = list(t = 70),
        showlegend = show.legend,
        xaxis = xaxis_style,
        yaxis = yaxis_style
    )

    # Apply axis styling to all subplot axes (handles faceting)
    fig <- apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

    return(fig)
}

#' Create a Dumbbell Plot for a Single Dataset
#'
#' Helper function that generates a plotly scatter plot in either single dot or dumbbell mode
#' for one dataset (i.e., one facet). Called internally by [dumbbellPlot()].
#'
#' @param data A data.frame containing the data to plot.
#' @param x Character vector of column name(s) for x-axis values. Length 1 produces a single dot plot;
#'   length 2 produces a dumbbell plot with connecting segments.
#' @param y Character, column name for the y-axis (categorical variable).
#' @param colour.by Character, how to color the markers. Either `"X variables"` (one color per x variable)
#'   or `"Y variables"` (one color per y category).
#' @param palette.selection Character vector of hex colors used for marker coloring.
#' @param line.colour Character, hex color for the connecting line between dumbbell points.
#' @param show.legend Logical, whether to display the legend for this subplot.
#' @param point.size Numeric, diameter of the markers in pixels.
#'
#' @return A plotly object representing the dumbbell (or single dot) plot for the supplied data.
#' 
#' @importFrom stats reformulate
#'
#' @author Jacob Martin
#' @rdname INTERNAL_create_dumbbell_plot
#' @keywords internal
.create_dumbbell_plot <- function(data, x, y, colour.by, palette.selection, line.colour, show.legend,
                                  point.size = 12) {
    if (is.null(x) || length(x) == 0) {
        return(plot_ly())
    }

    # Initialize empty plot
    fig <- plot_ly(data, type = "scatter")

    # A group's colour, looked up by name (dumbbellPlot() names the palette by
    # group), falling back to position for a caller-supplied unnamed palette.
    colour_of <- function(group, i) {
        col <- if (!is.null(names(palette.selection))) {
            unname(palette.selection[as.character(group)])
        } else {
            NA_character_
        }
        if (length(col) == 1L && !is.na(col)) {
            return(col)
        }
        palette.selection[[(i - 1L) %% length(palette.selection) + 1L]]
    }

    if (colour.by == "Y variables") {
        # One colour per y category, shared by its start and end markers. The
        # categories are walked in palette order so the legend reads the way the
        # colour picker does, and each is its own legend group so one click
        # toggles it in every facet.
        present <- unique(stats::na.omit(as.character(data[[y]])))
        y_levels <- c(intersect(names(palette.selection), present), setdiff(present, names(palette.selection)))

        for (i in seq_along(y_levels)) {
            y_val <- y_levels[i]
            y_data <- data[!is.na(data[[y]]) & as.character(data[[y]]) == y_val, , drop = FALSE]
            col <- colour_of(y_val, i)

            if (length(x) == 2) {
                fig <- fig |> add_segments(
                    x = y_data[[x[1]]],
                    xend = y_data[[x[2]]],
                    y = y_data[[y]],
                    yend = y_data[[y]],
                    line = list(color = col),
                    showlegend = FALSE,
                    hoverinfo = "skip",
                    legendgroup = y_val
                )
            }
            for (j in seq_along(x)) {
                fig <- fig |> add_markers(
                    x = y_data[[x[j]]],
                    y = y_data[[y]],
                    name = y_val,
                    marker = list(color = col, size = point.size),
                    # The first marker of each category carries its legend entry.
                    showlegend = show.legend && j == 1L,
                    legendgroup = y_val
                )
            }
        }
    } else if (length(x) <= 2) {
        # One colour per x variable. With two, a neutral segment joins each pair.
        if (length(x) == 2) {
            fig <- fig |> add_segments(
                x = data[[x[1]]],
                xend = data[[x[2]]],
                y = data[[y]],
                yend = data[[y]],
                line = list(color = line.colour),
                showlegend = FALSE,
                hoverinfo = "skip"
            )
        }
        for (j in seq_along(x)) {
            fig <- fig |> add_markers(
                x = data[[x[j]]],
                y = data[[y]],
                name = x[j],
                marker = list(color = colour_of(x[j], j), size = point.size),
                showlegend = show.legend,
                legendgroup = x[j]
            )
        }
    }

    return(fig)
}
