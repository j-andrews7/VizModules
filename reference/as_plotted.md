# Replace data columns with the values the modules plot for them

Applies
[`adjusted_values()`](https://j-andrews7.github.io/VizModules/reference/adjusted_values.md)
to each of `cols` in place, keeping the column names. Each column is
transformed on its own over the whole frame, as dittoViz does before any
row subsetting or multi-variable reshape, so the result can be passed
wherever the raw frame was (statistics, model formulas that name the raw
columns, axis-range calculations).

## Usage

``` r
as_plotted(df, cols, adjustment = NULL, adj.fxn = NULL)
```

## Arguments

- df:

  Data frame.

- cols:

  Character vector of column names to transform. Names not in `df` are
  ignored.

- adjustment, adj.fxn:

  Passed to
  [`adjusted_values()`](https://j-andrews7.github.io/VizModules/reference/adjusted_values.md).

## Value

`df` with `cols` transformed; unchanged when neither argument is set.

## See also

[`adjusted_values()`](https://j-andrews7.github.io/VizModules/reference/adjusted_values.md),
[`adjust_column_values()`](https://j-andrews7.github.io/VizModules/reference/adjust_column_values.md)

## Author

Jared Andrews

## Examples

``` r
as_plotted(data.frame(y = c(1, 10, 100)), "y", adjustment = "z-score", adj.fxn = "log10")
#>    y
#> 1 -1
#> 2  0
#> 3  1
```
