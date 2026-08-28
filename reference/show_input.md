# Show the grid cells wrapping module inputs

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
show_input(session, ids)
```

## Arguments

- session:

  The module `session` object (provides `session$ns`).

- ids:

  Character vector of un-namespaced input IDs to toggle.

## Value

Invisibly `NULL`, called for the side effect of running client-side JS.

## See also

[`hide_input()`](https://j-andrews7.github.io/VizModules/reference/hide_input.md),
[`toggle_input_cell()`](https://j-andrews7.github.io/VizModules/reference/toggle_input_cell.md),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Call inside a module server:
show_input(session, c("size", "opacity"))
} # }
```
