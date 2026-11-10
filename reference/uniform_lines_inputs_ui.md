# Generate uniform Lines input UI

Creates a standardized tagList of line-related inputs (horizontal,
vertical, and diagonal lines) for use across plot modules.

## Usage

``` r
uniform_lines_inputs_ui(ns, defaults = NULL, include.fit.lines = FALSE)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

- include.fit.lines:

  Logical; whether to include the fit and model line inputs: "line of
  best fit", "linear model line", custom model lines, and whether those
  lines are listed in the legend (`model.legend.show`, off by default).
  Only applicable for scatter plots. Default is FALSE.

## Value

A `tagList` containing the line input UI elements.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
ns <- shiny::NS("plot")
uniform_lines_inputs_ui(ns)
uniform_lines_inputs_ui(ns, include.fit.lines = TRUE)
}
```
