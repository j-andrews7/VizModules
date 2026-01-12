# Adjust numeric column values in a data frame using mathematical transformations

Applies supplied transformation to a specified numeric column in a data
frame, adding the transformation as a new column. Returns original data
frame unchanged when no transformation is specified or input is invalid.

## Usage

``` r
.adjust_column_values(
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

  A data frame containing the column to be transformed

- x.col:

  Character. Name of the column for x-axis values.

- y.col:

  Character. Name of the column for y-axis values.

- color.col:

  Character. Name of the column for color values.

- x.adj.fun:

  Character. Transformation function to apply to x-axis values,
  interpretable by `eval`.

- y.adj.fun:

  Character. Transformation function to apply to y-axis values,
  interpretable by `eval`.

- color.adj.fun:

  Character. Transformation function to apply to color values,
  interpretable by `eval`.

## Value

A data frame identical to input `df` but with transformed columns added.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
data(mtcars)
mtcars_mod <- .adjust_column_values(mtcars, x.col = "mpg", x.adj.fun = "log2")
head(mtcars_mod$mpg.adj)
#> [1] 4.392317 4.392317 4.510962 4.419539 4.224966 4.177918
```
