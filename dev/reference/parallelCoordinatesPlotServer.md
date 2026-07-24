# Server logic for parallelCoordinatesPlot module

Server logic for parallelCoordinatesPlot module

## Usage

``` r
parallelCoordinatesPlotServer(
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

The `moduleServer` function for the parallelCoordinatesPlot module.

## See also

[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlot.md),
[`parallelCoordinatesPlotInputsUI()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlotInputsUI.md),
[`parallelCoordinatesPlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlotOutputUI.md),
[`parallelCoordinatesPlotApp()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlotApp.md)

## Author

Jacob Martin, Jared Andrews
