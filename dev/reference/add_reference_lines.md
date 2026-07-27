# Add reference lines to a plotly figure from Shiny inputs

Convenience wrapper that adds horizontal, vertical, and/or diagonal
lines to a plotly figure based on parsed Shiny input values.

## Usage

``` r
add_reference_lines(
  fig,
  hline.intercepts = NULL,
  hline.colors = NULL,
  hline.widths = NULL,
  hline.linetypes = NULL,
  hline.opacities = NULL,
  vline.intercepts = NULL,
  vline.colors = NULL,
  vline.widths = NULL,
  vline.linetypes = NULL,
  vline.opacities = NULL,
  abline.slopes = NULL,
  abline.intercepts = NULL,
  abline.colors = NULL,
  abline.widths = NULL,
  abline.linetypes = NULL,
  abline.opacities = NULL
)
```

## Arguments

- fig:

  A plotly figure object.

- hline.intercepts:

  Character. Comma-separated y-intercepts for horizontal lines.

- hline.colors:

  Character. Comma-separated colors for horizontal lines.

- hline.widths:

  Character. Comma-separated widths for horizontal lines.

- hline.linetypes:

  Character. Comma-separated linetypes for horizontal lines.

- hline.opacities:

  Character. Comma-separated opacities for horizontal lines.

- vline.intercepts:

  Character. Comma-separated x-intercepts for vertical lines.

- vline.colors:

  Character. Comma-separated colors for vertical lines.

- vline.widths:

  Character. Comma-separated widths for vertical lines.

- vline.linetypes:

  Character. Comma-separated linetypes for vertical lines.

- vline.opacities:

  Character. Comma-separated opacities for vertical lines.

- abline.slopes:

  Character. Comma-separated slopes for diagonal lines.

- abline.intercepts:

  Character. Comma-separated y-intercepts for diagonal lines.

- abline.colors:

  Character. Comma-separated colors for diagonal lines.

- abline.widths:

  Character. Comma-separated widths for diagonal lines.

- abline.linetypes:

  Character. Comma-separated linetypes for diagonal lines.

- abline.opacities:

  Character. Comma-separated opacities for diagonal lines.

## Value

The modified plotly figure with all specified lines added.

## Author

Jared Andrews

## Examples

``` r
fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
add_reference_lines(fig,
    hline.intercepts = "20, 30", hline.colors = "red, blue",
    vline.intercepts = "3", abline.slopes = "5", abline.intercepts = "0"
)

{"x":{"visdat":{"19775d8eb192":["function () ","plotlyVisDat"]},"cur_data":"19775d8eb192","attrs":{"19775d8eb192":{"x":{},"y":{},"mode":"markers","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"shapes":[{"type":"line","x0":0,"x1":1,"xref":"x domain","y0":20,"y1":20,"yref":"y","line":{"color":"red","width":1,"dash":"solid"},"opacity":1},{"type":"line","x0":0,"x1":1,"xref":"x domain","y0":30,"y1":30,"yref":"y","line":{"color":"blue","width":1,"dash":"solid"},"opacity":1},{"type":"line","x0":3,"x1":3,"xref":"x","y0":0,"y1":1,"yref":"y domain","line":{"color":"#000000","width":1,"dash":"solid"},"opacity":1},{"type":"line","x0":0,"x1":1,"xref":"x","y0":0,"y1":5,"yref":"y","line":{"color":"#000000","width":1,"dash":"solid"},"opacity":1}],"xaxis":{"domain":[0,1],"automargin":true,"title":"wt"},"yaxis":{"domain":[0,1],"automargin":true,"title":"mpg"},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[2.6200000000000001,2.875,2.3199999999999998,3.2149999999999999,3.4399999999999999,3.46,3.5699999999999998,3.1899999999999999,3.1499999999999999,3.4399999999999999,3.4399999999999999,4.0700000000000003,3.73,3.7799999999999998,5.25,5.4240000000000004,5.3449999999999998,2.2000000000000002,1.615,1.835,2.4649999999999999,3.52,3.4350000000000001,3.8399999999999999,3.8450000000000002,1.9350000000000001,2.1400000000000001,1.5129999999999999,3.1699999999999999,2.77,3.5699999999999998,2.7799999999999998],"y":[21,21,22.800000000000001,21.399999999999999,18.699999999999999,18.100000000000001,14.300000000000001,24.399999999999999,22.800000000000001,19.199999999999999,17.800000000000001,16.399999999999999,17.300000000000001,15.199999999999999,10.4,10.4,14.699999999999999,32.399999999999999,30.399999999999999,33.899999999999999,21.5,15.5,15.199999999999999,13.300000000000001,19.199999999999999,27.300000000000001,26,30.399999999999999,15.800000000000001,19.699999999999999,15,21.399999999999999],"mode":"markers","type":"scatter","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
