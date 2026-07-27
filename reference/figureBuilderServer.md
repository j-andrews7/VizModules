# Server logic for the Figure Builder module

Powers the multi-panel **Figure Builder** module rendered by
[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderUI.md).
Users can add any VizModules plot module to a free-form A4 canvas, drag
and resize each plot, filter each plot's data independently, label
panels automatically, and export the whole figure as a single editable
SVG (or bundle every plot's source data, HTML plot, and statistics into
one `.zip`).

## Usage

``` r
figureBuilderServer(id, data_list = NULL, module_registry = NULL)
```

## Arguments

- id:

  The ID for the Shiny module. Must match the `id` given to
  [`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderUI.md).

- data_list:

  An optional named list of data frames that seed the dataset registry.
  If `NULL` (the default), the bundled example datasets (plus a
  `sales_by_product` summary suited to the pie plot) are used. At least
  one element is required and every element must be a data frame.

- module_registry:

  An optional named list describing the plot modules to offer. If `NULL`
  (the default), all bundled VizModules modules are offered. Each entry
  is itself a list with components: `label` (character, shown in the
  picker), `dataset` (character, the dataset name its `defaults` were
  written for), `inputs_ui`, `output_ui`, and `server_fn` (the module's
  three functions), and `defaults` (a named list of input defaults
  applied only when `dataset` is the chosen dataset).

## Value

Invisibly returns `NULL`; called for its side effects (wiring up the
Figure Builder module's reactive logic).

## Details

Call this from your app's server with the same `id` you passed to
[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderUI.md).
Because it is a proper Shiny module, several Figure Builders can coexist
on one page, each with its own namespace and canvas.

## See also

[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderUI.md),
[`figureBuilderApp()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderApp.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
if (interactive()) {
    ui <- fluidPage(figureBuilderUI("figure_builder"))
    server <- function(input, output, session) {
        figureBuilderServer("figure_builder")
    }
    shinyApp(ui, server)
}
```
