# Update a multiColorPicker input on the client

Change the color values assigned to groups in an existing
multiColorPicker input from the server side.

## Usage

``` r
updateMultiColorPicker(session, inputId, colors)
```

## Arguments

- session:

  The Shiny session object, typically `session`.

- inputId:

  Character. The input id of the multiColorPicker to update.

- colors:

  A named character vector of hex colors keyed by group name. Only
  groups present in the vector will be updated; others remain unchanged.

## Value

Invisibly returns `NULL`. Called for its side effect.

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
    actionButton("randomize", "Randomize colors"),
    verbatimTextOutput("chosen")
  )

  server <- function(input, output, session) {
    output$chosen <- renderPrint(input$species_cols)

    observeEvent(input$randomize, {
      new_colors <- setNames(
        sprintf("#%06X", sample(0xFFFFFF, length(groups))),
        groups
      )
      updateMultiColorPicker(session, "species_cols", new_colors)
    })
  }

  shinyApp(ui, server)
}
```
