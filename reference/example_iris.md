# Example grouped iris dataset

The classic iris dataset with an added 'Group' column to facilitate
multi-group plot examples.

## Usage

``` r
example_iris
```

## Format

A data frame with 150 rows and 6 columns:

- Sepal.Length:

  Sepal length in cm

- Sepal.Width:

  Sepal width in cm

- Petal.Length:

  Petal length in cm

- Petal.Width:

  Petal width in cm

- Species:

  Species of the iris (factor: setosa, versicolor, virginica)

- Group:

  Group assignment (factor: A, B, C, D)

## Source

Generated from the classic iris dataset.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
head(example_iris)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species Group
#> 1          5.1         3.5          1.4         0.2  setosa     A
#> 2          4.9         3.0          1.4         0.2  setosa     B
#> 3          4.7         3.2          1.3         0.2  setosa     A
#> 4          4.6         3.1          1.5         0.2  setosa     B
#> 5          5.0         3.6          1.4         0.2  setosa     A
#> 6          5.4         3.9          1.7         0.4  setosa     B
```
