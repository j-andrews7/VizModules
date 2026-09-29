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
  `example_heatmap_matrix` is used as example data — paired with
  `example_heatmap_column_data` unless `column_data` says otherwise.
  When `column_data` is supplied it is attached to the first entry,
  which becomes `list(matrix = , column_annotations = )`.

- column_data:

  An optional data frame of per-sample metadata, enabling column
  annotations, column splitting, and metadata-aware column filtering.
  Defaults to `example_heatmap_column_data` when `data_list` is also
  `NULL`; pass `data_list` explicitly to opt out. Attached to the first
  `data_list` entry (see
  [`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.md)'s
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

When neither `data_list` nor `column_data` is provided, the app launches
on the bundled pair — `example_heatmap_matrix` (a simulated gene x
sample expression matrix) together with `example_heatmap_column_data`
(its per-sample metadata), with `column_key` seeded to `"sample"`. The
column-annotation, column-split, and column-filter features are all
inert without a metadata table, so this way a bare
`ComplexHeatmap_HeatmapApp()` demonstrates the whole module.

Either way the app has the usual **Data Import** section for uploading
data and a **Data Table** for filtering the active dataset. Filtering
applies to the matrix; any companion metadata table rides along
untouched. Uploaded data files are added to the available datasets and
can be selected for plotting. If an uploaded file shares a name with an
existing dataset, the existing one is overwritten with a warning.

Unlike the other modules, this one depends on the Bioconductor packages
ComplexHeatmap, InteractiveComplexHeatmap, and circlize, which must be
installed (e.g. via `BiocManager::install()`).

This is a convenience wrapper around
[`createModuleApp()`](https://j-andrews7.github.io/VizModules/reference/createModuleApp.md),
which accepts a dataset entry that is a list of tables and filters only
the primary one, so the two-table
`list(matrix = , column_annotations = )` shape this module's column
features need is carried through without a bespoke app (see
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.md)'s
`data` parameter).

## See also

[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html),
[`ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.md),
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md),
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Launch on the bundled matrix + its per-sample metadata, so the column
# annotation/split/filter features are all usable:
app <- ComplexHeatmap_HeatmapApp()
if (interactive()) shiny::runApp(app)

# Matrix only, without the per-sample metadata:
app2 <- ComplexHeatmap_HeatmapApp(data_list = list(matrix = example_heatmap_matrix))
if (interactive()) shiny::runApp(app2)
```
