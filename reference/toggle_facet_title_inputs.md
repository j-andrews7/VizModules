# Match the title inputs to whether a plot is faceted

A faceted plot titles each panel and has no main title
([`add_plot_config()`](https://j-andrews7.github.io/VizModules/reference/add_plot_config.md)
disables it, as its placeholder sits over the panel titles), so the
facet title inputs are shown and the main title inputs hidden. An
unfaceted plot is the reverse.

## Usage

``` r
toggle_facet_title_inputs(session, faceted, extra = NULL, hidden = NULL)
```

## Arguments

- session:

  The module's Shiny session.

- faceted:

  Logical, whether the plot is currently faceted.

- extra:

  Additional facet-only input IDs shown and hidden with the facet title
  inputs.

- hidden:

  Input IDs the app hid via `hide.inputs`, which are never shown again
  here.

## Value

`NULL`, invisibly. Called for its side effect.

## See also

[main_title_input_ids](https://j-andrews7.github.io/VizModules/reference/main_title_input_ids.md),
[`hide_input()`](https://j-andrews7.github.io/VizModules/reference/hide_input.md),
[`show_input()`](https://j-andrews7.github.io/VizModules/reference/show_input.md),
[`add_plot_config()`](https://j-andrews7.github.io/VizModules/reference/add_plot_config.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Inside a module server, whenever the facet choice changes:
observe({
    toggle_facet_title_inputs(session, faceted = nz_value(input$facet.by), hidden = hide.inputs)
})
} # }
```
