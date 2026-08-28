# Hide or show the grid cell wrapping a module input

Toggles the visibility of the `.vizmodules-input-cell` that wraps a
given input (as laid out by
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)).
Hiding the cell rather than just the input itself lets the surrounding
inputs reflow so the panel stays compact instead of leaving an empty
gap, as a plain
[`shinyjs::hide()`](https://rdrr.io/pkg/shinyjs/man/visibilityFuncs.html)
on the input would.

## Usage

``` r
toggle_input_cell(session, ids, show)
```

## Arguments

- session:

  The module `session` object (provides `session$ns`).

- ids:

  Character vector of un-namespaced input IDs to toggle.

- show:

  Logical; `TRUE` to show the cell, `FALSE` to hide it.

## Value

Invisibly `NULL`, called for the side effect of running client-side JS.

## See also

[`hide_input()`](https://j-andrews7.github.io/VizModules/reference/hide_input.md),
[`show_input()`](https://j-andrews7.github.io/VizModules/reference/show_input.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Call inside a module server, e.g. from an observeEvent():
toggle_input_cell(session, "size", show = input$show.size)
} # }
```
