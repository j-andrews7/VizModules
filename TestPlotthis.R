
library(plotthis)
library(shiny)
library(shinyWidgets)
library(colourpicker)
library(shinyjs)
library(plotly)
library(shinyjqui)


data <- data.frame(
    x = rep(LETTERS[1:8], each = 40),
    y = c(rnorm(160), rnorm(160, mean = 1)),  
    group1 = sample(c("g1", "g2"), 320, replace = TRUE),
    group2 = sample(c("h1", "h2", "h3", "h4"), 320, replace = TRUE)
)

p <- plotthis::BoxPlot(data, x = "x", y = "y", add_bg = TRUE, bg_palette = "Paired", add_line = 1)

