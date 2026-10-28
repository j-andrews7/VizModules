# Create annotations for highlighted points

Creates plotly annotation objects for points highlighted by value
matching. This function finds all points in the plot data that match the
highlight values and creates annotations for them.

## Usage

``` r
create_highlight_annotations(
  plot_data,
  fig,
  annotate.by,
  highlight_vals,
  x_col,
  y_col,
  annotation_params,
  show.others = TRUE,
  require.markers = FALSE
)
```

## Arguments

- plot_data:

  Data frame. The plot data from dittoViz scatterPlot (Target_data).

- fig:

  Plotly figure object.

- annotate.by:

  Character. Name of the field to use for annotation text.

- highlight_vals:

  Character vector. Values to highlight from the annotate.by column.

- x_col:

  Character. Name of the x-axis column.

- y_col:

  Character. Name of the y-axis column.

- annotation_params:

  List of annotation styling parameters.

- show.others:

  Logical. Whether "show.others" was enabled in the plot.

- require.markers:

  Logical. When `TRUE`, only traces drawing point markers are matched
  (use it when other scatter traces, such as box outlines, come from the
  same data).

## Value

List of plotly annotation objects, or NULL if no valid annotations.

## See also

[`uniform_annotation_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_annotation_inputs_ui.md),
[`parse_highlight_values()`](https://j-andrews7.github.io/VizModules/reference/parse_highlight_values.md),
[`create_selected_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_selected_annotations.md),
[`merge_annotation_sets()`](https://j-andrews7.github.io/VizModules/reference/merge_annotation_sets.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Inside a module's renderPlotly(), after building the plot:
annos <- create_highlight_annotations(
    plot_data,
    fig,
    annotate.by = "name",
    highlight_vals = parse_highlight_values(input$highlight.values),
    x_col = "wt",
    y_col = "mpg",
    annotation_params = params
)
} # }
```
