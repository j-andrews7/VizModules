# Input IDs that style the main plot title

The inputs a faceted plot has no use for, since
[`add_plot_config()`](https://j-andrews7.github.io/VizModules/reference/add_plot_config.md)
disables its main title.
[`toggle_facet_title_inputs()`](https://j-andrews7.github.io/VizModules/reference/toggle_facet_title_inputs.md)
hides them while a plot is faceted.

## Usage

``` r
main_title_input_ids
```

## Format

A character vector of input IDs (without namespacing).

## See also

[`toggle_facet_title_inputs()`](https://j-andrews7.github.io/VizModules/reference/toggle_facet_title_inputs.md)

## Author

Jared Andrews

## Examples

``` r
main_title_input_ids
#> [1] "title.font.family"              "title.font.color"              
#> [3] "title.font.size"                "axis.title.horizontal.position"
```
