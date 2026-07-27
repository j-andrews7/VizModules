# Convert native cartesian axis titles to draggable annotations

Plotly's native axis titles can have their text edited interactively but
cannot be dragged to a new position. Faceted figures already render
their shared x/y axis titles as paper-anchored annotations (via
[`build_facet_annotations()`](https://j-andrews7.github.io/VizModules/reference/build_facet_annotations.md)),
which the plot configuration makes both editable and draggable. This
helper brings the same behaviour to single-panel (non-faceted) figures
by replacing the native x/y axis titles with equivalent paper-anchored
annotations.

## Usage

``` r
axis_titles_as_annotations(fig)
```

## Arguments

- fig:

  A plotly figure object.

## Value

The plotly figure with single-panel axis titles converted to
paper-anchored, draggable annotations. Returns the figure unchanged when
it is faceted/split or has no axis titles.

## Details

The figure is first built with
[`plotly::plotly_build()`](https://rdrr.io/pkg/plotly/man/plotly_build.html)
so that titles assigned via `layout()` (which are otherwise held in
`layoutAttrs` until build time) are consolidated into the layout. Any
pre-existing annotations (for example statistical brackets or facet
labels) are preserved, and the font already applied to each native axis
title is carried over to the corresponding annotation.

Multi-panel figures (faceting or `split.by`, detected by the presence of
secondary axes such as `xaxis2`/`yaxis2`) are returned unchanged, since
their shared titles are already draggable annotations.

## Author

Jared Andrews

## Examples

``` r
fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
fig <- plotly::layout(fig, xaxis = list(title = "Weight"), yaxis = list(title = "MPG"))
axis_titles_as_annotations(fig)

{"x":{"visdat":{"19a8766c7202":["function () ","plotlyVisDat"]},"cur_data":"19a8766c7202","attrs":{"19a8766c7202":{"x":{},"y":{},"mode":"markers","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"xaxis":{"domain":[0,1],"automargin":true,"title":{"text":""}},"yaxis":{"domain":[0,1],"automargin":true,"title":{"text":""}},"hovermode":"closest","showlegend":false,"annotations":[{"x":0.5,"y":-0.10000000000000001,"xref":"paper","yref":"paper","text":"Weight","showarrow":false,"xanchor":"center","yanchor":"top","annotationType":"axis","font":null},{"x":-0.050000000000000003,"y":0.5,"xref":"paper","yref":"paper","text":"MPG","showarrow":false,"xanchor":"center","yanchor":"middle","textangle":-90,"annotationType":"axis","font":null}]},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[2.6200000000000001,2.875,2.3199999999999998,3.2149999999999999,3.4399999999999999,3.46,3.5699999999999998,3.1899999999999999,3.1499999999999999,3.4399999999999999,3.4399999999999999,4.0700000000000003,3.73,3.7799999999999998,5.25,5.4240000000000004,5.3449999999999998,2.2000000000000002,1.615,1.835,2.4649999999999999,3.52,3.4350000000000001,3.8399999999999999,3.8450000000000002,1.9350000000000001,2.1400000000000001,1.5129999999999999,3.1699999999999999,2.77,3.5699999999999998,2.7799999999999998],"y":[21,21,22.800000000000001,21.399999999999999,18.699999999999999,18.100000000000001,14.300000000000001,24.399999999999999,22.800000000000001,19.199999999999999,17.800000000000001,16.399999999999999,17.300000000000001,15.199999999999999,10.4,10.4,14.699999999999999,32.399999999999999,30.399999999999999,33.899999999999999,21.5,15.5,15.199999999999999,13.300000000000001,19.199999999999999,27.300000000000001,26,30.399999999999999,15.800000000000001,19.699999999999999,15,21.399999999999999],"mode":"markers","type":"scatter","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
