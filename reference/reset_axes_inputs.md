# Reset uniform axes inputs to defaults

Resets all inputs created by
[`uniform_axes_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_axes_inputs_ui.md)
to their default values. Call inside an `observeEvent(input$reset, ...)`
block to avoid duplicating 20 `updateXxxInput` calls in every module
server.

## Usage

``` r
reset_axes_inputs(session, defaults = NULL)
```

## Arguments

- session:

  The Shiny session object (from `moduleServer`).

- defaults:

  A named list of default values to reset to, or NULL to use hardcoded
  fallbacks. Typically the same list passed to the UI function.

## Value

Called for side effects; returns `invisible(NULL)`.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Call inside a module server's observeEvent(input$reset, ...) block:
reset_axes_inputs(session, defaults)
} # }
```
