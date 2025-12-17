library(devtools)
devtools::load_all()
library(shiny)
library(shinyWidgets)
library(colourpicker)
library(shinyjs)
library(plotly)
library(shinyjqui)


# data_list <- list("mtcars" = mtcars, "iris" = iris)

data <- data.frame(
    x = c("A", "B", "C", "D", "E", "F", "G", "H"),
    y = c(10, 8, 16, 4, 6, 12, 14, 2),
    group = c("G1", "G1", "G2", "G2", "G3", "G3", "G4", "G4"),
    facet = c("F1", "F2", "F3", "F4", "F1", "F2", "F3", "F4")
)

data2 <- list("Box" = data)
app <- createBarPlotApp(data2)
runApp(app)

p <- plotthis::BoxPlot(data, x = "x", y = "y", add_bg = TRUE)

#  data <- data.frame(
#      x = rep(LETTERS[1:8], each = 40),
#      y = c(rnorm(160), rnorm(160, mean = 1)),  
#      group1 = sample(c("g1", "g2"), 320, replace = TRUE),
#      group2 = sample(c("h1", "h2", "h3", "h4"), 320, replace = TRUE)
#  )
#  data_list <- list("test_data" = data)
#  app <- createBoxPlotApp(data_list)
# runApp(app)