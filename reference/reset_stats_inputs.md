# Reset uniform stats inputs to defaults

Resets all inputs created by
[`uniform_stats_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_stats_inputs_ui.md)
to their default values. Call inside an `observeEvent(input$reset, ...)`
block.

## Usage

``` r
reset_stats_inputs(session, defaults = NULL, pair_strings = NULL)
```

## Arguments

- session:

  The Shiny session object (from `moduleServer`).

- defaults:

  A named list of default values to reset to, or NULL to use hardcoded
  fallbacks. Typically the same list passed to the UI function.

- pair_strings:

  Character vector of the comparisons currently on offer in the
  Comparisons selector. Those named by `defaults$stat.pairs` are
  reselected (see
  [`default_stat_pairs()`](https://j-andrews7.github.io/VizModules/reference/default_stat_pairs.md));
  `NULL` clears the selection.

## Value

Called for side effects; returns `invisible(NULL)`.

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Inside a module server:
observeEvent(input$reset, {
    reset_stats_inputs(session, defaults, pair_strings = pair_choices())
})
} # }
```
