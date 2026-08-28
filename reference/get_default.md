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

  A named list of default values, or NULL. Individual entries may be a
  [`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)/`reactiveVal`.

- key:

  Character string — the name to look up.

- fallback:

  The value to return when `key` is absent or fails validation.

- validator:

  An optional single-argument predicate function (e.g., `is.numeric`,
  `is.logical`). When supplied, the stored value is returned only if
  `validator(value)` is `TRUE`. Reactive entries are validated on their
  resolved value.

## Value

The resolved default value or `fallback`.

## Details

Entries that are a
[`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
[`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
are resolved with
[`shiny::isolate()`](https://rdrr.io/pkg/shiny/man/isolate.html) before
validation, so this returns the reactive's *current* value. See
[`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md)
for how modules keep such entries live at render time.

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
get_default(list(color = shiny::reactiveVal("blue")), "color", "black")
#> [1] "blue"
```
