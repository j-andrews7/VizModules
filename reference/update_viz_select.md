# Update a select input created by viz_select_input

Companion to
[`viz_select_input()`](https://j-andrews7.github.io/VizModules/reference/viz_select_input.md),
wrapping
[`shinyWidgets::updateVirtualSelect()`](https://dreamrs.github.io/shinyWidgets/reference/updateVirtualSelect.html)
so the empty-string "no selection" choice is relabelled consistently
with the UI side.

## Usage

``` r
update_viz_select(session, inputId, choices = NULL, selected = NULL, ...)
```

## Arguments

- session:

  The `session` object passed to the module server function.

- inputId:

  The id of the input to update.

- choices:

  New choices for the input, or `NULL` to leave them unchanged.

- selected:

  New value(s) to select. When `NULL` and `choices` is given, the
  current value is kept if it is still valid, falling back to the first
  choice. When `NULL` and `choices` is not given, the selection is left
  unchanged.

- ...:

  Further arguments passed to
  [`shinyWidgets::updateVirtualSelect()`](https://dreamrs.github.io/shinyWidgets/reference/updateVirtualSelect.html).

## Value

No return value, called for its side effect of updating the input.

## Details

Unlike
[`shinyWidgets::updateVirtualSelect()`](https://dreamrs.github.io/shinyWidgets/reference/updateVirtualSelect.html),
supplying `choices` without a `selected` does not clear the widget: the
current value is kept when it is still one of the new choices, and the
first choice is selected otherwise. This mirrors
[`shiny::updateSelectInput()`](https://rdrr.io/pkg/shiny/man/updateSelectInput.html),
which never leaves a single select with no value.

## See also

[`viz_select_input()`](https://j-andrews7.github.io/VizModules/reference/viz_select_input.md),
[`shinyWidgets::updateVirtualSelect()`](https://dreamrs.github.io/shinyWidgets/reference/updateVirtualSelect.html)

## Author

Jared Andrews

## Examples

``` r
library(shiny)
library(VizModules)

server <- function(input, output, session) {
    observeEvent(input$reset, {
        update_viz_select(session, "gene", choices = c("", "GENE1", "GENE2"))
    })
}
```
