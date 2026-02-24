# Server logic for the dataFilter module

Renders an interactive DT table with column-level filters and returns a
reactive containing only the currently visible (filtered) rows. This
reactive can be passed directly to any plotting module as its `data`
argument.

## Usage

``` r
dataFilterServer(id, data, factor.char.cols = TRUE, page.length = 10)
```

## Arguments

- id:

  The ID for the Shiny module. Must match the `id` used in
  [`dataFilterUI()`](https://j-andrews7.github.io/VizModules/reference/dataFilterUI.md).

- data:

  A `reactive` containing the data frame to display and filter.

- factor.char.cols:

  Logical. When `TRUE`, all character columns in `data` are converted to
  factors before the table is rendered. This causes DT to display
  select-box filters for those columns instead of free-text search
  boxes. Defaults to `TRUE`.

- page.length:

  Integer. The default number of rows shown per page. Defaults to `10`.

## Value

A `reactive` expression that evaluates to the filtered subset of `data`
based on the current DT selection/filter state. Pass this reactive to a
plotting module's `data` argument to keep the plot in sync with the
table filters.

## See also

[`dataFilterUI()`](https://j-andrews7.github.io/VizModules/reference/dataFilterUI.md)

## Author

Jacob Martin

## Examples

``` r
library(shiny)
library(VizModules)

ui <- fluidPage(
    dataFilterUI("filter"),
    verbatimTextOutput("rows")
)

server <- function(input, output, session) {
    data <- reactive(iris)
    filtered <- dataFilterServer("filter", data, factor.char.cols = TRUE)
    output$rows <- renderPrint(nrow(filtered()))
}

if (interactive()) shinyApp(ui, server)
```
