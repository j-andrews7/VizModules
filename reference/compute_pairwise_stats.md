# Compute pairwise statistical tests between groups

Performs pairwise statistical tests between groups defined by a
categorical variable. Supports Wilcoxon rank-sum, t-test,
Kruskal-Wallis, and ANOVA. Handles nested grouping (comparing color.by
groups within each x-level) and per-facet testing.

## Usage

``` r
compute_pairwise_stats(
  df,
  x,
  y,
  pairs = NULL,
  test = "wilcox.test",
  p.adjust.method = "holm",
  paired = FALSE,
  group.by = NULL,
  facet.by = NULL,
  per.facet = TRUE,
  sig.threshold = 0.05,
  sig.levels = c(`****` = 1e-04, `***` = 0.001, `**` = 0.01)
)
```

## Arguments

- df:

  Data frame containing the data.

- x:

  Character; column name of the categorical x-axis variable.

- y:

  Character; column name of the numeric response variable.

- pairs:

  List of length-2 character vectors specifying group pairs to test. If
  NULL (default), tests all unique pairwise combinations.

- test:

  Character; statistical test to use. One of `"wilcox.test"`,
  `"t.test"`, `"kruskal.test"`, or `"anova"`.

- p.adjust.method:

  Character; method for p-value adjustment via
  [`stats::p.adjust()`](https://rdrr.io/r/stats/p.adjust.html). Default
  `"holm"`.

- paired:

  Logical; whether to perform paired tests (only for `"wilcox.test"` and
  `"t.test"`). Default FALSE.

- group.by:

  Character or NULL; column for nested grouping. When set, comparisons
  are made between levels of `group.by` within each level of `x`.

- facet.by:

  Character or NULL; column for faceting. When set and
  `per.facet = TRUE`, tests run independently per facet panel.

- per.facet:

  Logical; if TRUE and `facet.by` is set, run tests independently per
  facet panel. Default TRUE.

- sig.threshold:

  Numeric; significance threshold for `*` vs `ns`. P-values at or below
  this are labeled `*`; above are labeled `ns`. Default 0.05. See
  `sig.levels` for the multi-star thresholds.

- sig.levels:

  Named numeric vector; upper p-value bounds for multi-star significance
  symbols. Names are the displayed symbols and values are the
  thresholds. Default `c("****" = 0.0001, "***" = 0.001, "**" = 0.01)`.
  Any number of levels can be provided. Evaluated from smallest to
  largest threshold so the most significant symbol always wins.

## Value

A data.frame with columns: `group1`, `group2`, `p.value`, `p.adj`,
`p.signif`, `test`, `facet_level`, `x_level` (when `group.by` is set).

## Author

Jared Andrews, Jacob Martin

## Examples

``` r
compute_pairwise_stats(
    df = example_iris,
    x = "Species",
    y = "Sepal.Length",
    test = "wilcox.test"
)
#>       group1     group2      p.value        test facet_level x_level
#> 1     setosa versicolor 8.345827e-14 wilcox.test        <NA>    <NA>
#> 2     setosa  virginica 6.396699e-17 wilcox.test        <NA>    <NA>
#> 3 versicolor  virginica 5.869006e-07 wilcox.test        <NA>    <NA>
#>          p.adj p.signif
#> 1 1.669165e-13     ****
#> 2 1.919010e-16     ****
#> 3 5.869006e-07     ****

# Custom significance levels: only two-star tiers, lower threshold for *
compute_pairwise_stats(
    df = example_iris,
    x = "Species",
    y = "Sepal.Length",
    test = "wilcox.test",
    sig.threshold = 0.01,
    sig.levels = c("**" = 0.001, "***" = 0.0001)
)
#>       group1     group2      p.value        test facet_level x_level
#> 1     setosa versicolor 8.345827e-14 wilcox.test        <NA>    <NA>
#> 2     setosa  virginica 6.396699e-17 wilcox.test        <NA>    <NA>
#> 3 versicolor  virginica 5.869006e-07 wilcox.test        <NA>    <NA>
#>          p.adj p.signif
#> 1 1.669165e-13      ***
#> 2 1.919010e-16      ***
#> 3 5.869006e-07      ***
```
