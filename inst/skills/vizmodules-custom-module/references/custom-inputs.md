# `multiColorPicker()`, `multiDynamicInput()` and `level_order_input()`

All three are exported and work in any Shiny app, not just inside a module.

## `multiColorPicker()`

A compact per-group colour picker with a palette dropdown.

```r
multiColorPicker(inputId, label = NULL, groups, palette_options = NULL,
                 selected_palette = NULL, colors = NULL, width = NULL,
                 show_text = TRUE, compact = FALSE, ...)
```

The value is a **named character vector**, one entry per group:

```r
input$colors
#> c(Engineering = "#E69F00", Finance = "#56B4E9", HR = "#009E73")
```

```r
updateMultiColorPicker(session, inputId, colors = NULL, ...)   # named vector: only named groups change
```

`default_palettes()` supplies the standard `palette_options` list;
`resolve_palette(groups, selected_colors, default_palette, manual_colors)` layers a
user's picks over supplied colours over the stock palette.

The widget deliberately reports its value only on blur or when the pointer leaves the
swatch, rather than on every drag inside the browser's colour dialog — otherwise a single
colour choice would fire dozens of re-renders. Typing in a hex field is coalesced until
the user pauses. One-shot actions (palette swatches, Apply, Reset, switching group, Enter)
report immediately.

Because the picker is normally built in `renderUI()`, pair it with `setup_group_colors()`
rather than `freezeReactiveValue()` — see `reactive-and-rerender.md`.

## `multiDynamicInput()`

A repeating row of inputs the user can add to and remove from.

```r
multiDynamicInput(inputId, label = NULL, row_spec, elements = NULL,
                  max_per_row = 4, add_label = "+ Add", width = NULL, panel = TRUE)
```

Each `row_spec` field is a named list with:

- `type` — one of `"select"`, `"text"`, `"numeric"`, `"slider"`, `"checkbox"`, `"colour"`/`"color"`
- `fn` — alternatively any input constructor (e.g. `shiny::dateInput`), for types without an alias
- `args` — arguments for the constructor, minus `inputId` (auto-generated per row)

```r
row_spec = list(
    model_type = list(type = "select", args = list(choices = c("lm", "glm"))),
    formula    = list(type = "text",   args = list(placeholder = "y ~ x"))
)
```

A `"select"` field with `multiple = TRUE` in its `args` reports a character vector of its
items in the order they were picked (the scatter module's Trajectories list relies on this);
pre-fill it with a character vector in the order wanted.

`elements` pre-fills rows on startup. The value is a named list of rows, keyed by the
lowercased label plus an index:

```r
input$models
#> list(models1 = list(model_type = "lm",  formula = "revenue ~ units"),
#>      models2 = list(model_type = "glm", formula = "revenue ~ poly(units, 2)"))
```

```r
updateMultiDynamicInput(session, inputId, elements = NULL, clear = FALSE)
```

A field may carry a `backend = "<name>"` tag, which hides it unless that model type is
selected. You rarely write those by hand — `build_model_row_spec()` assembles them from
the registered model backends.

## `level_order_input()`

A drag-and-drop list of a categorical column's levels (a `shinyjqui::orderInput()`) that
sets the order they are plotted in — the **X Order** / **Group Order** control of the
BarPlot, BoxPlot, yPlot and freqPlot modules. It comes with three server-side helpers:

```r
level_order_input(inputId, label = "X Order", items = NULL, tooltip = NULL, width = "100%")
level_order_choices(data, column, order = NULL, max.levels = 20)   # items, in drawing order
setup_level_order(input, session, data, column, defaults = NULL,
                  inputId = "x.order", max.levels = 20)            # returns a reactiveVal
apply_level_order(data, column, order)                              # re-levels the column
```

```r
# UI
level_order_input(ns("x.order"), "X Order",
    items = level_order_choices(data, x.default, get_default(defaults, "x.order", NULL, is.character)))

# Server
x_order <- setup_level_order(input, session, data, reactive(input$x.data), defaults)
generate_plot <- reactive({
    df <- apply_level_order(data(), isolate_fn(input$x.data), isolate_fn(x_order()))
    # hand df to the plot, the stats AND the brackets
})
```

- **Read the store, not `input$x.order`.** `setup_level_order()` refills the control when
  the column or data changes, restores `defaults$x.order` on `input$reset` (and follows it
  if it is a `reactive()`), and changes the store only when the order to draw does — so
  the control reporting its initial value, or echoing an update, costs no extra render.
  The store holds `NULL` for the default order, which `apply_level_order()` treats as a
  no-op.
- **Order the frame, not the plot.** `apply_level_order()` sets factor levels, which
  plotthis, dittoViz, `compute_pairwise_stats()`, `create_stat_annotations()` and
  `stat_bracket_headroom()` all read. Give every one of them the same re-levelled frame,
  or the brackets land over the wrong categories.
- A column the control cannot order — numeric, or with more than `max.levels` levels —
  empties it, and an empty control hides its `organize_inputs()` grid cell.
- It takes one `organize_inputs()` cell at full width (a tagList would be split).
- Do not pass `orderInput()` a `placeholder`: shinyjqui builds its CSS selector from the
  raw id, which a module's dotted, namespaced id breaks.
- A wrapped base module that already has the control (BoxPlot, BarPlot, yPlot, freqPlot)
  needs nothing from you; set `x.order` through `defaults`.

## Styling, if you write an input of your own

Both widgets ship a stylesheet from `inst/src/` through an `htmlDependency()`, and **that
stylesheet is injected into the host app's document**. There is no shadow DOM and no
automatic scoping, so a rule written for your widget applies to the whole page. Every plot
module renders a `multiColorPicker`, so these sheets arrive in any app that uses any
module — which is how one unscoped selector came to break stock `selectInput()` dropdowns
in apps that never touched the picker (#355).

Anchor every selector on a class you invented:

```css
/* WRONG — .selectize-dropdown, .option and .optgroup-header are selectize's own,
   so this restyles every dropdown on the page, DT's column filters included. */
.selectize-dropdown .selectize-dropdown-content { display: flex; flex-direction: column; }

/* RIGHT */
.mc-palette-dropdown .selectize-dropdown-content { display: flex; flex-direction: column; }
```

The wrong version reads like "the content inside my dropdown", which is the trap. Judge by
the **leftmost** class: if you did not invent it, the rule is not scoped.

A dropdown parented to `<body>` (to dodge a clipping ancestor) cannot be reached by a
`.my-widget .thing` selector — which is exactly why those rules were unscoped in the first
place. Give it a marker of its own; `multiColorPicker` passes
`dropdownClass: "selectize-dropdown mc-palette-dropdown"` to selectize, restating
selectize's class because the option replaces the default wholesale.

Also worth copying from these two:

- Inspect the rendered DOM and confirm each selector matches. One picker rule targeted
  `.option`, but its custom `render.option` emits `.mc-palette-option` — so it did nothing
  for the picker and everything to everyone else.
- Keep layout out of inline `style=`; it can only be overridden with `!important`. Pass
  per-instance values as CSS custom properties.
- Do not depend on the parent's padding (no Bootstrap negative-margin rows) — use `gap`.
- `min-width: 0` on flex children, and let every row wrap: these land in sidebars of any
  width.

`tests/testthat/test-ui_utils.R` fails on any selector in any bundled or inline stylesheet
that is not anchored to a package-owned prefix.
