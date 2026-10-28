# Is an input's value a usable, non-empty string?

The check for the column-selecting inputs, whose "nothing chosen" state
is the empty string rather than `NULL`. A Shiny input that has not
reported yet is `NULL`, and both `nzchar(NULL)` and `NULL == ""` are
`logical(0)`, which makes `if (...)` an error rather than `FALSE`; this
returns `FALSE` instead.

## Usage

``` r
nz_value(x)
```

## Arguments

- x:

  A value from a Shiny input.

## Value

`TRUE` for a length-1, non-`NA`, non-empty character scalar; `FALSE` for
anything else, `NULL` included.

## See also

[`blank_to_null()`](https://j-andrews7.github.io/VizModules/reference/blank_to_null.md)

## Author

Jared Andrews

## Examples

``` r
nz_value(NULL)
#> [1] FALSE
nz_value("")
#> [1] FALSE
nz_value(NA_character_)
#> [1] FALSE
nz_value("Species")
#> [1] TRUE
```
