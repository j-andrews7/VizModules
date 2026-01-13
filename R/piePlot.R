#' Create a plotly pie chart
#'
#' @param df A data frame containing the data to plot.
#' @param labels Name of the column to use for the labels.
#' @param values Name of the column to use for the values.
#' @param hole A numeric value between 0 and 1 for the hole size (0 for pie, >0 for donut).
#' @param palette A character vector of colors to use if `col.palette` is NULL.
#' @param col.palette A character vector of colors to use.
#' @param textinfo A character string for the text info to show.
#'   Any combination of "label", "text", "value", "percent" joined with a "+" OR "none".
#' @return A plotly object.
#'
#' @importFrom plotly plot_ly
#'
#' @export
#' @author Jacob Martin
piePlot <- function(df, labels, values, hole = 0,
                    palette, col.palette = NULL, textinfo = "label+text+value+percent") {
    colours <- if (is.null(col.palette)) palette else col.palette

    fig <- plot_ly(
        data = df,
        type = "pie",
        labels = labels,
        values = values,
        hole = hole,
        marker = list(colors = colours),
        textinfo = textinfo
    )

    return(fig)
}
