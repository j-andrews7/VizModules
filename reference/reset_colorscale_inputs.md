# Reset uniform Color Scale inputs to defaults

Resets the colour scale inputs created by
[`uniform_colorscale_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_colorscale_inputs_ui.md)
back to their default values. The picker goes back to the colours and
preset it was built with, so the same `defaults` must reach both.

## Usage

``` r
reset_colorscale_inputs(session, defaults = NULL)
```

## Arguments

- session:

  The Shiny session object.

- defaults:

  A named list of default values. When provided, inputs reset to these
  values rather than hardcoded fallbacks. Typically the same list passed
  to the UI function.

## Value

Called for side effects; returns `invisible(NULL)`.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Call inside a module server's observeEvent(input$reset, ...) block:
reset_colorscale_inputs(session, defaults)
} # }
```
