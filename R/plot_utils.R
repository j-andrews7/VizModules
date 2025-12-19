library(plotly)
library(rlang)

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