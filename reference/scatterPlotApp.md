# Create an example Modular scatterPlot Shiny Application

This function generates a Shiny application with modular
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
scatterPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which scatterPlot modules will be
  created. That is, UI inputs and a scatter plot will be generated for
  each.

## Value

A Shiny app object.

## Author

Jared Andrews

## Examples

``` r
library(vizModules)
data_list <- list("mtcars" = mtcars, "iris" = iris)
app <- scatterPlotApp(data_list)
#> Error in materialSwitch(ns("best.fit"), "Line of best fit:", value = FALSE,     offLabel = "Off", onLabel = "On", status = "success"): unused arguments (offLabel = "Off", onLabel = "On")
if (interactive()) runApp(app)
```
