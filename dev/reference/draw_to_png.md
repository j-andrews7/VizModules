# Render a grid or base drawing to PNG bytes

The raster counterpart to
[`draw_to_svg()`](https://j-andrews7.github.io/VizModules/dev/reference/draw_to_svg.md),
for the same job: letting a module whose output is not a plotly graph
supply its own artwork to an export. Where
[`draw_to_svg()`](https://j-andrews7.github.io/VizModules/dev/reference/draw_to_svg.md)
yields markup to splice, this yields the bytes of a finished file.

## Usage

``` r
draw_to_png(draw_fn, width, height, res = 72, scale = 2, bg = "white")
```

## Arguments

- draw_fn:

  A function of no arguments that draws onto the active device.

- width, height:

  Size in pixels.

- res:

  Pixels per inch used to size the drawing. The default matches
  [`shiny::renderPlot()`](https://rdrr.io/pkg/shiny/man/renderPlot.html)'s
  own `res`, so the result is laid out on a canvas the same physical
  size as the one the plot was rendered at on screen – which matters for
  anything sized in absolute points; see the note on `res` in
  [`draw_to_svg()`](https://j-andrews7.github.io/VizModules/dev/reference/draw_to_svg.md).

- scale:

  Pixel density multiplier. The drawing is laid out at the same physical
  size (`res` scales with the pixel count) but rasterised at `scale`
  times the resolution, so the result is a crisp image rather than a
  screenshot. Matches the `scale` plotly's own image export defaults to.

- bg:

  Background color.

## Value

A raw vector holding a PNG file, or `NULL` if the requested size is not
usable or the R build has no PNG support. An error raised by `draw_fn`
itself propagates to the caller; the device is closed either way.

## See also

[`draw_to_svg()`](https://j-andrews7.github.io/VizModules/dev/reference/draw_to_svg.md)
for the vector counterpart.

## Author

Jared Andrews

## Examples

``` r
png_bytes <- draw_to_png(function() plot(1:10), width = 480, height = 360)
head(png_bytes, 4)
#> [1] 89 50 4e 47
```
