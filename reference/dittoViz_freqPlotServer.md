# Server logic for freqPlot module

Server logic for freqPlot module

## Usage

``` r
dittoViz_freqPlotServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  defaults = NULL
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  A `reactive` containing the data frame to plot. Values that are not
  data frames are coerced with
  [`as.data.frame()`](https://rdrr.io/r/base/as.data.frame.html); a
  `NULL` value is treated as "not ready yet" and the module waits for
  data.

- hide.inputs:

  A character vector of input IDs to hide. These will still be
  initialized and their values passed to the plot function, but the user
  will not be able to see/adjust them in the UI.

- hide.tabs:

  A character vector of tab names to hide. Inputs in these tabs will
  still be initialized and their values passed to the plot function, but
  the user will not be able to see/adjust them in the UI.

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

The `moduleServer` function for the freqPlot module.

## See also

[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html),
[`dittoViz_freqPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotInputsUI.md),
[`dittoViz_freqPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotOutputUI.md),
[`dittoViz_freqPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_freqPlotApp.md)

## Author

Jared Andrews
