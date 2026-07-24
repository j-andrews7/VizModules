# Input UI components for the parallelCoordinatesPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`parallelCoordinatesPlotServer()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlotServer.md)
and
[`parallelCoordinatesPlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlotOutputUI.md)
functions.

## Usage

``` r
parallelCoordinatesPlotInputsUI(
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
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/dev/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlot.md)
parameters are not exposed as UI inputs:

- `title.text` - Plot title text (plotly allows interactive editing; use
  `defaults` to set)

## Plot parameters and defaults

The following
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `title.font.size` - Plot title font size (UI: "Title Size", default:
  26)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `title.font.color` - Color for plot title (UI: "Title Color", default:
  "#000000")

- `dimensions` - Columns to use as axes (UI: "Select dimensions",
  multiple: TRUE)

- `color.by` - Column to color lines by (UI: "Color by", default: "")

- `color.scale` - Colorscale for lines when `color.by` is numeric (UI:
  "Color Scale", default: "Viridis")

- `palette.selection` - Discrete color palette used when `color.by` is
  categorical (UI: palette picker)

- `line.opacity` - Line opacity (UI: "Line opacity", default: 0.5)

- `line.width` - Line width (UI: "Line width", default: 1)

- `show.colorbar` - Show colorbar (UI: "Show colorbar", default: TRUE)

- `label.font.size` - Dimension label font size (UI: "Label font size",
  default: 12)

- `label.font.color` - Dimension label font color (UI: "Label font
  color", default: "black")

- `label.font.family` - Dimension label font family (UI: "Label font",
  default: "Arial")

- `tick.font.size` - Tick label font size (UI: "Tick font size",
  default: 10)

- `tick.font.color` - Tick label font color (UI: "Tick font color",
  default: "black")

- `tick.font.family` - Tick label font family (UI: "Tick font", default:
  "Arial")

- `bgcolor` - Plot background color (UI: "Background color", default:
  "#FFFFFF")

## See also

[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/dev/reference/organize_inputs.md),
[`parallelCoordinatesPlotOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlotOutputUI.md),
[`parallelCoordinatesPlotServer()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlotServer.md),
[`parallelCoordinatesPlotApp()`](https://j-andrews7.github.io/VizModules/dev/reference/parallelCoordinatesPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
parallelCoordinatesPlotInputsUI("parcoords", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="parcoords-parallelCoordinatesPlotTabsetPanel" data-tabsetid="4754">
#>     <li class="active">
#>       <a href="#tab-4754-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4754-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4754-3" data-toggle="tab" data-bs-toggle="tab" data-value="Labels">Labels</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4754-4" data-toggle="tab" data-bs-toggle="tab" data-value="Title">Title</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4754-5" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="4754">
#>     <div class="tab-pane active" data-value="Data" id="tab-4754-1">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5428372">
#>             <label class="control-label" id="parcoords-dimensions-label" for="parcoords-dimensions">Dimensions</label>
#>             <div>
#>               <select id="parcoords-dimensions" class="shiny-input-select" multiple="multiple"><option value="mpg" selected>mpg</option>
#> <option value="cyl" selected>cyl</option>
#> <option value="disp" selected>disp</option>
#> <option value="hp" selected>hp</option>
#> <option value="drat" selected>drat</option>
#> <option value="wt" selected>wt</option>
#> <option value="qsec" selected>qsec</option>
#> <option value="vs" selected>vs</option>
#> <option value="am" selected>am</option>
#> <option value="gear" selected>gear</option>
#> <option value="carb" selected>carb</option></select>
#>               <script type="application/json" data-for="parcoords-dimensions">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5428372', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character vector of column names to use as dimensions (axes). Must contain at least two columns. Non-numeric columns are mapped to integers.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2392881">
#>             <label class="control-label" id="parcoords-color.by-label" for="parcoords-color.by">Color By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="parcoords-color.by"><option value="" selected></option>
#> <option value="mpg">mpg</option>
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
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2392881', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character, column name to color lines by. Numeric columns use a continuous colorscale (`color.scale`); categorical columns use a discrete palette (`palette.selection`) and are displayed with category names on the colorbar. Default: NULL.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-4754-2">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5088936">
#>             <label class="control-label" id="parcoords-color.scale-label" for="parcoords-color.scale">Color Scale</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="parcoords-color.scale"><option value="Blackbody">Blackbody</option>
#> <option value="Bluered">Bluered</option>
#> <option value="Blues">Blues</option>
#> <option value="Cividis">Cividis</option>
#> <option value="Earth">Earth</option>
#> <option value="Electric">Electric</option>
#> <option value="Greens">Greens</option>
#> <option value="Greys">Greys</option>
#> <option value="Hot">Hot</option>
#> <option value="Jet">Jet</option>
#> <option value="Picnic">Picnic</option>
#> <option value="Portland">Portland</option>
#> <option value="Rainbow">Rainbow</option>
#> <option value="RdBu">RdBu</option>
#> <option value="Reds">Reds</option>
#> <option value="Viridis" selected>Viridis</option>
#> <option value="YlGnBu">YlGnBu</option>
#> <option value="YlOrRd">YlOrRd</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5088936', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, plotly colorscale name for line coloring when `color.by` is numeric. Options include "Viridis", "Cividis", "Inferno", "Magma", "Plasma", "Blues", "Greens", "Reds", "Oranges", "RdBu", "RdYlBu", "Spectral", "Jet", "Hot", "Cool", "Portland". Default: "Viridis".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div id="parcoords-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify4172644">
#>             <label class="control-label" id="parcoords-line.opacity-label" for="parcoords-line.opacity">Line Opacity</label>
#>             <input class="js-range-slider" id="parcoords-line.opacity" data-skin="shiny" data-min="0" data-max="1" data-from="0.5" data-step="0.05" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4172644', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, opacity of lines between 0 and 1. Default: 0.5.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7269488">
#>             <label class="control-label" id="parcoords-line.width-label" for="parcoords-line.width">Line Width</label>
#>             <input id="parcoords-line.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.5" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7269488', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, width of lines in pixels. Default: 1.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6376855">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="parcoords-show.colorbar" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Colorbar</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6376855', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to show the colorbar. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3964100">
#>             <label class="control-label" for="parcoords-bgcolor">Background Color</label>
#>             <input id="parcoords-bgcolor" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3964100', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the plot background. Default: "#FFFFFF".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Labels" id="tab-4754-3">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9594826">
#>             <label class="control-label" id="parcoords-label.font.size-label" for="parcoords-label.font.size">Label Size</label>
#>             <input id="parcoords-label.font.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9594826', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for dimension labels. Default: 12.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2986581">
#>             <label class="control-label" for="parcoords-label.font.color">Label Color</label>
#>             <input id="parcoords-label.font.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2986581', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for dimension labels. Default: "black".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify502012">
#>             <label class="control-label" id="parcoords-label.font.family-label" for="parcoords-label.font.family">Label Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="parcoords-label.font.family"><option value="Arial" selected>Arial</option>
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
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify502012', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for dimension labels. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5761874">
#>             <label class="control-label" id="parcoords-tick.font.size-label" for="parcoords-tick.font.size">Tick Font Size</label>
#>             <input id="parcoords-tick.font.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5761874', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for axis tick labels. Default: 10.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2179058">
#>             <label class="control-label" for="parcoords-tick.font.color">Tick Font Color</label>
#>             <input id="parcoords-tick.font.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2179058', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for axis tick labels. Default: "black".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1258563">
#>             <label class="control-label" id="parcoords-tick.font.family-label" for="parcoords-tick.font.family">Tick Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="parcoords-tick.font.family"><option value="Arial" selected>Arial</option>
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
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1258563', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for axis tick labels. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Title" id="tab-4754-4">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9381526">
#>             <label class="control-label" id="parcoords-title.font.size-label" for="parcoords-title.font.size">Title Size</label>
#>             <input id="parcoords-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9381526', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for plot title. Default: 16.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify8012751">
#>             <label class="control-label" id="parcoords-title.font.family-label" for="parcoords-title.font.family">Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="parcoords-title.font.family"><option value="Arial" selected>Arial</option>
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
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8012751', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for plot title. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7580536">
#>             <label class="control-label" for="parcoords-title.font.color">Title Color</label>
#>             <input id="parcoords-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7580536', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for plot title text. Default: "black".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-4754-5">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="parcoords-download.format-label" for="parcoords-download.format">Download Format</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="parcoords-download.format"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5325652">
#>             <label class="control-label" id="parcoords-margin.t-label" for="parcoords-margin.t">Margin Top</label>
#>             <input id="parcoords-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5325652', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5468048">
#>             <label class="control-label" id="parcoords-margin.b-label" for="parcoords-margin.b">Margin Bottom</label>
#>             <input id="parcoords-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5468048', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify959265">
#>             <label class="control-label" id="parcoords-margin.l-label" for="parcoords-margin.l">Margin Left</label>
#>             <input id="parcoords-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify959265', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3883498">
#>             <label class="control-label" id="parcoords-margin.r-label" for="parcoords-margin.r">Margin Right</label>
#>             <input id="parcoords-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3883498', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1723519">
#>             <label class="control-label" for="parcoords-shape.fill">Shape Fill</label>
#>             <input id="parcoords-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1723519', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6907258">
#>             <label class="control-label" for="parcoords-shape.line.color">Shape Line Color</label>
#>             <input id="parcoords-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6907258', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6752085">
#>             <label class="control-label" id="parcoords-shape.line.width-label" for="parcoords-shape.line.width">Shape Line Width</label>
#>             <input id="parcoords-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6752085', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify9462948">
#>             <label class="control-label" id="parcoords-shape.linetype-label" for="parcoords-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="parcoords-shape.linetype"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9462948', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify1962196">
#>             <label class="control-label" id="parcoords-shape.opacity-label" for="parcoords-shape.opacity">Shape Opacity</label>
#>             <input id="parcoords-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1962196', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="parcoords-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="parcoords-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="parcoords-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button id="parcoords-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="parcoords-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-5" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="parcoords-download.source" tabindex="-1" target="_blank" width="100%">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('parcoords-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
