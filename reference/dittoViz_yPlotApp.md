# Create an example Modular yPlot Shiny Application

This function generates a Shiny application with modular
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
dittoViz_yPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which yPlot modules will be created.
  That is, UI inputs and a y plot will be generated for each.

## Value

A Shiny app object.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
data_list <- list("sales" = example_sales, "population" = example_population)
app <- dittoViz_yPlotApp(data_list)
if (interactive()) runApp(app)
```
