# Generate uniform Stats input UI

Creates a standardized tagList of statistical testing inputs for use
across plot modules that support pairwise comparisons (BoxPlot, yPlot,
freqPlot).

## Usage

``` r
uniform_stats_inputs_ui(ns, defaults = NULL)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

## Value

A `tagList` containing the stats input UI elements.

## See also

[`reset_stats_inputs()`](https://j-andrews7.github.io/VizModules/reference/reset_stats_inputs.md),
[`default_stat_pairs()`](https://j-andrews7.github.io/VizModules/reference/default_stat_pairs.md),
[`stat_bracket_headroom()`](https://j-andrews7.github.io/VizModules/reference/stat_bracket_headroom.md),
[`create_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_stat_annotations.md),
[`apply_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/apply_stat_annotations.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
uniform_stats_inputs_ui(shiny::NS("stats"))
}
```
