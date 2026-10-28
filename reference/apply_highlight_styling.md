# Restyle highlighted points in a plotly figure

Applies highlight marker styling (fill, size, border) to the points of a
plotly figure whose `annotate.by` value appears in `highlight_vals`.
Points are matched on their annotation value parsed out of the hover
text rather than on coordinates, because
[`ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html) encodes
categorical axes as numeric positions that will not match the raw data
values.

## Usage

``` r
apply_highlight_styling(
  fig,
  annotate.by,
  highlight_vals,
  style,
  default.size = NULL,
  show.others = TRUE,
  require.markers = FALSE
)
```

## Arguments

- fig:

  Plotly figure object.

- annotate.by:

  Character. Name of the hover field holding the values to match.

- highlight_vals:

  Character vector. Values identifying the points to highlight.

- style:

  A named list of styling values with elements `color`, `size`,
  `border.color` and `border.width`. Empty/`NA` elements are left
  unchanged.

- default.size:

  Numeric, or `NULL`. Marker size to fall back on for traces that carry
  no explicit size.

- show.others:

  Logical. Whether "show.others" was enabled in the plot.

- require.markers:

  Logical. When `TRUE`, only traces drawing point markers are restyled
  (use it when other scatter traces, such as box outlines, come from the
  same data).

## Value

The plotly figure with highlight styling applied.

## See also

[`uniform_annotation_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_annotation_inputs_ui.md),
[`parse_highlight_values()`](https://j-andrews7.github.io/VizModules/reference/parse_highlight_values.md),
[`create_highlight_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_highlight_annotations.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
fig <- apply_highlight_styling(
    fig, annotate.by = "name", highlight_vals = c("Mazda RX4", "Fiat 128"),
    style = list(color = "#FF0000", size = 14, border.color = "#000000", border.width = 2)
)
} # }
```
