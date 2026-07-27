# Apply axis styling to all subplot axes in a plotly figure

When using plotly subplots (e.g., via split.by in dittoViz), axis
styling must be applied to all subplot axes (xaxis, xaxis2, xaxis3,
etc.) individually. This helper function detects how many subplots exist
and applies the provided axis styling to all of them.

## Usage

``` r
apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)
```

## Arguments

- fig:

  A plotly figure object.

- xaxis_style:

  A named list of axis styling parameters for x-axes.

- yaxis_style:

  A named list of axis styling parameters for y-axes.

## Value

The modified plotly figure with axis styling applied to all subplots.

## Author

Jared Andrews

## Examples

``` r
fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
xaxis_style <- list(showline = TRUE, linecolor = "black", linewidth = 1)
yaxis_style <- list(showline = TRUE, linecolor = "black", linewidth = 1)
apply_subplot_axis_styling(fig, xaxis_style, yaxis_style)

{"x":{"visdat":{"190f4064fb83":["function () ","plotlyVisDat"]},"cur_data":"190f4064fb83","attrs":{"190f4064fb83":{"x":{},"y":{},"mode":"markers","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"showline":true,"linecolor":"black","linewidth":1,"title":"wt"},"yaxis":{"domain":[0,1],"automargin":true,"showline":true,"linecolor":"black","linewidth":1,"title":"mpg"},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[2.6200000000000001,2.875,2.3199999999999998,3.2149999999999999,3.4399999999999999,3.46,3.5699999999999998,3.1899999999999999,3.1499999999999999,3.4399999999999999,3.4399999999999999,4.0700000000000003,3.73,3.7799999999999998,5.25,5.4240000000000004,5.3449999999999998,2.2000000000000002,1.615,1.835,2.4649999999999999,3.52,3.4350000000000001,3.8399999999999999,3.8450000000000002,1.9350000000000001,2.1400000000000001,1.5129999999999999,3.1699999999999999,2.77,3.5699999999999998,2.7799999999999998],"y":[21,21,22.800000000000001,21.399999999999999,18.699999999999999,18.100000000000001,14.300000000000001,24.399999999999999,22.800000000000001,19.199999999999999,17.800000000000001,16.399999999999999,17.300000000000001,15.199999999999999,10.4,10.4,14.699999999999999,32.399999999999999,30.399999999999999,33.899999999999999,21.5,15.5,15.199999999999999,13.300000000000001,19.199999999999999,27.300000000000001,26,30.399999999999999,15.800000000000001,19.699999999999999,15,21.399999999999999],"mode":"markers","type":"scatter","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
