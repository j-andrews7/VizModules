---
name: vizmodules-app
description: Build or modify a Shiny app that uses VizModules plot modules (dittoViz_scatterPlot, dittoViz_yPlot, plotthis_BoxPlot/ViolinPlot/BarPlot/AreaPlot/DensityPlot/DotPlot/Histogram/SplitBarPlot, linePlot, piePlot, radarPlot, dumbbellPlot, parallelCoordinatesPlot, ComplexHeatmap_Heatmap). Use when wiring a plot module into an app, pre-filling controls with defaults, hiding inputs or tabs, enabling the Stats tab, adding the dataFilter table or figure builder, using createModuleApp(), or letting users download plot source data. Covers the R package VizModules. Not for building a wrapper module around a base module (use vizmodules-custom-module), not for adding a module to the VizModules package source (use vizmodules-new-module), and not for repository or documentation maintenance on the package itself.
license: MIT
---

# Using VizModules in a Shiny app

## The contract

Every plot module is a trio of functions sharing one `id`:

```r
<module>InputsUI(id, data, defaults = NULL, title = NULL, columns = 2)  # controls; takes a plain data.frame
<module>OutputUI(id, resizable = TRUE)                                  # the plotly output
<module>Server(id, data, hide.inputs = NULL, hide.tabs = NULL, defaults = NULL)  # data is a reactive()
```

Every module has that exact server signature. `InputsUI` gets a **plain data frame** (it
needs column names at UI-build time); `Server` gets a **`reactive()`**. Place `InputsUI`
and `OutputUI` anywhere in the layout — they are separate on purpose.

```r
ui <- fluidPage(sidebarLayout(
    sidebarPanel(plotthis_ViolinPlotInputsUI("v", example_rnaseq,
        defaults = list(x.data = "cell_type", y.data = "log2_cpm", group.by = "condition"))),
    mainPanel(plotthis_ViolinPlotOutputUI("v"))
))
server <- function(input, output, session) {
    plotthis_ViolinPlotServer("v", data = reactive(example_rnaseq))
}
```

## Look up the keys — do not guess them

`defaults` keys are **input IDs**, and they are *not* uniform across modules: the
x/y mapping is `x.data`/`y.data` on the plotthis modules, `x.by`/`y.by` on
`dittoViz_scatterPlot`, `x.value`/`y.value` on `linePlot`/`dumbbellPlot`, and `var` on
`dittoViz_yPlot`. The colour key is `palette.colours` on most modules but `color.panel`,
`slice.colors`, or `trace.colors` on three of them.

**Read `references/module-inventory.md` before writing any `defaults` or `hide.*`
vector.** It has every module's mapping keys, tab names, colour key, and stats support in
one table. An unrecognised key is *silently ignored* — `get_default()` falls back rather
than erroring — so a typo looks like "the default didn't work".

For the long tail of inputs beyond the mapping keys, the module's own help page
(`?plotthis_ViolinPlotInputsUI`) has a **Plot parameters and defaults** section listing
every wired argument with its UI label and default.

## Three arguments do most of the work

| Argument | Where | Effect |
|---|---|---|
| `defaults` | `InputsUI` **and** `Server` | Pre-fill a control. Pass the same list to both. |
| `hide.inputs` | `Server` | Hide one control. Value still initialises and still reaches the plot. |
| `hide.tabs` | `Server` | Hide a whole tab. Same — inputs stay live. |

Hiding never disables. `defaults = list(color.by = "cyl"), hide.inputs = "color.by"` is
the idiom for "fixed to this, user cannot change it".

A `defaults` entry may be a `reactive()`/`reactiveVal()` instead of a fixed value, so a
control follows app state. That is the **only** correct parent→child channel — do not
call `update*Input()` from the parent. See `references/defaults-and-hiding.md` for the
reactive-defaults setup (the UI must be built inside `renderUI()`) and its semantics.

## Building blocks

- **`createModuleApp(inputs_ui_fn, output_ui_fn, server_fn, data_list, defaults, hide.inputs, hide.tabs, show.table, title)`** — a complete app with file upload, a filterable table, and dataset switching. Every `*App()` (`plotthis_BarPlotApp()`, …) is a thin wrapper around it. Reach for this before hand-rolling an app shell.
- **`dataFilterUI(id)` / `dataFilterServer(id, data, factor.char.cols, page.length, col.visibility, hide.columns, filter.max.options)`** — a DT table whose filtered rows come back as a reactive you feed straight to one or more plot modules.
- **`figureBuilderUI(id)` / `figureBuilderServer(id, data_list, module_registry)`** — the multi-panel figure builder, embeddable like any module. `figureBuilderApp()` launches it standalone.
- **Stats tab** — `dittoViz_yPlot`, `plotthis_BoxPlot`, and `plotthis_ViolinPlot` only. Pre-fill it through `defaults` with the `stats.enabled` / `stat.*` keys; see `references/stats-tab.md`.
- **Source-data download** — `collect_source_data()` + `create_source_download_handler()`. Do not hand-roll `write.csv()`/`zip()`; see `references/source-data-export.md`.

## Rules

1. `data` reaches `*Server()` as a `reactive()`. Passing a bare data frame is an error.
2. `InputsUI` needs a real data frame at call time. If the dataset is chosen at runtime, build the controls inside `renderUI()`.
3. One `id` per module instance; reuse the same `id` across the trio. Two instances need two ids.
4. Verify any signature you are unsure of against `?<function>` rather than guessing — 151 functions are exported and the naming is not always predictable.
5. If a feature the user asked for is not exposed by a module, say so explicitly instead of inventing an argument.
