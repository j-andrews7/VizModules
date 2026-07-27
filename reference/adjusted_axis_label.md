# Build an adjustment-aware axis label

Wraps a base column name with the names of any data adjustments that are
applied to it before plotting, so that an axis title accurately
describes the values displayed. The wrapping order mirrors how the
adjustments are applied in dittoViz (the recognized `adjustment` is
applied first, then the `adj.fxn`), producing labels such as
`"log2(z-score(units))"`.

## Usage

``` r
adjusted_axis_label(base, adjustment = NULL, adj.fxn = NULL)
```

## Arguments

- base:

  Character scalar. The base axis label (typically the column name).

- adjustment:

  Character scalar. A recognized data adjustment such as `"z-score"` or
  `"relative.to.max"`. Optional.

- adj.fxn:

  Character scalar. The name of a transformation function such as
  `"log2"` or `"sqrt"`. Optional.

## Value

A character scalar containing the (possibly wrapped) axis label.

## Details

Empty strings, `NA`, and `NULL` adjustments are ignored, so when no
adjustment is requested the base label is returned unchanged.

## Author

Jared Andrews

## Examples

``` r
adjusted_axis_label("units")
#> [1] "units"
adjusted_axis_label("units", adjustment = "z-score")
#> [1] "z-score(units)"
adjusted_axis_label("units", adjustment = "z-score", adj.fxn = "log2")
#> [1] "log2(z-score(units))"
```
