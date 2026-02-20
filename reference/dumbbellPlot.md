# Create an Interactive Dumbbell Plot with plotly

Generates a customizable interactive dumbbell plot using plotly.
Supports single dot mode (1 x variable) or dumbbell mode (2 x
variables), with flexible coloring by either X or Y variables, faceting,
and transformations.

## Usage

``` r
dumbbellPlot(
  reactive.data,
  x,
  y,
  colour.by = "X variables",
  palette.selection,
  show.legend = TRUE,
  facet.by = NULL,
  line.colour = "gray80",
  facet.scales = "fixed",
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
  title.text = "",
  title.font.size = 14,
  title.font.family = "Arial",
  title.text.color = "black",
  y.title = NULL,
  x.title = NULL,
  flip.x = FALSE,
  flip.y = FALSE,
  x.adjustment = NULL,
  order.by = NULL
)
```

## Arguments

- reactive.data:

  A data.frame or tibble containing the data to plot.

- x:

  Character vector of column name(s) for x-axis values. Maximum 2 values
  allowed. If 1 value: creates single dot plot. If 2 values: creates
  dumbbell plot with connecting segments.

- y:

  Character, column name for the y-axis (categorical variable
  recommended).

- colour.by:

  Character, how to color the markers. Options: "X variables" (different
  colors for each x variable) or "Y variables" (different colors for
  each y category). Default: "X variables".

- palette.selection:

  Character vector of hex colors for marker colors.

- show.legend:

  Logical, whether to display the legend. Default: TRUE.

- facet.by:

  Optional character, column name to facet plots by. Creates subplots
  for each unique value. Default: NULL.

- line.colour:

  Character, hex color for the connecting lines between dumbbell points.
  Default: "gray80".

- facet.scales:

  Character, controls axis scaling across facets. Options: "fixed" (same
  for all), "free" (independent), "free_x" (independent x-axis),
  "free_y" (independent y-axis). Default: "fixed".

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

- order.by:

  Optional character vector, column name(s) to order data by before
  plotting. Default: NULL.

## Value

A plotly object representing the interactive dumbbell plot.

## Details

The dumbbell plot is designed for comparing two values across
categories.

**Modes:**

- **Single dot mode** (1 x variable): Shows one marker per y category

- **Dumbbell mode** (2 x variables): Shows two markers connected by a
  line per y category

**Coloring options:**

- **By X variables**: Each x variable gets a different color (e.g.,
  Male=blue, Female=pink)

- **By Y variables**: Each y category gets a different color (e.g.,
  School A=red, School B=blue)

## Author

Jacob Martin

## Examples

``` r
# Dumbbell plot comparing Women vs Men earnings by School
data <- data.frame(
  School = c("MIT", "Stanford", "Harvard"),
  Women = c(94, 96, 112),
  Men = c(152, 151, 165)
)
fig <- dumbbellPlot(
  reactive.data = data,
  x = c("Women", "Men"),
  y = "School",
  colour.by = "X variables",
  palette.selection = c("pink", "blue"),
  show.legend = TRUE,
  line.colour = "gray80"
)
```
