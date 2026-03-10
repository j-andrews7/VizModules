# Create an example Modular ViolinPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::ViolinPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive violin plot.

## Usage

``` r
plotthis_ViolinPlotApp(data_list = NULL)
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
data files are added to the available datasets and can be selected for
plotting. If an uploaded file shares a name with an existing dataset,
the existing one is overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- plotthis_ViolinPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- plotthis_ViolinPlotApp(list("sales" = example_sales, "population" = example_population))
if (interactive()) runApp(app2)
```
