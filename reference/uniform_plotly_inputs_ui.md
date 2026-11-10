# Generate uniform Plotly input UI

Creates a standardized tagList of Plotly-specific inputs used across all
plot modules. Includes interactive download controls, plot margin
adjustments, and user-drawn shape styling for Plotly's drawing tools.
(Subplot spacing controls live in each module's "Facet" tab via
[`uniform_subplot_spacing_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_subplot_spacing_inputs_ui.md).)

## Usage

``` r
uniform_plotly_inputs_ui(ns, defaults = NULL, include.shapes = TRUE)
```

## Arguments

- ns:

  A namespace function, typically created by `NS(id)`.

- defaults:

  A named list of default values for the inputs.

- include.shapes:

  Logical; whether to include the controls styling shapes drawn with
  plotly's drawing tools. Pass `FALSE` for plots without cartesian axes
  (pie, radar, parallel coordinates), where those tools do not work.
  Default is `TRUE`.

## Value

A `tagList` containing the Plotly input UI elements.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
ns <- shiny::NS("plot")
uniform_plotly_inputs_ui(ns)
}
```
