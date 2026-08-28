# Create an example Modular yPlot Shiny Application

This function generates a Shiny application with modular
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive y plot.

## Usage

``` r
dittoViz_yPlotApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("demographics" = gallery_demographics)` is used as example data.

- defaults:

  A named list of input IDs and their default values to apply on
  startup. An entry may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
  to have the input follow the parent app's state; see
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md).

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
`gallery_demographics` as an example dataset. Uploaded data files are
added to the available datasets and can be selected for plotting. If an
uploaded file shares a name with an existing dataset, the existing one
is overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

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
app2 <- dittoViz_yPlotApp(list("demographics" = example_demographics))
if (interactive()) runApp(app2)
```
