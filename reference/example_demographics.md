# Example demographics dataset

A simulated employee survey dataset with 500 rows spanning six
departments and four job levels. Salary rises steeply with job level and
varies by department; age and tenure rise with level; remote workers
report higher satisfaction than office workers in every department, and
long hours lower it. Gender has no effect on anything. Two employees are
planted against the trend for highlighting: `E042`, a very unhappy
remote engineer, and `E137`, a very happy office-based salesperson.
Designed to showcase the box, yPlot, density, and histogram plot
modules, including their statistical comparisons.

## Usage

``` r
example_demographics
```

## Format

A data frame with 500 rows and 11 columns:

- department:

  Employee department (factor: Engineering, Finance, Sales, Marketing,
  Operations, HR)

- job_level:

  Job seniority level (factor: Entry, Mid, Senior, Lead)

- gender:

  Employee gender (factor: Female, Male)

- age:

  Employee age in years (21-67)

- salary:

  Annual salary in USD

- satisfaction:

  Job satisfaction score (1-10)

- performance:

  Performance rating (1-10)

- tenure_years:

  Years with the company

- weekly_hours:

  Average weekly hours worked

- work_mode:

  Where the employee works (factor: Office, Remote)

- employee_id:

  Unique employee identifier (`E001`-`E500`)

## Source

Simulated in data-raw/generate_example_data.R.

## Author

Jared Andrews
