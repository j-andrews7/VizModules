# Restore a group color picker to its default mapping

Used by module Reset buttons. When `defaults` supplies a mapping for
`inputId` the picker is set back to it; otherwise the widget resets
itself to the stock palette it was built with.

## Usage

``` r
reset_group_colors(session, inputId, defaults, groups, default_palette = NULL)
```

## Arguments

- session:

  The Shiny `session` object from inside
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).

- inputId:

  Character string — the picker's id, without namespacing.

- defaults:

  A named list of default values, or `NULL`.

- groups:

  A character vector of the group levels currently in play.

- default_palette:

  A character vector of fallback colors.

## Value

Invisibly `NULL`; called for its side effect.

## See also

[`default_group_colors()`](https://j-andrews7.github.io/VizModules/reference/default_group_colors.md),
[`updateMultiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/updateMultiColorPicker.md),
[`setup_group_colors()`](https://j-andrews7.github.io/VizModules/reference/setup_group_colors.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Inside a module's observeEvent(input$reset, ...):
reset_group_colors(session, "palette.colours", defaults, palette_groups(), default_palette_values)
} # }
```
