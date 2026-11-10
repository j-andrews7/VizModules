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
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html) can
be set via these inputs, so see the help for that function for an
exhaustive list.

The "Y Data" input accepts several columns at once. "Multivar Aesthetic"
(on the Facet tab) then decides how they are shown: `"split"` gives each
variable its own facet (alongside any `split.by` facets), while
`"group"` and `"color"` put the variables on the x-axis or the fill
legend respectively. With several variables the Stats tab is only
available for the `"split"` aesthetic with no `split.by` set, and
comparisons are then run separately within each variable's facet. The
other layouts either replace the x-axis groups being compared or facet
on two dimensions at once, neither of which the significance brackets
can be placed against.

The "Y Adjustment Function" is applied first and the "Y Adjustment" then
rescales the result (e.g. log10, then z-score), the reverse of the order
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
applies its `var.adj.fxn` and `var.adjustment` in.

Statistics are computed on the values as plotted, after any Y
adjustment, and the Y Axis Min/Max and significance brackets are in
those units too. With a ridge plot among the plot types the values run
along the x-axis, so no brackets are drawn; the test results are still
included in the source data download.

## Plot parameters not implemented or with altered functionality

The following
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (auto-generated to reflect any applied Y
  adjustment, e.g. `"z-score(log2(units))"`; plotly allows interactive
  editing). With several Y variables only the adjustment is shown, as
  the variables are named by the facet strips or the legend instead

- `main` - Plot title (plotly allows interactive editing)

- `sub` - Plot subtitle (not supported in plotly)

- `theme` - ggplot2 theme (not applicable to plotly)

- `legend.title` - Legend title (managed by plotly interactively)

- `add.line` - Use `hline.intercepts` instead for horizontal lines with
  full styling options

- `line.linetype` - Use `hline.linetypes` instead

- `line.color` - Use `hline.colors` instead

- `line.linewidth` - Use `hline.widths` instead

- `line.opacity` - Use `hline.opacities` instead

- `rows.use` - Row subset to plot (not implemented)

- `colors` - Integer index/order into `color.panel` (managed via the
  palette UI)

- `shape.panel` - Shapes used with `shape.by` (not implemented)

- `y.breaks` - Custom continuous-axis breaks (not implemented)

- `x.labels` - Override group labels (not implemented)

- `x.labels.rotate` - Rotate group labels (handled by the Axes tab
  tick-angle controls)

- `x.reorder` - Reorder x-axis groups (use `x.order`, the "Group Order"
  input, instead)

- `boxplot.width` - Boxplot width (controlled via `boxgap` and
  `boxgroupgap`)

- `boxplot.outlier.size` - Outlier point size (not implemented)

- `boxplot.position.dodge` - Boxplot dodge (controlled via `boxgap`)

- `vlnplot.quantiles` - Violin quantiles (doesn't translate to plotly)

## Plot parameters and defaults

The following
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `var` - Y-axis variable(s) (UI: "Y Data", default: 2nd numeric
  variable). Several may be selected; `multivar.aes` then controls how
  they are displayed

- `multivar.aes` - Aesthetic used for multiple `var` columns (UI:
  "Multivar Aesthetic", default: "split")

- `multivar.split.dir` - Facet direction for multiple `var` columns (UI:
  "Multivar Split Dir", default: "col")

- `group.by` - Grouping variable for x-axis (UI: "Group by", default:
  2nd categorical variable)

- `color.by` - Coloring variable (UI: "Color by", default: "")

- `shape.by` - Shape variable (UI: "Shape by", default: "")

- `split.by` - Faceting variable (UI: "Split by (facet)", default: "")

- `plots` - Plot types to show (UI: "Plots to show", default:
  c("boxplot", "jitter"))

- `color.panel` - Custom color values (UI: palette picker, derived from
  palette)

- `min` - Y-axis minimum, in the units plotted (after any
  `var.adjustment`/`var.adj.fxn`); set with the `y.min` key (UI: "Y Axis
  Min", auto-calculated). Not applied under a free y facet scale, where
  each panel spans its own data.

- `max` - Y-axis maximum, in the units plotted; set with the `y.max` key
  (UI: "Y Axis Max", auto-calculated). Not applied under a free y facet
  scale.

- `var.adjustment` - Y-axis data adjustment (UI: "Y Adjustment",
  default: "")

- `var.adj.fxn` - Y-axis adjustment function (UI: "Y Adjustment
  Function", default: "")

- `split.nrow` - Number of facet rows (UI: "Rows", default: 4)

- `split.ncol` - Number of facet columns (UI: "Columns", default: 4)

- `split.adjust` - Facet scale behavior (UI: "Facet Scaling", default:
  "fixed"). A free y scale ("free", "free_y") ignores Y Axis Min/Max and
  stacks each panel's significance brackets above that panel's own data.

- `do.raster` - Rasterize jitter points (UI: "Rasterize Jitter",
  default: FALSE)

- `raster.dpi` - DPI for rasterization (UI: "Raster DPI", default: 600)

- `jitter.size` - Jitter point size (UI: "Jitter Point Size", default:
  1)

- `jitter.width` - Jitter width (UI: "Jitter Width", default: 0.2)

- `jitter.color` - Jitter border color (UI: "Jitter Border Color",
  default: "#000000")

- `jitter.shape.legend.size` - Shape legend size (UI: "Shape Legend
  Size", default: 5)

- `jitter.shape.legend.show` - Show shape legend (UI: "Show Shape
  Legend", default: TRUE)

- `jitter.position.dodge` - Jitter position dodge (calculated from
  boxgap)

- `boxplot.show.outliers` - Show boxplot outliers

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
  NULL)

- `hover.data` - Columns shown on hover (UI: "Hover Data", default: "";
  empty uses a sensible default set of columns)

- `hover.round.digits` - Hover value rounding (UI: "Hover Round Digits",
  default: 5)

- `legend.show` - Show the legend (UI: "Show Legend", default: TRUE)

- `stats.enabled` and the other `stat.*` parameters - Pairwise testing
  between the `group.by` groups, or between the `color.by` levels within
  each group when `color.by` is set (Stats tab). `stat.pairs` takes a
  character vector of `"A vs B"` strings naming those levels, e.g.
  `"Office vs Remote"`; left unset, every pair is tested

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
  (UI: "Annotate By", default: "")

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
if (FALSE) { # interactive()
library(VizModules)
data(mtcars)
dittoViz_yPlotInputsUI("yPlot", mtcars)
}
```
