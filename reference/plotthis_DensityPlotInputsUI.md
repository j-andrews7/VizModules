# Density Plot Input UI Module

Generates the user interface for density plot configuration, including
data selection, faceting options, aesthetic controls (alpha, position),
and detailed axis styling.

## Usage

``` r
plotthis_DensityPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = NULL,
  columns = 2
)
```

## Arguments

- id:

  `character` unique ID for the shiny namespace.

- data:

  `data.frame` The dataset used to populate column selection choices.

- defaults:

  `list` Optional named list of default values for the inputs.

- title:

  `character` Optional title for the input panel.

- columns:

  `numeric` Number of columns to organize the inputs into. Default is 2.

## Value

A `tagList` containing the organized UI elements.

## Author

Jacob Martin
