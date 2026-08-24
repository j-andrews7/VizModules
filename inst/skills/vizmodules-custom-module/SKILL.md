---
name: vizmodules-custom-module
description: Build a custom Shiny wrapper module on top of a VizModules plot module, or extend one from outside the package - adding your own inputs, filtering or transforming the data before it reaches the plot, driving a base module's parameters from your wrapper's state, registering a custom model-line backend with register_model_backend(), or adding multiColorPicker()/multiDynamicInput() widgets. Use whenever wrapping, extending, subclassing, or composing a VizModules module, or when a hand-rolled plotly output needs the same manual-edit persistence the built-in modules have. The wrapper lives in your own app or package; adding a module to the VizModules package source is vizmodules-new-module, and plain use of an existing module in an app is vizmodules-app.
license: MIT
---

# Wrapping and extending a VizModules module

## The namespace rule — get this right first

This is the one mistake that produces an app which *looks* fine and silently does
nothing. Shiny namespacing is the whole difficulty of wrapping a module.

```r
myModuleUI <- function(id) {
    ns <- NS(id)
    tagList(
        checkboxInput(ns("filter_setosa"), "Setosa only"),   # YOUR input: ns()
        dittoViz_scatterPlotInputsUI(id, iris)               # BASE module: bare id
    )
}

myModuleOutput <- function(id) dittoViz_scatterPlotOutputUI(id)   # bare id

myModuleServer <- function(id, data_reactive) {
    # 1. Your logic goes INSIDE moduleServer() — that is what gives you input$filter_setosa.
    filtered <- moduleServer(id, function(input, output, session) {
        reactive({
            df <- req(data_reactive())
            if (isTRUE(input$filter_setosa)) df <- df[df$Species == "setosa", ]
            df
        })
    })

    # 2. The base server goes OUTSIDE it. This is the critical line.
    dittoViz_scatterPlotServer(id, filtered)
}
```

Three rules, and they are not symmetric:

| Thing | Namespacing |
|---|---|
| Your own inputs, in your UI | `ns("name")` |
| Base `*InputsUI()` / `*OutputUI()`, in your UI | bare `id` |
| Your own logic, in your server | inside `moduleServer(id, ...)` |
| Base `*Server()`, in your server | **outside** `moduleServer()`, bare `id` |

Calling the base server *inside* `moduleServer()` double-namespaces it: it looks for
`id-id-x.by` while the UI created `id-x.by`. Nothing errors. The controls just have no
effect. If a user reports "the inputs do nothing", check this first.

## Driving a base module parameter from your wrapper

Pass a `reactive()` as that entry of `defaults`. Do **not** reach for `update*Input()` —
it is an async client round-trip, so the plot renders twice per change.

```r
colouredServer <- function(id, data_reactive) {
    colour_col <- moduleServer(id, function(input, output, session) {
        reactive(if (isTRUE(input$by_species)) "Species" else "")
    })

    dittoViz_scatterPlotServer(id, data_reactive, defaults = list(color.by = colour_col))
}
```

The colour mapping follows the checkbox, renders once, and the control stays
user-editable. Hiding a control instead (`hide.inputs`) fixes it to one value — use that
when the parameter should never move.

**The key must be an input the module actually reads.** A `defaults` entry for a key no
module exposes is a silent no-op — nothing errors, the plot just ignores it. Check the
key against `references/../module-inventory.md` or the module's own
**Plot parameters and defaults** roxygen section before relying on it.

> Known trap: `main` (plot title) is **not** exposed by any module — every server passes
> `main = NULL` and none reads `input$main`. Three vignettes (`quick-start`,
> `defaults-and-hiding`, `custom-modules`) nonetheless use
> `defaults = list(main = reactive(...))` as their worked example. That example does not
> work. To drive a title, act on the plotly figure directly (e.g. `plotlyProxy()` against
> the base module's output id, or `layout(title = ...)` in a hand-built figure).

## Updating your *own* inputs from the server

Freeze first, or the plot renders twice:

```r
observeEvent(input$stat.x, {
    pairs <- generate_pair_strings(data(), input$stat.x)
    if (length(pairs) > 0) {
        freezeReactiveValue(input, "stat.pairs")     # inside the same if branch
        update_viz_select(session, "stat.pairs", choices = c("", pairs), selected = "")
    }
})
```

- Freeze **only** when you will definitely update — a frozen input that never receives a value leaves the plot suspended.
- Never wrap `renderPlotly()` in a catch-all `tryCatch()`. The pause is a silent condition; swallowing it turns a clean pause into a blank plot. Use `req()` and explicit `if` branches.
- Freezing does **not** work for an input rebuilt by `renderUI()`. Use a server-side store instead — `setup_group_colors()` for colour pickers, `setup_axis_range()` for axis limits. See `references/reactive-and-rerender.md`.

## Other extension points

- **Manual layout edits** on a hand-rolled plotly output — two calls, `setup_manual_edits()` and `finalize_manual_edits()`. Inherited for free if you delegate to a base module. See `references/manual-edits.md`.
- **Model-line backends** — `register_model_backend(name, backend)` adds a fitting engine to the scatter module's Model Type dropdown. See `references/model-backends.md`.
- **Widgets** — `multiColorPicker()` and `multiDynamicInput()` are exported and usable in any Shiny app. See `references/custom-inputs.md`.
- **Runtime show/hide** — `hide_input(session, ids)` / `show_input(session, ids)`, not `shinyjs::hide()`; the VizModules helpers reflow the grid.
- **User-typed expressions** — `safe_eval_filter()`, `validate_expression()`, `safe_resolve_adj_fxn()`. Never `eval(parse())` on user input.

## Practices

1. Keep each wrapper to one cohesive concern; design so it could itself be wrapped.
2. Document what columns or data shape your wrapper requires.
3. Pass data in as a `reactive()`, and return one where it is useful.
4. Base module servers return their source-data reactive — capture it if your wrapper needs to expose downloads.
5. If inputs seem to have no effect, it is the namespace rule. It is almost always the namespace rule.
