# Create download handler for plot with source data

Generates a Shiny
[`downloadHandler()`](https://rdrr.io/pkg/shiny/man/downloadHandler.html)
that bundles the interactive plot and its supporting data into a single
`.zip` archive.

## Usage

``` r
create_source_download_handler(data_list, filename_base = "source_data")
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

## Value

A `downloadHandler` object suitable for assignment to a Shiny output.

## Author

Jacob Martin

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
