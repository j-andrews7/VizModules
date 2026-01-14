library(vizModules)

scatter_mtcars <- transform(mtcars,
    cyl = factor(cyl),
    gear = factor(gear)
)

scatter_iris <- iris
scatter_iris$Species <- factor(scatter_iris$Species)

data_list <- list(
    mtcars = scatter_mtcars,
    iris = scatter_iris
)

app <- scatterPlotApp(data_list)
app
