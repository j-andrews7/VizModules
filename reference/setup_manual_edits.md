# Set up persistent manual plot layout edits across re-renders

VizModules plots are fully rebuilt on every input change, which would
normally discard any layout tweaks a user made by hand: dragging the
legend, moving or editing annotations, repositioning the (draggable)
axis titles, or sliding a continuous-colour legend (colorbar).
`setup_manual_edits()` together with its companion
[`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/finalize_manual_edits.md)
add this persistence to a plotting module with two short lines of
wiring, so manually repositioned elements survive subsequent rebuilds.

## Usage

``` r
setup_manual_edits(input, session, plot_source)
```

## Arguments

- input:

  The module's `input` object.

- session:

  The module's `session` object.

- plot_source:

  Character scalar. A unique plotly event source id for this module
  instance, typically `session$ns("<plot-type>")` (e.g.
  `session$ns("scatter")`). It scopes the captured `plotly_relayout`
  events to this plot and **must match** the `plot_source` later passed
  to
  [`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/finalize_manual_edits.md).

## Value

A list (the "edit store") to hand to
[`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/finalize_manual_edits.md),
with components:

- `edits`:

  A
  [`shiny::reactiveValues()`](https://rdrr.io/pkg/shiny/man/reactiveValues.html)
  holding the captured `legend`, `annotations`, and `colorbar` edits.

- `rendered_fig`:

  A
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
  holding the most recently rendered figure, used to map relayout
  annotation indices to stable, rebuild-proof keys.

## Details

Call `setup_manual_edits()` **once**, near the top of your module's
[`shiny::moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html)
body, so the observers it registers belong to the module's reactive
domain. It creates a reactive store and registers the observers that
capture `plotly_relayout` events (legend, annotation, and axis-title
drags) plus the JavaScript-forwarded colorbar drag. Then, inside your
[`plotly::renderPlotly()`](https://rdrr.io/pkg/plotly/man/plotly-shiny.html),
pass the freshly built figure through
[`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/finalize_manual_edits.md)
before returning it.

## Module wiring (three steps)

    myPlotServer <- function(id, data) {
        moduleServer(id, function(input, output, session) {
            # 1. Unique event source + edit store (once, near the top).
            plot_source <- session$ns("myplot")
            edit_store <- setup_manual_edits(input, session, plot_source)

            output$myPlot <- renderPlotly({
                # 2. Create your plotly plot
                fig <- build_my_plotly_figure(data(), input)
                # 3. Finalize on the rebuilt figure, then return it.
                finalize_manual_edits(fig, plot_source, edit_store, session)
            })
        })
    }

## See also

[`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/reference/finalize_manual_edits.md)
for the render-step companion.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Call once inside a module server's moduleServer() body:
plot_source <- session$ns("myplot")
edit_store <- setup_manual_edits(input, session, plot_source)
} # }
```
