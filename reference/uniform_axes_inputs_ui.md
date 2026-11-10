# Generate uniform Axes input UI

Creates a standardized tagList of axis-related inputs for use across
plot modules.

## Usage

``` r
uniform_axes_inputs_ui(
  ns,
  defaults = NULL,
  include.rotate = FALSE,
  include.flip = FALSE,
  include.padding = c("x", "y")
)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

- include.rotate:

  Logical; whether to include the "Rotate" input for swapping x and y
  axes (e.g., horizontal bar plots). Default is FALSE.

- include.flip:

  Logical; whether to include the "Flip" input for flipping the axis.
  Default is FALSE.

- include.padding:

  Which of `"x"` and `"y"` get an axis padding input (`axis.padding.x`,
  `axis.padding.y`; see
  [`apply_axis_padding()`](https://j-andrews7.github.io/VizModules/reference/apply_axis_padding.md)).
  Leave out an axis that has its own limit inputs. Default is both.

## Value

A `tagList` containing the axis input UI elements.

## Details

Alongside the fonts, lines, gridlines, and ticks, the inputs include
`axis.scientific`, which writes numeric tick labels in scientific
notation (off by default, so they never switch to it on their own; see
[`apply_tick_notation()`](https://j-andrews7.github.io/VizModules/reference/apply_tick_notation.md)),
and `axis.padding.x`/`axis.padding.y`, the space between the data and
the edges of the plot area as a fraction of the data's extent at each
end (blank keeps the plot's own padding).

## Author

Jared Andrews Jacob Martin

## Examples

``` r
if (FALSE) { # interactive()
ns <- shiny::NS("plot")
uniform_axes_inputs_ui(ns)
uniform_axes_inputs_ui(ns, include.rotate = TRUE, include.flip = TRUE)
# A plot with its own y-axis limit inputs: x padding only.
uniform_axes_inputs_ui(ns, include.padding = "x")
}
```
