# Server logic for the dataFilter module

Renders an interactive DT table with column-level filters and returns a
reactive containing only the currently visible (filtered) rows. This
reactive can be passed directly to any plotting module as its `data`
argument.

## Usage

``` r
dataFilterServer(
  id,
  data,
  factor.char.cols = TRUE,
  page.length = 10,
  col.visibility = FALSE,
  hide.columns = NULL,
  filter.max.options = 50
)
```

## Arguments

- id:

  The ID for the Shiny module. Must match the `id` used in
  [`dataFilterUI()`](https://j-andrews7.github.io/VizModules/dev/reference/dataFilterUI.md).

- data:

  A `reactive` containing the data frame to display and filter. Values
  that are not data frames are coerced with
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html); a
  `NULL` value is treated as "not ready yet" and the table waits for
  data.

- factor.char.cols:

  Logical. When `TRUE`, all character columns in `data` are converted to
  factors before the table is rendered. This causes DT to display
  select-box filters for those columns instead of free-text search
  boxes. Note that DT serialises every level of a factor column into the
  page, so this is best avoided for columns with very many distinct
  values. Defaults to `TRUE`.

- page.length:

  Integer. The default number of rows shown per page. Defaults to `10`.

- col.visibility:

  Logical. When `TRUE`, adds a DT "Columns" button (Buttons extension
  `colvis`) so users can show/hide individual columns. Defaults to
  `FALSE`.

- hide.columns:

  Character vector of column names (or a numeric vector of column
  positions) to hide when the table is first drawn. Hidden columns get
  no filter box, which keeps the interface focused on the columns that
  matter. They are still present in the returned data, so plotting
  modules can use them. Set `col.visibility = TRUE` if users should be
  able to bring them back; otherwise they stay hidden. Names that do not
  occur in `data` are ignored with a warning. Defaults to `NULL` (show
  every column).

- filter.max.options:

  Integer. The maximum number of options a factor column's filter
  dropdown renders at once. Typing in the box narrows the list, so a low
  cap keeps high-cardinality columns usable. Defaults to `50`.

## Value

A `reactive` expression that evaluates to the filtered subset of `data`
based on the current DT selection/filter state. All columns are
retained, including any hidden via `hide.columns`. Pass this reactive to
a plotting module's `data` argument to keep the plot in sync with the
table filters.

## See also

[`dataFilterUI()`](https://j-andrews7.github.io/VizModules/dev/reference/dataFilterUI.md),
[`resolve_column_targets()`](https://j-andrews7.github.io/VizModules/dev/reference/resolve_column_targets.md)

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
    # Petal columns are hidden on load, but the "Columns" button lets users
    # bring them back, and they remain in the returned data either way.
    filtered <- dataFilterServer("filter", data,
        factor.char.cols = TRUE,
        hide.columns = c("Petal.Length", "Petal.Width"),
        col.visibility = TRUE
    )
    output$rows <- renderPrint(nrow(filtered()))
}

if (interactive()) shinyApp(ui, server)
```
