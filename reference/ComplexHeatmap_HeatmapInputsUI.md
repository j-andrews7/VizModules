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
  matrix.

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

- `row_split_by` - Row split method: "None", "K-means", or
  "Hierarchical" (UI: "Row Split Method", default: "None"). Only one
  split mechanism is ever active per axis, which avoids the error
  [`ComplexHeatmap::Heatmap()`](https://rdrr.io/pkg/ComplexHeatmap/man/Heatmap.html)
  raises when both a k-means and a hierarchical split are requested at
  once.

- `row_split_n` - Number of row groups, used when `row_split_by` is not
  "None" (UI: "Row Groups", default: NA; clamped to the number of matrix
  rows)

- `column_split_by` - Column split method: "None", "K-means", or
  "Hierarchical" (UI: "Column Split Method", default: "None")

- `column_split_n` - Number of column groups, used when
  `column_split_by` is not "None" (UI: "Column Groups", default: NA;
  clamped to the number of matrix columns)

- `row_gap` - Gap between row slices, mm (UI: "Row Gap (mm)", default:
  1)

- `column_gap` - Gap between column slices, mm (UI: "Column Gap (mm)",
  default: 1)

- `row_title` - Row title (UI: "Row Title", default: "")

- `column_title` - Column title (UI: "Column Title", default: "")

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
  — each row picks a `matrix` column and a side, Left or Right; default:
  none). Each row's color control appears just below the list once a
  column is picked: numeric columns get Low/Mid/High color pickers,
  everything else gets a
  [`multiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/multiColorPicker.md)
  with one color per level.

- `column_key` - Column in `column_annotations` matched against the
  matrix's selected column names (UI: "Annotations" tab, "Column Key";
  only shown when `data` supplies a `column_annotations` table)

- `column_annotations` - Column annotation tracks, built as
  [`ComplexHeatmap::columnAnnotation()`](https://rdrr.io/pkg/ComplexHeatmap/man/columnAnnotation.html)
  and passed as `top_annotation`/`bottom_annotation` per row (UI:
  "Annotations" tab, "Column Annotations"
  [`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/multiDynamicInput.md)
  — each row picks a column and a side, Top or Bottom, with the same
  per-row color controls as row annotations; only shown when `data`
  supplies a `column_annotations` table; default: none)

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
library(VizModules)
ComplexHeatmap_HeatmapInputsUI("heatmap", example_heatmap_matrix)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="heatmap-HeatmapTabsetPanel" data-tabsetid="9213">
#>     <li class="active">
#>       <a href="#tab-9213-1" data-toggle="tab" data-bs-toggle="tab" data-value="Matrix">Matrix</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9213-2" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9213-3" data-toggle="tab" data-bs-toggle="tab" data-value="Clustering">Clustering</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9213-4" data-toggle="tab" data-bs-toggle="tab" data-value="Labels">Labels</a>
#>     </li>
#>     <li>
#>       <a href="#tab-9213-5" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="9213">
#>     <div class="tab-pane active" data-value="Matrix" id="tab-9213-1">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2168999">
#>             <label class="control-label" id="heatmap-matrix.cols-label" for="heatmap-matrix.cols">Matrix Columns</label>
#>             <div id="heatmap-matrix.cols" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="heatmap-matrix.cols">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["mean_expression","Healthy_1","Healthy_2","Healthy_3","Healthy_4","Healthy_5","Healthy_6","Disease_1","Disease_2","Disease_3","Disease_4","Disease_5","Disease_6"],"value":["mean_expression","Healthy_1","Healthy_2","Healthy_3","Healthy_4","Healthy_5","Healthy_6","Disease_1","Disease_2","Disease_3","Disease_4","Disease_5","Disease_6"]}},"config":{"multiple":true,"search":true,"selectedValue":["mean_expression","Healthy_1","Healthy_2","Healthy_3","Healthy_4","Healthy_5","Healthy_6","Disease_1","Disease_2","Disease_3","Disease_4","Disease_5","Disease_6"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060,"alwaysShowSelectedOptionsCount":true,"optionsSelectedText":"columns shown","optionSelectedText":"column shown"}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2168999', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric columns that form the heatmap matrix'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6801629">
#>             <label class="control-label" id="heatmap-rowname.col-label" for="heatmap-rowname.col">Row Name Column</label>
#>             <div id="heatmap-rowname.col" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-rowname.col">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","gene","pathway"],"value":["","gene","pathway"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6801629', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional column whose values are used as row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4988456">
#>             <label class="control-label" id="heatmap-name-label" for="heatmap-name">Heatmap Name</label>
#>             <input id="heatmap-name" type="text" class="shiny-input-text form-control" value="value" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4988456', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Name of the heatmap, used as the legend title'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6416793">
#>             <label class="control-label" for="heatmap-na_col">NA Color</label>
#>             <input id="heatmap-na_col" type="text" class="form-control shiny-colour-input" data-init-value="grey" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6416793', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color used for NA cells'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6602843">
#>             <label class="control-label" id="heatmap-scale-label" for="heatmap-scale">Scale</label>
#>             <div id="heatmap-scale" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-scale">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","Rows","Columns"],"value":["None","Rows","Columns"]}},"config":{"multiple":false,"search":false,"selectedValue":"None","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6602843', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Z-score the matrix by row or column before plotting (a constant row/column becomes 0)'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-9213-2">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify960242">
#>             <label class="control-label" for="heatmap-low_color">Low Color</label>
#>             <input id="heatmap-low_color" type="text" class="form-control shiny-colour-input" data-init-value="#2166AC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify960242', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the lowest (or Min Value) end of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7656001">
#>             <label class="control-label" id="heatmap-min_value-label" for="heatmap-min_value">Min Value</label>
#>             <input id="heatmap-min_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7656001', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the Low Color (blank = the matrix minimum)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7696748">
#>             <label class="control-label" for="heatmap-mid_color">Mid Color</label>
#>             <input id="heatmap-mid_color" type="text" class="form-control shiny-colour-input" data-init-value="#F7F7F7" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7696748', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the midpoint of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9907123">
#>             <label class="control-label" id="heatmap-mid_value-label" for="heatmap-mid_value">Mid Value</label>
#>             <input id="heatmap-mid_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9907123', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the Mid Color (blank = the midpoint between Min and Max Value; set to 0 to center a z-scored matrix)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9705209">
#>             <label class="control-label" for="heatmap-high_color">High Color</label>
#>             <input id="heatmap-high_color" type="text" class="form-control shiny-colour-input" data-init-value="#B2182B" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9705209', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the highest (or Max Value) end of the scale'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3891828">
#>             <label class="control-label" id="heatmap-max_value-label" for="heatmap-max_value">Max Value</label>
#>             <input id="heatmap-max_value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3891828', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value mapped to the High Color (blank = the matrix maximum)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4611865">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-reverse.palette" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Reverse Palette</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4611865', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Reverse the direction of the color scheme'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3152418">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_heatmap_legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Legend</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3152418', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the heatmap color legend'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1746759">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-border" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Border</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1746759', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw a border around the heatmap body'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Clustering" id="tab-9213-3">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5315735">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-cluster_rows" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Cluster Rows</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5315735', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform hierarchical clustering on rows'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4936370">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-cluster_columns" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Cluster Columns</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4936370', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform hierarchical clustering on columns'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7793086">
#>             <label class="control-label" id="heatmap-clustering_distance_rows-label" for="heatmap-clustering_distance_rows">Row Distance</label>
#>             <div id="heatmap-clustering_distance_rows" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-clustering_distance_rows">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"],"value":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"]}},"config":{"multiple":false,"search":false,"selectedValue":"euclidean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7793086', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distance metric for row clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2041784">
#>             <label class="control-label" id="heatmap-clustering_distance_columns-label" for="heatmap-clustering_distance_columns">Column Distance</label>
#>             <div id="heatmap-clustering_distance_columns" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-clustering_distance_columns">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"],"value":["euclidean","maximum","manhattan","canberra","binary","minkowski","pearson","spearman","kendall"]}},"config":{"multiple":false,"search":false,"selectedValue":"euclidean","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2041784', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Distance metric for column clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7133973">
#>             <label class="control-label" id="heatmap-clustering_method_rows-label" for="heatmap-clustering_method_rows">Row Method</label>
#>             <div id="heatmap-clustering_method_rows" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-clustering_method_rows">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"],"value":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"]}},"config":{"multiple":false,"search":false,"selectedValue":"complete","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7133973', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Linkage method for row clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify652162">
#>             <label class="control-label" id="heatmap-clustering_method_columns-label" for="heatmap-clustering_method_columns">Column Method</label>
#>             <div id="heatmap-clustering_method_columns" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-clustering_method_columns">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"],"value":["complete","average","single","ward.D","ward.D2","mcquitty","median","centroid"]}},"config":{"multiple":false,"search":false,"selectedValue":"complete","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify652162', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Linkage method for column clustering'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3542068">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_row_dend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Row Dendrogram</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3542068', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the row dendrogram'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8251994">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_column_dend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Column Dendrogram</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8251994', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the column dendrogram'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2738183">
#>             <label class="control-label" id="heatmap-row_split_by-label" for="heatmap-row_split_by">Row Split Method</label>
#>             <div id="heatmap-row_split_by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-row_split_by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","K-means","Hierarchical"],"value":["None","K-means","Hierarchical"]}},"config":{"multiple":false,"search":false,"selectedValue":"None","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2738183', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How to split rows into groups: k-means, or hierarchical (cutting the row dendrogram)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5700449">
#>             <label class="control-label" id="heatmap-row_split_n-label" for="heatmap-row_split_n">Row Groups</label>
#>             <input id="heatmap-row_split_n" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5700449', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of row groups (used when Row Split Method is not &#39;None&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3357191">
#>             <label class="control-label" id="heatmap-column_split_by-label" for="heatmap-column_split_by">Column Split Method</label>
#>             <div id="heatmap-column_split_by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-column_split_by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["None","K-means","Hierarchical"],"value":["None","K-means","Hierarchical"]}},"config":{"multiple":false,"search":false,"selectedValue":"None","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3357191', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'How to split columns into groups: k-means, or hierarchical (cutting the column dendrogram)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5962628">
#>             <label class="control-label" id="heatmap-column_split_n-label" for="heatmap-column_split_n">Column Groups</label>
#>             <input id="heatmap-column_split_n" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="2" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5962628', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of column groups (used when Column Split Method is not &#39;None&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1915181">
#>             <label class="control-label" id="heatmap-row_gap-label" for="heatmap-row_gap">Row Gap (mm)</label>
#>             <input id="heatmap-row_gap" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1915181', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gap between row slices in millimeters (used when Row Split Method is not &#39;None&#39;)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9477639">
#>             <label class="control-label" id="heatmap-column_gap-label" for="heatmap-column_gap">Column Gap (mm)</label>
#>             <input id="heatmap-column_gap" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9477639', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Gap between column slices in millimeters (used when Column Split Method is not &#39;None&#39;)'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Labels" id="tab-9213-4">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5424804">
#>             <label class="control-label" id="heatmap-row_title-label" for="heatmap-row_title">Row Title</label>
#>             <input id="heatmap-row_title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5424804', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title placed alongside the rows'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5446034">
#>             <label class="control-label" id="heatmap-column_title-label" for="heatmap-column_title">Column Title</label>
#>             <input id="heatmap-column_title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5446034', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title placed alongside the columns'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2785972">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_row_names" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Row Names</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2785972', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4467025">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="heatmap-show_column_names" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Column Names</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4467025', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3715112">
#>             <label class="control-label" id="heatmap-row_names_side-label" for="heatmap-row_names_side">Row Names Side</label>
#>             <div id="heatmap-row_names_side" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-row_names_side">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["right","left"],"value":["right","left"]}},"config":{"multiple":false,"search":false,"selectedValue":"right","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3715112', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which side to place row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify280610">
#>             <label class="control-label" id="heatmap-column_names_side-label" for="heatmap-column_names_side">Column Names Side</label>
#>             <div id="heatmap-column_names_side" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="heatmap-column_names_side">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["bottom","top"],"value":["bottom","top"]}},"config":{"multiple":false,"search":false,"selectedValue":"bottom","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify280610', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which side to place column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4659872">
#>             <label class="control-label" id="heatmap-column_names_rot-label" for="heatmap-column_names_rot">Column Name Rotation</label>
#>             <input id="heatmap-column_names_rot" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" step="15"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4659872', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Rotation angle for column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3900314">
#>             <label class="control-label" id="heatmap-row_names_fontsize-label" for="heatmap-row_names_fontsize">Row Name Size</label>
#>             <input id="heatmap-row_names_fontsize" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3900314', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for row names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify200653">
#>             <label class="control-label" id="heatmap-column_names_fontsize-label" for="heatmap-column_names_fontsize">Column Name Size</label>
#>             <input id="heatmap-column_names_fontsize" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify200653', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for column names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3769709">
#>             <label class="control-label" id="heatmap-title_fontsize-label" for="heatmap-title_fontsize">Title Size</label>
#>             <input id="heatmap-title_fontsize" type="number" class="shiny-input-number form-control" value="13.2" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3769709', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size for row and column titles'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-9213-5">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="multi-dynamic-input shiny-input-container form-group " id="heatmap-row_annotations" data-keys="[&quot;column&quot;,&quot;side&quot;]" data-initial="[]" data-input-id="heatmap-row_annotations" data-row-prefix="row annotations">
#>             <div class="mdi-top">
#>               <label class="control-label" for="heatmap-row_annotations">Row Annotations</label>
#>               <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>             </div>
#>             <div class="mdi-rows"></div>
#>             <template class="mdi-row-template">
#>               <div class="mdi-row">
#>                 <div class="mdi-fields">
#>                   <div class="mdi-field" data-key="column" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="heatmap-row_annotations-__ROWIDX__-column-label" for="heatmap-row_annotations-__ROWIDX__-column">Column</label>
#>                       <div>
#>                         <select id="heatmap-row_annotations-__ROWIDX__-column" class="shiny-input-select"><option value="gene" selected>gene</option>
#> <option value="pathway">pathway</option></select>
#>                         <script type="application/json" data-for="heatmap-row_annotations-__ROWIDX__-column" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                   <div class="mdi-field" data-key="side" style="flex: 1 1 calc(50% - 8px); min-width: 120px;">
#>                     <div class="form-group shiny-input-container">
#>                       <label class="control-label" id="heatmap-row_annotations-__ROWIDX__-side-label" for="heatmap-row_annotations-__ROWIDX__-side">Side</label>
#>                       <div>
#>                         <select id="heatmap-row_annotations-__ROWIDX__-side" class="shiny-input-select"><option value="Left" selected>Left</option>
#> <option value="Right">Right</option></select>
#>                         <script type="application/json" data-for="heatmap-row_annotations-__ROWIDX__-side" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>                       </div>
#>                     </div>
#>                   </div>
#>                 </div>
#>                 <button type="button" class="mdi-delete" title="Delete this row" aria-label="Delete this row">&times;</button>
#>               </div>
#>             </template>
#>           </div>
#>           <div id="heatmap-row_annotation_colors_ui" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <span class="help-block">
#>             Supply data as list(matrix = ..., column_annotations = ...) to 
#>             enable column annotations.
#>           </span>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="heatmap-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="heatmap-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="heatmap-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="heatmap-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="heatmap-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="heatmap-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('heatmap-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
