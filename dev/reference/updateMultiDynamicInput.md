# Update a multiDynamicInput input on the client

Replace all rows of an existing
[`multiDynamicInput()`](https://j-andrews7.github.io/VizModules/dev/reference/multiDynamicInput.md)
from the server, or clear it entirely.

## Usage

``` r
updateMultiDynamicInput(session, inputId, elements = NULL, clear = FALSE)
```

## Arguments

- session:

  The Shiny session object, typically `session`.

- inputId:

  Character. The input id of the multiDynamicInput to update.

- elements:

  Optional named list of rows (same shape as the return value) to set.
  Ignored when `clear = TRUE`.

- clear:

  Logical. If `TRUE`, remove all rows. Overrides `elements`.

## Value

Invisibly returns `NULL`. Called for its side effect.

## Author

Jacob Martin
