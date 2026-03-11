# Input UI components for the SplitBarPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_SplitBarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotServer.md)
and
[`plotthis_SplitBarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotOutputUI.md)
functions.

## Usage

``` r
plotthis_SplitBarPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = NULL,
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation.

- defaults:

  A named list of default values for the inputs.

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The user inputs for this module are separated from the outputs to allow
for more flexible UI design.

The inputs will automatically be organized into a grid layout via the
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`plotthis::SplitBarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::SplitBarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `title` - Plot title (plotly allows interactive editing)

- `subtitle` - Plot subtitle (not supported in plotly)

- `aspect.ratio` - Aspect ratio control (handled by plotly layout)

- `legend.position` - Legend positioning (plotly allows interactive
  repositioning)

- `y` - Y-axis variable (automatically set from data structure)

- `y_sep` - Separator for y columns (not applicable in UI context)

- `flip` - Flip axes (not implemented in current UI)

- `split_by_sep` - Separator for split columns (not applicable in UI
  context)

- `order_y` - Y-axis ordering rules (handled by default logic)

- `lineheight` - Text line height (not applicable in plotly)

- `max_charwidth` - Maximum character width (not applicable in plotly)

- `fill_by_sep` - Separator for fill columns (not applicable in UI
  context)

- `fill_name` - Fill legend name (handled by plotly)

- `direction_pos_name` - Positive direction name (not implemented)

- `direction_neg_name` - Negative direction name (not implemented)

- `theme` - ggplot2 theme (not applicable in plotly)

- `theme_args` - Theme arguments (not applicable in plotly)

- `palette` - Managed internally via the palette selection UI

- `keep_empty` - Keep empty values (not implemented)

- `keep_na` - Keep NA values (not implemented)

- `combine` - Only applies if `split_by` is used

- `nrow` - Only applies if `split_by` is used

- `ncol` - Only applies if `split_by` is used

- `byrow` - Only applies if `split_by` is used

- `seed` - Random seed (not applicable)

- `axes` - Only applies if `split_by` is used

- `axis_titles` - Only applies if `split_by` is used

- `guides` - Only applies if `split_by` is used

- `design` - Only applies if `split_by` is used

- `legend_direction` - Managed position of legend however this can be
  handled via plotly

## Plot parameters and defaults

The following
[`plotthis::SplitBarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X values", default: 2nd numeric variable)

- `fill_by` - Fill color variable (UI: "Fill by", default: 2nd variable)

- `alpha_by` - Variable for alpha transparency (UI: "Alpha by", default:
  "")

- `alpha_reverse` - Reverse alpha order (UI: "Alpha reverse", default:
  FALSE)

- `alpha_name` - Alpha legend name (UI: "Alpha name", default: "")

- `bar_height` - Height of bars (UI: "Bar height", default: 0.9)

- `facet_by` - Faceting variable (UI: "Facet by", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet scale", default:
  "free_y")

- `facet_ncol` - Number of facet columns (UI: "Facet number of columns",
  default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Facet number of rows",
  default: NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet by row", default:
  TRUE)

- `split_by` - Split variable (UI: "Split by", default: "")

- `x_min` - Minimum X-axis value (UI: "X-axis min", default: calculated
  from data)

- `x_max` - Maximum X-axis value (UI: "X-axis max", default: calculated
  from data)

- `palcolor` - Custom color values (UI: palette picker, derived from
  palette)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `label.on.y.axis` - Show category labels on the Y axis instead of on
  the plot (UI: "Labels on Y axis", default: FALSE). When enabled, the
  text position slider is hidden and labels appear as Y-axis tick
  labels.

- `text.position` - Position of category labels along the X axis (UI:
  "Position of category labels", default: 0). Only visible when
  `label.on.y.axis` is FALSE.

- `axis.font.size` - Axis title font size (UI: "Axis font size",
  default: 18)

- `title.font.size` - Plot title font size (UI: "Title font size",
  default: 28)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `text.colour` - Color for axis labels (UI: "Label colour", default:
  "#000000")

- `axis.showline` - Show axis border lines (UI: "Show axis lines",
  default: TRUE)

- `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror axis
  lines", default: TRUE)

- `show.grid.x` - Show X-axis major gridlines (UI: "Show X major
  gridlines", default: TRUE)

- `show.grid.y` - Show Y-axis major gridlines (UI: "Show Y major
  gridlines", default: TRUE)

- `axis.linecolor` - Color of axis lines (UI: "Axis line color",
  default: "black")

- `axis.linewidth` - Width of axis lines (UI: "Axis line width",
  default: 0.5)

- `axis.tickfont.size` - Size of tick labels (UI: "Tick label size",
  default: 12)

- `axis.tickfont.color` - Color of tick labels (UI: "Tick label color",
  default: "black")

- `axis.tickfont.family` - Font family for tick labels (UI: "Tick label
  font", default: "Arial")

- `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI:
  "X-axis tick label angle", default: 0)

- `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI:
  "Y-axis tick label angle", default: 0)

- `axis.ticks` - Position of tick marks (UI: "Tick position", default:
  "outside")

- `axis.tickcolor` - Color of tick marks (UI: "Tick mark color",
  default: "black")

- `axis.ticklen` - Length of tick marks (UI: "Tick mark length",
  default: 5)

- `axis.tickwidth` - Width of tick marks (UI: "Tick mark width",
  default: 1)

- `hline.intercepts` - Y-coordinates for horizontal reference lines (UI:
  "Y-intercepts", default: "")

- `hline.colors` - Colors for horizontal lines (UI: "Colors", default:
  "#000000")

- `hline.widths` - Widths for horizontal lines (UI: "Widths", default:
  "1")

- `hline.linetypes` - Line types for horizontal lines (UI: "Line types",
  default: "dashed")

- `hline.opacities` - Opacities for horizontal lines (UI: "Opacities
  (0-1)", default: "1")

- `vline.intercepts` - X-coordinates for vertical reference lines (UI:
  "X-intercepts", default: "")

- `vline.colors` - Colors for vertical lines (UI: "Colors", default:
  "#000000")

- `vline.widths` - Widths for vertical lines (UI: "Widths", default:
  "1")

- `vline.linetypes` - Line types for vertical lines (UI: "Line types",
  default: "dashed")

- `vline.opacities` - Opacities for vertical lines (UI: "Opacities
  (0-1)", default: "1")

- `abline.slopes` - Slopes for diagonal reference lines (UI: "Slopes",
  default: "")

- `abline.intercepts` - Y-intercepts for diagonal lines (UI:
  "Y-intercepts", default: "")

- `abline.colors` - Colors for diagonal lines (UI: "Colors", default:
  "#000000")

- `abline.widths` - Widths for diagonal lines (UI: "Widths", default:
  "1")

- `abline.linetypes` - Line types for diagonal lines (UI: "Line types",
  default: "dashed")

- `abline.opacities` - Opacities for diagonal lines (UI: "Opacities
  (0-1)", default: "1")

## See also

[`plotthis::SplitBarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`plotthis_SplitBarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotOutputUI.md),
[`plotthis_SplitBarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotServer.md),
[`plotthis_SplitBarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_SplitBarPlotApp.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
mtcars$cyl <- as.factor(mtcars$cyl)
plotthis_SplitBarPlotInputsUI("splitBarPlot", mtcars)
#> Error in FUN(X[[i]], ...): object '.' not found
```
