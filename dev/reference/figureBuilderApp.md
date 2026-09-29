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
  `sales_by_region` summary suited to the pie plot) are used. At least
  one element is required. An element is either a data frame, or a named
  list of data frames for a module that needs companion tables (the
  `ComplexHeatmap` module's `list(matrix = , column_annotations = )`);
  in the latter case only the primary table is filtered and shown in the
  panel's table pane.

- module_registry:

  An optional named list describing the plot modules to offer. If `NULL`
  (the default), all bundled VizModules modules are offered, each
  opening on the same example figure as in
  [`moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/dev/reference/moduleGalleryApp.md).
  Each entry is itself a list with components: `label` (character, shown
  in the picker), `dataset` (character, the dataset name its `defaults`
  were written for), `inputs_ui`, `output_ui`, and `server_fn` (the
  module's three functions), and `defaults` (a named list of input
  defaults applied only when `dataset` is the chosen dataset). An entry
  may also carry `primary.table`, naming which table of a multi-table
  dataset gets filtered (the first by default); its presence is also
  what marks the module as able to take a multi-table dataset at all, so
  modules without it are handed the primary table alone and any dataset
  stays usable with any module. See
  [`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderServer.md)
  for the `vector_svg` hook that lets a non-plotly module take part in
  the SVG figure export.

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
users can also upload additional datasets (CSV, TSV, or tab-delimited
TXT) at runtime. The set of available plot modules is controlled by
`module_registry`, so the app can be extended with custom wrapper
modules without editing the package.

This is the recommended way to launch a standalone Figure Builder.
Internally it is a thin wrapper around the
[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderUI.md)
/
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderServer.md)
Shiny module, so the same builder can be embedded inside a larger app
(and instantiated more than once) by calling those two functions
directly. It is also the **Figure Builder** tab of
[`moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/dev/reference/moduleGalleryApp.md).

## See also

[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderUI.md),
[`figureBuilderServer()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderServer.md),
[`moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/dev/reference/moduleGalleryApp.md)

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
