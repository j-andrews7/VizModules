# Input UI components for the BarPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_BarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotServer.md)
and
[`plotthis_BarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotOutputUI.md)
functions.

## Usage

``` r
plotthis_BarPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`plotthis::BarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::BarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `title` - Plot title (plotly allows interactive editing)

- `subtitle` - Plot subtitle (not supported in plotly)

- `aspect.ratio` - Aspect ratio control (handled by plotly layout)

- `legend.position` - Legend positioning (plotly allows interactive
  repositioning)

- `position` - Bar position (auto, stack, dodge, fill) (not yet
  implemented)

- `position_dodge_preserve` - Preserve bar width when dodging (not yet
  implemented)

- `x_sep` - Separator for multiple x columns (not yet implemented)

- `group_by_sep` - Separator for multiple group_by columns (not yet
  implemented)

- `split_by_sep` - Separator for multiple split_by columns (not yet
  implemented)

- `flip` - Flip axes (not yet implemented)

- `fill_by_x_if_no_group` - Fill bars by x values (not yet implemented)

- `line_name` - Name of line (not yet implemented)

- `label` - Bar labels on top (not yet implemented)

- `label_nudge` - Label nudge distance (not yet implemented)

- `label_fg` - Label foreground color (not yet implemented)

- `label_size` - Label size (not yet implemented)

- `label_bg` - Label background color (not yet implemented)

- `label_bg_r` - Label background radius (not yet implemented)

- `group_name` - Group legend name (not yet implemented)

- `facet_args` - Additional facet arguments (not yet implemented)

- `add_bg` - Add background stripes (not yet implemented)

- `bg_palette` - Background palette (not yet implemented)

- `bg_palcolor` - Background palette colors (not yet implemented)

- `bg_alpha` - Background alpha (not yet implemented)

- `add_line` - Add horizontal line (not yet implemented)

- `line_color` - Horizontal line color (not yet implemented)

- `line_width` - Horizontal line width (not yet implemented)

- `line_type` - Horizontal line type (not yet implemented)

- `add_trend` - Add trend line (not yet implemented)

- `trend_color` - Trend line color (not yet implemented)

- `trend_linewidth` - Trend line width (not yet implemented)

- `trend_ptsize` - Trend point size (not yet implemented)

- `theme` - ggplot2 theme (managed internally)

- `theme_args` - Theme arguments (not yet implemented)

- `palette` - Managed internally via the palette selection UI

- `x_text_angle` - X-axis text angle (handled by axis.tickangle.x)

- `legend.direction` - Legend orientation (plotly allows interactive
  adjustment)

- `keep_empty` - Keep empty factor levels (not yet implemented)

- `keep_na` - Keep NA values (not yet implemented)

- `combine` - Combine multiple plots (not applicable for plotly)

- `nrow` - Only applies if `split_by` is used with combine

- `ncol` - Only applies if `split_by` is used with combine

- `byrow` - Only applies if `split_by` is used with combine

- `seed` - Random seed (not applicable)

- `axes` - Only applies if `split_by` is used with combine

- `axis_titles` - Only applies if `split_by` is used with combine

- `guides` - Only applies if `split_by` is used with combine

- `design` - Only applies if `split_by` is used with combine

## Plot parameters and defaults

The following
[`plotthis::BarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X values", default: 2nd categorical
  variable)

- `y` - Y-axis variable (UI: "Y values", default: 2nd numeric variable)

- `group_by` - Grouping variable for bar fill (UI: "Group by", default:
  2nd categorical variable)

- `split_by` - Split variable for separate plots (UI: "Split by",
  default: "")

- `facet_by` - Faceting variable (UI: "Facet by", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet scale", default:
  "fixed")

- `facet_ncol` - Number of facet columns (UI: "Facet number of columns",
  default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Facet number of rows",
  default: NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet by row", default:
  TRUE)

- `palcolor` - Custom color values (UI: palette picker, derived from
  palette)

- `alpha` - Bar fill transparency (UI: "Alpha", default: 1)

- `width` - Bar width (UI: "Width", default: NA)

- `expand` - Axis expansion values (UI: "Expand", default: "")

- `y_min` - Y-axis minimum value (UI: "Y-axis min", default: 0)

- `y_max` - Y-axis maximum value (UI: "Y-axis max", default: max of
  data)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

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

[`plotthis::BarPlot()`](https://pwwang.github.io/plotthis/reference/barplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`plotthis_BarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotOutputUI.md),
[`plotthis_BarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotServer.md),
[`plotthis_BarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_BarPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data(mtcars)
plotthis_BarPlotInputsUI("BarPlot", mtcars)
#> Error in FUN(X[[i]], ...): object '.' not found
```
