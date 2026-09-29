# Fit a hand-built InteractiveComplexHeatmap widget to its container's width

The heatmap module's output functions already do this (see their
`fit.width` argument). This is the same behaviour for an app that calls
[`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html)
itself rather than going through the module — a heatmap driven directly
by
[`InteractiveComplexHeatmap::makeInteractiveComplexHeatmap()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/makeInteractiveComplexHeatmap.html),
say.

## Usage

``` r
heatmap_fit_width(
  ui,
  heatmap_id,
  panels = c("heatmap", "sub_heatmap"),
  output = TRUE
)
```

## Arguments

- ui:

  The UI returned by
  [`InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput()`](https://rdrr.io/pkg/InteractiveComplexHeatmap/man/InteractiveComplexHeatmapOutput.html)
  (or the `originalHeatmapOutput()`/`subHeatmapOutput()` pair).

- heatmap_id:

  The `heatmap_id` passed to that output function.

- panels:

  Character vector of panels to scale. Defaults to both; pass just
  `"heatmap"` for a `compact = TRUE` widget, which has no sub-heatmap.

- output:

  Logical; also scale the click/brush info panel. Defaults to `TRUE`,
  matching what
  [`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md)
  does for the same combined widget; pass `FALSE` when the app lays that
  panel out itself.

## Value

`ui`, with the fitting script and its dependency attached.

## Details

`InteractiveComplexHeatmapOutput()` bakes its `width1`/`width2` into the
page as fixed pixels, so the widget over- or under-fills whatever room
the app actually gives it until the resize handle is dragged. Wrapping
the output in this rescales the panels to their container once the page
is laid out; the widget's own resize controls still win afterwards.

A widget on a tab that is not the active one has no width to measure on
load. It is fitted when its container is first laid out instead, so a
heatmap the user has not opened yet is still correct the moment they do.

## See also

[`ComplexHeatmap_HeatmapOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ComplexHeatmap_HeatmapOutputUI.md),
whose `fit.width` argument is the module-side equivalent.

## Author

Jared Andrews

## Examples

``` r
if (interactive() && requireNamespace("InteractiveComplexHeatmap", quietly = TRUE)) {
    heatmap_fit_width(
        InteractiveComplexHeatmap::InteractiveComplexHeatmapOutput(
            heatmap_id = "my_ht", width1 = 1480, height1 = 500
        ),
        heatmap_id = "my_ht"
    )
}
```
