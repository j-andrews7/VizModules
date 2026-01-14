library(vizModules)

box_data <- data.frame(
    x = factor(mtcars$cyl),
    y = mtcars$mpg,
    group1 = factor(mtcars$gear),
    group2 = factor(mtcars$vs)
)

app <- BoxPlotApp(list(box = box_data))
app
