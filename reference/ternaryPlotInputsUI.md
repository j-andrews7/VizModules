# Input UI components for the ternaryPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`ternaryPlotServer()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotServer.md)
and
[`ternaryPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotOutputUI.md)
functions.

## Usage

``` r
ternaryPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
to the `defaults` argument. Provide data with numeric columns for the
three ternary axes (a, b, c). For multiple traces, include a grouping
column. Nearly all parameters for
[`ternaryPlot()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`ternaryPlot()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlot.md)
parameters are not accessible via UI inputs:

- `a.titlefont.family`, `b.titlefont.family`, `c.titlefont.family` -
  Axis title font families (use `defaults` to set)

- `a.titlefont.color`, `b.titlefont.color`, `c.titlefont.color` - Axis
  title font colors (use `defaults` to set)

- `a.tickfont.size`, `b.tickfont.size`, `c.tickfont.size` - Axis tick
  label font sizes (use `defaults` to set)

- `a.tickcolor`, `b.tickcolor`, `c.tickcolor` - Axis tick colors (use
  `defaults` to set)

- `a.ticklen`, `b.ticklen`, `c.ticklen` - Axis tick length (use
  `defaults` to set)

- `legend.x`, `legend.y` - Legend position offsets (use `defaults` to
  set)

- `title.x` - Title horizontal position (use `defaults` to set)

- `palette` - Color palette name; use `colors` via the color picker UI
  instead

## Plot parameters and defaults

The following
[`ternaryPlot()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `a` - Column for a-axis (top vertex) (UI: "A-axis column", default:
  1st numeric column)

- `b` - Column for b-axis (bottom-left vertex) (UI: "B-axis column",
  default: 2nd numeric column)

- `c` - Column for c-axis (bottom-right vertex) (UI: "C-axis column",
  default: 3rd numeric column)

- `group` - Optional grouping column for multiple traces (UI: "Group
  column", default: NULL)

- `sum` - Constant sum for ternary axes (UI: "Sum", default: 100)

- `mode` - Trace mode (UI: "Mode", default: "markers")

- `marker.size` - Marker size (UI: "Marker size", default: 8)

- `marker.symbol` - Marker symbol (UI: "Marker symbol", default:
  "circle")

- `marker.line.width` - Marker border width (UI: "Marker border width",
  default: 0)

- `line.width` - Line width (UI: "Line width", default: 2)

- `line.dash` - Line dash style (UI: "Line style", default: "solid")

- `opacity` - Trace opacity (UI: "Opacity", default: 1)

- `colors` - Trace colors (UI: color picker, derived from palette)

- `a.title` - A-axis title (UI: "A-axis title", default: column name)

- `b.title` - B-axis title (UI: "B-axis title", default: column name)

- `c.title` - C-axis title (UI: "C-axis title", default: column name)

- `a.titlefont.size` - A-axis title font size (UI: "A-axis title size",
  default: 16)

- `b.titlefont.size` - B-axis title font size (UI: "B-axis title size",
  default: 16)

- `c.titlefont.size` - C-axis title font size (UI: "C-axis title size",
  default: 16)

- `a.gridcolor` - A-axis grid color (UI: "A-axis grid color", default:
  "#EEEEEE")

- `b.gridcolor` - B-axis grid color (UI: "B-axis grid color", default:
  "#EEEEEE")

- `c.gridcolor` - C-axis grid color (UI: "C-axis grid color", default:
  "#EEEEEE")

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

- `bgcolor` - Plot background color (UI: "Background color", default:
  "#FFFFFF")

## See also

[`ternaryPlot()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`ternaryPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotOutputUI.md),
[`ternaryPlotServer()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotServer.md),
[`ternaryPlotApp()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotApp.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
df <- data.frame(
    a_val = c(75, 70, 75, 5, 10),
    b_val = c(25, 10, 20, 60, 80),
    c_val = c(0, 20, 5, 35, 10)
)
ternaryPlotInputsUI("ternaryPlot", df)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="ternaryPlot-ternaryPlotTabsetPanel" data-tabsetid="8051">
#>     <li class="active">
#>       <a href="#tab-8051-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8051-2" data-toggle="tab" data-bs-toggle="tab" data-value="Trace Style">Trace Style</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8051-3" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8051-4" data-toggle="tab" data-bs-toggle="tab" data-value="Title &amp; Legend">Title &amp; Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8051-5" data-toggle="tab" data-bs-toggle="tab" data-value="Background">Background</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8051-6" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="8051">
#>     <div class="tab-pane active" data-value="Data" id="tab-8051-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4447896">
#>             <label class="control-label" id="ternaryPlot-a-label" for="ternaryPlot-a">A-axis Column</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-a"><option value=""></option>
#> <option value="a_val" selected>a_val</option>
#> <option value="b_val">b_val</option>
#> <option value="c_val">c_val</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4447896', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the a-axis (top vertex).'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1646753">
#>             <label class="control-label" id="ternaryPlot-b-label" for="ternaryPlot-b">B-axis Column</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-b"><option value=""></option>
#> <option value="a_val">a_val</option>
#> <option value="b_val" selected>b_val</option>
#> <option value="c_val">c_val</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1646753', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the b-axis (bottom-left vertex).'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1182768">
#>             <label class="control-label" id="ternaryPlot-c-label" for="ternaryPlot-c">C-axis Column</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-c"><option value=""></option>
#> <option value="a_val">a_val</option>
#> <option value="b_val">b_val</option>
#> <option value="c_val" selected>c_val</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1182768', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the c-axis (bottom-right vertex).'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3674644">
#>             <label class="control-label" id="ternaryPlot-group-label" for="ternaryPlot-group">Colour By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-group"><option value="" selected></option>
#> <option value="a_val">a_val</option>
#> <option value="b_val">b_val</option>
#> <option value="c_val">c_val</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3674644', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character, name of the column to use for grouping multiple traces. If NULL, a single trace is plotted. Default: NULL.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9465589">
#>             <label class="control-label" id="ternaryPlot-sum-label" for="ternaryPlot-sum">Sum</label>
#>             <input id="ternaryPlot-sum" type="number" class="shiny-input-number form-control" value="100" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9465589', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, the constant sum for the ternary axes (e.g., 100 for percentages, 1 for proportions). All data points should sum to this value. Default: 100.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trace Style" id="tab-8051-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8754107">
#>             <label class="control-label" id="ternaryPlot-mode-label" for="ternaryPlot-mode">Mode</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-mode"><option value="markers" selected>Markers</option>
#> <option value="lines+markers">Lines + Markers</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8754107', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, the trace mode. Options: "markers", "lines", "lines+markers". Default: "markers".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2600589">
#>             <label class="control-label" id="ternaryPlot-marker.size-label" for="ternaryPlot-marker.size">Marker Size</label>
#>             <input id="ternaryPlot-marker.size" type="number" class="shiny-input-number form-control" value="8" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2600589', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, size of the markers on the trace. Default: 8.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6572984">
#>             <label class="control-label" id="ternaryPlot-marker.symbol-label" for="ternaryPlot-marker.symbol">Marker Symbol</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-marker.symbol"><option value="circle" selected>Circle</option>
#> <option value="square">Square</option>
#> <option value="diamond">Diamond</option>
#> <option value="cross">Cross</option>
#> <option value="x">X</option>
#> <option value="triangle-up">Triangle up</option>
#> <option value="triangle-down">Triangle down</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6572984', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, marker symbol. Options: "circle", "square", "diamond", "cross", "x", "triangle-up", etc. Default: "circle".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1218647">
#>             <label class="control-label" id="ternaryPlot-marker.line.width-label" for="ternaryPlot-marker.line.width">Marker Border Width</label>
#>             <input id="ternaryPlot-marker.line.width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1218647', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, width of the marker border line. Default: 0.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3188481">
#>             <label class="control-label" for="ternaryPlot-marker.line.color">Marker Border Color</label>
#>             <input id="ternaryPlot-marker.line.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3188481', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the marker border. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6230610">
#>             <label class="control-label" id="ternaryPlot-line.width-label" for="ternaryPlot-line.width">Line Width</label>
#>             <input id="ternaryPlot-line.width" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6230610', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, width of the trace lines in pixels (only used if mode includes "lines"). Default: 2.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4469974">
#>             <label class="control-label" id="ternaryPlot-line.dash-label" for="ternaryPlot-line.dash">Line Style</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-line.dash"><option value="solid" selected>Solid</option>
#> <option value="dot">Dot</option>
#> <option value="dash">Dash</option>
#> <option value="longdash">Long dash</option>
#> <option value="dashdot">Dash-dot</option>
#> <option value="longdashdot">Long dash-dot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4469974', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, line dash style. Options: "solid", "dot", "dash", "longdash", "dashdot", "longdashdot". Default: "solid".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7082934">
#>             <label class="control-label" id="ternaryPlot-opacity-label" for="ternaryPlot-opacity">Opacity</label>
#>             <input class="js-range-slider" id="ternaryPlot-opacity" data-skin="shiny" data-min="0" data-max="1" data-from="1" data-step="0.05" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7082934', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, opacity of the traces (0-1). Default: 1.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="ternaryPlot-color.picker" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-8051-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8900290">
#>             <label class="control-label" id="ternaryPlot-a.title-label" for="ternaryPlot-a.title">A-axis Title</label>
#>             <input id="ternaryPlot-a.title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8900290', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, title for the a-axis. Default: "a".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1043065">
#>             <label class="control-label" id="ternaryPlot-b.title-label" for="ternaryPlot-b.title">B-axis Title</label>
#>             <input id="ternaryPlot-b.title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1043065', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, title for the b-axis. Default: "b".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6304117">
#>             <label class="control-label" id="ternaryPlot-c.title-label" for="ternaryPlot-c.title">C-axis Title</label>
#>             <input id="ternaryPlot-c.title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6304117', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, title for the c-axis. Default: "c".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8415589">
#>             <label class="control-label" id="ternaryPlot-a.titlefont.size-label" for="ternaryPlot-a.titlefont.size">A-axis Title Size</label>
#>             <input id="ternaryPlot-a.titlefont.size" type="number" class="shiny-input-number form-control" value="16" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8415589', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the a-axis title. Default: 16.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3642624">
#>             <label class="control-label" id="ternaryPlot-b.titlefont.size-label" for="ternaryPlot-b.titlefont.size">B-axis Title Size</label>
#>             <input id="ternaryPlot-b.titlefont.size" type="number" class="shiny-input-number form-control" value="16" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3642624', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the b-axis title. Default: 16.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6229228">
#>             <label class="control-label" id="ternaryPlot-c.titlefont.size-label" for="ternaryPlot-c.titlefont.size">C-axis Title Size</label>
#>             <input id="ternaryPlot-c.titlefont.size" type="number" class="shiny-input-number form-control" value="16" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6229228', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the c-axis title. Default: 16.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4607475">
#>             <label class="control-label" for="ternaryPlot-a.gridcolor">A-axis Grid Color</label>
#>             <input id="ternaryPlot-a.gridcolor" type="text" class="form-control shiny-colour-input" data-init-value="#EEEEEE" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4607475', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the a-axis gridlines. Default: "#EEEEEE".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1634123">
#>             <label class="control-label" for="ternaryPlot-b.gridcolor">B-axis Grid Color</label>
#>             <input id="ternaryPlot-b.gridcolor" type="text" class="form-control shiny-colour-input" data-init-value="#EEEEEE" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1634123', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the b-axis gridlines. Default: "#EEEEEE".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5138669">
#>             <label class="control-label" for="ternaryPlot-c.gridcolor">C-axis Grid Color</label>
#>             <input id="ternaryPlot-c.gridcolor" type="text" class="form-control shiny-colour-input" data-init-value="#EEEEEE" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5138669', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the c-axis gridlines. Default: "#EEEEEE".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Title &amp; Legend" id="tab-8051-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1432665">
#>             <label class="control-label" id="ternaryPlot-title.font.size-label" for="ternaryPlot-title.font.size">Title Size</label>
#>             <input id="ternaryPlot-title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1432665', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the title text. Default: 18.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6502987">
#>             <label class="control-label" id="ternaryPlot-title.font.family-label" for="ternaryPlot-title.font.family">Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-title.font.family"><option value="Arial" selected>Arial</option>
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
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6502987', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the title text. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1552946">
#>             <label class="control-label" for="ternaryPlot-title.font.color">Title Color</label>
#>             <input id="ternaryPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1552946', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the title text. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5083099">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="ternaryPlot-show.legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Legend</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5083099', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to display the legend. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify858705">
#>             <label class="control-label" id="ternaryPlot-legend.orientation-label" for="ternaryPlot-legend.orientation">Legend Orientation</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-legend.orientation"><option value="h" selected>Horizontal</option>
#> <option value="v">Vertical</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify858705', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, legend orientation. Options: "h" (horizontal) or "v" (vertical). Default: "h".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5030267">
#>             <label class="control-label" id="ternaryPlot-legend.font.family-label" for="ternaryPlot-legend.font.family">Legend Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-legend.font.family"><option value="Arial" selected>Arial</option>
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
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5030267', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the legend text. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify385719">
#>             <label class="control-label" id="ternaryPlot-legend.font.size-label" for="ternaryPlot-legend.font.size">Legend Font Size</label>
#>             <input id="ternaryPlot-legend.font.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify385719', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the legend text. Default: 12.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8240328">
#>             <label class="control-label" for="ternaryPlot-legend.font.color">Legend Font Color</label>
#>             <input id="ternaryPlot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8240328', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the legend text. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Background" id="tab-8051-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2859856">
#>             <label class="control-label" for="ternaryPlot-bgcolor">Background Color</label>
#>             <input id="ternaryPlot-bgcolor" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2859856', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the plot background. Default: "#FFFFFF".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-8051-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="ternaryPlot-download.format-label" for="ternaryPlot-download.format">Download Format</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-download.format"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2467509">
#>             <label class="control-label" id="ternaryPlot-margin.t-label" for="ternaryPlot-margin.t">Margin Top</label>
#>             <input id="ternaryPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2467509', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3979936">
#>             <label class="control-label" id="ternaryPlot-margin.b-label" for="ternaryPlot-margin.b">Margin Bottom</label>
#>             <input id="ternaryPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3979936', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6320929">
#>             <label class="control-label" id="ternaryPlot-margin.l-label" for="ternaryPlot-margin.l">Margin Left</label>
#>             <input id="ternaryPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6320929', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9485788">
#>             <label class="control-label" id="ternaryPlot-margin.r-label" for="ternaryPlot-margin.r">Margin Right</label>
#>             <input id="ternaryPlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9485788', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3401193">
#>             <label class="control-label" for="ternaryPlot-shape.fill">Shape Fill</label>
#>             <input id="ternaryPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3401193', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6273660">
#>             <label class="control-label" for="ternaryPlot-shape.line.color">Shape Line Color</label>
#>             <input id="ternaryPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6273660', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8249154">
#>             <label class="control-label" id="ternaryPlot-shape.line.width-label" for="ternaryPlot-shape.line.width">Shape Line Width</label>
#>             <input id="ternaryPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8249154', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1451154">
#>             <label class="control-label" id="ternaryPlot-shape.linetype-label" for="ternaryPlot-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="ternaryPlot-shape.linetype"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1451154', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9671391">
#>             <label class="control-label" id="ternaryPlot-shape.opacity-label" for="ternaryPlot-shape.opacity">Shape Opacity</label>
#>             <input id="ternaryPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9671391', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="ternaryPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="ternaryPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="ternaryPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="ternaryPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="ternaryPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-5" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="ternaryPlot-download.source" tabindex="-1" target="_blank" width="100%">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('ternaryPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
