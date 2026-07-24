# Check if column inputs contain mixed data types

This function validates that a vector of column names from a data frame
contains columns of only one data type category: either all numeric OR
all categorical (factor/character). Returns `FALSE` for mixed numeric +
categorical columns. Single columns always return `TRUE`. Used for Shiny
plotting module input validation.

## Usage

``` r
is_pure_type(inputs, d)
```

## Arguments

- inputs:

  Character vector of column names to validate.

- d:

  Data frame containing the columns specified in `inputs`.

## Value

Logical scalar: `TRUE` if all numeric OR all categorical
(factor/character); `FALSE` if mixed numeric + categorical/factor
detected.

## See also

[`base::for()`](https://rdrr.io/r/base/Control.html)

## Author

Jacob Martin

## Examples

``` r
df <- data.frame(num1 = 1:3, num2 = 4:6, cat1 = letters[1:3], fac1 = factor(1:3))
is_pure_type(c("num1", "num2"), df) # TRUE (all numeric)
#> [1] TRUE
is_pure_type(c("cat1", "fac1"), df) # TRUE (all categorical)
#> [1] TRUE
is_pure_type(c("num1"), df) # TRUE (single)
#> [1] TRUE
is_pure_type(c("num1", "cat1"), df) # FALSE (mixed numeric + cat)
#> [1] FALSE
```
