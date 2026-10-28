# Identify columns valid for faceting or splitting

Scans a data frame and returns the names of columns that are appropriate
choices for a facet/split selector. A column qualifies when it is
categorical (character or factor) and has fewer than `max.levels` unique
values. This keeps facet/split inputs from offering numeric columns or
high-cardinality categoricals that would produce an unwieldy number of
panels. The modules also use it, through
[`discrete_choices()`](https://j-andrews7.github.io/VizModules/reference/discrete_choices.md),
to limit their categorical colour, shape and group selectors, where a
column of IDs would otherwise ask for one colour or shape per row.

## Usage

``` r
facet_check(data, max.levels = 50)
```

## Arguments

- data:

  A data frame whose columns are evaluated.

- max.levels:

  A single positive number. Columns with this many or more distinct
  values are excluded. Defaults to 50.

## Value

A character vector of column names suitable for faceting/splitting.
Returns `character(0)` when no column qualifies.

## Details

Intended to populate the `choices` of a facet/split
[`viz_select_input()`](https://j-andrews7.github.io/VizModules/reference/viz_select_input.md)
via
[`update_viz_select()`](https://j-andrews7.github.io/VizModules/reference/update_viz_select.md)
inside a module server, so that only sensible faceting variables are
exposed to the user.

A column is considered valid when both of the following hold:

- It is categorical: `is.character(col)` or `is.factor(col)`.

- It has fewer than `max.levels` unique values (`NA`s excluded).

Numeric columns and categorical columns with `max.levels` or more
distinct values are always excluded.

## Author

Jacob Martin

## Examples

``` r
facet_check(iris)
#> [1] "Species"
facet_check(mtcars)
#> character(0)
# A lower cap drops the 3-level Species column.
facet_check(iris, max.levels = 3)
#> character(0)
```
