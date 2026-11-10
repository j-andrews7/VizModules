# Input UI components for the freqPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoViz_freqPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotServer.md)
and
[`dittoViz_freqPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotOutputUI.md)
functions.

## Usage

``` r
dittoViz_freqPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation.

- defaults:

  A named list of default values for the inputs. An entry may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html);
  it is resolved with
  [`shiny::isolate()`](https://rdrr.io/pkg/shiny/man/isolate.html) to
  seed the control, and the module then keeps it live (see
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md)).

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
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

Unlike most modules here, this one does not plot columns of the incoming
data. It tabulates how often each level of "Frequency Of" occurs within
each sample and plots *those* per-sample frequencies, one facet per
level. Axis limits, statistics, the point annotations and the source
download therefore all describe the summarised frequency table, not the
input rows.

Under a free y facet scale ("free", "free_y") the Y Axis Min/Max are not
applied and each panel's significance brackets sit above that panel's
own data. With a ridge plot among the plot types the values run along
the x-axis, so no brackets are drawn; the test results are still
included in the source download.

Because the frequencies are per-sample, "Sample" must nest inside "Group
By": each sample has to carry exactly one group value (and one color
value, when "Color By" is set), or
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
errors. "Group By" and "Color By" are therefore chosen freely and
"Sample" is narrowed to the columns that nest inside them, which makes
an erroring combination unselectable. With no sample column each group
collapses to a single point per facet, which is rarely what is wanted.

## Plot parameters not implemented or with altered functionality

The following
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `main` - Plot title (plotly allows interactive editing)

- `sub` - Plot subtitle (not supported in plotly)

- `theme` - ggplot2 theme (not applicable to plotly)

- `legend.title` - Legend title (managed by plotly interactively)

- `split.by` - Not a parameter of
  [`freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html); it
  always facets on the frequency variable's levels. Use `vars.use`
  ("Levels To Show") to choose which of those facets are drawn

- `rows.use` - Row subset to plot (use the app's data table filter
  instead)

- `data.out`, `data.only` - Return the summary rather than the plot (the
  module summarises internally; use the Source Download button for the
  table)

- `do.hover` - Always `TRUE`, so the frequency, count and sample are
  readable on hover

- `colors` - Integer index/order into `color.panel` (managed via the
  palette UI)

- `color.panel` - Managed internally via the palette selection UI

- `y.breaks` - Custom continuous-axis breaks (not implemented)

- `x.labels` - Override group labels (not implemented)

- `x.reorder` - Reorder x-axis groups (use `x.order`, the "Group Order"
  input, instead)

- `x.labels.rotate` - Rotate group labels (handled by the Axes tab
  tick-angle controls)

- `var.labels.rename` - Rename facet labels (not implemented)

- `var.labels.reorder` - Reorder facet labels (not implemented)

- `add.line` - Use `hline.intercepts` instead for horizontal lines with
  full styling options

- `line.linetype` - Use `hline.linetypes` instead

- `line.color` - Use `hline.colors` instead

- `line.linewidth` - Use `hline.widths` instead

- `line.opacity` - Use `hline.opacities` instead

- `boxplot.width` - Boxplot width (controlled via `boxgap` and
  `boxgroupgap`)

- `boxplot.outlier.size` - Outlier point size (not implemented)

- `boxplot.position.dodge` - Boxplot dodge (controlled via `boxgap`)

- `vlnplot.quantiles` - Violin quantiles (doesn't translate to plotly)

- `jitter.position.dodge` - Jitter position dodge (calculated from
  `boxgap`)

## Plot parameters and defaults

The following
[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `var` - Variable whose per-sample frequency is tabulated, one facet
  per level (UI: "Frequency Of", default: 1st low-cardinality
  categorical variable)

- `sample.by` - Sample identifier the frequencies are computed within
  (UI: "Sample", default: "", i.e. one point per group)

- `group.by` - Grouping variable forming the x-axis (UI: "Group By",
  default: 1st categorical variable that is constant within each sample)

- `color.by` - Coloring variable (UI: "Color By", default: "", which
  follows `group.by`)

- `vars.use` - Which levels of `var` get a facet (UI: "Levels To Show",
  default: "", i.e. all)

- `scale` - Plot frequencies as proportions or raw counts (UI: "Scale",
  default: "percent")

- `max.normalize` - Scale each facet to its own maximum (UI: "Max
  Normalize", default: FALSE)

- `plots` - Plot types to show (UI: "Plots", default:
  `c("boxplot", "jitter")`)

- `min` - Y-axis minimum (UI: "Y Axis Min", auto-calculated from the
  frequency table)

- `max` - Y-axis maximum (UI: "Y Axis Max", auto-calculated from the
  frequency table)

- `split.nrow` - Number of facet rows (UI: "Rows", default: NA)

- `split.ncol` - Number of facet columns (UI: "Columns", default: NA)

- `split.adjust` - Facet scale behavior (UI: "Facet Scaling", default:
  "fixed")

- `do.raster` - Rasterize jitter points (UI: "Rasterize Jitter",
  default: FALSE)

- `raster.dpi` - DPI for rasterization (UI: "Raster DPI", default: 600)

- `hover.round.digits` - Hover value rounding (UI: "Hover Round Digits",
  default: 5)

- `jitter.size` - Jitter point size (UI: "Jitter Point Size", default:
  1)

- `jitter.width` - Jitter width (UI: "Jitter Width", default: 0.2)

- `jitter.color` - Jitter border color (UI: "Jitter Border Color",
  default: "#000000")

- `boxplot.show.outliers` - Show boxplot outliers (UI: "Show Outliers",
  default: FALSE)

- `boxplot.color` - Boxplot outline color (UI: "Boxplot Color", default:
  "#000000")

- `boxplot.fill` - Fill boxplot (UI: "Fill Boxplot", default: TRUE)

- `boxplot.lineweight` - Boxplot line weight (UI: "Boxplot Line Weight",
  default: 0.5)

- `vlnplot.lineweight` - Violin line weight (UI: "Violin Line Weight",
  default: 0.5)

- `vlnplot.scaling` - Violin scaling method (UI: "Violin Scaling",
  default: "area")

- `vlnplot.width` - Violin width (derived from `boxgap`; not directly
  settable)

- `ridgeplot.lineweight` - Ridge line weight (UI: "Ridge Line Weight",
  default: 0.5)

- `ridgeplot.scale` - Ridge overlap scale (UI: "Ridge Scale (overlap)",
  default: 1.25)

- `ridgeplot.ymax.expansion` - Ridge Y-max expansion (UI: "Ridge Y-max
  Expansion", default: NA)

- `ridgeplot.shape` - Ridge shape (UI: "Ridge Shape", default: "smooth")

- `ridgeplot.bins` - Ridge bins (UI: "Ridge Bins", default: 30)

- `ridgeplot.binwidth` - Ridge binwidth (UI: "Ridge Binwidth", default:
  NA)

- `legend.show` - Show the legend (UI: "Show Legend", default: TRUE)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `webgl` - Draw the points with WebGL once there are 5,000 or more, as
  set by the `VizModules.webgl.threshold` option (UI: "Plot with WebGL",
  default: TRUE)

- `x.order` - Order of the `group.by` groups along the x-axis (UI:
  "Group Order", drag and drop, default: the column's factor level
  order, else sorted). As a default, a character vector of levels of
  `group.by`; levels it leaves out follow in their default order. Not
  shown for a `group.by` with more than 20 groups

- `boxmode` - Always "overlay": the boxes carry explicit x positions
  matching ggplot's dodge, so plotly.js is not asked to dodge them

- `boxgap` - Boxplot position dodge (UI: "Boxplot Position Dodge",
  default: 0.3)

- `boxgroupgap` - Boxplot group dodge (UI: "Boxplot Group Dodge",
  default: 0.2)

- `title.font.size` - Plot title font size (UI: "Title Size", default:
  26)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `title.font.color` - Color for plot title (UI: "Title Color", default:
  "#000000")

- `axis.title.font.size` - Axis title font size (UI: "Axis Title Size",
  default: 18)

- `axis.title.font.color` - Axis title font color (UI: "Axis Title
  Color", default: "#000000")

- `axis.title.font.family` - Axis title font family (UI: "Axis Title
  Font", default: "Arial")

- `axis.showline` - Show axis border lines (UI: "Show Axis Lines",
  default: TRUE)

- `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror Axis
  Lines", default: TRUE)

- `show.grid.x` - Show X-axis major gridlines (UI: "Show X Major
  Gridlines", default: TRUE)

- `show.grid.y` - Show Y-axis major gridlines (UI: "Show Y Major
  Gridlines", default: TRUE)

- `axis.linecolor` - Color of axis lines (UI: "Axis Line Color",
  default: "black")

- `axis.linewidth` - Width of axis lines (UI: "Axis Line Width",
  default: 0.5)

- `axis.tickfont.size` - Size of tick labels (UI: "Tick Label Size",
  default: 12)

- `axis.tickfont.color` - Color of tick labels (UI: "Tick Label Color",
  default: "black")

- `axis.tickfont.family` - Font family for tick labels (UI: "Tick Label
  Font", default: "Arial")

- `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI:
  "X-axis Tick Label Angle", default: 0)

- `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI:
  "Y-axis Tick Label Angle", default: 0)

- `axis.ticks` - Position of tick marks (UI: "Tick Position", default:
  "outside")

- `axis.tickcolor` - Color of tick marks (UI: "Tick Mark Color",
  default: "black")

- `axis.ticklen` - Length of tick marks (UI: "Tick Mark Length",
  default: 5)

- `axis.tickwidth` - Width of tick marks (UI: "Tick Mark Width",
  default: 1)

- `axis.scientific` - Write numeric tick labels in scientific notation
  (UI: "Scientific Notation Ticks", default: FALSE; when off they never
  switch to it). See
  [`apply_tick_notation()`](https://j-andrews7.github.io/VizModules/reference/apply_tick_notation.md)

- `axis.padding.x` - Space between the data and the plot area's edges
  along X, as a fraction of the data's extent at each end (UI: "X Axis
  Padding", default: NA = the plot's own). See
  [`apply_axis_padding()`](https://j-andrews7.github.io/VizModules/reference/apply_axis_padding.md)

- `legend.font.family` - Font family of the legend title and labels (UI:
  "Legend Font", default: "Arial")

- `legend.font.color` - Font color of the legend title and labels (UI:
  "Legend Font Color", default: "#000000")

- `legend.title.size` - Legend title font size (UI: "Legend Title Size",
  default: 14)

- `legend.text.size` - Legend entry label font size (UI: "Legend Text
  Size", default: 12)

- `hline.intercepts` - Y-coordinates for horizontal reference lines (UI:
  "Y-intercepts", default: "")

- `hline.colors` - Colors for horizontal lines (UI: "Colors", default:
  "#000000")

- `hline.widths` - Widths for horizontal lines (UI: "Widths", default:
  "1")

- `hline.linetypes` - Line types for horizontal lines (UI: "Line Types",
  default: "dashed")

- `hline.opacities` - Opacities for horizontal lines (UI: "Opacities
  (0-1)", default: "1")

- `vline.intercepts` - X-coordinates for vertical reference lines (UI:
  "X-intercepts", default: "")

- `vline.colors` - Colors for vertical lines (UI: "Colors", default:
  "#000000")

- `vline.widths` - Widths for vertical lines (UI: "Widths", default:
  "1")

- `vline.linetypes` - Line types for vertical lines (UI: "Line Types",
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

- `abline.linetypes` - Line types for diagonal lines (UI: "Line Types",
  default: "dashed")

- `abline.opacities` - Opacities for diagonal lines (UI: "Opacities
  (0-1)", default: "1")

- `palette.colours` - Named character vector mapping group levels to
  colors, e.g. `c(A = "#FF0000", B = "blue")` (UI: "Plot colors"). Seeds
  the picker; unnamed groups fall back to the default palette and user
  edits take precedence.

- `annotate.by` - Column whose values identify and label jitter points
  (UI: "Annotate By", default: ""). Restricted to the columns carried in
  the plot's hover text, which for this plot are the sample and color
  columns

- `highlight.points` - Values from the `annotate.by` column to highlight
  (UI: "Points to Highlight", default: ""). Values containing spaces
  (e.g. "CD4 T") must be separated by commas or new lines

- `highlight.color` - Fill color for highlighted points (UI: "Highlight
  Fill", default: "#00FFF7")

- `highlight.size` - Size of highlighted points (UI: "Highlight Size",
  default: 7)

- `highlight.border.color` - Border color for highlighted points (UI:
  "Highlight Border Color", default: "#000000")

- `highlight.border.width` - Border width for highlighted points (UI:
  "Highlight Border Width", default: 1)

- `highlight.auto.annotate` - Label highlighted points automatically
  (UI: "Auto-annotate Highlights", default: TRUE)

- `annotation.color` - Annotation text color (UI: "Annotation Color",
  default: "black")

- `annotation.ax` - Horizontal label offset in pixels (UI: "Annotation X
  Offset", default: 20)

- `annotation.ay` - Vertical label offset in pixels (UI: "Annotation Y
  Offset", default: -20)

- `annotation.size` - Annotation font size (UI: "Annotation Size",
  default: 10)

- `annotation.showarrow` - Draw an arrow from label to point (UI: "Show
  Arrow", default: TRUE)

- `annotation.arrowcolor` - Annotation arrow color (UI: "Arrow Color",
  default: "black")

- `annotation.arrowhead` - Annotation arrowhead style (UI: "Arrowhead
  Style", default: 2)

- `annotation.arrowwidth` - Annotation arrow line width (UI: "Arrow
  Linewidth", default: 1.5)

- `stats.enabled` and the other `stat.*` parameters - Pairwise testing
  of the per-sample frequencies between x-axis groups. Tests always run
  within each facet, since frequencies of different levels are not
  comparable quantities; the "Per Facet Panel" control is therefore
  hidden and forced on. `stat.pairs` takes a character vector of
  `"A vs B"` strings naming levels of `group.by` (or of `color.by`, when
  it differs), e.g. `"Healthy vs Disease"`; left unset, every pair is
  tested

## See also

[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`dittoViz_freqPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotOutputUI.md),
[`dittoViz_freqPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotServer.md),
[`dittoViz_freqPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
dittoViz_freqPlotInputsUI("freqPlot", example_composition)
}
```
