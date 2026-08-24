# `defaults`, `hide.inputs`, `hide.tabs`

## Static defaults

Pass the **same named list** to `*InputsUI()` and `*Server()`. Keys are input IDs (see
`module-inventory.md`); values are what the control initialises to and what Reset
restores.

```r
plotthis_BoxPlotInputsUI("p", iris, defaults = list(x.data = "Species", y.data = "Sepal.Length", pt.size = 0))
plotthis_BoxPlotServer("p", data = reactive(iris), defaults = list(x.data = "Species", y.data = "Sepal.Length", pt.size = 0))
```

`get_default(defaults, key, fallback, validator)` resolves each entry. A value that
fails the validator — or a key that does not exist — **falls back silently**. A typo
never errors; it just appears to do nothing. Check the key against the inventory or the
module help page first.

`createModuleApp()` and every `*App()` forward `defaults`, `hide.inputs`, and
`hide.tabs` to both the UI and the server, so you can set them in one place:

```r
plotthis_ViolinPlotApp(
    defaults    = list(x.data = "Species", y.data = "Sepal.Length"),
    hide.inputs = "group.by",
    hide.tabs   = "Plotly"
)
```

## Reactive defaults — the parent-to-child channel

Any single entry may be a `reactive()` or `reactiveVal()`, so the control follows app
state:

```r
server <- function(input, output, session) {
    plot_defaults <- list(x.by = "wt", y.by = "mpg", color.by = reactive(input$colour_col))

    # The UI must be built inside renderUI() so it can reach the reactive.
    # The seed is taken with isolate(), so the controls do not re-render on every change.
    output$controls <- renderUI({
        dittoViz_scatterPlotInputsUI("p", mtcars, defaults = plot_defaults)
    })

    dittoViz_scatterPlotServer("p", data = reactive(mtcars), defaults = plot_defaults)
}
```

Guarantees: the parameter tracks the reactive; the control stays populated **and
user-editable**; the plot renders **once** per change.

Semantics:

- An external change wins over a value the user typed.
- Reset restores the reactive's *current* value, not its startup value.
- Only `reactive()` and `reactiveVal()` are recognised. A plain function is treated as a literal value.
- Not supported for `dittoViz_scatterPlot`'s compound `custom.models` input.

**Do not** drive a module parameter with `updateSelectInput(session, "p-color.by", ...)`
from the parent. That is an asynchronous round-trip to the browser, so the plot renders
twice per change — once with the stale value, once when the client echoes the new one.
Reactive defaults exist precisely to avoid that.

**The key must be one the module actually reads.** `get_default()` falls back silently,
so a `defaults` entry for an unexposed key does nothing at all — no error, no warning.

> Known trap: `main` (plot title) is **not** exposed by any module. Every module server
> passes `main = NULL` and none reads `input$main`, and no module UI builds a title
> control. The `quick-start`, `defaults-and-hiding`, and `custom-modules` vignettes all
> use `defaults = list(main = reactive(...))` as their reactive-defaults example anyway;
> that example is a no-op. Drive a title through the plotly figure instead.

## Hiding

`hide.inputs` and `hide.tabs` go on the **server**, not the UI. Hidden controls are
still initialised and still feed the plot — hiding is cosmetic, never disabling.

```r
plotthis_ViolinPlotServer("v", data = reactive(example_rnaseq),
    defaults    = list(group.by = "condition"),
    hide.inputs = "group.by",
    hide.tabs   = c("Plotly", "Lines"))
```

Hidden inputs reflow (no empty gap) because `organize_inputs()` lays the controls out in
a flexbox grid.

A hidden control whose default is a `reactive()` still drives the plot — the value
resolves server-side rather than being read back from the invisible input. That is the
cleanest way to lock a parameter to app state entirely.

## Hiding at runtime

Inside a wrapper module, use the exported `hide_input(session, ids)` /
`show_input(session, ids)` rather than `shinyjs::hide()`/`show()`. The VizModules
helpers target the wrapping grid cell, so the layout reflows; `shinyjs` targets the
input element itself and leaves a hole.
