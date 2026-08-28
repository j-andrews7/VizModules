# Adding a New Module

This checklist walks through how to add a new plotting module to
**VizModules** so it matches the package’s organization, documentation,
and testing standards.

**VizModules** modules are designed to be a joy to use, which requires
some discipline to implement in a consistent way. This checklist may
seem daunting at first glance, but most of the items already have
helpers to implement them.

And a fair few are to keep you from shooting yourself in the foot and
avoiding most of the common module pitfalls.

## Quick Checklist

Pick the plot function you are wrapping and name your module
accordingly:

- For **dittoViz** functions: use `dittoViz_<PlotName>` (e.g.,
  `dittoViz_scatterPlot` for
  [`dittoViz::scatterPlot`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html))
- For **plotthis** functions: use `plotthis_<PlotName>` (e.g.,
  `plotthis_AreaPlot` for
  [`plotthis::AreaPlot`](https://pwwang.github.io/plotthis/reference/AreaPlot.html))
- For **custom/standalone** functions: use the plot name directly (e.g.,
  `linePlot`, `piePlot`)

If adding a brand-new plotting function (e.g., `piePlot`), define and
document that plot function first, then wrap it with the module.

Create the three core files: `R/<moduleName>_module_ui.R`,
`R/<moduleName>_module_server.R`, and `R/<moduleName>_module_app.R`.

Document UI, server, and app functions with roxygen (`@export`, params,
examples).

In the UI function docstring, add **three required sections**:

- `@section Plot parameters not implemented or with altered functionality:` -
  List inputs not exposed and why
- `@section Plot parameters and defaults:` - Document all exposed
  parameters with UI labels and defaults
- `@section Plot parameters implementing new functionality:` - Document
  any new or plotly-specific controls (axes, ticks, reference lines,
  etc)

Add an example app that uses the module twice to prove multi-instance
behavior.

Wire up reactive `defaults` support so parent apps can drive parameters
from app state (see [Supporting Reactive
Defaults](#supporting-reactive-defaults)).

Freeze any input you update from the server so the plot does not render
twice (see [Updating Your Own Inputs From the
Server](#updating-your-own-inputs-from-the-server)).

Wire up manual layout-edit persistence so user-dragged titles, legends,
annotations, and colorbars survive re-renders (see [Persisting Manual
Layout Edits](#persisting-manual-layout-edits)).

Cover the base plotting function with `testthat`; cover the module/app
with `testServer` where feasible.

Note any `ggplotly` conversion quirks that change or drop functionality.

**Never use `eval(str2expression())` on raw user input.** Use
[`safe_eval_filter()`](https://j-andrews7.github.io/VizModules/dev/reference/safe_eval_filter.md),
[`validate_expression()`](https://j-andrews7.github.io/VizModules/dev/reference/validate_expression.md),
or
[`safe_resolve_adj_fxn()`](https://j-andrews7.github.io/VizModules/dev/reference/safe_resolve_adj_fxn.md)
instead (see [Sanitizing User-Provided
Expressions](#sanitizing-user-provided-expressions) below).

## Naming & Organization

File names follow the module naming pattern:

- **dittoViz wrappers**: `dittoViz_<PlotName>_module_ui.R` (e.g.,
  `dittoViz_scatterPlot_module_ui.R`)
- **plotthis wrappers**: `plotthis_<PlotName>_module_ui.R` (e.g.,
  `plotthis_AreaPlot_module_ui.R`)
- **Custom modules**: `<plotName>_module_ui.R` (e.g.,
  `linePlot_module_ui.R`)

Function names follow the pattern: `<moduleName>InputsUI()`,
`<moduleName>OutputUI()`, `<moduleName>Server()`, `<moduleName>App()`.

- Examples:
  [`plotthis_AreaPlotInputsUI()`](https://j-andrews7.github.io/VizModules/dev/reference/plotthis_AreaPlotInputsUI.md),
  [`dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/dev/reference/dittoViz_scatterPlotServer.md),
  [`linePlotApp()`](https://j-andrews7.github.io/VizModules/dev/reference/linePlotApp.md)

Internal helpers stay in existing helper files when broadly useful;
otherwise keep them inside the module file.

## Documentation Standards

Roxygen headers include title, description, parameters, return value,
authors, and `@export`.

Examples show minimal, runnable usage with a small dataset.

**The UI function must include three documentation sections:**

### 1. `@section Plot parameters not implemented or with altered functionality:`

List all parameters from the base plot function that are **not** exposed
via UI inputs, with explanations:

``` r

#' @section Plot parameters not implemented or with altered functionality:
#' The following [plotthis::AreaPlot()] parameters are not available via UI inputs:
#' \itemize{
#'   \item \code{xlab} - X-axis label (plotly allows interactive editing)
#'   \item \code{ylab} - Y-axis label (plotly allows interactive editing)
#'   \item \code{title} - Plot title (plotly allows interactive editing)
#'   \item \code{subtitle} - Plot subtitle (not supported in plotly)
#'   \item \code{legend.position} - Legend positioning (plotly allows interactive repositioning)
#'   \item \code{split_by} - Split variable (returns a patchwork object, not supported in plotly)
#'   \item \code{palette} - Managed internally via the palette selection UI
#' }
```

### 2. `@section Plot parameters and defaults:`

Document all parameters that **are** exposed, listing their UI label and
default value:

``` r

#' @section Plot parameters and defaults:
#' The following [plotthis::AreaPlot()] parameters can be accessed via UI inputs and/or the \code{defaults} argument:
#' \itemize{
#'   \item \code{x} - X-axis variable (UI: "X values", default: 2nd categorical variable)
#'   \item \code{y} - Y-axis variable (UI: "Y values", default: 2nd numeric variable)
#'   \item \code{group_by} - Grouping variable (UI: "Group by", default: 3rd categorical variable or "")
#'   \item \code{facet_by} - Faceting variable (UI: "Facet by", default: "")
#'   \item \code{theme} - ggplot2 theme (UI: "Theme", default: "theme_this")
#'   \item \code{alpha} - Area fill transparency (UI: "Alpha", default: 1)
#' }
```

### 3. `@section Plot parameters implementing new functionality:`

Document all module-specific parameters (plotly controls, reference
lines, etc.):

``` r

#' The following parameters implementing new functionality or controlling plotly-specific features are also available:
#' \itemize{
#'   \item \code{axis.font.size} - Axis title font size (UI: "Axis font size", default: 18)
#'   \item \code{axis.showline} - Show axis border lines (UI: "Show axis lines", default: TRUE)
#'   \item \code{axis.tickfont.size} - Size of tick labels (UI: "Tick label size", default: 12)
#'   \item \code{hline.intercepts} - Y-coordinates for horizontal reference lines (UI: "Y-intercepts", default: "")
#'   \item \code{hline.colors} - Colors for horizontal lines, comma-separated (UI: "Colors", default: "#000000")
#'   \item \code{hline.linetypes} - Line types for horizontal lines, comma-separated (UI: "Line types", default: "dashed")
#'   \item \code{vline.intercepts} - X-coordinates for vertical reference lines (UI: "X-intercepts", default: "")
#'   \item \code{abline.slopes} - Slopes for diagonal reference lines (UI: "Slopes", default: "")
#' }
```

**Note:** Reference line parameters (`hline.*`, `vline.*`, `abline.*`)
accept comma-separated values to control each line individually.

## Functionality & Non-Exposed Inputs

For each plot function argument, decide: expose, set a fixed default, or
drop.

If dropped or fixed, document it inside the UI function (description +
reason).

If `ggplotly` alters or drops a feature (e.g., certain geoms,
annotations), note that limitation in the UI docs so users know what to
expect.

## Example App Requirement

Provide an app in `<plot>_module_app.R` as a thin wrapper around
\[createModuleApp()\]:

``` r

myPlotApp <- function(data_list = NULL) {
    if (is.null(data_list)) {
        data_list <- list("example" = my_default_data)
    }
    createModuleApp(
        inputs_ui_fn = myPlotInputsUI,
        output_ui_fn = myPlotOutputUI,
        server_fn    = myPlotServer,
        data_list    = data_list,
        title        = "Modular myPlots"
    )
}
```

[`createModuleApp()`](https://j-andrews7.github.io/VizModules/dev/reference/createModuleApp.md)
already handles validation, data import, data filtering, and dataset
switching — no need to duplicate that logic.

Add the module to the gallery app (`inst/apps/module-gallery/app.R`),
placing it in its own tab alongside the other modules.

## Testing Requirements

`testthat`: cover the base plotting function’s core behavior and
arguments (data handling, grouping, palette handling, etc.).

`testServer`: cover the module/app where feasible.

Place tests under `tests/testthat/` with clear file names
(`test-<plot>.R`, `test-<plot>-app.R`).

Ensure tests run headless and deterministically (seed randomness where
needed).

For new plotting functions, add dedicated `testthat` coverage of the
plotting helper itself (input validation, defaults, edge cases) in
addition to the module tests.

## Implementing a New Plotting Function (e.g., `piePlot`)

Add the plotting function under `R/` with full roxygen docs,
inputs/returns, and examples.

Keep arguments consistent with existing plot functions (data first,
`...` last, palette/palcolor patterns).

Document any assumptions about input shape (e.g., pre-summarized table
for pies).

Add `testthat` coverage for the plotting function (happy paths + invalid
inputs).

Only after the plotting function is stable, build the module
UI/server/app wrappers around it.

## Supporting Reactive Defaults

An entry in `defaults` may be a
[`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) rather than
a fixed value, so a parent app can make an input follow its state
without the double render that `update*Input()` causes (see
[`vignette("defaults-and-hiding", package = "VizModules")`](https://j-andrews7.github.io/VizModules/dev/articles/defaults-and-hiding.md)).
Two lines wire this up, and they are required in every new module.

Make the first statement of your
[`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html) body
build the parameter store:

``` r

params <- setup_reactive_defaults(defaults, input, session)
```

Pass that store to
[`setup_auto_update_logic()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_auto_update_logic.md)
inside your generate reactive:

``` r

generate_myPlot <- reactive({
    isolate_fn <- setup_auto_update_logic(input, params)
    ...
    main = isolate_fn(input$main)
})
```

Easy.
[`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_reactive_defaults.md)
returns `NULL` when no entry is reactive, in which case `isolate_fn` is
the plain
[`identity()`](https://rdrr.io/r/base/identity.html)/[`isolate()`](https://rdrr.io/pkg/shiny/man/isolate.html)
it has always been. When a store is present, `isolate_fn` recognises
direct `input$<key>` reads and resolves them from the store instead, so
your existing read sites need no edits, as long as they stay in the
`isolate_fn(input$<key>)` form. A wrapped read such as
`isolate_fn(as.numeric(input$size))` cannot be recognised and will not
support a reactive default; do the conversion outside the call instead.

Your `*InputsUI()` and reset observer need no special handling: both go
through
[`get_default()`](https://j-andrews7.github.io/VizModules/dev/reference/get_default.md),
which resolves reactive entries on its own. Reset therefore restores the
reactive’s current value.

## Updating Your Own Inputs From the Server

Modules often derive a value on the server and push it back into one of
their own controls, e.g. an auto-calculated y-axis range, a regenerated
list of stat comparison pairs, a rebuilt colour picker. `update*Input()`
is an asynchronous round-trip to the browser, so the plot renders
**twice**: once immediately with the stale value, then again when the
client echoes the new one. This is annoying as hell and can be avoided
by freezing the input before you update it:

Call
[`freezeReactiveValue()`](https://rdrr.io/pkg/shiny/man/freezeReactiveValue.html)
on the input immediately before you update it:

``` r

observeEvent(input$stat.x, {
    pairs <- generate_pair_strings(data(), input$stat.x)
    if (length(pairs) > 0) {
        freezeReactiveValue(input, "stat.pairs")
        update_viz_select(session, "stat.pairs", choices = c("", pairs), selected = "")
    }
})
```

Freezing pauses everything that reads that input until the real value
arrives, so the intermediate render never happens. Three rules:

- **Freeze only when you are definitely going to update.** A frozen
  input that never receives a value leaves the plot suspended. Keep the
  freeze inside the same `if` branch as the `update*Input()` call.
- **Do not add a catch-all
  [`tryCatch()`](https://rdrr.io/r/base/conditions.html) to your
  [`renderPlotly()`](https://rdrr.io/pkg/plotly/man/plotly-shiny.html).**
  The pause is delivered as a silent condition; swallowing it turns a
  clean pause into a blank plot. Guard with
  [`req()`](https://rdrr.io/pkg/shiny/man/req.html) and explicit `if`
  branches instead.

This does not apply to the reset observer, where a burst of updates is
expected.

### Inputs Rebuilt by `renderUI()`

Freezing does **not** cover an input your module rebuilds with
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html), such as a
\[multiColorPicker()\] whose groups follow the data. A freeze pauses
only the readers that run *after* it in that flush, and at startup the
plot output runs first. The freeze lands too late to pause anything, and
the value the freshly built input reports then rebuilds the plot for a
mapping it was already drawing.

In short, this results in the plot being re-rendered one or more times
in a way that can be annoying, particularly for large data sets.

Give the plot a server-side value to read instead, so the client’s echo
is compared against what is already in use rather than against `NULL`.
For a colour picker,
[`setup_group_colors()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_group_colors.md)
does this for you — it resolves the mapping as soon as the group set is
known and holds it in a
[`reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html), which
only invalidates on a real change:

Create the store beside your group-levels reactive:

``` r

palette_store <- setup_group_colors(
    input, "palette.colours", palette_groups,
    default_palette_values, defaults, params
)
```

Seed it inside the picker’s
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html), with the
same colours the input itself is built from, so the mapping is right
even when the render was deferred (a picker on a hidden tab is suspended
until that tab is opened):

``` r

initial_colors <- isolate(resolve_palette(
    groups, input$palette.colours, default_palette_values,
    .default_group_colors(defaults, "palette.colours")
))
palette_store(initial_colors)
```

Read the store in the plot reactive, in place of the raw input:

``` r

palette_values <- isolate_fn(palette_store())   # not isolate_fn(input$palette.colours)
```

The same shape works for any
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html)-rebuilt
input: resolve the value on the server, hold it in a
[`reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html), and
have the plot read that.

### Axis Limits

Limits behave the same way, and for the same reason: the module derives
them on the server, pushes them into the `y.min`/`y.max` controls, and
the echo of that push rebuilds the plot.
[`setup_axis_range()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_axis_range.md)
is the store for them.

Create the store, then seed it beside every `update*Input()` that sets
the limits — the y-data observer and the Reset button:

``` r

y_range_store <- setup_axis_range(input, session, params = params)

observeEvent(input$y.data, {
    y_range <- .calculate_range(df = data(), data_col_y = input$y.data,
                                axis_scale_factor = .y_axis_scale_factor)
    if (!is.null(y_range)) {
        y_range_store(list(min = y_range$min, max = y_range$max))
        updateNumericInput(session, "y.min", value = y_range$min)
        updateNumericInput(session, "y.max", value = y_range$max)
    }
})
```

Read `isolate_fn(y_range_store())` in the plot reactive, in place of
`isolate_fn(input$y.min)` and `isolate_fn(input$y.max)`.

If your module draws significance brackets, pass `headroom` as well. The
brackets are stacked above the data, so the limits have to clear them or
they are drawn clipped;
[`stat_bracket_y_max()`](https://j-andrews7.github.io/VizModules/dev/reference/stat_bracket_y_max.md)
works out how high they will reach, and the store raises the maximum to
meet it and updates the control to match. It only ever raises, so a
larger limit the user chose is left alone:

``` r

y_range_store <- setup_axis_range(
    input, session, params = params,
    headroom = function() {
        if (!isTRUE(input$stats.enabled)) {
            return(NULL)
        }
        .stat_bracket_headroom(
            df = data(), x = input$x.data, y = input$y.data,
            group.by = .blank_to_null(input$group.by),
            facet.by = .blank_to_null(input$facet.by),
            per.facet = isTRUE(input$stat.per.facet),
            input = input
        )
    }
)
```

Pass the resolved limits on to
[`apply_stat_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/apply_stat_annotations.md)
too, as `y.min` and `y.max`. It has the last word on the drawn range,
and knowing what you asked for is what lets it leave a large maximum
alone rather than shrinking the axis onto the brackets.

## Persisting Manual Layout Edits

Every VizModules plot is interactively editable: users can drag the
legend, reposition or re-text annotations, drag the (draggable) axis
titles to their heart’s content.

Because each module rebuilds its figure from scratch on every input
change, those hand-made tweaks would be lost on the next re-render
unless they are captured and re-applied.

Two exported helpers handle this for you. Use them in **every** new
module so the behaviour is available from the start.

### Server

Near the top of your
[`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html)
body, create a unique plotly event source for this module instance and
the edit store:

``` r

# Unique source so each module instance captures only its own events.
plot_source <- session$ns("myplot")
edit_store <- setup_manual_edits(input, session, plot_source)
```

In your
[`renderPlotly()`](https://rdrr.io/pkg/plotly/man/plotly-shiny.html),
pass the freshly built figure through
[`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/finalize_manual_edits.md)
immediately before returning it:

``` r

output$myPlot <- renderPlotly({
    req(input$x, input$y)
    fig <- generate_myPlot()  # your function that builds the plotly figure
    finalize_manual_edits(fig, plot_source, edit_store, session)
})
```

Pretty simple.

[`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_manual_edits.md)
registers the observers that capture `plotly_relayout` events (legend,
annotation, and axis-title drags) plus the JavaScript-forwarded colorbar
drag;
[`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/finalize_manual_edits.md)
tags the figure with the event source, restores any captured edits,
records the figure for stable annotation keying, and re-attaches the
colorbar listener.

Edits are matched to annotations by a content-derived key, so they
survive even when annotations are added, removed, or reordered between
rebuilds (e.g. when statistical brackets or reference labels appear).

### Key helpers (all in `R/plot_helpers.R`)

| Function | Purpose |
|----|----|
| [`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_manual_edits.md) | Create the edit store and register the relayout/colorbar capture observers (call **once**, near the top of the server) |
| [`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/finalize_manual_edits.md) | Tag the event source, restore captured edits, record the figure, and attach the colorbar listener (call in [`renderPlotly()`](https://rdrr.io/pkg/plotly/man/plotly-shiny.html), just before returning) |

Both functions are exported, so the same two-step pattern works from a
custom module in your own package. The supporting internals
(`.capture_manual_edits()`, `.reapply_manual_edits()`,
`.add_colorbar_listener()`) are not exported and shouldn’t need to be
used directly (though you can always access them via `VizModules:::` if
really necessary.

See any module server (e.g. `dittoViz_scatterPlotServer`) for a complete
example.

## Integrating Statistical Testing (Stats Tab)

Modules for categorical-vs-numeric plots (box, violin, etc.) can include
an optional **Stats** tab that provides pairwise statistical testing
with plotly bracket annotations. If your new module supports grouped
comparisons along a categorical x-axis, follow this pattern:

### UI

Add a `"Stats"` tab to the module’s `tabsetPanel` containing
`.uniform_stats_inputs_ui(ns, defaults)`.

### Server

Create a `reactiveVal` to store the last computed stats table:
`last_stats_df <- reactiveVal(NULL)`.

When `input$stats.enabled` is TRUE in the plot rendering block, call
[`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/dev/reference/compute_pairwise_stats.md)
to run tests, then
[`create_stat_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/create_stat_annotations.md)
to build bracket shapes/annotations, then
[`apply_stat_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/apply_stat_annotations.md)
to append them to the plotly figure.

Store the result: `last_stats_df(stats_df)`.

Add an `observeEvent` to update `stat.pairs` choices when the x or
grouping column changes, using
[`generate_pair_strings()`](https://j-andrews7.github.io/VizModules/dev/reference/generate_pair_strings.md).

Call `.reset_stats_inputs(session)` in the reset observer.

### Key helpers (all in `R/stat_helper.R`)

| Function | Purpose |
|----|----|
| [`compute_pairwise_stats()`](https://j-andrews7.github.io/VizModules/dev/reference/compute_pairwise_stats.md) | Run pairwise or omnibus tests with p-value adjustment |
| [`create_stat_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/create_stat_annotations.md) | Convert stats to plotly shapes/annotations with bracket packing |
| [`apply_stat_annotations()`](https://j-andrews7.github.io/VizModules/dev/reference/apply_stat_annotations.md) | Append shapes/annotations to the plotly figure and adjust y-axes |
| [`generate_pair_strings()`](https://j-andrews7.github.io/VizModules/dev/reference/generate_pair_strings.md) | Build `"A vs B"` strings for the comparison selector |
| [`parse_pair_strings()`](https://j-andrews7.github.io/VizModules/dev/reference/parse_pair_strings.md) | Convert selected pair strings back to list of length-2 vectors |

See the `plotthis_BoxPlotServer`, `plotthis_ViolinPlotServer`, or
`dittoViz_yPlotServer` implementations for complete integration
examples.

## Gallery App

Add or update the gallery app at `inst/apps/module-gallery/app.R` to
include the new module in its own tab.

Each tab should load a small sample dataset and show the module’s inputs
and outputs together.

Verify namespacing: each module instance should have a unique `id` and
independent state.

Keep dependencies minimal (prefer built-in or generated datasets).

## Review Before Submitting

Run `devtools::document()` to update NAMESPACE and Rd files.

Run `devtools::check()` and ensure tests pass locally.

Confirm UI text/tooltips mention any missing or altered plot features.

Verify both module instances in the example app work independently
(namespacing correct).

## Style Guide

Following a consistent style makes the package easier to read, maintain,
and extend. Apply these conventions to every new module.

### Input Labels

- **Capitalize** the first word of every input label: `"Group By"`, not
  `"group by"`.
- **Be concise** — prefer short, scannable labels over long
  descriptions. Move detail into a `tipify` tooltip instead.
- **Avoid redundant words.** `"Color"` is better than
  `"Select a Color"`.
- **Match plotthis/dittoViz parameter names loosely**, so users can
  cross-reference the upstream docs. E.g., label the `group_by` input
  `"Group By"`.

### Select Inputs

Use
[`viz_select_input()`](https://j-andrews7.github.io/VizModules/dev/reference/viz_select_input.md)
rather than
[`shiny::selectInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html)
or
[`shiny::selectizeInput()`](https://rdrr.io/pkg/shiny/man/selectInput.html),
and
[`update_viz_select()`](https://j-andrews7.github.io/VizModules/dev/reference/update_viz_select.md)
in place of their `update*()` counterparts. It takes the same
`inputId`/`label`/`choices`/`selected`/`multiple` arguments, but renders
a virtualised dropdown, so an input backed by a column with tens of
thousands of distinct values stays usable. A search box appears
automatically once there are more than ten choices.

An empty-string choice still means “no selection”; it is displayed as
`(none)` so users can see and pick it.

``` r

viz_select_input(ns("group.by"), "Group By",
    choices = cat.choices,
    selected = get_default(defaults, "group.by", "", function(x) x %in% cat.choices)
)
```

### Tooltips with `tipify`

Wrap any non-obvious input in
[`shinyBS::tipify()`](https://rdrr.io/pkg/shinyBS/man/tipify.html) to
show a tooltip on hover. This keeps labels concise while still informing
the user.

Apply `tipify` when:

- The input’s purpose is not immediately clear from its label alone.
- The input accepts a specific format that users might not guess (e.g.,
  comma-separated values, index positions for categorical axes).
- The input has a non-trivial effect on the plot (e.g., stat correction
  methods, bracket inset).

Standard pattern — always use `placement = "top"` and
`options = list(container = "body")` so tooltips render correctly inside
sidebar panels:

``` r

tipify(
    textInput(ns("hline.intercepts"), "Y-intercepts",
        placeholder = "e.g. 2, -2",
        value = get_default(defaults, "hline.intercepts", "")
    ),
    paste(
        "For categorical or factor axes, enter the index (position) of the",
        "category rather than its name."
    ),
    placement = "top", options = list(container = "body")
)
```

Inputs that are self-explanatory from their label (e.g., `"Plot Title"`,
`"X-axis Variable"`) do not need a tooltip.

### Reuse Uniform Input Helpers

In time, these helpers will be further formalized and exported, but they
can be used with the `VizModules:::` prefix in the meantime.

Before writing custom inputs, check whether a uniform helper already
covers your needs:

| Helper | Provides |
|----|----|
| [`uniform_lines_inputs_ui()`](https://j-andrews7.github.io/VizModules/dev/reference/uniform_lines_inputs_ui.md) | Horizontal, vertical, and diagonal reference line controls |
| [`uniform_axes_inputs_ui()`](https://j-andrews7.github.io/VizModules/dev/reference/uniform_axes_inputs_ui.md) | Font, axis border, gridline, tick, and facet styling |
| `.uniform_stats_inputs_ui()` | Pairwise statistical testing and bracket annotation controls |
| [`uniform_plotly_inputs_ui()`](https://j-andrews7.github.io/VizModules/dev/reference/uniform_plotly_inputs_ui.md) | Download buttons, margins, subplot spacing, and draw-shape styling |
| [`uniform_legend_inputs_ui()`](https://j-andrews7.github.io/VizModules/dev/reference/uniform_legend_inputs_ui.md) | Legend title and entry label font sizes |
| [`uniform_annotation_inputs_ui()`](https://j-andrews7.github.io/VizModules/dev/reference/uniform_annotation_inputs_ui.md) | Highlighting and labelling of individual data points |

Each UI helper has a matching `reset_*_inputs()` function to call from
the module’s `observeEvent(input$reset, ...)` block.

Modules that draw individual points can adopt
[`uniform_annotation_inputs_ui()`](https://j-andrews7.github.io/VizModules/dev/reference/uniform_annotation_inputs_ui.md)
to let users highlight and label points by the values of a chosen
column. The server side needs the chosen column carried in the plot’s
hover text (that is where the values are read back from), then
`.apply_highlight_styling()` to restyle matching markers and
`.create_highlight_annotations()`/`.create_selected_annotations()` to
build the labels. Set `require.markers = TRUE` when other scatter traces
are drawn from the same data (box or violin outlines, say) so only the
point markers are matched. Append the resulting annotations to
`fig$x$layout$annotations` rather than replacing them, or facet strip
labels and statistical brackets will be lost.

Pass `ns` and a `defaults` list to each helper. Use the `include.*`
arguments to opt in to optional groups (e.g., `include.fit.lines = TRUE`
for scatter plots, `include.rotate = TRUE` for bar plots).

Using the uniform helpers ensures that shared inputs behave identically
across every module and that future changes to those helpers propagate
automatically.

### Imports: `@importFrom` Over `::`

- **Always use `@importFrom pkg fun`** in the roxygen header of any file
  that calls an external function, then call the function directly
  (`fun()`) in the body.
- **Avoid `pkg::fun()` calls** in module code.

The only exception is a one-off call in an `@examples` block or vignette
where the full qualified name aids readability.

### Additional Conventions

- Use **4-space indentation** and keep lines to **120 characters** max
  (enforced by `.lintr`).
- Avoid [`sapply()`](https://rdrr.io/r/base/lapply.html) — use
  [`vapply()`](https://rdrr.io/r/base/lapply.html) or
  [`lapply()`](https://rdrr.io/r/base/lapply.html) with explicit types
  instead.
- Do not edit `NAMESPACE` manually; always regenerate with
  `devtools::document()`.

## Sanitizing User-Provided Expressions

**Never use `eval(str2expression())` or `eval(parse())` on raw user
input.** If a Shiny app is deployed publicly, this allows arbitrary code
execution on the server (e.g., `system("rm -rf /")`). VizModules
provides three exported helper functions for safely handling user-typed
expressions. Use them whenever your module accepts free-text input that
will be evaluated or passed to a plotting function.

### `safe_eval_filter(expr_text, data)`

Use when a module **evaluates** a user-typed filter expression directly
to produce a logical vector for row subsetting. The expression is
parsed, its AST is walked to ensure only allowed operations are present
(comparisons, logical operators, column references, and literals), and
then it is evaluated in a restricted environment containing only the
data frame’s columns.

``` r

# In a module server — filtering rows by a textInput:
rows.use = safe_eval_filter(isolate_fn(input$rows.use), data())
```

Returns a logical vector (same length as `nrow(data)`), or `NULL` if the
input is empty, unparseable, or contains disallowed operations.

### `validate_expression(expr_text, col_names)`

Use when a module **passes** a user-typed expression string through to a
downstream plotting function that will evaluate it internally (e.g.,
`plotthis::BoxPlot(highlight = ...)`). The string is validated but not
executed.

``` r

# In a module server — passing a highlight expression to plotthis:
highlight <- validate_expression(isolate_fn(input$highlight), names(data()))
```

Returns the original string if safe, or `NULL`.

### `safe_resolve_adj_fxn(fn_name)`

Use when a module resolves a function name from a dropdown or text input
into an actual function reference (e.g., for `x.adj.fxn`, `y.adj.fxn`).
Only function names in the allowed list (`"log2"`, `"log"`, `"log10"`,
`"neg_log10"`, `"log1p"`, `"as.factor"`, `"abs"`, `"sqrt"`) are
accepted.

``` r

# In a module server — resolving an adjustment function:
x.adj.fxn = safe_resolve_adj_fxn(isolate_fn(input$x.adj.fxn))
```

Returns the function, or `NULL` if the name is empty or not in the
allowed list.

### What counts as “allowed”?

All three helpers share the same whitelist of safe AST nodes:

- **Comparisons:** `<`, `>`, `<=`, `>=`, `==`, `!=`
- **Logical operators:** `&`, `&&`, `|`, `||`, `!`
- **Utilities:** `%in%`, [`c()`](https://rdrr.io/r/base/c.html),
  [`is.na()`](https://rdrr.io/r/base/NA.html),
  [`is.null()`](https://rdrr.io/r/base/NULL.html)
- **Arithmetic:** `-`, `+`, `*`, `/`, `:`, `%%`
- **Grouping:** `()`
- **Column names** from the data
- **Literals:** numbers, strings, `TRUE`, `FALSE`, `NA`, `NULL`, `Inf`,
  `NaN`

Anything outside this list (including function calls like
[`system()`](https://rdrr.io/r/base/system.html),
[`file.remove()`](https://rdrr.io/r/base/files.html),
[`library()`](https://rdrr.io/r/base/library.html), etc.) is rejected
and a warning is issued.
