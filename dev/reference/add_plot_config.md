# Create default Plotly configuration

Constructs a configuration list for Plotly plots, enabling interactive
editing of titles and legends, export options, and additional drawing
tools in the modebar.

## Usage

``` r
add_plot_config(
  download.format = "png",
  filename = as.character(Sys.Date()),
  include.modebar.buttons = TRUE,
  facet.by = NULL
)
```

## Arguments

- download.format:

  Character. The image format for downloads (e.g., "png", "svg",
  "jpeg").

- filename:

  Character. The filename for downloaded images (default: current date).

- include.modebar.buttons:

  Logical. Whether to include drawing tool buttons in the modebar
  (default: TRUE).

- facet.by:

  Logical. Whether the figure is facetted to determine if axes labels
  for each plot should be editable or not.

## Value

A named list suitable for use as the `config` argument in Plotly calls,
containing edit options, image download settings, extra modebar buttons,
and logo display preferences.

## Details

The configuration enables interactive editing of the plot title, legend
text and position, colorbar position and title, and annotation tails. It
also adds drawing tools (lines, paths, circles, rectangles, and an
eraser) to the modebar. Native cartesian axis-title text editing is
disabled because axis titles are rendered as draggable, editable
annotations (see
[`axis_titles_as_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/axis_titles_as_annotations.md)
and
[`build_facet_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/build_facet_annotations.md)).

## Author

Jacob Martin

## Examples

``` r
add_plot_config()
#> $edits
#> $edits$axisTitleText
#> [1] FALSE
#> 
#> $edits$titleText
#> [1] TRUE
#> 
#> $edits$annotationText
#> [1] TRUE
#> 
#> $edits$legendText
#> [1] TRUE
#> 
#> $edits$legendPosition
#> [1] TRUE
#> 
#> $edits$colorbarPosition
#> [1] TRUE
#> 
#> $edits$colorbarTitleText
#> [1] TRUE
#> 
#> $edits$annotationTail
#> [1] TRUE
#> 
#> $edits$editText
#> [1] TRUE
#> 
#> $edits$editTitle
#> [1] TRUE
#> 
#> $edits$annotationPosition
#> [1] TRUE
#> 
#> 
#> $toImageButtonOptions
#> $toImageButtonOptions$format
#> [1] "png"
#> 
#> $toImageButtonOptions$filename
#> [1] "2026-08-28"
#> 
#> 
#> $displaylogo
#> [1] FALSE
#> 
#> $modeBarButtonsToAdd
#> $modeBarButtonsToAdd[[1]]
#> [1] "drawline"
#> 
#> $modeBarButtonsToAdd[[2]]
#> [1] "drawopenpath"
#> 
#> $modeBarButtonsToAdd[[3]]
#> [1] "drawclosedpath"
#> 
#> $modeBarButtonsToAdd[[4]]
#> [1] "drawcircle"
#> 
#> $modeBarButtonsToAdd[[5]]
#> [1] "drawrect"
#> 
#> $modeBarButtonsToAdd[[6]]
#> [1] "eraseshape"
#> 
#> 
add_plot_config(download.format = "svg", include.modebar.buttons = FALSE)
#> $edits
#> $edits$axisTitleText
#> [1] FALSE
#> 
#> $edits$titleText
#> [1] TRUE
#> 
#> $edits$annotationText
#> [1] TRUE
#> 
#> $edits$legendText
#> [1] TRUE
#> 
#> $edits$legendPosition
#> [1] TRUE
#> 
#> $edits$colorbarPosition
#> [1] TRUE
#> 
#> $edits$colorbarTitleText
#> [1] TRUE
#> 
#> $edits$annotationTail
#> [1] TRUE
#> 
#> $edits$editText
#> [1] TRUE
#> 
#> $edits$editTitle
#> [1] TRUE
#> 
#> $edits$annotationPosition
#> [1] TRUE
#> 
#> 
#> $toImageButtonOptions
#> $toImageButtonOptions$format
#> [1] "svg"
#> 
#> $toImageButtonOptions$filename
#> [1] "2026-08-28"
#> 
#> 
#> $displaylogo
#> [1] FALSE
#> 
```
