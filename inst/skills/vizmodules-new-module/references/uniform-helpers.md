# Uniform input helpers

Before writing any control, check whether a helper already covers it. Using them means
shared inputs behave identically in every module and future changes propagate
automatically. Each takes `ns` and a `defaults` list.

| UI helper | Provides | Reset counterpart |
|---|---|---|
| `uniform_axes_inputs_ui(ns, defaults, include.rotate = FALSE, include.flip = FALSE)` | Font, axis border, gridline, tick, facet styling | `reset_axes_inputs(session, defaults)` |
| `uniform_legend_inputs_ui(ns, defaults)` | Legend visibility, font family and colour, title and entry label font sizes (apply with `apply_legend_inputs(fig, input, isolate_fn)`) | `reset_legend_inputs(session, defaults)` |
| `uniform_lines_inputs_ui(ns, defaults, include.fit.lines = FALSE)` | Horizontal, vertical, diagonal reference lines | `reset_lines_inputs(session, include.fit.lines, defaults)` |
| `uniform_plotly_inputs_ui(ns, defaults)` | Download buttons, margins, subplot spacing, draw-shape styling | `reset_plotly_inputs(session, defaults)` |
| `uniform_annotation_inputs_ui(ns, defaults, choices, annotate.note)` | Highlighting and labelling individual data points | `reset_annotation_inputs(session, defaults, choices)` |
| `uniform_stats_inputs_ui(ns, defaults)` | Pairwise statistical testing and brackets | `reset_stats_inputs(session, defaults, pair_strings)` |
| `uniform_subplot_spacing_inputs_ui(ns, defaults)` | Facet subplot spacing (goes on the Facet tab) | covered by `reset_plotly_inputs()` |

Call every reset counterpart you used from the module's `observeEvent(input$reset, ...)`
block. `subplot_spacing_defaults(defaults)` resolves the spacing both the control and its
reset start from. `reset_stats_inputs()` takes the pairs currently on offer, reselecting those
`default_stat_pairs(defaults, pairs)` names.

## Small helpers every module server needs

| Helper | For |
|---|---|
| `require_data_frame(data)` | First line of the server: `NULL` becomes a silent skip, anything else is coerced to a data frame |
| `nz_value(x)` | "Is this input a non-empty string?" Safe for an input that has not reported yet (`NULL`) |
| `blank_to_null(x)` | `""`, `NA`, `NULL` and multi-value inputs become `NULL` before reaching a plotting/stats function |
| `na_to_null(x)` | Same, for an empty `numericInput()` (`NA`) or `textInput()` (`""`) |
| `facet_check(data)` | Columns worth offering in a facet/split selector |
| `toggle_facet_title_inputs(session, faceted, extra, hidden)` | Shows the `facet.title.*` inputs and hides the main-title inputs (`main_title_input_ids`) while faceted; `hidden` is the app's `hide.inputs`, never re-shown |
| `default_group_colors(defaults, key)` | The validated mapping to seed a `multiColorPicker()` with inside `renderUI()` |
| `reset_group_colors(session, key, defaults, groups, default_palette)` | Restores a group colour picker on Reset |
| `flatten_palette_options(default_palettes()$choices)` | Flat palette-name lookup |
| `reset_manual_edits(store)` | Discards dragged legends/annotations/titles on Reset |
| `with_stable_seed(expr)` | Builds a plot under a fixed seed, so jitter layers do not move on every rebuild |
| `as_plotted(df, cols, adjustment, adj.fxn)`, `adjusted_values()`, `adjustment_fn()` | The values the plot draws, for anything drawn over it; `adjustment_fn()` is what to pass dittoViz as `*.adj.fxn` |

## Server-side stores

These exist because a value the module derives and pushes back into its own control
would otherwise cost an extra render. Use them instead of reading the raw input.

| Helper | For | Read in the plot as |
|---|---|---|
| `setup_reactive_defaults(defaults, input, session)` | Reactive `defaults` entries. First statement of the server. | via `isolate_fn` |
| `setup_auto_update_logic(input, params)` | Returns `isolate_fn`. First line of the generate reactive. | — |
| `setup_group_colors(input, key, groups, default_palette, defaults, params)` | A `renderUI()`-rebuilt colour picker | `isolate_fn(palette_store())` |
| `setup_axis_range(input, session, min_key, max_key, headroom, params)` | Axis limits the module computes | `isolate_fn(y_range_store())` |
| `setup_manual_edits(input, session, plot_source)` | Capture dragged legend/annotations/titles | — |
| `finalize_manual_edits(fig, plot_source, store, session)` | Restore them; last call in `renderPlotly()` | — |

`setup_reactive_defaults()` returns `NULL` when no entry is reactive, in which case
`isolate_fn` is the plain `isolate()` it has always been — so wiring it up costs nothing
for static-defaults modules.

`isolate_fn` recognises direct `input$<key>` reads and resolves them from the store
instead. That only works for the literal form:

```r
size <- isolate_fn(input$size)             # good
size <- as.numeric(isolate_fn(input$size)) # good -- convert outside
size <- isolate_fn(as.numeric(input$size)) # BROKEN -- silently loses reactive defaults
```

Your `*InputsUI()` and reset observer need no special handling: both go through
`get_default()`, which resolves reactive entries itself, so Reset restores the
reactive's current value.

### Axis limits with significance brackets

If the module draws brackets, pass `headroom` to `setup_axis_range()` so the limits
clear them:

```r
y_range_store <- setup_axis_range(
    input, session, params = params,
    headroom = function() {
        if (!isTRUE(input$stats.enabled)) return(NULL)
        stat_bracket_headroom(
            df = data(), x = input$x.data, y = input$y.data,
            group.by = blank_to_null(input$group.by),
            facet.by = blank_to_null(input$facet.by),
            per.facet = isTRUE(input$stat.per.facet),
            input = input
        )
    }
)
```

The store only ever raises the maximum, so a larger limit the user chose is left alone.
Pass the resolved limits on to `apply_stat_annotations()` as `y.min`/`y.max` — it has the
last word on the drawn range, and knowing what you asked for is what stops it shrinking
the axis onto the brackets.

## Other exported building blocks worth knowing

- `organize_inputs(tag.list, id, title, tack, columns, rows)` — the flexbox tab grid every module's UI returns.
- `module_tack_ui(ns, defaults)` — the Auto Update / Update / Reset / Source Download block appended to the controls.
- `viz_select_input()` / `update_viz_select()` — virtualised searchable dropdowns. Always these, never `selectInput()`.
- `get_default(defaults, key, fallback, validator)` — every default read.
- `resolve_palette(groups, selected_colors, default_palette, manual_colors)`, `default_palettes()`.
- `add_reference_lines()`, `add_plot_config()`, `apply_render_margins()`, `apply_title_layout()`, `apply_legend_styling()`, `apply_legend_inputs()`, `add_size_legend()` (the circle size legend plotly drops when marker size encodes a column), `apply_plotly_newshape()`, `axis_titles_as_annotations()`, `create_axis_styles()`, `create_ggplot_axis_style()`, `apply_subplot_axis_styling()`, `apply_facet_subplot_spacing()`, `apply_axis_title_to_annotations()`.
- `collect_source_data()` / `create_source_download_handler()` — the Source Download button's backing.
- `hide_input()` / `show_input()` — reflow-aware show/hide.
- `empty_plot()` — placeholder when there is nothing to draw.

## Annotating individual points

Modules that draw individual points can adopt `uniform_annotation_inputs_ui()` so users
can highlight and label points by the values of a chosen column. The server side needs
that column carried in the plot's hover text (that is where values are read back from),
then `apply_highlight_styling()` to restyle matching markers and
`create_highlight_annotations()` / `create_selected_annotations()` to build the labels.

Set `require.markers = TRUE` when other scatter traces are drawn from the same data (box
or violin outlines, say) so only point markers match. **Append** the resulting
annotations to `fig$x$layout$annotations` rather than replacing them, or facet strip
labels and statistical brackets are lost.
