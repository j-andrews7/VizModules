# Example roles dataset for ternary plots

A dataset of role proportions (journalist, developer, designer) for
eleven individuals across two teams, suitable for ternary plot examples.

## Usage

``` r
example_roles
```

## Format

A data frame with 11 rows and 5 columns:

- journalist:

  Journalist role proportion

- developer:

  Developer role proportion

- designer:

  Designer role proportion

- label:

  Point label (point 1 through point 11)

- team:

  Team assignment (Team A or Team B)

## Source

Simulated in data-raw/generate_example_data.R.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
example_roles
#>    journalist developer designer    label   team
#> 1          75        25        0  point 1 Team A
#> 2          70        10       20  point 2 Team A
#> 3          75        20        5  point 3 Team A
#> 4           5        60       35  point 4 Team A
#> 5          10        80       10  point 5 Team A
#> 6          10        90        0  point 6 Team A
#> 7          20        70       10  point 7 Team B
#> 8          10        20       70  point 8 Team B
#> 9          15         5       80  point 9 Team B
#> 10         10        10       80 point 10 Team B
#> 11         20        10       70 point 11 Team B
```
