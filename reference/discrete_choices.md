# Choices for a categorical colour, shape, group or fill selector

The columns
[`facet_check()`](https://j-andrews7.github.io/VizModules/reference/facet_check.md)
accepts plus the logical columns, in data order, for any selector that
maps one colour, shape or group to each level of a column. A column of
IDs or gene names would ask for one level per row, so categorical
columns with `max.levels` or more distinct values are left out, while a
TRUE/FALSE column, which
[`facet_check()`](https://j-andrews7.github.io/VizModules/reference/facet_check.md)
leaves out of the split choices, is a sensible shape or group. Every
built-in module builds its categorical Color By, Shape By, Group By and
Fill By choices this way.

## Usage

``` r
discrete_choices(data, max.levels = 50, keep = NULL)
```

## Arguments

- data:

  A data frame.

- max.levels:

  A single positive number, passed to
  [`facet_check()`](https://j-andrews7.github.io/VizModules/reference/facet_check.md).
  Categorical columns with this many or more distinct values are
  excluded.

- keep:

  Column names to keep whatever their size, such as the column a caller
  named in `defaults`, so an explicit choice is always on offer. Names
  not in `data` are ignored.

## Value

A character vector of column names, in the order they appear in `data`.
`character(0)` when `data` is `NULL` or has no columns.

## Details

A selector that can also draw a numeric column as a gradient (the
scatter module's Color By, say) should add its numeric columns to these
itself.

## See also

[`facet_check()`](https://j-andrews7.github.io/VizModules/reference/facet_check.md)
for facet and split selectors.

## Author

Jared Andrews

## Examples

``` r
df <- data.frame(
    sample = paste0("S", 1:60),
    group = rep(c("A", "B", "C"), 20),
    treated = rep(c(TRUE, FALSE), 30),
    score = rnorm(60)
)
# `sample` has 60 levels, so only `group` and `treated` are offered.
discrete_choices(df)
#> [1] "group"   "treated"

# A column named in `defaults` is offered regardless.
defaults <- list(group.by = "sample")
discrete_choices(df, keep = get_default(defaults, "group.by", NULL))
#> [1] "sample"  "group"   "treated"
```
