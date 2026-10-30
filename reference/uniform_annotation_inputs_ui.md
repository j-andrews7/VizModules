# Generate uniform Annotation input UI

Creates a standardized tagList of the point highlighting and annotation
inputs shared by modules that draw individual data points. Points are
identified by the values of the column chosen in "Annotate By", which
are also used as the label text.

## Usage

``` r
uniform_annotation_inputs_ui(
  ns,
  defaults = NULL,
  choices = "",
  annotate.note = NULL
)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

- choices:

  Character vector of column names offered by "Annotate By".

- annotate.note:

  Character, or `NULL`. Extra sentence appended to the "Annotate By"
  tooltip, for module-specific caveats.

## Value

A `tagList` containing the annotation input UI elements.

## Author

Jared Andrews

## Examples

``` r
ns <- shiny::NS("plot1")
uniform_annotation_inputs_ui(ns, choices = c("", "Species", "Sepal.Length"))
#> <div class="form-group shiny-input-container" style="width:100%;" id="tipify7539531">
#>   <label class="control-label" id="plot1-annotate.by-label" for="plot1-annotate.by">Annotate By</label>
#>   <div id="plot1-annotate.by" class="virtual-select" style="width:100%;max-width:none;display:block;" data-update="change">
#>     <script type="application/json" data-for="plot1-annotate.by">{"stateInput":false,"options":{"type":["transpose"],"choices":{"label":["(none)","Species","Sepal.Length"],"value":["","Species","Sepal.Length"]}},"config":{"multiple":false,"search":false,"selectedValue":"","hideClearButton":true,"autoSelectFirstOption":false,"showSelectedOptionsFirst":false,"showValueAsTags":false,"optionsCount":10,"noOfDisplayValues":50,"allowNewOption":false,"disableSelectAll":true,"disableOptionGroupCheckbox":true,"disabled":false,"dropboxWrapper":"body","zIndex":1060}}</script>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7539531', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select a column whose values will be used to identify points for highlighting and annotation'})}, 500)});</script>
#> <div class="shiny-input-textarea form-group shiny-input-container" id="tipify5454252">
#>   <label class="control-label" id="plot1-highlight.points-label" for="plot1-highlight.points">Points to Highlight</label>
#>   <textarea id="plot1-highlight.points" class="form-control" placeholder="Values from &#39;Annotate by&#39; column&#10;(comma, space, or newline delimited)" rows="3" data-update-on="change"></textarea>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5454252', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Enter specific values from the &#39;Annotate By&#39; column to highlight those points on the plot. Separate values that contain spaces with commas or new lines.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify7596779">
#>   <label class="control-label" for="plot1-highlight.color">Highlight Fill</label>
#>   <input id="plot1-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#00FFF7" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7596779', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the fill color for highlighted points'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify2129675">
#>   <label class="control-label" id="plot1-highlight.size-label" for="plot1-highlight.size">Highlight Size</label>
#>   <input id="plot1-highlight.size" type="number" class="shiny-input-number form-control" value="7" data-update-on="change" min="0.1" step="0.5"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2129675', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the size of highlighted points on the plot'})}, 500)});</script>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8392650">
#>   <label class="control-label" for="plot1-highlight.border.color">Highlight Border Color</label>
#>   <input id="plot1-highlight.border.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8392650', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the border color for highlighted points'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify4066971">
#>   <label class="control-label" id="plot1-highlight.border.width-label" for="plot1-highlight.border.width">Highlight Border Width</label>
#>   <input id="plot1-highlight.border.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.25"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4066971', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the width of the border around highlighted points'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify8737398">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot1-highlight.auto.annotate" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Auto-annotate Highlights</span>
#>     </label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8737398', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, automatically adds text labels to highlighted points using their &#39;Annotate By&#39; values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8821565">
#>   <label class="control-label" for="plot1-annotation.color">Annotation Color</label>
#>   <input id="plot1-annotation.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8821565', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the text color for annotation labels'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify1076894">
#>   <label class="control-label" id="plot1-annotation.ax-label" for="plot1-annotation.ax">Annotation X Offset</label>
#>   <input id="plot1-annotation.ax" type="number" class="shiny-input-number form-control" value="20" data-update-on="change" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1076894', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal pixel offset of annotation labels from their target points'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify5745444">
#>   <label class="control-label" id="plot1-annotation.ay-label" for="plot1-annotation.ay">Annotation Y Offset</label>
#>   <input id="plot1-annotation.ay" type="number" class="shiny-input-number form-control" value="-20" data-update-on="change" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5745444', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical pixel offset of annotation labels from their target points (negative values move up)'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify9960333">
#>   <label class="control-label" id="plot1-annotation.size-label" for="plot1-annotation.size">Annotation Size</label>
#>   <input id="plot1-annotation.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9960333', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the font size of annotation text labels in points'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify8505534">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot1-annotation.showarrow" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Show Arrow</span>
#>     </label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8505534', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle whether an arrow is drawn from the annotation label to the target point'})}, 500)});</script>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4376551">
#>   <label class="control-label" for="plot1-annotation.arrowcolor">Arrow Color</label>
#>   <input id="plot1-annotation.arrowcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4376551', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the color of the annotation arrow connecting the label to the point'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3264299">
#>   <label class="control-label" id="plot1-annotation.arrowhead-label" for="plot1-annotation.arrowhead">Arrowhead Style</label>
#>   <input id="plot1-annotation.arrowhead" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="7" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3264299', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Choose the arrowhead style (0-7) for annotation arrows, where 0 is no arrowhead'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3359689">
#>   <label class="control-label" id="plot1-annotation.arrowwidth-label" for="plot1-annotation.arrowwidth">Arrow Linewidth</label>
#>   <input id="plot1-annotation.arrowwidth" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0.1" step="0.25"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3359689', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the line width of the annotation arrow'})}, 500)});</script>
#> <button id="plot1-annotation.clear" type="button" class="btn btn-default action-button"><span class="action-label">Clear Annotations</span></button>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('plot1-annotation.clear', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Remove all annotation labels and arrows from the current plot'})}, 500)});</script>
```
