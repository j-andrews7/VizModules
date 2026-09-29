# Create download handler for plot with source data

Generates a Shiny
[`downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html)
that bundles the interactive plot, images of it, and its supporting data
into a single `.zip` archive.

## Usage

``` r
create_source_download_handler(
  data_list,
  filename_base = "source_data",
  images = TRUE,
  output_id = "download.source",
  session = getDefaultReactiveDomain()
)
```

## Arguments

- data_list:

  A reactive returning either a single summary list produced by
  [`collect_source_data()`](https://j-andrews7.github.io/VizModules/dev/reference/collect_source_data.md)
  (with elements `plot`, `plot_data`, `stats`, and `inputs`), or a named
  list of such summaries (one per plot). When a named list of summaries
  is supplied, each summary is written to its own set of files (prefixed
  with the list name) so several plots can be bundled into a single
  archive.

- filename_base:

  `character(1)`. Base name for the downloaded `.zip` file without
  extension. The final filename takes the form
  `<filename_base>_<Sys.Date()>.zip`.

- images:

  `logical(1)`. Whether to include `.svg` and `.png` images of each
  plot. Requires the button to carry the markup
  [`module_tack_ui()`](https://j-andrews7.github.io/VizModules/dev/reference/module_tack_ui.md)
  gives it; a hand-rolled
  [`shiny::downloadButton()`](https://rdrr.io/pkg/shiny/man/downloadButton.html)
  without it simply gets no images.

- output_id:

  `character(1)`. The id this handler is assigned to within its module,
  used to find the images the browser sends. Only needs changing if the
  handler is assigned to something other than `output$download.source`.

- session:

  The module session. Defaults to the calling module's, which is what
  every in-package call site wants.

## Value

A `downloadHandler` object suitable for assignment to a Shiny output.

## Details

The archive holds, per plot: the interactive plot as self-contained HTML
(`<name>_plot.html`), an `<name>_plot.svg` and `<name>_plot.png` of it,
and CSVs of the plot data, the statistics, and the UI inputs.

The images are photographed in the browser, off the graph the user is
looking at, so they carry every edit made after the figure was built –
reference lines, statistical brackets, restyled axes and legends,
dragged annotations. The capture happens between the button's click and
the download itself, which is why the button pauses briefly before the
archive arrives. When it cannot be done – the capture fails, the round
trip times out, the plot sits on a hidden tab – the archive still
downloads, without the images.

A module whose output is not a plotly graph has nothing for the browser
to photograph and draws itself instead, by putting a `vector_svg` and/or
`raster_png` function of `(width, height, res)` on its summary list, or
on the reactive passed as `data_list`.
[`draw_to_svg()`](https://j-andrews7.github.io/VizModules/dev/reference/draw_to_svg.md)
and
[`draw_to_png()`](https://j-andrews7.github.io/VizModules/dev/reference/draw_to_png.md)
build one from any grid or base drawing;
[`ComplexHeatmap_HeatmapServer()`](https://j-andrews7.github.io/VizModules/dev/reference/ComplexHeatmap_HeatmapServer.md)
is the worked example.

A summary may also carry `svg_key`, naming the captured image that
belongs to it. The Figure Builder uses this because the browser knows a
panel only by its id, while the summary is named after the panel's
display label.

One caveat worth passing on to users: a plot drawn with WebGL (the
`dittoViz` scatter plot's WebGL toggle) can only be photographed as a
raster, so its points arrive as an embedded image inside an otherwise
vector SVG. Turning WebGL off gives a fully editable file.

## See also

[`collect_source_data()`](https://j-andrews7.github.io/VizModules/dev/reference/collect_source_data.md),
[`module_tack_ui()`](https://j-andrews7.github.io/VizModules/dev/reference/module_tack_ui.md)

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Example usage in a Shiny app
library(shiny)
library(plotly)
library(VizModules)
ui <- fluidPage(
    plotlyOutput("my_plot"),
    downloadButton("download_data", "Download Plot and Data")
)

server <- function(input, output) {
    plot_reactive <- reactive({
        plot_ly(mtcars, x = ~mpg, y = ~hp, type = "scatter", mode = "markers")
    })

    output$my_plot <- renderPlotly(plot_reactive())
    # collect_source_data() reads reactives, so it has to run inside one.
    inputs_reactive <- reactive(reactiveValuesToList(input))
    output$download_data <- create_source_download_handler(
        reactive(collect_source_data(plot_reactive, inputs_reactive = inputs_reactive))
    )
}

shinyApp(ui, server)
} # }
```
