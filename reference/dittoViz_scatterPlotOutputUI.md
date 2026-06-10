# Output UI components for the scatterPlot module

This should be placed in the UI where the plot should be shown.

## Usage

``` r
dittoViz_scatterPlotOutputUI(id, resizable = TRUE)
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

A Shiny plotlyOutput for the scatterplot

## Author

Jared Andrews
