# Resolve the subplot spacing defaults

Shared by
[`uniform_subplot_spacing_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_subplot_spacing_inputs_ui.md)
and
[`reset_plotly_inputs()`](https://j-andrews7.github.io/VizModules/reference/reset_plotly_inputs.md)
so the controls start and reset to the same values. A `subplot.margin`
entry sets both directions at once (linePlot uses it for its tighter
default); `subplot.margin.x`/`subplot.margin.y` override it per
direction.

## Usage

``` r
subplot_spacing_defaults(defaults)
```

## Arguments

- defaults:

  A named list of default values, or `NULL`.

## Value

A list with numeric `x` and `y`.

## Author

Jared Andrews

## Examples

``` r
subplot_spacing_defaults(NULL)
#> $x
#> [1] 0.03
#> 
#> $y
#> [1] 0.1
#> 
subplot_spacing_defaults(list(subplot.margin = 0.05, subplot.margin.y = 0.2))
#> $x
#> [1] 0.05
#> 
#> $y
#> [1] 0.2
#> 
```
