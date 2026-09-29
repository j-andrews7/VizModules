# Create an example Modular piePlot Shiny Application

This function generates a Shiny application with modular piePlot
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive pie plot.

## Usage

``` r
piePlotApp(
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
  Each data frame should already contain a label column and an
  aggregated numeric value column, one row per slice.

- defaults:

  A named list of input IDs and their default values to apply on
  startup. An entry may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
  to have the input follow the parent app's state; see
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_reactive_defaults.md).

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
`sales_by_region` (`example_sales` revenue summed by region) with the
settings the module gallery
([`moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/dev/reference/moduleGalleryApp.md))
opens this module on, so its main features are on show from the start;
any `defaults` you pass are applied over those. Uploaded data files are
added to the available datasets and can be selected for plotting. If an
uploaded file shares a name with an existing dataset, the existing one
is overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/dev/reference/createModuleApp.md).

## See also

[`piePlot()`](https://j-andrews7.github.io/VizModules/dev/reference/piePlot.md),
[`piePlotInputsUI()`](https://j-andrews7.github.io/VizModules/dev/reference/piePlotInputsUI.md),
[`piePlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/piePlotOutputUI.md),
[`piePlotServer()`](https://j-andrews7.github.io/VizModules/dev/reference/piePlotServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- piePlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
sales_summary <- aggregate(revenue ~ product_line, example_sales, sum)
app2 <- piePlotApp(list("sales" = sales_summary))
if (interactive()) runApp(app2)
```
