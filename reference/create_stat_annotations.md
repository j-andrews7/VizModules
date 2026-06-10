# Create plotly shapes and annotations for statistical test results

Converts results from
[`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/reference/compute_pairwise_stats.md)
into plotly-compatible shapes (brackets) and annotations (text labels).
Sorts comparisons so that small-gap brackets are closest to the data and
large-gap brackets are higher.

## Usage

``` r
create_stat_annotations(
  stats_df,
  fig,
  df,
  x,
  y,
  display = "p.adj",
  hide.ns = FALSE,
  sig.threshold = 0.05,
  line.color = "#000000",
  line.width = 1,
  bracket.style = "capped",
  group.by = NULL,
  facet.by = NULL,
  x.order = NULL,
  font.size = 12,
  step.increase = 0.06,
  text.bump = 0.04,
  bracket.inset = 0.025
)
```

## Arguments

- stats_df:

  Data frame from
  [`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/reference/compute_pairwise_stats.md).

- fig:

  A plotly figure object. Used to detect subplot axis pairs for faceted
  plots.

- df:

  The original data frame.

- x:

  Character; x-axis column name.

- y:

  Character; y-axis column name.

- display:

  Character; what to display: `"p.adj"`, `"p.value"`, or `"symbol"`.
  Default `"p.adj"`.

- hide.ns:

  Logical; hide non-significant results. Default FALSE.

- sig.threshold:

  Numeric; significance threshold for determining non-significant
  results. Default 0.05.

- line.color:

  Character; color for bracket lines. Default `"#000000"`.

- line.width:

  Numeric; width of bracket lines. Default 1.

- bracket.style:

  Character; `"capped"` for ggpubr-style brackets with vertical ticks,
  or `"flat"` for a single horizontal line. Default `"capped"`.

- group.by:

  Character or NULL; nested grouping column.

- facet.by:

  Character or NULL; faceting column.

- x.order:

  Character vector; order of x-axis categories. If NULL, derived from
  unique values of `x` column.

- font.size:

  Numeric; size of annotation text. Default 12.

- step.increase:

  Numeric; fraction of y-range for spacing between successive brackets.
  Default 0.06.

- text.bump:

  Numeric; fraction of y-range for vertical distance of text above the
  bracket line. Default 0.04.

- bracket.inset:

  Numeric; fixed amount to inset each bracket endpoint from the group
  center position. Creates visual separation between adjacent brackets
  at the same y-level. Default 0.025.

## Value

A list with components:

- annotations:

  List of plotly annotation objects.

- shapes:

  List of plotly shape objects.

- y.max:

  Numeric; maximum y value needed to accommodate all annotations.

## Author

Jared Andrews, Jacob Martin

## Examples

``` r
stats_df <- compute_pairwise_stats(
    df = example_iris,
    x = "Species",
    y = "Sepal.Length",
    test = "wilcox.test"
)

fig <- plotly::plot_ly(
    data = example_iris, x = ~Species, y = ~Sepal.Length, type = "box"
)

stat_result <- create_stat_annotations(
    stats_df = stats_df,
    fig = fig,
    df = example_iris,
    x = "Species",
    y = "Sepal.Length",
    display = "symbol"
)

names(stat_result)
#> [1] "annotations" "shapes"      "y.max"      
```
