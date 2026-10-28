# Server logic for scatterPlot module

Server logic for scatterPlot module

## Usage

``` r
dittoViz_scatterPlotServer(
  id,
  data,
  hide.inputs = NULL,
  hide.tabs = NULL,
  defaults = NULL,
  fig.fn = NULL
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

- fig.fn:

  An optional function `function(fig, input, isolate_fn)` returning the
  figure, for a wrapper module to add to or adjust the plot (extra
  layers, annotations, axis title text) before it is finalised. It runs
  inside the plot reactive, after the legend is styled and before the
  axis titles become draggable annotations, so whatever it adds reaches
  the rendered plot, manual-edit persistence and the source download
  alike. `input` is this module's input, which a wrapper sharing the
  module's `id` also writes its own inputs to. Read inputs as
  `isolate_fn(input$key)` so they respect the module's auto-update
  setting.

## Value

The `moduleServer` function for the scatterPlot module.

## See also

[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
[`dittoViz_scatterPlotInputsUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotInputsUI.md),
[`dittoViz_scatterPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotOutputUI.md),
[`dittoViz_scatterPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotApp.md)

## Author

Jared Andrews
