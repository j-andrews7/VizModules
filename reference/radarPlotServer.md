# Server logic for radarPlot module

Server logic for radarPlot module

## Usage

``` r
radarPlotServer(id, data, hide.inputs = NULL, hide.tabs = NULL)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` containing the data frame to plot. Provide data with
  columns for categories (theta) and values (r). For multiple traces,
  include a grouping column.

- hide.inputs:

  A character vector of input IDs to hide. These will still be
  initialized and their values passed to the plot function, but the user
  will not be able to see/adjust them in the UI.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs will
  still be initialized and their values passed to the plot function, but
  the user will not be able to see/adjust them in the UI.

## Value

The `moduleServer` function for the radarPlot module.

## See also

[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md),
[`radarPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotInputsUI.md),
[`radarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotOutputUI.md),
[`radarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/radarPlotApp.md)

## Author

Jacob Martin
