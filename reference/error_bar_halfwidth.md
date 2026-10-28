# Half-width of a group's error bar

What
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
draws either side of a group's mean for `error.type = "sd"`, `"sem"` or
`"ci95"`. Missing values are dropped before `n` is counted, so the bar
describes the values that went into the mean.

## Usage

``` r
error_bar_halfwidth(
  x,
  type = c("sd", "sem", "ci95"),
  ci.method = c("normal", "t")
)
```

## Arguments

- x:

  Numeric vector of one group's y-values.

- type:

  One of `"sd"` (standard deviation), `"sem"` (standard error of the
  mean, `sd / sqrt(n)`) or `"ci95"` (95% confidence interval for the
  mean).

- ci.method:

  For `type = "ci95"`, `"normal"` scales the standard error by the
  97.5th percentile of the normal distribution (1.96) and `"t"` by that
  of the t distribution on `n - 1` degrees of freedom. Ignored for the
  other types.

## Value

A single number, or `NA_real_` for fewer than two non-missing values,
which have no spread to draw.

## Details

A module that summarises its own groups (over a numeric x, say, which
linePlot's own summaries do not cover) can work out each interval with
this and hand
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
the bounds through `error.type = "columns"`, so its bars and ribbons
match the line plot module's.

## See also

[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)

## Author

Jared Andrews

## Examples

``` r
x <- c(4.1, 5.3, 4.8, 6.0, 5.5)
error_bar_halfwidth(x, "sd")
#> [1] 0.7231874
error_bar_halfwidth(x, "sem")
#> [1] 0.3234192
# The t interval is wider for small groups.
error_bar_halfwidth(x, "ci95", "normal")
#> [1] 0.63389
error_bar_halfwidth(x, "ci95", "t")
#> [1] 0.8979557
```
