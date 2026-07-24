# Generate uniform Plotly input UI

Creates a standardized tagList of Plotly-specific inputs used across all
plot modules. Includes interactive download controls, plot margin
adjustments, and user-drawn shape styling for Plotly's drawing tools.
(Subplot spacing controls live in each module's "Facet" tab via
`.uniform_subplot_spacing_inputs_ui()`.)

## Usage

``` r
uniform_plotly_inputs_ui(ns, defaults = NULL)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

## Value

A `tagList` containing the Plotly input UI elements.

## Author

Jared Andrews

## Examples

``` r
ns <- shiny::NS("plot")
uniform_plotly_inputs_ui(ns)
#> <div class="form-group shiny-input-container" style="width:100%;">
#>   <label class="control-label" id="plot-download.format-label" for="plot-download.format">Download Format</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-download.format"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" id="tipify1681325">
#>   <label class="control-label" id="plot-margin.t-label" for="plot-margin.t">Margin Top</label>
#>   <input id="plot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1681325', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify2264814">
#>   <label class="control-label" id="plot-margin.b-label" for="plot-margin.b">Margin Bottom</label>
#>   <input id="plot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2264814', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify8455400">
#>   <label class="control-label" id="plot-margin.l-label" for="plot-margin.l">Margin Left</label>
#>   <input id="plot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8455400', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3458536">
#>   <label class="control-label" id="plot-margin.r-label" for="plot-margin.r">Margin Right</label>
#>   <input id="plot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3458536', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify673199">
#>   <label class="control-label" for="plot-shape.fill">Shape Fill</label>
#>   <input id="plot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify673199', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify270195">
#>   <label class="control-label" for="plot-shape.line.color">Shape Line Color</label>
#>   <input id="plot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify270195', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify1180446">
#>   <label class="control-label" id="plot-shape.line.width-label" for="plot-shape.line.width">Shape Line Width</label>
#>   <input id="plot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1180446', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify136954">
#>   <label class="control-label" id="plot-shape.linetype-label" for="plot-shape.linetype">Shape Linetype</label>
#>   <div>
#>     <select class="shiny-input-select form-control" id="plot-shape.linetype"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify136954', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify7357293">
#>   <label class="control-label" id="plot-shape.opacity-label" for="plot-shape.opacity">Shape Opacity</label>
#>   <input id="plot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7357293', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
```
