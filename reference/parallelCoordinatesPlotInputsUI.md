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
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters and defaults

The following
[`parallelCoordinatesPlot()`](https://j-andrews7.github.io/VizModules/reference/parallelCoordinatesPlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `dimensions` - Columns to use as axes (UI: "Select dimensions",
  multiple: TRUE)

- `color.by` - Column to color lines by (UI: "Color by", default: "")

- `color.scale` - Colorscale for lines (UI: "Color scale", default:
  "Viridis")

- `line.opacity` - Line opacity (UI: "Line opacity", default: 0.5)

- `line.width` - Line width (UI: "Line width", default: 1)

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

- `title.font.size` - Title font size (UI: "Title font size", default:
  16)

- `title.font.family` - Title font family (UI: "Title font", default:
  "Arial")

- `title.text.color` - Title text color (UI: "Title color", default:
  "black")

- `bgcolor` - Plot background color (UI: "Background color", default:
  "#FFFFFF")

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
library(VizModules)
parallelCoordinatesPlotInputsUI("parcoords", mtcars)
#> Error in FUN(X[[i]], ...): object '.' not found
```
