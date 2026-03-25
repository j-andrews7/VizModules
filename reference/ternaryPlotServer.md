# Server logic for ternaryPlot module

Server logic for ternaryPlot module

## Usage

``` r
ternaryPlotServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  defaults = NULL
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` containing the data frame to plot. Provide data with
  numeric columns for the three ternary axes (a, b, c). For multiple
  traces, include a grouping column.

- hide.inputs:

  A character vector of input IDs to hide. These will still be
  initialized and their values passed to the plot function, but the user
  will not be able to see/adjust them in the UI.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs will
  still be initialized and their values passed to the plot function, but
  the user will not be able to see/adjust them in the UI.

- defaults:

  A named list of default values for the inputs. When the reset button
  is clicked, inputs are reset to these values rather than hardcoded
  fallbacks. Typically the same list passed to the corresponding UI
  function.

## Value

The `moduleServer` function for the ternaryPlot module.

## See also

[`ternaryPlot()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlot.md),
[`ternaryPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotInputsUI.md),
[`ternaryPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotOutputUI.md),
[`ternaryPlotApp()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotApp.md)

## Author

Jacob Martin
