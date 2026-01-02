# Create a plotly pie chart

Create a plotly pie chart

## Usage

``` r
piePlot(
  reactive.data,
  plot.labels,
  plot.values,
  make.hole = 0,
  palette,
  col_palette = NULL,
  plot.text = "label+percent"
)
```

## Arguments

- reactive.data:

  A data frame containing the data to plot.

- plot.labels:

  A formula for the labels.

- plot.values:

  A formula for the values.

- make.hole:

  A numeric value between 0 and 1 for the hole size (0 for pie, \>0 for
  donut).

- palette:

  A character vector of colors to use if `col_palette` is NULL.

- col_palette:

  A character vector of colors to use.

- plot.text:

  A character string for the text info to show.

## Value

A plotly object.

## Author

Jacob Martin
