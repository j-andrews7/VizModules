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

  The Shiny input object from the module server.

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
if (FALSE) { # \dontrun{
# In a module server function:
output$myPlot <- renderPlot({
    isolate_fn <- setup_auto_update_logic(input)
    # Use isolate_fn to wrap inputs that should respect auto-update setting
    ggplot(data(), aes(x = isolate_fn(input$x_var), y = isolate_fn(input$y_var))) +
        geom_point()
})
} # }
```
