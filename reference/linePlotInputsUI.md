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
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters and defaults

The following
[`linePlot()`](https://j-andrews7.github.io/VizModules/reference/linePlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x` - X-axis variable(s) (UI: "Select X values", default: 1st column,
  multiple: TRUE)

- `y` - Y-axis variable(s) (UI: "Select Y values", default: 2nd column,
  multiple: TRUE)

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

- `plot.mode` - Plot type (UI: "Plot type", default: "lines")

- `line.type` - Line type (UI: "Line type", default: "solid")

- `palette.selection` - Color palette (UI: palette picker, derived from
  palette)

- `axis.showline` - Show axis lines (UI: via .uniform_axes_inputs_ui,
  default: TRUE)

- `axis.mirror` - Mirror axis lines (UI: via .uniform_axes_inputs_ui,
  default: TRUE)

- `axis.linecolor` - Axis line color (UI: via .uniform_axes_inputs_ui,
  default: "black")

- `axis.linewidth` - Axis line width (UI: via .uniform_axes_inputs_ui,
  default: 0.5)

- `axis.tickfont.size` - Tick font size (UI: via
  .uniform_axes_inputs_ui, default: 12)

- `axis.tickfont.color` - Tick font color (UI: via
  .uniform_axes_inputs_ui, default: "black")

- `axis.tickfont.family` - Tick font family (UI: via
  .uniform_axes_inputs_ui, default: "Arial")

- `axis.tickangle.x` - X-axis tick angle (UI: via
  .uniform_axes_inputs_ui, default: 0)

- `axis.tickangle.y` - Y-axis tick angle (UI: via
  .uniform_axes_inputs_ui, default: 0)

- `axis.ticks` - Tick position (UI: via .uniform_axes_inputs_ui,
  default: "outside")

- `axis.tickcolor` - Tick color (UI: via .uniform_axes_inputs_ui,
  default: "black")

- `axis.ticklen` - Tick length (UI: via .uniform_axes_inputs_ui,
  default: 5)

- `axis.tickwidth` - Tick width (UI: via .uniform_axes_inputs_ui,
  default: 1)

- `show.grid.x` - Show X-axis gridlines (UI: "Show X Gridlines",
  default: TRUE)

- `show.grid.y` - Show Y-axis gridlines (UI: "Show Y Gridlines",
  default: TRUE)

- `title.font.size` - Title font size (UI: via .uniform_axes_inputs_ui,
  default: 28)

- `title.font.family` - Title font family (UI: "Font", default: "Arial")

- `title.text.color` - Title text color (UI: via
  .uniform_axes_inputs_ui, default: "#000000")

- `x.title` - X-axis title (auto-calculated from data)

- `y.title` - Y-axis title (auto-calculated from data)

- `flip.x` - Flip X-axis (UI: "Flip X", default: FALSE)

- `flip.y` - Flip Y-axis (UI: "Flip Y", default: FALSE)

## Parameters controlling additional functionality

The following parameters implementing plotly-specific features are also
available:

- `hline.intercepts` - Horizontal line Y-intercepts (UI: via
  .uniform_lines_inputs_ui, default: "")

- `hline.colors` - Horizontal line colors (UI: via
  .uniform_lines_inputs_ui, default: "#000000")

- `hline.widths` - Horizontal line widths (UI: via
  .uniform_lines_inputs_ui, default: "1")

- `hline.linetypes` - Horizontal line types (UI: via
  .uniform_lines_inputs_ui, default: "dashed")

- `hline.opacities` - Horizontal line opacities (UI: via
  .uniform_lines_inputs_ui, default: "1")

- `vline.intercepts` - Vertical line X-intercepts (UI: via
  .uniform_lines_inputs_ui, default: "")

- `vline.colors` - Vertical line colors (UI: via
  .uniform_lines_inputs_ui, default: "#000000")

- `vline.widths` - Vertical line widths (UI: via
  .uniform_lines_inputs_ui, default: "1")

- `vline.linetypes` - Vertical line types (UI: via
  .uniform_lines_inputs_ui, default: "dashed")

- `vline.opacities` - Vertical line opacities (UI: via
  .uniform_lines_inputs_ui, default: "1")

- `abline.slopes` - Diagonal line slopes (UI: via
  .uniform_lines_inputs_ui, default: "")

- `abline.intercepts` - Diagonal line Y-intercepts (UI: via
  .uniform_lines_inputs_ui, default: "")

- `abline.colors` - Diagonal line colors (UI: via
  .uniform_lines_inputs_ui, default: "#000000")

- `abline.widths` - Diagonal line widths (UI: via
  .uniform_lines_inputs_ui, default: "1")

- `abline.linetypes` - Diagonal line types (UI: via
  .uniform_lines_inputs_ui, default: "dashed")

- `abline.opacities` - Diagonal line opacities (UI: via
  .uniform_lines_inputs_ui, default: "1")

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
library(VizModules)
data(mtcars)
linePlotInputsUI("linePlot", mtcars)
#> Error in FUN(X[[i]], ...): object '.' not found
```
