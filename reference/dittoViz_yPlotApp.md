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

## See also

[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html),
[`dittoViz_yPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotInputsUI.md),
[`dittoViz_yPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotOutputUI.md),
[`dittoViz_yPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotServer.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
data_list <- list("sales" = example_sales, "population" = example_population)
app <- dittoViz_yPlotApp(data_list)
#> Warning: Navigation containers expect a collection of `bslib::nav_panel()`/`shiny::tabPanel()`s and/or `bslib::nav_menu()`/`shiny::navbarMenu()`s. Consider using `header` or `footer` if you wish to place content above (or below) every panel's contents.
if (interactive()) runApp(app)
```
