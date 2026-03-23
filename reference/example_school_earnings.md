# Example school earnings dataset for dumbbell plots

A small dataset of median annual earnings for men and women at six
universities, suitable for dumbbell plot examples.

## Usage

``` r
example_school_earnings
```

## Format

A data frame with 6 rows and 4 columns:

- School:

  University name

- Women:

  Median earnings for women (thousands of USD)

- Men:

  Median earnings for men (thousands of USD)

- Group:

  University type (STEM-heavy or Liberal Arts)

## Source

Simulated in data-raw/generate_example_data.R.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
example_school_earnings
#>      School Women Men        Group
#> 1       MIT    94  52   STEM-heavy
#> 2  Stanford    96 101   STEM-heavy
#> 3   Harvard   112 165 Liberal Arts
#> 4      Yale   188 145 Liberal Arts
#> 5 Princeton    91 148 Liberal Arts
#> 6  Columbia   129 155   STEM-heavy
```
