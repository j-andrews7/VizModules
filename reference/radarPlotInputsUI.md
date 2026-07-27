# Input UI components for the radarPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`radarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/radarPlotServer.md)
and
[`radarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotOutputUI.md)
functions.

## Usage

``` r
radarPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
to the `defaults` argument. Provide data with columns for categories
(theta) and values (r). For multiple traces, include a grouping column.
Nearly all parameters for
[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md)
parameters are not exposed as UI inputs:

- `palette` - Color palette name; use `colors` via the color picker UI
  instead

- `legend.x` - Legend horizontal position offset (use `defaults` to set)

- `legend.y` - Legend vertical position offset (use `defaults` to set)

- `title.text` - Plot title text (plotly allows interactive editing; use
  `defaults` to set)

## Plot parameters and defaults

The following
[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `theta` - Category column for angular axes (UI: "Category column
  (theta)", default: 1st categorical column)

- `r` - Values column for radial distance (UI: "Values column (r)",
  default: 1st numeric column)

- `group` - Optional grouping column for multiple traces (UI: "Group
  column", default: NULL)

- `fill` - Fill area under trace (UI: "Fill area", default: "toself")

- `line.width` - Line width (UI: "Line width", default: 2)

- `line.dash` - Line dash style (UI: "Line style", default: "solid")

- `marker.size` - Marker size (UI: "Marker size", default: 5)

- `marker.symbol` - Marker symbol (UI: "Marker symbol", default:
  "circle")

- `opacity` - Trace opacity (UI: "Opacity", default: 0.6)

- `colors` - Trace colors (UI: color picker, derived from palette)

- `radial.visible` - Show radial axis (UI: "Show radial axis", default:
  TRUE)

- `radial.range` - Radial axis range (UI: "Radial min" and "Radial max",
  default: auto)

- `radial.showline` - Show radial axis line (UI: "Show radial line",
  default: TRUE)

- `radial.linecolor` - Radial axis line color (UI: "Radial line color",
  default: "#444444")

- `radial.gridcolor` - Radial grid color (UI: "Radial grid color",
  default: "#EEEEEE")

- `angular.direction` - Angular axis direction (UI: "Angular direction",
  default: "clockwise")

- `angular.rotation` - Angular axis rotation (UI: "Angular rotation",
  default: 90)

- `angular.gridcolor` - Angular grid color (UI: "Angular grid color",
  default: "#EEEEEE")

- `title.x` - Title horizontal position (UI: "Title horizontal
  position", default: 0.5)

- `title.font.size` - Plot title font size (UI: "Title Size", default:
  26)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `title.font.color` - Color for plot title (UI: "Title Color", default:
  "#000000")

- `show.legend` - Show legend (UI: "Show legend", default: TRUE)

- `legend.orientation` - Legend orientation (UI: "Legend orientation",
  default: "h")

- `legend.font.family` - Legend font (UI: "Legend font", default:
  "Arial")

- `legend.font.size` - Legend font size (UI: "Legend font size",
  default: 12)

- `legend.font.color` - Legend font color (UI: "Legend font color",
  default: "#000000")

- `bgcolor` - Plot background color (UI: "Plot background color",
  default: "#FFFFFF")

- `polar.bgcolor` - Polar area background color (UI: "Polar area
  background", default: "#FFFFFF")

## See also

[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`radarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotOutputUI.md),
[`radarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/radarPlotServer.md),
[`radarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/radarPlotApp.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
skills <- data.frame(
    category = c("Speed", "Strength", "Defense", "Stamina", "Speed"),
    value = c(8, 6, 7, 9, 8)
)
radarPlotInputsUI("radarPlot", skills)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="radarPlot-radarPlotTabsetPanel" data-tabsetid="3221">
#>     <li class="active">
#>       <a href="#tab-3221-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3221-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3221-3" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3221-4" data-toggle="tab" data-bs-toggle="tab" data-value="Title &amp; Legend">Title &amp; Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3221-5" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="3221">
#>     <div class="tab-pane active" data-value="Data" id="tab-3221-1">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3559015">
#>             <label class="control-label" id="radarPlot-theta-label" for="radarPlot-theta">Category (theta)</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-theta"><option value=""></option>
#> <option value="category" selected>category</option>
#> <option value="value">value</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3559015', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the angular categories (axes).'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9643438">
#>             <label class="control-label" id="radarPlot-r-label" for="radarPlot-r">Values (r)</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-r"><option value=""></option>
#> <option value="value" selected>value</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9643438', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the radial values.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1186832">
#>             <label class="control-label" id="radarPlot-group-label" for="radarPlot-group">Group</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-group"><option value="" selected></option>
#> <option value="category">category</option>
#> <option value="value">value</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1186832', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character, name of the column to use for grouping multiple traces. If NULL, a single trace is plotted. Default: NULL.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-3221-2">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4581607">
#>             <label class="control-label" id="radarPlot-fill-label" for="radarPlot-fill">Fill Area</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-fill"><option value="toself" selected>Fill</option>
#> <option value="none">No fill</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4581607', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical or character, whether to fill the area under each trace. Use "toself" to fill to the first point, or FALSE for no fill. Default: "toself".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5236504">
#>             <label class="control-label" id="radarPlot-line.width-label" for="radarPlot-line.width">Line Width</label>
#>             <input id="radarPlot-line.width" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5236504', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, width of the trace lines in pixels. Default: 2.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8370617">
#>             <label class="control-label" id="radarPlot-line.dash-label" for="radarPlot-line.dash">Line Style</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-line.dash"><option value="solid" selected>Solid</option>
#> <option value="dot">Dot</option>
#> <option value="dash">Dash</option>
#> <option value="longdash">Long dash</option>
#> <option value="dashdot">Dash-dot</option>
#> <option value="longdashdot">Long dash-dot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8370617', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, line dash style. Options: "solid", "dot", "dash", "longdash", "dashdot", "longdashdot". Default: "solid".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify335041">
#>             <label class="control-label" id="radarPlot-marker.size-label" for="radarPlot-marker.size">Marker Size</label>
#>             <input id="radarPlot-marker.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify335041', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, size of the markers on the trace. Default: 5.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify433285">
#>             <label class="control-label" id="radarPlot-marker.symbol-label" for="radarPlot-marker.symbol">Marker Symbol</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-marker.symbol"><option value="circle" selected>Circle</option>
#> <option value="square">Square</option>
#> <option value="diamond">Diamond</option>
#> <option value="cross">Cross</option>
#> <option value="x">X</option>
#> <option value="triangle-up">Triangle up</option>
#> <option value="triangle-down">Triangle down</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify433285', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, marker symbol. Options: "circle", "square", "diamond", "cross", "x", "triangle-up", etc. Default: "circle".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7921029">
#>             <label class="control-label" id="radarPlot-opacity-label" for="radarPlot-opacity">Opacity</label>
#>             <input class="js-range-slider" id="radarPlot-opacity" data-skin="shiny" data-min="0" data-max="1" data-from="0.6" data-step="0.05" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7921029', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, opacity of the traces (0-1). Default: 0.6.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div id="radarPlot-color.picker" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2026990">
#>             <label class="control-label" for="radarPlot-bgcolor">Plot Background Color</label>
#>             <input id="radarPlot-bgcolor" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2026990', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the plot background. Default: "#FFFFFF".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify687955">
#>             <label class="control-label" for="radarPlot-polar.bgcolor">Polar Area Background Color</label>
#>             <input id="radarPlot-polar.bgcolor" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify687955', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the polar area background. Default: "#FFFFFF".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-3221-3">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8644410">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="radarPlot-radial.visible" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Radial Axis</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8644410', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to show the radial axis. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="radarPlot-auto.radial.range" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Auto Radial Range</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify770899">
#>             <label class="control-label" id="radarPlot-radial.min-label" for="radarPlot-radial.min">Radial Min</label>
#>             <input id="radarPlot-radial.min" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify770899', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional numeric vector of length 2 specifying the range of the radial axis (e.g., c(0, 100)). If NULL, automatically determined. Default: NULL.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4310034">
#>             <label class="control-label" id="radarPlot-radial.max-label" for="radarPlot-radial.max">Radial Max</label>
#>             <input id="radarPlot-radial.max" type="number" class="shiny-input-number form-control" value="100" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4310034', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional numeric vector of length 2 specifying the range of the radial axis (e.g., c(0, 100)). If NULL, automatically determined. Default: NULL.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9736225">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="radarPlot-radial.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Radial Line</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9736225', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to show the radial axis line. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5709573">
#>             <label class="control-label" for="radarPlot-radial.linecolor">Radial Line Color</label>
#>             <input id="radarPlot-radial.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="#444444" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5709573', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the radial axis line. Default: "#444444".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7544066">
#>             <label class="control-label" for="radarPlot-radial.gridcolor">Radial Grid Color</label>
#>             <input id="radarPlot-radial.gridcolor" type="text" class="form-control shiny-colour-input" data-init-value="#EEEEEE" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7544066', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the radial grid lines. Default: "#EEEEEE".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2424544">
#>             <label class="control-label" id="radarPlot-angular.direction-label" for="radarPlot-angular.direction">Angular Direction</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-angular.direction"><option value="clockwise" selected>Clockwise</option>
#> <option value="counterclockwise">Counterclockwise</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2424544', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, direction of angular axis. Options: "clockwise" or "counterclockwise". Default: "clockwise".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6271579">
#>             <label class="control-label" id="radarPlot-angular.rotation-label" for="radarPlot-angular.rotation">Angular Rotation (degrees)</label>
#>             <input class="js-range-slider" id="radarPlot-angular.rotation" data-skin="shiny" data-min="0" data-max="360" data-from="90" data-step="5" data-grid="true" data-grid-num="9" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6271579', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, rotation angle for the angular axis in degrees. Default: 90.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1684146">
#>             <label class="control-label" for="radarPlot-angular.gridcolor">Angular Grid Color</label>
#>             <input id="radarPlot-angular.gridcolor" type="text" class="form-control shiny-colour-input" data-init-value="#EEEEEE" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1684146', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the angular grid lines. Default: "#EEEEEE".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Title &amp; Legend" id="tab-3221-4">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4447896">
#>             <label class="control-label" id="radarPlot-title.x-label" for="radarPlot-title.x">Title Position</label>
#>             <input class="js-range-slider" id="radarPlot-title.x" data-skin="shiny" data-min="0" data-max="1" data-from="0.5" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4447896', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, horizontal position for the plot title (0-1). Default: 0.5.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1646753">
#>             <label class="control-label" id="radarPlot-title.font.size-label" for="radarPlot-title.font.size">Title Size</label>
#>             <input id="radarPlot-title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1646753', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the title text. Default: 18.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1182768">
#>             <label class="control-label" id="radarPlot-title.font.family-label" for="radarPlot-title.font.family">Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-title.font.family"><option value="Arial" selected>Arial</option>
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
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1182768', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the title text. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3674644">
#>             <label class="control-label" for="radarPlot-title.font.color">Title Color</label>
#>             <input id="radarPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3674644', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the title text. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9465589">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="radarPlot-show.legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Legend</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9465589', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to display the legend. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8754107">
#>             <label class="control-label" id="radarPlot-legend.orientation-label" for="radarPlot-legend.orientation">Legend Orientation</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-legend.orientation"><option value="h" selected>Horizontal</option>
#> <option value="v">Vertical</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8754107', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, legend orientation. Options: "h" (horizontal) or "v" (vertical). Default: "h".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2600589">
#>             <label class="control-label" id="radarPlot-legend.font.family-label" for="radarPlot-legend.font.family">Legend Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-legend.font.family"><option value="Arial" selected>Arial</option>
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
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2600589', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the legend text. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6572984">
#>             <label class="control-label" id="radarPlot-legend.font.size-label" for="radarPlot-legend.font.size">Legend Font Size</label>
#>             <input id="radarPlot-legend.font.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6572984', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the legend text. Default: 12.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1218647">
#>             <label class="control-label" for="radarPlot-legend.font.color">Legend Font Color</label>
#>             <input id="radarPlot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1218647', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the legend text. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-3221-5">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="radarPlot-download.format-label" for="radarPlot-download.format">Download Format</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-download.format"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3188481">
#>             <label class="control-label" id="radarPlot-margin.t-label" for="radarPlot-margin.t">Margin Top</label>
#>             <input id="radarPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3188481', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6230610">
#>             <label class="control-label" id="radarPlot-margin.b-label" for="radarPlot-margin.b">Margin Bottom</label>
#>             <input id="radarPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6230610', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4469974">
#>             <label class="control-label" id="radarPlot-margin.l-label" for="radarPlot-margin.l">Margin Left</label>
#>             <input id="radarPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4469974', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7082934">
#>             <label class="control-label" id="radarPlot-margin.r-label" for="radarPlot-margin.r">Margin Right</label>
#>             <input id="radarPlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7082934', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8900290">
#>             <label class="control-label" for="radarPlot-shape.fill">Shape Fill</label>
#>             <input id="radarPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8900290', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1043065">
#>             <label class="control-label" for="radarPlot-shape.line.color">Shape Line Color</label>
#>             <input id="radarPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1043065', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6304117">
#>             <label class="control-label" id="radarPlot-shape.line.width-label" for="radarPlot-shape.line.width">Shape Line Width</label>
#>             <input id="radarPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6304117', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8415589">
#>             <label class="control-label" id="radarPlot-shape.linetype-label" for="radarPlot-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="radarPlot-shape.linetype"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8415589', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3642624">
#>             <label class="control-label" id="radarPlot-shape.opacity-label" for="radarPlot-shape.opacity">Shape Opacity</label>
#>             <input id="radarPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3642624', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="radarPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="radarPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="radarPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button id="radarPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="radarPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-5" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="radarPlot-download.source" tabindex="-1" target="_blank" width="100%">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('radarPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
