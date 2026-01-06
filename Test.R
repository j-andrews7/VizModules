library(plotly)
library(devtools)
library(shiny)
devtools::load_all()

data <- data.frame(
    num = c(1, 3, 2, 6, 3), 
    names = c("a", "b", "c", "d", "e"),
    num_x = c(1, 2, 3, 4, 5)
)

# p <- plot_ly(data = data, x = ~num, y = ~num_x, type = "scatter", mode = "lines", color = ~names)
data_list <- list("mtcars" = mtcars, "iris" = iris)

app <- linePlotApp(data_list = data_list)
runApp(app)
