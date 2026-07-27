# Resolve facet axis sharing from facet.scales

Converts a `facet.scales` string (one of `"fixed"`, `"free"`,
`"free_x"`, `"free_y"`) into the `shareX` / `shareY` logical values
expected by
[`plotly::subplot`](https://rdrr.io/pkg/plotly/man/subplot.html).

## Usage

``` r
resolve_facet_sharing(facet.scales = "fixed")
```

## Arguments

- facet.scales:

  Character, one of `"fixed"` (default), `"free"`, `"free_x"`, or
  `"free_y"`.

## Value

A named list with logical elements `shareX` and `shareY`.

## Author

Jared Andrews

## Examples

``` r
resolve_facet_sharing("fixed")
#> $shareX
#> [1] TRUE
#> 
#> $shareY
#> [1] TRUE
#> 
resolve_facet_sharing("free_x")
#> $shareX
#> [1] FALSE
#> 
#> $shareY
#> [1] TRUE
#> 
```
