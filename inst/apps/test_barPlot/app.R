library(VizModules)

bar_mtcars <- transform(mtcars,
    cyl = factor(cyl),
    gear = factor(gear),
    vs = factor(vs)
)

bar_iris <- iris
bar_iris$Species <- factor(bar_iris$Species)
bar_iris$PetalLengthBand <- cut(
    bar_iris$Petal.Length,
    breaks = c(0, 2, 4, 10),
    labels = c("short", "medium", "long"),
    right = FALSE
)

data_list <- list(
    mtcars = bar_mtcars,
    iris = bar_iris
)

app <- plotthis_BarPlotApp(data_list)
app
