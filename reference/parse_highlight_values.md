# Parse a highlight string into the values it names

Highlight values are typed as a comma- or newline-separated list, and
may also be separated by spaces. A value containing a space (`"CD4 T"`,
`"Player A"`) would be impossible to name that way, so each comma- or
newline-delimited entry is kept whole when it is one of `available`, and
split on whitespace otherwise.

## Usage

``` r
parse_highlight_values(x, available = NULL)
```

## Arguments

- x:

  A single string, e.g. `"CD4 T, B"` or `"P01 P07"`, or `NULL`.

- available:

  Character vector of the values the entries name (the `annotate.by`
  column), or `NULL` to split every entry on whitespace.

## Value

A character vector of unique, non-blank values, possibly empty.

## See also

[`apply_highlight_styling()`](https://j-andrews7.github.io/VizModules/reference/apply_highlight_styling.md),
[`create_highlight_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_highlight_annotations.md),
[`uniform_annotation_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_annotation_inputs_ui.md)

## Author

Jared Andrews

## Examples

``` r
parse_highlight_values("CD4 T, B", available = c("CD4 T", "B", "NK"))
#> [1] "CD4 T" "B"    
parse_highlight_values("P01 P07")
#> [1] "P01" "P07"
```
