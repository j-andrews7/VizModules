# Server logic for the Figure Builder module

Powers the multi-panel **Figure Builder** module rendered by
[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderUI.md).
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
  [`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderUI.md).

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
  defaults applied only when `dataset` is the chosen dataset).
  `defaults` is passed to both `inputs_ui` and `server_fn`, so it can
  seed server-rendered controls such as the group color picker. An entry
  may also carry `primary.table`, naming which table of a multi-table
  dataset gets filtered (the first by default); its presence is also
  what marks the module as able to take a multi-table dataset at all, so
  modules without it are handed the primary table alone and any dataset
  stays usable with any module.

  A module whose output is not a plotly graph can still contribute to
  the SVG figure export by attaching a `vector_svg` attribute to the
  reactive its server returns: a `function(width, height, res)` yielding
  an `<svg>` element drawn at that pixel size, which is spliced into the
  figure in place of the `Plotly.toImage()` result.
  [`draw_to_svg()`](https://j-andrews7.github.io/VizModules/dev/reference/draw_to_svg.md)
  builds one from any grid or base drawing;
  [`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapServer.md)
  is the worked example. A panel whose module attaches nothing simply
  contributes no artwork.

  The same renderers feed the source archive, which additionally wants a
  `raster_png` counterpart returning PNG bytes (see
  [`draw_to_png()`](https://j-andrews7.github.io/VizModules/dev/reference/draw_to_png.md)).
  Either can be given as an attribute on the reactive, as here, or as a
  field on the summary list the reactive returns – the latter being
  order-independent, since the summary is rebuilt on every download. See
  [`create_source_download_handler()`](https://j-andrews7.github.io/VizModules/dev/reference/create_source_download_handler.md).

## Value

Invisibly returns `NULL`; called for its side effects (wiring up the
Figure Builder module's reactive logic).

## Details

Call this from your app's server with the same `id` you passed to
[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderUI.md).
Because it is a proper Shiny module, several Figure Builders can coexist
on one page, each with its own namespace and canvas.

## See also

[`figureBuilderUI()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderUI.md),
[`figureBuilderApp()`](https://j-andrews7.github.io/VizModules/dev/reference/figureBuilderApp.md),
[`moduleGalleryApp()`](https://j-andrews7.github.io/VizModules/dev/reference/moduleGalleryApp.md)

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
