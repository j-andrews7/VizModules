# Set up auto-update/isolate logic for reactive contexts

A helper function that encapsulates the common pattern of handling
auto-update functionality in module servers. When auto-update is
disabled, it adds a dependency on the update button. Returns a wrapper
function that either isolates reactive expressions or passes them
through unchanged.

## Usage

``` r
setup_auto_update_logic(input)
```

## Arguments

- input:

  The Shiny input object from the module server, should have both
  `auto.update` (boolean) and `update` (button) inputs.

## Value

A function that wraps reactive expressions. Returns `identity` if
auto-update is enabled (expressions will be reactive), or `isolate` if
auto-update is disabled (expressions will not trigger reactivity).

## Details

This function consolidates the following common pattern:


    auto_update <- input$auto.update
    if (!auto_update) {
        input$update
    }
    isolate_fn <- if (auto_update) identity else isolate

Usage in a reactive context:


    output$plot <- renderPlotly({
        isolate_fn <- setup_auto_update_logic(input)
        # Now use isolate_fn to wrap input values
        x_val <- isolate_fn(input$x.value)
    })

## Author

Jared Andrews

## Examples

``` r
if (interactive()) {
    library(shiny)
    library(plotly)

    ui <- fluidPage(
        selectInput("x_var", "X variable", choices = names(mtcars), selected = "wt"),
        selectInput("y_var", "Y variable", choices = names(mtcars), selected = "mpg"),
        checkboxInput("auto.update", "Auto-update", value = TRUE),
        actionButton("update", "Update"),
        plotlyOutput("myPlot")
    )

    server <- function(input, output, session) {
        output$myPlot <- renderPlotly({
            isolate_fn <- setup_auto_update_logic(input)
            x_val <- isolate_fn(input$x_var)
            y_val <- isolate_fn(input$y_var)
            plot_ly(mtcars, x = ~ .data[[x_val]], y = ~ .data[[y_val]], type = "scatter",
                mode = "markers")
        })
    }

    shinyApp(ui, server)
}
```
