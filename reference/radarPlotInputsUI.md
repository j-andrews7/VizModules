# Input UI components for the radarPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`radarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/radarPlotServer.md)
and
[`radarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotOutputUI.md)
functions.

## Usage

``` r
radarPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
to the `defaults` argument. Provide data with columns for categories
(theta) and values (r). For multiple traces, include a grouping column.
Nearly all parameters for
[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters and defaults

The following
[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `theta` - Category column for angular axes (UI: "Category column
  (theta)", default: 1st categorical column)

- `r` - Values column for radial distance (UI: "Values column (r)",
  default: 1st numeric column)

- `group` - Optional grouping column for multiple traces (UI: "Group
  column", default: NULL)

- `fill` - Fill area under trace (UI: "Fill area", default: "toself")

- `line.width` - Line width (UI: "Line width", default: 2)

- `line.dash` - Line dash style (UI: "Line style", default: "solid")

- `marker.size` - Marker size (UI: "Marker size", default: 5)

- `marker.symbol` - Marker symbol (UI: "Marker symbol", default:
  "circle")

- `opacity` - Trace opacity (UI: "Opacity", default: 0.6)

- `colors` - Trace colors (UI: color picker, derived from palette)

- `radial.visible` - Show radial axis (UI: "Show radial axis", default:
  TRUE)

- `radial.range` - Radial axis range (UI: "Radial min" and "Radial max",
  default: auto)

- `radial.showline` - Show radial axis line (UI: "Show radial line",
  default: TRUE)

- `radial.linecolor` - Radial axis line color (UI: "Radial line color",
  default: "#444444")

- `radial.gridcolor` - Radial grid color (UI: "Radial grid color",
  default: "#EEEEEE")

- `angular.direction` - Angular axis direction (UI: "Angular direction",
  default: "clockwise")

- `angular.rotation` - Angular axis rotation (UI: "Angular rotation",
  default: 90)

- `angular.gridcolor` - Angular grid color (UI: "Angular grid color",
  default: "#EEEEEE")

- `title.x` - Title horizontal position (UI: "Title horizontal
  position", default: 0.5)

- `title.font.size` - Title font size (UI: "Title font size", default:
  18)

- `title.font.family` - Title font (UI: "Title font", default: "Arial")

- `title.font.color` - Title font color (UI: "Title font color",
  default: "#000000")

- `show.legend` - Show legend (UI: "Show legend", default: TRUE)

- `legend.orientation` - Legend orientation (UI: "Legend orientation",
  default: "h")

- `legend.font.family` - Legend font (UI: "Legend font", default:
  "Arial")

- `legend.font.size` - Legend font size (UI: "Legend font size",
  default: 12)

- `legend.font.color` - Legend font color (UI: "Legend font color",
  default: "#000000")

- `bgcolor` - Plot background color (UI: "Plot background color",
  default: "#FFFFFF")

- `polar.bgcolor` - Polar area background color (UI: "Polar area
  background", default: "#FFFFFF")

## See also

[`radarPlot()`](https://j-andrews7.github.io/VizModules/reference/radarPlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`radarPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/radarPlotOutputUI.md),
[`radarPlotServer()`](https://j-andrews7.github.io/VizModules/reference/radarPlotServer.md),
[`radarPlotApp()`](https://j-andrews7.github.io/VizModules/reference/radarPlotApp.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
skills <- data.frame(
    category = c("Speed", "Strength", "Defense", "Stamina", "Speed"),
    value = c(8, 6, 7, 9, 8)
)
radarPlotInputsUI("radarPlot", skills)
#> Error in FUN(X[[i]], ...): object '.' not found
```
