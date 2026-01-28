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
#>   record_id year age_group count
#> 1  Record_1 1975       0-9  4789
#> 2  Record_2 1975     10-17  6039
#> 3  Record_3 1975     18-34  5127
#> 4  Record_4 1975     35-44  4118
#> 5  Record_5 1975     45-54  4633
#> 6  Record_6 1975     55-64  5187
```
