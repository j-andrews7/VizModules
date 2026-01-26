# Create an example Modular piePlot Shiny Application

This function generates a Shiny application with modular piePlot
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
piePlotApp(data_list)
```

## Arguments

- data_list:

  A named list of summary data frames (one row per slice) for which
  piePlot modules will be created. That is, UI inputs and a pie plot
  will be generated for each. Each data frame should already contain a
  label column and an aggregated numeric value column.

## Value

A Shiny app object.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
iris_summary <- as.data.frame(table(iris$Species))
names(iris_summary) <- c("Species", "Count")
cyl_summary <- as.data.frame(table(mtcars$cyl))
names(cyl_summary) <- c("Cylinders", "Count")
data_list <- list("mtcars" = cyl_summary, "iris" = iris_summary)
app <- piePlotApp(data_list)
#> Error in materialSwitch(ns("auto.update"), "Auto Update", value = FALSE,     size = "mini", onLabel = "ON", offLabel = "OFF", status = "success"): unused arguments (size = "mini", onLabel = "ON", offLabel = "OFF")
if (interactive()) runApp(app)
```
