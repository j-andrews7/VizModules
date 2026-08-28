# Reset uniform Annotation inputs to defaults

Resets the point highlighting and annotation inputs created by
[`uniform_annotation_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_annotation_inputs_ui.md)
back to their default values.

## Usage

``` r
reset_annotation_inputs(session, defaults = NULL, choices = "")
```

## Arguments

- session:

  The Shiny session object.

- defaults:

  A named list of default values. When provided, inputs reset to these
  values rather than hardcoded fallbacks. Typically the same list passed
  to the UI function.

- choices:

  Character vector of valid "Annotate By" column names, used to validate
  the supplied default.

## Value

Called for side effects; returns `invisible(NULL)`.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Call inside a module server's observeEvent(input$reset, ...) block:
reset_annotation_inputs(session, defaults, choices = c("", names(data())))
} # }
```
