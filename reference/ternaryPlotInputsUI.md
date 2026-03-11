# Input UI components for the ternaryPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`ternaryPlotServer()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotServer.md)
and
[`ternaryPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotOutputUI.md)
functions.

## Usage

``` r
ternaryPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
to the `defaults` argument. Provide data with numeric columns for the
three ternary axes (a, b, c). For multiple traces, include a grouping
column. Nearly all parameters for
[`ternaryPlot()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters and defaults

The following
[`ternaryPlot()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `a` - Column for a-axis (top vertex) (UI: "A-axis column", default:
  1st numeric column)

- `b` - Column for b-axis (bottom-left vertex) (UI: "B-axis column",
  default: 2nd numeric column)

- `c` - Column for c-axis (bottom-right vertex) (UI: "C-axis column",
  default: 3rd numeric column)

- `group` - Optional grouping column for multiple traces (UI: "Group
  column", default: NULL)

- `sum` - Constant sum for ternary axes (UI: "Sum", default: 100)

- `mode` - Trace mode (UI: "Mode", default: "markers")

- `marker.size` - Marker size (UI: "Marker size", default: 8)

- `marker.symbol` - Marker symbol (UI: "Marker symbol", default:
  "circle")

- `marker.line.width` - Marker border width (UI: "Marker border width",
  default: 0)

- `line.width` - Line width (UI: "Line width", default: 2)

- `line.dash` - Line dash style (UI: "Line style", default: "solid")

- `opacity` - Trace opacity (UI: "Opacity", default: 1)

- `colors` - Trace colors (UI: color picker, derived from palette)

- `a.title` - A-axis title (UI: "A-axis title", default: column name)

- `b.title` - B-axis title (UI: "B-axis title", default: column name)

- `c.title` - C-axis title (UI: "C-axis title", default: column name)

- `a.titlefont.size` - A-axis title font size (UI: "A-axis title size",
  default: 16)

- `b.titlefont.size` - B-axis title font size (UI: "B-axis title size",
  default: 16)

- `c.titlefont.size` - C-axis title font size (UI: "C-axis title size",
  default: 16)

- `a.gridcolor` - A-axis grid color (UI: "A-axis grid color", default:
  "#EEEEEE")

- `b.gridcolor` - B-axis grid color (UI: "B-axis grid color", default:
  "#EEEEEE")

- `c.gridcolor` - C-axis grid color (UI: "C-axis grid color", default:
  "#EEEEEE")

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

- `bgcolor` - Plot background color (UI: "Background color", default:
  "#FFFFFF")

## See also

[`ternaryPlot()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`ternaryPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotOutputUI.md),
[`ternaryPlotServer()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotServer.md),
[`ternaryPlotApp()`](https://j-andrews7.github.io/VizModules/reference/ternaryPlotApp.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
df <- data.frame(
    a_val = c(75, 70, 75, 5, 10),
    b_val = c(25, 10, 20, 60, 80),
    c_val = c(0, 20, 5, 35, 10)
)
ternaryPlotInputsUI("ternaryPlot", df)
#> Error in FUN(X[[i]], ...): object '.' not found
```
