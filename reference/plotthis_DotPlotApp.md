# Create an example Modular DotPlot Shiny Application

This function generates a Shiny application with modular
[`plotthis::DotPlot()`](https://pwwang.github.io/plotthis/reference/dotplot.html)
components. The app features a **Data Import** section for uploading
data, a **Data Table** for filtering the active dataset, and a **Plot**
area for configuring and displaying an interactive dot plot.

## Usage

``` r
plotthis_DotPlotApp(
  data_list = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("markers" = example_markers)` is used as example data.

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
`example_markers` as an example dataset. Uploaded data files are added
to the available datasets and can be selected for plotting. If an
uploaded file shares a name with an existing dataset, the existing one
is overwritten with a warning.

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md).

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data:
app <- plotthis_DotPlotApp()
if (interactive()) runApp(app)

# Launch with custom data:
app2 <- plotthis_DotPlotApp(list("markers" = example_markers))
if (interactive()) runApp(app2)
```
