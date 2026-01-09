library(plotly)
library(devtools)
library(shiny)
devtools::load_all()
library(dplyr)
library(tidyr)
library(plotthis)
data <- data.frame(
    num = c(1, 3, 2, 6, 3), 
    names = c("a", "b", "c", "d", "e"),
    num_x = c(1, 2, 3, 4, 5)
)



# p <- plot_ly(data = data, x = ~num, y = ~num_x, type = "scatter", mode = "lines", color = ~names)
data_list <- list("mtcars" = mtcars, "iris" = iris)

app <- linePlotApp(data_list = data_list)
runApp(app)



# data <- iris
# p <- linePlot(
#     reactive.data = data,
#     x.value = ~Sepal.Length,
#     y.value = ~Sepal.Width,
#     plot.mode = "lines",
#     line.type = "solid", 
#     colour.group.by = NULL,
#     palette.selection = plotthis::palette_list[["Paired"]],
#     show.legend = TRUE,
#     facet.by = "Species")

#Box Plot 
#  data <- data.frame(
#      x = rep(LETTERS[1:8], each = 40),
#      y = c(rnorm(160), rnorm(160, mean = 1)),
#      group1 = sample(c("g1", "g2"), 320, replace = TRUE),
#      group2 = sample(c("h1", "h2", "h3", "h4"), 320, replace = TRUE)
#  )
#  data_list <- list("test_data" = data)
#  app <- BoxPlotApp(data_list)
#  if (interactive()) runApp(app)


# #Area Plot: 
# mtcars$cyl <- as.factor(mtcars$cyl)
# mtcars$gear <- as.factor(mtcars$gear)
# iris$group <- rep(c("A", "B"), each = 75)
# data_list <- list("mtcars" = mtcars, "iris" = iris)
# app <- AreaPlotApp(data_list)
# if (interactive()) runApp(app)


# p <- plotthis::AreaPlot(data = iris, x = "Species", y = "Sepal.Width")

#Pie Plot: 
# data_list <- list("mtcars" = mtcars, "iris" = iris)
# app <- piePlotApp(data_list)
# if (interactive()) runApp(app)

# Bar Plot: 

# data_list <- list("mtcars" = mtcars, "iris" = iris)
# app <- BarPlotApp(data_list)
# if (interactive()) runApp(app)














