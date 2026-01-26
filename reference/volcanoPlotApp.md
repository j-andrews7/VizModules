# Create a standalone Shiny app for the volcanoPlot module

Create a standalone Shiny app for the volcanoPlot module

## Usage

``` r
volcanoPlotApp(df)
```

## Arguments

- df:

  A data frame to plot. Must contain `padj` and `log2FoldChange`
  columns.

## Value

A Shiny app object.

## See also

[`volcanoPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotInputsUI.md),
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotOutputUI.md),
[`volcanoPlotServer()`](https://j-andrews7.github.io/VizModules/reference/volcanoPlotServer.md),
[airway_deseq2](https://j-andrews7.github.io/VizModules/reference/airway_deseq2.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
data(airway_deseq2)
if (interactive()) {
    volcanoPlotApp(airway_deseq2)
}
```
