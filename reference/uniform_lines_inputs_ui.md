# Generate uniform Lines input UI

Creates a standardized tagList of line-related inputs (horizontal,
vertical, and diagonal lines) for use across plot modules.

## Usage

``` r
uniform_lines_inputs_ui(ns, defaults = NULL, include.fit.lines = FALSE)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

- include.fit.lines:

  Logical; whether to include "line of best fit" and "linear model line"
  inputs. Only applicable for scatter plots. Default is FALSE.

## Value

A `tagList` containing the line input UI elements.

## Author

Jared Andrews

## Examples

``` r
ns <- shiny::NS("plot")
uniform_lines_inputs_ui(ns)
#> <div class="form-group shiny-input-container" id="tipify2548184">
#>   <label class="control-label" id="plot-hline.intercepts-label" for="plot-hline.intercepts">Y-intercepts</label>
#>   <input id="plot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2548184', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify4775874">
#>   <label class="control-label" id="plot-hline.colors-label" for="plot-hline.colors">Y Colors</label>
#>   <input id="plot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4775874', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify7044640">
#>   <label class="control-label" id="plot-hline.widths-label" for="plot-hline.widths">Y Widths</label>
#>   <input id="plot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7044640', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify75056">
#>   <label class="control-label" id="plot-hline.linetypes-label" for="plot-hline.linetypes">Y Line Types</label>
#>   <input id="plot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify75056', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify7724088">
#>   <label class="control-label" id="plot-hline.opacities-label" for="plot-hline.opacities">Y Opacities (0-1)</label>
#>   <input id="plot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7724088', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify2657936">
#>   <label class="control-label" id="plot-vline.intercepts-label" for="plot-vline.intercepts">X-intercepts</label>
#>   <input id="plot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2657936', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify9710409">
#>   <label class="control-label" id="plot-vline.colors-label" for="plot-vline.colors">X Colors</label>
#>   <input id="plot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9710409', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify1905252">
#>   <label class="control-label" id="plot-vline.widths-label" for="plot-vline.widths">X Widths</label>
#>   <input id="plot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1905252', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify196959">
#>   <label class="control-label" id="plot-vline.linetypes-label" for="plot-vline.linetypes">X Line Types</label>
#>   <input id="plot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify196959', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify6123770">
#>   <label class="control-label" id="plot-vline.opacities-label" for="plot-vline.opacities">X Opacities (0-1)</label>
#>   <input id="plot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6123770', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify5257314">
#>   <label class="control-label" id="plot-abline.slopes-label" for="plot-abline.slopes">Ab Slopes</label>
#>   <input id="plot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5257314', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify6345200">
#>   <label class="control-label" id="plot-abline.intercepts-label" for="plot-abline.intercepts">Ab Y-intercepts</label>
#>   <input id="plot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6345200', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3954480">
#>   <label class="control-label" id="plot-abline.colors-label" for="plot-abline.colors">Ab Colors</label>
#>   <input id="plot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3954480', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify1748683">
#>   <label class="control-label" id="plot-abline.widths-label" for="plot-abline.widths">Ab Widths</label>
#>   <input id="plot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1748683', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3273132">
#>   <label class="control-label" id="plot-abline.linetypes-label" for="plot-abline.linetypes">Ab Line Types</label>
#>   <input id="plot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3273132', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify6147532">
#>   <label class="control-label" id="plot-abline.opacities-label" for="plot-abline.opacities">Ab Opacities (0-1)</label>
#>   <input id="plot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6147532', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
uniform_lines_inputs_ui(ns, include.fit.lines = TRUE)
#> <div class="form-group shiny-input-container" id="tipify791665">
#>   <label class="control-label" id="plot-hline.intercepts-label" for="plot-hline.intercepts">Y-intercepts</label>
#>   <input id="plot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify791665', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify5190610">
#>   <label class="control-label" id="plot-hline.colors-label" for="plot-hline.colors">Y Colors</label>
#>   <input id="plot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5190610', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3062813">
#>   <label class="control-label" id="plot-hline.widths-label" for="plot-hline.widths">Y Widths</label>
#>   <input id="plot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3062813', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify6713953">
#>   <label class="control-label" id="plot-hline.linetypes-label" for="plot-hline.linetypes">Y Line Types</label>
#>   <input id="plot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6713953', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3936718">
#>   <label class="control-label" id="plot-hline.opacities-label" for="plot-hline.opacities">Y Opacities (0-1)</label>
#>   <input id="plot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3936718', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify7478482">
#>   <label class="control-label" id="plot-vline.intercepts-label" for="plot-vline.intercepts">X-intercepts</label>
#>   <input id="plot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7478482', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify1389266">
#>   <label class="control-label" id="plot-vline.colors-label" for="plot-vline.colors">X Colors</label>
#>   <input id="plot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1389266', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3773431">
#>   <label class="control-label" id="plot-vline.widths-label" for="plot-vline.widths">X Widths</label>
#>   <input id="plot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3773431', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify6413834">
#>   <label class="control-label" id="plot-vline.linetypes-label" for="plot-vline.linetypes">X Line Types</label>
#>   <input id="plot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6413834', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify9941946">
#>   <label class="control-label" id="plot-vline.opacities-label" for="plot-vline.opacities">X Opacities (0-1)</label>
#>   <input id="plot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9941946', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3685591">
#>   <label class="control-label" id="plot-abline.slopes-label" for="plot-abline.slopes">Ab Slopes</label>
#>   <input id="plot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3685591', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3373486">
#>   <label class="control-label" id="plot-abline.intercepts-label" for="plot-abline.intercepts">Ab Y-intercepts</label>
#>   <input id="plot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3373486', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify9136854">
#>   <label class="control-label" id="plot-abline.colors-label" for="plot-abline.colors">Ab Colors</label>
#>   <input id="plot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9136854', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify9094203">
#>   <label class="control-label" id="plot-abline.widths-label" for="plot-abline.widths">Ab Widths</label>
#>   <input id="plot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9094203', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify2383798">
#>   <label class="control-label" id="plot-abline.linetypes-label" for="plot-abline.linetypes">Ab Line Types</label>
#>   <input id="plot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2383798', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify4116800">
#>   <label class="control-label" id="plot-abline.opacities-label" for="plot-abline.opacities">Ab Opacities (0-1)</label>
#>   <input id="plot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4116800', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify7460717">
#>   <div class="material-switch">
#>     <label for="plot-best.fit" style="padding-right: 10px;">Plot Best Fit Line</label>
#>     <input id="plot-best.fit" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot-best.fit"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7460717', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a LOESS smoothed curve of best fit to the scatter plot'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify7234505">
#>   <label class="control-label" id="plot-line.best.smoothness-label" for="plot-line.best.smoothness">Best Fit Line Smoothness</label>
#>   <input id="plot-line.best.smoothness" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10000"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7234505', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Smoothing span for the LOESS curve; higher values produce a smoother, less wiggly fit'})}, 500)});</script>
#> <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify6145241">
#>   <label class="control-label" for="plot-line.best.colour">Best Fit Line Color</label>
#>   <input id="plot-line.best.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6145241', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for the LOESS best fit line'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify4739806">
#>   <div class="material-switch">
#>     <label for="plot-linear.model" style="padding-right: 10px;">Linear Model Line</label>
#>     <input id="plot-linear.model" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot-linear.model"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4739806', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Add a linear regression line to the scatter plot'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify5784610">
#>   <div class="material-switch">
#>     <label for="plot-custom.model.enable" style="padding-right: 10px;">Custom Model Lines</label>
#>     <input id="plot-custom.model.enable" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot-custom.model.enable"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5784610', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fit one or more custom models from formulas you define below and overlay them as lines. Only data columns and basic math/transform terms are allowed.'})}, 500)});</script>
#> <div class="multi-dynamic-input shiny-input-container form-group is-plain" id="plot-custom.models" data-keys="[&quot;model_type&quot;,&quot;formula&quot;,&quot;line_colour&quot;,&quot;line_width&quot;]" data-initial="[]" data-input-id="plot-custom.models" data-row-prefix="models">
#>   <div class="mdi-top">
#>     <label class="control-label" for="plot-custom.models">Models</label>
#>     <button type="button" class="mdi-add btn btn-default btn-sm">+ Add</button>
#>   </div>
#>   <div class="mdi-rows"></div>
#>   <template class="mdi-row-template">
#>     <div class="mdi-row">
#>       <div class="mdi-fields">
#>         <div class="mdi-field" data-key="model_type" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="plot-custom.models-__ROWIDX__-model_type-label" for="plot-custom.models-__ROWIDX__-model_type">Model type</label>
#>             <div>
#>               <select id="plot-custom.models-__ROWIDX__-model_type" class="shiny-input-select"><option value="glm">glm</option>
#> <option value="lm" selected>lm</option>
#> <option value="loess">loess</option>
#> <option value="nls">nls</option></select>
#>               <script type="application/json" data-for="plot-custom.models-__ROWIDX__-model_type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="mdi-field" data-key="formula" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="plot-custom.models-__ROWIDX__-formula-label" for="plot-custom.models-__ROWIDX__-formula">Formula</label>
#>             <input id="plot-custom.models-__ROWIDX__-formula" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. y ~ poly(x, 2)" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="mdi-field" data-key="line_colour" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="plot-custom.models-__ROWIDX__-line_colour">Line colour</label>
#>             <input id="plot-custom.models-__ROWIDX__-line_colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="mdi-field" data-key="line_width" style="flex: 1 1 calc(25% - 8px); min-width: 120px;">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="plot-custom.models-__ROWIDX__-line_width-label" for="plot-custom.models-__ROWIDX__-line_width">Line width</label>
#>             <input id="plot-custom.models-__ROWIDX__-line_width" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0.5" max="20" step="0.5"/>
#>           </div>
#>         </div>
#>       </div>
#>       <button type="button" class="mdi-delete" title="Delete this row" aria-label="Delete this row">&times;</button>
#>     </div>
#>   </template>
#> </div>
```
