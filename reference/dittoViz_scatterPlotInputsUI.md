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

## Plot parameters not implemented or with altered functionality

The following
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
parameters are not available via UI inputs or have been superseded:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `main` - Plot title (plotly allows interactive editing)

- `sub` - Plot subtitle (not supported in plotly)

- `theme` - ggplot2 theme (not applicable to plotly)

- `legend.title` - Legend title (managed by plotly interactively)

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

- `size` - Point size (UI: "Point Size", default: 1)

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

- `color.panel` - Custom color values (UI: color.panel.ui, derived from
  palette)

- `split.nrow` - Number of split rows (UI: "Split Rows", default: NA)

- `split.ncol` - Number of split columns (UI: "Split Columns", default:
  NA)

- `multivar.split.dir` - Multivar split direction (UI: "Multivar Split
  Dir", default: "col")

- `split.adjust.scales` - Facet scales (UI: "Facet Scales", default:
  "fixed")

- `annotate.by` - Annotate by column (UI: "Annotate By", default: "")

- `highlight.points` - Points to highlight (UI: "Points to Highlight",
  default: "")

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

- `legend.show` - Show legend (UI: "Show Legend", default: TRUE)

- `legend.color.title` - Legend title (UI: "Legend Title", default:
  "make")

- `legend.color.size` - Legend color size (UI: "Legend Color Size",
  default: 5)

- `legend.shape.size` - Legend shape size (UI: "Legend Shape Size",
  default: 5)

- `legend.color.breaks` - Legend tick breaks (UI: "Legend Tick Breaks",
  default: "")

- `min.value` - Minimum value (UI: "Min Value", default: NA)

- `max.value` - Maximum value (UI: "Max Value", default: NA)

- `trajectory.group.by` - Trajectory group by (UI: "Trajectory Group
  By", default: "")

- `add.trajectory.by.groups` - Add trajectory by groups (UI: "Add
  Trajectory By Groups", default: "")

- `trajectory.arrow.size` - Trajectory arrow size (UI: "Trajectory Arrow
  Size", default: 0.15)

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

- `axis.title.font.size` - Axis title font size (UI: via
  .uniform_axes_inputs_ui)

- `axis.title.font.color` - Axis title font color (UI: via
  .uniform_axes_inputs_ui)

- `axis.title.font.family` - Axis title font family (UI: via
  .uniform_axes_inputs_ui)

- `axis.showline` - Show axis lines (UI: via .uniform_axes_inputs_ui)

- `axis.mirror` - Mirror axis lines (UI: via .uniform_axes_inputs_ui)

- `show.grid.x` - Show X gridlines (UI: via .uniform_axes_inputs_ui)

- `show.grid.y` - Show Y gridlines (UI: via .uniform_axes_inputs_ui)

- `axis.linecolor` - Axis line color (UI: via .uniform_axes_inputs_ui)

- `axis.linewidth` - Axis line width (UI: via .uniform_axes_inputs_ui)

- `axis.tickfont.size` - Tick label size (UI: via
  .uniform_axes_inputs_ui)

- `axis.tickfont.color` - Tick label color (UI: via
  .uniform_axes_inputs_ui)

- `axis.tickfont.family` - Tick label font (UI: via
  .uniform_axes_inputs_ui)

- `axis.tickangle.x` - X-axis tick angle (UI: via
  .uniform_axes_inputs_ui)

- `axis.tickangle.y` - Y-axis tick angle (UI: via
  .uniform_axes_inputs_ui)

- `axis.ticks` - Tick position (UI: via .uniform_axes_inputs_ui)

- `axis.tickcolor` - Tick mark color (UI: via .uniform_axes_inputs_ui)

- `axis.ticklen` - Tick mark length (UI: via .uniform_axes_inputs_ui)

- `axis.tickwidth` - Tick mark width (UI: via .uniform_axes_inputs_ui)

- `hline.intercepts` - Horizontal line Y-intercepts (UI: via
  .uniform_lines_inputs_ui)

- `hline.colors` - Horizontal line colors (UI: via
  .uniform_lines_inputs_ui)

- `hline.widths` - Horizontal line widths (UI: via
  .uniform_lines_inputs_ui)

- `hline.linetypes` - Horizontal line types (UI: via
  .uniform_lines_inputs_ui)

- `hline.opacities` - Horizontal line opacities (UI: via
  .uniform_lines_inputs_ui)

- `vline.intercepts` - Vertical line X-intercepts (UI: via
  .uniform_lines_inputs_ui)

- `vline.colors` - Vertical line colors (UI: via
  .uniform_lines_inputs_ui)

- `vline.widths` - Vertical line widths (UI: via
  .uniform_lines_inputs_ui)

- `vline.linetypes` - Vertical line types (UI: via
  .uniform_lines_inputs_ui)

- `vline.opacities` - Vertical line opacities (UI: via
  .uniform_lines_inputs_ui)

- `abline.slopes` - Diagonal line slopes (UI: via
  .uniform_lines_inputs_ui)

- `abline.intercepts` - Diagonal line Y-intercepts (UI: via
  .uniform_lines_inputs_ui)

- `abline.colors` - Diagonal line colors (UI: via
  .uniform_lines_inputs_ui)

- `abline.widths` - Diagonal line widths (UI: via
  .uniform_lines_inputs_ui)

- `abline.linetypes` - Diagonal line types (UI: via
  .uniform_lines_inputs_ui)

- `abline.opacities` - Diagonal line opacities (UI: via
  .uniform_lines_inputs_ui)

- `fit.line` - Fit line (UI: via .uniform_lines_inputs_ui)

- `fit.line.color` - Fit line color (UI: via .uniform_lines_inputs_ui)

- `fit.line.width` - Fit line width (UI: via .uniform_lines_inputs_ui)

- `fit.line.type` - Fit line type (UI: via .uniform_lines_inputs_ui)

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
library(VizModules)
data(mtcars)
dittoViz_scatterPlotInputsUI("scatterPlot", mtcars)
#> Error in extract_roc_text(package_name, type = type, select = s, capitalize = cap): No Rd string extracted (NA_character_); please check your inputs; when using roxygen > 7.1.2, please check whether some parameters are co-documented: if they are, you need to select them as a whole set by select = 'param_a,param_b' or select = c('param_a', 'param_b')
```
