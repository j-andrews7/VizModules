# Transform values the way the modules plot them

The adjustment function (`adj.fxn`, e.g. `log10`) is applied first, then
the `adjustment` rescales the result (`"z-score"` or
`"relative.to.max"`). That is the order a transform and a
standardisation are normally combined in: log first, then z-score.
dittoViz applies them the other way round when given both, which turns
every below-average value into
[`log()`](https://rdrr.io/r/base/Log.html) of a negative number, so the
modules hand dittoViz this whole transform as its function instead (see
[`adjustment_fn()`](https://j-andrews7.github.io/VizModules/reference/adjustment_fn.md)).

## Usage

``` r
adjusted_values(values, adjustment = NULL, adj.fxn = NULL)
```

## Arguments

- values:

  Vector of values, normally one column of the plotted data.

- adjustment:

  `NULL`, `""`, `"z-score"` or `"relative.to.max"`.

- adj.fxn:

  `NULL`, `""`, a name accepted by
  [`safe_resolve_adj_fxn()`](https://j-andrews7.github.io/VizModules/reference/safe_resolve_adj_fxn.md),
  or a function.

## Value

The transformed values, unnamed.

## Details

The rescaling is computed over the finite values only, so a value the
function makes non-finite (`log(0)`) is dropped from the plot rather
than turning the whole column into `NaN`.

Anything drawn over an adjusted plot (significance brackets, fit lines,
axis limits) has to be computed from these values, not the raw column,
or it lands in a different coordinate space from the data.

## See also

[`adjustment_fn()`](https://j-andrews7.github.io/VizModules/reference/adjustment_fn.md),
[`as_plotted()`](https://j-andrews7.github.io/VizModules/reference/as_plotted.md),
[`adjust_column_values()`](https://j-andrews7.github.io/VizModules/reference/adjust_column_values.md)

## Author

Jared Andrews

## Examples

``` r
adjusted_values(c(1, 10, 100), adjustment = "z-score", adj.fxn = "log10")
#> [1] -1  0  1
adjusted_values(c(1, 2, 4), adjustment = "relative.to.max")
#> [1] 0.25 0.50 1.00
```
