# Update a multiColorPicker input on the client

Change the color values assigned to groups in an existing
multiColorPicker input from the server side. You can supply explicit
colors, apply a palette by name, or reset the widget back to its initial
state.

## Usage

``` r
updateMultiColorPicker(
  session,
  inputId,
  colors = NULL,
  palette = NULL,
  reset = FALSE
)
```

## Arguments

- session:

  The Shiny session object, typically `session`.

- inputId:

  Character. The input id of the multiColorPicker to update.

- colors:

  Optional named character vector of hex colors keyed by group name.
  Only groups present in the vector will be updated; others remain
  unchanged. Ignored when `palette` or `reset` is provided.

- palette:

  Optional character string giving the name of a palette (as supplied in
  the widget's `palette_options`). The palette's colors are applied in
  order to the widget's groups' color pickers and the palette selector
  is updated to match. Ignored when `reset` is `TRUE`.

- reset:

  Logical. If `TRUE`, reset the widget to its initial state (colors and
  selected palette). Overrides `colors` and `palette`.

## Value

Invisibly returns `NULL`. Called for its side effect.

## Author

Jared Andrews

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
    actionButton("apply_pal", "Apply ggplot2 palette"),
    actionButton("reset_cols", "Reset to initial"),
    verbatimTextOutput("chosen")
  )

  server <- function(input, output, session) {
    output$chosen <- renderPrint(input$species_cols)

    observeEvent(input$randomize, {
      new_colors <- setNames(
        sprintf("#%06X", sample(0xFFFFFF, length(groups))),
        groups
      )
      updateMultiColorPicker(session, "species_cols", colors = new_colors)
    })

    observeEvent(input$apply_pal, {
      updateMultiColorPicker(session, "species_cols", palette = "ggplot2")
    })

    observeEvent(input$reset_cols, {
      updateMultiColorPicker(session, "species_cols", reset = TRUE)
    })
  }

  shinyApp(ui, server)
}
```
