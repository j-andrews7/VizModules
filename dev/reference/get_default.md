# Resolve a default value from a named list

Looks up `key` in `defaults`. If present and passes `validator` (when
supplied), returns the stored value; otherwise returns `fallback`. Uses
standard `if`/`else` instead of vectorized
[`ifelse()`](https://rdrr.io/r/base/ifelse.html) to avoid silent
truncation of multi-valued defaults.

## Usage

``` r
get_default(defaults, key, fallback, validator = NULL)
```

## Arguments

- defaults:

  A named list of default values, or NULL.

- key:

  Character string — the name to look up.

- fallback:

  The value to return when `key` is absent or fails validation.

- validator:

  An optional single-argument predicate function (e.g., `is.numeric`,
  `is.logical`). When supplied, the stored value is returned only if
  `validator(value)` is `TRUE`.

## Value

The resolved default value or `fallback`.

## Author

Jared Andrews

## Examples

``` r
get_default(list(color = "red"), "color", "black")
#> [1] "red"
get_default(list(), "missing", 10)
#> [1] 10
get_default(list(n = "x"), "n", 5, is.numeric)
#> [1] 5
```
