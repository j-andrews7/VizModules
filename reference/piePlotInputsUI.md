# Input UI components for the piePlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`piePlotServer()`](https://j-andrews7.github.io/VizModules/reference/piePlotServer.md)
and
[`piePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/piePlotOutputUI.md)
functions.

## Usage

``` r
piePlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation. Supply a summary table with
  one row per slice.

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
to the `defaults` argument. Provide summarized data (one row per slice)
with columns for labels and aggregated values. Nearly all parameters for
[`piePlot()`](https://j-andrews7.github.io/VizModules/reference/piePlot.md)
can be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters and defaults

The following
[`piePlot()`](https://j-andrews7.github.io/VizModules/reference/piePlot.md)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `labels` - Label column (UI: "Label column (summary data)", default:
  2nd categorical column)

- `values` - Aggregated value column (UI: "Aggregated value column",
  default: 2nd numeric column)

- `sort` - Sort slices by value (UI: "Sort slices by value", default:
  TRUE)

- `direction` - Slice direction (UI: "Slice direction", default:
  "counterclockwise")

- `rotation` - Start angle in degrees (UI: "Start angle (degrees)",
  default: 0)

- `hole` - Center hole size for donut chart (UI: "Center hole size",
  default: 0)

- `colors` - Slice colors (UI: color picker, derived from palette)

- `slice.line.color` - Slice border color (UI: "Slice border color",
  default: "#FFFFFF")

- `slice.line.width` - Slice border width (UI: "Slice border width",
  default: 0)

- `textinfo` - Text to show on slices (UI: "Text to show on slices",
  default: c("label", "value", "percent"))

- `textposition` - Text position (UI: "Text position", default: "auto")

- `insidetextorientation` - Inside text orientation (UI: "Inside text
  orientation", default: "auto")

- `text.font.size` - Slice text size (UI: "Slice text size", default:
  12)

- `text.font.family` - Slice text font (UI: "Slice text font", default:
  "Arial")

- `text.font.color` - Slice text color (UI: "Slice text color", default:
  "#000000")

- `title.x` - Title horizontal position (UI: "Title horizontal
  position", default: 0.5)

- `title.font.size` - Title font size (UI: "Title font size", default:
  28)

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

## See also

[`piePlot()`](https://j-andrews7.github.io/VizModules/reference/piePlot.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`piePlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/piePlotOutputUI.md),
[`piePlotServer()`](https://j-andrews7.github.io/VizModules/reference/piePlotServer.md),
[`piePlotApp()`](https://j-andrews7.github.io/VizModules/reference/piePlotApp.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(VizModules)
pie_df <- as.data.frame(table(iris$Species))
names(pie_df) <- c("Species", "Count")
piePlotInputsUI("piePlot", pie_df)
#> Error in FUN(X[[i]], ...): object '.' not found
```
