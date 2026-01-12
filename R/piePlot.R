#' Create a plotly pie chart
#'
#' @param reactive.data A data frame containing the data to plot.
#' @param plot.labels A formula for the labels.
#' @param plot.values A formula for the values.
#' @param make.hole A numeric value between 0 and 1 for the hole size (0 for pie, >0 for donut).
#' @param palette A character vector of colors to use if `col.palette` is NULL.
#' @param col.palette A character vector of colors to use.
#' @param plot.text A character string for the text info to show.
#' @return A plotly object.
#'
#' @importFrom plotly plot_ly
#'
#' @export
#' @author Jacob Martin
piePlot <- function(reactive.data, plot.labels, plot.values, make.hole = 0,
                    palette, col.palette = NULL, plot.text = "label+percent") {
    colours <- if (is.null(col.palette)) palette else col.palette

    df <- reactive.data
    lab_var <- all.vars(plot.labels)[1]
    val_var <- all.vars(plot.values)[1]

    labs <- df[[lab_var]]
    vals <- df[[val_var]]

    fig <- plot_ly(
        data = reactive.data,
        type = "pie",
        labels = labs,
        values = vals,
        hole = make.hole,
        marker = list(colors = colours),
        textinfo = plot.text
    )


    return(fig)
}
