# Convert NA or empty string to NULL

A helper function to convert NA values or empty strings to NULL. Used to
handle Shiny input default values which return NA or "" instead of NULL
when the input field is empty. numericInput returns NA, textInput
returns "".

## Usage

``` r
na_to_null(x)
```

## Arguments

- x:

  A value that may be NA or an empty string.

## Value

NULL if x is a single NA value or empty string, otherwise x unchanged.

## See also

[`blank_to_null()`](https://j-andrews7.github.io/VizModules/reference/blank_to_null.md),
[`nz_value()`](https://j-andrews7.github.io/VizModules/reference/nz_value.md)

## Author

Jared Andrews

## Examples

``` r
na_to_null(NA)
#> NULL
na_to_null("")
#> NULL
na_to_null(5)
#> [1] 5
```
