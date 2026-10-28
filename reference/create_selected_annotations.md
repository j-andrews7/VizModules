# Create annotations for selected points

Creates plotly annotation objects for selected points from
event_data("plotly_selected"). This function handles the complex logic
of matching selected points to their corresponding traces and extracting
annotation text.

## Usage

``` r
create_selected_annotations(
  selected_data,
  fig,
  annotate.by,
  annotation_params,
  show.others = TRUE,
  require.markers = FALSE
)
```

## Arguments

- selected_data:

  Data frame from event_data("plotly_selected").

- fig:

  Plotly figure object.

- annotate.by:

  Character. Name of the field to use for annotation text.

- annotation_params:

  List of annotation styling parameters (ax, ay, showarrow, etc.).

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
[`create_highlight_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_highlight_annotations.md),
[`merge_annotation_sets()`](https://j-andrews7.github.io/VizModules/reference/merge_annotation_sets.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Inside a module's renderPlotly(), with the selection from event_data():
selected <- event_data("plotly_selected", source = plot_source)
annos <- create_selected_annotations(selected, fig, annotate.by = "name", 
                                     annotation_params = params)
} # }
```
