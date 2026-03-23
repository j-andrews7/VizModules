# Example mtcars dataset with factors

The classic mtcars dataset with key numeric columns converted to factors
for categorical plotting examples.

## Usage

``` r
example_mtcars
```

## Format

A data frame with 32 rows and 11 columns:

- mpg:

  Miles per gallon

- cyl:

  Number of cylinders (factor)

- disp:

  Displacement (cubic inches)

- hp:

  Gross horsepower

- drat:

  Rear axle ratio

- wt:

  Weight (1000 lbs)

- qsec:

  1/4 mile time

- vs:

  Engine (0 = V-shaped, 1 = straight) (factor)

- am:

  Transmission (0 = automatic, 1 = manual) (factor)

- gear:

  Number of forward gears (factor)

- carb:

  Number of carburetors (factor)

## Source

Generated from the classic mtcars dataset.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
head(example_mtcars)
#>                    mpg cyl disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
#> Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
#> Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
#> Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
#> Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
```
