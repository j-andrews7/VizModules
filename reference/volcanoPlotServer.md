# Server logic for volcanoPlot module

This module builds upon the `scatterPlotServer()` to provide a volcano
plot with interactive significance and fold-change thresholding.

## Usage

``` r
volcanoPlotServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = c("Trajectory", "Facets")
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` containing the data frame to plot. Must contain `padj`
  and `log2FoldChange` columns.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide.

## Value

The `moduleServer` function for the volcanoPlot module.

## Author

Jared Andrews
