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

[`volcanoPlotInputsUI()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotInputsUI.md),
[`volcanoPlotOutputUI()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotOutputUI.md),
[`volcanoPlotServer()`](https://j-andrews7.github.io/vizModules/reference/volcanoPlotServer.md),
[airway_deseq2](https://j-andrews7.github.io/vizModules/reference/airway_deseq2.md)

## Author

Jared Andrews

## Examples

``` r
library(vizModules)
data(airway_deseq2)
if (interactive()) {
    volcanoPlotApp(airway_deseq2)
}
```
