# Input UI components for the volcanoPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`volcanoPlotServer()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotServer.md)
and
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotOutputUI.md)
functions.

## Usage

``` r
volcanoPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = "Volcano Settings",
  columns = 2
)
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

Additional inputs specific to volcano plots are added to control
significance thresholds and colors:

- `sig.thresh`: Significance threshold (default 0.05)

- `fc.thresh`: Log2 fold change threshold (default 0)

- `color.up`: Color for upregulated genes (default "red")

- `color.down`: Color for downregulated genes (default "blue")

- `color.ns`: Color for non-significant genes (default "lightgray")

## See also

[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md),
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotOutputUI.md),
[`volcanoPlotServer()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotServer.md),
[`volcanoPlotApp()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(vizModules)
data(airway_deseq2)
volcanoPlotInputsUI("volcanoPlot", airway_deseq2)
#> Error in materialSwitch(ns("best.fit"), "Line of best fit:", value = FALSE,     offLabel = "Off", onLabel = "On", status = "success"): unused arguments (offLabel = "Off", onLabel = "On")
```
