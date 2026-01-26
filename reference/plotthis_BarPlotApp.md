# Create an example Modular BarPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::BarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
plotthis_BarPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which BarPlot modules will be created.
  That is, UI inputs and a bar plot will be generated for each.

## Value

A Shiny app object.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
mtcars$cyl <- as.factor(mtcars$cly)
#> Error in `$<-.data.frame`(`*tmp*`, cyl, value = structure(integer(0), levels = character(0), class = "factor")): replacement has 0 rows, data has 32
data_list <- list("mtcars" = mtcars, "iris" = iris)
app <- plotthis_BarPlotApp(data_list)
#> Error in materialSwitch(ns("facet.by.row"), "Facet by row:", value = TRUE,     offLabel = "Off", onLabel = "On", status = "success"): unused arguments (offLabel = "Off", onLabel = "On")
if (interactive()) runApp(app)
```
