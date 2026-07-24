# Apply custom subplot spacing to a faceted ggplotly figure

[`ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html) assigns
panel layout via plotly domain coordinates
(`fig$x$layout$xaxis*/yaxis*$domain`) rather than honouring the ggplot2
`panel.spacing` theme option. This helper rewrites those domains so that
each facet panel has a uniform size and the gap between panels is
exactly `spacing` (expressed as a fraction of the plot area, e.g.
`0.04`).

## Usage

``` r
apply_facet_subplot_spacing(fig, spacing = 0.04, ncol = NULL, nrow = NULL)
```

## Arguments

- fig:

  A plotly figure object (typically the result of
  [`ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html)).

- spacing:

  Numeric fraction of the plot area to leave between panels (default
  `0.04`). May be a single value applied to both directions, or a
  length-2 numeric vector `c(horizontal, vertical)` to control the gap
  between columns and rows independently. Must satisfy
  `horizontal * (ncol - 1) < 1` and `vertical * (nrow - 1) < 1`;
  otherwise the figure is returned unchanged.

- ncol:

  Optional integer. Number of facet columns. If `NULL` or `NA`, detected
  from the number of distinct x-axis domain starts.

- nrow:

  Optional integer. Number of facet rows. If `NULL` or `NA`, detected
  from the number of distinct y-axis domain starts.

## Value

The modified plotly figure with rewritten axis domains and remapped
paper-anchored annotations/shapes. Figures with a single panel (or no
layout) are returned unchanged.

## Details

In addition to the axis domains, any paper-anchored layout annotations
(e.g. facet strip titles) and shapes (e.g. strip backgrounds, panel
borders) are remapped through a piecewise-linear transform built from
the old and new domain intervals, so strip labels and panel borders move
with their panels. Annotations/shapes whose `xref`/`yref` is tied to an
axis (for example `"x"`, `"y2"`, or `"x2 domain"`) are left alone
because they follow the rewritten axis automatically.

The number of columns and rows can be supplied manually, or detected
automatically from the distinct x / y domain starts already present in
the ggplotly output.

## Author

Jacob Martin

## Examples

``` r
p <- ggplot2::ggplot(mtcars, ggplot2::aes(wt, mpg)) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~cyl)
fig <- plotly::ggplotly(p)
apply_facet_subplot_spacing(fig, spacing = 0.05)

{"x":{"data":[{"x":[2.3199999999999998,3.1899999999999999,3.1499999999999999,2.2000000000000002,1.615,1.835,2.4649999999999999,1.9350000000000001,2.1400000000000001,1.5129999999999999,2.7799999999999998],"y":[22.800000000000001,24.399999999999999,22.800000000000001,32.399999999999999,30.399999999999999,33.899999999999999,21.5,27.300000000000001,26,30.399999999999999,21.399999999999999],"text":["wt: 2.320<br />mpg: 22.8","wt: 3.190<br />mpg: 24.4","wt: 3.150<br />mpg: 22.8","wt: 2.200<br />mpg: 32.4","wt: 1.615<br />mpg: 30.4","wt: 1.835<br />mpg: 33.9","wt: 2.465<br />mpg: 21.5","wt: 1.935<br />mpg: 27.3","wt: 2.140<br />mpg: 26.0","wt: 1.513<br />mpg: 30.4","wt: 2.780<br />mpg: 21.4"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,0,0,1)","opacity":1,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(0,0,0,1)"}},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"x":[2.6200000000000001,2.875,3.2149999999999999,3.46,3.4399999999999999,3.4399999999999999,2.77],"y":[21,21,21.399999999999999,18.100000000000001,19.199999999999999,17.800000000000001,19.699999999999999],"text":["wt: 2.620<br />mpg: 21.0","wt: 2.875<br />mpg: 21.0","wt: 3.215<br />mpg: 21.4","wt: 3.460<br />mpg: 18.1","wt: 3.440<br />mpg: 19.2","wt: 3.440<br />mpg: 17.8","wt: 2.770<br />mpg: 19.7"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,0,0,1)","opacity":1,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(0,0,0,1)"}},"hoveron":"points","showlegend":false,"xaxis":"x2","yaxis":"y","hoverinfo":"text","frame":null},{"x":[3.4399999999999999,3.5699999999999998,4.0700000000000003,3.73,3.7799999999999998,5.25,5.4240000000000004,5.3449999999999998,3.52,3.4350000000000001,3.8399999999999999,3.8450000000000002,3.1699999999999999,3.5699999999999998],"y":[18.699999999999999,14.300000000000001,16.399999999999999,17.300000000000001,15.199999999999999,10.4,10.4,14.699999999999999,15.5,15.199999999999999,13.300000000000001,19.199999999999999,15.800000000000001,15],"text":["wt: 3.440<br />mpg: 18.7","wt: 3.570<br />mpg: 14.3","wt: 4.070<br />mpg: 16.4","wt: 3.730<br />mpg: 17.3","wt: 3.780<br />mpg: 15.2","wt: 5.250<br />mpg: 10.4","wt: 5.424<br />mpg: 10.4","wt: 5.345<br />mpg: 14.7","wt: 3.520<br />mpg: 15.5","wt: 3.435<br />mpg: 15.2","wt: 3.840<br />mpg: 13.3","wt: 3.845<br />mpg: 19.2","wt: 3.170<br />mpg: 15.8","wt: 3.570<br />mpg: 15.0"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,0,0,1)","opacity":1,"size":5.6692913385826778,"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(0,0,0,1)"}},"hoveron":"points","showlegend":false,"xaxis":"x3","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":34.995433789954348,"r":7.3059360730593621,"b":37.260273972602747,"l":37.260273972602747},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724},"xaxis":{"domain":[0,0.29999999999999999],"automargin":true,"type":"linear","autorange":false,"range":[1.3174499999999998,5.6195500000000003],"tickmode":"array","ticktext":["2","3","4","5"],"tickvals":[2,3,4,5],"categoryorder":"array","categoryarray":["2","3","4","5"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.68949771689498},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":"","hoverformat":".2f"},"annotations":[{"text":"wt","x":0.5,"y":0,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"center","yanchor":"top","annotationType":"axis","yshift":-21.917808219178088},{"text":"mpg","x":0,"y":0.5,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724},"xref":"paper","yref":"paper","textangle":-90,"xanchor":"right","yanchor":"center","annotationType":"axis","xshift":-21.917808219178088},{"text":"4","x":0.14999999917021273,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(26,26,26,1)","family":"","size":11.68949771689498},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"center","yanchor":"bottom"},{"text":"6","x":0.5,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(26,26,26,1)","family":"","size":11.68949771689498},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"center","yanchor":"bottom"},{"text":"8","x":0.85000000082978711,"y":1,"showarrow":false,"ax":0,"ay":0,"font":{"color":"rgba(26,26,26,1)","family":"","size":11.68949771689498},"xref":"paper","yref":"paper","textangle":-0,"xanchor":"center","yanchor":"bottom"}],"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[9.2249999999999996,35.074999999999996],"tickmode":"array","ticktext":["10","15","20","25","30","35"],"tickvals":[10,15,20,25,30,35],"categoryorder":"array","categoryarray":["10","15","20","25","30","35"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.68949771689498},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"x","title":"","hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":"rgba(217,217,217,1)","line":{"color":"transparent","width":0.66417600664176002,"linetype":"solid"},"yref":"paper","xref":"paper","layer":"below","x0":0,"x1":0.29999999834042546,"y0":0,"y1":1,"yanchor":1,"ysizemode":"pixel"},{"type":"rect","fillcolor":"rgba(217,217,217,1)","line":{"color":"transparent","width":0.66417600664176002,"linetype":"solid"},"yref":"paper","xref":"paper","layer":"below","x0":0.34999999659999997,"x1":0.65000000340000008,"y0":0,"y1":1,"yanchor":1,"ysizemode":"pixel"},{"type":"rect","fillcolor":"rgba(217,217,217,1)","line":{"color":"transparent","width":0.66417600664176002,"linetype":"solid"},"yref":"paper","xref":"paper","layer":"below","x0":0.70000000165957432,"x1":1,"y0":0,"y1":1,"yanchor":1,"ysizemode":"pixel"}],"xaxis2":{"type":"linear","autorange":false,"range":[1.3174499999999998,5.6195500000000003],"tickmode":"array","ticktext":["2","3","4","5"],"tickvals":[2,3,4,5],"categoryorder":"array","categoryarray":["2","3","4","5"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.68949771689498},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"domain":[0.34999999999999998,0.64999999999999991],"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":"","hoverformat":".2f"},"xaxis3":{"type":"linear","autorange":false,"range":[1.3174499999999998,5.6195500000000003],"tickmode":"array","ticktext":["2","3","4","5"],"tickvals":[2,3,4,5],"categoryorder":"array","categoryarray":["2","3","4","5"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.68949771689498},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"domain":[0.69999999999999996,1],"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":"","hoverformat":".2f"},"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.8897637795275593,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.68949771689498}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"1ab31054168b":{"x":{},"y":{},"type":"scatter"}},"cur_data":"1ab31054168b","visdat":{"1ab31054168b":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
