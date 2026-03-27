# Input UI components for the piePlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`piePlotServer()`](https://j-andrews7.github.io/VizModules/reference/piePlotServer.md)
and
[`piePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/piePlotOutputUI.md)
functions.

## Usage

``` r
piePlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation. Supply a summary table with
  one row per slice.

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
to the `defaults` argument. Provide summarized data (one row per slice)
with columns for labels and aggregated values. Nearly all parameters for
[`piePlot()`](https://j-andrews7.github.io/VizModules/reference/piePlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters and defaults

The following
[`piePlot()`](https://j-andrews7.github.io/VizModules/reference/piePlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `title.font.size` - Plot title font size (UI: "Title Size", default:
  26)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `title.font.color` - Color for plot title (UI: "Title Color", default:
  "#000000")

- `labels` - Label column (UI: "Label column (summary data)", default:
  2nd categorical column)

- `values` - Aggregated value column (UI: "Aggregated value column",
  default: 2nd numeric column)

- `sort` - Sort slices by value (UI: "Sort slices by value", default:
  TRUE)

- `direction` - Slice direction (UI: "Slice direction", default:
  "counterclockwise")

- `rotation` - Start angle in degrees (UI: "Start angle (degrees)",
  default: 0)

- `hole` - Center hole size for donut chart (UI: "Center hole size",
  default: 0)

- `colors` - Slice colors (UI: color picker, derived from palette)

- `slice.line.color` - Slice border color (UI: "Slice border color",
  default: "#FFFFFF")

- `slice.line.width` - Slice border width (UI: "Slice border width",
  default: 0)

- `textinfo` - Text to show on slices (UI: "Text to show on slices",
  default: c("label", "value", "percent"))

- `textposition` - Text position (UI: "Text position", default: "auto")

- `insidetextorientation` - Inside text orientation (UI: "Inside text
  orientation", default: "auto")

- `text.font.size` - Slice text size (UI: "Slice text size", default:
  12)

- `text.font.family` - Slice text font (UI: "Slice text font", default:
  "Arial")

- `text.font.color` - Slice text color (UI: "Slice text color", default:
  "#000000")

- `title.x` - Title horizontal position (UI: "Title horizontal
  position", default: 0.5)

- `show.legend` - Show legend (UI: "Show legend", default: TRUE)

- `legend.orientation` - Legend orientation (UI: "Legend orientation",
  default: "h")

- `legend.font.family` - Legend font (UI: "Legend font", default:
  "Arial")

- `legend.font.size` - Legend font size (UI: "Legend font size",
  default: 12)

- `legend.font.color` - Legend font color (UI: "Legend font color",
  default: "#000000")

## See also

[`piePlot()`](https://j-andrews7.github.io/VizModules/reference/piePlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`piePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/piePlotOutputUI.md),
[`piePlotServer()`](https://j-andrews7.github.io/VizModules/reference/piePlotServer.md),
[`piePlotApp()`](https://j-andrews7.github.io/VizModules/reference/piePlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
pie_df <- as.data.frame(table(iris$Species))
names(pie_df) <- c("Species", "Count")
piePlotInputsUI("piePlot", pie_df)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="piePlot-piePlotTabsetPanel" data-tabsetid="3949">
#>     <li class="active">
#>       <a href="#tab-3949-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3949-2" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3949-3" data-toggle="tab" data-bs-toggle="tab" data-value="Labels &amp; Text">Labels &amp; Text</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3949-4" data-toggle="tab" data-bs-toggle="tab" data-value="Title &amp; Legend">Title &amp; Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3949-5" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="3949">
#>     <div class="tab-pane active" data-value="Data" id="tab-3949-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify502012">
#>             <label class="control-label" id="piePlot-labels-label" for="piePlot-labels">Label Column</label>
#>             <div>
#>               <select id="piePlot-labels" class="shiny-input-select"><option value=""></option>
#> <option value="Species" selected>Species</option></select>
#>               <script type="application/json" data-for="piePlot-labels">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify502012', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the slice labels.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5761874">
#>             <label class="control-label" id="piePlot-values-label" for="piePlot-values">Aggregated Value Column</label>
#>             <div>
#>               <select id="piePlot-values" class="shiny-input-select"><option value=""></option>
#> <option value="Count" selected>Count</option></select>
#>               <script type="application/json" data-for="piePlot-values">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5761874', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, name of the column to use for the aggregated values (slice sizes).'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2179058">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="piePlot-sort.slices" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Sort Slices by Value</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2179058', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to sort slices by their values in descending order. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1258563">
#>             <label class="control-label" id="piePlot-direction-label" for="piePlot-direction">Slice Direction</label>
#>             <div>
#>               <select id="piePlot-direction" class="shiny-input-select"><option value="counterclockwise" selected>Counterclockwise</option>
#> <option value="clockwise">Clockwise</option></select>
#>               <script type="application/json" data-for="piePlot-direction" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1258563', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, direction of slice progression. Options: "counterclockwise" or "clockwise". Default: "counterclockwise".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9381526">
#>             <label class="control-label" id="piePlot-rotation-label" for="piePlot-rotation">Start Angle (Degrees)</label>
#>             <input class="js-range-slider" id="piePlot-rotation" data-skin="shiny" data-min="0" data-max="360" data-from="0" data-step="5" data-grid="true" data-grid-num="9" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9381526', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, starting angle of the first slice in degrees (0-360). Default: 0.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8012751">
#>             <label class="control-label" id="piePlot-hole-label" for="piePlot-hole">Center Hole Size</label>
#>             <input class="js-range-slider" id="piePlot-hole" data-skin="shiny" data-min="0" data-max="0.9" data-from="0" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8012751', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric value between 0 and 1 for the hole size (0 for pie chart, >0 for donut chart). Default: 0.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-3949-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="piePlot-color.picker" class="shiny-html-output"></div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7580536">
#>             <label class="control-label" for="piePlot-slice.line.color">Slice Border Color</label>
#>             <input id="piePlot-slice.line.color" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7580536', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for slice borders. Default: "#FFFFFF" (white).'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5325652">
#>             <label class="control-label" id="piePlot-slice.line.width-label" for="piePlot-slice.line.width">Slice Border Width</label>
#>             <input id="piePlot-slice.line.width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5325652', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, width of slice borders in pixels. Set to 0 for no borders. Default: 0.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Labels &amp; Text" id="tab-3949-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5468048">
#>             <label class="control-label" id="piePlot-textinfo-label" for="piePlot-textinfo">Slice Label</label>
#>             <div>
#>               <select id="piePlot-textinfo" class="shiny-input-select" multiple="multiple"><option value="label" selected>label</option>
#> <option value="value" selected>value</option>
#> <option value="percent" selected>percent</option>
#> <option value="none">none</option></select>
#>               <script type="application/json" data-for="piePlot-textinfo">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5468048', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character string specifying the text info to show on slices. Any combination of "label", "text", "value", "percent" joined with a "+" (e.g., "label+percent") or "none" to hide text. Default: "label+percent".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify959265">
#>             <label class="control-label" id="piePlot-textposition-label" for="piePlot-textposition">Text Position</label>
#>             <div>
#>               <select id="piePlot-textposition" class="shiny-input-select"><option value="auto" selected>Auto</option>
#> <option value="inside">Inside</option>
#> <option value="outside">Outside</option>
#> <option value="none">Hide text</option></select>
#>               <script type="application/json" data-for="piePlot-textposition" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify959265', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, position of the text relative to the slice. Options: "auto", "inside", "outside", or "none". Default: "auto".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3883498">
#>             <label class="control-label" id="piePlot-insidetextorientation-label" for="piePlot-insidetextorientation">Inside Text Orientation</label>
#>             <div>
#>               <select id="piePlot-insidetextorientation" class="shiny-input-select"><option value="auto" selected>auto</option>
#> <option value="horizontal">horizontal</option>
#> <option value="radial">radial</option>
#> <option value="tangential">tangential</option></select>
#>               <script type="application/json" data-for="piePlot-insidetextorientation" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3883498', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, orientation for inside text. Options: "auto", "horizontal", "radial", or "tangential". Default: "auto".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1723519">
#>             <label class="control-label" id="piePlot-text.font.size-label" for="piePlot-text.font.size">Slice Text Size</label>
#>             <input id="piePlot-text.font.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="6" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1723519', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the slice labels. Default: 12.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6907258">
#>             <label class="control-label" id="piePlot-text.font.family-label" for="piePlot-text.font.family">Slice Text Font</label>
#>             <div>
#>               <select id="piePlot-text.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="piePlot-text.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6907258', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the slice labels. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6752085">
#>             <label class="control-label" for="piePlot-text.font.color">Slice Text Color</label>
#>             <input id="piePlot-text.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6752085', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the slice labels. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Title &amp; Legend" id="tab-3949-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9462948">
#>             <label class="control-label" id="piePlot-title.x-label" for="piePlot-title.x">Title Position</label>
#>             <input class="js-range-slider" id="piePlot-title.x" data-skin="shiny" data-min="0" data-max="1" data-from="0.5" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9462948', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, horizontal position for the plot title (0-1, where 0=left, 0.5=center, 1=right). Default: 0.5.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1962196">
#>             <label class="control-label" id="piePlot-title.font.size-label" for="piePlot-title.font.size">Title Size</label>
#>             <input id="piePlot-title.font.size" type="number" class="shiny-input-number form-control" value="28" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1962196', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the title text. Default: 18.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9686375">
#>             <label class="control-label" id="piePlot-title.font.family-label" for="piePlot-title.font.family">Title Font</label>
#>             <div>
#>               <select id="piePlot-title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="piePlot-title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9686375', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the title text. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3870963">
#>             <label class="control-label" for="piePlot-title.font.color">Title Color</label>
#>             <input id="piePlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3870963', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the title text. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6503439">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="piePlot-show.legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Legend</span>
#>               </label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6503439', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether to display the legend. Default: TRUE.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8145962">
#>             <label class="control-label" id="piePlot-legend.orientation-label" for="piePlot-legend.orientation">Legend Orientation</label>
#>             <div>
#>               <select id="piePlot-legend.orientation" class="shiny-input-select"><option value="h" selected>Horizontal</option>
#> <option value="v">Vertical</option></select>
#>               <script type="application/json" data-for="piePlot-legend.orientation" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8145962', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, legend orientation. Options: "h" (horizontal) or "v" (vertical). Default: "h".'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify709648">
#>             <label class="control-label" id="piePlot-legend.font.family-label" for="piePlot-legend.font.family">Legend Font</label>
#>             <div>
#>               <select id="piePlot-legend.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="piePlot-legend.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify709648', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, font family for the legend text. Default: "Arial".'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5268303">
#>             <label class="control-label" id="piePlot-legend.font.size-label" for="piePlot-legend.font.size">Legend Font Size</label>
#>             <input id="piePlot-legend.font.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5268303', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Numeric, font size for the legend text. Default: 12.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7634748">
#>             <label class="control-label" for="piePlot-legend.font.color">Legend Font Color</label>
#>             <input id="piePlot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7634748', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the legend text. Default: "#000000".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-3949-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="piePlot-download.interactive" tabindex="-1" target="_blank" width="100%">
#>             <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>             Save Interactive
#>           </a>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="piePlot-download.format-label" for="piePlot-download.format">Download Format</label>
#>             <div>
#>               <select id="piePlot-download.format" class="shiny-input-select"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>               <script type="application/json" data-for="piePlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4353866">
#>             <label class="control-label" id="piePlot-margin.t-label" for="piePlot-margin.t">Margin Top</label>
#>             <input id="piePlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4353866', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5524723">
#>             <label class="control-label" id="piePlot-margin.b-label" for="piePlot-margin.b">Margin Bottom</label>
#>             <input id="piePlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5524723', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2040307">
#>             <label class="control-label" id="piePlot-margin.l-label" for="piePlot-margin.l">Margin Left</label>
#>             <input id="piePlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2040307', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify310261">
#>             <label class="control-label" id="piePlot-margin.r-label" for="piePlot-margin.r">Margin Right</label>
#>             <input id="piePlot-margin.r" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify310261', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9697070">
#>             <label class="control-label" id="piePlot-subplot.margin-label" for="piePlot-subplot.margin">Subplot Spacing</label>
#>             <input id="piePlot-subplot.margin" type="number" class="shiny-input-number form-control" value="0.04" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9697070', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Spacing between facet panels as a fraction of the plot area. Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1786131">
#>             <label class="control-label" for="piePlot-shape.fill">Shape Fill</label>
#>             <input id="piePlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1786131', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7782928">
#>             <label class="control-label" for="piePlot-shape.line.color">Shape Line Color</label>
#>             <input id="piePlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7782928', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8857108">
#>             <label class="control-label" id="piePlot-shape.line.width-label" for="piePlot-shape.line.width">Shape Line Width</label>
#>             <input id="piePlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8857108', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8364462">
#>             <label class="control-label" id="piePlot-shape.linetype-label" for="piePlot-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select id="piePlot-shape.linetype" class="shiny-input-select"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>               <script type="application/json" data-for="piePlot-shape.linetype" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8364462', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6053684">
#>             <label class="control-label" id="piePlot-shape.opacity-label" for="piePlot-shape.opacity">Shape Opacity</label>
#>             <input id="piePlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6053684', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="piePlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="piePlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="piePlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="piePlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="piePlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#> </div>
```
