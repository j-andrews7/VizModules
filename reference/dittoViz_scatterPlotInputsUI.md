# Input UI components for the scatterPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.md)
and
[`dittoViz_scatterPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotOutputUI.md)
functions.

## Usage

``` r
dittoViz_scatterPlotInputsUI(
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
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

Note that some of the parameters may have input types that differ from
the actual function, e.g. `shape.panel` is a text input for
comma-separated integers, while the function expects a vector of
integers. The module will parse such inputs into the appropriate format
for
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
automatically.

**Source data note:** When source data is downloaded with faceting
applied and `split.show.all.others = TRUE`, values will be duplicated
due to them being shown in every panel.

## Plot parameters not implemented or with altered functionality

The following
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
parameters are not available via UI inputs or have been superseded:

- `xlab` - X-axis label (auto-generated to reflect any applied X
  adjustment, e.g. `"z-score(log2(units))"`; plotly allows interactive
  editing)

- `ylab` - Y-axis label (auto-generated to reflect any applied Y
  adjustment, e.g. `"z-score(log2(units))"`; plotly allows interactive
  editing)

- `main` - Plot title (plotly allows interactive editing)

- `sub` - Plot subtitle (not supported in plotly)

- `theme` - ggplot2 theme (not applicable to plotly)

- `legend.title` - Legend title (managed by plotly interactively)

- `legend.color.size` - Legend color size (not supported in plotly)

- `legend.shape.size` - Legend shape size (not supported in plotly)

- `add.xline` - Use `vline.intercepts` instead for vertical lines with
  full styling options

- `add.yline` - Use `hline.intercepts` instead for horizontal lines with
  full styling options

- `xline.linetype` - Use `vline.linetypes` instead

- `xline.color` - Use `vline.colors` instead

- `yline.linetype` - Use `hline.linetypes` instead

- `yline.color` - Use `hline.colors` instead

- `do.letter` - Lettering subplots (not implemented for plotly)

- `do.label` - Labeling points interactively (not compatible with plotly
  hover)

- `labels.size`, `labels.highlight`, `labels.use.numbers`,
  `labels.numbers.spacer`, `labels.repel`, `labels.repel.adjust`,
  `labels.split.by` - Point-label styling (tied to `do.label`, not
  implemented)

- `rename.color.groups` - Rename color groups (not implemented)

- `rename.shape.groups` - Rename shape groups (not implemented)

- `add.trajectory.curves` - Add trajectory curves from coordinate
  matrices (not implemented; use `add.trajectory.by.groups` instead)

- `do.raster` - Rasterize the point layer (not implemented; use `webgl`
  for performance instead)

- `raster.dpi` - Rasterization DPI (not applicable without `do.raster`)

- `show.grid.lines` - Toggle grid lines (managed via the Axes tab
  gridline controls)

- `legend.color.breaks.labels` - Labels for color-scale breaks (not
  implemented)

The new Lines tab provides enhanced functionality including multiple
lines per type, individual line widths, opacities, and diagonal/ablines
with slope control.

## Plot parameters and defaults

The following
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x.by` - X-axis variable (UI: "X Data", default: 2nd column)

- `y.by` - Y-axis variable (UI: "Y Data", default: 3rd column)

- `color.by` - Coloring variable (UI: "Color By", default: "")

- `shape.by` - Shape variable (UI: "Shape By", default: "")

- `split.by` - Faceting variable (UI: "Split By", default: "")

- `rows.use` - Row filter expression (UI: "Rows Filter", default: "")

- `x.adjustment` - X-axis adjustment (UI: "X Adjustment", default: "")

- `y.adjustment` - Y-axis adjustment (UI: "Y Adjustment", default: "")

- `color.adjustment` - Color adjustment (UI: "Color Adjustment",
  default: "")

- `x.adj.fxn` - X adjustment function (UI: "X Adjustment Function",
  default: "")

- `y.adj.fxn` - Y adjustment function (UI: "Y Adjustment Function",
  default: "")

- `color.adj.fxn` - Color adjustment function (UI: "Color Adjustment
  Function", default: "")

- `size` - Point size (UI: "Point Size", default: 1); shown while
  `size.by` is unset

- `size.by` - Numeric column mapped to point size (UI: "Size By",
  default: ""); when set, a custom circle size legend is drawn since
  plotly cannot render a native size legend

- `size.min` - Smallest point size a `size.by` column maps onto (UI:
  "Min Point Size", default: 1). Shown while `size.by` is set

- `size.max` - Largest point size a `size.by` column maps onto (UI: "Max
  Point Size", default: 6). Shown while `size.by` is set

- `size.scale.min` - `size.by` value drawn at the minimum point size,
  where the size legend starts (UI: "Size Scale Min", default: NA = the
  column's minimum); smaller values are drawn at the minimum size. Shown
  while `size.by` is set

- `size.scale.max` - `size.by` value drawn at the maximum point size,
  where the size legend ends (UI: "Size Scale Max", default: NA = the
  column's maximum); larger values are drawn at the maximum size. Shown
  while `size.by` is set

- `opacity` - Point opacity (UI: "Point Opacity", default: 1)

- `show.others` - Show others (UI: "Show Others", default: TRUE)

- `split.show.all.others` - Show split others (UI: "Show Split Others",
  default: TRUE)

- `plot.order` - Plot order (UI: "Plot Order", default: "unordered")

- `shape.panel` - Shape panel values (UI: "Shape Panel", default: "16,
  15, 17, 23, 25, 8")

- `min.color` - Minimum color (UI: "Min Color", default: "#F0E442")

- `max.color` - Maximum color (UI: "Max Color", default: "#0072B2")

- `contour.color` - Contour color (UI: "Contour Color", default:
  "black")

- `contour.linetype` - Contour linetype (UI: "Contour Linetype",
  default: "solid")

- `color.panel` - Named character vector mapping `color.by` levels to
  colors, e.g. `c(setosa = "#FF0000", virginica = "blue")` (UI:
  color.panel.ui). Seeds the picker; unnamed groups fall back to the
  default palette and user edits take precedence.

- `single.point.color` - Point color used when `color.by` is unset (UI:
  "Point color", default: "#000000")

- `split.nrow` - Number of split rows (UI: "Rows", default: NA)

- `split.ncol` - Number of split columns (UI: "Columns", default: NA)

- `multivar.split.dir` - Multivar split direction (UI: "Multivar Split
  Dir", default: "col")

- `split.adjust.scales` - Facet scales (UI: "Facet Scales", default:
  "fixed")

- `annotate.by` - Annotate by column (UI: "Annotate By", default: "")

- `highlight.points` - Values from the `annotate.by` column to highlight
  (UI: "Points to Highlight", default: ""). Values containing spaces
  (e.g. "CD4 T") must be separated by commas or new lines

- `highlight.color` - Highlight fill (UI: "Highlight Fill", default:
  "#00FFF7")

- `highlight.size` - Highlight size (UI: "Highlight Size", default: 7)

- `highlight.border.color` - Highlight border color (UI: "Highlight
  Border Color", default: "#000000")

- `highlight.border.width` - Highlight border width (UI: "Highlight
  Border Width", default: 1)

- `highlight.auto.annotate` - Auto-annotate highlights (UI:
  "Auto-annotate Highlights", default: TRUE)

- `annotation.color` - Annotation color (UI: "Annotation Color",
  default: "black")

- `annotation.ax` - Annotation X offset (UI: "Annotation X Offset",
  default: 20)

- `annotation.ay` - Annotation Y offset (UI: "Annotation Y Offset",
  default: -20)

- `annotation.size` - Annotation size (UI: "Annotation Size", default:
  10)

- `annotation.showarrow` - Show arrow (UI: "Show Arrow", default: TRUE)

- `annotation.arrowcolor` - Arrow color (UI: "Arrow Color", default:
  "black")

- `annotation.arrowhead` - Arrowhead style (UI: "Arrowhead Style",
  default: 2)

- `annotation.arrowwidth` - Arrow linewidth (UI: "Arrow Linewidth",
  default: 1.5)

- `legend.show` - Show the legend, colorbar and size legend (UI: "Show
  Legend", default: TRUE)

- `legend.color.title` - Color legend title (UI: "Legend Title",
  default: "make")

- `legend.color.breaks` - Legend tick breaks (UI: "Legend Tick Breaks",
  default: "")

- `size.legend.x` - Custom size-legend x position (UI: "Size Legend X
  Position", default: 1.03); nudges the manual size legend (drawn when
  `size.by` is set) along the x-axis.

- `size.legend.y` - Custom size-legend y position (UI: "Size Legend Y
  Position", default: 0.35); nudges the manual size legend (drawn when
  `size.by` is set) along the y-axis.

- `min.value` - Minimum value (UI: "Min Value", default: NA)

- `max.value` - Maximum value (UI: "Max Value", default: NA)

- `trajectory.group.by` - Column whose groups the trajectories pass
  through (UI: "Trajectory Group By", default: "")

- `add.trajectory.by.groups` - Trajectories, each the groups it visits
  in order (UI: "Trajectories", a
  [`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/reference/multiDynamicInput.md)
  with one row per trajectory, each picking its groups in order from the
  `trajectory.group.by` column; default: none). In `defaults`, a list of
  character vectors as dittoViz takes it, e.g.
  `list(c("A", "B"), c("C", "D", "E"))`, applied while
  `trajectory.group.by` is its default column; the bracketed text
  `"[A,B],[C,D,E]"` also works. Changing the column clears the list. The
  module draws each as a path through its groups' medians, ending in an
  arrowhead (ggplotly drops dittoViz's). The medians are of the values
  as plotted, after any adjustment. On a split plot each panel's path
  runs through that panel's medians, and a path is left out of any
  panel, or plot, missing one of its groups. None are drawn while an
  adjustment makes an axis categorical. Zoomed in, a path stops at the
  panel's edge, but an arrowhead just past the edge is still drawn, as
  plotly does not clip annotations to the plot area

- `trajectory.arrow.size` - Arrowhead length in inches (UI: "Trajectory
  Arrow Size", default: 0.1)

- `do.ellipse` - Enable ellipses (UI: "Enable Ellipses", default: FALSE)

- `do.contour` - Enable contour (UI: "Enable Contour", default: FALSE)

- `hover.data` - Hover data columns (UI: "Hover Data", default: "")

- `hover.round.digits` - Hover round digits (UI: "Hover Round Digits",
  default: 5)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `webgl` - Plot with webGL (UI: "Plot with webGL", default: TRUE)

- `shape.fill` - Shape fill color (UI: "Shape Fill", default: "rgba(0,
  0, 0, 0)")

- `shape.line.color` - Shape line color (UI: "Shape Line Color",
  default: "black")

- `shape.line.width` - Shape line width (UI: "Shape Line Width",
  default: 4)

- `shape.linetype` - Shape linetype (UI: "Shape Linetype", default:
  "solid")

- `shape.opacity` - Shape opacity (UI: "Shape Opacity", default: 1)

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

- `axis.showline` - Show axis border lines (UI: "Show Axis Borders",
  default: TRUE)

- `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror Axis
  Borders", default: TRUE)

- `show.grid.x` - Show X-axis major gridlines (UI: "Show X Gridlines",
  default: TRUE)

- `show.grid.y` - Show Y-axis major gridlines (UI: "Show Y Gridlines",
  default: TRUE)

- `grid.color` - Gridline color (UI: "Gridline Color", default:
  "#CCCCCC")

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

- `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI: "X
  Tick Label Angle", default: 0)

- `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI: "Y
  Tick Label Angle", default: 0)

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

- `axis.padding.y` - Space between the data and the plot area's edges
  along Y, as a fraction of the data's extent at each end (UI: "Y Axis
  Padding", default: NA = the plot's own). See
  [`apply_axis_padding()`](https://j-andrews7.github.io/VizModules/reference/apply_axis_padding.md)

- `facet.title.font.size` - Facet subplot title font size (UI: "Facet
  Subplot Title Size", default: 18)

- `facet.title.font.color` - Facet subplot title font color (UI: "Facet
  Title Color", default: "#000000")

- `facet.title.font.family` - Facet subplot title font family (UI:
  "Facet Title Font", default: "Arial")

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

- `best.fit` - Enable line of best fit (UI: "Line of best fit:",
  default: FALSE)

- `line.best.smoothness` - Smoothness of line of best fit (UI:
  "Smoothness of line of best fit:", default: 1)

- `line.best.colour` - Color of line of best fit (UI: "Line of best fit
  colour:", default: "#000000")

- `linear.model` - Enable linear model line (UI: "Linear model line",
  default: FALSE)

- `model.legend.show` - List the fit and model lines in the legend (UI:
  "Model Lines in Legend", default: FALSE). Off, a line fit to a Color
  By group hides and shows with that group's entry.

- `marginal.x` - Distributions of the X values drawn above the plot, any
  of `"density"`, `"histogram"` and `"rug"` (UI: "Top Marginal (X)",
  default: none)

- `marginal.y` - Distributions of the Y values drawn to the right of the
  plot, any of `"density"`, `"histogram"` and `"rug"` (UI: "Right
  Marginal (Y)", default: none)

- `marginal.x.size` - Share of the plot's height given to the top
  marginal (UI: "Top Marginal Height", default: 0.15). Shown while
  `marginal.x` is set

- `marginal.y.size` - Share of the plot's width given to the right
  marginal (UI: "Right Marginal Width", default: 0.15). Shown while
  `marginal.y` is set

- `marginal.opacity` - Opacity of the density and histogram fills and
  the rug lines (UI: "Marginal Opacity", default: 0.5). Shown while
  either marginal is set

- `marginal.bins` - Number of histogram bins (UI: "Histogram Bins",
  default: 30). Shown while either marginal has a histogram

- `marginal.binwidth` - Histogram bin width, overriding `marginal.bins`
  (UI: "Histogram Bin Width", default: NA = use `marginal.bins`). Shown
  while either marginal has a histogram

- `marginal.density.adjust` - Multiplier on the density bandwidth (UI:
  "Density Bandwidth Adjust", default: 1). Shown while either marginal
  has a density

- `marginal.rug.height` - Share of a marginal given to its rug when it
  sits alongside a density or histogram (UI: "Rug Height", default:
  0.3). Shown while a marginal has both

- `marginal.rug.width` - Line width of the rug ticks, in pixels (UI:
  "Rug Line Width", default: 1). Shown while either marginal has a rug

- `marginal.axes` - Show the density or count axis, with its ticks and
  labels, of each density and histogram marginal (UI: "Show Marginal
  Axes", default: FALSE). Shown while either marginal has a density or
  histogram

Marginal plots show one distribution per Color By group, in the group's
colour, or a single one in the Point color when the plot has no groups
(including a numeric Color By). Like the fit lines, they are drawn from
the plotted values, after any X/Y adjustment. A density and a histogram
share their marginal, the histogram scaled to a density so the two
match; a histogram on its own shows counts. The rug sits in its own
strip next to the plot, with a lane for each group. Zooming the plot
zooms its marginals, and hiding a group in the legend hides its
marginals too. Marginals are not drawn on a split plot, nor along an
axis an adjustment (`as.factor`) makes categorical.

Each "Adjustment Function" is applied first and the matching
"Adjustment" then rescales the result (e.g. log10, then z-score), the
reverse of the order
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
applies its `*.adj.fxn` and `*.adjustment` in.

Fit lines (linear, best fit, and custom models) are fit to the values as
plotted, after any X/Y adjustment, so they are drawn over the points
they describe. A custom formula such as `mpg ~ hp` therefore models the
adjusted values; do not repeat the adjustment inside it. No fit lines
are drawn while an adjustment (`as.factor`) makes an axis categorical.

## See also

[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`dittoViz_scatterPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotOutputUI.md),
[`dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.md),
[`dittoViz_scatterPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
dittoViz_scatterPlotInputsUI("scatterPlot", example_mtcars)
}
```
