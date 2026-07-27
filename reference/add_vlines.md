# Build vertical line shapes for a plotly figure

Creates shape specifications for one or more vertical lines at specified
x-intercepts. Supports independent styling for each line.

## Usage

``` r
add_vlines(
  fig,
  intercepts,
  colors = "#000000",
  widths = 1,
  linetypes = "solid",
  opacities = 1
)
```

## Arguments

- fig:

  A plotly figure object. Used to detect subplot axes for faceted plots.

- intercepts:

  Numeric vector. X-axis intercepts for vertical lines.

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

If style vector lengths don't match the number of intercepts, only the
first value of each style vector is used for all lines. When the figure
contains subplots (e.g., from faceting), lines are replicated across all
panels with correct axis references.

## Author

Jared Andrews

## Examples

``` r
fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
add_vlines(fig, intercepts = c(3, 4), colors = c("red", "blue"))
#> [[1]]
#> [[1]]$type
#> [1] "line"
#> 
#> [[1]]$x0
#> [1] 3
#> 
#> [[1]]$x1
#> [1] 3
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
#> [1] "y domain"
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
#> [[2]]
#> [[2]]$type
#> [1] "line"
#> 
#> [[2]]$x0
#> [1] 4
#> 
#> [[2]]$x1
#> [1] 4
#> 
#> [[2]]$xref
#> [1] "x"
#> 
#> [[2]]$y0
#> [1] 0
#> 
#> [[2]]$y1
#> [1] 1
#> 
#> [[2]]$yref
#> [1] "y domain"
#> 
#> [[2]]$line
#> [[2]]$line$color
#> [1] "blue"
#> 
#> [[2]]$line$width
#> [1] 1
#> 
#> [[2]]$line$dash
#> [1] "solid"
#> 
#> 
#> [[2]]$opacity
#> [1] 1
#> 
#> 
```
