# Create a plotly radar chart

Create a plotly radar chart

## Usage

``` r
radarPlot(
  df,
  theta,
  r,
  group = NULL,
  colors = NULL,
  palette = NULL,
  fill = "toself",
  line.width = 2,
  line.dash = "solid",
  marker.size = 5,
  marker.symbol = "circle",
  opacity = 0.6,
  radial.visible = TRUE,
  radial.range = NULL,
  radial.showline = TRUE,
  radial.linecolor = "#444444",
  radial.gridcolor = "#EEEEEE",
  angular.direction = "clockwise",
  angular.rotation = 90,
  angular.gridcolor = "#EEEEEE",
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
  bgcolor = "#FFFFFF",
  polar.bgcolor = "#FFFFFF"
)
```

## Arguments

- df:

  A data frame containing the data to plot. For a single trace, provide
  columns for categories (theta) and values (r). For multiple traces,
  include a grouping column. The function automatically closes the radar
  polygon by adding the first point to the end.

- theta:

  Character, name of the column to use for the angular categories
  (axes).

- r:

  Character, name of the column to use for the radial values.

- group:

  Optional character, name of the column to use for grouping multiple
  traces. If NULL, a single trace is plotted. Default: NULL.

- colors:

  Optional character vector of hex colors for the traces. If named,
  values are matched to the group values; otherwise colours are
  recycled.

- palette:

  Optional character vector of fallback colors used when `colors` is not
  supplied or missing values are present.

- fill:

  Logical or character, whether to fill the area under each trace. Use
  "toself" to fill to the first point, or FALSE for no fill. Default:
  "toself".

- line.width:

  Numeric, width of the trace lines in pixels. Default: 2.

- line.dash:

  Character, line dash style. Options: "solid", "dot", "dash",
  "longdash", "dashdot", "longdashdot". Default: "solid".

- marker.size:

  Numeric, size of the markers on the trace. Default: 5.

- marker.symbol:

  Character, marker symbol. Options: "circle", "square", "diamond",
  "cross", "x", "triangle-up", etc. Default: "circle".

- opacity:

  Numeric, opacity of the traces (0-1). Default: 0.6.

- radial.visible:

  Logical, whether to show the radial axis. Default: TRUE.

- radial.range:

  Optional numeric vector of length 2 specifying the range of the radial
  axis (e.g., c(0, 100)). If NULL, automatically determined. Default:
  NULL.

- radial.showline:

  Logical, whether to show the radial axis line. Default: TRUE.

- radial.linecolor:

  Character, hex color for the radial axis line. Default: "#444444".

- radial.gridcolor:

  Character, hex color for the radial grid lines. Default: "#EEEEEE".

- angular.direction:

  Character, direction of angular axis. Options: "clockwise" or
  "counterclockwise". Default: "clockwise".

- angular.rotation:

  Numeric, rotation angle for the angular axis in degrees. Default: 90.

- angular.gridcolor:

  Character, hex color for the angular grid lines. Default: "#EEEEEE".

- show.legend:

  Logical, whether to display the legend. Default: TRUE.

- legend.orientation:

  Character, legend orientation. Options: "h" (horizontal) or "v"
  (vertical). Default: "h".

- legend.x:

  Numeric, horizontal legend position offset (0-1). Default: 0.5.

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

  Numeric, horizontal position for the plot title (0-1). Default: 0.5.

- bgcolor:

  Character, hex color for the plot background. Default: "#FFFFFF".

- polar.bgcolor:

  Character, hex color for the polar area background. Default:
  "#FFFFFF".

## Value

A plotly object.

## Author

Jacob Martin

## Examples

``` r
# Single trace radar chart
# Note: Polygon is automatically closed by the function
skills <- data.frame(
    category = c("Speed", "Strength", "Defense", "Stamina"),
    value = c(8, 6, 7, 9)
)

radarPlot(
    df = skills,
    theta = "category",
    r = "value",
    title.text = "Player Stats"
)

{"x":{"visdat":{"20f325534c42":["function () ","plotlyVisDat"],"20f373a6701e":["function () ","data"]},"cur_data":"20f373a6701e","attrs":{"20f325534c42":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatterpolar"},"20f373a6701e":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatterpolar","r":{},"theta":{},"mode":"lines+markers","fill":"toself","fillcolor":"#003C30","line":{"color":"#003C30","width":2,"dash":"solid"},"marker":{"color":"#003C30","size":5,"symbol":"circle"},"opacity":0.59999999999999998,"showlegend":false,"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":"Player Stats","font":{"family":"Arial","size":18,"color":"#000000"},"x":0.5,"xanchor":"center"},"polar":{"bgcolor":"#FFFFFF","radialaxis":{"visible":true,"range":[],"showline":true,"linecolor":"#444444","gridcolor":"#EEEEEE"},"angularaxis":{"direction":"clockwise","rotation":90,"gridcolor":"#EEEEEE"}},"showlegend":true,"legend":{"orientation":"h","x":0.5,"y":-0.10000000000000001,"font":{"family":"Arial","size":12,"color":"#000000"}},"paper_bgcolor":"#FFFFFF","hovermode":"closest"},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"type":"scatterpolar","mode":"markers","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"line":{"color":"rgba(31,119,180,1)"},"frame":null},{"fillcolor":"#003C30","type":"scatterpolar","r":[8,6,7,9,8],"theta":["Speed","Strength","Defense","Stamina","Speed"],"mode":"lines+markers","fill":"toself","line":{"color":"#003C30","width":2,"dash":"solid"},"marker":{"color":"#003C30","size":5,"symbol":"circle","line":{"color":"rgba(255,127,14,1)"}},"opacity":0.59999999999999998,"showlegend":false,"name":"#003C30","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
# Multiple trace radar chart
# Note: Polygon is automatically closed for each trace
team_stats <- data.frame(
    category = rep(c("Speed", "Strength", "Defense", "Stamina"), 2),
    value = c(8, 6, 7, 9, 5, 9, 8, 6),
    player = rep(c("Player A", "Player B"), each = 4)
)

radarPlot(
    df = team_stats,
    theta = "category",
    r = "value",
    group = "player",
    title.text = "Team Comparison"
)

{"x":{"visdat":{"20f32a5ed604":["function () ","plotlyVisDat"],"20f3457c6e33":["function () ","data"],"20f3b1724dc":["function () ","data"]},"cur_data":"20f3b1724dc","attrs":{"20f32a5ed604":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatterpolar"},"20f3457c6e33":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatterpolar","r":{},"theta":{},"name":"Player A","mode":"lines+markers","fill":"toself","fillcolor":"#003C30","line":{"color":"#003C30","width":2,"dash":"solid"},"marker":{"color":"#003C30","size":5,"symbol":"circle"},"opacity":0.59999999999999998,"inherit":true},"20f3b1724dc":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatterpolar","r":{},"theta":{},"name":"Player B","mode":"lines+markers","fill":"toself","fillcolor":"#01665E","line":{"color":"#01665E","width":2,"dash":"solid"},"marker":{"color":"#01665E","size":5,"symbol":"circle"},"opacity":0.59999999999999998,"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":"Team Comparison","font":{"family":"Arial","size":18,"color":"#000000"},"x":0.5,"xanchor":"center"},"polar":{"bgcolor":"#FFFFFF","radialaxis":{"visible":true,"range":[],"showline":true,"linecolor":"#444444","gridcolor":"#EEEEEE"},"angularaxis":{"direction":"clockwise","rotation":90,"gridcolor":"#EEEEEE"}},"showlegend":true,"legend":{"orientation":"h","x":0.5,"y":-0.10000000000000001,"font":{"family":"Arial","size":12,"color":"#000000"}},"paper_bgcolor":"#FFFFFF","hovermode":"closest"},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"type":"scatterpolar","mode":"markers","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"line":{"color":"rgba(31,119,180,1)"},"frame":null},{"fillcolor":"#003C30","type":"scatterpolar","r":[8,6,7,9,8],"theta":["Speed","Strength","Defense","Stamina","Speed"],"name":"Player A","mode":"lines+markers","fill":"toself","line":{"color":"#003C30","width":2,"dash":"solid"},"marker":{"color":"#003C30","size":5,"symbol":"circle","line":{"color":"rgba(255,127,14,1)"}},"opacity":0.59999999999999998,"frame":null},{"fillcolor":"#01665E","type":"scatterpolar","r":[5,9,8,6,5],"theta":["Speed","Strength","Defense","Stamina","Speed"],"name":"Player B","mode":"lines+markers","fill":"toself","line":{"color":"#01665E","width":2,"dash":"solid"},"marker":{"color":"#01665E","size":5,"symbol":"circle","line":{"color":"rgba(44,160,44,1)"}},"opacity":0.59999999999999998,"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
