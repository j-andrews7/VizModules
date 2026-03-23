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
