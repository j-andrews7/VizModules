# Input UI components for the freqPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoViz_freqPlotServer()`](https://j-andrews7.github.io/VizModules/dev/reference/dittoViz_freqPlotServer.md)
and
[`dittoViz_freqPlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/dittoViz_freqPlotOutputUI.md)
functions.

## Usage

``` r
dittoViz_freqPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation.

- defaults:

  A named list of default values for the inputs. An entry may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html);
  it is resolved with
  [`shiny::isolate()`](https://rdrr.io/pkg/shiny/man/isolate.html) to
  seed the control, and the module then keeps it live (see
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_reactive_defaults.md)).

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The user inputs for this module are separated from the outputs to allow
for more flexible UI design.

The inputs will automatically be organized into a grid layout via the
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/dev/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

Unlike most modules here, this one does not plot columns of the incoming
data. It tabulates how often each level of "Frequency Of" occurs within
each sample and plots *those* per-sample frequencies, one facet per
level. Axis limits, statistics, the point annotations and the source
download therefore all describe the summarised frequency table, not the
input rows.

Because the frequencies are per-sample, "Sample" must nest inside "Group
By": each sample has to carry exactly one group value (and one color
value, when "Color By" is set), or
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
errors. "Group By" and "Color By" are therefore chosen freely and
"Sample" is narrowed to the columns that nest inside them, which makes
an erroring combination unselectable. With no sample column each group
collapses to a single point per facet, which is rarely what is wanted.

## Plot parameters not implemented or with altered functionality

The following
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `main` - Plot title (plotly allows interactive editing)

- `sub` - Plot subtitle (not supported in plotly)

- `theme` - ggplot2 theme (not applicable to plotly)

- `legend.title` - Legend title (managed by plotly interactively)

- `legend.show` - Show legend (always `TRUE`; not directly settable)

- `split.by` - Not a parameter of
  [`freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html); it
  always facets on the frequency variable's levels. Use `vars.use`
  ("Levels To Show") to choose which of those facets are drawn

- `rows.use` - Row subset to plot (use the app's data table filter
  instead)

- `data.out`, `data.only` - Return the summary rather than the plot (the
  module summarises internally; use the Source Download button for the
  table)

- `do.hover` - Always `TRUE`, so the frequency, count and sample are
  readable on hover

- `colors` - Integer index/order into `color.panel` (managed via the
  palette UI)

- `color.panel` - Managed internally via the palette selection UI

- `y.breaks` - Custom continuous-axis breaks (not implemented)

- `x.labels` - Override group labels (not implemented)

- `x.reorder` - Reorder x-axis groups (not implemented)

- `x.labels.rotate` - Rotate group labels (handled by the Axes tab
  tick-angle controls)

- `var.labels.rename` - Rename facet labels (not implemented)

- `var.labels.reorder` - Reorder facet labels (not implemented)

- `add.line` - Use `hline.intercepts` instead for horizontal lines with
  full styling options

- `line.linetype` - Use `hline.linetypes` instead

- `line.color` - Use `hline.colors` instead

- `line.linewidth` - Use `hline.widths` instead

- `line.opacity` - Use `hline.opacities` instead

- `boxplot.width` - Boxplot width (controlled via `boxgap` and
  `boxgroupgap`)

- `boxplot.outlier.size` - Outlier point size (not implemented)

- `boxplot.position.dodge` - Boxplot dodge (controlled via `boxgap`)

- `vlnplot.quantiles` - Violin quantiles (doesn't translate to plotly)

- `jitter.position.dodge` - Jitter position dodge (calculated from
  `boxgap`)

## Plot parameters and defaults

The following
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `var` - Variable whose per-sample frequency is tabulated, one facet
  per level (UI: "Frequency Of", default: 1st low-cardinality
  categorical variable)

- `sample.by` - Sample identifier the frequencies are computed within
  (UI: "Sample", default: "", i.e. one point per group)

- `group.by` - Grouping variable forming the x-axis (UI: "Group By",
  default: 1st categorical variable that is constant within each sample)

- `color.by` - Coloring variable (UI: "Color By", default: "", which
  follows `group.by`)

- `vars.use` - Which levels of `var` get a facet (UI: "Levels To Show",
  default: "", i.e. all)

- `scale` - Plot frequencies as proportions or raw counts (UI: "Scale",
  default: "percent")

- `max.normalize` - Scale each facet to its own maximum (UI: "Max
  Normalize", default: FALSE)

- `plots` - Plot types to show (UI: "Plots", default:
  `c("boxplot", "jitter")`)

- `min` - Y-axis minimum (UI: "Y Axis Min", auto-calculated from the
  frequency table)

- `max` - Y-axis maximum (UI: "Y Axis Max", auto-calculated from the
  frequency table)

- `split.nrow` - Number of facet rows (UI: "Rows", default: NA)

- `split.ncol` - Number of facet columns (UI: "Columns", default: NA)

- `split.adjust` - Facet scale behavior (UI: "Facet Scaling", default:
  "fixed")

- `do.raster` - Rasterize jitter points (UI: "Rasterize Jitter",
  default: FALSE)

- `raster.dpi` - DPI for rasterization (UI: "Raster DPI", default: 600)

- `hover.round.digits` - Hover value rounding (UI: "Hover Round Digits",
  default: 5)

- `jitter.size` - Jitter point size (UI: "Jitter Point Size", default:
  1)

- `jitter.width` - Jitter width (UI: "Jitter Width", default: 0.2)

- `jitter.color` - Jitter border color (UI: "Jitter Border Color",
  default: "#000000")

- `boxplot.show.outliers` - Show boxplot outliers (UI: "Show Outliers",
  default: FALSE)

- `boxplot.color` - Boxplot outline color (UI: "Boxplot Color", default:
  "#000000")

- `boxplot.fill` - Fill boxplot (UI: "Fill Boxplot", default: TRUE)

- `boxplot.lineweight` - Boxplot line weight (UI: "Boxplot Line Weight",
  default: 0.5)

- `vlnplot.lineweight` - Violin line weight (UI: "Violin Line Weight",
  default: 0.5)

- `vlnplot.scaling` - Violin scaling method (UI: "Violin Scaling",
  default: "area")

- `vlnplot.width` - Violin width (derived from `boxgap`; not directly
  settable)

- `ridgeplot.lineweight` - Ridge line weight (UI: "Ridge Line Weight",
  default: 0.5)

- `ridgeplot.scale` - Ridge overlap scale (UI: "Ridge Scale (overlap)",
  default: 1.25)

- `ridgeplot.ymax.expansion` - Ridge Y-max expansion (UI: "Ridge Y-max
  Expansion", default: NA)

- `ridgeplot.shape` - Ridge shape (UI: "Ridge Shape", default: "smooth")

- `ridgeplot.bins` - Ridge bins (UI: "Ridge Bins", default: 30)

- `ridgeplot.binwidth` - Ridge binwidth (UI: "Ridge Binwidth", default:
  NA)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `boxmode` - Boxplot mode grouping (calculated: "group" or "overlay"
  based on `color.by`)

- `boxgap` - Boxplot position dodge (UI: "Boxplot Position Dodge",
  default: 0.3)

- `boxgroupgap` - Boxplot group dodge (UI: "Boxplot Group Dodge",
  default: 0.2)

- `title.font.size` - Plot title font size (UI: "Title Size", default:
  26)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `title.font.color` - Color for plot title (UI: "Title Color", default:
  "#000000")

- `axis.title.font.size` - Axis title font size (UI: "Axis Title Size",
  default: 18)

- `axis.title.font.color` - Axis title font color (UI: "Axis Title
  Color", default: "#000000")

- `axis.title.font.family` - Axis title font family (UI: "Axis Title
  Font", default: "Arial")

- `axis.showline` - Show axis border lines (UI: "Show Axis Lines",
  default: TRUE)

- `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror Axis
  Lines", default: TRUE)

- `show.grid.x` - Show X-axis major gridlines (UI: "Show X Major
  Gridlines", default: TRUE)

- `show.grid.y` - Show Y-axis major gridlines (UI: "Show Y Major
  Gridlines", default: TRUE)

- `axis.linecolor` - Color of axis lines (UI: "Axis Line Color",
  default: "black")

- `axis.linewidth` - Width of axis lines (UI: "Axis Line Width",
  default: 0.5)

- `axis.tickfont.size` - Size of tick labels (UI: "Tick Label Size",
  default: 12)

- `axis.tickfont.color` - Color of tick labels (UI: "Tick Label Color",
  default: "black")

- `axis.tickfont.family` - Font family for tick labels (UI: "Tick Label
  Font", default: "Arial")

- `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI:
  "X-axis Tick Label Angle", default: 0)

- `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI:
  "Y-axis Tick Label Angle", default: 0)

- `axis.ticks` - Position of tick marks (UI: "Tick Position", default:
  "outside")

- `axis.tickcolor` - Color of tick marks (UI: "Tick Mark Color",
  default: "black")

- `axis.ticklen` - Length of tick marks (UI: "Tick Mark Length",
  default: 5)

- `axis.tickwidth` - Width of tick marks (UI: "Tick Mark Width",
  default: 1)

- `hline.intercepts` - Y-coordinates for horizontal reference lines (UI:
  "Y-intercepts", default: "")

- `hline.colors` - Colors for horizontal lines (UI: "Colors", default:
  "#000000")

- `hline.widths` - Widths for horizontal lines (UI: "Widths", default:
  "1")

- `hline.linetypes` - Line types for horizontal lines (UI: "Line Types",
  default: "dashed")

- `hline.opacities` - Opacities for horizontal lines (UI: "Opacities
  (0-1)", default: "1")

- `vline.intercepts` - X-coordinates for vertical reference lines (UI:
  "X-intercepts", default: "")

- `vline.colors` - Colors for vertical lines (UI: "Colors", default:
  "#000000")

- `vline.widths` - Widths for vertical lines (UI: "Widths", default:
  "1")

- `vline.linetypes` - Line types for vertical lines (UI: "Line Types",
  default: "dashed")

- `vline.opacities` - Opacities for vertical lines (UI: "Opacities
  (0-1)", default: "1")

- `abline.slopes` - Slopes for diagonal reference lines (UI: "Slopes",
  default: "")

- `abline.intercepts` - Y-intercepts for diagonal lines (UI:
  "Y-intercepts", default: "")

- `abline.colors` - Colors for diagonal lines (UI: "Colors", default:
  "#000000")

- `abline.widths` - Widths for diagonal lines (UI: "Widths", default:
  "1")

- `abline.linetypes` - Line types for diagonal lines (UI: "Line Types",
  default: "dashed")

- `abline.opacities` - Opacities for diagonal lines (UI: "Opacities
  (0-1)", default: "1")

- `palette.colours` - Named character vector mapping group levels to
  colors, e.g. `c(A = "#FF0000", B = "blue")` (UI: "Plot colors"). Seeds
  the picker; unnamed groups fall back to the default palette and user
  edits take precedence.

- `annotate.by` - Column whose values identify and label jitter points
  (UI: "Annotate By", default: ""). Restricted to the columns carried in
  the plot's hover text, which for this plot are the sample and color
  columns

- `highlight.points` - Values from the `annotate.by` column to highlight
  (UI: "Points to Highlight", default: "")

- `highlight.color` - Fill color for highlighted points (UI: "Highlight
  Fill", default: "#00FFF7")

- `highlight.size` - Size of highlighted points (UI: "Highlight Size",
  default: 7)

- `highlight.border.color` - Border color for highlighted points (UI:
  "Highlight Border Color", default: "#000000")

- `highlight.border.width` - Border width for highlighted points (UI:
  "Highlight Border Width", default: 1)

- `highlight.auto.annotate` - Label highlighted points automatically
  (UI: "Auto-annotate Highlights", default: TRUE)

- `annotation.color` - Annotation text color (UI: "Annotation Color",
  default: "black")

- `annotation.ax` - Horizontal label offset in pixels (UI: "Annotation X
  Offset", default: 20)

- `annotation.ay` - Vertical label offset in pixels (UI: "Annotation Y
  Offset", default: -20)

- `annotation.size` - Annotation font size (UI: "Annotation Size",
  default: 10)

- `annotation.showarrow` - Draw an arrow from label to point (UI: "Show
  Arrow", default: TRUE)

- `annotation.arrowcolor` - Annotation arrow color (UI: "Arrow Color",
  default: "black")

- `annotation.arrowhead` - Annotation arrowhead style (UI: "Arrowhead
  Style", default: 2)

- `annotation.arrowwidth` - Annotation arrow line width (UI: "Arrow
  Linewidth", default: 1.5)

- `stats.enabled` and the other `stat.*` parameters - Pairwise testing
  of the per-sample frequencies between x-axis groups. Tests always run
  within each facet, since frequencies of different levels are not
  comparable quantities; the "Per Facet Panel" control is therefore
  hidden and forced on

## See also

[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/dev/reference/organize_inputs.md),
[`dittoViz_freqPlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/dittoViz_freqPlotOutputUI.md),
[`dittoViz_freqPlotServer()`](https://j-andrews7.github.io/VizModules/dev/reference/dittoViz_freqPlotServer.md),
[`dittoViz_freqPlotApp()`](https://j-andrews7.github.io/VizModules/dev/reference/dittoViz_freqPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
dittoViz_freqPlotInputsUI("freqPlot", example_composition)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="freqPlot-freqPlotTabsetPanel" data-tabsetid="2260">
#>     <li class="active">
#>       <a href="#tab-2260-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-2" data-toggle="tab" data-bs-toggle="tab" data-value="Scale">Scale</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-3" data-toggle="tab" data-bs-toggle="tab" data-value="Jitter">Jitter</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-4" data-toggle="tab" data-bs-toggle="tab" data-value="Box">Box</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-5" data-toggle="tab" data-bs-toggle="tab" data-value="Violin">Violin</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-6" data-toggle="tab" data-bs-toggle="tab" data-value="Ridge">Ridge</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-7" data-toggle="tab" data-bs-toggle="tab" data-value="Stats">Stats</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-8" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-9" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-10" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-11" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-12" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2260-13" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="2260">
#>     <div class="tab-pane active" data-value="Data" id="tab-2260-1">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5599128">
#>             <label class="control-label" id="freqPlot-var-label" for="freqPlot-var">Frequency Of</label>
#>             <div id="freqPlot-var" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-var">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["sample","condition","batch","cell_type"],"value":["sample","condition","batch","cell_type"]}},"config":{"multiple":false,"search":false,"selectedValue":"sample","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5599128', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a column of `data_frame` that contains the discrete data you wish to quantify as frequencies.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8570836">
#>             <label class="control-label" id="freqPlot-sample.by-label" for="freqPlot-sample.by">Sample</label>
#>             <div id="freqPlot-sample.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-sample.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","sample"],"value":["","sample"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8570836', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Frequencies are computed within each sample, giving one point per sample. Only columns nesting inside the grouping are offered. With no sample column each group collapses to a single point.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify3848097">
#>             <label class="control-label" id="freqPlot-group.by-label" for="freqPlot-group.by">Group By</label>
#>             <div id="freqPlot-group.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-group.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["condition","batch","cell_type"],"value":["condition","batch","cell_type"]}},"config":{"multiple":false,"search":false,"selectedValue":"condition","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3848097', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a column of `data_frame` containing discrete data to use for separating the data points into groups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5279170">
#>             <label class="control-label" id="freqPlot-color.by-label" for="freqPlot-color.by">Color By</label>
#>             <div id="freqPlot-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","condition","batch","cell_type"],"value":["","condition","batch","cell_type"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5279170', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Column used for fill color. Leave empty to color by the grouping. Must also be constant within each sample.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify6006375">
#>             <label class="control-label" id="freqPlot-vars.use-label" for="freqPlot-vars.use">Levels To Show</label>
#>             <div id="freqPlot-vars.use" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="freqPlot-vars.use">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["P01","P02","P03","P04","P05","P06","P07","P08","P09","P10","P11","P12"],"value":["P01","P02","P03","P04","P05","P06","P07","P08","P09","P10","P11","P12"]}},"config":{"multiple":true,"search":true,"selectedValue":"","hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6006375', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Which levels of the frequency variable get a facet. Empty shows all of them.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2613714">
#>             <label class="control-label" id="freqPlot-plots-label" for="freqPlot-plots">Plots</label>
#>             <div id="freqPlot-plots" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="freqPlot-plots">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Violin","Box","Jitter","Ridge"],"value":["vlnplot","boxplot","jitter","ridgeplot"]}},"config":{"multiple":true,"search":false,"selectedValue":["boxplot","jitter"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2613714', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector which sets the types of plots to include: possibilities = "jitter", "boxplot", "vlnplot", "ridgeplot".  Order matters: c("vlnplot", "boxplot", "jitter") will put a violin plot in the back, boxplot in the middle, and then individual dots in the front.  See details section for more info.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <span class="help-block">Order not currently respected</span>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div id="freqPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Scale" id="tab-2260-2">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2900502">
#>             <label class="control-label" id="freqPlot-scale-label" for="freqPlot-scale">Scale</label>
#>             <div id="freqPlot-scale" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-scale">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["percent","count"],"value":["percent","count"]}},"config":{"multiple":false,"search":false,"selectedValue":"percent","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2900502', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '"count" or "percent". Sets whether data should be shown as counts versus percentage.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4800752">
#>             <div class="material-switch">
#>               <label for="freqPlot-max.normalize" style="padding-right: 10px;">Max Normalize</label>
#>               <input id="freqPlot-max.normalize" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="freqPlot-max.normalize"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4800752', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical which sets whether the data for each `var`-data value (each facet) should be normalized to have the same maximum value.  When set to `TRUE`, lower frequency `var`-values will make use of just as much plot space as higher frequency vars.  Note: Similarly equal plot space utilization can be achieved by using `split.adjust = list(scales = "free_y")`, and that alternative route retains original values of the data.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9200055">
#>             <label class="control-label" id="freqPlot-y.max-label" for="freqPlot-y.max">Y Axis Max</label>
#>             <input id="freqPlot-y.max" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9200055', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Upper limit of the frequency axis. Recomputed from the frequency table when the summary changes'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4007202">
#>             <label class="control-label" id="freqPlot-y.min-label" for="freqPlot-y.min">Y Axis Min</label>
#>             <input id="freqPlot-y.min" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4007202', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Lower limit of the frequency axis. Recomputed from the frequency table when the summary changes'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Jitter" id="tab-2260-3">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2131727">
#>             <label class="control-label" id="freqPlot-jitter.size-label" for="freqPlot-jitter.size">Jitter Point Size</label>
#>             <input id="freqPlot-jitter.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" max="10"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2131727', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the size of the jitter shapes.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6717668">
#>             <label class="control-label" id="freqPlot-jitter.width-label" for="freqPlot-jitter.width">Jitter Width</label>
#>             <input id="freqPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6717668', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar that sets the width/spread of the jitter in the x direction. Ignored in ridgeplots.  Note for when `color.by` is used to split x-axis groupings into additional bins: ggplot does not shrink jitter widths accordingly, so be sure to do so yourself! Ideally, needs to be 0.5/num_subgroups.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify586142">
#>             <label class="control-label" for="freqPlot-jitter.color">Jitter Border Color</label>
#>             <input id="freqPlot-jitter.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify586142', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String which sets the color of the jitter shapes'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9970691">
#>             <label class="control-label" id="freqPlot-hover.round.digits-label" for="freqPlot-hover.round.digits">Hover Round Digits</label>
#>             <input id="freqPlot-hover.round.digits" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9970691', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer number specifying the number of decimal digits to round displayed numeric values to, when `do.hover` is set to `TRUE`.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1490355">
#>             <div class="material-switch">
#>               <label for="freqPlot-do.raster" style="padding-right: 10px;">Rasterize Jitter</label>
#>               <input id="freqPlot-do.raster" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="freqPlot-do.raster"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1490355', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. When set to `TRUE`, rasterizes the jitter plot layer, changing it from individually encoded points to a flattened set of pixels. This can be useful for editing in external programs (e.g. Illustrator) when there are many thousands of data points.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5185566">
#>             <label class="control-label" id="freqPlot-raster.dpi-label" for="freqPlot-raster.dpi">Raster DPI</label>
#>             <input id="freqPlot-raster.dpi" type="number" class="shiny-input-number form-control" value="600" data-update-on="change" min="100" max="1200"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5185566', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number indicating dots/pixels per inch (dpi) to use for rasterization. Default = 300.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Box" id="tab-2260-4">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8461200">
#>             <div class="material-switch">
#>               <label for="freqPlot-boxplot.show.outliers" style="padding-right: 10px;">Show Outliers</label>
#>               <input id="freqPlot-boxplot.show.outliers" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="freqPlot-boxplot.show.outliers"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8461200', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether outliers should by including in the boxplot. Default is `FALSE` when there is a jitter plotted, `TRUE` if there is no jitter.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7182697">
#>             <label class="control-label" for="freqPlot-boxplot.color">Boxplot Color</label>
#>             <input id="freqPlot-boxplot.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7182697', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String which sets the color of the lines of the boxplot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2413140">
#>             <div class="material-switch">
#>               <label for="freqPlot-boxplot.fill" style="padding-right: 10px;">Fill Boxplot</label>
#>               <input id="freqPlot-boxplot.fill" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="freqPlot-boxplot.fill"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2413140', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether the boxplot should be filled in or not. Known bug: when boxplot fill is turned off, outliers do not render.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5470434">
#>             <label class="control-label" id="freqPlot-boxplot.lineweight-label" for="freqPlot-boxplot.lineweight">Boxplot Line Weight</label>
#>             <input id="freqPlot-boxplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5470434', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which adjusts the thickness of boxplot lines.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8348018">
#>             <label class="control-label" id="freqPlot-boxgap-label" for="freqPlot-boxgap">Boxplot Position Dodge</label>
#>             <input id="freqPlot-boxgap" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8348018', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the gap between boxplots within the same group, controlling how closely boxes are spaced'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify279561">
#>             <label class="control-label" id="freqPlot-boxgroupgap-label" for="freqPlot-boxgroupgap">Boxplot Group Dodge</label>
#>             <input id="freqPlot-boxgroupgap" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify279561', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the gap between groups of boxplots when a color.by variable is used'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Violin" id="tab-2260-5">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4693843">
#>             <label class="control-label" id="freqPlot-vlnplot.lineweight-label" for="freqPlot-vlnplot.lineweight">Violin Line Weight</label>
#>             <input id="freqPlot-vlnplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4693843', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the thickness of the line that outlines the violin plots.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8056800">
#>             <label class="control-label" id="freqPlot-vlnplot.scaling-label" for="freqPlot-vlnplot.scaling">Violin Scaling</label>
#>             <div id="freqPlot-vlnplot.scaling" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-vlnplot.scaling">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["area","count","width"],"value":["area","count","width"]}},"config":{"multiple":false,"search":false,"selectedValue":"area","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8056800', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String which sets how the widths of the of violin plots are set in relation to each other. Options are "area", "count", and "width". If the default is not right for your data, I recommend trying "width". For an explanation of each, see `link[ggplot2]{geom_violin`}.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Ridge" id="tab-2260-6">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8140513">
#>             <label class="control-label" id="freqPlot-ridgeplot.lineweight-label" for="freqPlot-ridgeplot.lineweight">Ridge Line Weight</label>
#>             <input id="freqPlot-ridgeplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8140513', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the thickness of the ridgeplot outline.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4039110">
#>             <label class="control-label" id="freqPlot-ridgeplot.scale-label" for="freqPlot-ridgeplot.scale">Ridge Scale (overlap)</label>
#>             <input id="freqPlot-ridgeplot.scale" type="number" class="shiny-input-number form-control" value="1.25" data-update-on="change" min="0.5" max="3"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4039110', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the distance/overlap between ridgeplots. A value of 1 means the tallest density curve just touches the baseline of the next higher one. Higher numbers lead to greater overlap.  Default = 1.25'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2184310">
#>             <label class="control-label" id="freqPlot-ridgeplot.ymax.expansion-label" for="freqPlot-ridgeplot.ymax.expansion">Ridge Y-max Expansion</label>
#>             <input id="freqPlot-ridgeplot.ymax.expansion" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2184310', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which adjusts the minimal space between the topmost grouping and the top of the plot in order to ensure the curve is not cut off by the plotting grid. The larger the value, the greater the space requested. When left as NA, dittoViz will attempt to determine an ideal value itself based on the number of groups & linear interpolation between these goal posts: #groups of 3 or fewer: 0.6; #groups=12: 0.1; #groups or 34 or greater: 0.05.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4183614">
#>             <label class="control-label" id="freqPlot-ridgeplot.shape-label" for="freqPlot-ridgeplot.shape">Ridge Shape</label>
#>             <div id="freqPlot-ridgeplot.shape" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-ridgeplot.shape">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["smooth","hist"],"value":["smooth","hist"]}},"config":{"multiple":false,"search":false,"selectedValue":"smooth","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4183614', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Either "smooth" or "hist", sets whether ridges will be smoothed (the typical, and default) versus rectangular like a histogram. (Note: as of the time shape "hist" was added, combination of jittered points is not supported by the `link[ggridges]{stat_binline`} that dittoViz relies on.)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6688707">
#>             <label class="control-label" id="freqPlot-ridgeplot.bins-label" for="freqPlot-ridgeplot.bins">Ridge Bins</label>
#>             <input id="freqPlot-ridgeplot.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="5" max="100"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6688707', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer which sets how many chunks to break the x-axis into when `ridgeplot.shape = "hist"`. Overridden by `ridgeplot.binwidth` when that input is provided.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5076503">
#>             <label class="control-label" id="freqPlot-ridgeplot.binwidth-label" for="freqPlot-ridgeplot.binwidth">Ridge Binwidth</label>
#>             <input id="freqPlot-ridgeplot.binwidth" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5076503', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer which sets the width of chunks to break the x-axis into when `ridgeplot.shape = "hist"`. Takes precedence over `ridgeplot.bins` when provided.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Stats" id="tab-2260-7">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6603593">
#>             <div class="material-switch">
#>               <label for="freqPlot-stats.enabled" style="padding-right: 10px;">Enable Stats</label>
#>               <input id="freqPlot-stats.enabled" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="freqPlot-stats.enabled"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6603593', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle pairwise statistical testing with bracket annotations on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify5117913">
#>             <label class="control-label" id="freqPlot-stat.test-label" for="freqPlot-stat.test">Test</label>
#>             <div id="freqPlot-stat.test" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-stat.test">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Wilcoxon","t-test","Kruskal-Wallis","ANOVA"],"value":["wilcox.test","t.test","kruskal.test","anova"]}},"config":{"multiple":false,"search":false,"selectedValue":"wilcox.test","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5117913', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Statistical test for comparisons. Wilcoxon and t-test perform pairwise comparisons. Kruskal-Wallis and ANOVA perform omnibus tests.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8355524">
#>             <label class="control-label" id="freqPlot-stat.p.adjust-label" for="freqPlot-stat.p.adjust">P-value Adjustment</label>
#>             <div id="freqPlot-stat.p.adjust" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-stat.p.adjust">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["holm","hochberg","hommel","bonferroni","BH","BY","fdr","none"],"value":["holm","hochberg","hommel","bonferroni","BH","BY","fdr","none"]}},"config":{"multiple":false,"search":false,"selectedValue":"holm","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8355524', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Method for multiple testing correction applied to all p-values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7087811">
#>             <label class="control-label" id="freqPlot-stat.display-label" for="freqPlot-stat.display">Display</label>
#>             <div id="freqPlot-stat.display" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-stat.display">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Adjusted P-value","P-value","Symbols"],"value":["p.adj","p.value","symbol"]}},"config":{"multiple":false,"search":false,"selectedValue":"p.adj","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7087811', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'What to display on brackets: adjusted p-values, raw p-values, or significance symbols (*, **, ***, ****)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8742059">
#>             <label class="control-label" id="freqPlot-stat.sig.threshold-label" for="freqPlot-stat.sig.threshold">Significance Threshold</label>
#>             <input id="freqPlot-stat.sig.threshold" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8742059', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '(Adjusted, if applied) P-values above this threshold are labeled &#39;ns&#39;. Also used as the boundary for the &#39;*&#39; significance symbol.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify114796">
#>             <div class="material-switch">
#>               <label for="freqPlot-stat.hide.ns" style="padding-right: 10px;">Hide Non-Significant</label>
#>               <input id="freqPlot-stat.hide.ns" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="freqPlot-stat.hide.ns"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify114796', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Hide comparison brackets where the adjusted p-value exceeds the significance threshold'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8882495">
#>             <div class="material-switch">
#>               <label for="freqPlot-stat.paired" style="padding-right: 10px;">Paired Test</label>
#>               <input id="freqPlot-stat.paired" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="freqPlot-stat.paired"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8882495', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform paired tests (Wilcoxon signed-rank or paired t-test). Each group must have the same number of observations in corresponding order. Data should be sorted so that paired samples align row-by-row within each group.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify9963469">
#>             <label class="control-label" id="freqPlot-stat.pairs-label" for="freqPlot-stat.pairs">Comparisons</label>
#>             <div id="freqPlot-stat.pairs" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="freqPlot-stat.pairs">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":[],"value":[]}},"config":{"multiple":true,"search":false,"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9963469', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select specific pairwise comparisons to display. If empty, all possible pairs are tested.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5001915">
#>             <label class="control-label" for="freqPlot-stat.line.color">Line Color</label>
#>             <input id="freqPlot-stat.line.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5001915', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for bracket lines and annotation text'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3589670">
#>             <label class="control-label" id="freqPlot-stat.line.width-label" for="freqPlot-stat.line.width">Line Width</label>
#>             <input id="freqPlot-stat.line.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="1" max="50" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3589670', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of bracket lines in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7749130">
#>             <label class="control-label" id="freqPlot-stat.bracket.style-label" for="freqPlot-stat.bracket.style">Bracket Style</label>
#>             <div id="freqPlot-stat.bracket.style" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-stat.bracket.style">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Capped","Flat"],"value":["capped","flat"]}},"config":{"multiple":false,"search":false,"selectedValue":"capped","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7749130', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Capped brackets have vertical ticks at each end; flat brackets are a single horizontal line'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5844752">
#>             <label class="control-label" id="freqPlot-stat.step.increase-label" for="freqPlot-stat.step.increase">Bracket Spacing</label>
#>             <input id="freqPlot-stat.step.increase" type="number" class="shiny-input-number form-control" value="0.06" data-update-on="change" min="0.01" max="0.3" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5844752', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the y-axis range used as vertical spacing between successive bracket levels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6339764">
#>             <label class="control-label" id="freqPlot-stat.text.bump-label" for="freqPlot-stat.text.bump">Text Offset</label>
#>             <input id="freqPlot-stat.text.bump" type="number" class="shiny-input-number form-control" value="0.04" data-update-on="change" min="0.005" max="0.2" step="0.005"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6339764', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the y-axis range for vertical distance between the bracket line and annotation text'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8586661">
#>             <label class="control-label" id="freqPlot-stat.bracket.inset-label" for="freqPlot-stat.bracket.inset">Bracket Inset</label>
#>             <input id="freqPlot-stat.bracket.inset" type="number" class="shiny-input-number form-control" value="0.025" data-update-on="change" min="0" max="0.2" step="0.005"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8586661', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fixed amount to inset bracket endpoints from group centers, preventing overlap of adjacent brackets'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5668943">
#>             <div class="material-switch">
#>               <label for="freqPlot-stat.per.facet" style="padding-right: 10px;">Per Facet Panel</label>
#>               <input id="freqPlot-stat.per.facet" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="freqPlot-stat.per.facet"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5668943', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, statistical tests run independently within each facet panel. When disabled, tests run on the full dataset.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-2260-8">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <span class="help-block">Faceted on the frequency variable; use "Levels To Show" to pick facets.</span>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2529970">
#>             <label class="control-label" id="freqPlot-split.adjust-label" for="freqPlot-split.adjust">Facet Scaling</label>
#>             <div id="freqPlot-split.adjust" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-split.adjust">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["fixed","free","free_y","free_x"],"value":["fixed","free","free_y","free_x"]}},"config":{"multiple":false,"search":false,"selectedValue":"fixed","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2529970', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A named list which allows extra parameters to be pushed through to the faceting function call. List elements should be valid inputs to the faceting function `link[ggplot2]{facet_wrap`}, e.g. `list(scales = "free_y")`.  See `link[ggplot2]{facet_wrap`} for options.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9188032">
#>             <label class="control-label" id="freqPlot-split.ncol-label" for="freqPlot-split.ncol">Columns</label>
#>             <input id="freqPlot-split.ncol" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9188032', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of the facet grid.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8673502">
#>             <label class="control-label" id="freqPlot-split.nrow-label" for="freqPlot-split.nrow">Rows</label>
#>             <input id="freqPlot-split.nrow" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8673502', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of the facet grid.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2485387">
#>             <label class="control-label" id="freqPlot-subplot.margin.x-label" for="freqPlot-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="freqPlot-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2485387', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4028812">
#>             <label class="control-label" id="freqPlot-subplot.margin.y-label" for="freqPlot-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="freqPlot-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4028812', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-2260-9">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify7696301">
#>             <label class="control-label" id="freqPlot-annotate.by-label" for="freqPlot-annotate.by">Annotate By</label>
#>             <div id="freqPlot-annotate.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-annotate.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","cell_id","sample","condition","batch","cell_type","n_genes","percent_mito"],"value":["","cell_id","sample","condition","batch","cell_type","n_genes","percent_mito"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7696301', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select a column whose values will be used to identify points for highlighting and annotation. Points are samples. Only the sample and color columns are carried in the hover text, so only those can be annotated; include &#39;jitter&#39; in Plots and leave &#39;Rasterize Jitter&#39; off'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="shiny-input-textarea form-group shiny-input-container" id="tipify1194854">
#>             <label class="control-label" id="freqPlot-highlight.points-label" for="freqPlot-highlight.points">Points to Highlight</label>
#>             <textarea id="freqPlot-highlight.points" class="form-control" placeholder="Values from &#39;Annotate by&#39; column&#10;(comma, space, or newline delimited)" rows="3" data-update-on="change"></textarea>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1194854', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enter specific values from the &#39;Annotate By&#39; column to highlight those points on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1946950">
#>             <label class="control-label" for="freqPlot-highlight.color">Highlight Fill</label>
#>             <input id="freqPlot-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#00FFF7" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1946950', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the fill color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1645693">
#>             <label class="control-label" id="freqPlot-highlight.size-label" for="freqPlot-highlight.size">Highlight Size</label>
#>             <input id="freqPlot-highlight.size" type="number" class="shiny-input-number form-control" value="7" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1645693', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the size of highlighted points on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6632066">
#>             <label class="control-label" for="freqPlot-highlight.border.color">Highlight Border Color</label>
#>             <input id="freqPlot-highlight.border.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6632066', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the border color for highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8565750">
#>             <label class="control-label" id="freqPlot-highlight.border.width-label" for="freqPlot-highlight.border.width">Highlight Border Width</label>
#>             <input id="freqPlot-highlight.border.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8565750', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the width of the border around highlighted points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9265464">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="freqPlot-highlight.auto.annotate" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Auto-annotate Highlights</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9265464', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, automatically adds text labels to highlighted points using their &#39;Annotate By&#39; values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5523776">
#>             <label class="control-label" for="freqPlot-annotation.color">Annotation Color</label>
#>             <input id="freqPlot-annotation.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5523776', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the text color for annotation labels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5770657">
#>             <label class="control-label" id="freqPlot-annotation.ax-label" for="freqPlot-annotation.ax">Annotation X Offset</label>
#>             <input id="freqPlot-annotation.ax" type="number" class="shiny-input-number form-control" value="20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5770657', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal pixel offset of annotation labels from their target points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6874477">
#>             <label class="control-label" id="freqPlot-annotation.ay-label" for="freqPlot-annotation.ay">Annotation Y Offset</label>
#>             <input id="freqPlot-annotation.ay" type="number" class="shiny-input-number form-control" value="-20" data-update-on="change" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6874477', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical pixel offset of annotation labels from their target points (negative values move up)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2447183">
#>             <label class="control-label" id="freqPlot-annotation.size-label" for="freqPlot-annotation.size">Annotation Size</label>
#>             <input id="freqPlot-annotation.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2447183', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the font size of annotation text labels in points'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify446172">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="freqPlot-annotation.showarrow" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Arrow</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify446172', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle whether an arrow is drawn from the annotation label to the target point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9098545">
#>             <label class="control-label" for="freqPlot-annotation.arrowcolor">Arrow Color</label>
#>             <input id="freqPlot-annotation.arrowcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9098545', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the color of the annotation arrow connecting the label to the point'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify706813">
#>             <label class="control-label" id="freqPlot-annotation.arrowhead-label" for="freqPlot-annotation.arrowhead">Arrowhead Style</label>
#>             <input id="freqPlot-annotation.arrowhead" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="7" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify706813', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the arrowhead style (0-7) for annotation arrows, where 0 is no arrowhead'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9968914">
#>             <label class="control-label" id="freqPlot-annotation.arrowwidth-label" for="freqPlot-annotation.arrowwidth">Arrow Linewidth</label>
#>             <input id="freqPlot-annotation.arrowwidth" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0.1" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9968914', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the line width of the annotation arrow'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <button id="freqPlot-annotation.clear" type="button" class="btn btn-default action-button"><span class="action-label">Clear Annotations</span></button>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('freqPlot-annotation.clear', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Remove all annotation labels and arrows from the current plot'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-2260-10">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6118524">
#>             <label class="control-label" id="freqPlot-legend.title.size-label" for="freqPlot-legend.title.size">Legend Title Size</label>
#>             <input id="freqPlot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6118524', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1725589">
#>             <label class="control-label" id="freqPlot-legend.text.size-label" for="freqPlot-legend.text.size">Legend Text Size</label>
#>             <input id="freqPlot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1725589', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-2260-11">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="freqPlot-download.format-label" for="freqPlot-download.format">Download Format</label>
#>             <div id="freqPlot-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9094409">
#>             <label class="control-label" id="freqPlot-margin.t-label" for="freqPlot-margin.t">Margin Top</label>
#>             <input id="freqPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9094409', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify374512">
#>             <label class="control-label" id="freqPlot-margin.b-label" for="freqPlot-margin.b">Margin Bottom</label>
#>             <input id="freqPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify374512', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5935538">
#>             <label class="control-label" id="freqPlot-margin.l-label" for="freqPlot-margin.l">Margin Left</label>
#>             <input id="freqPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5935538', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2369776">
#>             <label class="control-label" id="freqPlot-margin.r-label" for="freqPlot-margin.r">Margin Right</label>
#>             <input id="freqPlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2369776', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9062972">
#>             <label class="control-label" for="freqPlot-shape.fill">Shape Fill</label>
#>             <input id="freqPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9062972', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8188730">
#>             <label class="control-label" for="freqPlot-shape.line.color">Shape Line Color</label>
#>             <input id="freqPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8188730', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6998293">
#>             <label class="control-label" id="freqPlot-shape.line.width-label" for="freqPlot-shape.line.width">Shape Line Width</label>
#>             <input id="freqPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6998293', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2200004">
#>             <label class="control-label" id="freqPlot-shape.linetype-label" for="freqPlot-shape.linetype">Shape Linetype</label>
#>             <div id="freqPlot-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2200004', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7279909">
#>             <label class="control-label" id="freqPlot-shape.opacity-label" for="freqPlot-shape.opacity">Shape Opacity</label>
#>             <input id="freqPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7279909', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-2260-12">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="freqPlot-title.font.family-label" for="freqPlot-title.font.family">Title Font</label>
#>             <div id="freqPlot-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="freqPlot-title.font.color">Title Color</label>
#>             <input id="freqPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="freqPlot-title.font.size-label" for="freqPlot-title.font.size">Title Size</label>
#>             <input id="freqPlot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="freqPlot-axis.title.horizontal.position-label" for="freqPlot-axis.title.horizontal.position">Title position</label>
#>             <input id="freqPlot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="freqPlot-axis.title.font.size-label" for="freqPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="freqPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="freqPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="freqPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="freqPlot-axis.title.font.family-label" for="freqPlot-axis.title.font.family">Axis Title Font</label>
#>             <div id="freqPlot-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="freqPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="freqPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="freqPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="freqPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="freqPlot-grid.color">Gridline Color</label>
#>             <input id="freqPlot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="freqPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="freqPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="freqPlot-axis.linewidth-label" for="freqPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="freqPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="freqPlot-axis.tickfont.size-label" for="freqPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="freqPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="freqPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="freqPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="freqPlot-axis.tickfont.family-label" for="freqPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div id="freqPlot-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="freqPlot-axis.tickangle.x-label" for="freqPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="freqPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="freqPlot-axis.tickangle.y-label" for="freqPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="freqPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="freqPlot-axis.ticks-label" for="freqPlot-axis.ticks">Tick Position</label>
#>             <div id="freqPlot-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="freqPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="freqPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="freqPlot-axis.ticklen-label" for="freqPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="freqPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="freqPlot-axis.tickwidth-label" for="freqPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="freqPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="freqPlot-facet.title.font.size-label" for="freqPlot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="freqPlot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="freqPlot-facet.title.font.color">Facet Title Color</label>
#>             <input id="freqPlot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="freqPlot-facet.title.font.family-label" for="freqPlot-facet.title.font.family">Facet Title Font</label>
#>             <div id="freqPlot-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="freqPlot-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-2260-13">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2170845">
#>             <label class="control-label" id="freqPlot-hline.intercepts-label" for="freqPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="freqPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2170845', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4562302">
#>             <label class="control-label" id="freqPlot-hline.colors-label" for="freqPlot-hline.colors">Y Colors</label>
#>             <input id="freqPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4562302', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3327998">
#>             <label class="control-label" id="freqPlot-hline.widths-label" for="freqPlot-hline.widths">Y Widths</label>
#>             <input id="freqPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3327998', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5683527">
#>             <label class="control-label" id="freqPlot-hline.linetypes-label" for="freqPlot-hline.linetypes">Y Line Types</label>
#>             <input id="freqPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5683527', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2522057">
#>             <label class="control-label" id="freqPlot-hline.opacities-label" for="freqPlot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="freqPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2522057', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4640136">
#>             <label class="control-label" id="freqPlot-vline.intercepts-label" for="freqPlot-vline.intercepts">X-intercepts</label>
#>             <input id="freqPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4640136', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9176605">
#>             <label class="control-label" id="freqPlot-vline.colors-label" for="freqPlot-vline.colors">X Colors</label>
#>             <input id="freqPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9176605', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9728442">
#>             <label class="control-label" id="freqPlot-vline.widths-label" for="freqPlot-vline.widths">X Widths</label>
#>             <input id="freqPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9728442', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8190824">
#>             <label class="control-label" id="freqPlot-vline.linetypes-label" for="freqPlot-vline.linetypes">X Line Types</label>
#>             <input id="freqPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8190824', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9029238">
#>             <label class="control-label" id="freqPlot-vline.opacities-label" for="freqPlot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="freqPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9029238', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5813660">
#>             <label class="control-label" id="freqPlot-abline.slopes-label" for="freqPlot-abline.slopes">Ab Slopes</label>
#>             <input id="freqPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5813660', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7730085">
#>             <label class="control-label" id="freqPlot-abline.intercepts-label" for="freqPlot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="freqPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7730085', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9951230">
#>             <label class="control-label" id="freqPlot-abline.colors-label" for="freqPlot-abline.colors">Ab Colors</label>
#>             <input id="freqPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9951230', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7109712">
#>             <label class="control-label" id="freqPlot-abline.widths-label" for="freqPlot-abline.widths">Ab Widths</label>
#>             <input id="freqPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7109712', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2149426">
#>             <label class="control-label" id="freqPlot-abline.linetypes-label" for="freqPlot-abline.linetypes">Ab Line Types</label>
#>             <input id="freqPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2149426', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2917577">
#>             <label class="control-label" id="freqPlot-abline.opacities-label" for="freqPlot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="freqPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2917577', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="freqPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="freqPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="freqPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="freqPlot-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="freqPlot-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="freqPlot-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('freqPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
