# Input UI components for the dumbbellPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dumbbellPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotServer.md)
and
[`dumbbellPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotOutputUI.md)
functions.

## Usage

``` r
dumbbellPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
to the `defaults` argument.

## Plot parameters and defaults

The following
[`dumbbellPlot()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlot.md)
parameters can be accessed via UI inputs:

- `x` - X values (UI: "Select X values (max 2)", multiple: TRUE, max 2
  enforced)

- `y` - Y value (UI: "Select Y value", single selection)

- `x.adjustment` - X-axis transformation (UI: "X Adjustment")

- `colour.by` - Color by X or Y (UI: "Colour by", options: "X
  variables", "Y variables")

- `facet.by` - Faceting variable (UI: "Facet by")

- `facet.scales` - Facet scale behavior (UI: "Facet scales", default:
  "fixed")

- `line.colour` - Color of connecting lines (UI: "Colour Of connectors",
  default: "red")

- `palette.selection` - Color palette (UI: palette picker)

- `axis.*` - Various axis styling options (UI: via
  .uniform_axes_inputs_ui)

- `flip.x` - Flip X-axis (UI: "Flip X", default: FALSE)

- `flip.y` - Flip Y-axis (UI: "Flip Y", default: FALSE)

## See also

[`dumbbellPlot()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`dumbbellPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotOutputUI.md),
[`dumbbellPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotServer.md),
[`dumbbellPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotApp.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
data <- data.frame(
  School = c("MIT", "Stanford", "Harvard"),
  Women = c(94, 96, 112),
  Men = c(152, 151, 165)
)
dumbbellPlotInputsUI("dumbbellPlot", data)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="dumbbellPlot-dumbbellPlotTabsetPanel" data-tabsetid="8890">
#>     <li class="active">
#>       <a href="#tab-8890-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8890-2" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8890-3" data-toggle="tab" data-bs-toggle="tab" data-value="Aesthetics">Aesthetics</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8890-4" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-8890-5" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="8890">
#>     <div class="tab-pane active" data-value="Data" id="tab-8890-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4028812">
#>             <label class="control-label" id="dumbbellPlot-x.value-label" for="dumbbellPlot-x.value">Select X values (max 2):</label>
#>             <div>
#>               <select id="dumbbellPlot-x.value" class="shiny-input-select" multiple="multiple"><option value=""></option>
#> <option value="Women" selected>Women</option>
#> <option value="Men" selected>Men</option></select>
#>               <script type="application/json" data-for="dumbbellPlot-x.value">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4028812', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character vector of column name(s) for x-axis values. Maximum 2 values allowed. If 1 value: creates single dot plot. If 2 values: creates dumbbell plot with connecting segments.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7696301">
#>             <label class="control-label" id="dumbbellPlot-y.value-label" for="dumbbellPlot-y.value">Select Y value:</label>
#>             <div>
#>               <select id="dumbbellPlot-y.value" class="shiny-input-select"><option value=""></option>
#> <option value="School" selected>School</option></select>
#>               <script type="application/json" data-for="dumbbellPlot-y.value">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7696301', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, column name for the y-axis (categorical variable recommended).'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1194854">
#>             <label class="control-label" id="dumbbellPlot-x.adjustment-label" for="dumbbellPlot-x.adjustment">X Adjustment:</label>
#>             <div>
#>               <select id="dumbbellPlot-x.adjustment" class="shiny-input-select"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="as.factor">as.factor</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>               <script type="application/json" data-for="dumbbellPlot-x.adjustment">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1194854', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character or function, transformation to apply to x values. Options: "log2", "log", "log10", "neg_log10", "log1p", "as.factor", "abs", "sqrt", or custom function. Default: NULL.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1946950">
#>             <label class="control-label" id="dumbbellPlot-colour.by-label" for="dumbbellPlot-colour.by">Colour by:</label>
#>             <div>
#>               <select id="dumbbellPlot-colour.by" class="shiny-input-select"><option value="X variables" selected>X variables</option>
#> <option value="Y variables">Y variables</option></select>
#>               <script type="application/json" data-for="dumbbellPlot-colour.by" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1946950', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, how to color the markers. Options: "X variables" (different colors for each x variable) or "Y variables" (different colors for each y category). Default: "X variables".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-8890-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1645693">
#>             <label class="control-label" id="dumbbellPlot-facet.by-label" for="dumbbellPlot-facet.by">Facet by:</label>
#>             <div>
#>               <select id="dumbbellPlot-facet.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="School">School</option></select>
#>               <script type="application/json" data-for="dumbbellPlot-facet.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1645693', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Optional character, column name to facet plots by. Creates subplots for each unique value. Default: NULL.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6632066">
#>             <label class="control-label" id="dumbbellPlot-facet.scales-label" for="dumbbellPlot-facet.scales">Facet scales</label>
#>             <div>
#>               <select id="dumbbellPlot-facet.scales" class="shiny-input-select"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>               <script type="application/json" data-for="dumbbellPlot-facet.scales" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6632066', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, controls axis scaling across facets. Options: "fixed" (same for all), "free" (independent), "free_x" (independent x-axis), "free_y" (independent y-axis). Default: "fixed".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Aesthetics" id="tab-8890-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="dumbbellPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8565750">
#>             <label class="control-label" for="dumbbellPlot-line.colour">Colour Of conectors</label>
#>             <input id="dumbbellPlot-line.colour" type="text" class="form-control shiny-colour-input" data-init-value="red" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8565750', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Character, hex color for the connecting lines between dumbbell points. Default: "gray80".'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-8890-4">
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="dumbbellPlot-flip.x" style="padding-right: 10px;">Flip X Axis</label>
#>               <input id="dumbbellPlot-flip.x" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="dumbbellPlot-flip.x"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="dumbbellPlot-flip.y" style="padding-right: 10px;">Flip Y Axis</label>
#>               <input id="dumbbellPlot-flip.y" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="dumbbellPlot-flip.y"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-font.type-label" for="dumbbellPlot-font.type">Title Font</label>
#>             <div>
#>               <select id="dumbbellPlot-font.type" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="dumbbellPlot-font.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dumbbellPlot-text.colour">Title Color</label>
#>             <input id="dumbbellPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-axis.title.font.size-label" for="dumbbellPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="dumbbellPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dumbbellPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="dumbbellPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-axis.title.font.family-label" for="dumbbellPlot-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select id="dumbbellPlot-axis.title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="dumbbellPlot-axis.title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dumbbellPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dumbbellPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
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
#>                 <input id="dumbbellPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="dumbbellPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dumbbellPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="dumbbellPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-axis.linewidth-label" for="dumbbellPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="dumbbellPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-axis.tickfont.size-label" for="dumbbellPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="dumbbellPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dumbbellPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="dumbbellPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-axis.tickfont.family-label" for="dumbbellPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select id="dumbbellPlot-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="dumbbellPlot-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-axis.tickangle.x-label" for="dumbbellPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="dumbbellPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-axis.tickangle.y-label" for="dumbbellPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="dumbbellPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-axis.ticks-label" for="dumbbellPlot-axis.ticks">Tick Position</label>
#>             <div>
#>               <select id="dumbbellPlot-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="dumbbellPlot-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="dumbbellPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="dumbbellPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-axis.ticklen-label" for="dumbbellPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="dumbbellPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-axis.tickwidth-label" for="dumbbellPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="dumbbellPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-8890-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9265464">
#>             <label class="control-label" id="dumbbellPlot-hline.intercepts-label" for="dumbbellPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="dumbbellPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9265464', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-hline.colors-label" for="dumbbellPlot-hline.colors">Colors</label>
#>             <input id="dumbbellPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-hline.widths-label" for="dumbbellPlot-hline.widths">Widths</label>
#>             <input id="dumbbellPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-hline.linetypes-label" for="dumbbellPlot-hline.linetypes">Line types</label>
#>             <input id="dumbbellPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-hline.opacities-label" for="dumbbellPlot-hline.opacities">Opacities (0-1)</label>
#>             <input id="dumbbellPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <br/>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5523776">
#>             <label class="control-label" id="dumbbellPlot-vline.intercepts-label" for="dumbbellPlot-vline.intercepts">X-intercepts</label>
#>             <input id="dumbbellPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5523776', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-vline.colors-label" for="dumbbellPlot-vline.colors">Colors</label>
#>             <input id="dumbbellPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-vline.widths-label" for="dumbbellPlot-vline.widths">Widths</label>
#>             <input id="dumbbellPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-vline.linetypes-label" for="dumbbellPlot-vline.linetypes">Line types</label>
#>             <input id="dumbbellPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="dumbbellPlot-vline.opacities-label" for="dumbbellPlot-vline.opacities">Opacities (0-1)</label>
#>             <input id="dumbbellPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <br/>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="dumbbellPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="dumbbellPlot-auto.update" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="dumbbellPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="dumbbellPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="dumbbellPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="dumbbellPlot-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="dumbbellPlot-download.format-label" for="dumbbellPlot-download.format">Download Format</label>
#>       <div>
#>         <select id="dumbbellPlot-download.format" class="shiny-input-select"><option value="png">png</option>
#> <option value="svg" selected>svg</option></select>
#>         <script type="application/json" data-for="dumbbellPlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
