# Example sales dataset for module apps

A dataset containing simulated sales records across years, months, and
regions.

## Usage

``` r
example_sales
```

## Format

A data frame with 720 rows and 6 columns:

- sale_id:

  Unique sale record identifier

- year:

  Year of the sale

- month:

  Month of the sale

- region:

  Sales region

- revenue:

  Revenue amount

- units:

  Units sold

## Source

Simulated in data-raw/generate_example_data.R.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
head(example_sales)
#>          region revenue year month units sale_id
#> 1         North   198.3 2015   Jan   243  Sale_1
#> 2         South   110.1 2015   Jan   103  Sale_2
#> 3          East    68.3 2015   Jan   275  Sale_3
#> 4          West    61.9 2015   Jan   212  Sale_4
#> 5       Central    88.5 2015   Jan   156  Sale_5
#> 6 International   171.2 2015   Jan   205  Sale_6
```
