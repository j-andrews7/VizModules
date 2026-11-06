# Render persistent manual plot layout edits across re-renders

Render-step companion to
[`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.md).
Call this inside your module's
[`plotly::renderPlotly()`](https://rdrr.io/pkg/plotly/man/plotly-shiny.html)
on the freshly rebuilt figure, as the last step: return what it returns.

## Usage

``` r
finalize_manual_edits(
  fig,
  plot_source,
  store,
  session,
  regen_keys = character(0)
)
```

## Arguments

- fig:

  A plotly figure object, typically the result of your plotting
  pipeline. If `NULL`, it is returned unchanged.

- plot_source:

  Character scalar. The **same** plotly event source id passed to
  [`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.md);
  assigned to `fig$x$source`.

- store:

  The list returned by
  [`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.md).

- session:

  The module's `session` object, used to namespace the colorbar drag
  input.

- regen_keys:

  Character vector of annotation keys (e.g. `"axis:y"`) whose `text` is
  regenerated on every rebuild and must not be overwritten by a captured
  edit. Pass the axis side(s) carrying an active data adjustment so the
  freshly built label (e.g. `"log2(units)"`) always wins, while the
  captured position still persists. Defaults to none (all captured props
  are restored, the pre-existing behaviour).

## Value

The finalized plotly figure, ready to be returned from
[`plotly::renderPlotly()`](https://rdrr.io/pkg/plotly/man/plotly-shiny.html).
Inside a render, when only the layout changed, it instead sends the
layout and cancels the render.

## Details

It performs six jobs:

1.  tags the figure with the module's plotly event `source` so its
    `plotly_relayout` events are captured by
    [`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.md);

2.  restores any manually repositioned legend, annotations, axis titles,
    and colorbar captured so far;

3.  records the figure so future relayout events can be matched to
    stable annotation keys (surviving re-ordering on rebuild);

4.  attaches the JavaScript listener that forwards colorbar drags;

5.  has the figure re-rendered in place: `layout.transition = TRUE`
    makes the plotly widget update its graph with `Plotly.react()`
    instead of purging and recreating it, which is faster and keeps the
    user's zoom and toggled legend entries whenever `layout.uirevision`
    is unchanged (the cached modules set it per build of the plot, so
    styling changes keep the view). A small script clears the previous
    render's event listeners first, which purging used to; and

6.  sends only the layout when nothing else changed: if the figure's
    traces, config, `layout.uirevision`, and everything else but its
    layout match the figure last sent to this output, the new layout
    goes to the browser in a small message, applied with
    `Plotly.react()` over the traces already drawn, and the render is
    cancelled (`req(FALSE, cancelOutput = TRUE)`), so no code after this
    call runs. A styling change then costs kilobytes rather than the
    whole figure. Set `options(VizModules.layout.updates = FALSE)` to
    always send the whole figure.

Restored edits are applied under
[`shiny::isolate()`](https://rdrr.io/pkg/shiny/man/isolate.html) so
re-applying them never triggers an additional re-render.

## See also

[`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/setup_manual_edits.md)
for the setup-step companion.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Inside renderPlotly(), after building `fig`:
finalize_manual_edits(fig, plot_source, edit_store, session)
} # }
```
