# Create an example Modular AreaPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive area plot.

## Usage

``` r
plotthis_AreaPlotApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("sales" = example_sales)` is used as example data.

- defaults:

  A named list of input IDs and their default values to apply on
  startup.

- hide.inputs:

  A character vector of input IDs to hide. Their values are still
  initialized and used, but the controls are not shown in the UI.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs are
  still initialized and used, but the controls are not shown in the UI.

## Value

A Shiny app object.

## Details

When `data_list` is not provided (or `NULL`), the app launches with
`example_sales` as an example dataset. Uploaded data files are added to
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
app <- plotthis_AreaPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- plotthis_AreaPlotApp(list("sales" = example_sales))
if (interactive()) runApp(app2)
```
