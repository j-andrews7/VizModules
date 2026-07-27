# Resolve number of rows for a faceted subplot grid

Given the number of facet levels and optional user-supplied `facet.nrow`
/ `facet.ncol` values, computes the `nrows` argument to pass to
[`plotly::subplot`](https://rdrr.io/pkg/plotly/man/subplot.html).

## Usage

``` r
resolve_facet_layout(n_facets, facet.nrow = NULL, facet.ncol = NULL)
```

## Arguments

- n_facets:

  Integer, number of facet panels.

- facet.nrow:

  Optional integer, user-requested number of rows.

- facet.ncol:

  Optional integer, user-requested number of columns.

## Value

A positive integer giving the number of rows for
[`plotly::subplot`](https://rdrr.io/pkg/plotly/man/subplot.html).

## Details

Resolution rules:

- Both `NULL`/`NA`: returns 1 (single row, preserves legacy behaviour).

- Only `facet.nrow` supplied: returns that value.

- Only `facet.ncol` supplied: returns `ceiling(n_facets / facet.ncol)`.

- Both supplied: `facet.nrow` wins.

The result is clamped to the range `[1, n_facets]`.

## Author

Jared Andrews

## Examples

``` r
resolve_facet_layout(6, facet.nrow = 2)
#> [1] 2
resolve_facet_layout(6, facet.ncol = 3)
#> [1] 2
```
