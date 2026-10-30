# Add a point-size legend to a plotly figure

plotly drops the size legend when marker size encodes a numeric column
(plotly.R#705), whether the figure comes from
[`plotly::ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html) or
is built by hand. This draws one in its place: a vertical column of
circles with numeric labels, outside the right edge of the plot area in
paper-referenced coordinates so it does not overlap the data. The breaks
run evenly across the size scale's `limits`, and each circle is drawn at
the size the scale gives its value, so the legend follows the plot's
size scaling. The DotPlot and scatter plot modules use it, and a module
in another package can too.

## Usage

``` r
add_size_legend(
  fig,
  data,
  size.by,
  gap = 0.05,
  size.values = NULL,
  title = size.by,
  digits = NULL,
  title.size = NULL,
  text.size = NULL,
  start.y = 0.95,
  start.x = 1.02,
  font.family = NULL,
  font.color = NULL,
  limits = NULL,
  size.range = NULL,
  breaks = NULL
)
```

## Arguments

- fig:

  A plotly figure object.

- data:

  A data frame containing the variable mapped to point size.

- size.by:

  Character string, or `NULL`. Name of the column in `data` whose range
  determines the legend break labels. When `NULL` or empty (no size
  mapping is in effect), the figure is returned unchanged.

- gap:

  Numeric. Vertical spacing (in paper units, 0–1) between consecutive
  legend entries. Defaults to `0.05`.

- size.values:

  Numeric vector of font sizes (px) used to render the circle glyphs,
  one per legend entry. When `NULL` (the default), the glyph sizes
  follow the plot's size scaling: from `size.range` when it is given,
  otherwise from the marker sizes in `fig`. The marker pixel diameters
  are converted to glyph font-sizes via `.CIRCLE_GLYPH_DIAMETER_RATIO`
  so the rendered circles match the plotted dots. When supplied, the
  vector is used verbatim as font sizes and its length determines the
  number of legend entries.

- title:

  Character. Legend title. Defaults to `size.by`.

- digits:

  Integer, or `NULL`. Decimal places the break labels are rounded to.
  When `NULL` (the default), the break values are printed as they are.

- title.size:

  Numeric, or `NULL`. Font size (px) of the legend title annotation.
  When `NULL`, plotly's default is used.

- text.size:

  Numeric, or `NULL`. Font size (px) of the numeric label annotations.
  Defaults to `12` when `NULL`.

- start.y:

  Numeric. Paper-space y coordinate (0–1) at which the legend column
  begins; the title sits just above it and subsequent entries stack
  downward. Lower it to vertically offset the size legend from an
  overlapping color/shape legend. Invalid values fall back to the
  default. Defaults to `0.95`.

- start.x:

  Numeric. Paper-space x coordinate at which the legend column (circles,
  labels and title) is anchored. Values just above `1` place the legend
  to the right of the plot area; nudge it lower to pull the whole set
  inward when it would otherwise overflow a narrow plot, or higher to
  push it further out. Defaults to `1.02`.

- font.family:

  Character, or `NULL`. Font family of the title and label annotations.
  When `NULL`, plotly's default is used.

- font.color:

  Character, or `NULL`. Font color of the title and label annotations.
  Defaults to `"#000000"` when `NULL`. The circles stay black.

- limits:

  Numeric length-2 vector, or `NULL`. The `size.by` values drawn at the
  smallest and largest sizes, as given to the plot's size scale. The
  breaks run evenly between them. A `NA` end takes the data's minimum or
  maximum, and limits that are not in increasing order fall back to the
  data's range. Defaults to `NULL`, the data's range.

- size.range:

  Numeric length-2 vector, or `NULL`. The size range the plot's size
  scale maps `limits` onto, in ggplot2 size units (the `range` of
  [`ggplot2::scale_size()`](https://ggplot2.tidyverse.org/reference/scale_size.html)).
  When given, each circle is drawn at the size the scale gives its
  break. When `NULL` (the default), the circles are read from the marker
  sizes in `fig`.

- breaks:

  Numeric vector, or `NULL`. The `size.by` values to draw a circle for,
  in place of five spaced evenly between the limits. Values outside the
  limits are dropped. Useful for round labels, or to leave out the lower
  limit of a scale whose `size.range` starts at 0, which would draw an
  empty circle. When `size.values` is also given, it is recycled to one
  glyph size per break. Defaults to `NULL`.

## Value

The built plotly figure with size-legend annotations appended, or the
unmodified figure when `size.by` is `NULL`/empty, not present in `data`,
not numeric, or has no finite values.

## Details

For a ggplot drawn with `scale_size(range = r, limits = l)`, pass
`size.range = r` and `limits = l`. Without `size.range`, the circles are
read from the figure's own markers instead, taking its smallest and
largest to be the data's minimum and maximum.

Call it after the figure's traces are complete. It builds the figure and
appends its annotations to the built layout, so later
[`plotly::plotly_build()`](https://rdrr.io/pkg/plotly/man/plotly_build.html)
calls (e.g.
[`apply_legend_inputs()`](https://j-andrews7.github.io/VizModules/reference/apply_legend_inputs.md)
or
[`axis_titles_as_annotations()`](https://j-andrews7.github.io/VizModules/reference/axis_titles_as_annotations.md))
do not duplicate them. A module hiding its legend should pass
`size.by = NULL`.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
library(plotly)
df <- data.frame(x = 1:5, y = c(2, 4, 3, 5, 1), n = c(10, 40, 25, 80, 55))
fig <- plot_ly(df, x = ~x, y = ~y, type = "scatter", mode = "markers",
    marker = list(size = sqrt(df$n) * 3))
add_size_legend(fig, df, size.by = "n", title = "Count", digits = 0)

{"x":{"visdat":{"1c3e6addb0c3":["function () ","plotlyVisDat"]},"cur_data":"1c3e6addb0c3","attrs":{"1c3e6addb0c3":{"x":{},"y":{},"mode":"markers","marker":{"size":[9.4868329805051381,18.973665961010276,15,26.832815729997478,22.248595461286989]},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"title":"x"},"yaxis":{"domain":[0,1],"automargin":true,"title":"y"},"hovermode":"closest","showlegend":false,"annotations":[{"x":1.04,"y":0.97499999999999998,"xref":"paper","yref":"paper","text":"Count","showarrow":false,"xanchor":"center","yanchor":"bottom","font":{"color":"#000000"}},{"x":1.02,"y":0.94051316701949483,"xref":"paper","yref":"paper","text":"<span style='font-size:21.5609840466026px; color:#000000;'>&#9679;<\/span>","showarrow":false,"xanchor":"center","yanchor":"middle"},{"x":1.02,"y":0.94051316701949483,"xref":"paper","yref":"paper","text":"10","showarrow":false,"xanchor":"left","yanchor":"middle","xshift":10.743416490252569,"font":{"color":"#000000","size":12}},{"x":1.02,"y":0.86286650968373835,"xref":"paper","yref":"paper","text":"<span style='font-size:41.2723280801166px; color:#000000;'>&#9679;<\/span>","showarrow":false,"xanchor":"center","yanchor":"middle"},{"x":1.02,"y":0.86286650968373835,"xref":"paper","yref":"paper","text":"28","showarrow":false,"xanchor":"left","yanchor":"middle","xshift":15.079912177625655,"font":{"color":"#000000","size":12}},{"x":1.02,"y":0.77295439031947089,"xref":"paper","yref":"paper","text":"<span style='font-size:49.4370341114001px; color:#000000;'>&#9679;<\/span>","showarrow":false,"xanchor":"center","yanchor":"middle"},{"x":1.02,"y":0.77295439031947089,"xref":"paper","yref":"paper","text":"45","showarrow":false,"xanchor":"left","yanchor":"middle","xshift":16.876147504508022,"font":{"color":"#000000","size":12}},{"x":1.02,"y":0.6766932006152826,"xref":"paper","yref":"paper","text":"<span style='font-size:55.7020333981185px; color:#000000;'>&#9679;<\/span>","showarrow":false,"xanchor":"center","yanchor":"middle"},{"x":1.02,"y":0.6766932006152826,"xref":"paper","yref":"paper","text":"62","showarrow":false,"xanchor":"left","yanchor":"middle","xshift":18.254447347586073,"font":{"color":"#000000","size":12}},{"x":1.02,"y":0.57535149019011289,"xref":"paper","yref":"paper","text":"<span style='font-size:60.9836721136306px; color:#000000;'>&#9679;<\/span>","showarrow":false,"xanchor":"center","yanchor":"middle"},{"x":1.02,"y":0.57535149019011289,"xref":"paper","yref":"paper","text":"80","showarrow":false,"xanchor":"left","yanchor":"middle","xshift":19.416407864998739,"font":{"color":"#000000","size":12}}]},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[1,2,3,4,5],"y":[2,4,3,5,1],"mode":"markers","marker":{"color":"rgba(31,119,180,1)","size":[9.4868329805051381,18.973665961010276,15,26.832815729997478,22.248595461286989],"line":{"color":"rgba(31,119,180,1)"}},"type":"scatter","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
# A ggplot with a fixed size scale: the legend runs 0, 25, ..., 100.
library(ggplot2)
p <- ggplot(df, aes(x, y, size = n)) +
    geom_point() +
    scale_size(range = c(2, 8), limits = c(0, 100))
add_size_legend(ggplotly(p), df, size.by = "n", limits = c(0, 100), size.range = c(2, 8))

{"x":{"data":[{"x":[1,2,3,4,5],"y":[2,4,3,5,1],"text":["x: 1<br />y: 2<br />n: 10","x: 2<br />y: 4<br />n: 40","x: 3<br />y: 3<br />n: 25","x: 4<br />y: 5<br />n: 80","x: 5<br />y: 1<br />n: 55"],"type":"scatter","mode":"markers","marker":{"autocolorscale":false,"color":"rgba(0,0,0,1)","opacity":1,"size":[14.730204457704671,21.901353797299105,18.897637795275593,27.842128425824864,24.3768910573508],"symbol":"circle","line":{"width":1.8897637795275593,"color":"rgba(0,0,0,1)"}},"hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":23.305936073059364,"r":7.3059360730593621,"b":37.260273972602747,"l":31.415525114155255},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.80000000000000004,5.2000000000000002],"tickmode":"array","ticktext":["1","2","3","4","5"],"tickvals":[1,2,3,4,5],"categoryorder":"array","categoryarray":["1","2","3","4","5"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.68949771689498},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":{"text":"x","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.80000000000000004,5.2000000000000002],"tickmode":"array","ticktext":["1","2","3","4","5"],"tickvals":[1,2,3,4,5],"categoryorder":"array","categoryarray":["1","2","3","4","5"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.68949771689498},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"x","title":{"text":"y","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724}},"hoverformat":".2f"},"shapes":[],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.8897637795275593,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.68949771689498},"title":{"text":"n","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724}}},"hovermode":"closest","barmode":"relative","annotations":[{"x":1.04,"y":0.97499999999999998,"xref":"paper","yref":"paper","text":"n","showarrow":false,"xanchor":"center","yanchor":"bottom","font":{"color":"#000000"}},{"x":1.02,"y":0.94244094488188968,"xref":"paper","yref":"paper","text":"<span style='font-size:17.1796707229778px; color:#000000;'>&#9679;<\/span>","showarrow":false,"xanchor":"center","yanchor":"middle"},{"x":1.02,"y":0.94244094488188968,"xref":"paper","yref":"paper","text":"0","showarrow":false,"xanchor":"left","yanchor":"middle","xshift":9.7795275590551185,"font":{"color":"#000000","size":12}},{"x":1.02,"y":0.8659842519685037,"xref":"paper","yref":"paper","text":"<span style='font-size:42.9491768074445px; color:#000000;'>&#9679;<\/span>","showarrow":false,"xanchor":"center","yanchor":"middle"},{"x":1.02,"y":0.8659842519685037,"xref":"paper","yref":"paper","text":"25","showarrow":false,"xanchor":"left","yanchor":"middle","xshift":15.448818897637796,"font":{"color":"#000000","size":12}},{"x":1.02,"y":0.77349238165498191,"xref":"paper","yref":"paper","text":"<span style='font-size:53.6232557232866px; color:#000000;'>&#9679;<\/span>","showarrow":false,"xanchor":"center","yanchor":"middle"},{"x":1.02,"y":0.77349238165498191,"xref":"paper","yref":"paper","text":"50","showarrow":false,"xanchor":"left","yanchor":"middle","xshift":17.797116259123062,"font":{"color":"#000000","size":12}},{"x":1.02,"y":0.67270009273595477,"xref":"paper","yref":"paper","text":"<span style='font-size:61.8137645472295px; color:#000000;'>&#9679;<\/span>","showarrow":false,"xanchor":"center","yanchor":"middle"},{"x":1.02,"y":0.67270009273595477,"xref":"paper","yref":"paper","text":"75","showarrow":false,"xanchor":"left","yanchor":"middle","xshift":19.599028200390485,"font":{"color":"#000000","size":12}},{"x":1.02,"y":0.56526581586273283,"xref":"paper","yref":"paper","text":"<span style='font-size:68.7186828919112px; color:#000000;'>&#9679;<\/span>","showarrow":false,"xanchor":"center","yanchor":"middle"},{"x":1.02,"y":0.56526581586273283,"xref":"paper","yref":"paper","text":"100","showarrow":false,"xanchor":"left","yanchor":"middle","xshift":21.118110236220474,"font":{"color":"#000000","size":12}}]},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"1c3e2c662e0a":{"x":{},"y":{},"size":{},"type":"scatter"}},"cur_data":"1c3e2c662e0a","visdat":{"1c3e2c662e0a":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
