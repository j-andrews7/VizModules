# Input UI components for the parallelCoordinatesPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`parallelCoordinatesPlotServer()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotServer.md)
and
[`parallelCoordinatesPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotOutputUI.md)
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

A Shiny tagList containing the UI elements

## Details

The user inputs for this module are separated from the outputs to allow
for more flexible UI design.

The inputs will automatically be organized into a grid layout via the
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md)
parameters are not exposed as UI inputs:

- `title.text` - Plot title text (plotly allows interactive editing; use
  `defaults` to set)

## Plot parameters and defaults

The following
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md)
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

- `palette.colours` - Named character vector mapping group levels to
  colors, e.g. `c(A = "#FF0000", B = "blue")` (UI: "Plot colors"). Seeds
  the picker; unnamed groups fall back to the default palette and user
  edits take precedence.

## See also

[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`parallelCoordinatesPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotOutputUI.md),
[`parallelCoordinatesPlotServer()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotServer.md),
[`parallelCoordinatesPlotApp()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
parallelCoordinatesPlotInputsUI("parcoords", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="parcoords-parallelCoordinatesPlotTabsetPanel" data-tabsetid="2075">
#>     <li class="active">
#>       <a href="#tab-2075-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2075-2" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2075-3" data-toggle="tab" data-bs-toggle="tab" data-value="Labels">Labels</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2075-4" data-toggle="tab" data-bs-toggle="tab" data-value="Title">Title</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2075-5" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="2075">
#>     <div class="tab-pane active" data-value="Data" id="tab-2075-1">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify732092">
#>             <label class="control-label" id="parcoords-dimensions-label" for="parcoords-dimensions">Dimensions</label>
#>             <div id="parcoords-dimensions" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="close">
#>               <script type="application/json" data-for="parcoords-dimensions">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["mpg","cyl","disp","hp","drat","wt","qsec","vs","am","gear","carb"],"value":["mpg","cyl","disp","hp","drat","wt","qsec","vs","am","gear","carb"]}},"config":{"multiple":true,"search":true,"selectedValue":["mpg","cyl","disp","hp","drat","wt","qsec","vs","am","gear","carb"],"hideClearButton":false,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":true,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":false,"disableOptionGroupCheckbox":false,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify732092', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character vector of column names to use as dimensions (axes). Must contain at least two columns. Non-numeric columns are mapped to integers.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8847428">
#>             <label class="control-label" id="parcoords-color.by-label" for="parcoords-color.by">Color By</label>
#>             <div id="parcoords-color.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="parcoords-color.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","mpg","cyl","disp","hp","drat","wt","qsec","vs","am","gear","carb"],"value":["","mpg","cyl","disp","hp","drat","wt","qsec","vs","am","gear","carb"]}},"config":{"multiple":false,"search":true,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8847428', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character, column name to color lines by. Numeric columns use a continuous colorscale (`color.scale`); categorical columns use a discrete palette (`palette.selection`) and are displayed with category names on the colorbar. Default: NULL.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-2075-2">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8267003">
#>             <label class="control-label" id="parcoords-color.scale-label" for="parcoords-color.scale">Color Scale</label>
#>             <div id="parcoords-color.scale" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="parcoords-color.scale">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Blackbody","Bluered","Blues","Cividis","Earth","Electric","Greens","Greys","Hot","Jet","Picnic","Portland","Rainbow","RdBu","Reds","Viridis","YlGnBu","YlOrRd"],"value":["Blackbody","Bluered","Blues","Cividis","Earth","Electric","Greens","Greys","Hot","Jet","Picnic","Portland","Rainbow","RdBu","Reds","Viridis","YlGnBu","YlOrRd"]}},"config":{"multiple":false,"search":true,"selectedValue":"Viridis","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8267003', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, plotly colorscale name for line coloring when `color.by` is numeric. Options include "Viridis", "Cividis", "Inferno", "Magma", "Plasma", "Blues", "Greens", "Reds", "Oranges", "RdBu", "RdYlBu", "Spectral", "Jet", "Hot", "Cool", "Portland". Default: "Viridis".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div id="parcoords-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify7257639">
#>             <label class="control-label" id="parcoords-line.opacity-label" for="parcoords-line.opacity">Line Opacity</label>
#>             <input class="js-range-slider" id="parcoords-line.opacity" data-skin="shiny" data-min="0" data-max="1" data-from="0.5" data-step="0.05" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7257639', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, opacity of lines between 0 and 1. Default: 0.5.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3673290">
#>             <label class="control-label" id="parcoords-line.width-label" for="parcoords-line.width">Line Width</label>
#>             <input id="parcoords-line.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.5" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3673290', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, width of lines in pixels. Default: 1.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5234284">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="parcoords-show.colorbar" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Colorbar</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5234284', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to show the colorbar. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4698789">
#>             <label class="control-label" for="parcoords-bgcolor">Background Color</label>
#>             <input id="parcoords-bgcolor" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4698789', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the plot background. Default: "#FFFFFF".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Labels" id="tab-2075-3">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify985664">
#>             <label class="control-label" id="parcoords-label.font.size-label" for="parcoords-label.font.size">Label Size</label>
#>             <input id="parcoords-label.font.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify985664', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for dimension labels. Default: 12.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5160349">
#>             <label class="control-label" for="parcoords-label.font.color">Label Color</label>
#>             <input id="parcoords-label.font.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5160349', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for dimension labels. Default: "black".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify4497338">
#>             <label class="control-label" id="parcoords-label.font.family-label" for="parcoords-label.font.family">Label Font</label>
#>             <div id="parcoords-label.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="parcoords-label.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4497338', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for dimension labels. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5494615">
#>             <label class="control-label" id="parcoords-tick.font.size-label" for="parcoords-tick.font.size">Tick Font Size</label>
#>             <input id="parcoords-tick.font.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5494615', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for axis tick labels. Default: 10.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6495062">
#>             <label class="control-label" for="parcoords-tick.font.color">Tick Font Color</label>
#>             <input id="parcoords-tick.font.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6495062', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for axis tick labels. Default: "black".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify1590349">
#>             <label class="control-label" id="parcoords-tick.font.family-label" for="parcoords-tick.font.family">Tick Font</label>
#>             <div id="parcoords-tick.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="parcoords-tick.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1590349', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for axis tick labels. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Title" id="tab-2075-4">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2937508">
#>             <label class="control-label" id="parcoords-title.font.size-label" for="parcoords-title.font.size">Title Size</label>
#>             <input id="parcoords-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2937508', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for plot title. Default: 16.'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify8912848">
#>             <label class="control-label" id="parcoords-title.font.family-label" for="parcoords-title.font.family">Title Font</label>
#>             <div id="parcoords-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="parcoords-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8912848', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for plot title. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5880786">
#>             <label class="control-label" for="parcoords-title.font.color">Title Color</label>
#>             <input id="parcoords-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5880786', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for plot title text. Default: "black".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-2075-5">
#>       <div class="vizmodules-input-grid" style="display: flex; flex-wrap: wrap; align-items: flex-start; margin-left: -15px; margin-right: -15px;">
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="parcoords-download.format-label" for="parcoords-download.format">Download Format</label>
#>             <div id="parcoords-download.format" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="parcoords-download.format">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["svg","png","jpeg","webp"],"value":["svg","png","jpeg","webp"]}},"config":{"multiple":false,"search":false,"selectedValue":"svg","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify6332315">
#>             <label class="control-label" id="parcoords-margin.t-label" for="parcoords-margin.t">Margin Top</label>
#>             <input id="parcoords-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6332315', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify2595095">
#>             <label class="control-label" id="parcoords-margin.b-label" for="parcoords-margin.b">Margin Bottom</label>
#>             <input id="parcoords-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2595095', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3182127">
#>             <label class="control-label" id="parcoords-margin.l-label" for="parcoords-margin.l">Margin Left</label>
#>             <input id="parcoords-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3182127', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify3392539">
#>             <label class="control-label" id="parcoords-margin.r-label" for="parcoords-margin.r">Margin Right</label>
#>             <input id="parcoords-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3392539', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7607611">
#>             <label class="control-label" for="parcoords-shape.fill">Shape Fill</label>
#>             <input id="parcoords-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7607611', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify108725">
#>             <label class="control-label" for="parcoords-shape.line.color">Shape Line Color</label>
#>             <input id="parcoords-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify108725', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify631374">
#>             <label class="control-label" id="parcoords-shape.line.width-label" for="parcoords-shape.line.width">Shape Line Width</label>
#>             <input id="parcoords-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify631374', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" style="width:100%;" id="tipify2638418">
#>             <label class="control-label" id="parcoords-shape.linetype-label" for="parcoords-shape.linetype">Shape Linetype</label>
#>             <div id="parcoords-shape.linetype" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>               <script type="application/json" data-for="parcoords-shape.linetype">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["solid","dot","dash","longdash","dashdot","longdashdot"],"value":["solid","dot","dash","longdash","dashdot","longdashdot"]}},"config":{"multiple":false,"search":false,"selectedValue":"solid","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2638418', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="vizmodules-input-cell" style="flex: 0 0 calc(100% / 2); max-width: calc(100% / 2); padding-left: 15px; padding-right: 15px; box-sizing: border-box;">
#>           <div class="form-group shiny-input-container" id="tipify5938366">
#>             <label class="control-label" id="parcoords-shape.opacity-label" for="parcoords-shape.opacity">Shape Opacity</label>
#>             <input id="parcoords-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5938366', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="module-tack" style="margin-top: 12px;">
#>   <div class="module-tack-switch" style="margin-bottom: 4px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="parcoords-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="parcoords-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="parcoords-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="module-tack-buttons" style="display: flex; flex-wrap: wrap; gap: 8px;">
#>     <button class="btn btn-default action-button btn-primary" id="parcoords-update" style="flex: 1 1 45%;" type="button"><span class="action-label">Update</span></button>
#>     <button class="btn btn-default action-button btn-secondary" id="parcoords-reset" style="flex: 1 1 45%;" type="button"><span class="action-label">Reset</span></button>
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="parcoords-download.source" style="flex: 1 1 100%;" tabindex="-1" target="_blank">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('parcoords-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
