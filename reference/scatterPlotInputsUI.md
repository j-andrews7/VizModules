# Input UI components for the scatterPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`scatterPlotServer()`](https://j-andrews7.github.io/vizModules/reference/scatterPlotServer.md)
and
[`scatterPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/scatterPlotOutputUI.md)
functions.

## Usage

``` r
scatterPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

Note that some of the parameters may have input types that differ from
the actual function, e.g. `shape.panel` is a text input for
comma-separated integers, while the function expects a vector of
integers. The module will parse such inputs into the appropriate format
for
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
automatically.

There are also a handful that are specific to the Shiny module that
additionally modify the plotly output:

- `id`: The ID for the Shiny module.

## Plot parameters not implemented or with altered functionality

The following
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
parameters are superseded by the enhanced Lines tab:

- `add.xline` - Use `vline.intercepts` instead for vertical lines with
  full styling options

- `add.yline` - Use `hline.intercepts` instead for horizontal lines with
  full styling options

- `xline.linetype` - Use `vline.linetypes` instead

- `xline.color` - Use `vline.colors` instead

- `yline.linetype` - Use `hline.linetypes` instead

- `yline.color` - Use `hline.colors` instead

The new Lines tab provides enhanced functionality including multiple
lines per type, individual line widths, opacities, and diagonal/ablines
with slope control.

## See also

[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md),
[`scatterPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/scatterPlotOutputUI.md),
[`scatterPlotServer()`](https://j-andrews7.github.io/vizModules/reference/scatterPlotServer.md),
[`scatterPlotApp()`](https://j-andrews7.github.io/vizModules/reference/scatterPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(vizModules)
data(mtcars)
scatterPlotInputsUI("scatterPlot", mtcars)
#> Error in materialSwitch(ns("best.fit"), "Line of best fit:", value = FALSE,     offLabel = "Off", onLabel = "On", status = "success"): unused arguments (offLabel = "Off", onLabel = "On")
```
