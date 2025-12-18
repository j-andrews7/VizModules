library(plotly)
library(rlang)
data <- data.frame(
    x = c("England", "USA", "France", "Canada"),
    values = c(20, 30, 15, 35)
)

# pie.chart <- plot_ly(data, type = "pie", labels = ~x, values = ~values, hole = 0.6, marker = list(colors = plotthis::palette_list[["Set2"]]), textinfo = 'label+percent') 


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

input.x <- "x"
input.values <- "values"

x_values <- reformulate(input.x)
input_values <- reformulate(input.values)

p <- piePlot(data, plot.labels = x_values, plot.values = input_values, make.hole = 0, palette = plotthis::palette_list[["Set2"]], plot.text = 'label+percent')