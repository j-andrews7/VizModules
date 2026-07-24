# Recycle style vector to match line count

Extends or truncates a style vector to match the number of lines being
drawn. If the input length doesn't match the target length, uses only
the first value for all lines (as documented behavior).

## Usage

``` r
recycle_line_style(values, n, default)
```

## Arguments

- values:

  Vector. Style values (colors, widths, etc.) to recycle.

- n:

  Integer. Target length (number of lines).

- default:

  The default value to use if values is NULL or empty.

## Value

A vector of length n with recycled values.

## Author

Jared Andrews

## Examples

``` r
recycle_line_style(c("red", "blue"), 2, "black")
#> [1] "red"  "blue"
recycle_line_style(NULL, 3, "black")
#> [1] "black" "black" "black"
```
