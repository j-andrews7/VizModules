# Create an example Modular parallelCoordinatesPlot Shiny Application

This function generates a Shiny application with modular
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md)
components. A module is created for each data frame provided in the
named list of data frames.

## Usage

``` r
parallelCoordinatesPlotApp(data_list)
```

## Arguments

- data_list:

  A named list of data frames for which parallelCoordinatesPlot modules
  will be created. That is, UI inputs and a parallel coordinates plot
  will be generated for each. Each data frame should contain at least
  two numeric or categorical columns.

## Value

A Shiny app object.

## See also

[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md),
[`parallelCoordinatesPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotInputsUI.md),
[`parallelCoordinatesPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotOutputUI.md),
[`parallelCoordinatesPlotServer()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data_list <- list("mtcars" = mtcars, "iris" = iris)
app <- parallelCoordinatesPlotApp(data_list)
#> Warning: Navigation containers expect a collection of `bslib::nav_panel()`/`shiny::tabPanel()`s and/or `bslib::nav_menu()`/`shiny::navbarMenu()`s. Consider using `header` or `footer` if you wish to place content above (or below) every panel's contents.
if (interactive()) runApp(app)
```
