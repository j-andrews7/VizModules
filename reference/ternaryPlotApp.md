# Create an example Modular ternaryPlot Shiny Application

This function generates a Shiny application with modular ternaryPlot
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive ternary plot.

## Usage

``` r
ternaryPlotApp(data_list = NULL)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  example datasets with three numeric columns are used. Each data frame
  should contain numeric columns for the three ternary axes (a, b, c).
  For multiple traces, include a grouping column.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
example `roles` and `teams` datasets. Uploaded data files are added to
the available datasets and can be selected for plotting. If an uploaded
file shares a name with an existing dataset, the existing one is
overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

## See also

[`ternaryPlot()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlot.md),
[`ternaryPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotInputsUI.md),
[`ternaryPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotOutputUI.md),
[`ternaryPlotServer()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- ternaryPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
df <- data.frame(
    journalist = c(75, 70, 75, 5, 10),
    developer = c(25, 10, 20, 60, 80),
    designer = c(0, 20, 5, 35, 10)
)
app2 <- ternaryPlotApp(list("roles" = df))
if (interactive()) runApp(app2)
```
