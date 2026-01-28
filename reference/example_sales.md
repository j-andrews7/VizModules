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
#>   sale_id year month        region revenue units
#> 1  Sale_1 2015   Jan         North   198.3   243
#> 2  Sale_2 2015   Jan         South   110.1   103
#> 3  Sale_3 2015   Jan          East    68.3   275
#> 4  Sale_4 2015   Jan          West    61.9   212
#> 5  Sale_5 2015   Jan       Central    88.5   156
#> 6  Sale_6 2015   Jan International   171.2   205
```
