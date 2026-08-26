# Avoiding double renders

Three distinct situations, three different tools. Picking the wrong one produces a plot
that flickers or rebuilds twice per change — cheap on `iris`, painful on a real dataset.

## 1. A parent app drives a module parameter → reactive `defaults`

```r
plot_defaults <- list(x.by = "wt", color.by = reactive(input$colour_col))
output$controls <- renderUI(dittoViz_scatterPlotInputsUI("p", mtcars, defaults = plot_defaults))
dittoViz_scatterPlotServer("p", reactive(mtcars), defaults = plot_defaults)
```

Resolved server-side in the same reactive flush as the data. Renders once. The control
stays populated and user-editable. The UI must be built in `renderUI()` so it can reach
the reactive; the seed is taken with `isolate()`, so the controls do not rebuild on every
change.

Not `update*Input()` from the parent — that is an async browser round-trip and renders
twice.

## 2. A module updates one of its own ordinary inputs → `freezeReactiveValue()`

```r
if (length(pairs) > 0) {
    freezeReactiveValue(input, "stat.pairs")
    update_viz_select(session, "stat.pairs", choices = c("", pairs), selected = "")
}
```

Freezing pauses every reader of that input until the real value arrives, so the
intermediate render never happens. Keep the freeze in the same `if` branch as the update
— a frozen input that never receives a value leaves the plot suspended forever. Does not
apply to a reset observer, where a burst of updates is expected.

Never add a catch-all `tryCatch()` to `renderPlotly()`: the pause is delivered as a
silent condition, and swallowing it turns a clean pause into a blank plot.

## 3. A module updates an input that `renderUI()` rebuilds → a server-side store

Freezing does not help here. A freeze pauses only readers that run *after* it in that
flush, and at startup the plot output runs first, so the freeze lands too late. The value
the freshly built input then reports rebuilds the plot for a mapping it was already
drawing.

Give the plot a server-side value to read instead, so the client's echo is compared
against what is already in use rather than against `NULL`.

### Colour pickers — `setup_group_colors()`

```r
palette_store <- setup_group_colors(
    input, "palette.colours", palette_groups,
    default_palette_values, defaults, params
)

output$palette.selection <- renderUI({
    groups <- palette_groups()
    if (length(groups) == 0) return(NULL)
    initial_colors <- isolate(resolve_palette(
        groups, input$palette.colours, default_palette_values,
        .default_group_colors(defaults, "palette.colours")
    ))
    palette_store(initial_colors)     # seed with the same colours the picker is built from
    multiColorPicker(ns("palette.colours"), label = "Plot colors", groups = groups,
                     colors = initial_colors, compact = TRUE)
})

# In the plot reactive, read the store — not the raw input:
palette_values <- isolate_fn(palette_store())
```

Seeding inside `renderUI()` matters because a picker on a hidden tab is suspended until
that tab is opened, so the render can be deferred well past startup.

### Axis limits — `setup_axis_range()`

```r
y_range_store <- setup_axis_range(input, session, min_key = "y.min", max_key = "y.max",
                                  headroom = NULL, params = params)

observeEvent(input$y.data, {
    y_range <- .calculate_range(df = data(), data_col_y = input$y.data, ...)
    if (!is.null(y_range)) {
        y_range_store(list(min = y_range$min, max = y_range$max))
        updateNumericInput(session, "y.min", value = y_range$min)
        updateNumericInput(session, "y.max", value = y_range$max)
    }
})

# Then read isolate_fn(y_range_store()) instead of isolate_fn(input$y.min) / input$y.max.
```

Seed the store beside **every** update that sets the limits — the y-data observer and the
Reset button both.

If the plot draws significance brackets, pass `headroom` too. Brackets stack above the
data, so the limit must clear them or they draw clipped. `stat_bracket_y_max()` works out
how high they reach; the store raises the maximum to meet it and updates the control to
match. It only ever raises, so a larger limit the user chose is left alone. Pass the
resolved limits on to `apply_stat_annotations()` as `y.min`/`y.max` — it has the last word
on the drawn range, and knowing what you asked for is what stops it shrinking the axis
onto the brackets.

The same shape works for any `renderUI()`-rebuilt input: resolve the value on the server,
hold it in a `reactiveVal()`, have the plot read that.
