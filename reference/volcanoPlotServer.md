# Server logic for volcanoPlot module

This module builds upon the
[`dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.md)
to provide a volcano plot with interactive significance and fold-change
thresholding.

## Usage

``` r
volcanoPlotServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = c("Trajectory", "Facets", "Colors", "Legend/Scale")
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` containing the data frame to plot. Must contain effect
  size (e.g., log2FoldChange) and significance (e.g., padj) columns.

- hide.inputs:

  A character vector of input IDs to hide.

- hide.tabs:

  A character vector of tab names to hide. Default hides: "Trajectory",
  "Facets", "Colors", "Legend/Scale".

## Value

The `moduleServer` function for the volcanoPlot module.

## See also

[`dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.md),
[`volcanoPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotInputsUI.md),
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotOutputUI.md),
[`volcanoPlotApp()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotApp.md)

## Author

Jared Andrews
