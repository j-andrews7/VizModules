# Build paper-anchored panel border shapes for a faceted plotly figure

Native plotly [`subplot()`](https://rdrr.io/pkg/plotly/man/subplot.html)
figures with shared (`shareX`/`shareY`) axes do not render axis border
lines on the matched/inner panels, so faceted plots end up with a box
around only the first panel. This helper reconstructs each panel's
rectangle from the grid of x/y axis domains in the figure layout and
returns paper-anchored shapes that draw a uniform border around every
panel.

## Usage

``` r
build_facet_panel_borders(
  fig,
  n_facets,
  showline = TRUE,
  mirror = TRUE,
  linecolor = "black",
  linewidth = 0.5,
  ncol = NULL,
  nrow = NULL
)
```

## Arguments

- fig:

  A plotly figure object whose `x$layout` contains the per-panel
  `xaxis*`/`yaxis*` domains (typically after
  [`subplot()`](https://rdrr.io/pkg/plotly/man/subplot.html) and
  [`apply_facet_subplot_spacing()`](https://j-andrews7.github.io/VizModules/dev/reference/apply_facet_subplot_spacing.md)).

- n_facets:

  Integer, number of facet panels.

- showline:

  Logical, whether to draw border lines. Default `TRUE`.

- mirror:

  Logical, whether to mirror the lines to form a full box. Default
  `TRUE`.

- linecolor:

  Character, colour of the border lines. Default `"black"`.

- linewidth:

  Numeric, width of the border lines in pixels. Default `0.5`.

- ncol:

  Optional integer. Number of facet columns. If `NULL` or `NA`, detected
  from the distinct x-axis domain starts.

- nrow:

  Optional integer. Number of facet rows. If `NULL` or `NA`, detected
  from the distinct y-axis domain starts.

## Value

A list of plotly shape definitions (each paper-anchored). Returns an
empty list when borders should not be drawn or panel domains cannot be
resolved.

## Details

Panel rectangles are derived from the geometry of the subplot grid
rather than from a per-panel axis index. With shared axes plotly only
keeps one axis per column (x) and one per row (y), so an
`xaxis{i}`/`yaxis{i}` lookup keyed on the facet index breaks down for
grids with more than one row or column. Instead the distinct x-axis
domain starts define the columns (left to right) and the distinct y-axis
domain starts define the rows (top to bottom), and each facet panel is
mapped to a (row, column) cell in row-major fill order — matching how
[`subplot()`](https://rdrr.io/pkg/plotly/man/subplot.html) lays panels
out.

The borders honour the same axis styling semantics used for single-panel
figures:

- `showline` and `mirror` both `TRUE`: full rectangle border around each
  panel.

- only `showline` `TRUE`: left and bottom edges only.

- `showline` `FALSE`: no borders (empty list).

## Author

Jacob Martin

## Examples

``` r
p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~cyl)
fig <- plotly::ggplotly(p)
build_facet_panel_borders(fig, n_facets = 3)
#> [[1]]
#> [[1]]$type
#> [1] "rect"
#> 
#> [[1]]$xref
#> [1] "paper"
#> 
#> [[1]]$yref
#> [1] "paper"
#> 
#> [[1]]$x0
#> [1] 0
#> 
#> [[1]]$x1
#> [1] 0.3219178
#> 
#> [[1]]$y0
#> [1] 0
#> 
#> [[1]]$y1
#> [1] 1
#> 
#> [[1]]$line
#> [[1]]$line$color
#> [1] "black"
#> 
#> [[1]]$line$width
#> [1] 0.5
#> 
#> 
#> [[1]]$fillcolor
#> [1] "rgba(0,0,0,0)"
#> 
#> [[1]]$layer
#> [1] "above"
#> 
#> 
#> [[2]]
#> [[2]]$type
#> [1] "rect"
#> 
#> [[2]]$xref
#> [1] "paper"
#> 
#> [[2]]$yref
#> [1] "paper"
#> 
#> [[2]]$x0
#> [1] 0.3447489
#> 
#> [[2]]$x1
#> [1] 0.6552511
#> 
#> [[2]]$y0
#> [1] 0
#> 
#> [[2]]$y1
#> [1] 1
#> 
#> [[2]]$line
#> [[2]]$line$color
#> [1] "black"
#> 
#> [[2]]$line$width
#> [1] 0.5
#> 
#> 
#> [[2]]$fillcolor
#> [1] "rgba(0,0,0,0)"
#> 
#> [[2]]$layer
#> [1] "above"
#> 
#> 
#> [[3]]
#> [[3]]$type
#> [1] "rect"
#> 
#> [[3]]$xref
#> [1] "paper"
#> 
#> [[3]]$yref
#> [1] "paper"
#> 
#> [[3]]$x0
#> [1] 0.6780822
#> 
#> [[3]]$x1
#> [1] 1
#> 
#> [[3]]$y0
#> [1] 0
#> 
#> [[3]]$y1
#> [1] 1
#> 
#> [[3]]$line
#> [[3]]$line$color
#> [1] "black"
#> 
#> [[3]]$line$width
#> [1] 0.5
#> 
#> 
#> [[3]]$fillcolor
#> [1] "rgba(0,0,0,0)"
#> 
#> [[3]]$layer
#> [1] "above"
#> 
#> 
```
