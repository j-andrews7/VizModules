# Generate uniform Legend input UI

Creates a standardized tagList of legend styling inputs used across plot
modules. Currently exposes the legend title and entry label font sizes
so they can be adjusted consistently regardless of plot type.

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

## Author

Jared Andrews

## Examples

``` r
ns <- shiny::NS("plot1")
uniform_legend_inputs_ui(ns)
#> <div class="form-group shiny-input-container" id="tipify6229228">
#>   <label class="control-label" id="plot1-legend.title.size-label" for="plot1-legend.title.size">Legend Title Size</label>
#>   <input id="plot1-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6229228', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify4607475">
#>   <label class="control-label" id="plot1-legend.text.size-label" for="plot1-legend.text.size">Legend Text Size</label>
#>   <input id="plot1-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4607475', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
uniform_legend_inputs_ui(ns, defaults = list(legend.title.size = 16, legend.text.size = 12))
#> <div class="form-group shiny-input-container" id="tipify1634123">
#>   <label class="control-label" id="plot1-legend.title.size-label" for="plot1-legend.title.size">Legend Title Size</label>
#>   <input id="plot1-legend.title.size" type="number" class="shiny-input-number form-control" value="16" data-update-on="change" min="0" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1634123', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify5138669">
#>   <label class="control-label" id="plot1-legend.text.size-label" for="plot1-legend.text.size">Legend Text Size</label>
#>   <input id="plot1-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5138669', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
```
