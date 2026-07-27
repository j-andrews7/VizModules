# Create a Shiny App for Dumbbell Plots

This function generates a Shiny application for interactive dumbbell
plots. The app features a **Data Import** section for uploading data, a
**Data Table** for filtering the active dataset, and a **Plot** area for
configuring and displaying an interactive dumbbell plot.

## Usage

``` r
dumbbellPlotApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("school_earnings" = example_school_earnings)` is used as example
  data.

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
`example_school_earnings` as an example dataset. Uploaded data files are
added to the available datasets and can be selected for plotting. If an
uploaded file shares a name with an existing dataset, the existing one
is overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

## See also

[`dumbbellPlot()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlot.md),
[`dumbbellPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotInputsUI.md),
[`dumbbellPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotOutputUI.md),
[`dumbbellPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- dumbbellPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
data <- data.frame(
    School = c("MIT", "Stanford", "Harvard"),
    Women = c(94, 96, 112),
    Men = c(152, 151, 165),
    Group = c("A", "B", "A")
)
app2 <- dumbbellPlotApp(list("School Earnings" = data))
if (interactive()) runApp(app2)
```
