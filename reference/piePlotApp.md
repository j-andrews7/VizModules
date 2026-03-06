# Create an example Modular piePlot Shiny Application

This function generates a Shiny application with modular piePlot
components. The app features a **Data Import** section for uploading
Excel spreadsheets, a **Data Table** for viewing and editing the active
dataset, and a **Plot** area for configuring and displaying an
interactive pie plot.

## Usage

``` r
piePlotApp(data_list = NULL)
```

## Arguments

- data_list:

  An optional named list of summary data frames (one row per slice). If
  `NULL` (the default), aggregated example data is used. Each data frame
  should already contain a label column and an aggregated numeric value
  column.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
aggregated `example_sales` and `example_population` datasets. Uploaded
Excel files are added to the available datasets and can be selected for
plotting. If an uploaded file shares a name with an existing dataset,
the existing one is overwritten with a warning.

## See also

[`piePlot()`](https://j-andrews7.github.io/VizModules/reference/piePlot.md),
[`piePlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/piePlotInputsUI.md),
[`piePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/piePlotOutputUI.md),
[`piePlotServer()`](https://j-andrews7.github.io/VizModules/reference/piePlotServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- piePlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
sales_summary <- aggregate(revenue ~ region, example_sales, sum)
app2 <- piePlotApp(list("sales" = sales_summary))
if (interactive()) runApp(app2)
```
