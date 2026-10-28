# Discard every captured manual layout edit

Used by module Reset buttons, so a dragged legend, annotation, axis
title or colorbar goes back to where the rebuilt figure puts it. The
store's fields are reactive values, so they are cleared in place;
reassigning the list returned by
[`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.md)
would only change a local copy.

## Usage

``` r
reset_manual_edits(store)
```

## Arguments

- store:

  The list returned by
  [`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.md).

## Value

Invisibly `NULL`; called for its side effect.

## See also

[`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.md),
[`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/finalize_manual_edits.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Inside a module's observeEvent(input$reset, ...):
manual_edits <- setup_manual_edits(input, session, plot_source)
reset_manual_edits(manual_edits)
} # }
```
