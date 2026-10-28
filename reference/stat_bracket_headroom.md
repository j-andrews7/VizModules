# Bracket headroom for a module, read straight off its Stats tab

Wraps
[`stat_bracket_y_max()`](https://j-andrews7.github.io/VizModules/reference/stat_bracket_y_max.md)
with the geometry inputs every module's Stats tab carries, so the three
modules that draw significance brackets share one call rather than three
copies of the same argument list. Missing inputs fall back to the tab's
own defaults, which matters while the tab has yet to be rendered.

## Usage

``` r
stat_bracket_headroom(
  df,
  x,
  y,
  group.by = NULL,
  facet.by = NULL,
  per.facet = TRUE,
  input,
  dodge.width = 1
)
```

## Arguments

- df, x, y, group.by, facet.by, per.facet, dodge.width:

  Passed to
  [`stat_bracket_y_max()`](https://j-andrews7.github.io/VizModules/reference/stat_bracket_y_max.md).

- input:

  The Shiny `input` object from inside
  [`moduleServer()`](https://rdrr.io/pkg/shiny/man/moduleServer.html).

## Value

A single number, or `NULL` when no brackets would be drawn.

## See also

[`stat_bracket_y_max()`](https://j-andrews7.github.io/VizModules/reference/stat_bracket_y_max.md),
[`uniform_stats_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_stats_inputs_ui.md),
[`setup_axis_range()`](https://j-andrews7.github.io/VizModules/reference/setup_axis_range.md)

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# As the `headroom` of setup_axis_range(), inside a module server:
headroom <- function() {
    if (!isTRUE(input$stats.enabled)) return(NULL)
    stat_bracket_headroom(data(), x = input$x.data, y = input$y.data, input = input)
}
} # }
```
