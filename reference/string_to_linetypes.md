# Parse and validate linetype string to a vector

Parses a comma-separated string of linetypes and validates each element.
Invalid linetypes are replaced with "solid" and a warning is issued.

## Usage

``` r
string_to_linetypes(x)
```

## Arguments

- x:

  A string of linetypes delimited by commas, e.g. "solid, dashed,
  dotted". Valid linetypes are: "solid", "dashed", "dotted", "dotdash",
  "longdash", "twodash".

## Value

A character vector of validated linetypes. If the input is "" or NULL,
returns "solid".

## Author

Jared Andrews

## Examples

``` r
string_to_linetypes("solid, dashed, dotted")
#> [1] "solid"  "dashed" "dotted"
string_to_linetypes("")
#> [1] "solid"
```
