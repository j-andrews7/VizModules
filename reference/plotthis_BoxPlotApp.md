# Create an example Modular BoxPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
plotthis_BoxPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which BoxPlot modules will be created.
  That is, UI inputs and a box plot will be generated for each.

## Value

A Shiny app object.

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
data_list <- list("sales" = example_sales, "population" = example_population)
app <- plotthis_BoxPlotApp(data_list)
if (interactive()) runApp(app)
```
