# Main heatmap output UI component for the ComplexHeatmap module

Renders *only* the original (main) interactive heatmap panel, via
[`InteractiveComplexHeatmap::originalHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/originalHeatmapOutput.html).
Use this together with
[`ComplexHeatmap_HeatmapSubOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapSubOutputUI.md)
and/or
[`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)
to place the three interactive components independently in a custom
layout, instead of
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md)'s
single combined widget. All pieces used for one heatmap must share the
same module `id` as the
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.md)
call — no server-side changes are needed to switch between the combined
and separated forms.

## Usage

``` r
ComplexHeatmap_HeatmapMainOutputUI(
  id,
  title = NULL,
  width = 450,
  height = 350,
  fit.width = TRUE,
  ...
)
```

## Arguments

- id:

  The ID for the Shiny module. Must match the `id` used for
  [`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.md)
  and any other output pieces for the same heatmap.

- title:

  Optional panel title. `NULL` (the default) omits the title.

- width, height:

  Panel dimensions in pixels.

- fit.width:

  Logical; when `TRUE` (the default) the panel is scaled once on load to
  fit the width of its container, making `width` a starting proportion
  rather than an absolute size. See
  [`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md).

- ...:

  Additional arguments passed to
  [`InteractiveComplexHeatmap::originalHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/originalHeatmapOutput.html),
  e.g. `action`, `response`, `brush_opt`.

## Value

A Shiny UI object for the main interactive heatmap panel.

## See also

[`InteractiveComplexHeatmap::originalHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/originalHeatmapOutput.html),
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md),
[`ComplexHeatmap_HeatmapSubOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapSubOutputUI.md),
[`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)

## Author

Jacob Martin

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
if (requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
    ComplexHeatmap_HeatmapMainOutputUI("heatmap", title = "Heatmap")
}
}
```
