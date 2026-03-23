# Example sales dataset

A simulated product-sales dataset covering five product lines over four
years and four quarters (80 rows total). Designed to showcase bar, box,
violin, area, line, scatter, split-bar, density, and histogram plot
modules.

## Usage

``` r
example_sales
```

## Format

A data frame with 80 rows and 9 columns:

- product_line:

  Product category (factor: Electronics, Clothing, Food, Sports, Home)

- year:

  Year of the record (factor: 2020-2023)

- quarter:

  Quarter of the year (factor: Q1-Q4)

- revenue:

  Total quarterly revenue

- profit:

  Quarterly profit (can be negative)

- units:

  Units sold

- growth_pct:

  Year-over-year growth percentage (can be negative)

- rating:

  Average customer rating (3.0–5.0)

- online_pct:

  Percentage of sales made online (20–80)

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
