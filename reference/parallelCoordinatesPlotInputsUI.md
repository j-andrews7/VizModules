# Input UI components for the parallelCoordinatesPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`parallelCoordinatesPlotServer()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotServer.md)
and
[`parallelCoordinatesPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotOutputUI.md)
functions.

## Usage

``` r
parallelCoordinatesPlotInputsUI(
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
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md)
parameters are not exposed as UI inputs:

- `title.text` - Plot title text (plotly allows interactive editing; use
  `defaults` to set)

plotly draws parallel coordinates lines one pixel wide and fully opaque,
with no way to set their width or opacity, so there are no inputs for
either.

## Plot parameters and defaults

The following
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `title.font.size` - Plot title font size (UI: "Title Size", default:
  26)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `title.font.color` - Color for plot title (UI: "Title Color", default:
  "#000000")

- `dimensions` - Columns to use as axes (UI: "Select dimensions",
  multiple: TRUE)

- `color.by` - Column to color lines by (UI: "Color by", default: "")

- `color.scale` - Colorscale for lines when `color.by` is numeric (UI:
  "Color Scale", default: "Viridis")

- `palette.selection` - Discrete color palette used when `color.by` is
  categorical (UI: palette picker)

- `show.colorbar` - Show colorbar (UI: "Show colorbar", default: TRUE)

- `label.font.size` - Dimension label font size (UI: "Label font size",
  default: 12)

- `label.font.color` - Dimension label font color (UI: "Label font
  color", default: "black")

- `label.font.family` - Dimension label font family (UI: "Label font",
  default: "Arial")

- `tick.font.size` - Tick label font size (UI: "Tick font size",
  default: 10)

- `tick.font.color` - Tick label font color (UI: "Tick font color",
  default: "black")

- `tick.font.family` - Tick label font family (UI: "Tick font", default:
  "Arial")

- `bgcolor` - Plot background color (UI: "Background color", default:
  "#FFFFFF")

- `palette.colours` - Named character vector mapping group levels to
  colors, e.g. `c(A = "#FF0000", B = "blue")` (UI: "Plot colors"). Seeds
  the picker; unnamed groups fall back to the default palette and user
  edits take precedence.

## See also

[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`parallelCoordinatesPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotOutputUI.md),
[`parallelCoordinatesPlotServer()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotServer.md),
[`parallelCoordinatesPlotApp()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
parallelCoordinatesPlotInputsUI("parcoords", mtcars)
}
```
