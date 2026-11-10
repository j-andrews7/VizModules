# Output UI components for the ComplexHeatmap module

This should be placed in the UI where the heatmap should be shown.
Unlike the plotly modules, the interactive output is provided by
[`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html),
which supplies its own resize and export controls.

## Usage

``` r
ComplexHeatmap_HeatmapOutputUI(id, resizable = TRUE, fit.width = TRUE, ...)
```

## Arguments

- id:

  The ID for the Shiny module.

- resizable:

  Logical; accepted for signature parity with the other module output
  functions but ignored, since the InteractiveComplexHeatmap widget
  manages its own sizing.

- fit.width:

  Logical; when `TRUE` (the default) the widget's panels are scaled once
  on load so the whole thing fits the width of its container, instead of
  sitting at the fixed pixel widths baked in by
  InteractiveComplexHeatmap. `width1`/`width2` (and their defaults) then
  act as the relative widths that get scaled, rather than absolute
  sizes. Heights are left alone, and the widget's own resize handle and
  size tab still override the fitted width afterwards. Pass `FALSE` for
  fixed pixel widths.

- ...:

  Additional arguments passed to
  [`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html),
  e.g. `layout`, `compact`, `width1`/`height1`,
  `title1`/`title2`/`title3`.

## Value

A Shiny UI object for the interactive heatmap.

## Details

This renders the original heatmap, the selected sub-heatmap, and the
click/brush info panel together as one widget, arranged per `layout`
(see
[`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html)
for the available layout strings, e.g. `"(1-2)|3"`, `"1|(2-3)"`,
`"1-2-3"`).

Pass `compact = TRUE` for a smaller footprint (see the ["Compact mode"
article
section](https://jokergoo.github.io/InteractiveComplexHeatmap/articles/shiny_dev.html#compact-mode)):
the sub-heatmap panel is dropped entirely and the click/brush info
floats near the cursor instead of occupying its own static area —
equivalent to
`response = c(action, "brush-output"), output_ui_float = TRUE`, per
[`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html)'s
own docs. `layout` has nothing left to arrange in compact mode, since
only one static panel remains. No server-side change is needed to turn
compact mode on or off.

A floating info panel is moved onto `<body>` by
InteractiveComplexHeatmap and parked off-screen when idle. It is parked
to the *left* here rather than to the right as the package does, since a
box parked past the right edge extends the host page's scrollable width
by 10,000px.

To place the three components independently anywhere in a custom UI
(separate tabs, cards, columns, etc.), use
[`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapMainOutputUI.md),
[`ComplexHeatmap_HeatmapSubOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapSubOutputUI.md),
and
[`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)
instead of this function. Use one approach or the other, not both, for
the same module `id`. Compact mode is specific to this combined widget:
the separated pieces (`originalHeatmapOutput()`, `subHeatmapOutput()`,
`HeatmapInfoOutput()`, which back the three functions above) don't
accept a `compact` argument at all.

## See also

[`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html),
[`ComplexHeatmap_HeatmapMainOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapMainOutputUI.md),
[`ComplexHeatmap_HeatmapSubOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapSubOutputUI.md),
[`ComplexHeatmap_HeatmapInfoOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapInfoOutputUI.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
if (requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
    # Default combined widget:
    ComplexHeatmap_HeatmapOutputUI("heatmap")
    # Same widget, main heatmap on its own row above sub-heatmap + info:
    ComplexHeatmap_HeatmapOutputUI("heatmap", layout = "1|(2-3)")
    # Compact: no sub-heatmap panel, click/brush info floats near the cursor
    ComplexHeatmap_HeatmapOutputUI("heatmap", compact = TRUE)
    # Fixed pixel widths, ignoring the container:
    ComplexHeatmap_HeatmapOutputUI("heatmap", fit.width = FALSE)
}
}
```
