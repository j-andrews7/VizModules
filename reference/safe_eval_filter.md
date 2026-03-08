# Safely evaluate a user-provided filter expression against a data frame

Parses the expression text, validates that it only contains allowed
operations (comparisons, logical operators, column references, and
literals), then evaluates it in a restricted environment containing only
the data frame columns. Returns a logical vector suitable for row
subsetting, or `NULL` if the input is empty or invalid.

## Usage

``` r
safe_eval_filter(expr_text, data)
```

## Arguments

- expr_text:

  Character string containing the filter expression (e.g.,
  `"Sepal.Length > 5 & Species == 'setosa'"`).

- data:

  A `data.frame` whose columns are made available for the expression.

## Value

A logical vector the same length as `nrow(data)`, or `NULL` if the input
is empty, unparseable, or contains disallowed operations.

## Details

**Use this function any time a module evaluates a user-typed expression
directly** (e.g., a row-filter text input). Never call
`eval(str2expression())` on raw user input — doing so allows arbitrary
code execution on the server.

## Author

Jared Andrews

## Examples

``` r
safe_eval_filter("Sepal.Length > 5", iris)
#>   [1]  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE
#>  [13] FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
#>  [25] FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE FALSE FALSE
#>  [37]  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE
#>  [49]  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE
#>  [61] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#>  [73]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#>  [85]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE
#>  [97]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
#> [109]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#> [121]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#> [133]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
#> [145]  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
safe_eval_filter("Sepal.Length > 5 & Species == 'setosa'", iris)
#>   [1]  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE
#>  [13] FALSE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE
#>  [25] FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE FALSE FALSE
#>  [37]  TRUE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE  TRUE FALSE  TRUE FALSE
#>  [49]  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [61] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [73] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [85] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#>  [97] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [109] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [121] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [133] FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE FALSE
#> [145] FALSE FALSE FALSE FALSE FALSE FALSE
safe_eval_filter("", iris) # NULL
#> NULL
safe_eval_filter("system('echo pwned')", iris) # NULL + warning
#> Warning: Filter expression contains disallowed operations. Only column references, comparisons, and logical operators are permitted.
#> NULL
```
