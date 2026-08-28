# Build facet subplot annotations

Creates a list of plotly annotation objects suitable for labelling
faceted subplots arranged in a grid of `nrows` rows. When `nrows = 1`
(the default) the behaviour matches the previous single-row layout.
Optionally appends a shared X-axis title (bottom centre) and a shared,
rotated Y-axis title (left centre).

## Usage

``` r
build_facet_annotations(
  facet_levels,
  x.title = NULL,
  y.title = NULL,
  title.font.size = 14,
  nrows = 1,
  fig = NULL,
  title.offset = 0.02
)
```

## Arguments

- facet_levels:

  Character vector of facet level labels, one per subplot.

- x.title:

  Optional character, shared X-axis title. Default: `NULL`.

- y.title:

  Optional character, shared Y-axis title. Default: `NULL`.

- title.font.size:

  Numeric, font size for all annotation text. Default: 14.

- nrows:

  Integer, number of rows the faceted subplots are arranged in. Used to
  compute per-subplot annotation coordinates for multi-row grids when
  `fig` is not supplied. Default: 1.

- fig:

  Optional plotly figure. When supplied, per-panel title coordinates are
  read directly from the figure's xaxis/yaxis domains so that titles
  stay aligned with panels after domain-rewriting helpers such as
  [`apply_facet_subplot_spacing()`](https://j-andrews7.github.io/VizModules/dev/reference/apply_facet_subplot_spacing.md).
  If `NULL` (the default), coordinates are computed from `nrows`
  assuming evenly spaced panels filling the full paper area.

- title.offset:

  Numeric fraction of the figure height to place each subplot title
  above the top of its panel. Default: `0.02`.

## Value

A list of annotation lists suitable for
`plotly::layout(annotations = ...)`.

## Author

Jared Andrews

## Examples

``` r
build_facet_annotations(c("A", "B", "C"), x.title = "X", y.title = "Y")
#> [[1]]
#> [[1]]$x
#> [1] 0.1666667
#> 
#> [[1]]$y
#> [1] 1.05
#> 
#> [[1]]$xref
#> [1] "paper"
#> 
#> [[1]]$yref
#> [1] "paper"
#> 
#> [[1]]$text
#> [1] "A"
#> 
#> [[1]]$showarrow
#> [1] FALSE
#> 
#> [[1]]$xanchor
#> [1] "center"
#> 
#> [[1]]$yanchor
#> [1] "bottom"
#> 
#> [[1]]$font
#> [[1]]$font$size
#> [1] 14
#> 
#> 
#> 
#> [[2]]
#> [[2]]$x
#> [1] 0.5
#> 
#> [[2]]$y
#> [1] 1.05
#> 
#> [[2]]$xref
#> [1] "paper"
#> 
#> [[2]]$yref
#> [1] "paper"
#> 
#> [[2]]$text
#> [1] "B"
#> 
#> [[2]]$showarrow
#> [1] FALSE
#> 
#> [[2]]$xanchor
#> [1] "center"
#> 
#> [[2]]$yanchor
#> [1] "bottom"
#> 
#> [[2]]$font
#> [[2]]$font$size
#> [1] 14
#> 
#> 
#> 
#> [[3]]
#> [[3]]$x
#> [1] 0.8333333
#> 
#> [[3]]$y
#> [1] 1.05
#> 
#> [[3]]$xref
#> [1] "paper"
#> 
#> [[3]]$yref
#> [1] "paper"
#> 
#> [[3]]$text
#> [1] "C"
#> 
#> [[3]]$showarrow
#> [1] FALSE
#> 
#> [[3]]$xanchor
#> [1] "center"
#> 
#> [[3]]$yanchor
#> [1] "bottom"
#> 
#> [[3]]$font
#> [[3]]$font$size
#> [1] 14
#> 
#> 
#> 
#> [[4]]
#> [[4]]$x
#> [1] 0.5
#> 
#> [[4]]$y
#> [1] -0.1
#> 
#> [[4]]$xref
#> [1] "paper"
#> 
#> [[4]]$yref
#> [1] "paper"
#> 
#> [[4]]$text
#> [1] "X"
#> 
#> [[4]]$showarrow
#> [1] FALSE
#> 
#> [[4]]$xanchor
#> [1] "center"
#> 
#> [[4]]$yanchor
#> [1] "top"
#> 
#> [[4]]$annotationType
#> [1] "axis"
#> 
#> [[4]]$font
#> [[4]]$font$size
#> [1] 14
#> 
#> 
#> 
#> [[5]]
#> [[5]]$x
#> [1] -0.05
#> 
#> [[5]]$y
#> [1] 0.5
#> 
#> [[5]]$xref
#> [1] "paper"
#> 
#> [[5]]$yref
#> [1] "paper"
#> 
#> [[5]]$text
#> [1] "Y"
#> 
#> [[5]]$showarrow
#> [1] FALSE
#> 
#> [[5]]$xanchor
#> [1] "center"
#> 
#> [[5]]$yanchor
#> [1] "middle"
#> 
#> [[5]]$textangle
#> [1] -90
#> 
#> [[5]]$annotationType
#> [1] "axis"
#> 
#> [[5]]$font
#> [[5]]$font$size
#> [1] 14
#> 
#> 
#> 
```
