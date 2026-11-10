# Sub-heatmap output UI component for the ComplexHeatmap module

Renders *only* the selected sub-heatmap panel (the zoomed-in view of a
brushed/selected region), via
[`InteractiveComplexHeatmap::subHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/subHeatmapOutput.html).
See
[`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapMainOutputUI.md)
for how the separated output pieces fit together.

## Usage

``` r
ComplexHeatmap_HeatmapSubOutputUI(
  id,
  title = NULL,
  width = 400,
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
  [`InteractiveComplexHeatmap::subHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/subHeatmapOutput.html).

## Value

A Shiny UI object for the sub-heatmap panel.

## See also

[`InteractiveComplexHeatmap::subHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/subHeatmapOutput.html),
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md),
[`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapMainOutputUI.md),
[`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)

## Author

Jacob Martin

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
if (requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
    ComplexHeatmap_HeatmapSubOutputUI("heatmap", title = "Selected region")
}
}
```
