# Extract parameter documentation from an R function help page

Reads the help page of a function and returns the descriptions of the
parameters asked for, as plain text suitable for UI tooltips. Code is
set in backticks and other Rd markup is reduced to its text.

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

  A list of parameter names to extract. Co-documented parameters (e.g.,
  `x.by` and `y.by`) can be grouped together in a vector within the
  list; each name gets the shared description.

- cap:

  Logical; if TRUE, capitalize the first letter of each description.

## Value

A named list where names are parameter names and values are their
documentation strings. Returns empty strings for parameters not found in
the documentation.

## Details

Each package's help pages are read once per R session and kept, so
building a module's UI again (another tab, another dataset, another
Figure Builder panel) costs nothing. A package loaded with
[`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)
is read from its source `man/` directory, so its own, current docs are
used.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
get_documentation("stats::lm", selected = list("formula", "data"), cap = TRUE)
#> $formula
#> [1] "An object of class `\"formula\"` (or one that can be coerced to that class): a symbolic description of the model to be fitted. The details of model specification are given under 'Details'."
#> 
#> $data
#> [1] "An optional data frame, list or environment (or object coercible by `as.data.frame` to a data frame) containing the variables in the model. If not found in `data`, the variables are taken from `environment(formula)`, typically the environment from which `lm` is called."
#> 
```
