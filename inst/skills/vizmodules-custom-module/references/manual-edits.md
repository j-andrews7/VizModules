# Persisting manual layout edits

Every VizModules plot is interactively editable — users drag the legend, reposition or
re-text annotations, drag axis titles, move the continuous-colour legend (colorbar).
Because a module rebuilds its figure from scratch on every input change, those edits
would be lost on the next render unless they are captured and re-applied.

If your wrapper delegates to a base module's server, you get this for free. If you build
a `plotly` output yourself, two calls add it:

```r
customPlotServer <- function(id, data_reactive) {
    moduleServer(id, function(input, output, session) {
        # 1. A unique event source per module instance, plus the edit store. Once, near the top.
        plot_source <- session$ns("customplot")
        edit_store  <- setup_manual_edits(input, session, plot_source)

        output$plot <- renderPlotly({
            # 2. Build your figure however you like.
            fig <- build_my_plotly_figure(data_reactive(), input)
            # 3. Restore captured edits and re-arm capture, then return.
            finalize_manual_edits(fig, plot_source, edit_store, session)
        })
    })
}
```

```r
setup_manual_edits(input, session, plot_source)
finalize_manual_edits(fig, plot_source, store, session, regen_keys = character(0))
```

`setup_manual_edits()` registers the observers that capture `plotly_relayout` events
(legend, annotation, and axis-title drags) plus the JavaScript-forwarded colorbar drag.
`finalize_manual_edits()` tags the figure with the event source, restores captured edits,
records the figure for stable annotation keying, and re-attaches the colorbar listener.

The event source **must** be unique per instance — `session$ns("...")` guarantees that.
Two instances sharing a source will capture each other's edits.

Edits are matched to annotations by a content-derived key, so they survive annotations
being added, removed, or reordered between rebuilds — which happens whenever statistical
brackets or reference labels appear.

Both helpers are exported, so the pattern works from a custom module in your own package.
The internals (`.capture_manual_edits()`, `.reapply_manual_edits()`,
`.add_colorbar_listener()`) are not exported and should not be needed directly.

See any module server (e.g. `dittoViz_scatterPlotServer`) for a complete example.
