# Generate uniform subplot spacing input UI

Creates a standardized tagList of the horizontal/vertical subplot
spacing inputs. These controls only have an effect when faceting is
active, so they are rendered within each module's "Facet" tab.

## Usage

``` r
uniform_subplot_spacing_inputs_ui(ns, defaults = NULL)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

## Value

A `tagList` containing the subplot spacing input UI elements.

## See also

[`subplot_spacing_defaults()`](https://j-andrews7.github.io/VizModules/reference/subplot_spacing_defaults.md),
[`apply_facet_subplot_spacing()`](https://j-andrews7.github.io/VizModules/reference/apply_facet_subplot_spacing.md),
[`reset_plotly_inputs()`](https://j-andrews7.github.io/VizModules/reference/reset_plotly_inputs.md)

## Author

Jared Andrews

## Examples

``` r
uniform_subplot_spacing_inputs_ui(shiny::NS("spacing"), defaults = list(subplot.margin = 0.05))
#> <div class="form-group shiny-input-container" id="tipify7279052">
#>   <label class="control-label" id="spacing-subplot.margin.x-label" for="spacing-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>   <input id="spacing-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7279052', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify5457234">
#>   <label class="control-label" id="spacing-subplot.margin.y-label" for="spacing-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>   <input id="spacing-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5457234', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
```
