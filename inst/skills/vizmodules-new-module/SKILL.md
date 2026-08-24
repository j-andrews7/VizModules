---
name: vizmodules-new-module
description: Add a brand-new plot module to the VizModules R package itself - wrapping a dittoViz, plotthis, or native plotting function as the standard InputsUI/OutputUI/Server/App quartet, with the required roxygen sections, reactive-defaults and manual-edit wiring, uniform input helpers, gallery registration, and tests. Use when contributing a module to VizModules, following the adding-a-new-module checklist, or when asked to implement a planned module such as dittoViz freqPlot, barPlot, ridgePlot, or scatterHexPlot. Only for modules that live in the VizModules package source under R/; a wrapper module in your own app or package is vizmodules-custom-module, and merely using an existing module is vizmodules-app.
license: MIT
---

# Adding a module to VizModules

Work from the templates in `templates/` — they encode the whole contract. Copy them,
rename, and fill in. Do **not** read an existing 900-line module server to infer the
pattern; the templates are that pattern, distilled.

## Name and files

| Wrapping | Module name | Files |
|---|---|---|
| `dittoViz::freqPlot` | `dittoViz_freqPlot` | `R/dittoViz_freqPlot_module_{ui,server,app}.R` |
| `plotthis::RidgePlot` | `plotthis_RidgePlot` | `R/plotthis_RidgePlot_module_{ui,server,app}.R` |
| a new native function | `myPlot` | `R/myPlot.R` first, then `R/myPlot_module_{ui,server,app}.R` |

Four exports per module: `<name>InputsUI()`, `<name>OutputUI()`, `<name>Server()`,
`<name>App()`. Signatures are fixed:

```r
<name>InputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
<name>OutputUI(id, resizable = TRUE)
<name>Server(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL)
<name>App(data_list = NULL, defaults = NULL, hide.inputs = NULL, hide.tabs = NULL)
```

If you are adding a brand-new plotting function, define, document, and test **that**
first. Only wrap it once it is stable.

## The six things that are easy to get wrong

1. **Three roxygen `@section` blocks on the UI function** are mandatory: parameters not implemented, parameters and defaults, parameters implementing new functionality. See `references/roxygen-sections.md`.
2. **Reactive defaults**: `params <- setup_reactive_defaults(defaults, input, session)` must be the *first* statement of the `moduleServer()` body, and `isolate_fn <- setup_auto_update_logic(input, params)` the first line of the generate reactive. Every read must stay in the literal `isolate_fn(input$key)` form — `isolate_fn(as.numeric(input$size))` cannot be recognised and silently loses reactive-default support. Convert outside the call.
3. **Manual edits**: `plot_source <- session$ns("<short>")` + `edit_store <- setup_manual_edits(...)` near the top, and `finalize_manual_edits()` as the last thing `renderPlotly()` does.
4. **Freeze before you update your own inputs**, or the plot renders twice. For `renderUI()`-rebuilt inputs use `setup_group_colors()` / `setup_axis_range()` instead — freezing does not work there.
5. **Never `eval(parse())` / `eval(str2expression())` on user input.** Use `safe_eval_filter()`, `validate_expression()`, or `safe_resolve_adj_fxn()`. A publicly deployed app otherwise executes arbitrary code.
6. **Reuse the uniform input helpers** rather than writing your own Axes/Legend/Lines/Plotly controls. See `references/uniform-helpers.md`.

## Style

- `viz_select_input()` / `update_viz_select()`, never `selectInput()` / `updateSelectInput()`. It renders a virtualised dropdown, so a column with tens of thousands of levels stays usable. Empty string means "no selection" and displays as `(none)`.
- Every default read goes through `get_default(defaults, key, fallback, validator)`.
- `@importFrom pkg fun` in the roxygen header, then bare `fun()` in the body. Avoid `pkg::fun()` except in `@examples` and vignettes.
- Wrap any non-obvious input in `shinyBS::tipify(..., placement = "top", options = list(container = "body"))`. Self-explanatory labels ("Plot Title") need none. `get_documentation()` pulls the upstream package's parameter text for tooltips.
- Capitalise the first word of every input label; keep labels short and put detail in the tooltip.
- 4-space indent, 120-character lines (enforced by `.lintr`). Use `vapply()`/`lapply()`, never `sapply()`.
- Never edit `NAMESPACE` by hand — regenerate with `devtools::document()`.

## Finishing

- Register the module in `inst/apps/module-gallery/app.R` (its own tab, small sample dataset).
- Add `tests/testthat/test-<plot>.R`; cover a new plotting function directly, and the module with `testServer` where feasible.
- Add the exports to `_pkgdown.yml` and an entry to `NEWS.md`.
- Run `devtools::document()`, then `devtools::test()` and `devtools::check()`.
- Prove multi-instance behaviour: two instances with different ids must be independent.

`references/checklist.md` is the full tick-list if you want to audit at the end.
