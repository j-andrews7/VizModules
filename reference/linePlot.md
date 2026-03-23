# Create an Interactive Line Plot with plotly

Generates a customizable interactive line plot using plotly, supporting
grouping, faceting, axis adjustments, and color palettes.

## Usage

``` r
linePlot(
  data,
  x,
  y,
  plot.mode,
  line.type,
  colour.group.by,
  palette.selection,
  show.legend,
  facet.by = NULL,
  facet.scales = "fixed",
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
  title.text = "",
  title.font.size = 14,
  title.font.family = "Arial",
  title.text.color = "black",
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
  error.bar = FALSE
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

- plot.mode:

  Character, plotly mode for plot type. Options: "lines", "markers",
  "lines+markers". Default: "lines".

- line.type:

  Character, line style. Options: "solid", "dot", "dash", "longdash",
  "dashdot", "longdashdot". Default: "solid".

- colour.group.by:

  Character or formula, column name(s) to group lines by color. Can be a
  formula like `~ column_name`.

- palette.selection:

  Character vector of hex colors or palette name for line colors. Used
  to assign colors to groups or traces.

- show.legend:

  Logical, whether to display the legend. Default: TRUE.

- facet.by:

  Optional character, column name to facet plots by. Creates subplots
  for each unique value. Default: NULL.

- facet.scales:

  Character, controls axis scaling across facets. Options: "fixed" (same
  for all), "free" (independent), "free_x" (independent x-axis),
  "free_y" (independent y-axis). Default: "fixed".

- subplot.margin:

  Numeric, spacing between facet panels as a fraction of the plot area.
  Default: 0.05.

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

- title.text:

  Character, main title text for the plot. Default: "".

- title.font.size:

  Numeric, font size for plot title. Default: 14.

- title.font.family:

  Character, font family for plot title. Default: "Arial".

- title.text.color:

  Character, hex color for plot title text. Default: "black".

- y.title:

  Optional character, label for y-axis. If NULL, auto-generated from
  column name. Default: NULL.

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

  hex colour input to set the colour of the error bars on a plot with a
  categorical X axis and only 1 Y axis variable

- error.width:

  numeric input to set the width of the error bars on a plot with a
  categorical X axis and only 1 Y axis variable

- error.bar:

  Boolean value to determine if error bars will be on or off on a plot
  with a categorical X axis and only 1 Y axis variable

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
```
