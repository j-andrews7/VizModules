library(vizModules)

line_data <- transform(mtcars,
    cyl = factor(cyl),
    gear = factor(gear)
)
iris_data <- iris
iris_data$Species <- factor(iris_data$Species)

data_list <- list(
    mtcars = line_data,
    iris = iris_data
)

app <- linePlotApp(data_list)
app
