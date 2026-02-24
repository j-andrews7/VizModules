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

  Character, name of the column to use for the slice labels.

- values:

  Character, name of the column to use for the aggregated values (slice
  sizes).

- colors:

  Optional character vector of hex colors for the slices. If named,
  values are matched to the values in `labels`; otherwise colours are
  recycled in data order.

- palette:

  Optional character vector of fallback colors used when `colors` is not
  supplied or missing values are present.

- hole:

  Numeric value between 0 and 1 for the hole size (0 for pie chart, \>0
  for donut chart). Default: 0.

- textinfo:

  Character string specifying the text info to show on slices. Any
  combination of "label", "text", "value", "percent" joined with a "+"
  (e.g., "label+percent") or "none" to hide text. Default:
  "label+percent".

- textposition:

  Character, position of the text relative to the slice. Options:
  "auto", "inside", "outside", or "none". Default: "auto".

- insidetextorientation:

  Character, orientation for inside text. Options: "auto", "horizontal",
  "radial", or "tangential". Default: "auto".

- sort:

  Logical, whether to sort slices by their values in descending order.
  Default: TRUE.

- direction:

  Character, direction of slice progression. Options: "counterclockwise"
  or "clockwise". Default: "counterclockwise".

- rotation:

  Numeric, starting angle of the first slice in degrees (0-360).
  Default: 0.

- show.legend:

  Logical, whether to display the legend. Default: TRUE.

- legend.orientation:

  Character, legend orientation. Options: "h" (horizontal) or "v"
  (vertical). Default: "h".

- legend.x:

  Numeric, horizontal legend position offset (0-1, where 0=left,
  1=right). Default: 0.5.

- legend.y:

  Numeric, vertical legend position offset (-1 to 1). Default: -0.1.

- legend.font.family:

  Character, font family for the legend text. Default: "Arial".

- legend.font.size:

  Numeric, font size for the legend text. Default: 12.

- legend.font.color:

  Character, hex color for the legend text. Default: "#000000".

- title.text:

  Character, main plot title text. Default: "".

- title.font.family:

  Character, font family for the title text. Default: "Arial".

- title.font.size:

  Numeric, font size for the title text. Default: 18.

- title.font.color:

  Character, hex color for the title text. Default: "#000000".

- title.x:

  Numeric, horizontal position for the plot title (0-1, where 0=left,
  0.5=center, 1=right). Default: 0.5.

- text.font.family:

  Character, font family for the slice labels. Default: "Arial".

- text.font.size:

  Numeric, font size for the slice labels. Default: 12.

- text.font.color:

  Character, hex color for the slice labels. Default: "#000000".

- slice.line.color:

  Character, hex color for slice borders. Default: "#FFFFFF" (white).

- slice.line.width:

  Numeric, width of slice borders in pixels. Set to 0 for no borders.
  Default: 0.

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

{"x":{"visdat":{"22385eed3a78":["function () ","plotlyVisDat"]},"cur_data":"22385eed3a78","attrs":{"22385eed3a78":{"labels":{},"values":{},"hole":0,"sort":false,"direction":"counterclockwise","rotation":0,"textinfo":"label+percent","textposition":"auto","insidetextorientation":"auto","marker":{"colors":["#1B9E77","#D95F02","#7570B3"],"line":{"color":"#FFFFFF","width":0}},"textfont":{"family":"Arial","size":12,"color":"#000000"},"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"pie"}},"layout":{"margin":{"b":40,"l":60,"t":80,"r":10},"title":{"text":"Genes by status","font":{"family":"Arial","size":18,"color":"#000000"},"x":0.5,"xanchor":"center","y":0.94999999999999996,"yanchor":"top","pad":{"t":20}},"showlegend":true,"legend":{"orientation":"h","x":0.5,"y":-0.10000000000000001,"font":{"family":"Arial","size":12,"color":"#000000"}},"hovermode":"closest"},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"labels":["Upregulated","Downregulated","Not significant"],"values":[12,7,3],"hole":0,"sort":false,"direction":"counterclockwise","rotation":0,"textinfo":"label+percent","textposition":["auto","auto","auto"],"insidetextorientation":"auto","marker":{"color":"rgba(31,119,180,1)","colors":["#1B9E77","#D95F02","#7570B3"],"line":{"color":"#FFFFFF","width":0}},"textfont":{"family":"Arial","size":12,"color":"#000000"},"type":"pie","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
