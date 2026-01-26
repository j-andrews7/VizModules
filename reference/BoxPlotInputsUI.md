# Input UI components for the BoxPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`BoxPlotServer()`](https://j-andrews7.github.io/vizModules/reference/BoxPlotServer.md)
and
[`BoxPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/BoxPlotOutputUI.md)
functions.

## Usage

``` r
BoxPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## See also

[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md),
[`BoxPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/BoxPlotOutputUI.md),
[`BoxPlotServer()`](https://j-andrews7.github.io/vizModules/reference/BoxPlotServer.md),
[`BoxPlotApp()`](https://j-andrews7.github.io/vizModules/reference/BoxPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(vizModules)
data(mtcars)
BoxPlotInputsUI("BoxPlot", mtcars)
#> Error in materialSwitch(ns("stack"), "Stack Plot: ", value = FALSE, onLabel = "Stacked",     offLabel = "Not Stacked", status = "success"): unused arguments (onLabel = "Stacked", offLabel = "Not Stacked")
```
