# Reset uniform Legend inputs to defaults

Resets the legend styling inputs (legend title and entry label font
sizes) created by
[`uniform_legend_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_legend_inputs_ui.md)
back to their default values.

## Usage

``` r
reset_legend_inputs(session, defaults = NULL)
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
reset_legend_inputs(session, defaults)
} # }
```
