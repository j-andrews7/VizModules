# Create an example Modular yPlot Shiny Application

This function generates a Shiny application with modular
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
components. The app features a **Data Import** section for uploading
Excel spreadsheets, a **Data Table** for viewing and editing the active
dataset, and a **Plot** area for configuring and displaying an
interactive y plot.

## Usage

``` r
dittoViz_yPlotApp(data_list = NULL)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("sales" = example_sales, "population" = example_population)` is
  used as example data.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
`example_sales` and `example_population` as example datasets. Uploaded
Excel files are added to the available datasets and can be selected for
plotting. If an uploaded file shares a name with an existing dataset,
the existing one is overwritten with a warning.

## See also

[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html),
[`dittoViz_yPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotInputsUI.md),
[`dittoViz_yPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotOutputUI.md),
[`dittoViz_yPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotServer.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- dittoViz_yPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- dittoViz_yPlotApp(list("cars" = mtcars))
if (interactive()) runApp(app2)
```
