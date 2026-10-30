# Keep a level-order control in step with its column

The server half of
[`level_order_input()`](https://j-andrews7.github.io/VizModules/reference/level_order_input.md).
Refills the control with the levels of the selected column whenever the
data or the column changes, holds the order the plot should use, and
restores `defaults[[inputId]]` when the module's Reset button
(`input$reset`) is pressed.

## Usage

``` r
setup_level_order(
  input,
  session,
  data,
  column,
  defaults = NULL,
  inputId = "x.order",
  max.levels = 20
)
```

## Arguments

- input, session:

  The module's `input` and `session`.

- data:

  A reactive holding the module's data frame.

- column:

  A reactive (or function) giving the name of the column ordered, e.g.
  `reactive(input$x.data)`.

- defaults:

  The module's named list of defaults, or `NULL`.

- inputId:

  The un-namespaced ID of the
  [`level_order_input()`](https://j-andrews7.github.io/VizModules/reference/level_order_input.md).

- max.levels:

  The most levels the control offers; see
  [`level_order_choices()`](https://j-andrews7.github.io/VizModules/reference/level_order_choices.md).

## Value

A
[`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
holding the levels in the order to draw, or `NULL` for the default
order. Hand it to
[`apply_level_order()`](https://j-andrews7.github.io/VizModules/reference/apply_level_order.md).

## Details

A new column starts from `defaults[[inputId]]` (levels it does not have
are ignored), and new data for the same column keeps the order the user
dragged the levels into. A column the control cannot order – numeric, or
with more than `max.levels` levels – empties the control, which hides
it.

The returned store, not `input[[inputId]]`, is what the plot should
read. It changes only when the order to draw does, so neither the
control reporting its initial value nor its echo of an update costs an
extra render. A `defaults[[inputId]]` given as a
[`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) is
followed as the parent's state changes, as with
[`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md).

## See also

[`level_order_input()`](https://j-andrews7.github.io/VizModules/reference/level_order_input.md),
[`apply_level_order()`](https://j-andrews7.github.io/VizModules/reference/apply_level_order.md)

## Author

Jared Andrews

## Examples

``` r
if (interactive()) {
    library(shiny)

    ui <- fluidPage(
        selectInput("x", "X", c("Species", "Petal.Size")),
        level_order_input("x.order", "X Order"),
        plotOutput("plot")
    )

    server <- function(input, output, session) {
        data <- reactive({
            df <- example_iris
            df$Petal.Size <- ifelse(df$Petal.Length > 4, "Large", "Small")
            df
        })
        x.order <- setup_level_order(input, session, data, reactive(input$x))

        output$plot <- renderPlot({
            df <- apply_level_order(data(), input$x, x.order())
            boxplot(df$Sepal.Length ~ df[[input$x]], xlab = input$x)
        })
    }

    shinyApp(ui, server)
}
```
