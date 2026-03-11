# Input UI components for the yPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoViz_yPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotServer.md)
and
[`dittoViz_yPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotOutputUI.md)
functions.

## Usage

``` r
dittoViz_yPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html) can
be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `main` - Plot title (plotly allows interactive editing)

- `sub` - Plot subtitle (not supported in plotly)

- `theme` - ggplot2 theme (not applicable to plotly)

- `legend.title` - Legend title (managed by plotly interactively)

- `add.line` - Use `hline.intercepts` instead for horizontal lines with
  full styling options

- `line.linetype` - Use `hline.linetypes` instead

- `line.color` - Use `hline.colors` instead

## Plot parameters and defaults

The following
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `var` - Y-axis variable (UI: "Y data (var)", default: 2nd numeric
  variable)

- `group.by` - Grouping variable for x-axis (UI: "Group by", default:
  2nd categorical variable)

- `color.by` - Coloring variable (UI: "Color by", default: "")

- `shape.by` - Shape variable (UI: "Shape by", default: "")

- `split.by` - Faceting variable (UI: "Split by (facet)", default: "")

- `plots` - Plot types to show (UI: "Plots to show", default:
  c("boxplot", "jitter"))

- `color.panel` - Custom color values (UI: palette picker, derived from
  palette)

- `min` - Y-axis minimum (UI: "Y Axis Min", auto-calculated)

- `max` - Y-axis maximum (UI: "Y Axis Max", auto-calculated)

- `split.nrow` - Number of facet rows (UI: "Number of Rows", default: 4)

- `split.ncol` - Number of facet columns (UI: "Number of Columns",
  default: 4)

- `split.adjust` - Facet scale behavior (UI: "Facet Scaling", default:
  "free")

- `do.raster` - Rasterize jitter points (UI: "Rasterize Jitter",
  default: FALSE)

- `raster.dpi` - DPI for rasterization (UI: "Raster DPI", default: 600)

- `jitter.size` - Jitter point size (UI: "Jitter Point Size", default:
  1)

- `jitter.width` - Jitter width (UI: "Jitter Width", default: 0.2)

- `jitter.color` - Jitter point color (UI: "Jitter Point Color",
  default: "#000000")

- `jitter.shape.legend.size` - Shape legend size (UI: "Shape Legend
  Size", default: 5)

- `jitter.shape.legend.show` - Show shape legend (UI: "Show Shape
  Legend", default: TRUE)

- `jitter.position.dodge` - Jitter position dodge (calculated from
  boxgap)

- `boxplot.show.outliers` - Show boxplot outliers (always TRUE in
  implementation)

- `boxplot.color` - Boxplot outline color (UI: "Boxplot Color", default:
  "#000000")

- `boxplot.fill` - Fill boxplot (UI: "Fill Boxplot", default: TRUE)

- `boxplot.lineweight` - Boxplot line weight (UI: "Boxplot Line Weight",
  default: 0.5)

- `vlnplot.lineweight` - Violin line weight (UI: "Violin Line Weight",
  default: 0.5)

- `vlnplot.scaling` - Violin scaling method (UI: "Violin Scaling",
  default: "area")

- `vlnplot.quantiles` - Violin quantiles (UI: "Violin Quantiles (0-1)",
  default: "")

- `vlnplot.width` - Violin width (calculated from boxgap)

- `ridgeplot.lineweight` - Ridge line weight (UI: "Ridge Line Weight",
  default: 0.5)

- `ridgeplot.scale` - Ridge overlap scale (UI: "Ridge Scale (overlap)",
  default: 1.25)

- `ridgeplot.ymax.expansion` - Ridge Y-max expansion (UI: "Ridge Y-max
  Expansion", default: NA)

- `ridgeplot.shape` - Ridge shape (UI: "Ridge Shape", default: "smooth")

- `ridgeplot.bins` - Ridge bins (UI: "Ridge Bins", default: 30)

- `ridgeplot.binwidth` - Ridge binwidth (UI: "Ridge Binwidth", default:
  NULL)

- `legend.show` - Show legend (always TRUE in implementation)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `boxmode` - Boxplot mode grouping (calculated: "group" or "overlay"
  based on color.by)

- `boxgap` - Boxplot position dodge (UI: "Boxplot Position Dodge",
  default: 0.3)

- `boxgroupgap` - Boxplot group dodge (UI: "Boxplot Group Dodge",
  default: 0.2)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `text.colour` - Color for title text (UI: "Label colour", default:
  "#000000")

- `axis.title.font.size` - Axis title font size (UI: "Axis font size",
  default: 18)

- `axis.title.font.color` - Axis title font color (UI: "Axis title font
  color", default: "#000000")

- `axis.title.font.family` - Axis title font family (UI: "Axis title
  font family", default: "Arial")

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

[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`dittoViz_yPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotOutputUI.md),
[`dittoViz_yPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotServer.md),
[`dittoViz_yPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotApp.md)

## Author

Jared Andrews, Jacob Martin

## Examples

``` r
library(VizModules)
data(mtcars)
dittoViz_yPlotInputsUI("yPlot", mtcars)
#> Error in FUN(X[[i]], ...): object '.' not found
```
