# Static (non-interactive) heatmap output UI component for the ComplexHeatmap module

Renders the heatmap as a plain
[`shiny::plotOutput()`](https://rdrr.io/pkg/shiny/man/plotOutput.html)
instead of an InteractiveComplexHeatmap widget. The same
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapServer.md)
call backs both, so switching between them needs no server-side change –
use this function *or* the interactive output functions for a given
module `id`, not both.

## Usage

``` r
ComplexHeatmap_HeatmapStaticOutputUI(
  id,
  resizable = TRUE,
  width = "100%",
  height = "100%"
)
```

## Arguments

- id:

  The ID for the Shiny module. Must match the `id` used for
  [`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapServer.md).

- resizable:

  Logical; whether to wrap the plot in a resizable container. Unlike
  [`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapOutputUI.md),
  this is honoured, since a `plotOutput` has no resize handle of its
  own.

- width, height:

  Passed to
  [`shiny::plotOutput()`](https://rdrr.io/pkg/shiny/man/plotOutput.html).
  The defaults fill the containing element, so the heatmap follows its
  container's size.

## Value

A Shiny UI object for the static heatmap.

## Details

What is given up is the widget's interactivity: cell hover/click, the
sub-heatmap zoom, and the brush info panel. What is gained is a panel
with no chrome of its own. InteractiveComplexHeatmap draws a grey border
around the heatmap panel, a control tab strip beneath it, and sizes
itself in fixed pixels; none of that can be switched off through an
argument, since the border is set by an id selector in that package's
own stylesheet. A `plotOutput` has none of it and fills its container at
whatever `width` and `height` say, which is what a figure panel wants –
it is how the `ComplexHeatmap` module appears in the Figure Builder (see
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderServer.md)).

Unlike the interactive output, this needs only ComplexHeatmap itself,
not InteractiveComplexHeatmap.

## See also

[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapOutputUI.md)
for the interactive widget,
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapServer.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
if (requireNamespace("ComplexHeatmap", quietly = TRUE)) {
    ComplexHeatmap_HeatmapStaticOutputUI("heatmap")
    # Fixed size, no resize handle:
    ComplexHeatmap_HeatmapStaticOutputUI("heatmap",
        resizable = FALSE, width = "600px", height = "400px"
    )
}
#> <div class="shiny-plot-output html-fill-item" id="heatmap-HeatmapStatic" style="width:600px;height:400px;"></div>
```
