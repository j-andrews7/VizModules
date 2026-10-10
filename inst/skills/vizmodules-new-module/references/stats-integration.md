# Adding a Stats tab

Only for modules plotting a **categorical x against a numeric y** with grouped
comparisons — box, violin, y-plot shapes. Everything else should skip it.

## UI

Add one entry to the `inputs` list:

```r
"Stats" = uniform_stats_inputs_ui(ns, defaults),
```

That supplies all fifteen controls: `stats.enabled` (the master toggle, note the plural),
plus `stat.test`, `stat.p.adjust`, `stat.display`, `stat.sig.threshold`, `stat.hide.ns`,
`stat.paired`, `stat.pairs`, `stat.per.facet`, `stat.bracket.style`,
`stat.bracket.inset`, `stat.step.increase`, `stat.text.bump`, `stat.line.color`,
`stat.line.width`.

## Server

1. Hold the last computed table so the download handler can reach it:

   ```r
   last_stats_df <- reactiveVal(NULL)
   ```

2. Inside the plot-building reactive, when `input$stats.enabled` is `TRUE`, run the
   three-step pipeline and store the result:

   ```r
   if (isTRUE(isolate_fn(input$stats.enabled))) {
       stats_df <- compute_pairwise_stats(
           df = data(), x = x.col, y = y.col,
           pairs = parse_pair_strings(isolate_fn(input$stat.pairs)),
           test = isolate_fn(input$stat.test),
           p.adjust.method = isolate_fn(input$stat.p.adjust),
           paired = isolate_fn(input$stat.paired),
           group.by = group.by, facet.by = facet.by,
           per.facet = isolate_fn(input$stat.per.facet),
           sig.threshold = isolate_fn(input$stat.sig.threshold)
       )
       last_stats_df(stats_df)

       stat_result <- create_stat_annotations(
           stats_df, fig, data(), x.col, y.col,
           display = isolate_fn(input$stat.display),
           hide.ns = isolate_fn(input$stat.hide.ns),
           sig.threshold = isolate_fn(input$stat.sig.threshold),
           line.color = isolate_fn(input$stat.line.color),
           line.width = isolate_fn(input$stat.line.width),
           bracket.style = isolate_fn(input$stat.bracket.style),
           group.by = group.by, facet.by = facet.by
       )

       fig <- apply_stat_annotations(fig, stat_result, y.min = y.min, y.max = y.max)
   }
   ```

3. Repopulate the comparison selector whenever the x or grouping column changes — and
   **freeze first**, or the plot renders twice:

   ```r
   observeEvent(input$x.data, {
       pairs <- generate_pair_strings(data(), input$x.data, group.by = blank_to_null(input$group.by))
       if (length(pairs) > 0) {
           freezeReactiveValue(input, "stat.pairs")
           update_viz_select(session, "stat.pairs", choices = c("", pairs), selected = "")
       }
   })
   ```

4. Call `reset_stats_inputs(session, defaults)` from the reset observer.

5. Pass the stats reactive to `collect_source_data()` so the table lands in the source
   download:

   ```r
   collect_source_data(
       plot_reactive   = generate_myPlot,
       stats_reactive  = reactive(last_stats_df()),
       inputs_reactive = AllInputs()
   )
   ```

## Axis headroom

Brackets stack above the data, so the y-limit must clear them or they draw clipped. Give
`setup_axis_range()` a `headroom` function and pass the resolved limits on to
`apply_stat_annotations()` as `y.min`/`y.max`. See `uniform-helpers.md`.

## Test and draw on the plotted values, never raw `data()`

The stats helpers use whatever frame they are given, and the brackets are placed at its
heights. If the plot transforms a column before drawing it (dittoViz's `var.adjustment` /
`var.adj.fxn`, a summary like `freqPlot`'s), give the tests, `create_stat_annotations()`, the
headroom **and** the axis-range calculation the values as drawn. Otherwise the brackets
land in another coordinate space, far off the axis (#319). Use
`as_plotted()` (or `adjust_column_values()`, which also adds the `.adj` column). Both apply the
adjustment function first and then the z-score/relative rescaling, the reverse of dittoViz,
so hand dittoViz the combined `adjustment_fn()` as its `*.adj.fxn` (and no `*.adjustment`)
or the plot and the overlays disagree. Build that frame in
one function that both the headroom and the render call (`.yplot_stat_context()` is the
worked example), so the two cannot drift apart.

- **Values along the x-axis** (a rotated plot, dittoViz with a ridge plot): brackets cannot
  go there. Test and ship the table, but skip drawing and call `note_brackets_skipped()`.
- **Free y facet scales**: pass `free.y = TRUE` to `create_stat_annotations()` so each
  panel's brackets sit on its own data, return `NULL` from the headroom, and do not pass one
  shared `min`/`max` to a dittoViz plot, whose `coord_cartesian()` would pin every panel to it.
- Write the range with `apply_stat_annotations()` after the axis styling or before it; it
  survives either way. Never queue a copy of an existing axis through `plotly::layout()`,
  which reverts later layout writes at build time.
- Test it: `expect_brackets_within_axes()` in `tests/testthat/helper-overlays.R` builds the
  figure and checks every bracket lies within its own axis.

## Helpers

All in `R/stat_helper.R`, all exported:

| Function | Purpose |
|---|---|
| `compute_pairwise_stats()` | Run pairwise or omnibus tests with p-value adjustment |
| `create_stat_annotations()` | Convert stats to plotly shapes/annotations with bracket packing |
| `apply_stat_annotations()` | Append shapes/annotations to the figure and adjust the y-axis |
| `generate_pair_strings()` | Build `"A vs B"` strings for the comparison selector |
| `parse_pair_strings()` | Convert selected pair strings back to length-2 vectors |
| `stat_bracket_y_max()` | How high the brackets will reach |

`create_stat_annotations()` expects ggplotly's 1-based categorical axis convention (the
first factor level at `x = 1`), which is what building the figure with `ggplot2` +
`ggplotly()` gives you. A figure built another way will place brackets wrongly.

`plotthis_BoxPlotServer`, `dittoViz_yPlotServer`, and `dittoViz_freqPlotServer` are the
complete worked examples.

## Known limits

Brackets cannot currently be placed when several y variables are combined with a
`split.by` facet, or for `dittoViz_yPlot`'s `"group"` and `"color"` multivar aesthetics.
Those combinations hide the tab rather than drawing something wrong.
