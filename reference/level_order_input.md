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
if (FALSE) { # interactive()
level_order_input("x.order", "X Order", items = c("Healthy", "Disease"))

# The items for a column of a data frame, in the order they are drawn by default
level_order_input("x.order", "X Order",
    items = level_order_choices(example_iris, "Species")
)
}
```
