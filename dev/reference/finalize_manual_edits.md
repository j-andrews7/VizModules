# Render persistent manual plot layout edits across re-renders

Render-step companion to
[`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_manual_edits.md).
Call this inside your module's
[`plotly::renderPlotly()`](https://rdrr.io/pkg/plotly/man/plotly-shiny.html)
on the freshly rebuilt figure, immediately before returning it.

## Usage

``` r
finalize_manual_edits(fig, plot_source, store, session)
```

## Arguments

- fig:

  A plotly figure object, typically the result of your plotting
  pipeline. If `NULL`, it is returned unchanged.

- plot_source:

  Character scalar. The **same** plotly event source id passed to
  [`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_manual_edits.md);
  assigned to `fig$x$source`.

- store:

  The list returned by
  [`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_manual_edits.md).

- session:

  The module's `session` object, used to namespace the colorbar drag
  input.

## Value

The finalized plotly figure, ready to be returned from
[`plotly::renderPlotly()`](https://rdrr.io/pkg/plotly/man/plotly-shiny.html).

## Details

It performs four jobs:

1.  tags the figure with the module's plotly event `source` so its
    `plotly_relayout` events are captured by
    [`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_manual_edits.md);

2.  restores any manually repositioned legend, annotations, axis titles,
    and colorbar captured so far;

3.  records the figure so future relayout events can be matched to
    stable annotation keys (surviving re-ordering on rebuild); and

4.  attaches the JavaScript listener that forwards colorbar drags.

Restored edits are applied under
[`shiny::isolate()`](https://rdrr.io/pkg/shiny/man/isolate.html) so
re-applying them never triggers an additional re-render.

## See also

[`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_manual_edits.md)
for the setup-step companion.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Inside renderPlotly(), after building `fig`:
fig <- finalize_manual_edits(fig, plot_source, edit_store, session)
fig
} # }
```
