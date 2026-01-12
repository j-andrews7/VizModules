# Server logic for linePlot module

Server logic for linePlot module

## Usage

``` r
linePlotServer(id, data, hide.inputs = NULL, hide.tabs = NULL)
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

The `moduleServer` function for the linePlot module.

## See also

[`linePlot()`](https://j-andrews7.github.io/vizModules/reference/linePlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/vizModules/reference/organize_inputs.md),
[`linePlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/linePlotOutputUI.md),
`linePlotServer()`,
[`linePlotApp()`](https://j-andrews7.github.io/vizModules/reference/linePlotApp.md)

## Author

Jacob Martin
