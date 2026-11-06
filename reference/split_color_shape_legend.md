# Give a plot's colour and shape their own legend sections

A ggplot mapping both colour and shape to discrete columns has two
legends, but
[`plotly::ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html)
merges them into one with an entry per combination, named
`"(colour,shape)"` under a `"colour<br />shape"` title. This draws them
as ggplot2 does instead: one legend in two titled sections, an entry per
colour level and one per shape level (in black, as ggplot2 draws shape
keys). Clicking an entry hides or shows every trace of its level, and
double-clicking one shows only its level (`inst/src/legendSections.js`).

## Usage

``` r
split_color_shape_legend(
  fig,
  color.levels,
  shape.levels,
  color.title = NULL,
  shape.title = NULL,
  marker.size = 8
)
```

## Arguments

- fig:

  A built plotly figure.

- color.levels, shape.levels:

  The colour and shape levels as plotted.

- color.title, shape.title:

  The sections' titles. `NULL` takes each from the legend title ggplotly
  wrote.

- marker.size:

  The size, in px, of the entries' markers.

## Value

The figure, unchanged when no trace is drawn for a combination of a
colour and a shape level.

## Details

The point traces drawn for each combination are kept, out of the legend
and tagged with their levels (in `meta`). A trace drawn for a colour
alone, such as a yPlot's boxes (`"(colour,1)"`, ggplot's placeholder
shape for them), becomes its level's colour entry; a level without one
gets a data-less legend-only trace, as does every shape level. Those are
appended after the existing traces, so no trace's index (a selection's
curve number) moves. Traces grouped under a colour level by name (the
scatter plot's marginals) are hidden and shown with it.

## See also

[`apply_legend_styling()`](https://j-andrews7.github.io/VizModules/reference/apply_legend_styling.md),
whose title fonts style the section titles.

## Author

Jared Andrews

## Examples

``` r
d <- transform(mtcars, am = factor(am), vs = factor(vs))
p <- ggplot2::ggplot(d, ggplot2::aes(wt, mpg, colour = am, shape = vs)) +
    ggplot2::geom_point()
fig <- plotly::plotly_build(plotly::ggplotly(p))
fig <- split_color_shape_legend(fig, levels(d$am), levels(d$vs))
```
