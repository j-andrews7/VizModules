# Build diagonal (abline) line shapes for a plotly figure

Creates shape specifications for one or more diagonal lines defined by
slope and intercept. Lines are drawn across the provided or computed
axis range.

## Usage

``` r
add_ablines(
  fig,
  slopes,
  intercepts,
  colors = "#000000",
  widths = 1,
  linetypes = "solid",
  opacities = 1
)
```

## Arguments

- fig:

  A plotly figure object (used to determine x-axis range and detect
  subplots).

- slopes:

  Numeric vector. Slopes for the diagonal lines.

- intercepts:

  Numeric vector. Y-intercepts for the diagonal lines. Must be same
  length as slopes.

- colors:

  Character vector. Line colors (hex or named colors).

- widths:

  Numeric vector. Line widths in pixels.

- linetypes:

  Character vector. Line types: "solid", "dashed", "dotted", "dotdash",
  "longdash", "twodash".

- opacities:

  Numeric vector. Line opacities (0 to 1).

## Value

A list of shape specifications for use with plotly::layout().

## Details

If style vector lengths don't match the number of lines, only the first
value of each style vector is used for all lines. If slopes and
intercepts have different lengths, the shorter one is recycled. When the
figure contains subplots (e.g., from faceting), lines are replicated
across all panels with correct axis references.

## Author

Jared Andrews

## Examples

``` r
fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
add_ablines(fig, slopes = 1, intercepts = 0, colors = "red")
#> [[1]]
#> [[1]]$type
#> [1] "line"
#> 
#> [[1]]$x0
#> [1] 0
#> 
#> [[1]]$x1
#> [1] 1
#> 
#> [[1]]$xref
#> [1] "x"
#> 
#> [[1]]$y0
#> [1] 0
#> 
#> [[1]]$y1
#> [1] 1
#> 
#> [[1]]$yref
#> [1] "y"
#> 
#> [[1]]$line
#> [[1]]$line$color
#> [1] "red"
#> 
#> [[1]]$line$width
#> [1] 1
#> 
#> [[1]]$line$dash
#> [1] "solid"
#> 
#> 
#> [[1]]$opacity
#> [1] 1
#> 
#> 
```
