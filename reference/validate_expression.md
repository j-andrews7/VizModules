# Validate a user-provided expression string for safety

Parses the expression text and walks the AST to ensure it only contains
allowed operations (comparisons, logical operators, column references,
and literals). Returns the original string if valid, or `NULL` if the
input is empty, unparseable, or contains disallowed operations. This is
useful when the expression string must be passed through to a downstream
function (e.g., `plotthis::BoxPlot(highlight = ...)`) rather than
evaluated directly.

## Usage

``` r
validate_expression(expr_text, col_names)
```

## Arguments

- expr_text:

  Character string containing the expression to validate (e.g.,
  `"group == 'A' & value > 10"`).

- col_names:

  Character vector of allowed column/symbol names (typically
  `names(data)`).

## Value

The original `expr_text` string if safe, or `NULL`.

## Details

**Use this when a module passes a user-typed expression string to an
external plotting function** that will evaluate it internally. The
string is validated but not executed by this function.

## Author

Jared Andrews

## Examples

``` r
validate_expression("Sepal.Length > 5", names(iris))
#> [1] "Sepal.Length > 5"
validate_expression("system('echo pwned')", names(iris)) # NULL + warning
#> Warning: Expression contains disallowed operations. Only column references, comparisons, and logical operators are permitted.
#> NULL
validate_expression("", names(iris)) # NULL
#> NULL
```
