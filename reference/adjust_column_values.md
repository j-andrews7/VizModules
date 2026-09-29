# Adjust numeric column values in a data frame using mathematical transformations

Transforms the named numeric columns of a data frame the way the plot
modules do for their adjustment inputs, adding the transformed values as
a new column (original column name + ".adj"). The function is applied
first, then an adjustment (`"z-score"` or `"relative.to.max"`) rescales
the result, computed over its finite values. The function name must be
one of the allowed functions listed in
[`safe_resolve_adj_fxn()`](https://j-andrews7.github.io/VizModules/reference/safe_resolve_adj_fxn.md)
(e.g., "log2", "log10", "sqrt", "abs", "as.factor"). The original data
frame is returned unchanged if no transformation is specified or if the
supplied function name is invalid.

## Usage

``` r
adjust_column_values(
  df,
  x.col = NULL,
  y.col = NULL,
  color.col = NULL,
  x.adj.fun = NULL,
  y.adj.fun = NULL,
  color.adj.fun = NULL,
  x.adjustment = NULL,
  y.adjustment = NULL,
  color.adjustment = NULL
)
```

## Arguments

- df:

  A data frame containing the column to be transformed.

- x.col:

  Character scalar. Name of the column for x‑axis values (optional).

- y.col:

  Character scalar. Name of the column for y‑axis values (optional).

- color.col:

  Character scalar. Name of the column for color values (optional).

- x.adj.fun:

  Character scalar. Name of a transformation function to apply to x‑axis
  values, as accepted by `safe_resolve_adj_fxn` (e.g., "log2", "log10",
  "sqrt"). If `NULL` or an empty string, x‑axis values are left
  unchanged.

- y.adj.fun:

  Character scalar. Name of a transformation function to apply to y‑axis
  values, as accepted by `safe_resolve_adj_fxn`. If `NULL` or an empty
  string, y‑axis values are left unchanged.

- color.adj.fun:

  Character scalar. Name of a transformation function to apply to color
  values, as accepted by `safe_resolve_adj_fxn`. If `NULL` or an empty
  string, color values are left unchanged.

- x.adjustment, y.adjustment, color.adjustment:

  Character scalar. `"z-score"` or `"relative.to.max"` to rescale that
  column after its function is applied. If `NULL` or an empty string, no
  rescaling is done.

## Value

A data frame identical to input `df` but with transformed columns added
(e.g., `mpg.adj`) when valid transformations are specified.

## Details

Use this to compute anything drawn over an adjusted plot (axis limits,
bracket headroom, fit lines) from the values the plot actually shows,
rather than the raw column. Note that dittoViz, given both an
`*.adjustment` and an `*.adj.fxn`, applies them in the opposite order;
the modules pass it the whole transform as its function instead.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
data(mtcars)
mtcars_mod <- adjust_column_values(mtcars, x.col = "mpg", x.adj.fun = "log2")
head(mtcars_mod$mpg.adj)
#> [1] 4.392317 4.392317 4.510962 4.419539 4.224966 4.177918

# log10 first, then z-scored: the values the scatter module draws for that pair
mtcars_z <- adjust_column_values(mtcars,
    x.col = "hp", x.adj.fun = "log10", x.adjustment = "z-score"
)
range(mtcars_z$hp.adj)
#> [1] -1.958356  1.961584
```
