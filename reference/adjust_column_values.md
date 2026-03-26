# Adjust numeric column values in a data frame using mathematical transformations

Applies a named mathematical transformation to a specified numeric
column in a data frame, adding the transformed values as a new column
(original column name + ".adj"). The transformation name must be one of
the allowed functions listed in `safe_resolve_adj_fxn` (e.g., "log2",
"log10", "sqrt", "abs", "as.factor"). The original data frame is
returned unchanged if no transformation is specified or if the supplied
name is invalid.

## Usage

``` r
adjust_column_values(
  df,
  x.col = NULL,
  y.col = NULL,
  color.col = NULL,
  x.adj.fun = NULL,
  y.adj.fun = NULL,
  color.adj.fun = NULL
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

## Value

A data frame identical to input `df` but with transformed columns added
(e.g., `mpg.adj`) when valid transformations are specified.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
data(mtcars)
mtcars_mod <- adjust_column_values(mtcars, x.col = "mpg", x.adj.fun = "log2")
head(mtcars_mod$mpg.adj)
#> [1] 4.392317 4.392317 4.510962 4.419539 4.224966 4.177918
```
