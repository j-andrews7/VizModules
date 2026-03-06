# Density Plot Server Module

Server-side logic for the density plot module. This function manages
reactive data processing, dynamic UI generation for color palettes, and
the rendering of interactive Plotly density plots.

## Usage

``` r
plotthis_DensityPlotServer(id, data, hide.inputs = NULL, hide.tabs = NULL)
```

## Arguments

- id:

  `character` unique ID for the shiny namespace.

- data:

  `reactive` A reactive expression returning a data frame to be plotted.

- hide.inputs:

  `character` vector of input IDs to hide in the UI. Default is NULL.

- hide.tabs:

  `character` vector of tab names to hide within the module. Default is
  NULL.

## Value

The `moduleServer` function for the DensityPlot module.

## Author

Jacob Martin, Jared Andrews
