# Generate uniform Legend input UI

Creates a standardized tagList of legend inputs used across plot
modules, so the legend can be shown/hidden and styled consistently
regardless of plot type:

## Usage

``` r
uniform_legend_inputs_ui(ns, defaults = NULL)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

## Value

A `tagList` containing the legend input UI elements.

## Details

- `legend.show` - Show the legend, colorbars and any size legend (UI:
  "Show Legend", default: TRUE)

- `legend.font.family` - Font family of the legend title and labels (UI:
  "Legend Font", default: "Arial")

- `legend.font.color` - Font color of the legend title and labels (UI:
  "Legend Font Color", default: "#000000")

- `legend.title.size` - Font size of the legend title (UI: "Legend Title
  Size", default: 14)

- `legend.text.size` - Font size of the legend entry labels (UI: "Legend
  Text Size", default: 12)

Apply them to a figure with
[`apply_legend_inputs()`](https://j-andrews7.github.io/VizModules/reference/apply_legend_inputs.md)
and restore them with
[`reset_legend_inputs()`](https://j-andrews7.github.io/VizModules/reference/reset_legend_inputs.md).

## Author

Jared Andrews

## Examples

``` r
ns <- shiny::NS("plot1")
uniform_legend_inputs_ui(ns)
#> <div class="form-group shiny-input-container" id="tipify1073319">
#>   <div class="material-switch">
#>     <label for="plot1-legend.show" style="padding-right: 10px;">Show Legend</label>
#>     <input id="plot1-legend.show" type="checkbox" checked="checked"/>
#>     <label class="switch label-success bg-success" for="plot1-legend.show"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1073319', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" style="width:100%;" id="tipify729945">
#>   <label class="control-label" id="plot1-legend.font.family-label" for="plot1-legend.font.family">Legend Font</label>
#>   <div id="plot1-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot1-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Arial","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify729945', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify3563146">
#>   <label class="control-label" for="plot1-legend.font.color">Legend Font Color</label>
#>   <input id="plot1-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3563146', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify5715608">
#>   <label class="control-label" id="plot1-legend.title.size-label" for="plot1-legend.title.size">Legend Title Size</label>
#>   <input id="plot1-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5715608', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify6779880">
#>   <label class="control-label" id="plot1-legend.text.size-label" for="plot1-legend.text.size">Legend Text Size</label>
#>   <input id="plot1-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6779880', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
uniform_legend_inputs_ui(ns, defaults = list(
    legend.show = FALSE, legend.font.family = "Courier New",
    legend.title.size = 16, legend.text.size = 12
))
#> <div class="form-group shiny-input-container" id="tipify6907191">
#>   <div class="material-switch">
#>     <label for="plot1-legend.show" style="padding-right: 10px;">Show Legend</label>
#>     <input id="plot1-legend.show" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot1-legend.show"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6907191', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Show the legend. Turning it off also hides colorbars and any point size legend.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" style="width:100%;" id="tipify3734108">
#>   <label class="control-label" id="plot1-legend.font.family-label" for="plot1-legend.font.family">Legend Font</label>
#>   <div id="plot1-legend.font.family" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot1-legend.font.family">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"],"value":["Arial","Balto","Courier New","Droid Sans","Droid Serif","Droid Sans Mono","Gravitas One","Old Standard TT","Open Sans","Overpass","PT Sans Narrow","Raleway","Times New Roman","Verdana","sans-serif","serif","monospace"]}},"config":{"multiple":false,"search":true,"selectedValue":"Courier New","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3734108', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font family of the legend title and entry labels.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify979781">
#>   <label class="control-label" for="plot1-legend.font.color">Legend Font Color</label>
#>   <input id="plot1-legend.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify979781', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font color of the legend title and entry labels.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify990097">
#>   <label class="control-label" id="plot1-legend.title.size-label" for="plot1-legend.title.size">Legend Title Size</label>
#>   <input id="plot1-legend.title.size" type="number" class="shiny-input-number form-control" value="16" data-update-on="change" min="0" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify990097', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify7748016">
#>   <label class="control-label" id="plot1-legend.text.size-label" for="plot1-legend.text.size">Legend Text Size</label>
#>   <input id="plot1-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7748016', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
```
