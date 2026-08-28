# Track the group-to-color mapping a plot should draw with

A
[`multiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/multiColorPicker.md)
is rebuilt by
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) whenever the
group set changes, and the freshly built widget reports its value back
on a client round-trip. A plot that depends on the picker's raw
`input$<key>` therefore rebuilds when that value lands, even at startup
where the reported value is exactly what the server had already seeded
the picker with.

## Usage

``` r
setup_group_colors(
  input,
  key,
  groups,
  default_palette = NULL,
  defaults = NULL,
  params = NULL
)
```

## Arguments

- input:

  The Shiny `input` object from inside
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).

- key:

  Character string — the picker's input id, without namespacing, e.g.
  `"palette.colours"`.

- groups:

  A [`reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) yielding
  the character vector of group levels currently in play.

- default_palette:

  A character vector of fallback colors.

- defaults:

  A named list of default values, or `NULL`. A named color mapping
  stored under `key` seeds groups the user has not picked.

- params:

  Optional reactive-defaults store from
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md),
  or `NULL`. When `key` is backed by the store, the mapping follows it
  rather than the client input, matching what
  [`setup_auto_update_logic()`](https://j-andrews7.github.io/VizModules/reference/setup_auto_update_logic.md)
  would have done for a direct `input$<key>` read.

## Value

A
[`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html)
holding a named character vector of colors aligned to the current
groups, or `NULL` before any groups exist. Call it with no arguments to
read, and with a value to seed.

## Details

`setup_group_colors()` gives the module a server-side channel for the
mapping instead. It resolves the palette itself (via
[`resolve_palette()`](https://j-andrews7.github.io/VizModules/reference/resolve_palette.md))
as soon as the group set is known, and holds the result in a
[`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html),
which only invalidates on a *changed* value. A rebuilt picker echoing
the mapping already in use therefore costs nothing, while a color the
user actually picks comes straight through.

Use it in three places:

- Create the store next to the module's group-levels reactive.

- Seed it inside the picker's
  [`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) with the
  same `initial_colors` the widget is built from, so the mapping is
  right even when the render was deferred (a picker on a hidden tab is
  suspended).

- Read `isolate_fn(store())` in the plot reactive, in place of
  `isolate_fn(input$<key>)`.

Note that
[`freezeReactiveValue()`](https://rdrr.io/pkg/shiny/man/freezeReactiveValue.html)
does not cover this case: inside a
[`renderUI()`](https://rdrr.io/pkg/shiny/man/renderUI.html) it pauses
only the readers that run after it in that flush, and at startup the
plot output runs first.

## See also

[`resolve_palette()`](https://j-andrews7.github.io/VizModules/reference/resolve_palette.md),
[`multiColorPicker()`](https://j-andrews7.github.io/VizModules/reference/multiColorPicker.md),
[`setup_auto_update_logic()`](https://j-andrews7.github.io/VizModules/reference/setup_auto_update_logic.md)

## Author

Jared Andrews

## Examples

``` r
if (interactive()) {
    library(shiny)

    server <- function(input, output, session) {
        groups <- reactive(levels(as.factor(iris$Species)))
        palette_store <- setup_group_colors(
            input, "palette.colours", groups,
            default_palette = dittoViz::dittoColors()
        )

        output$palette.selection <- renderUI({
            initial_colors <- isolate(palette_store())
            multiColorPicker(
                session$ns("palette.colours"),
                groups = groups(), colors = initial_colors
            )
        })

        output$plot <- renderPlot(barplot(1:3, col = palette_store()))
    }
}
```
