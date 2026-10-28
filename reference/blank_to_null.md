# Normalize a module's "no selection" column input to `NULL`

Module selects use `""` for "none". Statistics helpers expect `NULL`,
and a grouping column that is numeric is a gradient rather than a
nesting, which the renders already treat as no grouping.

## Usage

``` r
blank_to_null(value, df = NULL, numeric_is_null = FALSE)
```

## Arguments

- value:

  The input value.

- df:

  Optional data frame, needed only for `numeric_is_null`.

- numeric_is_null:

  Logical; when `TRUE`, a numeric column in `df` also yields `NULL`.

## Value

`value`, or `NULL`.

## Details

Anything that is not a single, non-`NA`, non-empty value gives `NULL`:
an input that has not reported yet (`NULL`), `NA`, `""` and a vector of
more than one value alike. A multi-select therefore reads as "no
selection", so handle those inputs explicitly.

## See also

[`nz_value()`](https://j-andrews7.github.io/VizModules/reference/nz_value.md),
[`na_to_null()`](https://j-andrews7.github.io/VizModules/reference/na_to_null.md)

## Author

Jared Andrews

## Examples

``` r
blank_to_null("")
#> NULL
blank_to_null(NULL)
#> NULL
blank_to_null("Species")
#> [1] "Species"
blank_to_null("Sepal.Length", df = iris, numeric_is_null = TRUE)
#> NULL
```
