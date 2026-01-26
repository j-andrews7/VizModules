# Standalone Multi-Dataset Density Plot Application

Launches a complete Shiny application that displays interactive density
plot modules for every data frame provided in a list. This is ideal for
side-by-side comparison of different genomic datasets or clinical
cohorts.

## Usage

``` r
plotthis_DensityPlotApp(data_list)
```

## Arguments

- data_list:

  `list` A named list of data frames. Each list element will trigger the
  creation of a separate density plot module instance.

## Value

A Shiny app object that can be run locally or deployed to a server.

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
# Needs at least 2 categorical variables for grouping and x-axis
mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$gear <- as.factor(mtcars$gear)
iris$group <- rep(c("A", "B"), each = 75)
data_list <- list("mtcars" = mtcars, "iris" = iris)
app <- plotthis_DensityPlotApp(data_list)
#> Error in materialSwitch(ns("facet.by.row"), "Facet by row:", value = TRUE,     offLabel = "Off", onLabel = "On", status = "success"): unused arguments (offLabel = "Off", onLabel = "On")
if (interactive()) runApp(app)
```
