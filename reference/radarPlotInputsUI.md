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

- `title.font.size` - Title font size (UI: "Title font size", default:
  18)

- `title.font.family` - Title font (UI: "Title font", default: "Arial")

- `title.font.color` - Title font color (UI: "Title font color",
  default: "#000000")

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
#>   <ul class="nav nav-tabs shiny-tab-input" id="radarPlot-radarPlotTabsetPanel" data-tabsetid="5578">
#>     <li class="active">
#>       <a href="#tab-5578-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5578-2" data-toggle="tab" data-bs-toggle="tab" data-value="Trace Style">Trace Style</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5578-3" data-toggle="tab" data-bs-toggle="tab" data-value="Radial Axis">Radial Axis</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5578-4" data-toggle="tab" data-bs-toggle="tab" data-value="Angular Axis">Angular Axis</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5578-5" data-toggle="tab" data-bs-toggle="tab" data-value="Title &amp; Legend">Title &amp; Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5578-6" data-toggle="tab" data-bs-toggle="tab" data-value="Background">Background</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="5578">
#>     <div class="tab-pane active" data-value="Data" id="tab-5578-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2392738">
#>             <label class="control-label" id="radarPlot-theta-label" for="radarPlot-theta">Category column (theta):</label>
#>             <div>
#>               <select id="radarPlot-theta" class="shiny-input-select"><option value=""></option>
#> <option value="category" selected>category</option>
#> <option value="value">value</option></select>
#>               <script type="application/json" data-for="radarPlot-theta">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2392738', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the angular categories (axes).'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4213711">
#>             <label class="control-label" id="radarPlot-r-label" for="radarPlot-r">Values column (r):</label>
#>             <div>
#>               <select id="radarPlot-r" class="shiny-input-select"><option value=""></option>
#> <option value="value" selected>value</option></select>
#>               <script type="application/json" data-for="radarPlot-r">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4213711', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the radial values.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5121368">
#>             <label class="control-label" id="radarPlot-group-label" for="radarPlot-group">Group column (optional):</label>
#>             <div>
#>               <select id="radarPlot-group" class="shiny-input-select"><option value="" selected></option>
#> <option value="category">category</option>
#> <option value="value">value</option></select>
#>               <script type="application/json" data-for="radarPlot-group">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5121368', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character, name of the column to use for grouping multiple traces. If NULL, a single trace is plotted. Default: NULL.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trace Style" id="tab-5578-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1854464">
#>             <label class="control-label" id="radarPlot-fill-label" for="radarPlot-fill">Fill area:</label>
#>             <div>
#>               <select id="radarPlot-fill" class="shiny-input-select"><option value="toself" selected>Fill</option>
#> <option value="none">No fill</option></select>
#>               <script type="application/json" data-for="radarPlot-fill" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1854464', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical or character, whether to fill the area under each trace. Use "toself" to fill to the first point, or FALSE for no fill. Default: "toself".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3264005">
#>             <label class="control-label" id="radarPlot-line.width-label" for="radarPlot-line.width">Line width:</label>
#>             <input id="radarPlot-line.width" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3264005', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, width of the trace lines in pixels. Default: 2.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8170736">
#>             <label class="control-label" id="radarPlot-line.dash-label" for="radarPlot-line.dash">Line style:</label>
#>             <div>
#>               <select id="radarPlot-line.dash" class="shiny-input-select"><option value="solid" selected>Solid</option>
#> <option value="dot">Dot</option>
#> <option value="dash">Dash</option>
#> <option value="longdash">Long dash</option>
#> <option value="dashdot">Dash-dot</option>
#> <option value="longdashdot">Long dash-dot</option></select>
#>               <script type="application/json" data-for="radarPlot-line.dash" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8170736', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, line dash style. Options: "solid", "dot", "dash", "longdash", "dashdot", "longdashdot". Default: "solid".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7487380">
#>             <label class="control-label" id="radarPlot-marker.size-label" for="radarPlot-marker.size">Marker size:</label>
#>             <input id="radarPlot-marker.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7487380', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, size of the markers on the trace. Default: 5.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5317419">
#>             <label class="control-label" id="radarPlot-marker.symbol-label" for="radarPlot-marker.symbol">Marker symbol:</label>
#>             <div>
#>               <select id="radarPlot-marker.symbol" class="shiny-input-select"><option value="circle" selected>Circle</option>
#> <option value="square">Square</option>
#> <option value="diamond">Diamond</option>
#> <option value="cross">Cross</option>
#> <option value="x">X</option>
#> <option value="triangle-up">Triangle up</option>
#> <option value="triangle-down">Triangle down</option></select>
#>               <script type="application/json" data-for="radarPlot-marker.symbol" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5317419', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, marker symbol. Options: "circle", "square", "diamond", "cross", "x", "triangle-up", etc. Default: "circle".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9615713">
#>             <label class="control-label" id="radarPlot-opacity-label" for="radarPlot-opacity">Opacity:</label>
#>             <input class="js-range-slider" id="radarPlot-opacity" data-skin="shiny" data-min="0" data-max="1" data-from="0.6" data-step="0.05" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9615713', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, opacity of the traces (0-1). Default: 0.6.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="radarPlot-color.picker" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Radial Axis" id="tab-5578-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1040464">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="radarPlot-radial.visible" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show radial axis</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1040464', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to show the radial axis. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="radarPlot-auto.radial.range" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Auto radial range</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7371236">
#>             <label class="control-label" id="radarPlot-radial.min-label" for="radarPlot-radial.min">Radial min:</label>
#>             <input id="radarPlot-radial.min" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7371236', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional numeric vector of length 2 specifying the range of the radial axis (e.g., c(0, 100)). If NULL, automatically determined. Default: NULL.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8474799">
#>             <label class="control-label" id="radarPlot-radial.max-label" for="radarPlot-radial.max">Radial max:</label>
#>             <input id="radarPlot-radial.max" type="number" class="shiny-input-number form-control" value="100" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8474799', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional numeric vector of length 2 specifying the range of the radial axis (e.g., c(0, 100)). If NULL, automatically determined. Default: NULL.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6437387">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="radarPlot-radial.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show radial line</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6437387', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to show the radial axis line. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2324572">
#>             <label class="control-label" for="radarPlot-radial.linecolor">Radial line color:</label>
#>             <input id="radarPlot-radial.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="#444444" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2324572', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the radial axis line. Default: "#444444".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9162295">
#>             <label class="control-label" for="radarPlot-radial.gridcolor">Radial grid color:</label>
#>             <input id="radarPlot-radial.gridcolor" type="text" class="form-control shiny-colour-input" data-init-value="#EEEEEE" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9162295', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the radial grid lines. Default: "#EEEEEE".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Angular Axis" id="tab-5578-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4245976">
#>             <label class="control-label" id="radarPlot-angular.direction-label" for="radarPlot-angular.direction">Angular direction:</label>
#>             <div>
#>               <select id="radarPlot-angular.direction" class="shiny-input-select"><option value="clockwise" selected>Clockwise</option>
#> <option value="counterclockwise">Counterclockwise</option></select>
#>               <script type="application/json" data-for="radarPlot-angular.direction" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4245976', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, direction of angular axis. Options: "clockwise" or "counterclockwise". Default: "clockwise".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1929435">
#>             <label class="control-label" id="radarPlot-angular.rotation-label" for="radarPlot-angular.rotation">Angular rotation (degrees):</label>
#>             <input class="js-range-slider" id="radarPlot-angular.rotation" data-skin="shiny" data-min="0" data-max="360" data-from="90" data-step="5" data-grid="true" data-grid-num="9" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1929435', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, rotation angle for the angular axis in degrees. Default: 90.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7015503">
#>             <label class="control-label" for="radarPlot-angular.gridcolor">Angular grid color:</label>
#>             <input id="radarPlot-angular.gridcolor" type="text" class="form-control shiny-colour-input" data-init-value="#EEEEEE" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7015503', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the angular grid lines. Default: "#EEEEEE".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Title &amp; Legend" id="tab-5578-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9925807">
#>             <label class="control-label" id="radarPlot-title.x-label" for="radarPlot-title.x">Title horizontal position:</label>
#>             <input class="js-range-slider" id="radarPlot-title.x" data-skin="shiny" data-min="0" data-max="1" data-from="0.5" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9925807', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, horizontal position for the plot title (0-1). Default: 0.5.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7089125">
#>             <label class="control-label" id="radarPlot-title.font.size-label" for="radarPlot-title.font.size">Title font size:</label>
#>             <input id="radarPlot-title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7089125', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the title text. Default: 18.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5174852">
#>             <label class="control-label" id="radarPlot-title.font.family-label" for="radarPlot-title.font.family">Title font:</label>
#>             <div>
#>               <select id="radarPlot-title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="radarPlot-title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5174852', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the title text. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7087320">
#>             <label class="control-label" for="radarPlot-title.font.color">Title font color:</label>
#>             <input id="radarPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7087320', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the title text. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3751405">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="radarPlot-show.legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show legend</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3751405', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to display the legend. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2547738">
#>             <label class="control-label" id="radarPlot-legend.orientation-label" for="radarPlot-legend.orientation">Legend orientation:</label>
#>             <div>
#>               <select id="radarPlot-legend.orientation" class="shiny-input-select"><option value="h" selected>Horizontal</option>
#> <option value="v">Vertical</option></select>
#>               <script type="application/json" data-for="radarPlot-legend.orientation" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2547738', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, legend orientation. Options: "h" (horizontal) or "v" (vertical). Default: "h".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9964129">
#>             <label class="control-label" id="radarPlot-legend.font.family-label" for="radarPlot-legend.font.family">Legend font:</label>
#>             <div>
#>               <select id="radarPlot-legend.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="radarPlot-legend.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9964129', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the legend text. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5228954">
#>             <label class="control-label" id="radarPlot-legend.font.size-label" for="radarPlot-legend.font.size">Legend font size:</label>
#>             <input id="radarPlot-legend.font.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5228954', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the legend text. Default: 12.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7158094">
#>             <label class="control-label" for="radarPlot-legend.font.color">Legend font color:</label>
#>             <input id="radarPlot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7158094', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the legend text. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Background" id="tab-5578-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify24925">
#>             <label class="control-label" for="radarPlot-bgcolor">Plot background color:</label>
#>             <input id="radarPlot-bgcolor" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify24925', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the plot background. Default: "#FFFFFF".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2929688">
#>             <label class="control-label" for="radarPlot-polar.bgcolor">Polar area background:</label>
#>             <input id="radarPlot-polar.bgcolor" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2929688', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the polar area background. Default: "#FFFFFF".'})}, 500)});</script>
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
#>         <input id="radarPlot-auto.update" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="radarPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="radarPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="radarPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="radarPlot-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="radarPlot-download.format-label" for="radarPlot-download.format">Download Format</label>
#>       <div>
#>         <select id="radarPlot-download.format" class="shiny-input-select"><option value="png">png</option>
#> <option value="svg" selected>svg</option></select>
#>         <script type="application/json" data-for="radarPlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
