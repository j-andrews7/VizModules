# Click/brush info output UI component for the ComplexHeatmap module

Renders *only* the output panel showing information about the clicked or
brushed cell(s) (e.g. row/column names and value), via
[`InteractiveComplexHeatmap::HeatmapInfoOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/HeatmapInfoOutput.html).
See
[`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapMainOutputUI.md)
for how the separated output pieces fit together.

## Usage

``` r
ComplexHeatmap_HeatmapInfoOutputUI(id, title = NULL, width = 400, ...)
```

## Arguments

- id:

  The ID for the Shiny module. Must match the `id` used for
  [`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapServer.md)
  and any other output pieces for the same heatmap.

- title:

  Optional panel title. `NULL` (the default) omits the title.

- width:

  Panel width in pixels.

- ...:

  Additional arguments passed to
  [`InteractiveComplexHeatmap::HeatmapInfoOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/HeatmapInfoOutput.html).

## Value

A Shiny UI object for the click/brush info panel.

## See also

[`InteractiveComplexHeatmap::HeatmapInfoOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/HeatmapInfoOutput.html),
[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md),
[`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapMainOutputUI.md),
[`ComplexHeatmap_HeatmapSubOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapSubOutputUI.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
ComplexHeatmap_HeatmapInfoOutputUI("heatmap", title = "Details")
#> <div id="heatmap_Heatmap_output_wrapper" style="width: 400px">
#>   <h5>Details</h5>
#>   <div id="heatmap_Heatmap_info" class="shiny-html-output"></div>
#> </div>
```
