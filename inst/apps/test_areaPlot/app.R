library(VizModules)

mtcars_area <- transform(mtcars,
    cyl = factor(cyl),
    gear = factor(gear)
)

iris_area <- iris
iris_area$Species <- factor(iris_area$Species)
iris_area$WidthGroup <- ifelse(iris_area$Sepal.Width >= 3, "Wide", "Narrow")
iris_area$WidthGroup <- factor(iris_area$WidthGroup)

data_list <- list(
    mtcars = mtcars_area,
    iris = iris_area
)

app <- plotthis_AreaPlotApp(data_list)
app
