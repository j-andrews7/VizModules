# Generate uniform Legend input UI

Creates a standardized tagList of legend inputs used across plot
modules, so the legend can be shown/hidden and styled consistently
regardless of plot type:

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

## Details

- `legend.show` - Show the legend, colorbars and any size legend (UI:
  "Show Legend", default: TRUE)

- `legend.font.family` - Font family of the legend title and labels (UI:
  "Legend Font", default: "Arial")

- `legend.font.color` - Font color of the legend title and labels (UI:
  "Legend Font Color", default: "#000000")

- `legend.title.size` - Font size of the legend title (UI: "Legend Title
  Size", default: 14)

- `legend.text.size` - Font size of the legend entry labels (UI: "Legend
  Text Size", default: 12)

Apply them to a figure with
[`apply_legend_inputs()`](https://j-andrews7.github.io/VizModules/reference/apply_legend_inputs.md)
and restore them with
[`reset_legend_inputs()`](https://j-andrews7.github.io/VizModules/reference/reset_legend_inputs.md).

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
ns <- shiny::NS("plot1")
uniform_legend_inputs_ui(ns)
uniform_legend_inputs_ui(ns, defaults = list(
    legend.show = FALSE, legend.font.family = "Courier New",
    legend.title.size = 16, legend.text.size = 12
))
}
```
