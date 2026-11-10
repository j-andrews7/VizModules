# Create a select input that scales to very large choice sets

A drop-in replacement for
[`shiny::selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html)
built on
[`shinyWidgets::virtualSelectInput()`](https://dreamrs.github.io/shinyWidgets/reference/virtualSelectInput.html).
The underlying `virtual-select` library renders only the visible slice
of the choice list, so a column with tens of thousands of unique values
stays responsive and readable instead of producing an unusable wall of
options.

## Usage

``` r
viz_select_input(
  inputId,
  label,
  choices,
  selected = NULL,
  multiple = FALSE,
  search = NULL,
  width = "100%",
  ...
)
```

## Arguments

- inputId:

  The `input` slot that will be used to access the value.

- label:

  Display label for the control, or `NULL` for no label.

- choices:

  A vector or named list of values to select from, in the same form
  accepted by
  [`shiny::selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html).

- selected:

  The initially selected value(s). Defaults to the first choice for
  single selects and nothing for multiple selects.

- multiple:

  Logical, whether multiple values can be selected.

- search:

  Logical, whether to show a search box. Defaults to `NULL`, which
  enables the search box once there are more than 10 choices.

- width:

  The width of the input, e.g. `"100%"` or `"400px"`.

- ...:

  Further arguments passed to
  [`shinyWidgets::virtualSelectInput()`](https://dreamrs.github.io/shinyWidgets/reference/virtualSelectInput.html),
  including any raw `virtual-select` property such as `optionsCount` or
  `zIndex`.

## Value

A `shiny.tag` object to be included in a UI definition.

## Details

Defaults are chosen so this behaves like
[`shiny::selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html):
when `selected` is not supplied and `multiple = FALSE`, the first choice
is selected. An empty-string choice (the "no selection" convention used
throughout this package) is relabelled `"(none)"` so it is visible in
the dropdown, while its value remains `""`.

## See also

[`update_viz_select()`](https://j-andrews7.github.io/VizModules/reference/update_viz_select.md),
[`shinyWidgets::virtualSelectInput()`](https://dreamrs.github.io/shinyWidgets/reference/virtualSelectInput.html)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # interactive()
library(VizModules)
viz_select_input("gene", "Gene", choices = c("", paste0("GENE", 1:1000)))
}
```
