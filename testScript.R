library(devtools)
devtools::load_all()
library(shiny)
library(shinyWidgets)
library(colourpicker)
library(shinyjs)
library(plotly)
library(shinyjqui)


data_list <- list("mtcars" = mtcars, "iris" = iris)

data <- data.frame(
    x = rep(LETTERS[1:8], each = 40),
    y = c(rnorm(160), rnorm(160, mean = 1)),  
    group1 = sample(c("g1", "g2"), 320, replace = TRUE),
    group2 = sample(c("h1", "h2", "h3", "h4"), 320, replace = TRUE)
)

data2 <- list("Hello" = data)
app <- createBoxPlotApp(data2)
runApp(app)

# p <- plotthis::BoxPlot(data, x = "x", y = "y", add_bg = TRUE)



# var sd mean median