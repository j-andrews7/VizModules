# The levels a categorical column is plotted in, optionally reordered

Gives the levels of `data[[column]]` that are present, in the order a
plot draws them by default – factor level order for a factor, sorted
values otherwise – with any levels named in `order` moved to the front
in that order.

## Usage

``` r
level_order_choices(data, column, order = NULL, max.levels = 20)
```

## Arguments

- data:

  A data frame.

- column:

  The name of the column.

- order:

  Optional character vector of levels in the order wanted. Entries that
  are not present levels are ignored, and levels it leaves out follow in
  their default order, so an order kept from an earlier filtering of the
  data still applies to what is left.

- max.levels:

  The most levels worth offering for reordering. A column with more
  gives `NULL`.

## Value

A character vector of levels, or `NULL` when `column` is missing,
numeric, or has no levels or more than `max.levels` of them.

## See also

[`level_order_input()`](https://j-andrews7.github.io/VizModules/reference/level_order_input.md),
[`apply_level_order()`](https://j-andrews7.github.io/VizModules/reference/apply_level_order.md),
[`setup_level_order()`](https://j-andrews7.github.io/VizModules/reference/setup_level_order.md)

## Author

Jared Andrews

## Examples

``` r
level_order_choices(example_iris, "Species")
#> [1] "setosa"     "versicolor" "virginica" 
level_order_choices(example_iris, "Species", order = "virginica")
#> [1] "virginica"  "setosa"     "versicolor"

# Numeric columns have no levels to order
level_order_choices(example_iris, "Sepal.Length")
#> NULL
```
