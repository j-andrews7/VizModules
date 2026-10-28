# The whole plotted transform as one function, for dittoViz

dittoViz applies its `*.adjustment` before its `*.adj.fxn`. Passing it
this function as `*.adj.fxn`, with no `*.adjustment`, has it plot
[`adjusted_values()`](https://j-andrews7.github.io/VizModules/reference/adjusted_values.md)
instead, while it still builds its adjusted columns, hover text and
multi-variable reshape as usual.

## Usage

``` r
adjustment_fn(adjustment = NULL, adj.fxn = NULL)
```

## Arguments

- adjustment, adj.fxn:

  Passed to
  [`adjusted_values()`](https://j-andrews7.github.io/VizModules/reference/adjusted_values.md).

## Value

A function of one vector, or `NULL` when neither is set.

## See also

[`adjusted_values()`](https://j-andrews7.github.io/VizModules/reference/adjusted_values.md),
[`as_plotted()`](https://j-andrews7.github.io/VizModules/reference/as_plotted.md)

## Author

Jared Andrews

## Examples

``` r
fn <- adjustment_fn(adjustment = "z-score", adj.fxn = "log10")
fn(c(1, 10, 100))
#> [1] -1  0  1
adjustment_fn()
#> NULL
```
