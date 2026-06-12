# Apply statistical annotation shapes and annotations to a plotly figure

Appends the shapes and annotations from
[`create_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_stat_annotations.md)
to an existing plotly figure's layout. Adjusts the y-axis range to
accommodate the annotation brackets.

## Usage

``` r
apply_stat_annotations(fig, stat_result, y.min = NULL)
```

## Arguments

- fig:

  A plotly figure object.

- stat_result:

  List with `annotations`, `shapes`, and `y.max` as returned by
  [`create_stat_annotations()`](https://j-andrews7.github.io/VizModules/reference/create_stat_annotations.md).

- y.min:

  Numeric or NULL; minimum y-axis value. If NULL, the existing y-axis
  range is preserved.

## Value

The modified plotly figure.

## Author

Jared Andrews

## Examples

``` r
stats_df <- compute_pairwise_stats(
    df = example_iris,
    x = "Species",
    y = "Sepal.Length",
    test = "wilcox.test"
)
fig <- plotly::plot_ly(
    data = example_iris, x = ~Species, y = ~Sepal.Length, type = "box"
)
stat_result <- create_stat_annotations(
    stats_df = stats_df,
    fig = fig,
    df = example_iris,
    x = "Species",
    y = "Sepal.Length",
    display = "symbol"
)
apply_stat_annotations(fig, stat_result)

{"x":{"visdat":{"20fc4fb886e7":["function () ","plotlyVisDat"]},"cur_data":"20fc4fb886e7","attrs":{"20fc4fb886e7":{"x":{},"y":{},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"box"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"shapes":[{"type":"line","line":{"color":"#000000","width":1},"xref":"x","yref":"y","x0":1.0249999999999999,"x1":1.0249999999999999,"y0":8.0440000000000005,"y1":8.1159999999999997},{"type":"line","line":{"color":"#000000","width":1},"xref":"x","yref":"y","x0":1.0249999999999999,"x1":1.9750000000000001,"y0":8.1159999999999997,"y1":8.1159999999999997},{"type":"line","line":{"color":"#000000","width":1},"xref":"x","yref":"y","x0":1.9750000000000001,"x1":1.9750000000000001,"y0":8.0440000000000005,"y1":8.1159999999999997},{"type":"line","line":{"color":"#000000","width":1},"xref":"x","yref":"y","x0":2.0249999999999999,"x1":2.0249999999999999,"y0":8.0440000000000005,"y1":8.1159999999999997},{"type":"line","line":{"color":"#000000","width":1},"xref":"x","yref":"y","x0":2.0249999999999999,"x1":2.9750000000000001,"y0":8.1159999999999997,"y1":8.1159999999999997},{"type":"line","line":{"color":"#000000","width":1},"xref":"x","yref":"y","x0":2.9750000000000001,"x1":2.9750000000000001,"y0":8.0440000000000005,"y1":8.1159999999999997},{"type":"line","line":{"color":"#000000","width":1},"xref":"x","yref":"y","x0":1.0249999999999999,"x1":1.0249999999999999,"y0":8.2600000000000016,"y1":8.3320000000000007},{"type":"line","line":{"color":"#000000","width":1},"xref":"x","yref":"y","x0":1.0249999999999999,"x1":2.9750000000000001,"y0":8.3320000000000007,"y1":8.3320000000000007},{"type":"line","line":{"color":"#000000","width":1},"xref":"x","yref":"y","x0":2.9750000000000001,"x1":2.9750000000000001,"y0":8.2600000000000016,"y1":8.3320000000000007}],"annotations":[{"text":"****","x":1.5,"y":8.2599999999999998,"xref":"x","yref":"y","showarrow":false,"font":{"size":12,"color":"#000000"}},{"text":"****","x":2.5,"y":8.2599999999999998,"xref":"x","yref":"y","showarrow":false,"font":{"size":12,"color":"#000000"}},{"text":"****","x":2,"y":8.4760000000000009,"xref":"x","yref":"y","showarrow":false,"font":{"size":12,"color":"#000000"}}],"yaxis":{"domain":[0,1],"automargin":true,"range":8.6920000000000002,"title":"Sepal.Length"},"xaxis":{"domain":[0,1],"automargin":true,"title":"Species","type":"category","categoryorder":"array","categoryarray":["setosa","versicolor","virginica"]},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"fillcolor":"rgba(31,119,180,0.5)","x":["setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","setosa","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","versicolor","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica","virginica"],"y":[5.0999999999999996,4.9000000000000004,4.7000000000000002,4.5999999999999996,5,5.4000000000000004,4.5999999999999996,5,4.4000000000000004,4.9000000000000004,5.4000000000000004,4.7999999999999998,4.7999999999999998,4.2999999999999998,5.7999999999999998,5.7000000000000002,5.4000000000000004,5.0999999999999996,5.7000000000000002,5.0999999999999996,5.4000000000000004,5.0999999999999996,4.5999999999999996,5.0999999999999996,4.7999999999999998,5,5,5.2000000000000002,5.2000000000000002,4.7000000000000002,4.7999999999999998,5.4000000000000004,5.2000000000000002,5.5,4.9000000000000004,5,5.5,4.9000000000000004,4.4000000000000004,5.0999999999999996,5,4.5,4.4000000000000004,5,5.0999999999999996,4.7999999999999998,5.0999999999999996,4.5999999999999996,5.2999999999999998,5,7,6.4000000000000004,6.9000000000000004,5.5,6.5,5.7000000000000002,6.2999999999999998,4.9000000000000004,6.5999999999999996,5.2000000000000002,5,5.9000000000000004,6,6.0999999999999996,5.5999999999999996,6.7000000000000002,5.5999999999999996,5.7999999999999998,6.2000000000000002,5.5999999999999996,5.9000000000000004,6.0999999999999996,6.2999999999999998,6.0999999999999996,6.4000000000000004,6.5999999999999996,6.7999999999999998,6.7000000000000002,6,5.7000000000000002,5.5,5.5,5.7999999999999998,6,5.4000000000000004,6,6.7000000000000002,6.2999999999999998,5.5999999999999996,5.5,5.5,6.0999999999999996,5.7999999999999998,5,5.5999999999999996,5.7000000000000002,5.7000000000000002,6.2000000000000002,5.0999999999999996,5.7000000000000002,6.2999999999999998,5.7999999999999998,7.0999999999999996,6.2999999999999998,6.5,7.5999999999999996,4.9000000000000004,7.2999999999999998,6.7000000000000002,7.2000000000000002,6.5,6.4000000000000004,6.7999999999999998,5.7000000000000002,5.7999999999999998,6.4000000000000004,6.5,7.7000000000000002,7.7000000000000002,6,6.9000000000000004,5.5999999999999996,7.7000000000000002,6.2999999999999998,6.7000000000000002,7.2000000000000002,6.2000000000000002,6.0999999999999996,6.4000000000000004,7.2000000000000002,7.4000000000000004,7.9000000000000004,6.4000000000000004,6.2999999999999998,6.0999999999999996,7.7000000000000002,6.2999999999999998,6.4000000000000004,6,6.9000000000000004,6.7000000000000002,6.9000000000000004,5.7999999999999998,6.7999999999999998,6.7000000000000002,6.7000000000000002,6.2999999999999998,6.5,6.2000000000000002,5.9000000000000004],"type":"box","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
