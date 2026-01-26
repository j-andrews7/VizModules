# Create a plotly pie chart

Create a plotly pie chart

## Usage

``` r
piePlot(
  df,
  labels,
  values,
  colors = NULL,
  palette = NULL,
  hole = 0,
  textinfo = "label+percent",
  textposition = "auto",
  insidetextorientation = "auto",
  sort = TRUE,
  direction = "counterclockwise",
  rotation = 0,
  show.legend = TRUE,
  legend.orientation = "h",
  legend.x = 0.5,
  legend.y = -0.1,
  legend.font.family = "Arial",
  legend.font.size = 12,
  legend.font.color = "#000000",
  title.text = "",
  title.font.family = "Arial",
  title.font.size = 18,
  title.font.color = "#000000",
  title.x = 0.5,
  text.font.family = "Arial",
  text.font.size = 12,
  text.font.color = "#000000",
  slice.line.color = "#FFFFFF",
  slice.line.width = 0
)
```

## Arguments

- df:

  A data frame where each row already represents a summarized slice
  (e.g., counts per category) with label and value columns.

- labels:

  Name of the column to use for the slice labels.

- values:

  Name of the column to use for the aggregated values.

- colors:

  Optional character vector of hex colors for the slices. If named,
  values are matched to the values in `labels`; otherwise colours are
  recycled in data order.

- palette:

  Optional character vector of fallback colors used when `colors` is not
  supplied or missing values are present.

- hole:

  A numeric value between 0 and 1 for the hole size (0 for pie, \>0 for
  donut).

- textinfo:

  A character string for the text info to show. Any combination of
  "label", "text", "value", "percent" joined with a "+" or "none".

- textposition:

  Position of the text relative to the slice: "auto", "inside",
  "outside", or "none".

- insidetextorientation:

  Orientation for inside text: "auto", "horizontal", "radial", or
  "tangential".

- sort:

  Logical, whether to sort slices by their values.

- direction:

  Direction of slices: "counterclockwise" or "clockwise".

- rotation:

  Starting angle of the first slice in degrees.

- show.legend:

  Logical, whether to display the legend.

- legend.orientation:

  Legend orientation, either "h" (horizontal) or "v" (vertical).

- legend.x, legend.y:

  Numeric legend position offsets.

- legend.font.family, legend.font.size, legend.font.color:

  Font settings for the legend text.

- title.text:

  Plot title text.

- title.font.family, title.font.size, title.font.color:

  Font settings for the title text.

- title.x:

  Horizontal position for the plot title (0 = left, 1 = right).

- text.font.family, text.font.size, text.font.color:

  Font settings for the slice labels.

- slice.line.color, slice.line.width:

  Border styling for the slices.

## Value

A plotly object.

## Author

Jacob Martin, Jared Andrews

## Examples

``` r
status_counts <- data.frame(
    status = c("Upregulated", "Downregulated", "Not significant"),
    n = c(12, 7, 3)
)

piePlot(
    df = status_counts,
    labels = "status",
    values = "n",
    palette = c("#1B9E77", "#D95F02", "#7570B3"),
    sort = FALSE,
    title.text = "Genes by status"
)

{"x":{"visdat":{"220d3202bc09":["function () ","plotlyVisDat"]},"cur_data":"220d3202bc09","attrs":{"220d3202bc09":{"labels":{},"values":{},"hole":0,"sort":false,"direction":"counterclockwise","rotation":0,"textinfo":"label+percent","textposition":"auto","insidetextorientation":"auto","marker":{"colors":["#1B9E77","#D95F02","#7570B3"],"line":{"color":"#FFFFFF","width":0}},"textfont":{"family":"Arial","size":12,"color":"#000000"},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"pie"}},"layout":{"margin":{"b":40,"l":60,"t":80,"r":10},"title":{"text":"Genes by status","font":{"family":"Arial","size":18,"color":"#000000"},"x":0.5,"xanchor":"center","y":0.94999999999999996,"yanchor":"top","pad":{"t":20}},"showlegend":true,"legend":{"orientation":"h","x":0.5,"y":-0.10000000000000001,"font":{"family":"Arial","size":12,"color":"#000000"}},"hovermode":"closest"},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"labels":["Upregulated","Downregulated","Not significant"],"values":[12,7,3],"hole":0,"sort":false,"direction":"counterclockwise","rotation":0,"textinfo":"label+percent","textposition":["auto","auto","auto"],"insidetextorientation":"auto","marker":{"color":"rgba(31,119,180,1)","colors":["#1B9E77","#D95F02","#7570B3"],"line":{"color":"#FFFFFF","width":0}},"textfont":{"family":"Arial","size":12,"color":"#000000"},"type":"pie","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
