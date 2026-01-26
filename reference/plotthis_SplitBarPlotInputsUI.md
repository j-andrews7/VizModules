# Input UI components for the SplitBarPlot module

Builds the tabbed input controls used to configure the SplitBarPlot
module. This should be placed alongside
[`plotthis_SplitBarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotOutputUI.md)
in your app.

## Usage

``` r
plotthis_SplitBarPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = NULL,
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A data frame used to populate input choices.

- defaults:

  Named list of default input values.

- title:

  Optional title for the input panel.

- columns:

  Integer. Number of columns for organizing inputs.

## Value

A Shiny UI element containing the inputs for SplitBarPlot.

## Author

Jacob Martin
