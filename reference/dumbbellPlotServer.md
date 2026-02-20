# Server logic for dumbbellPlot module

Server logic for dumbbellPlot module

## Usage

``` r
dumbbellPlotServer(id, data, hide.inputs = NULL, hide.tabs = NULL)
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

## Value

The `moduleServer` function for the dumbbellPlot module.

## See also

[`dumbbellPlot()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlot.md),
[`dumbbellPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotInputsUI.md),
[`dumbbellPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotOutputUI.md),
[`dumbbellPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotApp.md)

## Author

Jacob Martin
