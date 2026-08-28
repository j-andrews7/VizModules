# Drop persisted axis-title text edits

Removes any captured `text` edit for the given axis-title annotation
keys from an edit store, so the axis title is regenerated from its
(possibly adjusted) data-derived label on the next rebuild rather than
restoring a stale manual edit. Any captured position for those titles is
left intact, so a dragged title keeps its place. Intended to be called
when the plotted variable for an axis changes (e.g. from an
[`observeEvent()`](https://rdrr.io/pkg/shiny/man/observeEvent.html) or
inside the plot-building reactive), matching the convention that a
manual title only makes sense for the variable it was written for.

## Usage

``` r
reset_axis_title_text(store, keys = c("axis:x", "axis:y"))
```

## Arguments

- store:

  The list returned by
  [`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_manual_edits.md).

- keys:

  Character vector of axis annotation keys to clear text for. Defaults
  to both axis titles, `c("axis:x", "axis:y")`. The `#<occurrence>`
  suffix added by `.annotation_edit_keys()` is ignored when matching.

## Value

Invisibly, `TRUE` if any stored text was removed, otherwise `FALSE`.

## See also

[`setup_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/setup_manual_edits.md),
[`finalize_manual_edits()`](https://j-andrews7.github.io/VizModules/dev/reference/finalize_manual_edits.md).

## Author

Jared Andrews

## Examples

``` r
if (FALSE) { # \dontrun{
# Regenerate the y-axis title whenever the plotted variable changes:
observeEvent(input$var, reset_axis_title_text(edit_store, "axis:y"),
    ignoreInit = TRUE)
} # }
```
