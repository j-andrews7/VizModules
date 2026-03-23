# Create an example Modular BarPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::BarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive bar plot.

## Usage

``` r
plotthis_BarPlotApp(data_list = NULL)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("Bar" = example_bar)` is used as example data.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
`example_bar` as an example dataset. Uploaded data files are added to
the available datasets and can be selected for plotting. If an uploaded
file shares a name with an existing dataset, the existing one is
overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- plotthis_BarPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- plotthis_BarPlotApp(list("Bar" = example_bar))
if (interactive()) runApp(app2)
```
