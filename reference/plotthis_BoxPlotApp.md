# Create an example Modular BoxPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::BoxPlot()`](https://pwwang.github.io/plotthis/reference/boxviolinplot.html)
components. The app features a **Data Import** section for uploading
Excel spreadsheets, a **Data Table** for viewing and editing the active
dataset, and a **Plot** area for configuring and displaying an
interactive box plot.

## Usage

``` r
plotthis_BoxPlotApp(data_list = NULL)
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

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- plotthis_BoxPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- plotthis_BoxPlotApp(list("cars" = mtcars))
if (interactive()) runApp(app2)
```
