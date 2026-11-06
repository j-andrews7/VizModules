# Draw a figure's point layers with WebGL

SVG slows down badly with many points, where WebGL does not. This
switches the figure's point traces (`scatter` traces drawn as markers
only: jitter, the points of a scatter plot) to `scattergl` once,
together, they hold at least `threshold` points. Lines, filled areas,
boxes, and violins stay SVG, so they stay vector in SVG downloads; only
the switched points become an embedded image there. Unlike
[`plotly::toWebGL()`](https://rdrr.io/pkg/plotly/man/toWebGL.html),
which switches every trace.

## Usage

``` r
auto_webgl(fig, threshold = .webgl_threshold(), overlays = FALSE)
```

## Arguments

- fig:

  A plotly figure, built or as
  [`plotly::ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html)
  returns it.

- threshold:

  Point count at and above which the points switch.

- overlays:

  Logical; also switch unfilled line traces, for lines that must stay on
  top of the points.

## Value

The figure.

## Details

WebGL canvases sit above SVG traces, so a line drawn over the points (an
ellipse, a contour) would end up beneath them. Set `overlays = TRUE` to
switch a figure's unfilled line traces with its points, which keeps
their order. The points alone decide whether the threshold is reached,
and filled traces stay SVG either way.

Pair it with
[`webgl_input()`](https://j-andrews7.github.io/VizModules/reference/webgl_input.md).
The default threshold is 5,000 points, or
`options(VizModules.webgl.threshold = n)`.

## See also

[`webgl_input()`](https://j-andrews7.github.io/VizModules/reference/webgl_input.md)

## Author

Jared Andrews

## Examples

``` r
fig <- plotly::plot_ly(x = rnorm(100), y = rnorm(100), type = "scatter", mode = "markers")
fig <- plotly::plotly_build(fig)
auto_webgl(fig, threshold = 50)$x$data[[1]]$type
#> [1] "scattergl"
```
