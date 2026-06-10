# Output UI components for the BarPlot module

This should be placed in the UI where the plot should be shown.

## Usage

``` r
plotthis_BarPlotOutputUI(id, resizable = TRUE)
```

## Arguments

- id:

  The ID for the Shiny module.

- resizable:

  Logical; when `TRUE` (the default) the plot output is wrapped in
  [`jqui_resizable`](https://yang-tang.github.io/shinyjqui/reference/Interactions.html)
  so it can be resized by dragging. Set to `FALSE` when embedding the
  output in a container that already provides resizing.

## Value

A Shiny plotlyOutput for the BarPlot

## Author

Jacob Martin, Jared Andrews
