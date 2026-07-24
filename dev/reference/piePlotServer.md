# Server logic for piePlot module

Server logic for piePlot module

## Usage

``` r
piePlotServer(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` containing the data frame to plot. Provide a summarized
  table with columns for labels and aggregated values.

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

The `moduleServer` function for the piePlot module.

## See also

[`piePlot()`](https://j-andrews7.github.io/VizModules/dev/reference/piePlot.md),
[`piePlotInputsUI()`](https://j-andrews7.github.io/VizModules/dev/reference/piePlotInputsUI.md),
[`piePlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/piePlotOutputUI.md),
[`piePlotApp()`](https://j-andrews7.github.io/VizModules/dev/reference/piePlotApp.md)

## Author

Jacob Martin, Jared Andrews
