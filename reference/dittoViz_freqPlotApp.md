# Create an example Modular freqPlot Shiny Application

This function generates a Shiny application with modular
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive frequency plot.

## Usage

``` r
dittoViz_freqPlotApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default), the
  module's example dataset is used, along with its showcase defaults.

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

When `data_list` is not provided (or `NULL`), the app launches on
`example_composition` (twelve donors nested inside two conditions, the
shape
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
needs to compare per-sample frequencies across groups) with the settings
the module gallery
([`moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/reference/moduleGalleryApp.md))
opens this module on, so its main features are on show from the start;
any `defaults` you pass are applied over those. Uploaded data files are
added to the available datasets and can be selected for plotting. If an
uploaded file shares a name with an existing dataset, the existing one
is overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

## See also

[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html),
[`dittoViz_freqPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotInputsUI.md),
[`dittoViz_freqPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotOutputUI.md),
[`dittoViz_freqPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotServer.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- dittoViz_freqPlotApp()
if (interactive()) runApp(app)

# The same example data, as raw cell counts and without the statistics:
app2 <- dittoViz_freqPlotApp(defaults = list(scale = "count", stats.enabled = FALSE))
if (interactive()) runApp(app2)
```
