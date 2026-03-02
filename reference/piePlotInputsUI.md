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

- `title.font.size` - Title font size (UI: "Title font size", default:
  28)

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
#>   <ul class="nav nav-tabs shiny-tab-input" id="piePlot-piePlotTabsetPanel" data-tabsetid="6546">
#>     <li class="active">
#>       <a href="#tab-6546-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6546-2" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6546-3" data-toggle="tab" data-bs-toggle="tab" data-value="Labels &amp; Text">Labels &amp; Text</a>
#>     </li>
#>     <li>
#>       <a href="#tab-6546-4" data-toggle="tab" data-bs-toggle="tab" data-value="Title &amp; Legend">Title &amp; Legend</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="6546">
#>     <div class="tab-pane active" data-value="Data" id="tab-6546-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-labels-label" for="piePlot-labels">Label column (summary data):</label>
#>             <div>
#>               <select id="piePlot-labels" class="shiny-input-select"><option value=""></option>
#> <option value="Species" selected>Species</option></select>
#>               <script type="application/json" data-for="piePlot-labels">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-values-label" for="piePlot-values">Aggregated value column:</label>
#>             <div>
#>               <select id="piePlot-values" class="shiny-input-select"><option value=""></option>
#> <option value="Count" selected>Count</option></select>
#>               <script type="application/json" data-for="piePlot-values">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="piePlot-sort.slices" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Sort slices by value</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-direction-label" for="piePlot-direction">Slice direction:</label>
#>             <div>
#>               <select id="piePlot-direction" class="shiny-input-select"><option value="counterclockwise" selected>Counterclockwise</option>
#> <option value="clockwise">Clockwise</option></select>
#>               <script type="application/json" data-for="piePlot-direction" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-rotation-label" for="piePlot-rotation">Start angle (degrees):</label>
#>             <input class="js-range-slider" id="piePlot-rotation" data-skin="shiny" data-min="0" data-max="360" data-from="0" data-step="5" data-grid="true" data-grid-num="9" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-hole-label" for="piePlot-hole">Center hole size:</label>
#>             <input class="js-range-slider" id="piePlot-hole" data-skin="shiny" data-min="0" data-max="0.9" data-from="0" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-6546-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="piePlot-color.picker" class="shiny-html-output"></div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="piePlot-slice.line.color">Slice border color:</label>
#>             <input id="piePlot-slice.line.color" type="text" class="form-control shiny-colour-input" data-init-value="#FFFFFF" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-slice.line.width-label" for="piePlot-slice.line.width">Slice border width:</label>
#>             <input id="piePlot-slice.line.width" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="0" step="0.5"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Labels &amp; Text" id="tab-6546-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-textinfo-label" for="piePlot-textinfo">Text to show on slices:</label>
#>             <div>
#>               <select id="piePlot-textinfo" class="shiny-input-select" multiple="multiple"><option value="label" selected>label</option>
#> <option value="value">value</option>
#> <option value="percent">percent</option>
#> <option value="none">none</option></select>
#>               <script type="application/json" data-for="piePlot-textinfo">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-textposition-label" for="piePlot-textposition">Text position:</label>
#>             <div>
#>               <select id="piePlot-textposition" class="shiny-input-select"><option value="auto" selected>Auto</option>
#> <option value="inside">Inside</option>
#> <option value="outside">Outside</option>
#> <option value="none">Hide text</option></select>
#>               <script type="application/json" data-for="piePlot-textposition" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-insidetextorientation-label" for="piePlot-insidetextorientation">Inside text orientation:</label>
#>             <div>
#>               <select id="piePlot-insidetextorientation" class="shiny-input-select"><option value="auto" selected>auto</option>
#> <option value="horizontal">horizontal</option>
#> <option value="radial">radial</option>
#> <option value="tangential">tangential</option></select>
#>               <script type="application/json" data-for="piePlot-insidetextorientation" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-text.font.size-label" for="piePlot-text.font.size">Slice text size:</label>
#>             <input id="piePlot-text.font.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="6" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-text.font.family-label" for="piePlot-text.font.family">Slice text font:</label>
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
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="piePlot-text.font.color">Slice text color:</label>
#>             <input id="piePlot-text.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Title &amp; Legend" id="tab-6546-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-title.x-label" for="piePlot-title.x">Title horizontal position:</label>
#>             <input class="js-range-slider" id="piePlot-title.x" data-skin="shiny" data-min="0" data-max="1" data-from="0.5" data-step="0.01" data-grid="true" data-grid-num="10" data-grid-snap="false" data-prettify-separator="," data-prettify-enabled="true" data-keyboard="true" data-data-type="number"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-title.font.size-label" for="piePlot-title.font.size">Title font size:</label>
#>             <input id="piePlot-title.font.size" type="number" class="shiny-input-number form-control" value="28" data-update-on="change" min="0"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-title.font.family-label" for="piePlot-title.font.family">Title font:</label>
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
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="piePlot-title.font.color">Title font color:</label>
#>             <input id="piePlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="piePlot-show.legend" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show legend</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-legend.orientation-label" for="piePlot-legend.orientation">Legend orientation:</label>
#>             <div>
#>               <select id="piePlot-legend.orientation" class="shiny-input-select"><option value="h" selected>Horizontal</option>
#> <option value="v">Vertical</option></select>
#>               <script type="application/json" data-for="piePlot-legend.orientation" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-legend.font.family-label" for="piePlot-legend.font.family">Legend font:</label>
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
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="piePlot-legend.font.size-label" for="piePlot-legend.font.size">Legend font size:</label>
#>             <input id="piePlot-legend.font.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="piePlot-legend.font.color">Legend font color:</label>
#>             <input id="piePlot-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
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
#>         <input id="piePlot-auto.update" type="checkbox"/>
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
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="piePlot-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="piePlot-download.format-label" for="piePlot-download.format">Download Format</label>
#>       <div>
#>         <select id="piePlot-download.format" class="shiny-input-select"><option value="png">png</option>
#> <option value="svg" selected>svg</option></select>
#>         <script type="application/json" data-for="piePlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
