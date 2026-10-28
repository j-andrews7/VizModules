# Create an Interactive Line Plot with plotly

Generates a customizable interactive line plot using plotly, supporting
grouping, faceting, axis adjustments, and color palettes.

## Usage

``` r
linePlot(
  data,
  x,
  y,
  palette.selection,
  plot.mode = "lines",
  line.type = "solid",
  colour.group.by = NULL,
  show.legend = TRUE,
  facet.by = NULL,
  facet.scales = "fixed",
  facet.nrow = NULL,
  facet.ncol = NULL,
  subplot.margin = 0.05,
  axis.showline = TRUE,
  axis.mirror = TRUE,
  axis.linecolor = "black",
  axis.linewidth = 0.5,
  axis.tickfont.size = 12,
  axis.tickfont.color = "black",
  axis.tickfont.family = "Arial",
  axis.tickangle.x = 0,
  axis.tickangle.y = 0,
  axis.ticks = "outside",
  axis.tickcolor = "black",
  axis.ticklen = 5,
  axis.tickwidth = 1,
  show.grid.x = TRUE,
  show.grid.y = TRUE,
  grid.color = "#CCCCCC",
  axis.title.font.size = 18,
  axis.title.font.color = "black",
  axis.title.font.family = "Arial",
  facet.title.font.size = 18,
  facet.title.font.color = "black",
  facet.title.font.family = "Arial",
  title.text = "",
  title.font.size = 14,
  title.font.family = "Arial",
  title.font.color = "black",
  title.x.position = 0.47,
  y.title = NULL,
  x.title = NULL,
  flip.x = FALSE,
  flip.y = FALSE,
  x.adjustment = NULL,
  y.adjustment = NULL,
  color.adjustment = NULL,
  order.by = NULL,
  error.colour = NULL,
  error.width = NULL,
  error.bar = FALSE,
  error.type = c("sd", "sem", "ci95", "columns"),
  error.ci.method = c("normal", "t"),
  error.lower = NULL,
  error.upper = NULL,
  error.ribbon = FALSE,
  error.ribbon.opacity = 0.25
)
```

## Arguments

- data:

  A data.frame or tibble containing the data to plot.

- x:

  Character vector of column name(s) for the x-axis. Multiple columns
  create separate traces.

- y:

  Character vector of column name(s) for the y-axis. Multiple columns
  create separate traces.

- palette.selection:

  Character vector of hex colors for line colors. Used to assign colors
  to groups or traces.

- plot.mode:

  Character, plotly mode for plot type. Options: "lines", "markers",
  "lines+markers". Default: "lines".

- line.type:

  Character, line style. Options: "solid", "dot", "dash", "longdash",
  "dashdot", "longdashdot". Default: "solid".

- colour.group.by:

  Character or formula, column name(s) to group lines by color. Can be a
  formula like `~ column_name`. Ignored if multiple `x` or `y` columns
  are provided. Default: `NULL`.

- show.legend:

  Logical, whether to display the legend. Default: TRUE.

- facet.by:

  Optional character, column name to facet plots by. Creates subplots
  for each unique value. Default: NULL.

- facet.scales:

  Character, controls axis scaling across facets. Options: "fixed" (same
  for all), "free" (independent), "free_x" (independent x-axis),
  "free_y" (independent y-axis). Default: "fixed".

- facet.nrow:

  Optional integer, number of rows in the faceted subplot grid. If
  `NULL` (default), a single row is used unless `facet.ncol` is
  supplied, in which case the number of rows is derived from the number
  of facet levels.

- facet.ncol:

  Optional integer, number of columns in the faceted subplot grid. If
  `NULL` (default), columns are derived from `facet.nrow` and the number
  of facet levels. Only one of `facet.nrow` / `facet.ncol` needs to be
  set; if both are provided, `facet.nrow` takes precedence.

- subplot.margin:

  Numeric, spacing between facet panels as a fraction of the plot area.
  May be a single value (applied to both directions) or a length-2
  vector `c(horizontal, vertical)` to control the gap between columns
  and rows separately. Default: 0.05.

- axis.showline:

  Logical, whether to show axis border lines. Default: TRUE.

- axis.mirror:

  Logical, whether to mirror axis lines on opposite side of plot.
  Default: TRUE.

- axis.linecolor:

  Character, hex color for axis lines. Default: "black".

- axis.linewidth:

  Numeric, width of axis lines in pixels. Default: 0.5.

- axis.tickfont.size:

  Numeric, font size for axis tick labels. Default: 12.

- axis.tickfont.color:

  Character, hex color for axis tick labels. Default: "black".

- axis.tickfont.family:

  Character, font family for axis tick labels. Default: "Arial".

- axis.tickangle.x:

  Numeric, rotation angle for x-axis tick labels in degrees. Default: 0.

- axis.tickangle.y:

  Numeric, rotation angle for y-axis tick labels in degrees. Default: 0.

- axis.ticks:

  Character, position of tick marks. Options: "outside", "inside",
  "none". Default: "outside".

- axis.tickcolor:

  Character, hex color for tick marks. Default: "black".

- axis.ticklen:

  Numeric, length of tick marks in pixels. Default: 5.

- axis.tickwidth:

  Numeric, width of tick marks in pixels. Default: 1.

- show.grid.x:

  Logical, whether to show gridlines on the x-axis. Default: TRUE.

- show.grid.y:

  Logical, whether to show gridlines on the y-axis. Default: TRUE.

- grid.color:

  Character, hex color for gridlines. Default: "#CCCCCC".

- axis.title.font.size:

  Numeric, font size for the x/y axis titles. Default: 18.

- axis.title.font.color:

  Character, hex color for the x/y axis titles. Default: "black".

- axis.title.font.family:

  Character, font family for the x/y axis titles. Default: "Arial".

- facet.title.font.size:

  Numeric, font size for the facet panel titles. Default: 18.

- facet.title.font.color:

  Character, hex color for the facet panel titles. Default: "black".

- facet.title.font.family:

  Character, font family for the facet panel titles. Default: "Arial".

- title.text:

  Character, main title text for the plot. Default: "".

- title.font.size:

  Numeric, font size for plot title. Default: 14.

- title.font.family:

  Character, font family for plot title. Default: "Arial".

- title.font.color:

  Character, hex color for plot title text. Default: "black".

- title.x.position:

  Numeric, horizontal position of the plot title in paper coordinates (0
  = left, 1 = right). Default: 0.47.

- y.title:

  Optional character, label for y-axis. If NULL, auto-generated from
  column name. When `x` is a single categorical column, the plotted
  y-values are per-group means, so the title is wrapped as
  `mean(<y.title>)` to accurately describe the summary displayed.
  Default: NULL.

- x.title:

  Optional character, label for x-axis. If NULL, auto-generated from
  column name. Default: NULL.

- flip.x:

  Logical, whether to reverse the x-axis direction. Default: FALSE.

- flip.y:

  Logical, whether to reverse the y-axis direction. Default: FALSE.

- x.adjustment:

  Optional character or function, transformation to apply to x values.
  Options: "log2", "log", "log10", "neg_log10", "log1p", "as.factor",
  "abs", "sqrt", or custom function. Default: NULL.

- y.adjustment:

  Optional character or function, transformation to apply to y values.
  Options: "log2", "log", "log10", "neg_log10", "log1p", "as.factor",
  "abs", "sqrt", or custom function. Default: NULL.

- color.adjustment:

  Optional character or function, transformation to apply to color
  grouping variable. Same options as x.adjustment and y.adjustment.
  Default: NULL.

- order.by:

  Optional character vector, column name(s) to order data by before
  plotting. Default: NULL.

- error.colour:

  Hex colour of the error bars. Default: `NULL` (the series' own
  colour).

- error.width:

  Numeric, thickness of the error bars. Default: `NULL` (plotly's
  default).

- error.bar:

  Logical, whether to draw the interval `error.type` selects as error
  bars. Needs a single `y`, and a single categorical `x` unless
  `error.type = "columns"`. For `"sd"`, `"sem"` and `"ci95"`, each bar
  spans the plotted group mean plus or minus that amount, computed from
  the group's y-values, where a group is a single x category, split
  further by `colour.group.by` and `facet.by` when those are set. A
  group with fewer than two observations has no spread and is drawn
  without a bar. Default: `FALSE`.

- error.type:

  What the error bars and ribbon show, one of `"sd"` (one standard
  deviation, the default), `"sem"` (one standard error of the mean,
  `sd / sqrt(n)`), `"ci95"` (a 95% confidence interval for the mean) or
  `"columns"` (the interval between the `error.lower` and `error.upper`
  columns). Missing values are ignored when counting `n`. The first
  three summarise each group, so they need a categorical `x`.
  `"columns"` works with any `x`. It suits intervals worked out
  beforehand, such as a model's confidence or prediction interval, a
  forecast range or a min/max range.

- error.ci.method:

  How `error.type = "ci95"` is computed, one of `"normal"` (the default;
  the standard error times the 97.5th percentile of the normal
  distribution, 1.96) or `"t"` (the standard error times the 97.5th
  percentile of the t distribution with `n - 1` degrees of freedom). The
  t interval is wider for small groups and converges on the normal one
  as `n` grows. Ignored for the other error types.

- error.lower, error.upper:

  Optional character, names of the numeric columns holding each point's
  lower and upper bound, for `error.type = "columns"`. Either order
  works. The bounds are on the y-axis's scale, so `y.adjustment` is
  applied to them too. With a categorical `x`, they are averaged per
  group, as `y` is, so supply one row per x position (and colour/facet
  group). A bound that lies on the wrong side of the line draws no bar
  on that side. Default: `NULL`.

- error.ribbon:

  Logical, whether to draw the interval `error.type` selects as a shaded
  band (a ribbon) behind each line, in the line's own colour, on its own
  or alongside the error bars. It has the same requirements as
  `error.bar`. A point without an interval leaves a gap in the band, so
  an isolated point's interval shows only as a bar. No ribbon is drawn
  for a numeric `colour.group.by`, which plotly does not split into
  separate lines. Hovering a band's edge shows that bound. Default:
  `FALSE`.

- error.ribbon.opacity:

  Numeric between 0 and 1, the ribbon's fill opacity. Default: 0.25.

## Value

A plotly object representing the interactive line plot.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
palette <- plotthis::palette_list[["Set2"]]
fig <- linePlot(
    data = mtcars,
    x = "cyl",
    y = "mpg",
    plot.mode = "lines",
    line.type = "solid",
    colour.group.by = "mpg",
    palette.selection = palette,
    show.legend = TRUE
)

# Each product line's yearly mean revenue, with a 95% confidence interval ribbon.
fig2 <- linePlot(
    data = example_sales,
    x = "year",
    y = "revenue",
    colour.group.by = "product_line",
    palette.selection = palette[1:3],
    error.type = "ci95",
    error.ribbon = TRUE
)

# A band from columns holding precomputed bounds, on a numeric x-axis.
fit <- data.frame(t = 1:20, est = sqrt(1:20))
fit$lo <- fit$est - 0.4
fit$hi <- fit$est + 0.4
fig3 <- linePlot(
    data = fit,
    x = "t",
    y = "est",
    palette.selection = "#1B9E77",
    error.type = "columns",
    error.lower = "lo",
    error.upper = "hi",
    error.ribbon = TRUE
)
```
