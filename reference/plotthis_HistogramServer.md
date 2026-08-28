# Histogram Plot Server Module

Server-side logic for the histogram plot module. This function manages
reactive data processing, dynamic UI generation for color palettes, and
the rendering of interactive Plotly histograms.

## Usage

``` r
plotthis_HistogramServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  defaults = NULL
)
```

## Arguments

- id:

  `character` unique ID for the shiny namespace.

- data:

  `reactive` A reactive expression returning a data frame to be plotted.
  Values that are not data frames are coerced with
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html); a
  `NULL` value is treated as "not ready yet" and the module waits for
  data.

- hide.inputs:

  `character` vector of input IDs to hide in the UI. Default is NULL.

- hide.tabs:

  `character` vector of tab names to hide within the module. Default is
  NULL.

- defaults:

  A named list of default values for the inputs. When the reset button
  is clicked, inputs are reset to these values rather than hardcoded
  fallbacks. Typically the same list passed to the corresponding UI
  function. An entry may also be a
  [`shiny::reactive()`](https://rdrr.io/pkg/shiny/man/reactive.html) or
  [`shiny::reactiveVal()`](https://rdrr.io/pkg/shiny/man/reactiveVal.html),
  in which case the input tracks it as the parent app's state changes;
  see
  [`setup_reactive_defaults()`](https://j-andrews7.github.io/VizModules/reference/setup_reactive_defaults.md).

## Value

The `moduleServer` function for the Histogram module.

## Author

Jacob Martin, Jared Andrews
