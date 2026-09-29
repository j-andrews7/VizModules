# Bar dataset for bar and split bar plot examples

A small dataset with one row for each of six groups crossed with three
types, so bars stack by `Type` and each `Type` facet of a split bar plot
has one bar per `Group`. `Values` is positive and shrinks from Alpha to
Gamma; `Numbers` and `Score` are signed, leaning positive for Alpha and
negative for Gamma. Used as the default data for
[`plotthis_BarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotApp.md)
and
[`plotthis_SplitBarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotApp.md).

## Usage

``` r
example_bar
```

## Format

A data frame with 18 rows and 5 columns:

- Group:

  Group label (A through F)

- Type:

  Category type (Alpha, Beta, or Gamma)

- Values:

  Primary numeric values (positive)

- Numbers:

  Secondary numeric values (can be negative)

- Score:

  Tertiary numeric values (can be negative)

## Source

Generated in data-raw/generate_example_data.R.

## Author

Jacob Martin
