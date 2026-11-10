# Exempt a figure's overlay axes from the shared styling

Marks axes as belonging to panels drawn beside the main plot, such as
marginal distributions, annotation strips, or gene tracks.
[`apply_uniform_styling()`](https://j-andrews7.github.io/VizModules/reference/apply_uniform_styling.md)
then leaves them as they were drawn: the Axes tab's fonts, ticks,
gridlines, and lines are not applied to them, reference lines are not
drawn on them, and they do not count as facets, so the plot's own axis
titles stay draggable. This is the approach for a figure built with
hand-set axis domains, where only the primary `xaxis` and `yaxis` follow
the Axes tab.

## Usage

``` r
mark_overlay_axes(fig, axes)
```

## Arguments

- fig:

  A plotly figure, already built with
  [`plotly::plotly_build()`](https://rdrr.io/pkg/plotly/man/plotly_build.html).

- axes:

  Character vector of layout axis names (`"xaxis2"`, `"yaxis3"`), not
  trace references (`"x2"`, `"y3"`).

## Value

The figure, with `axes` added to any axes already marked.

## Details

Link an overlay panel to the plot with `matches`, as
[`add_marginal_plots()`](https://j-andrews7.github.io/VizModules/reference/add_marginal_plots.md)
does, so it zooms and pans with it.

## See also

[`add_marginal_plots()`](https://j-andrews7.github.io/VizModules/reference/add_marginal_plots.md),
[`apply_uniform_styling()`](https://j-andrews7.github.io/VizModules/reference/apply_uniform_styling.md)

## Author

Jared Andrews

## Examples

``` r
fig <- plotly::plot_ly()
fig <- plotly::add_trace(fig, x = 1:3, y = 1:3, type = "scatter", mode = "lines")
fig <- plotly::add_trace(fig,
    x = 1:3, y = 3:1, type = "scatter", mode = "lines", xaxis = "x2", yaxis = "y2"
)
fig <- plotly::layout(fig,
    xaxis = list(domain = c(0, 1)), yaxis = list(domain = c(0, 0.8)),
    xaxis2 = list(domain = c(0, 1), matches = "x", anchor = "y2"),
    yaxis2 = list(domain = c(0.85, 1))
)
fig <- plotly::plotly_build(fig)
mark_overlay_axes(fig, c("xaxis2", "yaxis2"))

{"x":{"visdat":{"192143fa3a28":["function () ","plotlyVisDat"]},"cur_data":"192143fa3a28","attrs":{"192143fa3a28":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":[1,2,3],"y":[1,2,3],"type":"scatter","mode":"lines","inherit":true},"192143fa3a28.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"x":[1,2,3],"y":[3,2,1],"type":"scatter","mode":"lines","xaxis":"x2","yaxis":"y2","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"title":[]},"yaxis":{"domain":[0,0.80000000000000004],"automargin":true,"title":[]},"xaxis2":{"domain":[0,1],"matches":"x","anchor":"y2"},"yaxis2":{"domain":[0.84999999999999998,1]},"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[1,2,3],"y":[1,2,3],"type":"scatter","mode":"lines","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[1,2,3],"y":[3,2,1],"type":"scatter","mode":"lines","xaxis":"x2","yaxis":"y2","marker":{"color":"rgba(255,127,14,1)","line":{"color":"rgba(255,127,14,1)"}},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"line":{"color":"rgba(255,127,14,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly",".vizmodules_overlay_axes":["xaxis2","yaxis2"]},"evals":[],"jsHooks":[]}
```
