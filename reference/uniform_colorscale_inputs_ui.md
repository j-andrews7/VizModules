# Generate uniform Color Scale input UI

Creates a standardized tagList of the inputs that set a continuous
colour scale, for a plotly figure with a colorbar such as a heatmap:

## Usage

``` r
uniform_colorscale_inputs_ui(ns, defaults = NULL)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

## Value

A `tagList` containing the colour scale input UI elements.

## Details

- `colorscale.colors` - The five colour stops, lowest value first, as a
  [`multiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/multiColorPicker.md)
  (UI: "Color Scale", default: the "RdYlBu" preset). In `defaults`, five
  colours, named by stop or in order

- `colorscale.palette` - The preset selected, one of "RdYlBu", "Jet",
  "Blue-White-Red", "Viridis", "Magma", or "Cividis". Set in `defaults`
  only

- `colorscale.reverse` - Run the colours from high to low (UI: "Reverse
  Colors", default: FALSE)

- `colorscale.min` - Value at the lowest colour (UI: "Scale Min",
  default: NA, the data's minimum)

- `colorscale.mid` - Value at the middle colour (UI: "Scale Mid",
  default: NA, the centre of the limits)

- `colorscale.max` - Value at the highest colour (UI: "Scale Max",
  default: NA, the data's maximum)

- `colorbar.title` - Title of the colorbar (UI: "Colorbar Title",
  default: "Value")

Pass the inputs to
[`resolve_colorscale()`](https://j-andrews7.github.io/VizModules/reference/resolve_colorscale.md),
and restore them with
[`reset_colorscale_inputs()`](https://j-andrews7.github.io/VizModules/reference/reset_colorscale_inputs.md).
The picker's five stops are fixed, so it needs no
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) and no
[`setup_group_colors()`](https://j-andrews7.github.io/VizModules/reference/setup_group_colors.md)
store: read it directly, as `isolate_fn(input$colorscale.colors)`.

The colorbar's fonts and visibility follow the Legend tab, through
[`apply_legend_styling()`](https://j-andrews7.github.io/VizModules/reference/apply_legend_styling.md).

## See also

[`resolve_colorscale()`](https://j-andrews7.github.io/VizModules/reference/resolve_colorscale.md),
[`reset_colorscale_inputs()`](https://j-andrews7.github.io/VizModules/reference/reset_colorscale_inputs.md)

## Author

Jared Andrews

## Examples

``` r
ns <- shiny::NS("plot1")
uniform_colorscale_inputs_ui(ns)
#> <div class="multi-color-picker shiny-input-container form-group is-compact " id="plot1-colorscale.colors" data-palettes="{&quot;RdYlBu&quot;:[&quot;#2C7BB6&quot;,&quot;#ABD9E9&quot;,&quot;#FFFFBF&quot;,&quot;#FDAE61&quot;,&quot;#D7191C&quot;],&quot;Jet&quot;:[&quot;#0000FF&quot;,&quot;#00FFFF&quot;,&quot;#80FF80&quot;,&quot;#FFFF00&quot;,&quot;#FF0000&quot;],&quot;Blue-White-Red&quot;:[&quot;#2166AC&quot;,&quot;#92C5DE&quot;,&quot;#F7F7F7&quot;,&quot;#F4A582&quot;,&quot;#B2182B&quot;],&quot;Viridis&quot;:[&quot;#440154&quot;,&quot;#3B528B&quot;,&quot;#21908C&quot;,&quot;#5DC863&quot;,&quot;#FDE725&quot;],&quot;Magma&quot;:[&quot;#000004&quot;,&quot;#51127C&quot;,&quot;#B63679&quot;,&quot;#FB8861&quot;,&quot;#FCFDBF&quot;],&quot;Cividis&quot;:[&quot;#00224E&quot;,&quot;#434E6C&quot;,&quot;#7D7C78&quot;,&quot;#BCAF6F&quot;,&quot;#FEE838&quot;]}" data-initial="{&quot;Lowest&quot;:&quot;#2C7BB6&quot;,&quot;Low&quot;:&quot;#ABD9E9&quot;,&quot;Middle&quot;:&quot;#FFFFBF&quot;,&quot;High&quot;:&quot;#FDAE61&quot;,&quot;Highest&quot;:&quot;#D7191C&quot;}" data-groups="[&quot;Lowest&quot;,&quot;Low&quot;,&quot;Middle&quot;,&quot;High&quot;,&quot;Highest&quot;]" data-default-palette="RdYlBu" data-compact="true">
#>   <div class="mc-top">
#>     <label class="control-label" for="plot1-colorscale.colors">Color Scale</label>
#>     <div class="mc-actions">
#>       <select class="mc-palette-select form-control input-sm" aria-label="Palette">
#>         <option value="RdYlBu" selected="selected">RdYlBu</option>
#>         <option value="Jet">Jet</option>
#>         <option value="Blue-White-Red">Blue-White-Red</option>
#>         <option value="Viridis">Viridis</option>
#>         <option value="Magma">Magma</option>
#>         <option value="Cividis">Cividis</option>
#>       </select>
#>       <div class="mc-button-group">
#>         <button type="button" class="mc-button mc-apply-palette">Apply</button>
#>         <button type="button" class="mc-button mc-reset-palette">Reset</button>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="mc-swatch-row" role="list"></div>
#>   <div class="mc-color-rows">
#>     <div class="mc-color-row is-active" data-group="Lowest">
#>       <span class="mc-group-label">Lowest</span>
#>       <input type="color" class="mc-color-input" value="#2C7BB6" aria-label="Lowest color"/>
#>       <input type="text" class="mc-text-input form-control input-sm" value="#2C7BB6" aria-label="Lowest hex code"/>
#>     </div>
#>     <div class="mc-color-row " data-group="Low">
#>       <span class="mc-group-label">Low</span>
#>       <input type="color" class="mc-color-input" value="#ABD9E9" aria-label="Low color"/>
#>       <input type="text" class="mc-text-input form-control input-sm" value="#ABD9E9" aria-label="Low hex code"/>
#>     </div>
#>     <div class="mc-color-row " data-group="Middle">
#>       <span class="mc-group-label">Middle</span>
#>       <input type="color" class="mc-color-input" value="#FFFFBF" aria-label="Middle color"/>
#>       <input type="text" class="mc-text-input form-control input-sm" value="#FFFFBF" aria-label="Middle hex code"/>
#>     </div>
#>     <div class="mc-color-row " data-group="High">
#>       <span class="mc-group-label">High</span>
#>       <input type="color" class="mc-color-input" value="#FDAE61" aria-label="High color"/>
#>       <input type="text" class="mc-text-input form-control input-sm" value="#FDAE61" aria-label="High hex code"/>
#>     </div>
#>     <div class="mc-color-row " data-group="Highest">
#>       <span class="mc-group-label">Highest</span>
#>       <input type="color" class="mc-color-input" value="#D7191C" aria-label="Highest color"/>
#>       <input type="text" class="mc-text-input form-control input-sm" value="#D7191C" aria-label="Highest hex code"/>
#>     </div>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" id="tipify616548">
#>   <div class="material-switch">
#>     <label for="plot1-colorscale.reverse" style="padding-right: 10px;">Reverse Colors</label>
#>     <input id="plot1-colorscale.reverse" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot1-colorscale.reverse"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify616548', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Run the colors from the highest value to the lowest.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify6794862">
#>   <label class="control-label" id="plot1-colorscale.min-label" for="plot1-colorscale.min">Scale Min</label>
#>   <input id="plot1-colorscale.min" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6794862', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value at the lowest color. Empty for the minimum of the data.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify3781626">
#>   <label class="control-label" id="plot1-colorscale.mid-label" for="plot1-colorscale.mid">Scale Mid</label>
#>   <input id="plot1-colorscale.mid" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3781626', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value at the middle color. Empty for the center of the limits.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify5883703">
#>   <label class="control-label" id="plot1-colorscale.max-label" for="plot1-colorscale.max">Scale Max</label>
#>   <input id="plot1-colorscale.max" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5883703', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value at the highest color. Empty for the maximum of the data.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify4919785">
#>   <label class="control-label" id="plot1-colorbar.title-label" for="plot1-colorbar.title">Colorbar Title</label>
#>   <input id="plot1-colorbar.title" type="text" class="shiny-input-text form-control" value="Value" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4919785', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title of the colorbar.'})}, 500)});</script>
uniform_colorscale_inputs_ui(ns, defaults = list(
    colorscale.palette = "Viridis", colorscale.min = 0, colorscale.max = 1,
    colorbar.title = "Beta value"
))
#> <div class="multi-color-picker shiny-input-container form-group is-compact " id="plot1-colorscale.colors" data-palettes="{&quot;RdYlBu&quot;:[&quot;#2C7BB6&quot;,&quot;#ABD9E9&quot;,&quot;#FFFFBF&quot;,&quot;#FDAE61&quot;,&quot;#D7191C&quot;],&quot;Jet&quot;:[&quot;#0000FF&quot;,&quot;#00FFFF&quot;,&quot;#80FF80&quot;,&quot;#FFFF00&quot;,&quot;#FF0000&quot;],&quot;Blue-White-Red&quot;:[&quot;#2166AC&quot;,&quot;#92C5DE&quot;,&quot;#F7F7F7&quot;,&quot;#F4A582&quot;,&quot;#B2182B&quot;],&quot;Viridis&quot;:[&quot;#440154&quot;,&quot;#3B528B&quot;,&quot;#21908C&quot;,&quot;#5DC863&quot;,&quot;#FDE725&quot;],&quot;Magma&quot;:[&quot;#000004&quot;,&quot;#51127C&quot;,&quot;#B63679&quot;,&quot;#FB8861&quot;,&quot;#FCFDBF&quot;],&quot;Cividis&quot;:[&quot;#00224E&quot;,&quot;#434E6C&quot;,&quot;#7D7C78&quot;,&quot;#BCAF6F&quot;,&quot;#FEE838&quot;]}" data-initial="{&quot;Lowest&quot;:&quot;#440154&quot;,&quot;Low&quot;:&quot;#3B528B&quot;,&quot;Middle&quot;:&quot;#21908C&quot;,&quot;High&quot;:&quot;#5DC863&quot;,&quot;Highest&quot;:&quot;#FDE725&quot;}" data-groups="[&quot;Lowest&quot;,&quot;Low&quot;,&quot;Middle&quot;,&quot;High&quot;,&quot;Highest&quot;]" data-default-palette="Viridis" data-compact="true">
#>   <div class="mc-top">
#>     <label class="control-label" for="plot1-colorscale.colors">Color Scale</label>
#>     <div class="mc-actions">
#>       <select class="mc-palette-select form-control input-sm" aria-label="Palette">
#>         <option value="RdYlBu">RdYlBu</option>
#>         <option value="Jet">Jet</option>
#>         <option value="Blue-White-Red">Blue-White-Red</option>
#>         <option value="Viridis" selected="selected">Viridis</option>
#>         <option value="Magma">Magma</option>
#>         <option value="Cividis">Cividis</option>
#>       </select>
#>       <div class="mc-button-group">
#>         <button type="button" class="mc-button mc-apply-palette">Apply</button>
#>         <button type="button" class="mc-button mc-reset-palette">Reset</button>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="mc-swatch-row" role="list"></div>
#>   <div class="mc-color-rows">
#>     <div class="mc-color-row is-active" data-group="Lowest">
#>       <span class="mc-group-label">Lowest</span>
#>       <input type="color" class="mc-color-input" value="#440154" aria-label="Lowest color"/>
#>       <input type="text" class="mc-text-input form-control input-sm" value="#440154" aria-label="Lowest hex code"/>
#>     </div>
#>     <div class="mc-color-row " data-group="Low">
#>       <span class="mc-group-label">Low</span>
#>       <input type="color" class="mc-color-input" value="#3B528B" aria-label="Low color"/>
#>       <input type="text" class="mc-text-input form-control input-sm" value="#3B528B" aria-label="Low hex code"/>
#>     </div>
#>     <div class="mc-color-row " data-group="Middle">
#>       <span class="mc-group-label">Middle</span>
#>       <input type="color" class="mc-color-input" value="#21908C" aria-label="Middle color"/>
#>       <input type="text" class="mc-text-input form-control input-sm" value="#21908C" aria-label="Middle hex code"/>
#>     </div>
#>     <div class="mc-color-row " data-group="High">
#>       <span class="mc-group-label">High</span>
#>       <input type="color" class="mc-color-input" value="#5DC863" aria-label="High color"/>
#>       <input type="text" class="mc-text-input form-control input-sm" value="#5DC863" aria-label="High hex code"/>
#>     </div>
#>     <div class="mc-color-row " data-group="Highest">
#>       <span class="mc-group-label">Highest</span>
#>       <input type="color" class="mc-color-input" value="#FDE725" aria-label="Highest color"/>
#>       <input type="text" class="mc-text-input form-control input-sm" value="#FDE725" aria-label="Highest hex code"/>
#>     </div>
#>   </div>
#> </div>
#> <div class="form-group shiny-input-container" id="tipify2857770">
#>   <div class="material-switch">
#>     <label for="plot1-colorscale.reverse" style="padding-right: 10px;">Reverse Colors</label>
#>     <input id="plot1-colorscale.reverse" type="checkbox"/>
#>     <label class="switch label-success bg-success" for="plot1-colorscale.reverse"></label>
#>   </div>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2857770', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Run the colors from the highest value to the lowest.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify84196">
#>   <label class="control-label" id="plot1-colorscale.min-label" for="plot1-colorscale.min">Scale Min</label>
#>   <input id="plot1-colorscale.min" type="number" class="shiny-input-number form-control" value="0" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify84196', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value at the lowest color. Empty for the minimum of the data.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify5507743">
#>   <label class="control-label" id="plot1-colorscale.mid-label" for="plot1-colorscale.mid">Scale Mid</label>
#>   <input id="plot1-colorscale.mid" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5507743', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value at the middle color. Empty for the center of the limits.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify8132309">
#>   <label class="control-label" id="plot1-colorscale.max-label" for="plot1-colorscale.max">Scale Max</label>
#>   <input id="plot1-colorscale.max" type="number" class="shiny-input-number form-control" value="1" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8132309', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Value at the highest color. Empty for the maximum of the data.'})}, 500)});</script>
#> <div class="form-group shiny-input-container" id="tipify6435746">
#>   <label class="control-label" id="plot1-colorbar.title-label" for="plot1-colorbar.title">Colorbar Title</label>
#>   <input id="plot1-colorbar.title" type="text" class="shiny-input-text form-control" value="Beta value" data-update-on="change"/>
#> </div>
#> <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6435746', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Title of the colorbar.'})}, 500)});</script>
```
