# Reorder the levels of a categorical column

Re-levels `data[[column]]` as a factor whose levels follow `order`,
which is how the plot modules set the order of a categorical axis: the
plot functions, the statistics and their brackets all take the axis
order from the column's levels, so they stay in step.

## Usage

``` r
apply_level_order(data, column, order)
```

## Arguments

- data:

  A data frame.

- column:

  The name of the column.

- order:

  Character vector of levels in the order wanted, e.g. the value of a
  [`level_order_input()`](https://j-andrews7.github.io/VizModules/reference/level_order_input.md).
  Merged as in
  [`level_order_choices()`](https://j-andrews7.github.io/VizModules/reference/level_order_choices.md),
  with no cap on the number of levels.

## Value

`data`, with `column` re-levelled. It is returned unchanged when `order`
is empty or already the default order, or `column` is missing or
numeric.

## See also

[`level_order_input()`](https://j-andrews7.github.io/VizModules/reference/level_order_input.md),
[`level_order_choices()`](https://j-andrews7.github.io/VizModules/reference/level_order_choices.md),
[`setup_level_order()`](https://j-andrews7.github.io/VizModules/reference/setup_level_order.md)

## Author

Jared Andrews

## Examples

``` r
df <- apply_level_order(example_iris, "Species", c("virginica", "setosa"))
levels(df$Species)
#> [1] "virginica"  "setosa"     "versicolor"
```
