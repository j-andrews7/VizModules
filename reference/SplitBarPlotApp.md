# Create an example Modular SplitBarPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::SplitBarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
SplitBarPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which SplitBarPlot modules will be
  created. That is, UI inputs and a split bar plot will be generated for
  each.

## Value

A Shiny app object.

## Author

Jacob Martin

## Examples

``` r
mtcars$cyl <- as.factor(mtcars$cyl)
data_list <- list("mtcars" = mtcars, "iris" = iris)
app <- SplitBarPlotApp(data_list)
if (interactive()) runApp(app)
```
