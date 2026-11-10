# Input UI components for the ComplexHeatmap module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.md)
and
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md)
functions.

## Usage

``` r
ComplexHeatmap_HeatmapInputsUI(
  id,
  data,
  defaults = NULL,
  title = NULL,
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation, *or* a list with a `matrix`
  data frame (required) and a `column_annotations` data frame (optional)
  — see
  [`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.md)'s
  `data` parameter for details. Row-annotation choices come from
  `matrix`'s columns; column-annotation choices (and the "Column
  Annotations" tab controls) only appear when `column_annotations` is
  supplied.

- defaults:

  A named list of default values for the inputs. An entry may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html);
  it is resolved with
  [`shiny::isolate()`](https://rdrr.io/pkg/shiny/man/isolate.html) to
  seed the control, and the module then keeps it live (see
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md)).

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements.

## Details

Unlike the other plotly-based modules, this module wraps
[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
and renders its interactive output via the InteractiveComplexHeatmap
package. The incoming data frame is converted to a numeric matrix (see
the Data / Matrix tab) before being passed to
[`Heatmap()`](https://pwwang.github.io/plotthis/reference/Heatmap.html).

The inputs are organized into a grid via
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
with `columns` controlling the number of columns in the grid. Defaults
for each input can be supplied via the `defaults` argument (see
[`get_default()`](https://j-andrews7.github.io/VizModules/reference/get_default.md)).

## Plot parameters and defaults

The following
[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `matrix.cols` - Numeric columns forming the matrix (UI: "Matrix
  Columns", default: all numeric columns)

- `rowname.col` - Column used as row names (UI: "Row Name Column",
  default: "")

- `name` - Heatmap / legend title (UI: "Heatmap Name", default: "value")

- `na_col` - Color for `NA` cells (UI: "NA Color", default: "grey")

- `scale` - Z-score the matrix by row, column, or not at all (UI:
  "Scale", default: "None"). Applied before plotting only — row/column
  annotation values and the source-data download always use the unscaled
  matrix. Scaling happens *after* the Filter tab's row/column filters,
  so a Z-score describes only the rows and columns on screen.

- `reverse.palette` - Reverse the palette (UI: "Reverse Palette",
  default: FALSE)

- `low_color`, `mid_color`, `high_color` - Colors for the low/mid/high
  end of the value scale, i.e. what `col` in
  [`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
  is built from via
  [`circlize::colorRamp2()`](https://rdrr.io/pkg/circlize/man/colorRamp2.html)
  (UI: "Low/Mid/High Color", default: blue/white/red)

- `min_value`, `mid_value`, `max_value` - Values mapped to
  `low_color`/`mid_color`/`high_color` (UI: "Min/Mid/Max Value",
  default: NA = derived from the matrix: min, `mean(range(mat))`, and
  max respectively)

- `show_heatmap_legend` - Show the heatmap legend (UI: "Show Legend",
  default: TRUE)

- `border` - Draw heatmap border (UI: "Border", default: FALSE)

- `cluster_rows` - Cluster rows (UI: "Cluster Rows", default: TRUE)

- `cluster_columns` - Cluster columns (UI: "Cluster Columns", default:
  TRUE)

- `clustering_distance_rows` - Row distance metric (UI: "Row Distance",
  default: "euclidean")

- `clustering_distance_columns` - Column distance metric (UI: "Column
  Distance", default: "euclidean")

- `clustering_method_rows` - Row linkage method (UI: "Row Method",
  default: "complete")

- `clustering_method_columns` - Column linkage method (UI: "Column
  Method", default: "complete")

- `show_row_dend` - Show row dendrogram (UI: "Show Row Dendrogram",
  default: TRUE)

- `show_column_dend` - Show column dendrogram (UI: "Show Column
  Dendrogram", default: TRUE)

- `row_split_by` - Row split method: "None", "K-means", "Hierarchical",
  or "Annotation" (UI: "Row Split Method", default: "None"). Only one
  split mechanism is ever active per axis, which avoids the error
  [`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
  raises when both a k-means and a hierarchical split are requested at
  once.

- `row_split_n` - Number of row groups, used when `row_split_by` is
  "K-means" or "Hierarchical" (UI: "Row Groups", default: NA; clamped to
  the number of matrix rows)

- `row_split_cols` - Columns whose values group the rows, used when
  `row_split_by` is "Annotation" (UI: "Row Split Columns", default:
  none). Several columns give nested slices, one per observed
  combination. Values come from the same place row annotation tracks
  read, so a split and a track on one column always agree.

- `column_split_by` - Column split method: "None", "K-means",
  "Hierarchical", or "Annotation" (UI: "Column Split Method", default:
  "None")

- `column_split_n` - Number of column groups, used when
  `column_split_by` is "K-means" or "Hierarchical" (UI: "Column Groups",
  default: NA; clamped to the number of matrix columns)

- `column_split_cols` - Columns of the `column_annotations` table whose
  values group the heatmap columns, used when `column_split_by` is
  "Annotation" (UI: "Column Split Columns"; only shown when `data`
  supplies a `column_annotations` table; default: none)

- `row_gap` - Gap between row slices, mm (UI: "Row Gap (mm)", default:
  1)

- `column_gap` - Gap between column slices, mm (UI: "Column Gap (mm)",
  default: 1)

- `row_title` - Row title (UI: "Row Title", default: "")

- `column_title` - Column title (UI: "Column Title", default: ""). A
  title, when set, replaces the group names a split would otherwise
  title its slices with; a `%s` in it is filled in with each slice's
  group name. The same goes for `row_title`.

- `show_row_slice_titles` - Title each row slice with its group name
  when the rows are split and `row_title` is blank (UI: "Show Row Slice
  Titles", default: TRUE). Applies to every split method: annotation
  values for "Annotation", cluster numbers for "K-means" and
  "Hierarchical". Untick it to remove the titles and the space they
  take.

- `show_column_slice_titles` - The same for columns (UI: "Show Column
  Slice Titles", default: TRUE)

- `show_row_names` - Show row names (UI: "Show Row Names", default:
  TRUE)

- `show_column_names` - Show column names (UI: "Show Column Names",
  default: TRUE)

- `row_names_side` - Row names side (UI: "Row Names Side", default:
  "right")

- `column_names_side` - Column names side (UI: "Column Names Side",
  default: "bottom")

- `column_names_rot` - Column name rotation (UI: "Column Name Rotation",
  default: 90)

- `row_names_fontsize` - Row name font size (UI: "Row Name Size",
  default: 12)

- `column_names_fontsize` - Column name font size (UI: "Column Name
  Size", default: 12)

- `title_fontsize` - Row/column title font size (UI: "Title Size",
  default: 13.2)

- `row_annotations` - Row annotation tracks, built as
  [`ComplexHeatmap::rowAnnotation()`](https://rdrr.io/pkg/ComplexHeatmap/man/rowAnnotation.html)
  and passed as `left_annotation`/`right_annotation` per row (UI:
  "Annotations" tab, "Row Annotations"
  [`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/multiDynamicInput.md)
  — each row picks a `matrix` column, a side (Left or Right), and the
  side and font size of that track's own name label (Bottom or Top,
  since ComplexHeatmap places a row annotation's name above or below
  it), and whether that track contributes a legend ("Show Legend",
  default `TRUE`); default: none). Each row's color control appears just
  below the list once a column is picked: numeric columns get
  Low/Mid/High color pickers, everything else gets a
  [`multiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/multiColorPicker.md)
  with one color per level. Seed those colors from `defaults` with a
  named color vector keyed by the annotation's *column name* — the row
  names in a `row_annotations`/`column_annotations` default are not
  stable, since the client reports rows back as `row1`, `row2`, ...

- `column_key` - Column in `column_annotations` matched against the
  matrix's selected column names (UI: "Annotations" tab, "Column Key";
  only shown when `data` supplies a `column_annotations` table)

- `column_annotations` - Column annotation tracks, built as
  [`ComplexHeatmap::columnAnnotation()`](https://rdrr.io/pkg/ComplexHeatmap/man/columnAnnotation.html)
  and passed as `top_annotation`/`bottom_annotation` per row (UI:
  "Annotations" tab, "Column Annotations"
  [`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/multiDynamicInput.md)
  — each row picks a column, a side (Top or Bottom), the side and font
  size of that track's own name label (Right or Left, since
  ComplexHeatmap places a column annotation's name beside it), and
  whether that track contributes a legend ("Show Legend", default
  `TRUE`), with the same per-row color controls as row annotations; only
  shown when `data` supplies a `column_annotations` table; default:
  none)

## Plot parameters implementing new functionality

The "Filter" tab's two inputs have no
[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
equivalent — they narrow the matrix before it is built, so a specific
set of genes or samples can be plotted without wiring up the separate
`dataFilter` module:

- `row_filter` - Expression keeping only the matching rows (UI: "Row
  Filter", default: ""). Evaluated against the `matrix` data frame, so
  every one of its columns is in scope — annotation columns, the
  row-name column, and the matrix columns themselves.

- `column_filter` - Expression keeping only the matching matrix columns
  (UI: "Column Filter", default: ""). Matrix columns are sample names
  rather than rows of a data frame, so the expression is evaluated
  against a frame built with one row per selected matrix column: a
  synthetic `column` field holding the column name, plus every field of
  `column_annotations` joined via `column_key`.
  `column %in% c("Healthy_1", "Healthy_2")` therefore works with no
  metadata table at all, while `condition == "Disease"` works as soon as
  one is supplied. If `column_annotations` already has a field named
  `column`, the real one wins and no synthetic is added.

Both are evaluated with
[`safe_eval_filter()`](https://j-andrews7.github.io/VizModules/reference/safe_eval_filter.md),
which permits comparisons, `&`/`|`/`!`, `%in%`,
[`is.na()`](https://rdrr.io/r/base/NA.html), arithmetic, and the string
helpers `grepl`, `startsWith`, `endsWith`, `substr`, `nchar`, `toupper`,
`tolower`, and `trimws`. Anything else — a function call outside that
list, or a symbol that is not a column — is rejected and reported in the
UI rather than evaluated. An expression yielding `NA` for a row drops
that row.

Filtering runs before everything else: `scale`, the annotation tracks,
the split methods, and the source download all describe the filtered
matrix.

Both inputs are debounced by 700ms, so the heatmap redraws once you
pause rather than on every keystroke of a half-typed expression.

## Plot parameters not implemented

The following
[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
parameters are not exposed because they require R code, objects, or
annotations that do not map cleanly to UI inputs: `cell_fun`,
`layer_fun`, `post_fun`, `rect_gp`, `border_gp`, custom `col` mapping
functions for the annotation tracks (beyond the Low/Mid/High colors and
`multiColorPicker`), `row_order` / `column_order`, `row_labels` /
`column_labels`, `jitter`, and all rasterization parameters
(`use_raster`, `raster_*`).

## See also

[`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md),
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.md),
[`ComplexHeatmap_HeatmapApp()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
ComplexHeatmap_HeatmapInputsUI("heatmap", example_heatmap_matrix)
}
```
