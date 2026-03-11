# Input UI components for the AreaPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`plotthis_AreaPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotServer.md)
and
[`plotthis_AreaPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotOutputUI.md)
functions.

## Usage

``` r
plotthis_AreaPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `title` - Plot title (plotly allows interactive editing)

- `subtitle` - Plot subtitle (not supported in plotly)

- `aspect.ratio` - Aspect ratio control (handled by plotly layout)

- `legend.position` - Legend positioning (plotly allows interactive
  repositioning)

- `split_by` - Split variable (returns a patchwork object, not supported
  in plotly), use `facet_by` instead

- `design` - Only applies if `split_by` is used

- `split_by_sep` - Only applies if `split_by` is used

- `axes` - Only applies if `split_by` is used

- `axis_titles` - Only applies if `split_by` is used

- `guides` - Only applies if `split_by` is used

- `byrow` - Only applies if `split_by` is used

- `nrow` - Only applies if `split_by` is used

- `ncol` - Only applies if `split_by` is used

- `palette` - Managed internally via the palette selection UI

- `legend_direction` - Managed position of legend however this can be
  handled via plotly

## Plot parameters and defaults

The following
[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable (UI: "X values", default: 2nd categorical
  variable)

- `y` - Y-axis variable (UI: "Y values", default: 2nd numeric variable)

- `group_by` - Grouping variable for area fill (UI: "Group by", default:
  3rd categorical variable or "")

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

- `theme` - ggplot2 theme (UI: "Theme", default: "theme_this")

- `alpha` - Area fill transparency (UI: "Alpha", default: 1)

- `scale_y` - Scale y-axis by total (UI: "Scale y-axis by total",
  default: FALSE)

- `legend_direction` - Legend orientation (UI: "Legend direction",
  default: "vertical")

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

[`plotthis::AreaPlot()`](https://pwwang.github.io/plotthis/reference/AreaPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`plotthis_AreaPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotOutputUI.md),
[`plotthis_AreaPlotServer()`](https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotServer.md),
[`plotthis_AreaPlotApp()`](https://j-andrews7.github.io/VizModules/reference/plotthis_AreaPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
# Needs at least 2 categorical variables for grouping and x-axis
mtcars$cyl <- as.factor(mtcars$cyl)
mtcars$gear <- as.factor(mtcars$gear)
plotthis_AreaPlotInputsUI("areaPlot", mtcars)
#> Error in FUN(X[[i]], ...): object '.' not found
```
