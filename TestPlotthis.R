
library(plotthis)
library(shiny)
library(shinyWidgets)
library(colourpicker)
library(shinyjs)
library(plotly)
library(shinyjqui)


data <- data.frame(
    x = c("A", "B", "C", "D", "E", "F", "G", "H"),
    y = c(10, 8, 16, 4, 6, 12, 14, 2),
    group = c("G1", "G1", "G2", "G2", "G3", "G3", "G4", "G4"),
    facet = c("F1", "F2", "F3", "F4", "F1", "F2", "F3", "F4")
)

p <- plotthis::BarPlot(data, x = "x", y = "y", add_bg = TRUE, bg_palette = "stripe", palette = "Set2", palcolor =  c("#66C2A5", "#FC8D62", "#8DA0CB", "#E78AC3"))

q <- ggplotly(p)