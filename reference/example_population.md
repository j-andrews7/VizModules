# Example population dataset for module apps

A dataset containing simulated population counts across years and age
groups.

## Usage

``` r
example_population
```

## Format

A data frame with 400 rows and 4 columns:

- record_id:

  Unique population record identifier

- year:

  Year of the record

- age_group:

  Age group

- count:

  Population count

## Source

Simulated in data-raw/generate_example_data.R.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
head(example_population)
#>   year age_group count record_id
#> 1 1975       0-9  4789  Record_1
#> 2 1975     10-17  6039  Record_2
#> 3 1975     18-34  5127  Record_3
#> 4 1975     35-44  4118  Record_4
#> 5 1975     45-54  4633  Record_5
#> 6 1975     55-64  5187  Record_6
```
