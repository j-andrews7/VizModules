# Input UI components for the linePlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`linePlotServer()`](https://j-andrews7.github.io/VizModules/reference/linePlotServer.md)
and
[`linePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/linePlotOutputUI.md)
functions.

## Usage

``` r
linePlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters and defaults

The following
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable(s) (UI: "Select X values", defaults key:
  `x.value`, default: 1st column, multiple: TRUE)

- `y` - Y-axis variable(s) (UI: "Select Y values", defaults key:
  `y.value`, default: 2nd column, multiple: TRUE)

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

- `group.by` - Grouping variable (UI: "Group by", default: 1st
  categorical variable)

- `order.by` - Order by Y values (UI: "Order by Y", default: FALSE)

- `x.adjustment` - X-axis adjustment function (UI: "X Adjustment",
  default: "")

- `y.adjustment` - Y-axis adjustment function (UI: "Y Adjustment",
  default: "")

- `facet.by` - Faceting variable (UI: "Facet by", default: "")

- `facet.scales` - Facet scale behavior (UI: "Facet scales", default:
  "fixed")

- `facet.nrow` - Number of rows in the facet grid (UI: "Rows", default:
  NULL; blank = auto)

- `facet.ncol` - Number of columns in the facet grid (UI: "Columns",
  default: NULL; blank = auto)

- `plot.mode` - Plot type (UI: "Plot type", default: "lines")

- `line.type` - Line type (UI: "Line type", default: "solid")

- `error.bar` - Show the interval as error bars (UI: "Error Bars",
  default: TRUE; requires a single X and a single Y, and a categorical X
  unless the error type is "columns")

- `error.ribbon` - Show the interval as a shaded band behind each line
  (UI: "Error Ribbon", default: FALSE; same requirements as `error.bar`)

- `error.type` - What the error bars and ribbon show: "sd", "sem",
  "ci95" or "columns" (UI: "Error Type", defaults key: `error.bar.type`,
  default: "sd")

- `error.ci.method` - How a "ci95" interval is computed: "normal" or "t"
  (UI: "Confidence Interval Method", defaults key:
  `error.bar.ci.method`, default: "normal"; only shown while the error
  type is "ci95")

- `error.lower`, `error.upper` - Numeric columns holding each point's
  lower and upper bound (UI: "Lower Bound" and "Upper Bound", default:
  ""; only shown while the error type is "columns")

- `error.colour` - Error bar color (UI: "Error Bar Colour", defaults
  key: `error.bar.colour`, default: "#000000")

- `error.width` - Error bar cap width (UI: "Error Bar Width", defaults
  key: `error.bar.width`, default: 1)

- `error.ribbon.opacity` - Ribbon fill opacity, 0 to 1 (UI: "Ribbon
  Opacity", default: 0.25)

- `palette.selection` - Color palette (UI: palette picker, derived from
  palette)

- `axis.showline` - Show axis border lines (UI: "Show Axis Borders",
  default: TRUE)

- `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror Axis
  Borders", default: TRUE)

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

- `show.grid.x` - Show X-axis gridlines (UI: "Show X Gridlines",
  default: TRUE)

- `show.grid.y` - Show Y-axis gridlines (UI: "Show Y Gridlines",
  default: TRUE)

- `grid.color` - Gridline color (UI: "Gridline Color", default:
  "#CCCCCC")

- `x.title` - X-axis title (auto-calculated from data)

- `y.title` - Y-axis title (auto-calculated from data)

- `flip.x` - Flip X-axis (UI: "Flip X", default: FALSE)

- `flip.y` - Flip Y-axis (UI: "Flip Y", default: FALSE)

## Parameters controlling additional functionality

The following parameters implementing plotly-specific features are also
available:

- `legend.show` - Show the legend and any colorbar (UI: "Show Legend",
  default: TRUE)

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

## See also

[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`linePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/linePlotOutputUI.md),
[`linePlotServer()`](https://j-andrews7.github.io/VizModules/reference/linePlotServer.md),
[`linePlotApp()`](https://j-andrews7.github.io/VizModules/reference/linePlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
data(mtcars)
linePlotInputsUI("linePlot", mtcars)
}
```
