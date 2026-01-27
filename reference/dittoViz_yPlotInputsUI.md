# Input UI components for the yPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoViz_yPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotServer.md)
and
[`dittoViz_yPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotOutputUI.md)
functions.

## Usage

``` r
dittoViz_yPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation.

- defaults:

  A named list of default values for the inputs.

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The user inputs for this module are separated from the outputs to allow
for more flexible UI design.

The inputs will automatically be organized into a grid layout via the
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html) can
be set via these inputs, so see the help for that function for an
exhaustive list.

## See also

[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`dittoViz_yPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotOutputUI.md),
[`dittoViz_yPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotServer.md),
[`dittoViz_yPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotApp.md)

## Author

Jared Andrews, Jacob Martin

## Examples

``` r
library(VizModules)
data(mtcars)
dittoViz_yPlotInputsUI("yPlot", mtcars)
#> Error in materialSwitch(ns("auto.update"), "Auto Update", value = FALSE,     size = "mini", status = "success"): unused argument (size = "mini")
```
