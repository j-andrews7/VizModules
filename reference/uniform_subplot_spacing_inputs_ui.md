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
if (FALSE) { # interactive()
uniform_subplot_spacing_inputs_ui(shiny::NS("spacing"), defaults = list(subplot.margin = 0.05))
}
```
