# Generate uniform Axes input UI

Creates a standardized tagList of axis-related inputs for use across
plot modules.

## Usage

``` r
uniform_axes_inputs_ui(
  ns,
  defaults = NULL,
  include.rotate = FALSE,
  include.flip = FALSE,
  include.padding = c("x", "y")
)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

- include.rotate:

  Logical; whether to include the "Rotate" input for swapping x and y
  axes (e.g., horizontal bar plots). Default is FALSE.

- include.flip:

  Logical; whether to include the "Flip" input for flipping the axis.
  Default is FALSE.

- include.padding:

  Which of `"x"` and `"y"` get an axis padding input (`axis.padding.x`,
  `axis.padding.y`; see
  [`apply_axis_padding()`](https://j-andrews7.github.io/VizModules/reference/apply_axis_padding.md)).
  Leave out an axis that has its own limit inputs. Default is both.

## Value

A `tagList` containing the axis input UI elements.

## Details

Alongside the fonts, lines, gridlines, and ticks, the inputs include
`axis.scientific`, which writes numeric tick labels in scientific
notation (off by default, so they never switch to it on their own; see
[`apply_tick_notation()`](https://j-andrews7.github.io/VizModules/reference/apply_tick_notation.md)),
and `axis.padding.x`/`axis.padding.y`, the space between the data and
the edges of the plot area as a fraction of the data's extent at each
end (blank keeps the plot's own padding).

## Author

Jared Andrews Jacob Martin

## Examples

``` r
ns <- shiny::NS("plot")
uniform_axes_inputs_ui(ns)
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-title.font.family-label" for="plot-title.font.family">Title Font</label>
#>   <div id="plot-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-title.font.color">Title Color</label>
#>   <input id="plot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-title.font.size-label" for="plot-title.font.size">Title Size</label>
#>   <input id="plot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.horizontal.position-label" for="plot-axis.title.horizontal.position">Title position</label>
#>   <input id="plot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.font.size-label" for="plot-axis.title.font.size">Axis Title Size</label>
#>   <input id="plot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.title.font.color">Axis Title Color</label>
#>   <input id="plot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-axis.title.font.family-label" for="plot-axis.title.font.family">Axis Title Font</label>
#>   <div id="plot-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Axis Borders</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Mirror Axis Borders</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show X Gridlines</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Y Gridlines</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-grid.color">Gridline Color</label>
#>   <input id="plot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.linecolor">Axis Line Color</label>
#>   <input id="plot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.linewidth-label" for="plot-axis.linewidth">Axis Line Width</label>
#>   <input id="plot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickfont.size-label" for="plot-axis.tickfont.size">Tick Label Size</label>
#>   <input id="plot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.tickfont.color">Tick Label Color</label>
#>   <input id="plot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-axis.tickfont.family-label" for="plot-axis.tickfont.family">Tick Label Font</label>
#>   <div id="plot-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickangle.x-label" for="plot-axis.tickangle.x">X Tick Label Angle</label>
#>   <input id="plot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickangle.y-label" for="plot-axis.tickangle.y">Y Tick Label Angle</label>
#>   <input id="plot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-axis.ticks-label" for="plot-axis.ticks">Tick Position</label>
#>   <div id="plot-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.tickcolor">Tick Mark Color</label>
#>   <input id="plot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.ticklen-label" for="plot-axis.ticklen">Tick Mark Length</label>
#>   <input id="plot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickwidth-label" for="plot-axis.tickwidth">Tick Mark Width</label>
#>   <input id="plot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container" id="tipify2083168">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.scientific" type="checkbox" class="shiny-input-checkbox"/>
#>       <span>Scientific Notation Ticks</span>
#>     </label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2083168', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Write numeric tick labels as powers of ten. Off, they are never in scientific notation.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify2282609">
#>   <label class="control-label" id="plot-axis.padding.x-label" for="plot-axis.padding.x">X Axis Padding</label>
#>   <input id="plot-axis.padding.x" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="0.01"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2282609', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Space between the data and the edges of the plot area along X, as a fraction of the data&#39;s extent at each end. 0 fills the plot area. Leave blank for the default.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify504422">
#>   <label class="control-label" id="plot-axis.padding.y-label" for="plot-axis.padding.y">Y Axis Padding</label>
#>   <input id="plot-axis.padding.y" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="0.01"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify504422', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Space between the data and the edges of the plot area along Y, as a fraction of the data&#39;s extent at each end. 0 fills the plot area. Leave blank for the default.'})}, 500)});</script>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-facet.title.font.size-label" for="plot-facet.title.font.size">Facet Subplot Title Size</label>
#>   <input id="plot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-facet.title.font.color">Facet Title Color</label>
#>   <input id="plot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-facet.title.font.family-label" for="plot-facet.title.font.family">Facet Title Font</label>
#>   <div id="plot-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
uniform_axes_inputs_ui(ns, include.rotate = TRUE, include.flip = TRUE)
#> <div class="form-group shiny-input-container">
#>   <div class="material-switch">
#>     <label for="plot-rotate" style="padding-right: 10px;">Rotate (swap X/Y)</label>
#>     <input id="plot-rotate" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot-rotate"></label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="material-switch">
#>     <label for="plot-flip.x" style="padding-right: 10px;">Flip X Axis</label>
#>     <input id="plot-flip.x" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot-flip.x"></label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="material-switch">
#>     <label for="plot-flip.y" style="padding-right: 10px;">Flip Y Axis</label>
#>     <input id="plot-flip.y" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot-flip.y"></label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-title.font.family-label" for="plot-title.font.family">Title Font</label>
#>   <div id="plot-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-title.font.color">Title Color</label>
#>   <input id="plot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-title.font.size-label" for="plot-title.font.size">Title Size</label>
#>   <input id="plot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.horizontal.position-label" for="plot-axis.title.horizontal.position">Title position</label>
#>   <input id="plot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.font.size-label" for="plot-axis.title.font.size">Axis Title Size</label>
#>   <input id="plot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.title.font.color">Axis Title Color</label>
#>   <input id="plot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-axis.title.font.family-label" for="plot-axis.title.font.family">Axis Title Font</label>
#>   <div id="plot-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Axis Borders</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Mirror Axis Borders</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show X Gridlines</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Y Gridlines</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-grid.color">Gridline Color</label>
#>   <input id="plot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.linecolor">Axis Line Color</label>
#>   <input id="plot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.linewidth-label" for="plot-axis.linewidth">Axis Line Width</label>
#>   <input id="plot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickfont.size-label" for="plot-axis.tickfont.size">Tick Label Size</label>
#>   <input id="plot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.tickfont.color">Tick Label Color</label>
#>   <input id="plot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-axis.tickfont.family-label" for="plot-axis.tickfont.family">Tick Label Font</label>
#>   <div id="plot-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickangle.x-label" for="plot-axis.tickangle.x">X Tick Label Angle</label>
#>   <input id="plot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickangle.y-label" for="plot-axis.tickangle.y">Y Tick Label Angle</label>
#>   <input id="plot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-axis.ticks-label" for="plot-axis.ticks">Tick Position</label>
#>   <div id="plot-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.tickcolor">Tick Mark Color</label>
#>   <input id="plot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.ticklen-label" for="plot-axis.ticklen">Tick Mark Length</label>
#>   <input id="plot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickwidth-label" for="plot-axis.tickwidth">Tick Mark Width</label>
#>   <input id="plot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container" id="tipify5618212">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.scientific" type="checkbox" class="shiny-input-checkbox"/>
#>       <span>Scientific Notation Ticks</span>
#>     </label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5618212', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Write numeric tick labels as powers of ten. Off, they are never in scientific notation.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify6942461">
#>   <label class="control-label" id="plot-axis.padding.x-label" for="plot-axis.padding.x">X Axis Padding</label>
#>   <input id="plot-axis.padding.x" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="0.01"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6942461', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Space between the data and the edges of the plot area along X, as a fraction of the data&#39;s extent at each end. 0 fills the plot area. Leave blank for the default.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify2279427">
#>   <label class="control-label" id="plot-axis.padding.y-label" for="plot-axis.padding.y">Y Axis Padding</label>
#>   <input id="plot-axis.padding.y" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="0.01"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2279427', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Space between the data and the edges of the plot area along Y, as a fraction of the data&#39;s extent at each end. 0 fills the plot area. Leave blank for the default.'})}, 500)});</script>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-facet.title.font.size-label" for="plot-facet.title.font.size">Facet Subplot Title Size</label>
#>   <input id="plot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-facet.title.font.color">Facet Title Color</label>
#>   <input id="plot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-facet.title.font.family-label" for="plot-facet.title.font.family">Facet Title Font</label>
#>   <div id="plot-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
# A plot with its own y-axis limit inputs: x padding only.
uniform_axes_inputs_ui(ns, include.padding = "x")
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-title.font.family-label" for="plot-title.font.family">Title Font</label>
#>   <div id="plot-title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-title.font.color">Title Color</label>
#>   <input id="plot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-title.font.size-label" for="plot-title.font.size">Title Size</label>
#>   <input id="plot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.horizontal.position-label" for="plot-axis.title.horizontal.position">Title position</label>
#>   <input id="plot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.title.font.size-label" for="plot-axis.title.font.size">Axis Title Size</label>
#>   <input id="plot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.title.font.color">Axis Title Color</label>
#>   <input id="plot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-axis.title.font.family-label" for="plot-axis.title.font.family">Axis Title Font</label>
#>   <div id="plot-axis.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-axis.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Axis Borders</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Mirror Axis Borders</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show X Gridlines</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Y Gridlines</span>
#>     </label>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-grid.color">Gridline Color</label>
#>   <input id="plot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.linecolor">Axis Line Color</label>
#>   <input id="plot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.linewidth-label" for="plot-axis.linewidth">Axis Line Width</label>
#>   <input id="plot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickfont.size-label" for="plot-axis.tickfont.size">Tick Label Size</label>
#>   <input id="plot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.tickfont.color">Tick Label Color</label>
#>   <input id="plot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-axis.tickfont.family-label" for="plot-axis.tickfont.family">Tick Label Font</label>
#>   <div id="plot-axis.tickfont.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-axis.tickfont.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickangle.x-label" for="plot-axis.tickangle.x">X Tick Label Angle</label>
#>   <input id="plot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickangle.y-label" for="plot-axis.tickangle.y">Y Tick Label Angle</label>
#>   <input id="plot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-axis.ticks-label" for="plot-axis.ticks">Tick Position</label>
#>   <div id="plot-axis.ticks" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-axis.ticks">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Outside","Inside","(none)"],"value":["outside","inside",""]}},"config":{"multiple":false,"search":false,"selectedValue":"outside","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-axis.tickcolor">Tick Mark Color</label>
#>   <input id="plot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.ticklen-label" for="plot-axis.ticklen">Tick Mark Length</label>
#>   <input id="plot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-axis.tickwidth-label" for="plot-axis.tickwidth">Tick Mark Width</label>
#>   <input id="plot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#> </div>
#> <div class="form-group shiny-input-container" id="tipify9603136">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-axis.scientific" type="checkbox" class="shiny-input-checkbox"/>
#>       <span>Scientific Notation Ticks</span>
#>     </label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9603136', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Write numeric tick labels as powers of ten. Off, they are never in scientific notation.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify4928372">
#>   <label class="control-label" id="plot-axis.padding.x-label" for="plot-axis.padding.x">X Axis Padding</label>
#>   <input id="plot-axis.padding.x" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="0.01"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4928372', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Space between the data and the edges of the plot area along X, as a fraction of the data&#39;s extent at each end. 0 fills the plot area. Leave blank for the default.'})}, 500)});</script>
#> <div class="form-group shiny-input-container">
#>   <label class="control-label" id="plot-facet.title.font.size-label" for="plot-facet.title.font.size">Facet Subplot Title Size</label>
#>   <input id="plot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#> </div>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>   <label class="control-label" for="plot-facet.title.font.color">Facet Title Color</label>
#>   <input id="plot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-facet.title.font.family-label" for="plot-facet.title.font.family">Facet Title Font</label>
#>   <div id="plot-facet.title.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot-facet.title.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
```
