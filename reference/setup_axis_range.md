# Track the axis limits a plot should draw with

Modules derive an axis range on the server and push it into their own
`y.min`/`y.max` controls with
[`updateNumericInput()`](https://rdrr.io/pkg/shiny/man/updateNumericInput.html),
which is a client round-trip: the plot renders once with the stale
limits and again when the browser echoes the new ones.
`setup_axis_range()` gives the plot a server-side value to read instead,
held in a
[`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
that only invalidates on a real change, so the echo costs nothing while
a limit the user types comes straight through.

## Usage

``` r
setup_axis_range(
  input,
  session,
  min_key = "y.min",
  max_key = "y.max",
  headroom = NULL,
  params = NULL
)
```

## Arguments

- input:

  The Shiny `input` object from inside
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).

- session:

  The Shiny `session` object from inside
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).

- min_key, max_key:

  Character strings — the limit controls' input ids, without
  namespacing.

- headroom:

  Optional function of no arguments returning the smallest acceptable
  maximum, or `NULL` for none. Returning `NULL` or a non-finite value
  leaves the requested maximum alone.

- params:

  Optional reactive-defaults store from
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md),
  or `NULL`. A limit backed by the store follows it rather than the
  client input.

## Value

A
[`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
holding `list(min = , max = )`. Call it with no arguments to read, and
with a value to seed.

## Details

Pass `headroom` when something is drawn above the data that the limits
have to clear — significance brackets, for instance, via
[`stat_bracket_y_max()`](https://j-andrews7.github.io/VizModules/reference/stat_bracket_y_max.md).
It is evaluated reactively, and the maximum is raised to meet it
whenever the requested one falls short; the control is updated to match,
so the number on screen is the limit actually in use rather than one the
plot has quietly overridden. The maximum is only ever raised this way,
so a larger limit the user chose is left alone.

Seed the store alongside any `update*Input()` call that sets the limits
(the y-data observer, the Reset button) so the echo arrives as a no-op:

    y_range_store(list(min = y_range$min, max = y_range$max))
    updateNumericInput(session, "y.min", value = y_range$min)
    updateNumericInput(session, "y.max", value = y_range$max)

## See also

[`stat_bracket_y_max()`](https://j-andrews7.github.io/VizModules/reference/stat_bracket_y_max.md),
[`setup_group_colors()`](https://j-andrews7.github.io/VizModules/reference/setup_group_colors.md)

## Author

Jared Andrews

## Examples

``` r
if (interactive()) {
    library(shiny)

    server <- function(input, output, session) {
        y_range_store <- setup_axis_range(
            input, session,
            headroom = function() {
                if (!isTRUE(input$stats.enabled)) {
                    return(NULL)
                }
                stat_bracket_y_max(iris, x = "Species", y = "Sepal.Length")
            }
        )

        output$plot <- renderPlot({
            lims <- y_range_store()
            plot(iris$Sepal.Length, ylim = c(lims$min, lims$max))
        })
    }
}
```
