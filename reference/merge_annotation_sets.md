# Merge two sets of plotly point annotations

Appends `extra` annotations to `annos`, skipping any that already
describe the same point and text so a point selected by hand and also
matched by a highlight value is only labelled once.

## Usage

``` r
merge_annotation_sets(annos, extra)
```

## Arguments

- annos:

  List of plotly annotation objects, or NULL.

- extra:

  List of plotly annotation objects to append, or NULL.

## Value

The combined list of annotation objects, or NULL when both are empty.

## See also

[`create_selected_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_selected_annotations.md),
[`create_highlight_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_highlight_annotations.md)

## Author

Jared Andrews

## Examples

``` r
a <- list(list(x = 1, y = 2, text = "A"))
b <- list(list(x = 1, y = 2, text = "A"), list(x = 3, y = 4, text = "B"))
length(merge_annotation_sets(a, b))
#> [1] 2
```
