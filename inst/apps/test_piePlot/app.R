library(vizModules)

iris_summary <- as.data.frame(table(iris$Species))
names(iris_summary) <- c("Species", "Count")

cyl_summary <- as.data.frame(table(mtcars$cyl))
names(cyl_summary) <- c("Cylinders", "Count")

data_list <- list(
    mtcars = cyl_summary,
    iris = iris_summary
)

app <- piePlotApp(data_list)
app
