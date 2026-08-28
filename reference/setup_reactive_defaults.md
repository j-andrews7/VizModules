# Resolve reactive `defaults` entries into a server-side parameter store

Plot module parameters normally travel through client-side inputs: the
value is seeded into a control by `*InputsUI()` and read back at render
time as `input$<key>`. That makes it impossible for a parent app to
drive a parameter from app state without a visible double render.
`update*Input()` is an asynchronous client round-trip, so the plot
renders once with the stale value and again when the new value arrives
from the browser.

## Usage

``` r
setup_reactive_defaults(defaults, input, session)
```

## Arguments

- defaults:

  A named list of default values, or `NULL`. Individual entries may be a
  [`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)/`reactiveVal`.

- input:

  The Shiny `input` object from inside
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).

- session:

  The Shiny `session` object from inside
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).

## Value

`NULL` when `defaults` holds no reactive entries, in which case modules
behave exactly as they did before. Otherwise a list with two functions,
`has(key)` and `get(key)`, for
[`setup_auto_update_logic()`](https://j-andrews7.github.io/VizModules/reference/setup_auto_update_logic.md)
to read.

## Details

`setup_reactive_defaults()` fixes that by giving the module a
*server-side* channel. Any `defaults` entry that is a
[`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
[`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
is mirrored into an internal store that updates in the same reactive
flush as the parent's data, so the plot renders once. The store is the
render's source of truth (see
[`setup_auto_update_logic()`](https://j-andrews7.github.io/VizModules/reference/setup_auto_update_logic.md));
the on-screen control is kept in sync separately and remains
user-editable.

Semantics:

- **Precedence.** An external change always wins, overwriting a value
  the user had typed into the control.

- **User edits.** Editing the control writes back to the store, so
  manual overrides work exactly as they do for static defaults.

- **Reset.** The module's Reset button restores the reactive's *current*
  value, not the value it held at startup, because
  [`get_default()`](https://j-andrews7.github.io/VizModules/reference/get_default.md)
  resolves the reactive when the reset observer runs.

- **Recognised forms.** Only
  [`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) and
  `reactiveVal` are treated as reactive defaults (via
  [`shiny::is.reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html)).
  A plain function is kept as a literal default value.

Control sync is cosmetic and uses a generic `sendInputMessage()`, which
covers the standard text, numeric, checkbox, select, colour and switch
inputs, plus
[`multiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/multiColorPicker.md)
when the value is a named vector of colors. A composite widget that
ignores that message will simply not re-display the new value; the plot
is still correct, because the render reads the store.

## See also

[`setup_auto_update_logic()`](https://j-andrews7.github.io/VizModules/reference/setup_auto_update_logic.md),
[`get_default()`](https://j-andrews7.github.io/VizModules/reference/get_default.md)

## Author

Jared Andrews

## Examples

``` r
if (interactive()) {
    library(shiny)

    ui <- fluidPage(
        viz_select_input("sample", "Sample", c("S1", "S2", "S3")),
        dittoViz_scatterPlotInputsUI("p", mtcars),
        dittoViz_scatterPlotOutputUI("p")
    )

    server <- function(input, output, session) {
        # The plot title follows the selected sample, but stays editable.
        dittoViz_scatterPlotServer(
            "p",
            data = reactive(mtcars),
            defaults = list(main = reactive(input$sample))
        )
    }

    shinyApp(ui, server)
}
```
