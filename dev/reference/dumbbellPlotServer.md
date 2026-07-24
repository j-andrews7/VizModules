# Server logic for dumbbellPlot module

Server logic for dumbbellPlot module

## Usage

``` r
dumbbellPlotServer(
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

  A `reactive` containing the data frame to plot.

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

The `moduleServer` function for the dumbbellPlot module.

## See also

[`dumbbellPlot()`](https://j-andrews7.github.io/VizModules/dev/reference/dumbbellPlot.md),
[`dumbbellPlotInputsUI()`](https://j-andrews7.github.io/VizModules/dev/reference/dumbbellPlotInputsUI.md),
[`dumbbellPlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/dumbbellPlotOutputUI.md),
[`dumbbellPlotApp()`](https://j-andrews7.github.io/VizModules/dev/reference/dumbbellPlotApp.md)

## Author

Jacob Martin
