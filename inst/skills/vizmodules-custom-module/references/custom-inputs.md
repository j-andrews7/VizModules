# `multiColorPicker()` and `multiDynamicInput()`

Both are exported and work in any Shiny app, not just inside a module.

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
