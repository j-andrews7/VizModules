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
  title = "VizModules App"
)
```

## Arguments

- inputs_ui_fn:

  A function with signature `function(id, data, ...)` that returns
  module input UI elements (e.g.
  [`plotthis_BarPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotInputsUI.md)).

- output_ui_fn:

  A function with signature `function(id)` that returns the module's
  output UI (e.g.
  [`plotthis_BarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotOutputUI.md)).

- server_fn:

  A function with signature `function(id, data, ...)` that drives the
  module server logic (e.g.
  [`plotthis_BarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotServer.md)).

- data_list:

  A named list of data frames. At least one element is required.

- defaults:

  A named list of ui ids and their default values that can change the ui
  default settings on startup.

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
[`plotthis_BarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotApp.md),
[`linePlotApp()`](https://j-andrews7.github.io/VizModules/reference/linePlotApp.md))
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
