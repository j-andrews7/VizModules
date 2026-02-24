# Create an example Modular AreaPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
plotthis_AreaPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which AreaPlot modules will be
  created. That is, UI inputs and an area plot will be generated for
  each.

## Value

A Shiny app object.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data_list <- list("sales" = example_sales, "population" = example_population)
app <- plotthis_AreaPlotApp(data_list)
#> Warning: Navigation containers expect a collection of `bslib::nav_panel()`/`shiny::tabPanel()`s and/or `bslib::nav_menu()`/`shiny::navbarMenu()`s. Consider using `header` or `footer` if you wish to place content above (or below) every panel's contents.
if (interactive()) runApp(app)
```
