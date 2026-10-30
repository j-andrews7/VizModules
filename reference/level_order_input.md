# Drag-and-drop control for the order of a categorical axis

A
[`shinyjqui::orderInput()`](https://yang-tang.github.io/shinyjqui/reference/orderInput.html)
laid out to fill one
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)
grid cell, listing the levels of a categorical column as buttons that
can be dragged into the order they should be plotted in. Its value is
the levels in their current order, a character vector.

## Usage

``` r
level_order_input(
  inputId,
  label = "X Order",
  items = NULL,
  tooltip = NULL,
  width = "100%"
)
```

## Arguments

- inputId:

  The input ID, namespaced as for any other input (e.g.
  `ns("x.order")`).

- label:

  The label shown above the control.

- items:

  Character vector of levels to show, in order, typically from
  [`level_order_choices()`](https://j-andrews7.github.io/VizModules/reference/level_order_choices.md).
  `NULL` or empty renders an empty, hidden control.

- tooltip:

  Optional tooltip text shown on hover.

- width:

  The CSS width of the control.

## Value

A `shiny.tag` wrapping the order input.

## Details

The control hides its grid cell whenever it has no items, which is how
[`setup_level_order()`](https://j-andrews7.github.io/VizModules/reference/setup_level_order.md)
takes it off screen for a column it cannot order (a numeric one, or one
with more levels than are practical to drag). A cell hidden with
[`hide_input()`](https://j-andrews7.github.io/VizModules/reference/hide_input.md)
stays hidden either way.

## See also

[`level_order_choices()`](https://j-andrews7.github.io/VizModules/reference/level_order_choices.md),
[`apply_level_order()`](https://j-andrews7.github.io/VizModules/reference/apply_level_order.md),
[`setup_level_order()`](https://j-andrews7.github.io/VizModules/reference/setup_level_order.md)

## Author

Jared Andrews

## Examples

``` r
level_order_input("x.order", "X Order", items = c("Healthy", "Disease"))
#> <div class="vizmodules-level-order">
#>   <label class="control-label" id="x.order-label" for="x.order">X Order</label>
#>   <div id="x.order" style="width: 100%; font-size: 0px; min-height: 25px;" class="jqui-orderInput">
#>     <div data-value="Healthy" class="btn btn-default" style="margin: 1px">Healthy</div>
#>     <div data-value="Disease" class="btn btn-default" style="margin: 1px">Disease</div>
#>   </div>
#>   <iframe srcdoc="&lt;p&gt;cant catch me&lt;/p&gt;" class="jqui_self_cleaning_script" style="width:0;height:0;border:none;display:none !important" onload="$(function(){setTimeout(function(){shinyjqui.msgCallback({&quot;ui&quot;:&quot;[id=&#39;x.order&#39;]&quot;,&quot;type&quot;:&quot;interaction&quot;,&quot;func&quot;:&quot;sortable&quot;,&quot;operation&quot;:&quot;enable&quot;,&quot;options&quot;:{&quot;connectWith&quot;:&quot;false&quot;,&quot;remove&quot;:&quot;function(e, ui){if(!$(e.target).children().length)$(e.target).empty();}&quot;},&quot;debug&quot;:false,&quot;_js_idx&quot;:{&quot;ui&quot;:false,&quot;type&quot;:false,&quot;func&quot;:false,&quot;operation&quot;:false,&quot;options&quot;:{&quot;connectWith&quot;:false,&quot;remove&quot;:true},&quot;debug&quot;:false}});&#10;      $(&quot;.jqui_self_cleaning_script&quot;).remove();}, 10);});"></iframe>
#> </div>

# The items for a column of a data frame, in the order they are drawn by default
level_order_input("x.order", "X Order",
    items = level_order_choices(example_iris, "Species")
)
#> <div class="vizmodules-level-order">
#>   <label class="control-label" id="x.order-label" for="x.order">X Order</label>
#>   <div id="x.order" style="width: 100%; font-size: 0px; min-height: 25px;" class="jqui-orderInput">
#>     <div data-value="setosa" class="btn btn-default" style="margin: 1px">setosa</div>
#>     <div data-value="versicolor" class="btn btn-default" style="margin: 1px">versicolor</div>
#>     <div data-value="virginica" class="btn btn-default" style="margin: 1px">virginica</div>
#>   </div>
#>   <iframe srcdoc="&lt;p&gt;cant catch me&lt;/p&gt;" class="jqui_self_cleaning_script" style="width:0;height:0;border:none;display:none !important" onload="$(function(){setTimeout(function(){shinyjqui.msgCallback({&quot;ui&quot;:&quot;[id=&#39;x.order&#39;]&quot;,&quot;type&quot;:&quot;interaction&quot;,&quot;func&quot;:&quot;sortable&quot;,&quot;operation&quot;:&quot;enable&quot;,&quot;options&quot;:{&quot;connectWith&quot;:&quot;false&quot;,&quot;remove&quot;:&quot;function(e, ui){if(!$(e.target).children().length)$(e.target).empty();}&quot;},&quot;debug&quot;:false,&quot;_js_idx&quot;:{&quot;ui&quot;:false,&quot;type&quot;:false,&quot;func&quot;:false,&quot;operation&quot;:false,&quot;options&quot;:{&quot;connectWith&quot;:false,&quot;remove&quot;:true},&quot;debug&quot;:false}});&#10;      $(&quot;.jqui_self_cleaning_script&quot;).remove();}, 10);});"></iframe>
#> </div>
```
