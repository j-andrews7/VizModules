# Compact multi-group color picker input

Build a compact Shiny input that assigns colors to a set of groups using
a palette or manual hex pickers. The value returned to
`input[[inputId]]` is a named character vector of hex colors keyed by
group.

## Usage

``` r
multiColorPicker(
  inputId,
  label = NULL,
  groups,
  palette_options = NULL,
  selected_palette = NULL,
  colors = NULL,
  width = NULL,
  show_text = TRUE,
  compact = FALSE,
  panel = TRUE
)
```

## Arguments

- inputId:

  Character. Shiny input id.

- label:

  Optional label displayed above the control.

- groups:

  Character or factor vector of group names.

- palette_options:

  Named list of palettes (each a character vector of colors). Defaults
  to the palettes from
  [`default_palettes()`](https://j-andrews7.github.io/vizModules/reference/default_palettes.md).

- selected_palette:

  Optional name of the palette to preselect.

- colors:

  Optional named vector of starting colors. Values are matched to
  `groups` by name when provided.

- width:

  Optional CSS width for the container.

- show_text:

  Logical. If `TRUE`, show editable hex text inputs beside the color
  pickers.

- compact:

  Logical. If `TRUE`, renders a tighter layout with reduced spacing,
  smaller controls, and narrower palette selector.

- panel:

  Logical. If `FALSE`, removes the surrounding panel/well styling
  (border, padding, background).

## Value

A UI element that produces a named character vector of colors.

## Examples

``` r
if (interactive()) {
  library(shiny)
  groups <- c("setosa", "virginica", "versicolor")

  ui <- fluidPage(
    multiColorPicker(
      "species_cols",
      "Species colors",
      groups = groups,
      selected_palette = "dittoColors"
    ),
    verbatimTextOutput("chosen")
  )

  server <- function(input, output, session) {
    output$chosen <- renderPrint(input$species_cols)
  }

  shinyApp(ui, server)
}
```
