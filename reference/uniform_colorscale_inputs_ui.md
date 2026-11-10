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
if (FALSE) { # interactive()
ns <- shiny::NS("plot1")
uniform_colorscale_inputs_ui(ns)
uniform_colorscale_inputs_ui(ns, defaults = list(
    colorscale.palette = "Viridis", colorscale.min = 0, colorscale.max = 1,
    colorbar.title = "Beta value"
))
}
```
