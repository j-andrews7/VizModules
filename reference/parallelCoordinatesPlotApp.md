# Create an example Modular parallelCoordinatesPlot Shiny Application

This function generates a Shiny application with modular
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md)
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive parallel coordinates
plot.

## Usage

``` r
parallelCoordinatesPlotApp(data_list = NULL)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("mtcars" = mtcars, "iris" = iris)` is used as example data. Each
  data frame should contain at least two numeric or categorical columns.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
`iris` and `mtcars` as example datasets. Uploaded data files are added
to the available datasets and can be selected for plotting. If an
uploaded file shares a name with an existing dataset, the existing one
is overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

## See also

[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md),
[`parallelCoordinatesPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotInputsUI.md),
[`parallelCoordinatesPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotOutputUI.md),
[`parallelCoordinatesPlotServer()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- parallelCoordinatesPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- parallelCoordinatesPlotApp(list("sales" = example_sales, "population" = example_population))
if (interactive()) runApp(app2)
```
