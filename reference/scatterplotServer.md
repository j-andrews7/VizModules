# Server logic for scatterPlot module

Server logic for scatterPlot module

## Usage

``` r
scatterPlotServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  manual.colors = NULL
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

- manual.colors:

  A character vector of colors, a reactive returning a character vector
  of colors, or a function that takes the `input` list and returns a
  named character vector of colors.

## Value

The `moduleServer` function for the scatterPlot module.

## Author

Jared Andrews
