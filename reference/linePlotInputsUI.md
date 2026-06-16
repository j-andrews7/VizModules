# Input UI components for the linePlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`linePlotServer()`](https://j-andrews7.github.io/VizModules/reference/linePlotServer.md)
and
[`linePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/linePlotOutputUI.md)
functions.

## Usage

``` r
linePlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation.

- defaults:

  A named list of default values for the inputs.

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
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters and defaults

The following
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable(s) (UI: "Select X values", defaults key:
  `x.value`, default: 1st column, multiple: TRUE)

- `y` - Y-axis variable(s) (UI: "Select Y values", defaults key:
  `y.value`, default: 2nd column, multiple: TRUE)

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

- `group.by` - Grouping variable (UI: "Group by", default: 1st
  categorical variable)

- `order.by` - Order by Y values (UI: "Order by Y", default: FALSE)

- `x.adjustment` - X-axis adjustment function (UI: "X Adjustment",
  default: "")

- `y.adjustment` - Y-axis adjustment function (UI: "Y Adjustment",
  default: "")

- `facet.by` - Faceting variable (UI: "Facet by", default: "")

- `facet.scales` - Facet scale behavior (UI: "Facet scales", default:
  "fixed")

- `facet.nrow` - Number of rows in the facet grid (UI: "Rows", default:
  NULL; blank = auto)

- `facet.ncol` - Number of columns in the facet grid (UI: "Columns",
  default: NULL; blank = auto)

- `plot.mode` - Plot type (UI: "Plot type", default: "lines")

- `line.type` - Line type (UI: "Line type", default: "solid")

- `palette.selection` - Color palette (UI: palette picker, derived from
  palette)

- `axis.showline` - Show axis border lines (UI: "Show Axis Borders",
  default: TRUE)

- `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror Axis
  Borders", default: TRUE)

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

- `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI: "X
  Tick Label Angle", default: 0)

- `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI: "Y
  Tick Label Angle", default: 0)

- `axis.ticks` - Position of tick marks (UI: "Tick Position", default:
  "outside")

- `axis.tickcolor` - Color of tick marks (UI: "Tick Mark Color",
  default: "black")

- `axis.ticklen` - Length of tick marks (UI: "Tick Mark Length",
  default: 5)

- `axis.tickwidth` - Width of tick marks (UI: "Tick Mark Width",
  default: 1)

- `facet.title.font.size` - Facet subplot title font size (UI: "Facet
  Subplot Title Size", default: 18)

- `facet.title.font.color` - Facet subplot title font color (UI: "Facet
  Title Color", default: "#000000")

- `facet.title.font.family` - Facet subplot title font family (UI:
  "Facet Title Font", default: "Arial")

- `show.grid.x` - Show X-axis gridlines (UI: "Show X Gridlines",
  default: TRUE)

- `show.grid.y` - Show Y-axis gridlines (UI: "Show Y Gridlines",
  default: TRUE)

- `grid.color` - Gridline color (UI: "Gridline Color", default:
  "#CCCCCC")

- `x.title` - X-axis title (auto-calculated from data)

- `y.title` - Y-axis title (auto-calculated from data)

- `flip.x` - Flip X-axis (UI: "Flip X", default: FALSE)

- `flip.y` - Flip Y-axis (UI: "Flip Y", default: FALSE)

## Parameters controlling additional functionality

The following parameters implementing plotly-specific features are also
available:

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

## See also

[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`linePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/linePlotOutputUI.md),
[`linePlotServer()`](https://j-andrews7.github.io/VizModules/reference/linePlotServer.md),
[`linePlotApp()`](https://j-andrews7.github.io/VizModules/reference/linePlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data(mtcars)
linePlotInputsUI("linePlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="linePlot-linePlotTabsetPanel" data-tabsetid="8814">
#>     <li class="active">
#>       <a href="#tab-8814-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8814-2" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8814-3" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8814-4" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8814-5" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8814-6" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8814-7" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="8814">
#>     <div class="tab-pane active" data-value="Data" id="tab-8814-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1453159">
#>             <label class="control-label" id="linePlot-x.value-label" for="linePlot-x.value">X Values</label>
#>             <div>
#>               <select id="linePlot-x.value" class="shiny-input-select" multiple="multiple"><option value="mpg" selected>mpg</option>
#> <option value="cyl">cyl</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="linePlot-x.value">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1453159', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character vector of column name(s) for the x-axis. Multiple columns create separate traces. . If you want error bars the X input must be a category and the Y input must only be length = 1'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8543839">
#>             <label class="control-label" id="linePlot-y.value-label" for="linePlot-y.value">Y Values</label>
#>             <div>
#>               <select id="linePlot-y.value" class="shiny-input-select" multiple="multiple"><option value="mpg">mpg</option>
#> <option value="cyl" selected>cyl</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="linePlot-y.value">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8543839', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character vector of column name(s) for the y-axis. Multiple columns create separate traces.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2131493">
#>             <label class="control-label" id="linePlot-group.by-label" for="linePlot-group.by">Group By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-group.by"><option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2131493', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character or formula, column name(s) to group lines by color. Can be a formula like `~ column_name`. Ignored if multiple `x` or `y` columns are provided. Default: `NULL`.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2103108">
#>             <div class="material-switch">
#>               <label for="linePlot-error.bar" style="padding-right: 10px;">Error Bars</label>
#>               <input id="linePlot-error.bar" type="checkbox" checked="checked"/>
#>               <label class="switch label-default bg-default" for="linePlot-error.bar"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2103108', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Boolean value to determine if error bars will be on or off on a plot with a categorical X axis and only 1 Y axis variable'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify395207">
#>             <div class="material-switch">
#>               <label for="linePlot-order.by" style="padding-right: 10px;">Order by Y</label>
#>               <input id="linePlot-order.by" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="linePlot-order.by"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify395207', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character vector, column name(s) to order data by before plotting. Default: NULL.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9447748">
#>             <label class="control-label" id="linePlot-x.adjustment-label" for="linePlot-x.adjustment">X Adjustment</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-x.adjustment"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="as.factor">as.factor</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9447748', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character or function, transformation to apply to x values. Options: "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt", or custom function. Default: NULL.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2449280">
#>             <label class="control-label" id="linePlot-y.adjustment-label" for="linePlot-y.adjustment">Y Adjustment</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-y.adjustment"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="as.factor">as.factor</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2449280', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character or function, transformation to apply to y values. Options: "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt", or custom function. Default: NULL.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-8814-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7811225">
#>             <label class="control-label" id="linePlot-facet.by-label" for="linePlot-facet.by">Facet By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-facet.by"><option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7811225', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character, column name to facet plots by. Creates subplots for each unique value. Default: NULL.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2882372">
#>             <label class="control-label" id="linePlot-facet.scales-label" for="linePlot-facet.scales">Facet Scales</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-facet.scales"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2882372', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, controls axis scaling across facets. Options: "fixed" (same for all), "free" (independent), "free_x" (independent x-axis), "free_y" (independent y-axis). Default: "fixed".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8753579">
#>             <label class="control-label" id="linePlot-facet.nrow-label" for="linePlot-facet.nrow">Rows</label>
#>             <input id="linePlot-facet.nrow" type="number" class="shiny-input-number form-control" data-update-on="change" min="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8753579', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of rows in the facet grid. Leave blank to auto-compute; only one of rows/columns needs to be set.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2957501">
#>             <label class="control-label" id="linePlot-facet.ncol-label" for="linePlot-facet.ncol">Columns</label>
#>             <input id="linePlot-facet.ncol" type="number" class="shiny-input-number form-control" data-update-on="change" min="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2957501', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number of columns in the facet grid. Leave blank to auto-compute; only one of rows/columns needs to be set.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9835254">
#>             <label class="control-label" id="linePlot-subplot.margin.x-label" for="linePlot-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="linePlot-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9835254', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5898375">
#>             <label class="control-label" id="linePlot-subplot.margin.y-label" for="linePlot-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="linePlot-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5898375', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-8814-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7591584">
#>             <label class="control-label" id="linePlot-plot.mode-label" for="linePlot-plot.mode">Plot Type</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-plot.mode"><option value="lines" selected>lines</option>
#> <option value="markers">markers</option>
#> <option value="lines+markers">lines+markers</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7591584', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, plotly mode for plot type. Options: "lines", "markers", "lines+markers". Default: "lines".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8360753">
#>             <label class="control-label" id="linePlot-line.type-label" for="linePlot-line.type">Line Type</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-line.type"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8360753', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, line style. Options: "solid", "dot", "dash", "longdash", "dashdot", "longdashdot". Default: "solid".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="linePlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7628194">
#>             <label class="control-label" for="linePlot-error.bar.colour">Error Bar Colour</label>
#>             <input id="linePlot-error.bar.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7628194', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Hex colour input to set the colour of the error bars on a plot with a categorical X axis and only 1 Y axis variable'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4172699">
#>             <label class="control-label" id="linePlot-error.bar.width-label" for="linePlot-error.bar.width">Error Bar Width</label>
#>             <input id="linePlot-error.bar.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4172699', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric input to set the width of the error bars on a plot with a categorical X axis and only 1 Y axis variable'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-8814-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1380749">
#>             <label class="control-label" id="linePlot-legend.title.size-label" for="linePlot-legend.title.size">Legend Title Size</label>
#>             <input id="linePlot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1380749', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify808450">
#>             <label class="control-label" id="linePlot-legend.text.size-label" for="linePlot-legend.text.size">Legend Text Size</label>
#>             <input id="linePlot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify808450', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-8814-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="linePlot-download.format-label" for="linePlot-download.format">Download Format</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-download.format"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6559826">
#>             <label class="control-label" id="linePlot-margin.t-label" for="linePlot-margin.t">Margin Top</label>
#>             <input id="linePlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6559826', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6020038">
#>             <label class="control-label" id="linePlot-margin.b-label" for="linePlot-margin.b">Margin Bottom</label>
#>             <input id="linePlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6020038', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6569958">
#>             <label class="control-label" id="linePlot-margin.l-label" for="linePlot-margin.l">Margin Left</label>
#>             <input id="linePlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6569958', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3293172">
#>             <label class="control-label" id="linePlot-margin.r-label" for="linePlot-margin.r">Margin Right</label>
#>             <input id="linePlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3293172', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9794742">
#>             <label class="control-label" for="linePlot-shape.fill">Shape Fill</label>
#>             <input id="linePlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9794742', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7151861">
#>             <label class="control-label" for="linePlot-shape.line.color">Shape Line Color</label>
#>             <input id="linePlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7151861', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8726303">
#>             <label class="control-label" id="linePlot-shape.line.width-label" for="linePlot-shape.line.width">Shape Line Width</label>
#>             <input id="linePlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8726303', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9832837">
#>             <label class="control-label" id="linePlot-shape.linetype-label" for="linePlot-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-shape.linetype"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9832837', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2185630">
#>             <label class="control-label" id="linePlot-shape.opacity-label" for="linePlot-shape.opacity">Shape Opacity</label>
#>             <input id="linePlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2185630', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-8814-6">
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="linePlot-flip.x" style="padding-right: 10px;">Flip X Axis</label>
#>               <input id="linePlot-flip.x" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="linePlot-flip.x"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="linePlot-flip.y" style="padding-right: 10px;">Flip Y Axis</label>
#>               <input id="linePlot-flip.y" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="linePlot-flip.y"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-title.font.family-label" for="linePlot-title.font.family">Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-title.font.family"><option value="Arial" selected>Arial</option>
#> <option value="Balto">Balto</option>
#> <option value="Courier New">Courier New</option>
#> <option value="Droid Sans">Droid Sans</option>
#> <option value="Droid Serif">Droid Serif</option>
#> <option value="Droid Sans Mono">Droid Sans Mono</option>
#> <option value="Gravitas One">Gravitas One</option>
#> <option value="Old Standard TT">Old Standard TT</option>
#> <option value="Open Sans">Open Sans</option>
#> <option value="Overpass">Overpass</option>
#> <option value="PT Sans Narrow">PT Sans Narrow</option>
#> <option value="Raleway">Raleway</option>
#> <option value="Times New Roman">Times New Roman</option>
#> <option value="Verdana">Verdana</option>
#> <option value="sans-serif">sans-serif</option>
#> <option value="serif">serif</option>
#> <option value="monospace">monospace</option></select>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="linePlot-title.font.color">Title Color</label>
#>             <input id="linePlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-title.font.size-label" for="linePlot-title.font.size">Title Size</label>
#>             <input id="linePlot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.title.horizontal.position-label" for="linePlot-axis.title.horizontal.position">Title position</label>
#>             <input id="linePlot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.title.font.size-label" for="linePlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="linePlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="linePlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="linePlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.title.font.family-label" for="linePlot-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-axis.title.font.family"><option value="Arial" selected>Arial</option>
#> <option value="Balto">Balto</option>
#> <option value="Courier New">Courier New</option>
#> <option value="Droid Sans">Droid Sans</option>
#> <option value="Droid Serif">Droid Serif</option>
#> <option value="Droid Sans Mono">Droid Sans Mono</option>
#> <option value="Gravitas One">Gravitas One</option>
#> <option value="Old Standard TT">Old Standard TT</option>
#> <option value="Open Sans">Open Sans</option>
#> <option value="Overpass">Overpass</option>
#> <option value="PT Sans Narrow">PT Sans Narrow</option>
#> <option value="Raleway">Raleway</option>
#> <option value="Times New Roman">Times New Roman</option>
#> <option value="Verdana">Verdana</option>
#> <option value="sans-serif">sans-serif</option>
#> <option value="serif">serif</option>
#> <option value="monospace">monospace</option></select>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="linePlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="linePlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="linePlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="linePlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="linePlot-grid.color">Gridline Color</label>
#>             <input id="linePlot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="linePlot-axis.linecolor">Axis Line Color</label>
#>             <input id="linePlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.linewidth-label" for="linePlot-axis.linewidth">Axis Line Width</label>
#>             <input id="linePlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.tickfont.size-label" for="linePlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="linePlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="linePlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="linePlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.tickfont.family-label" for="linePlot-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-axis.tickfont.family"><option value="Arial" selected>Arial</option>
#> <option value="Balto">Balto</option>
#> <option value="Courier New">Courier New</option>
#> <option value="Droid Sans">Droid Sans</option>
#> <option value="Droid Serif">Droid Serif</option>
#> <option value="Droid Sans Mono">Droid Sans Mono</option>
#> <option value="Gravitas One">Gravitas One</option>
#> <option value="Old Standard TT">Old Standard TT</option>
#> <option value="Open Sans">Open Sans</option>
#> <option value="Overpass">Overpass</option>
#> <option value="PT Sans Narrow">PT Sans Narrow</option>
#> <option value="Raleway">Raleway</option>
#> <option value="Times New Roman">Times New Roman</option>
#> <option value="Verdana">Verdana</option>
#> <option value="sans-serif">sans-serif</option>
#> <option value="serif">serif</option>
#> <option value="monospace">monospace</option></select>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.tickangle.x-label" for="linePlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="linePlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.tickangle.y-label" for="linePlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="linePlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.ticks-label" for="linePlot-axis.ticks">Tick Position</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-axis.ticks"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="linePlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="linePlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.ticklen-label" for="linePlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="linePlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-axis.tickwidth-label" for="linePlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="linePlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-facet.title.font.size-label" for="linePlot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="linePlot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="linePlot-facet.title.font.color">Facet Title Color</label>
#>             <input id="linePlot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="linePlot-facet.title.font.family-label" for="linePlot-facet.title.font.family">Facet Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="linePlot-facet.title.font.family"><option value="Arial" selected>Arial</option>
#> <option value="Balto">Balto</option>
#> <option value="Courier New">Courier New</option>
#> <option value="Droid Sans">Droid Sans</option>
#> <option value="Droid Serif">Droid Serif</option>
#> <option value="Droid Sans Mono">Droid Sans Mono</option>
#> <option value="Gravitas One">Gravitas One</option>
#> <option value="Old Standard TT">Old Standard TT</option>
#> <option value="Open Sans">Open Sans</option>
#> <option value="Overpass">Overpass</option>
#> <option value="PT Sans Narrow">PT Sans Narrow</option>
#> <option value="Raleway">Raleway</option>
#> <option value="Times New Roman">Times New Roman</option>
#> <option value="Verdana">Verdana</option>
#> <option value="sans-serif">sans-serif</option>
#> <option value="serif">serif</option>
#> <option value="monospace">monospace</option></select>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-8814-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6645300">
#>             <label class="control-label" id="linePlot-hline.intercepts-label" for="linePlot-hline.intercepts">Y-intercepts</label>
#>             <input id="linePlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6645300', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3895640">
#>             <label class="control-label" id="linePlot-hline.colors-label" for="linePlot-hline.colors">Y Colors</label>
#>             <input id="linePlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3895640', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify460637">
#>             <label class="control-label" id="linePlot-hline.widths-label" for="linePlot-hline.widths">Y Widths</label>
#>             <input id="linePlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify460637', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6169145">
#>             <label class="control-label" id="linePlot-hline.linetypes-label" for="linePlot-hline.linetypes">Y Line Types</label>
#>             <input id="linePlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6169145', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5984750">
#>             <label class="control-label" id="linePlot-hline.opacities-label" for="linePlot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="linePlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5984750', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4068536">
#>             <label class="control-label" id="linePlot-vline.intercepts-label" for="linePlot-vline.intercepts">X-intercepts</label>
#>             <input id="linePlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4068536', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8583281">
#>             <label class="control-label" id="linePlot-vline.colors-label" for="linePlot-vline.colors">X Colors</label>
#>             <input id="linePlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8583281', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5176812">
#>             <label class="control-label" id="linePlot-vline.widths-label" for="linePlot-vline.widths">X Widths</label>
#>             <input id="linePlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5176812', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9792934">
#>             <label class="control-label" id="linePlot-vline.linetypes-label" for="linePlot-vline.linetypes">X Line Types</label>
#>             <input id="linePlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9792934', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify170157">
#>             <label class="control-label" id="linePlot-vline.opacities-label" for="linePlot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="linePlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify170157', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6734478">
#>             <label class="control-label" id="linePlot-abline.slopes-label" for="linePlot-abline.slopes">Ab Slopes</label>
#>             <input id="linePlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6734478', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3712699">
#>             <label class="control-label" id="linePlot-abline.intercepts-label" for="linePlot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="linePlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3712699', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9180106">
#>             <label class="control-label" id="linePlot-abline.colors-label" for="linePlot-abline.colors">Ab Colors</label>
#>             <input id="linePlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9180106', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6779781">
#>             <label class="control-label" id="linePlot-abline.widths-label" for="linePlot-abline.widths">Ab Widths</label>
#>             <input id="linePlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6779781', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6651524">
#>             <label class="control-label" id="linePlot-abline.linetypes-label" for="linePlot-abline.linetypes">Ab Line Types</label>
#>             <input id="linePlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6651524', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7560411">
#>             <label class="control-label" id="linePlot-abline.opacities-label" for="linePlot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="linePlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7560411', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="linePlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="linePlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="linePlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="linePlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="linePlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-5" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="linePlot-download.source" tabindex="-1" target="_blank" width="100%">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('linePlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
