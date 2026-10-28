# Tell the user why significance brackets are missing from the plot

Brackets are stacked above the data on the y-axis, so they cannot be
drawn when the plotted values run along the x-axis (a rotated box plot,
or a dittoViz plot containing a ridge plot). The tests are still run and
shipped in the source-data download; this says so. The notification has
a fixed id, so rebuilding the plot replaces it rather than stacking
copies.

## Usage

``` r
note_brackets_skipped(session = shiny::getDefaultReactiveDomain())
```

## Arguments

- session:

  The Shiny session, from inside
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).

## Value

Called for its side effect; `NULL`, invisibly.

## See also

[`apply_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/apply_stat_annotations.md),
[`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/reference/compute_pairwise_stats.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Inside a module's renderPlotly(), when the values run along the x-axis:
note_brackets_skipped()
} # }
```
