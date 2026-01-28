# Create an example Modular ViolinPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::ViolinPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
plotthis_ViolinPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which ViolinPlot modules will be
  created. That is, UI inputs and a violin plot will be generated for
  each.

## Value

A Shiny app object.

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
data_list <- list("sales" = example_sales, "population" = example_population)
app <- plotthis_ViolinPlotApp(data_list)
if (interactive()) runApp(app)
```
