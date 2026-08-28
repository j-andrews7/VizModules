# Y-axis top needed to draw statistical annotation brackets in full

Works out how high the significance brackets from
[`create_stat_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/create_stat_annotations.md)
will reach, so an axis range can reserve room for them up front rather
than having the plot drawn with the brackets clipped or pushed outside
the panel.

## Usage

``` r
stat_bracket_y_max(
  df,
  x,
  y,
  pairs = NULL,
  group.by = NULL,
  facet.by = NULL,
  per.facet = TRUE,
  step.increase = 0.06,
  text.bump = 0.04,
  bracket.inset = 0.025,
  hide.ns = FALSE,
  sig.threshold = 0.05,
  test = "wilcox.test",
  p.adjust.method = "holm",
  paired = FALSE
)
```

## Arguments

- df:

  Data frame the statistics are computed on. For a module that reshapes
  its data for testing (e.g. a multi-variable Y selection), pass the
  reshaped frame, not the raw one.

- x:

  Character; x-axis column name.

- y:

  Character; y-axis column name(s). Several may be given, in which case
  the data range spans all of them.

- pairs:

  List of length-2 character vectors, or `NULL` for all pairwise
  combinations.

- group.by:

  Character or `NULL`; nested grouping column.

- facet.by:

  Character or `NULL`; faceting column.

- per.facet:

  Logical; whether tests are run within each facet.

- step.increase:

  Numeric; fraction of the y-range between successive bracket levels.
  Default 0.06.

- text.bump:

  Numeric; fraction of the y-range between a bracket and its label.
  Default 0.04.

- bracket.inset:

  Numeric; endpoint inset, which affects how tightly brackets pack onto
  a level. Default 0.025.

- hide.ns:

  Logical; whether non-significant brackets are dropped before drawing.
  When `TRUE` the tests are run so only the surviving comparisons are
  counted. Default `FALSE`.

- sig.threshold:

  Numeric; significance cutoff used with `hide.ns`.

- test, p.adjust.method, paired:

  Passed to
  [`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/dev/reference/compute_pairwise_stats.md),
  and used only when `hide.ns` is `TRUE`. Match them to the render's
  settings, or the wrong comparisons are counted.

## Value

A single number giving the y-axis maximum the brackets need, or `NULL`
when nothing would be drawn.

## Details

The brackets are stacked above the data: each packing level sits
`step.increase` of the data range above the last, the label sits
`text.bump` above its bracket, and a final `step.increase` of clearance
is left at the top. Which comparisons land on which level is decided by
`.assign_bracket_levels()`, shared with the drawing code, so the two
agree exactly.

Which comparisons there are to place depends only on the grouping
columns and the user's pair selection, so no test needs to be run —
except under `hide.ns = TRUE`, where the non-significant brackets are
dropped before packing and the tests have to be run to know which those
are. That case repeats the work
[`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/dev/reference/compute_pairwise_stats.md)
does at render time; it is skipped for several `y` columns at once,
where the comparisons no longer map one-to-one onto a single test run,
and the result is then an upper bound.

[`apply_stat_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/apply_stat_annotations.md)
still has the last word on the drawn range, so a bracket is never
clipped even where this over- or under-estimates.

## See also

[`create_stat_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/create_stat_annotations.md),
[`apply_stat_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/apply_stat_annotations.md)

## Author

Jared Andrews

## Examples

``` r
# Three species means three comparisons, which stack onto two levels.
stat_bracket_y_max(example_iris, x = "Species", y = "Sepal.Length")
#> [1] 8.692

# Compare against the raw data maximum.
max(example_iris$Sepal.Length)
#> [1] 7.9
```
