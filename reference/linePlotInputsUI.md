# Input UI components for the linePlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`linePlotServer()`](https://j-andrews7.github.io/VizModules/reference/linePlotServer.md)
and
[`linePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/linePlotOutputUI.md)
functions.

## Usage

``` r
linePlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## See also

[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`linePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/linePlotOutputUI.md),
[`linePlotServer()`](https://j-andrews7.github.io/VizModules/reference/linePlotServer.md),
[`linePlotApp()`](https://j-andrews7.github.io/VizModules/reference/linePlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data(mtcars)
linePlotInputsUI("linePlot", mtcars)
#> Error in materialSwitch(ns("order.by"), "Order plot by:", value = FALSE,     offLabel = "x axis", onLabel = "y axis", status = "success"): unused arguments (offLabel = "x axis", onLabel = "y axis")
```
