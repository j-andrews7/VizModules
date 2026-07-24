# Generate comparison pair strings from data columns

Creates formatted pair strings for populating the comparison selector
UI. Handles both standard x-axis comparisons and nested group.by
comparisons.

## Usage

``` r
generate_pair_strings(df, x, group.by = NULL)
```

## Arguments

- df:

  Data frame containing the data.

- x:

  Character; x-axis column name.

- group.by:

  Character or NULL; nested grouping column.

## Value

A character vector of pair strings in "group1 vs group2" format.

## Author

Jared Andrews

## Examples

``` r
generate_pair_strings(example_iris, x = "Species")
#> [1] "setosa vs versicolor"    "setosa vs virginica"    
#> [3] "versicolor vs virginica"
```
