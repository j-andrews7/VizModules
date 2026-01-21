# Server logic for SplitBarPlot module

Server logic for SplitBarPlot module

## Usage

``` r
SplitBarPlotServer(id, data, hide.inputs = NULL, hide.tabs = NULL)
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

The `moduleServer` function for the SplitBarPlot module.

## See also

[`plotthis::SplitBarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md),
[`SplitBarPlotInputsUI()`](https://j-andrews7.github.io/vizModules/reference/SplitBarPlotInputsUI.md),
[`SplitBarPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/SplitBarPlotOutputUI.md),
[`SplitBarPlotApp()`](https://j-andrews7.github.io/vizModules/reference/SplitBarPlotApp.md)

## Author

Jacob Martin
