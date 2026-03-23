# Example demographics dataset

A simulated employee survey dataset with 500 rows spanning six
departments and four job levels. Designed to showcase violin, box,
yPlot, density, and histogram plot modules with realistic numeric
distributions.

## Usage

``` r
example_demographics
```

## Format

A data frame with 500 rows and 9 columns:

- department:

  Employee department (factor: Engineering, Marketing, Sales, HR,
  Finance, Operations)

- job_level:

  Job seniority level (factor: Junior, Mid, Senior, Lead)

- gender:

  Employee gender (factor: Male, Female)

- age:

  Employee age in years

- salary:

  Annual salary in USD

- satisfaction:

  Job satisfaction score (1–10)

- performance:

  Performance rating (1–10)

- tenure_years:

  Years with the company

- weekly_hours:

  Average weekly hours worked (35–65)

## Source

Simulated in data-raw/generate_example_data.R.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
head(example_demographics)
#>    department job_level gender age salary satisfaction performance tenure_years
#> 1     Finance    Senior   Male  32  81928          4.6         5.7          1.4
#> 2   Marketing      Lead   Male  28  77390          6.0         5.7          4.9
#> 3     Finance    Senior   Male  67  84606          5.3         5.8          2.8
#> 4   Marketing    Senior   Male  32  50164          7.6         8.8          6.8
#> 5 Engineering      Lead Female  55  53708          9.0         8.0          1.1
#> 6          HR    Senior Female  35  46496          1.4         6.6          8.6
#>   weekly_hours
#> 1         37.4
#> 2         41.5
#> 3         38.0
#> 4         40.2
#> 5         42.2
#> 6         38.9
```
