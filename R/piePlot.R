#' Create a plotly pie chart
#'
#' @param reactive.data A data frame containing the data to plot.
#' @param plot.labels A formula for the labels.
#' @param plot.values A formula for the values.
#' @param make.hole A numeric value between 0 and 1 for the hole size (0 for pie, >0 for donut).
#' @param palette A character vector of colors to use if `col.palette` is NULL.
#' @param col.palette A character vector of colors to use.
#' @param plot.text A character string for the text info to show.
#' 
#' @details This function automatically aggregates data by summing values for each
#'   unique label. If your data contains multiple rows with the same label, their
#'   values will be summed to create a single pie slice per label. This aggregation
#'   is necessary to ensure colors are correctly applied to pie chart slices.
#' 
#' @return A plotly object.
#'
#' @importFrom plotly plot_ly
#' @importFrom stats aggregate as.formula
#'
#' @export
#' @author Jacob Martin
piePlot <- function(reactive.data, plot.labels, plot.values, make.hole = 0,
                    palette, col.palette = NULL, plot.text = "label+percent") {
    colours <- if (is.null(col.palette)) palette else col.palette

    # Extract column names from formulas
    label_col <- all.vars(plot.labels)
    value_col <- all.vars(plot.values)
    
    # Validate that formulas contain variables
    if (length(label_col) == 0 || length(value_col) == 0) {
        stop("plot.labels and plot.values must be valid formulas containing variable names")
    }
    
    label_col <- label_col[1]
    value_col <- value_col[1]
    
    # Validate columns exist in data
    if (!label_col %in% names(reactive.data)) {
        stop(sprintf("Label column '%s' not found in data", label_col))
    }
    if (!value_col %in% names(reactive.data)) {
        stop(sprintf("Value column '%s' not found in data", value_col))
    }
    
    # Validate value column is numeric
    if (!is.numeric(reactive.data[[value_col]])) {
        stop(sprintf("Value column '%s' must be numeric", value_col))
    }
    
    # Aggregate data by label (sum values for each category)
    # This is necessary for pie charts to work correctly with colors
    agg_formula <- as.formula(paste(value_col, "~", label_col))
    agg_data <- aggregate(agg_formula, data = reactive.data, FUN = sum)
    
    # Get labels and values as vectors
    labels_vec <- agg_data[[label_col]]
    values_vec <- agg_data[[value_col]]
    
    # Ensure we have enough colors by repeating the color palette if necessary
    n_labels <- length(labels_vec)
    if (length(colours) < n_labels) {
        colours <- rep(colours, length.out = n_labels)
    }

    # Create pie chart with vectors instead of formulas
    # This is necessary because plot_ly() with formulas doesn't properly
    # apply marker colors for pie charts
    pie.chart <- plot_ly(
        type = "pie",
        labels = labels_vec,
        values = values_vec,
        hole = make.hole,
        marker = list(colors = colours),
        textinfo = plot.text
    )
    return(pie.chart)
}
