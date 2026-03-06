# Create an example Modular radarPlot Shiny Application

This function generates a Shiny application with modular radarPlot
components. The app features a **Data Import** section for uploading
Excel spreadsheets, a **Data Table** for viewing and editing the active
dataset, and a **Plot** area for configuring and displaying an
interactive radar plot.

## Usage

``` r
radarPlotApp(data_list = NULL)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  example datasets with categories and values are used. Each data frame
  should contain columns for categories (theta) and values (r). For
  multiple traces, include a grouping column.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
example `skills` and `team_stats` datasets. Uploaded Excel files are
added to the available datasets and can be selected for plotting. If an
uploaded file shares a name with an existing dataset, the existing one
is overwritten with a warning.

## See also

[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md),
[`radarPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotInputsUI.md),
[`radarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotOutputUI.md),
[`radarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/radarPlotServer.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- radarPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
skills <- data.frame(
    category = c("Speed", "Strength", "Defense", "Stamina", "Speed"),
    value = c(8, 6, 7, 9, 8)
)
app2 <- radarPlotApp(list("skills" = skills))
if (interactive()) runApp(app2)
```
