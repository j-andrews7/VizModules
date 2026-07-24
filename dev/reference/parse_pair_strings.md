# Parse pair strings from UI into list of length-2 vectors

Converts the "group1 vs group2" strings from the comparison selector
back into a list of length-2 character vectors for
[`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/dev/reference/compute_pairwise_stats.md).

## Usage

``` r
parse_pair_strings(pair_strings)
```

## Arguments

- pair_strings:

  Character vector of pair strings from UI input.

## Value

A list of length-2 character vectors, or NULL if input is empty.

## Author

Jared Andrews

## Examples

``` r
parse_pair_strings(c("setosa vs versicolor", "versicolor vs virginica"))
#> [[1]]
#> [1] "setosa"     "versicolor"
#> 
#> [[2]]
#> [1] "versicolor" "virginica" 
#> 
```
