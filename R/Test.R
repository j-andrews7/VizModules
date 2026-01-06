library(plotly)
library(devtools)
library(shiny)
devtools::load_all()

data <- data.frame(
    num = c(1, 3, 2, 6, 3), 
    names = c("a", "b", "c", "d", "e"),
    num_x = c(1, 2, 3, 4, 5)
)
data_list <- list(data1 = data)

app <- linePlotApp(data_list = data_list)
runApp(app)
