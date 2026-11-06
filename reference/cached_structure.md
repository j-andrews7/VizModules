# Cache a module's plot step

Draws a module's plot (everything before
[`apply_uniform_styling()`](https://j-andrews7.github.io/VizModules/reference/apply_uniform_styling.md))
and keeps it in the session's cache, keyed on the data, the module's
other reactive values the step reads (`extra`), and the inputs the step
reads, so a styling change never redraws the plot and going back to
settings already drawn (toggling an option back, Reset) re-uses the
figure. The figure is built here
([`plotly::plotly_build()`](https://rdrr.io/pkg/plotly/man/plotly_build.html)),
so the styling step does not repeat that work.

## Usage

``` r
cached_structure(build, input, session, data, params = NULL, extra = NULL)
```

## Arguments

- build:

  A function of `isolate_fn` that draws the plot and returns a list with
  at least `fig`. See the rules above.

- input, session:

  The module's `input` and `session`.

- data:

  The module's `data` reactive.

- params:

  The reactive-defaults store from
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md),
  or `NULL`.

- extra:

  A function of no arguments returning the module's other reactive
  values `build` reads (axis-limit and colour stores, the selection,
  ...), or `NULL`.

## Value

A reactive returning `build`'s value, with `.build` added: a number
unique to each time the plot was drawn, kept with the value in the
cache. The figure's `layout.uirevision` is set from it, so a styling
change keeps the user's zoom while a different plot resets it.

## Details

The inputs in the key are exactly those the step reads through the
`isolate_fn` it is given: every `isolate_fn(input$<key>)` read is
recorded, and the set only grows. So an input the step reads is always
in the key (a stale plot otherwise), while inputs it never reads (the
styling ones, widget bookkeeping, an input frozen by an update the step
does not care about) are never in it. An entry stored before the set
grew has a key of a different shape from every later one, so it can
never be served for settings it was not drawn with.

On a miss the step is evaluated reactively, so it depends on what it
reads in the usual way; on a hit the key's reads stand in for it. Errors
are not cached. The key includes the module's namespace, so modules
sharing a session never see each other's entries. Set
`options(VizModules.cache = FALSE)` to turn caching off.

## Three rules keep the cache honest

A step that breaks one of these does not fail: it draws a stale plot.

- Read every input in the literal form `isolate_fn(input$key)`. A
  wrapped read such as `isolate_fn(as.numeric(input$size))` cannot be
  recognised, and a bare `input$size` bypasses `isolate_fn` altogether,
  so that input never reaches the key. Convert outside the call.

- Name every other reactive the step reads in `extra`: colour and
  axis-limit stores, a debounced text input, a reactive argument. The
  exception is a reactive that only derives from `data`, which the key
  already covers.

- Give it no side effects (notifications,
  [`reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
  writes), since a cache hit skips them. Return anything else the module
  needs in the list instead.

## See also

[`apply_uniform_styling()`](https://j-andrews7.github.io/VizModules/reference/apply_uniform_styling.md)
for the styling step,
[`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/finalize_manual_edits.md)
for sending a restyle as a layout-only update.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Inside moduleServer(), with `params` from setup_reactive_defaults():
draw_myPlot <- function(isolate_fn) {
    p <- my_plot_fn(data(), x = isolate_fn(input$x.by), colors = palette_store())
    list(fig = plotly::ggplotly(p))
}
base_myPlot <- cached_structure(draw_myPlot, input, session, data,
    params = params, extra = function() list(palette_store())
)
generate_myPlot <- reactive({
    isolate_fn <- setup_auto_update_logic(input, params)
    apply_uniform_styling(base_myPlot()$fig, input, isolate_fn)
})
} # }
```
