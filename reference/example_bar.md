# Bar dataset for bar and split bar plot examples

A small dataset with five groups, two categorical variables, and three
numeric variables. Used as the default data for
[`plotthis_BarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotApp.md)
and
[`plotthis_SplitBarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotApp.md).

## Usage

``` r
example_bar
```

## Format

A data frame with 5 rows and 5 columns:

- Group:

  Group label (A through E)

- Type:

  Category type (Alpha, Beta, or Gamma)

- Values:

  Primary numeric values (positive)

- Numbers:

  Secondary numeric values (can be negative)

- Score:

  Tertiary numeric values (can be negative)

## Source

Defined in data-raw/generate_example_data.R.

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
example_bar
#>   Group  Type Values Numbers Score
#> 1     A Alpha     22      15     7
#> 2     B  Beta     35      -8    -3
#> 3     C Alpha     18      22    15
#> 4     D Gamma     41      -5     8
#> 5     E  Beta     29      12    -2
```
