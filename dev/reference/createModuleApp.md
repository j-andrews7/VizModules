# Create an Example Module App from Any Module Trio

Factory function that generates a standard Shiny application for any
VizModules module. The resulting app features a **Data Import** section
for uploading data files, a **Data Table** for viewing and editing the
active dataset, and a **Plot** area for configuring and displaying an
interactive plot.

## Usage

``` r
createModuleApp(
  inputs_ui_fn,
  output_ui_fn,
  server_fn,
  data_list,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL,
  show.table = TRUE,
  title = "VizModules App"
)
```

## Arguments

- inputs_ui_fn:

  A function with signature `function(id, data, ...)` that returns
  module input UI elements (e.g.
  [`plotthis_BarPlotInputsUI()`](https://j-andrews7.github.io/VizModules/dev/reference/plotthis_BarPlotInputsUI.md)).

- output_ui_fn:

  A function with signature `function(id)` that returns the module's
  output UI (e.g.
  [`plotthis_BarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/plotthis_BarPlotOutputUI.md)).

- server_fn:

  A function with signature `function(id, data, ...)` that drives the
  module server logic (e.g.
  [`plotthis_BarPlotServer()`](https://j-andrews7.github.io/VizModules/dev/reference/plotthis_BarPlotServer.md)).

- data_list:

  A named list of data frames. At least one element is required.

- defaults:

  A named list of ui ids and their default values that can change the ui
  default settings on startup.

- hide.inputs:

  A character vector of input IDs to hide. These inputs are still
  initialized and their values passed to the plot, but are not shown in
  the UI. Passed through to `server_fn` when it accepts a `hide.inputs`
  argument.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs are
  still initialized and their values passed to the plot, but are not
  shown in the UI. Passed through to `server_fn` when it accepts a
  `hide.tabs` argument.

- show.table:

  Logical. When `TRUE` (default), a filterable DT table is shown below
  the plot and its row selection drives the data passed to the plot
  module. When `FALSE`, the table and filter controls are hidden and the
  full (unfiltered) dataset is passed directly to the plot module.

- title:

  A character string used as the page title (default:
  `"VizModules App"`).

## Value

A [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object.

## Details

Uploaded files (Excel, CSV, TSV, or tab-delimited text) are added to the
available datasets and can be selected for plotting. If an uploaded file
shares a name with an existing dataset, the existing one is overwritten
with a warning.

Every module-specific `*App()` convenience function (e.g.
[`plotthis_BarPlotApp()`](https://j-andrews7.github.io/VizModules/dev/reference/plotthis_BarPlotApp.md),
[`linePlotApp()`](https://j-andrews7.github.io/VizModules/dev/reference/linePlotApp.md))
is a thin wrapper around `createModuleApp()`. You can also call it
directly for quick prototyping or to create apps for custom wrapper
modules.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)

# Quick-launch a bar plot app with custom data:
app <- createModuleApp(
    inputs_ui_fn = plotthis_BarPlotInputsUI,
    output_ui_fn = plotthis_BarPlotOutputUI,
    server_fn    = plotthis_BarPlotServer,
    data_list    = list("iris" = iris),
    title        = "My Bar Plot",
    defaults     = NULL
)
if (interactive()) runApp(app)

# Works with any module trio, including custom wrapper modules:
app2 <- createModuleApp(
    inputs_ui_fn = dittoViz_scatterPlotInputsUI,
    output_ui_fn = dittoViz_scatterPlotOutputUI,
    server_fn    = dittoViz_scatterPlotServer,
    data_list    = list("iris" = iris),
    title        = "Scatter",
    defaults    = NULL
)
if (interactive()) runApp(app2)
```
