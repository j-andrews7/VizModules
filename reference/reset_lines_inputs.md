# Reset uniform lines inputs to defaults

Resets all inputs created by
[`uniform_lines_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_lines_inputs_ui.md)
to their default values. Call inside an `observeEvent(input$reset, ...)`
block to avoid duplicating line-reset boilerplate in every module
server.

## Usage

``` r
reset_lines_inputs(session, include.fit.lines = FALSE, defaults = NULL)
```

## Arguments

- session:

  The Shiny session object (from `moduleServer`).

- include.fit.lines:

  Logical; if TRUE, also resets the fit-line inputs (best.fit,
  line.best.smoothness, line.best.colour, linear.model). Default is
  FALSE.

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
reset_lines_inputs(session, defaults = defaults)
} # }
```
