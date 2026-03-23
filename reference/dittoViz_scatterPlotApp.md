# Create an example Modular scatterPlot Shiny Application

This function generates a Shiny application with modular
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive scatter plot.

## Usage

``` r
dittoViz_scatterPlotApp(data_list = NULL)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("sales" = gallery_sales)` is used as example data.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
`gallery_sales` as an example dataset. Uploaded data files are added to
the available datasets and can be selected for plotting. If an uploaded
file shares a name with an existing dataset, the existing one is
overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

## See also

[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
[`dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.md),
[`dittoViz_scatterPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotOutputUI.md),
[`dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- dittoViz_scatterPlotApp()
#> Error in dittoViz_scatterPlotApp(): object 'gallery_sales' not found
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- dittoViz_scatterPlotApp(list("sales" = gallery_sales))
#> Error: object 'gallery_sales' not found
if (interactive()) runApp(app2)
```
