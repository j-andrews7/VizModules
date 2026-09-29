# Render a grid or base drawing to a self-contained SVG fragment

Draws onto an SVG device and returns the markup, ready to be placed
inside a larger SVG document. This is what lets a module whose output is
not a plotly graph still contribute vector art to the Figure Builder's
figure export: see the `vector_svg` attribute documented in
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderServer.md).

## Usage

``` r
draw_to_svg(draw_fn, width, height, res = 72, id_prefix = NULL, bg = "white")
```

## Arguments

- draw_fn:

  A function of no arguments that draws onto the active device.

- width, height:

  Size in pixels.

- res:

  Pixels per inch used to convert `width`/`height` to the inches the SVG
  devices take. The default matches
  [`shiny::renderPlot()`](https://rdrr.io/pkg/shiny/man/renderPlot.html)'s
  own `res`, so the fragment is drawn on a canvas the same physical size
  as the one the panel was rendered at on screen. That is not cosmetic:
  a `ComplexHeatmap` legend, its row labels and its titles are all sized
  in absolute points, so a canvas even slightly smaller than the
  on-screen one leaves them the same size while the heatmap body – the
  one flexible element – absorbs the entire shortfall. Exporting a
  legend-heavy heatmap 25% small squeezed its cells down to nothing.

- id_prefix:

  Optional character scalar used to namespace the fragment's ids, so
  several fragments can share one document. See `.svg_namespace_ids()`.

- bg:

  Background color.

## Value

A character scalar holding an `<svg>` element, or `NULL` if the
requested size is not usable or the R build can reach neither SVG device
(no svglite installed and no working cairo – which on macOS needs
XQuartz). An error raised by `draw_fn` itself (a panel dragged too small
to leave any plotting room, say) propagates to the caller, which is
better placed to decide whether to drop that panel or fail the whole
export; the device is closed either way.

The result is a *fragment*: it carries no XML declaration and no
`xmlns`, because it is meant to be spliced into a document that already
declares them. That makes it unopenable as a file on its own – writing
one out directly needs the namespace restated first.

## Details

svglite is used when it is installed, because it writes real `<text>`
elements, so labels stay editable in a vector editor. The cairo device
([`grDevices::svg()`](https://rdrr.io/r/grDevices/cairo.html)) is the
fallback: still vector, but it converts text to glyph paths, which
cannot be edited or restyled afterwards.

## See also

[`draw_to_png()`](https://j-andrews7.github.io/VizModules/dev/reference/draw_to_png.md)
for the raster counterpart.

## Author

Jared Andrews

## Examples

``` r
svg <- draw_to_svg(function() plot(1:10), width = 480, height = 360)
substr(svg, 1, 24)
#> [1] "<svg width=\"480\" height="
```
