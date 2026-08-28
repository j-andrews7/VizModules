# Create an example Modular ComplexHeatmap Shiny Application

This function generates a Shiny application with modular
[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
components rendered interactively via InteractiveComplexHeatmap. The app
features a **Data Import** section for uploading data, a **Data Table**
for filtering the active dataset, and a **Plot** area for configuring
and displaying the interactive heatmap.

## Usage

``` r
ComplexHeatmap_HeatmapApp(
  data_list = NULL,
  column_data = NULL,
  defaults = NULL,
  hide.inputs = NULL,
  hide.tabs = NULL
)
```

## Arguments

- data_list:

  An optional named list of data frames. If `NULL` (the default),
  `list("matrix" = example_heatmap_matrix)` is used as example data.
  Ignored (only its first element is used, as the matrix) when
  `column_data` is supplied — that path has no dataset
  picker/upload/filter UI.

- column_data:

  An optional data frame of per-sample metadata, enabling column
  annotations (see
  [`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapServer.md)'s
  `data` parameter for the expected shape — a key column matching the
  matrix's column names, plus arbitrary annotation columns). When
  supplied, the app is a minimal single-dataset
  [`shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html) (no Data
  Import/Data Table sections) wiring
  `data = list(matrix = <first element of data_list, or example_heatmap_matrix>, column_annotations = column_data)`
  directly into the module.

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

When `data_list` is not provided (or `NULL`), the app launches with
`example_heatmap_matrix` (a simulated gene x sample expression matrix)
as an example dataset. Uploaded data files are added to the available
datasets and can be selected for plotting. If an uploaded file shares a
name with an existing dataset, the existing one is overwritten with a
warning.

Unlike the other modules, this one depends on the Bioconductor packages
ComplexHeatmap, InteractiveComplexHeatmap, and circlize, which must be
installed (e.g. via `BiocManager::install()`).

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/dev/reference/createModuleApp.md)
— *except* when `column_data` is supplied (see below), which needs a
small bespoke app instead, since
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/dev/reference/createModuleApp.md)
always hands the module server a single data frame and can't carry the
two-table `list(matrix = , column_annotations = )` shape the module's
column-annotation feature needs (see
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapServer.md)'s
`data` parameter).

## See also

[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html),
[`ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapInputsUI.md),
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapOutputUI.md),
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch with default example data (row annotations only):
app <- ComplexHeatmap_HeatmapApp()
if (interactive()) shiny::runApp(app)

# Launch with column annotations too:
app2 <- ComplexHeatmap_HeatmapApp(column_data = example_heatmap_column_data)
if (interactive()) shiny::runApp(app2)
```
