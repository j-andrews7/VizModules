# Create a VizModules Figure Builder Application

Build the multi-panel **Figure Builder** Shiny application as a
returnable object. The app lets users add any VizModules plot module to
a free-form A4 canvas, drag and resize each plot, filter each plot's
data independently, label panels automatically, and export the whole
figure as a single editable SVG (or bundle every plot's source data,
HTML plot, and statistics into one `.zip`).

## Usage

``` r
figureBuilderApp(
  data_list = NULL,
  module_registry = NULL,
  title = "VizModules Figure Builder",
  return_components = FALSE
)
```

## Arguments

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

- title:

  A character string used as the page title and header (default:
  `"VizModules Figure Builder"`).

- return_components:

  Logical. When `FALSE` (the default) a
  [`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
  object is returned. When `TRUE` a named list with `ui` and `server`
  elements is returned instead, which is convenient for deployment
  scripts that need an explicit `shinyApp(ui, server)` call.

## Value

Either a
[`shiny::shinyApp()`](https://rdrr.io/pkg/shiny/man/shinyApp.html)
object, or (when `return_components = TRUE`) a list with elements `ui`
and `server`.

## Details

Datasets are supplied via `data_list` and seed the "Add Plot" dialog;
users can also upload additional datasets (CSV, TSV, TXT, or RDS) at
runtime. The set of available plot modules is controlled by
`module_registry`, so the app can be extended with custom wrapper
modules without editing the package.

This is the recommended way to launch a standalone Figure Builder.
Internally it is a thin wrapper around the
[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderUI.md)
/
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md)
Shiny module, so the same builder can be embedded inside a larger app
(and instantiated more than once) by calling those two functions
directly. The bundled app at
`system.file("apps/figure-builder", package = "VizModules")` is itself a
thin wrapper around this function.

## See also

[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderUI.md),
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/reference/figureBuilderServer.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)

# Launch with the bundled example datasets and all modules:
app <- figureBuilderApp()
if (interactive()) runApp(app)

# Launch with your own datasets:
app2 <- figureBuilderApp(data_list = list("iris" = iris, "mtcars" = mtcars))
if (interactive()) runApp(app2)

# Return the UI and server separately (e.g. for a deployment app.R):
parts <- figureBuilderApp(return_components = TRUE)
if (interactive()) shinyApp(parts$ui, parts$server)
```
