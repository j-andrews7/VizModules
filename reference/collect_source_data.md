# Collect plot and source data for download

Collects the plot object, its underlying data, statistical testing
details (if applied), and optional UI input values into a single list
for downstream download generation.

## Usage

``` r
collect_source_data(
  plot_reactive,
  stats_reactive = NULL,
  inputs_reactive = NULL
)
```

## Arguments

- plot_reactive:

  A reactive expression returning a `plotly` plot object.

- stats_reactive:

  Optional. A reactive expression (e.g. a
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html))
  returning a `data.frame` of statistical test results. When `NULL` or
  when the reactive returns `NULL`, no statistics data is included.

- inputs_reactive:

  Optional. A reactive expression returning a named list of UI input
  values. When `NULL` or when it returns `NULL`, no UI input data is
  included.

## Value

A named list with elements:

- plot:

  The `plotly` plot object.

- plot_data:

  A `data.frame` of the plot's underlying data, limited to the columns
  and rows actually rendered (see Details).

- stats:

  A `data.frame` of statistical test results, or `NULL`.

- inputs:

  A `data.frame` of UI input names and values, or `NULL`.

## Details

`plot_data` is scoped down from the plot's full source data.frame (as
returned by
[`plotly::plotly_data()`](https://rdrr.io/pkg/plotly/man/plotly_data.html))
in two ways:

- Columns are limited to those actually mapped in the plot (x, y,
  color/fill, shape, size, labels/values, facets, etc.), detected by
  inspecting the built `plotly` figure's trace attributes and, for
  columns that don't survive conversion to `plotly` (namely
  `split.by`/`facet.by`), the UI input values.

- Rows are limited to those with complete data across the detected
  columns, since rows with `NA` in a plotted aesthetic are dropped by
  the underlying plotting functions.

If no plotted columns can be detected, the full source data.frame is
returned unchanged.

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

    data_list <- collect_source_data(plot_reactive)
    output$my_plot <- renderPlotly(plot_reactive())
    output$download_data <- create_source_download_handler(reactive(data_list))
}

shinyApp(ui, server)
} # }
```
