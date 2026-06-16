# Scale factor applied to the maximum Y value for initial axis range.
# Using a named constant avoids magic numbers scattered across modules.
.y_axis_scale_factor <- 1.11

#' Adjust numeric column values in a data frame using mathematical transformations
#'
#' Applies a named mathematical transformation to a specified numeric column in a data frame,
#' adding the transformed values as a new column (original column name + ".adj").
#' The transformation name must be one of the allowed functions listed in `safe_resolve_adj_fxn`
#' (e.g., "log2", "log10", "sqrt", "abs", "as.factor"). The original data frame is returned unchanged
#' if no transformation is specified or if the supplied name is invalid.
#'
#' @param df A data frame containing the column to be transformed.
#' @param x.col Character scalar. Name of the column for x‑axis values (optional).
#' @param y.col Character scalar. Name of the column for y‑axis values (optional).
#' @param color.col Character scalar. Name of the column for color values (optional).
#' @param x.adj.fun Character scalar. Name of a transformation function to apply to x‑axis values,
#'   as accepted by `safe_resolve_adj_fxn` (e.g., "log2", "log10", "sqrt"). If `NULL` or an empty string,
#'   x‑axis values are left unchanged.
#' @param y.adj.fun Character scalar. Name of a transformation function to apply to y‑axis values,
#'   as accepted by `safe_resolve_adj_fxn`. If `NULL` or an empty string, y‑axis values are left unchanged.
#' @param color.adj.fun Character scalar. Name of a transformation function to apply to color values,
#'   as accepted by `safe_resolve_adj_fxn`. If `NULL` or an empty string, color values are left unchanged.
#'
#' @return A data frame identical to input \code{df} but with transformed columns added
#'   (e.g., \code{mpg.adj}) when valid transformations are specified.
#'
#' @examples
#' data(mtcars)
#' mtcars_mod <- adjust_column_values(mtcars, x.col = "mpg", x.adj.fun = "log2")
#' head(mtcars_mod$mpg.adj)
#'
#' @author Jacob Martin, Jared Andrews
#' @export
adjust_column_values <- function(df, x.col = NULL, y.col = NULL, color.col = NULL,
                                  x.adj.fun = NULL, y.adj.fun = NULL, color.adj.fun = NULL) {

  apply_trans <- function(d, cols, adj_name) {
    out <- d

    if (!is.null(adj_name) && nzchar(as.character(adj_name))) {
      adj_fun <- safe_resolve_adj_fxn(adj_name) #Safety check for string input

      if (!is.null(adj_fun)) {
        for (col in cols) {
          if (col %in% names(out) && is.numeric(out[[col]])) {
            out[[paste(col, "adj", sep = ".")]] <- adj_fun(out[[col]])
          }
        }
      }
    }
    return(out)
  }

  df <- apply_trans(df, x.col,       x.adj.fun)
  df <- apply_trans(df, y.col,       y.adj.fun)
  df <- apply_trans(df, color.col,   color.adj.fun)

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
#' @details The configuration enables interactive editing of the
#'   plot title, legend text and position, colorbar position and title, and
#'   annotation tails. It also adds drawing tools (lines, paths, circles,
#'   rectangles, and an eraser) to the modebar. Native cartesian axis-title
#'   text editing is disabled because axis titles are rendered as draggable,
#'   editable annotations (see \code{\link{.axis_titles_as_annotations}} and
#'   \code{\link{.build_facet_annotations}}).
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_add_plot_config
.add_plot_config <- function(download.format = "png", filename = as.character(Sys.Date()),
                             include.modebar.buttons = TRUE, facet.by = NULL) {
    if (is.null(facet.by)) {
        config <- list(
            edits = list(
                # Native axis titles are replaced with draggable annotations via
                # .axis_titles_as_annotations(), so disable native axis-title text
                # editing to avoid misclicks competing with the annotation titles.
                axisTitleText = FALSE,
                titleText = TRUE,
                annotationText = TRUE,
                legendText = TRUE,
                legendPosition = TRUE,
                colorbarPosition = TRUE,
                colorbarTitleText = TRUE,
                annotationTail = TRUE,
                editText = TRUE,
                editTitle = TRUE,
                annotationPosition = TRUE
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
                titleText = TRUE,
                annotationText = TRUE,
                legendText = TRUE,
                legendPosition = TRUE,
                colorbarPosition = TRUE,
                colorbarTitleText = TRUE,
                annotationTail = TRUE,
                annotationPosition = TRUE
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


#' Calculate axis range from data
#'
#' Computes a numeric range for the Y-axis based on specified columns in a
#' data frame, applying a scaling factor to the maximum value. Handles both
#' simple (non-stacked) and stacked bar scenarios, where stacking occurs when
#' \code{group.by} or \code{fill.by} is numeric.
#'
#' @param df Data frame. The data containing the variables to range over.
#' @param data_col_y Character string. Name of the numeric Y-axis data column.
#'   Takes priority over \code{data_col_x} if both are provided.
#' @param data_col_x Character string. Name of the X-axis data column. Required
#'   when \code{grouping = TRUE} or \code{stack_by} is specified, as it defines
#'   the groups over which Y values are summed.
#' @param axis_scale_factor Numeric. Multiplicative factor applied to the
#'   maximum Y value to provide additional headroom on the axis.
#' @param grouping Logical. If \code{TRUE}, bars are treated as stacked and the
#'   maximum is derived from the sum of Y values within each X group rather than
#'   the raw maximum. Defaults to \code{FALSE}.
#' @param stack_by Character string or \code{NULL}. Name of the column used for
#'   stacking (i.e. \code{group.by} or \code{fill.by}). When this column is
#'   numeric, bars are stacked and Y values are summed per X category before
#'   computing the maximum. Ignored if \code{NULL} or if the column is
#'   categorical. Defaults to \code{NULL}.
#'
#' @return A named list with components \code{min} and \code{max} giving the
#'   lower and upper limits for the Y-axis, or \code{NULL} if any required
#'   column is missing, non-numeric, or otherwise invalid.
#'
#' @details
#' The function resolves the primary data column from \code{data_col_y} or
#' \code{data_col_x} and validates that it exists and is numeric in \code{df}.
#'
#' Behaviour depends on whether bars are stacked:
#' \itemize{
#'   \item \strong{Non-stacked} (\code{grouping = FALSE}, categorical or absent
#'     \code{stack_by}): the Y range is computed directly from the raw column
#'     values using \code{min()} and \code{max()}.
#'   \item \strong{Stacked} (\code{grouping = TRUE} or \code{stack_by} is
#'     numeric): Y values are summed within each unique X category using
#'     \code{tapply()}, and the maximum of those sums is used. The minimum is
#'     fixed at 0 since stacked bars always originate from zero.
#' }
#'
#' Non-finite results (e.g. from empty or all-\code{NA} columns) are replaced
#' with default values of 0 for the minimum and 1 for the maximum.
#'
#' @author Jacob Martin
#' @keywords internal
#' @rdname INTERNAL_calculate_range
.calculate_range <- function(df, data_col_x = NULL, data_col_y = NULL,
                             axis_scale_factor, grouping = FALSE,
                             stack_by = NULL) {
    # Resolve primary data column
    data_col <- if (!is.null(data_col_y)) data_col_y else data_col_x

    # Basic guards
    if (is.null(data_col) || !nzchar(data_col)) {
        return(NULL)
    }
    if (!data_col %in% names(df)) {
        return(NULL)
    }
    if (!is.numeric(df[[data_col]])) {
        return(NULL)
    }

    if (!grouping) {
        # --- Non-stacked: bars are NOT stacked, just find the max single value ---
        # If stack_by is provided and numeric, bars ARE stacked → sum per x group
        if (!is.null(stack_by) && stack_by %in% names(df) && is.numeric(df[[stack_by]])) {
            # Numeric stack_by: stacked bars, sum y per x category
            if (is.null(data_col_x) || !data_col_x %in% names(df)) {
                return(NULL)
            }
            x_sums <- tapply(df[[data_col]], df[[data_col_x]], function(v) sum(v, na.rm = TRUE))
            max_val <- max(x_sums, na.rm = TRUE) * axis_scale_factor
            min_val <- 0
        } else {
            # Categorical or no stack_by: bars dodged/ungrouped, max of raw values
            max_val <- max(df[[data_col]], na.rm = TRUE) * axis_scale_factor
            min_val <- min(df[[data_col]], na.rm = TRUE)
        }

        if (!is.finite(min_val)) min_val <- 0
        if (!is.finite(max_val)) max_val <- 1

        return(list(min = min_val, max = max_val))
    } else {
        # --- Stacked grouping: sum y values per x group ---
        if (is.null(data_col_x) || !data_col_x %in% names(df)) {
            return(NULL)
        }
        x_sums <- tapply(df[[data_col]], df[[data_col_x]], function(v) sum(v, na.rm = TRUE))
        max_val <- max(x_sums, na.rm = TRUE) * axis_scale_factor
        min_val <- 0

        if (!is.finite(max_val)) max_val <- 1

        return(list(min = min_val, max = max_val))
    }
}


#' Create an empty ggplot2 plot or plotly plot with input text
#'
#' This function creates an empty ggplot2 or plotly plot and places a user-provided text
#' string in the middle of the plot.
#'
#' @param text Character scalar to show in plot area.
#' @param plotly Boolean indicating whether to return a plotly object.
#' @return Either a ggplot object or a plotly object if \code{plotly = TRUE}.
#'
#' @importFrom ggplot2 theme_void geom_text theme margin ggplot aes
#' @importFrom plotly ggplotly layout
#'
#' @author Jared Andrews
#'
#' @seealso \code{\link[ggplot2]{geom_text}}, \code{\link[ggplot2]{theme_void}}
#' @export
#' @examples
#' library(VizModules)
#' empty_plot("No data to display")
empty_plot <- function(text = NULL, plotly = FALSE) {
    if (length(text) > 1) {
        text <- paste(text, collapse = "\n")
    }

    plot <- ggplot() +
        theme_void() +
        theme(plot.margin = margin(1, 1, 1, 1, "cm")) +
        geom_text(aes(x = 0.5, y = 0.5, label = text),
            inherit.aes = FALSE, check_overlap = TRUE
        )

    if (plotly) {
        plot <- ggplotly(plot)
        plot <- plot |> layout(
            xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, showline = FALSE),
            yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE, showline = FALSE),
            plot_bgcolor = "white",
            showlegend = FALSE,
            autosize = TRUE,
            margin = list(l = 0, r = 0, b = 0, t = 0)
        )
    }

    plot
}


#' Check if column inputs contain mixed data types
#'
#' This function validates that a vector of column names from a data frame contains
#' columns of only one data type category: either all numeric OR all categorical
#' (factor/character). Returns \code{FALSE} for mixed numeric + categorical columns.
#' Single columns always return \code{TRUE}. Used for Shiny plotting module input validation.
#'
#' @param inputs Character vector of column names to validate.
#' @param d Data frame containing the columns specified in \code{inputs}.
#'
#' @return Logical scalar: \code{TRUE} if all numeric OR all categorical (factor/character);
#'   \code{FALSE} if mixed numeric + categorical/factor detected.
#'
#' @author Jacob Martin
#'
#' @examples
#' df <- data.frame(num1 = 1:3, num2 = 4:6, cat1 = letters[1:3], fac1 = factor(1:3))
#' is_pure_type(c("num1", "num2"), df) # TRUE (all numeric)
#' is_pure_type(c("cat1", "fac1"), df) # TRUE (all categorical)
#' is_pure_type(c("num1"), df) # TRUE (single)
#' is_pure_type(c("num1", "cat1"), df) # FALSE (mixed numeric + cat)
#'
#' @rdname is_pure_type
#' @seealso \code{\link[base]{for}}
#' @export
is_pure_type <- function(inputs, d) {
    cols <- inputs[nzchar(inputs) & inputs %in% names(d)]

    # Single column or empty always pure
    if (length(cols) <= 1) {
        return(TRUE)
    }

    # Classify first column to establish reference type
    first_col <- d[[cols[1]]]
    ref_type <- if (is.numeric(first_col)) {
        "numeric"
    } else if (is.factor(first_col) || is.character(first_col)) "categorical"

    # Check all remaining columns match reference
    for (i in 2:length(cols)) {
        col <- d[[cols[i]]]
        col_type <- if (is.numeric(col)) {
            "numeric"
        } else if (is.factor(col) || is.character(col)) "categorical"

        if (col_type != ref_type) {
            return(FALSE)
        }
    }

    TRUE
}


#' Add multi-axis traces to a plotly figure
#'
#' Appends scatter traces for each element of a multi-valued \code{x} or
#' multi-valued \code{y} vector to an existing plotly figure.
#' Handles data ordering, line/marker styling, and palette colouring.
#'
#' @param fig A plotly figure object to add traces to.
#' @param data A data.frame containing the plot data.
#' @param x Character vector of x-column name(s).
#' @param y Character vector of y-column name(s).
#' @param order.cols Character vector of column name(s) used to sort trace
#'   data before plotting.
#' @param plot.mode Character, plotly scatter mode (e.g. \code{"lines"},
#'   \code{"markers"}, \code{"lines+markers"}).
#' @param line.type Character, plotly dash style for lines.
#' @param palette.selection Character vector of hex colours.
#' @param show.legend Logical, whether traces should appear in the legend.
#'   Default: \code{TRUE}.
#'
#' @return The modified plotly figure with added traces.
#'
#' @author Jared Andrews
#' @rdname INTERNAL_add_multi_axis_traces
#' @keywords internal
.add_multi_axis_traces <- function(fig, data, x, y, order.cols, plot.mode,
                                   line.type, palette.selection,
                                   show.legend = TRUE) {
    .add_traces_for <- function(iter_var, fixed_var, is_x_multi) {
        for (i in seq_along(iter_var)) {
            trace_data <- data

            sort_column <- order.cols[1]
            if (!is.null(order.cols) && length(order.cols) >= i &&
                order.cols[i] %in% names(trace_data)) {
                sort_column <- order.cols[i]
            }
            if (!is.null(sort_column) && sort_column %in% names(trace_data)) {
                trace_data <- trace_data[order(trace_data[[sort_column]]), ]
            }

            if (is_x_multi) {
                xvals <- trace_data[[iter_var[i]]]
                yvals <- trace_data[[fixed_var[1]]]
                trace_name <- iter_var[i]
            } else {
                xvals <- trace_data[[fixed_var[1]]]
                yvals <- trace_data[[iter_var[i]]]
                trace_name <- iter_var[i]
            }

            trace_params <- list(
                x = xvals,
                y = yvals,
                type = "scatter",
                mode = plot.mode,
                name = trace_name,
                showlegend = show.legend
            )

            if (plot.mode %in% c("lines", "lines+markers")) {
                trace_params$line <- list(
                    dash = line.type,
                    color = palette.selection[i]
                )
            }
            if (plot.mode %in% c("markers", "lines+markers")) {
                trace_params$marker <- list(color = palette.selection[i])
            }

            fig <<- do.call(plotly::add_trace, c(list(fig), trace_params))
        }
    }

    if (length(x) > 1) {
        .add_traces_for(x, y, is_x_multi = TRUE)
    }
    if (length(y) > 1) {
        .add_traces_for(y, x, is_x_multi = FALSE)
    }

    fig
}

