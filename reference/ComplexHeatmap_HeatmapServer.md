# Server logic for the ComplexHeatmap module

Server logic for the ComplexHeatmap module

## Usage

``` r
ComplexHeatmap_HeatmapServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  defaults = NULL
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` yielding either a data frame (the matrix's columns plus
  any row-annotation columns, all together — the original, single-table
  behavior) or
  `list(matrix = <data.frame>, column_annotations = <data.frame>)` to
  additionally enable column annotations, where `column_annotations` is
  a per-sample metadata table keyed by a column matching the matrix's
  selected column names (see the "Column Key" input). A `NULL` value (or
  a list missing `matrix`) is treated as "not ready yet" and the module
  waits for data.

- hide.inputs:

  A character vector of input IDs to hide. These will still be
  initialized and their values used, but the user will not be able to
  see/adjust them in the UI.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs will
  still be initialized and used, but not shown in the UI.

- defaults:

  A named list of default values for the inputs. When the reset button
  is clicked, inputs are reset to these values rather than hardcoded
  fallbacks. Typically the same list passed to the UI function. An entry
  may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html),
  in which case the input tracks it as the parent app's state changes;
  see
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md).

## Value

The `moduleServer` function for the ComplexHeatmap module. The returned
reactive yields the source-download bundle (matrix data + inputs).

## Details

The incoming data frame is converted to a numeric matrix using the
selected matrix columns (and optional row-name column). Row/column
annotation tracks configured on the "Annotations" tab are built as
[`ComplexHeatmap::rowAnnotation()`](https://rdrr.io/pkg/ComplexHeatmap/man/rowAnnotation.html)/[`ComplexHeatmap::columnAnnotation()`](https://rdrr.io/pkg/ComplexHeatmap/man/columnAnnotation.html)
(one per side) and passed as `left_annotation`/`right_annotation`/
`top_annotation`/`bottom_annotation`. The heatmap is built with
[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
and registered for interactivity with
[`InteractiveComplexHeatmap::makeInteractiveComplexHeatmap()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/makeInteractiveComplexHeatmap.html),
which draws it onto its own device to capture the interactive widget.

Both ComplexHeatmap and InteractiveComplexHeatmap are Bioconductor
packages and are only required at runtime for this module; they are
guarded with
[`requireNamespace()`](https://rdrr.io/r/base/ns-load.html).

## See also

[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html),
[`ComplexHeatmap_HeatmapInputsUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInputsUI.md),
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md),
[`ComplexHeatmap_HeatmapApp()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapApp.md)

## Author

Jacob Martin, Jared Andrews
