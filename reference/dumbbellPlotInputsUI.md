# Input UI components for the dumbbellPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dumbbellPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotServer.md)
and
[`dumbbellPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotOutputUI.md)
functions.

## Usage

``` r
dumbbellPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
to the `defaults` argument.

## Plot parameters and defaults

The following
[`dumbbellPlot()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlot.md)
parameters can be accessed via UI inputs:

- `x` - X values (UI: "Select X values (max 2)", multiple: TRUE, max 2
  enforced)

- `y` - Y value (UI: "Select Y value", single selection)

- `x.adjustment` - X-axis transformation (UI: "X Adjustment")

- `colour.by` - Color by X or Y (UI: "Colour by", options: "X
  variables", "Y variables")

- `facet.by` - Faceting variable (UI: "Facet by")

- `facet.scales` - Facet scale behavior (UI: "Facet scales", default:
  "fixed")

- `line.colour` - Color of connecting lines (UI: "Colour Of connectors",
  default: "red")

- `palette.selection` - Color palette (UI: palette picker)

- `axis.*` - Various axis styling options (UI: via
  .uniform_axes_inputs_ui)

- `flip.x` - Flip X-axis (UI: "Flip X", default: FALSE)

- `flip.y` - Flip Y-axis (UI: "Flip Y", default: FALSE)

## See also

[`dumbbellPlot()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`dumbbellPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotOutputUI.md),
[`dumbbellPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotServer.md),
[`dumbbellPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dumbbellPlotApp.md)

## Author

Jacob Martin

## Examples

``` r
library(VizModules)
data <- data.frame(
  School = c("MIT", "Stanford", "Harvard"),
  Women = c(94, 96, 112),
  Men = c(152, 151, 165)
)
dumbbellPlotInputsUI("dumbbellPlot", data)
#> Error in FUN(X[[i]], ...): object '.' not found
```
