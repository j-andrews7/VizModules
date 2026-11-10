# The "Plot with WebGL" toggle for a module's point layers

On (the default), the plot's points switch to WebGL once there are
enough of them (see
[`auto_webgl()`](https://j-andrews7.github.io/VizModules/reference/auto_webgl.md));
off, they always stay SVG, so SVG downloads stay fully vector. Read it
in the module's plot step with `!isFALSE(isolate_fn(input$webgl))`, so a
client that has not reported it yet counts as on.

## Usage

``` r
webgl_input(ns, defaults = NULL)
```

## Arguments

- ns:

  The module's namespace function.

- defaults:

  The module's `defaults`, whose `webgl` entry sets the value.

## Value

A tooltipped checkbox input with id `webgl`.

## See also

[`auto_webgl()`](https://j-andrews7.github.io/VizModules/reference/auto_webgl.md)

## Author

Jared Andrews

## Examples

``` r
webgl_input(shiny::NS("plot"))
#> <div class="form-group shiny-input-container" id="tipify6006700">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-webgl" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>       <span>Plot with WebGL</span>
#>     </label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6006700', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw the points with WebGL once the plot has 5,000 or more, which is much faster with large data. In SVG downloads, WebGL points are an embedded image rather than vector shapes; turn this off for a fully vector file.'})}, 500)});</script>
webgl_input(shiny::NS("plot"), defaults = list(webgl = FALSE))
#> <div class="form-group shiny-input-container" id="tipify1516763">
#>   <div class="checkbox">
#>     <label>
#>       <input id="plot-webgl" type="checkbox" class="shiny-input-checkbox"/>
#>       <span>Plot with WebGL</span>
#>     </label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1516763', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Draw the points with WebGL once the plot has 5,000 or more, which is much faster with large data. In SVG downloads, WebGL points are an embedded image rather than vector shapes; turn this off for a fully vector file.'})}, 500)});</script>
```
