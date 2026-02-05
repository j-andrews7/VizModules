# Server logic for yPlot module

Server logic for yPlot module

## Usage

``` r
dittoViz_yPlotServer(id, data, hide.inputs = NULL, hide.tabs = NULL)
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

The `moduleServer` function for the yPlot module.

## See also

[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html),
[`dittoViz_yPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotInputsUI.md),
[`dittoViz_yPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotOutputUI.md),
[`dittoViz_yPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotApp.md)

## Author

Jared Andrews, Jacob Martin
