# Server logic for parallelCoordinatesPlot module

Server logic for parallelCoordinatesPlot module

## Usage

``` r
parallelCoordinatesPlotServer(id, data, hide.inputs = NULL, hide.tabs = NULL)
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

The `moduleServer` function for the parallelCoordinatesPlot module.

## See also

[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md),
[`parallelCoordinatesPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotInputsUI.md),
[`parallelCoordinatesPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotOutputUI.md),
[`parallelCoordinatesPlotApp()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotApp.md)

## Author

Jacob Martin, Jared Andrews
