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
#>   <ul class="nav nav-tabs shiny-tab-input" id="ternaryPlot-ternaryPlotTabsetPanel" data-tabsetid="1324">
#>     <li class="active">
#>       <a href="#tab-1324-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1324-2" data-toggle="tab" data-bs-toggle="tab" data-value="Trace Style">Trace Style</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1324-3" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1324-4" data-toggle="tab" data-bs-toggle="tab" data-value="Title &amp; Legend">Title &amp; Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-1324-5" data-toggle="tab" data-bs-toggle="tab" data-value="Background">Background</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="1324">
#>     <div class="tab-pane active" data-value="Data" id="tab-1324-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify40820">
#>             <label class="control-label" id="ternaryPlot-a-label" for="ternaryPlot-a">A-axis column:</label>
#>             <div>
#>               <select id="ternaryPlot-a" class="shiny-input-select"><option value=""></option>
#> <option value="a_val" selected>a_val</option>
#> <option value="b_val">b_val</option>
#> <option value="c_val">c_val</option></select>
#>               <script type="application/json" data-for="ternaryPlot-a">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify40820', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the a-axis (top vertex).'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6568564">
#>             <label class="control-label" id="ternaryPlot-b-label" for="ternaryPlot-b">B-axis column:</label>
#>             <div>
#>               <select id="ternaryPlot-b" class="shiny-input-select"><option value=""></option>
#> <option value="a_val">a_val</option>
#> <option value="b_val" selected>b_val</option>
#> <option value="c_val">c_val</option></select>
#>               <script type="application/json" data-for="ternaryPlot-b">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6568564', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the b-axis (bottom-left vertex).'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1509290">
#>             <label class="control-label" id="ternaryPlot-c-label" for="ternaryPlot-c">C-axis column:</label>
#>             <div>
#>               <select id="ternaryPlot-c" class="shiny-input-select"><option value=""></option>
#> <option value="a_val">a_val</option>
#> <option value="b_val">b_val</option>
#> <option value="c_val" selected>c_val</option></select>
#>               <script type="application/json" data-for="ternaryPlot-c">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1509290', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the c-axis (bottom-right vertex).'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1991607">
#>             <label class="control-label" id="ternaryPlot-group-label" for="ternaryPlot-group">Colour By:</label>
#>             <div>
#>               <select id="ternaryPlot-group" class="shiny-input-select"><option value="" selected></option>
#> <option value="a_val">a_val</option>
#> <option value="b_val">b_val</option>
#> <option value="c_val">c_val</option></select>
#>               <script type="application/json" data-for="ternaryPlot-group">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1991607', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character, name of the column to use for grouping multiple traces. If NULL, a single trace is plotted. Default: NULL.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2396384">
#>             <label class="control-label" id="ternaryPlot-sum-label" for="ternaryPlot-sum">Sum:</label>
#>             <input id="ternaryPlot-sum" type="number" class="shiny-input-number form-control" value="100" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2396384', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, the constant sum for the ternary axes (e.g., 100 for percentages, 1 for proportions). All data points should sum to this value. Default: 100.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trace Style" id="tab-1324-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6615740">
#>             <label class="control-label" id="ternaryPlot-mode-label" for="ternaryPlot-mode">Mode:</label>
#>             <div>
#>               <select id="ternaryPlot-mode" class="shiny-input-select"><option value="markers" selected>Markers</option>
#> <option value="lines+markers">Lines + Markers</option></select>
#>               <script type="application/json" data-for="ternaryPlot-mode" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6615740', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, the trace mode. Options: "markers", "lines", "lines+markers". Default: "markers".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2417888">
#>             <label class="control-label" id="ternaryPlot-marker.size-label" for="ternaryPlot-marker.size">Marker size:</label>
#>             <input id="ternaryPlot-marker.size" type="number" class="shiny-input-number form-control" value="8" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2417888', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, size of the markers on the trace. Default: 8.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify715498">
#>             <label class="control-label" id="ternaryPlot-marker.symbol-label" for="ternaryPlot-marker.symbol">Marker symbol:</label>
#>             <div>
#>               <select id="ternaryPlot-marker.symbol" class="shiny-input-select"><option value="circle" selected>Circle</option>
#> <option value="square">Square</option>
#> <option value="diamond">Diamond</option>
#> <option value="cross">Cross</option>
#> <option value="x">X</option>
#> <option value="triangle-up">Triangle up</option>
#> <option value="triangle-down">Triangle down</option></select>
#>               <script type="application/json" data-for="ternaryPlot-marker.symbol" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify715498', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, marker symbol. Options: "circle", "square", "diamond", "cross", "x", "triangle-up", etc. Default: "circle".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7046719">
#>             <label class="control-label" id="ternaryPlot-marker.line.width-label" for="ternaryPlot-marker.line.width">Marker border width:</label>
#>             <input id="ternaryPlot-marker.line.width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7046719', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, width of the marker border line. Default: 0.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3153969">
#>             <label class="control-label" for="ternaryPlot-marker.line.color">Marker border color:</label>
#>             <input id="ternaryPlot-marker.line.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3153969', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the marker border. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3758752">
#>             <label class="control-label" id="ternaryPlot-line.width-label" for="ternaryPlot-line.width">Line width:</label>
#>             <input id="ternaryPlot-line.width" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3758752', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, width of the trace lines in pixels (only used if mode includes "lines"). Default: 2.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8150977">
#>             <label class="control-label" id="ternaryPlot-line.dash-label" for="ternaryPlot-line.dash">Line style:</label>
#>             <div>
#>               <select id="ternaryPlot-line.dash" class="shiny-input-select"><option value="solid" selected>Solid</option>
#> <option value="dot">Dot</option>
#> <option value="dash">Dash</option>
#> <option value="longdash">Long dash</option>
#> <option value="dashdot">Dash-dot</option>
#> <option value="longdashdot">Long dash-dot</option></select>
#>               <script type="application/json" data-for="ternaryPlot-line.dash" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8150977', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, line dash style. Options: "solid", "dot", "dash", "longdash", "dashdot", "longdashdot". Default: "solid".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2005600">
#>             <label class="control-label" id="ternaryPlot-opacity-label" for="ternaryPlot-opacity">Opacity:</label>
#>             <input class="js-range-slider" id="ternaryPlot-opacity" data-skin="shiny" data-min="0" data-max="1" data-from="1" data-step="0.05" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2005600', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, opacity of the traces (0-1). Default: 1.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="ternaryPlot-color.picker" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-1324-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3019302">
#>             <label class="control-label" id="ternaryPlot-a.title-label" for="ternaryPlot-a.title">A-axis title:</label>
#>             <input id="ternaryPlot-a.title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3019302', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, title for the a-axis. Default: "a".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify877203">
#>             <label class="control-label" id="ternaryPlot-b.title-label" for="ternaryPlot-b.title">B-axis title:</label>
#>             <input id="ternaryPlot-b.title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify877203', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, title for the b-axis. Default: "b".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1833202">
#>             <label class="control-label" id="ternaryPlot-c.title-label" for="ternaryPlot-c.title">C-axis title:</label>
#>             <input id="ternaryPlot-c.title" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1833202', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, title for the c-axis. Default: "c".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2068019">
#>             <label class="control-label" id="ternaryPlot-a.titlefont.size-label" for="ternaryPlot-a.titlefont.size">A-axis title size:</label>
#>             <input id="ternaryPlot-a.titlefont.size" type="number" class="shiny-input-number form-control" value="16" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2068019', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the a-axis title. Default: 16.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8549595">
#>             <label class="control-label" id="ternaryPlot-b.titlefont.size-label" for="ternaryPlot-b.titlefont.size">B-axis title size:</label>
#>             <input id="ternaryPlot-b.titlefont.size" type="number" class="shiny-input-number form-control" value="16" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8549595', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the b-axis title. Default: 16.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2629099">
#>             <label class="control-label" id="ternaryPlot-c.titlefont.size-label" for="ternaryPlot-c.titlefont.size">C-axis title size:</label>
#>             <input id="ternaryPlot-c.titlefont.size" type="number" class="shiny-input-number form-control" value="16" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2629099', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the c-axis title. Default: 16.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9453342">
#>             <label class="control-label" for="ternaryPlot-a.gridcolor">A-axis grid color:</label>
#>             <input id="ternaryPlot-a.gridcolor" type="text" class="form-control shiny-colour-input" data-init-value="#EEEEEE" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9453342', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the a-axis gridlines. Default: "#EEEEEE".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7927354">
#>             <label class="control-label" for="ternaryPlot-b.gridcolor">B-axis grid color:</label>
#>             <input id="ternaryPlot-b.gridcolor" type="text" class="form-control shiny-colour-input" data-init-value="#EEEEEE" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7927354', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the b-axis gridlines. Default: "#EEEEEE".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8315819">
#>             <label class="control-label" for="ternaryPlot-c.gridcolor">C-axis grid color:</label>
#>             <input id="ternaryPlot-c.gridcolor" type="text" class="form-control shiny-colour-input" data-init-value="#EEEEEE" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8315819', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the c-axis gridlines. Default: "#EEEEEE".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Title &amp; Legend" id="tab-1324-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6189772">
#>             <label class="control-label" id="ternaryPlot-title.font.size-label" for="ternaryPlot-title.font.size">Title font size:</label>
#>             <input id="ternaryPlot-title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6189772', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the title text. Default: 18.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4437336">
#>             <label class="control-label" id="ternaryPlot-title.font.family-label" for="ternaryPlot-title.font.family">Title font:</label>
#>             <div>
#>               <select id="ternaryPlot-title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="ternaryPlot-title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4437336', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the title text. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9646256">
#>             <label class="control-label" for="ternaryPlot-title.font.color">Title font color:</label>
#>             <input id="ternaryPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9646256', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the title text. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1621987">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="ternaryPlot-show.legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show legend</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1621987', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to display the legend. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1856538">
#>             <label class="control-label" id="ternaryPlot-legend.orientation-label" for="ternaryPlot-legend.orientation">Legend orientation:</label>
#>             <div>
#>               <select id="ternaryPlot-legend.orientation" class="shiny-input-select"><option value="h" selected>Horizontal</option>
#> <option value="v">Vertical</option></select>
#>               <script type="application/json" data-for="ternaryPlot-legend.orientation" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1856538', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, legend orientation. Options: "h" (horizontal) or "v" (vertical). Default: "h".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6131014">
#>             <label class="control-label" id="ternaryPlot-legend.font.family-label" for="ternaryPlot-legend.font.family">Legend font:</label>
#>             <div>
#>               <select id="ternaryPlot-legend.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="ternaryPlot-legend.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6131014', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the legend text. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4814845">
#>             <label class="control-label" id="ternaryPlot-legend.font.size-label" for="ternaryPlot-legend.font.size">Legend font size:</label>
#>             <input id="ternaryPlot-legend.font.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4814845', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the legend text. Default: 12.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3961379">
#>             <label class="control-label" for="ternaryPlot-legend.font.color">Legend font color:</label>
#>             <input id="ternaryPlot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3961379', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the legend text. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Background" id="tab-1324-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3187564">
#>             <label class="control-label" for="ternaryPlot-bgcolor">Background color:</label>
#>             <input id="ternaryPlot-bgcolor" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3187564', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the plot background. Default: "#FFFFFF".'})}, 500)});</script>
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
#>         <input id="ternaryPlot-auto.update" type="checkbox"/>
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
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="ternaryPlot-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="ternaryPlot-download.format-label" for="ternaryPlot-download.format">Download Format</label>
#>       <div>
#>         <select id="ternaryPlot-download.format" class="shiny-input-select"><option value="png">png</option>
#> <option value="svg" selected>svg</option></select>
#>         <script type="application/json" data-for="ternaryPlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
