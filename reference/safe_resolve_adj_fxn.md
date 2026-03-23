# Safely resolve an adjustment function name to an actual function

Validates that the provided function name is in the allowed list before
converting it to a function reference. Returns `NULL` for empty strings
or unrecognized names.

## Usage

``` r
safe_resolve_adj_fxn(fn_name)
```

## Arguments

- fn_name:

  Character string — name of the adjustment function. Currently allowed
  values: `"log2"`, `"log"`, `"log10"`, `"neg_log10"`, `"log1p"`,
  `"as.factor"`, `"abs"`, `"sqrt"`.

## Value

The corresponding function, or `NULL` if `fn_name` is empty or not in
the allowed list.

## Details

**Use this instead of `eval(str2expression())` when resolving function
names from user input** (e.g., a dropdown that selects a transformation
like `"log2"` or `"sqrt"`).

## Author

Jared Andrews

## Examples

``` r
safe_resolve_adj_fxn("log2") # returns log2
#> function (x)  .Primitive("log2")
safe_resolve_adj_fxn("") # NULL
#> NULL
safe_resolve_adj_fxn("system") # NULL + warning
#> Warning: Unrecognized adjustment function: system
#> NULL
```
