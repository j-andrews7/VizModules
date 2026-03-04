# Extract parameter documentation from an R function help page

Parses the Rd documentation for a given function and extracts parameter
descriptions for specified parameter names.

## Usage

``` r
get_documentation(package_name, type = "param", selected = NULL, cap = FALSE)
```

## Arguments

- package_name:

  A string in the format "package::function" indicating which function's
  documentation to parse.

- type:

  The type of documentation section to extract. Currently only "param"
  is supported.

- selected:

  A character vector of parameter names to extract.

- cap:

  Logical; if TRUE, capitalize the first letter of each description.

## Value

A named list where names are parameter names and values are their
documentation strings. Returns empty strings for parameters not found in
the documentation.

## Author

Jacob Martin, Jared Andrews
