# Input UI components for the Histogram module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_HistogramServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramServer.md)
and
[`plotthis_HistogramOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramOutputUI.md)
functions.

## Usage

``` r
plotthis_HistogramInputsUI(
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
[`plotthis::Histogram()`](https://pwwang.github.io/plotthis/reference/densityhistoplot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::Histogram()`](https://pwwang.github.io/plotthis/reference/densityhistoplot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `title` - Plot title (plotly allows interactive editing)

- `subtitle` - Plot subtitle (not supported in plotly)

- `legend.position` - Legend positioning (plotly allows interactive
  repositioning)

- `group_by_sep` - Separator for group columns (not applicable in UI
  context)

- `group_name` - Group legend name (handled by plotly)

- `xtrans` - X-axis transformation (not implemented in UI)

- `ytrans` - Y-axis transformation (not implemented in UI)

- `split_by` - Split variable (returns a patchwork object, not supported
  in plotly), use `facet_by` instead

- `split_by_sep` - Only applies if `split_by` is used

- `flip` - Flip axes (not implemented in current UI)

- `theme` - ggplot2 theme (not applicable in plotly)

- `theme_args` - Theme arguments (not applicable in plotly)

- `palette` - Managed internally via the palette selection UI

- `expand` - Axis expansion (not implemented)

- `seed` - Random seed (not applicable)

- `combine` - Only applies if `split_by` is used

- `nrow` - Only applies if `split_by` is used

- `ncol` - Only applies if `split_by` is used

- `byrow` - Only applies if `split_by` is used

- `axes` - Only applies if `split_by` is used

- `axis_titles` - Only applies if `split_by` is used

- `guides` - Only applies if `split_by` is used

- `design` - Only applies if `split_by` is used

- `legend_direction` - Managed position of legend however this can be
  handled via plotly

## Plot parameters and defaults

The following
[`plotthis::Histogram()`](https://pwwang.github.io/plotthis/reference/densityhistoplot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X Data", default: 2nd numeric variable)

- `group_by` - Grouping variable (UI: "Group By", default: "")

- `bins` - Number of bins (UI: "Number of Bins", default: NA)

- `binwidth` - Width of bins (UI: "Bin Width", default: NA)

- `use_trend` - Show only trend line (UI: "Trend Line Only", default:
  FALSE)

- `add_trend` - Add trend line to histogram (UI: "Add Trend to
  Histogram", default: FALSE)

- `trend_skip_zero` - Skip zero values in trend (UI: "Skip Zero Values",
  default: FALSE)

- `trend_alpha` - Trend line transparency (UI: "Trend Line Alpha",
  default: 1)

- `trend_linewidth` - Trend line width (UI: "Trend Line Width", default:
  0.8)

- `trend_pt_size` - Trend point size (UI: "Trend Point Size", default:
  1.5)

- `position` - Position adjustment (UI: "Position", default: "identity")

- `alpha` - Histogram fill transparency (UI: "Plot Alpha", default: 1)

- `add_bars` - Add rug plot (UI: "Add Rug Plot", default: FALSE)

- `bar_height` - Rug bar height (UI: "Rug Bar Height", default: 0.04)

- `bar_alpha` - Rug bar transparency (UI: "Rug Bar Alpha", default: 1)

- `bar_width` - Rug bar width (UI: "Rug Bar Width", default: 1)

- `facet_by` - Faceting variable (UI: "Facet By", default: "")

- `facet_scales` - Facet scale behavior (UI: "Facet Scale", default:
  "fixed")

- `facet_ncol` - Number of facet columns (UI: "Number of Columns",
  default: NULL)

- `facet_nrow` - Number of facet rows (UI: "Number of Rows", default:
  NULL)

- `facet_byrow` - Facet ordering direction (UI: "Facet by Row", default:
  TRUE)

- `palcolor` - Custom color values (UI: palette picker, derived from
  palette)

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

[`plotthis::Histogram()`](https://pwwang.github.io/plotthis/reference/densityhistoplot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`plotthis_HistogramOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramOutputUI.md),
[`plotthis_HistogramServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramServer.md),
[`plotthis_HistogramApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_HistogramApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
data(mtcars)
plotthis_HistogramInputsUI("histogram", mtcars)
#> Error in FUN(X[[i]], ...): object '.' not found
```
