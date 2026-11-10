# Set the padding between a figure's data and the edges of its plot area

Sets each x and y axis range to the extent of the data drawn on it,
widened at each end by a fraction of that extent: `0` makes the data
fill the plot area, `0.05` matches ggplot2's default expansion. The
extent is read from the figure's traces as drawn: points and lines, bars
from their base, error bars, and fills down to zero. A categorical axis
(as [`plotly::ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html)
draws one) spans its categories' bands, each one unit wide, so `0` puts
the outer bands' edges on the plot area's.

## Usage

``` r
apply_axis_padding(fig, x = NULL, y = NULL, swap = FALSE)
```

## Arguments

- fig:

  A plotly figure.

- x, y:

  Padding for the x and y axes, as a fraction of the data's extent added
  at each end. `NULL` or `NA` leaves that axis as it is.

- swap:

  Logical. Apply `x` to the figure's y axes and `y` to its x axes, for a
  plot drawn with its axes swapped (a rotated or flipped plot), so the
  padding follows the variable rather than the screen direction.

## Value

The built plotly figure with the axis ranges set.

## Details

Axes that share a scale (matched axes, or the identical ranges of a
faceted plot's fixed scales) get the same range, so they still line up.
Reversed axes stay reversed, and log axes are padded in log units. Axes
holding dates or plotly categories, or with no numeric data on them, are
left alone, as are axes marked with
[`mark_overlay_axes()`](https://j-andrews7.github.io/VizModules/reference/mark_overlay_axes.md).

Only what the traces draw counts. Annotations and shapes, such as
significance brackets or reference lines, do not widen the range and can
be cut off, so use axis limits instead on an axis that carries them.

## See also

[`apply_uniform_styling()`](https://j-andrews7.github.io/VizModules/reference/apply_uniform_styling.md),
which applies this from the Axes tab's "X Axis Padding" and "Y Axis
Padding" inputs.

## Author

Jared Andrews

## Examples

``` r
fig <- plotly::plot_ly(mtcars,
    x = ~wt, y = ~mpg, type = "scatter", mode = "markers"
)
# Points reaching the edges of the plot area.
apply_axis_padding(fig, x = 0, y = 0)$x$layout$xaxis$range
#> [1] 1.513 5.424

# A ggplot area plot with its default expansion removed along x only.
df <- data.frame(year = 2000:2020, n = cumsum(c(5, rep(1, 20))))
p <- ggplot2::ggplot(df, ggplot2::aes(year, n)) +
    ggplot2::geom_area()
apply_axis_padding(plotly::ggplotly(p), x = 0)

{"x":{"data":[{"x":[2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2020,2020,2019,2018,2017,2016,2015,2014,2013,2012,2011,2010,2009,2008,2007,2006,2005,2004,2003,2002,2001,2000,2000],"y":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,0],"text":["year: 2000<br />n:  5","year: 2001<br />n:  6","year: 2002<br />n:  7","year: 2003<br />n:  8","year: 2004<br />n:  9","year: 2005<br />n: 10","year: 2006<br />n: 11","year: 2007<br />n: 12","year: 2008<br />n: 13","year: 2009<br />n: 14","year: 2010<br />n: 15","year: 2011<br />n: 16","year: 2012<br />n: 17","year: 2013<br />n: 18","year: 2014<br />n: 19","year: 2015<br />n: 20","year: 2016<br />n: 21","year: 2017<br />n: 22","year: 2018<br />n: 23","year: 2019<br />n: 24","year: 2020<br />n: 25","year: 2020<br />n: 25","year: 2020<br />n: 25","year: 2019<br />n: 24","year: 2018<br />n: 23","year: 2017<br />n: 22","year: 2016<br />n: 21","year: 2015<br />n: 20","year: 2014<br />n: 19","year: 2013<br />n: 18","year: 2012<br />n: 17","year: 2011<br />n: 16","year: 2010<br />n: 15","year: 2009<br />n: 14","year: 2008<br />n: 13","year: 2007<br />n: 12","year: 2006<br />n: 11","year: 2005<br />n: 10","year: 2004<br />n:  9","year: 2003<br />n:  8","year: 2002<br />n:  7","year: 2001<br />n:  6","year: 2000<br />n:  5","year: 2000<br />n:  5"],"type":"scatter","mode":"lines","line":{"width":1.8897637795275593,"color":"transparent","dash":"solid"},"fill":"toself","fillcolor":"rgba(51,51,51,1)","hoveron":"points","showlegend":false,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":23.305936073059364,"r":7.3059360730593621,"b":37.260273972602747,"l":37.260273972602747},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[2000,2020],"tickmode":"array","ticktext":["2000","2005","2010","2015","2020"],"tickvals":[2000,2005,2010,2015,2020],"categoryorder":"array","categoryarray":["2000","2005","2010","2015","2020"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.68949771689498},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"y","title":{"text":"year","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-1.25,26.25],"tickmode":"array","ticktext":["0","5","10","15","20","25"],"tickvals":[0,5,10,15,20,25],"categoryorder":"array","categoryarray":["0","5","10","15","20","25"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.6529680365296811,"tickwidth":0.66417600664176002,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.68949771689498},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176002,"zeroline":false,"anchor":"x","title":{"text":"n","font":{"color":"rgba(0,0,0,1)","family":"","size":14.611872146118724}},"hoverformat":".2f"},"shapes":[],"showlegend":false,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.8897637795275593,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.68949771689498}},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"source":"A","attrs":{"198c725ebdd3":{"x":{},"y":{},"type":"scatter"}},"cur_data":"198c725ebdd3","visdat":{"198c725ebdd3":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly",".vizmodules_built":true},"evals":[],"jsHooks":[]}
```
