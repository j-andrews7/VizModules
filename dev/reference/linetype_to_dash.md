# Convert linetype name to plotly dash style

Maps common linetype names to plotly dash specifications.

## Usage

``` r
linetype_to_dash(linetype)
```

## Arguments

- linetype:

  Character. Linetype name: "solid", "dashed", "dotted", "dotdash",
  "longdash", "twodash".

## Value

Character. Plotly-compatible dash specification.

## Author

Jared Andrews

## Examples

``` r
linetype_to_dash("dashed")
#> [1] "dash"
linetype_to_dash("dotted")
#> [1] "dot"
```
