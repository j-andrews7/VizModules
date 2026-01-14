# Create an example Modular linePlot Shiny Application

This function generates a Shiny application with modular
[`linePlot()`](https://j-andrews7.github.io/vizModules/reference/linePlot.md)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
linePlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which linePlot modules will be
  created. That is, UI inputs and a line plot will be generated for
  each.

## Value

A Shiny app object.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(vizModules)
data_list <- list("mtcars" = mtcars, "iris" = iris)
app <- linePlotApp(data_list)
if (interactive()) runApp(app)
```
