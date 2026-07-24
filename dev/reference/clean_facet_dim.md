# Clean and validate facet dimension value for lineplot module

Internal helper function that validates and sanitizes a numeric value
intended for use as a **facet dimension** (rows or columns) in a
**ggplot2 faceting layout**. Ensures the value is a positive numeric
greater than or equal to 1, returning `NULL` for invalid inputs to
gracefully handle missing or malformed facet specifications.

## Usage

``` r
clean_facet_dim(val)
```

## Arguments

- val:

  `numeric(1)` or `NULL` Proposed facet dimension value (number of rows
  or columns).

## Value

`numeric(1)` or `NULL` Validated facet dimension value, or `NULL` if
invalid.

## Details

This function is used within **VizModules** lineplot functions to
process user-supplied facet dimensions before passing to `facet_grid()`
or `facet_wrap()`. Invalid values trigger sensible defaults rather than
breaking the plot layout. **Valid inputs** return unchanged. **Invalid
inputs** (NULL, NA, non-numeric, \< 1) return `NULL`.

## Author

Jacob Martin

## Examples

``` r
clean_facet_dim(3)
#> [1] 3
clean_facet_dim(NA)
#> NULL
clean_facet_dim(NULL)
#> NULL
```
