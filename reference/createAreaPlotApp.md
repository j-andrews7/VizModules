# Create an example Modular areaPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
createAreaPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which areaPlot modules will be
  created. That is, UI inputs and an area plot will be generated for
  each.

## Value

A Shiny app object.

## Author

Jacob Martin

## Examples

``` r
data_list <- list("mtcars" = mtcars, "iris" = iris)
app <- createAreaPlotApp(data_list)
if (interactive()) runApp(app)
```
