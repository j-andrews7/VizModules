# Parse comma-separated numeric string to vector

Parses a text string containing comma-separated numeric values into a
numeric vector. Used for parsing user input for line intercepts, slopes,
etc.

## Usage

``` r
parse_numeric_list(text)
```

## Arguments

- text:

  Character. A string containing comma-separated numeric values (e.g.,
  "1, 5, 8").

## Value

A numeric vector of parsed values, or NULL if input is empty/invalid.

## Details

Whitespace around values is trimmed. Non-numeric values are converted to
NA. If all values are NA or the input is empty, returns NULL.

## Author

Jared Andrews

## Examples

``` r
parse_numeric_list("1, 5, 8")
#> [1] 1 5 8
parse_numeric_list("")
#> NULL
```
