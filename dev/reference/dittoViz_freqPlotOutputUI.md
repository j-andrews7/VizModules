# Output UI components for the freqPlot module

This should be placed in the UI where the plot should be shown.

## Usage

``` r
dittoViz_freqPlotOutputUI(id, resizable = TRUE)
```

## Arguments

- id:

  The ID for the Shiny module.

- resizable:

  Logical; when `TRUE` (the default) the plot output is wrapped in
  [`shinyjqui::jqui_resizable()`](https://yang-tang.github.io/shinyjqui/reference/Interactions.html)
  so it can be resized by dragging. Set to `FALSE` when embedding the
  output in a container that already provides resizing.

## Value

A Shiny plotlyOutput for the freqPlot

## See also

[`dittoViz::freqPlot()`](https://rdrr.io/pkg/dittoViz/man/freqPlot.html),
[`dittoViz_freqPlotInputsUI()`](https://j-andrews7.github.io/VizModules/dev/reference/dittoViz_freqPlotInputsUI.md),
[`dittoViz_freqPlotServer()`](https://j-andrews7.github.io/VizModules/dev/reference/dittoViz_freqPlotServer.md),
[`dittoViz_freqPlotApp()`](https://j-andrews7.github.io/VizModules/dev/reference/dittoViz_freqPlotApp.md)

## Author

Jared Andrews
