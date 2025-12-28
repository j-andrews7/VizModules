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
piePlot <- function(reactive.data, plot.labels, plot.values, make.hole = 0, palette, col_palette = NULL, plot.text = 'label+percent'){

    colours <- if (is.null(col_palette)) palette else col_palette

    pie.chart <- plot_ly(data = reactive.data, 
                        type = "pie", 
                        labels = plot.labels, 
                        values = plot.values,
                        hole = make.hole, 
                        marker = list(colors = colours), 
                        textinfo = plot.text)
    return(pie.chart)

}

# input.x <- "x"
# input.values <- "values"

# x_values <- reformulate(input.x)
# input_values <- reformulate(input.values)
# ~x and ~values
# Line Plot: 

# Line type. 
#points show or not 
# colour of points 
# colour of line 
#line type 
#line width 
#line alpha 
#points alpha 
# points on line off 
# theme 