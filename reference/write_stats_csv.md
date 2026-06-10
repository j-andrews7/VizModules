# Write stats table CSV with metadata header

Writes the stats data frame to a CSV file with a metadata header block
containing the p-value correction method, significance threshold, and
symbol legend.

## Usage

``` r
write_stats_csv(
  stats_df,
  file,
  p.adjust.method = "holm",
  sig.threshold = 0.05,
  sig.levels = c(`****` = 1e-04, `***` = 0.001, `**` = 0.01)
)
```

## Arguments

- stats_df:

  Data frame from
  [`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/reference/compute_pairwise_stats.md),
  or NULL.

- file:

  Character; path to the output file.

- p.adjust.method:

  Character; p-value correction method used.

- sig.threshold:

  Numeric; significance threshold used for `*` vs `ns`.

- sig.levels:

  Named numeric vector; the multi-star thresholds passed to
  [`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/reference/compute_pairwise_stats.md).
  Used to generate the symbol legend in the header. Default
  `c("****" = 0.0001, "***" = 0.001, "**" = 0.01)`.

## Value

Called for side effects; writes to `file`.

## Author

Jared Andrews

## Examples

``` r
stats_df <- compute_pairwise_stats(
    df = example_iris,
    x = "Species",
    y = "Sepal.Length",
    test = "wilcox.test"
)
tmp <- tempfile(fileext = ".csv")
write_stats_csv(stats_df, tmp)
file.remove(tmp)
#> [1] TRUE
```
