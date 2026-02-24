# Create a plotly ternary plot

Create a plotly ternary plot

## Usage

``` r
ternaryPlot(
  df,
  a,
  b,
  c,
  group = NULL,
  colors = NULL,
  palette = NULL,
  sum = 100,
  mode = "markers",
  marker.size = 8,
  marker.symbol = "circle",
  marker.line.width = 0,
  marker.line.color = "#000000",
  line.width = 2,
  line.dash = "solid",
  opacity = 1,
  a.title = "a",
  b.title = "b",
  c.title = "c",
  a.titlefont.size = 16,
  b.titlefont.size = 16,
  c.titlefont.size = 16,
  a.titlefont.family = "Arial",
  b.titlefont.family = "Arial",
  c.titlefont.family = "Arial",
  a.titlefont.color = "#000000",
  b.titlefont.color = "#000000",
  c.titlefont.color = "#000000",
  a.tickfont.size = 12,
  b.tickfont.size = 12,
  c.tickfont.size = 12,
  a.tickcolor = "rgba(0,0,0,0)",
  b.tickcolor = "rgba(0,0,0,0)",
  c.tickcolor = "rgba(0,0,0,0)",
  a.ticklen = 5,
  b.ticklen = 5,
  c.ticklen = 5,
  a.gridcolor = "#EEEEEE",
  b.gridcolor = "#EEEEEE",
  c.gridcolor = "#EEEEEE",
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
  bgcolor = "#FFFFFF"
)
```

## Arguments

- df:

  A data frame containing the data to plot. Must contain numeric columns
  for the three ternary axes (a, b, c). For multiple traces, include a
  grouping column.

- a:

  Character, name of the column to use for the a-axis (top vertex).

- b:

  Character, name of the column to use for the b-axis (bottom-left
  vertex).

- c:

  Character, name of the column to use for the c-axis (bottom-right
  vertex).

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

- sum:

  Numeric, the constant sum for the ternary axes (e.g., 100 for
  percentages, 1 for proportions). All data points should sum to this
  value. Default: 100.

- mode:

  Character, the trace mode. Options: "markers", "lines",
  "lines+markers". Default: "markers".

- marker.size:

  Numeric, size of the markers on the trace. Default: 8.

- marker.symbol:

  Character, marker symbol. Options: "circle", "square", "diamond",
  "cross", "x", "triangle-up", etc. Default: "circle".

- marker.line.width:

  Numeric, width of the marker border line. Default: 0.

- marker.line.color:

  Character, hex color for the marker border. Default: "#000000".

- line.width:

  Numeric, width of the trace lines in pixels (only used if mode
  includes "lines"). Default: 2.

- line.dash:

  Character, line dash style. Options: "solid", "dot", "dash",
  "longdash", "dashdot", "longdashdot". Default: "solid".

- opacity:

  Numeric, opacity of the traces (0-1). Default: 1.

- a.title:

  Character, title for the a-axis. Default: "a".

- b.title:

  Character, title for the b-axis. Default: "b".

- c.title:

  Character, title for the c-axis. Default: "c".

- a.titlefont.size:

  Numeric, font size for the a-axis title. Default: 16.

- b.titlefont.size:

  Numeric, font size for the b-axis title. Default: 16.

- c.titlefont.size:

  Numeric, font size for the c-axis title. Default: 16.

- a.titlefont.family:

  Character, font family for the a-axis title. Default: "Arial".

- b.titlefont.family:

  Character, font family for the b-axis title. Default: "Arial".

- c.titlefont.family:

  Character, font family for the c-axis title. Default: "Arial".

- a.titlefont.color:

  Character, hex color for the a-axis title. Default: "#000000".

- b.titlefont.color:

  Character, hex color for the b-axis title. Default: "#000000".

- c.titlefont.color:

  Character, hex color for the c-axis title. Default: "#000000".

- a.tickfont.size:

  Numeric, font size for the a-axis tick labels. Default: 12.

- b.tickfont.size:

  Numeric, font size for the b-axis tick labels. Default: 12.

- c.tickfont.size:

  Numeric, font size for the c-axis tick labels. Default: 12.

- a.tickcolor:

  Character, hex color for the a-axis ticks. Default: "rgba(0,0,0,0)".

- b.tickcolor:

  Character, hex color for the b-axis ticks. Default: "rgba(0,0,0,0)".

- c.tickcolor:

  Character, hex color for the c-axis ticks. Default: "rgba(0,0,0,0)".

- a.ticklen:

  Numeric, length of the a-axis ticks. Default: 5.

- b.ticklen:

  Numeric, length of the b-axis ticks. Default: 5.

- c.ticklen:

  Numeric, length of the c-axis ticks. Default: 5.

- a.gridcolor:

  Character, hex color for the a-axis gridlines. Default: "#EEEEEE".

- b.gridcolor:

  Character, hex color for the b-axis gridlines. Default: "#EEEEEE".

- c.gridcolor:

  Character, hex color for the c-axis gridlines. Default: "#EEEEEE".

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

## Value

A plotly object.

## Author

Jacob Martin

## Examples

``` r
# Single trace ternary plot
journalist <- c(75, 70, 75, 5, 10, 10, 20, 10, 15, 10, 20)
developer <- c(25, 10, 20, 60, 80, 90, 70, 20, 5, 10, 10)
designer <- c(0, 20, 5, 35, 10, 0, 10, 70, 80, 80, 70)
label <- c("point 1", "point 2", "point 3", "point 4", "point 5", "point 6",
           "point 7", "point 8", "point 9", "point 10", "point 11")

df <- data.frame(journalist, developer, designer, label)

ternaryPlot(
    df = df,
    a = "journalist",
    b = "developer",
    c = "designer",
    a.title = "Journalist",
    b.title = "Developer",
    c.title = "Designer",
    title.text = "Simple Ternary Plot with Markers"
)

{"x":{"visdat":{"251a4f7d9127":["function () ","plotlyVisDat"]},"cur_data":"251a4f7d9127","attrs":{"251a4f7d9127":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatterternary","mode":"markers","a":[75,70,75,5,10,10,20,10,15,10,20],"b":[25,10,20,60,80,90,70,20,5,10,10],"c":[0,20,5,35,10,0,10,70,80,80,70],"marker":{"size":8,"symbol":"circle","color":"#1F77B4","opacity":1,"line":{"width":0,"color":"#000000"}},"showlegend":false,"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":"Simple Ternary Plot with Markers","font":{"family":"Arial","size":18,"color":"#000000"},"x":0.5,"automargin":true},"ternary":{"sum":100,"aaxis":{"title":"Journalist","titlefont":{"size":16,"family":"Arial","color":"#000000"},"tickfont":{"size":12},"tickcolor":"rgba(0,0,0,0)","ticklen":5,"gridcolor":"#EEEEEE"},"baxis":{"title":"Developer","titlefont":{"size":16,"family":"Arial","color":"#000000"},"tickfont":{"size":12},"tickcolor":"rgba(0,0,0,0)","ticklen":5,"gridcolor":"#EEEEEE"},"caxis":{"title":"Designer","titlefont":{"size":16,"family":"Arial","color":"#000000"},"tickfont":{"size":12},"tickcolor":"rgba(0,0,0,0)","ticklen":5,"gridcolor":"#EEEEEE"},"bgcolor":"#FFFFFF"},"legend":{"orientation":"h","x":0.5,"y":-0.10000000000000001,"font":{"family":"Arial","size":12,"color":"#000000"}},"paper_bgcolor":"#FFFFFF","hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"type":"scatterternary","mode":"markers","a":[75,70,75,5,10,10,20,10,15,10,20],"b":[25,10,20,60,80,90,70,20,5,10,10],"c":[0,20,5,35,10,0,10,70,80,80,70],"marker":{"color":"#1F77B4","size":8,"symbol":"circle","opacity":1,"line":{"color":"#000000","width":0}},"showlegend":false,"line":{"color":"rgba(31,119,180,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
# Multiple trace ternary plot with grouping
team_data <- data.frame(
    journalist = c(75, 70, 75, 5, 10, 10),
    developer = c(25, 10, 20, 60, 80, 90),
    designer = c(0, 20, 5, 35, 10, 0),
    team = rep(c("Team A", "Team B"), each = 3)
)

ternaryPlot(
    df = team_data,
    a = "journalist",
    b = "developer",
    c = "designer",
    group = "team",
    a.title = "Journalist",
    b.title = "Developer",
    c.title = "Designer",
    title.text = "Team Comparison"
)

{"x":{"visdat":{"251a72f222c2":["function () ","plotlyVisDat"]},"cur_data":"251a72f222c2","attrs":{"251a72f222c2":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatterternary","mode":"markers","a":[75,70,75],"b":[25,10,20],"c":[0,20,5],"name":"Team A","marker":{"size":8,"symbol":"circle","color":"#1F77B4","opacity":1,"line":{"width":0,"color":"#000000"}},"showlegend":true,"inherit":true},"251a72f222c2.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatterternary","mode":"markers","a":[5,10,10],"b":[60,80,90],"c":[35,10,0],"name":"Team B","marker":{"size":8,"symbol":"circle","color":"#FF7F0E","opacity":1,"line":{"width":0,"color":"#000000"}},"showlegend":true,"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"text":"Team Comparison","font":{"family":"Arial","size":18,"color":"#000000"},"x":0.5,"automargin":true},"ternary":{"sum":100,"aaxis":{"title":"Journalist","titlefont":{"size":16,"family":"Arial","color":"#000000"},"tickfont":{"size":12},"tickcolor":"rgba(0,0,0,0)","ticklen":5,"gridcolor":"#EEEEEE"},"baxis":{"title":"Developer","titlefont":{"size":16,"family":"Arial","color":"#000000"},"tickfont":{"size":12},"tickcolor":"rgba(0,0,0,0)","ticklen":5,"gridcolor":"#EEEEEE"},"caxis":{"title":"Designer","titlefont":{"size":16,"family":"Arial","color":"#000000"},"tickfont":{"size":12},"tickcolor":"rgba(0,0,0,0)","ticklen":5,"gridcolor":"#EEEEEE"},"bgcolor":"#FFFFFF"},"legend":{"orientation":"h","x":0.5,"y":-0.10000000000000001,"font":{"family":"Arial","size":12,"color":"#000000"}},"paper_bgcolor":"#FFFFFF","hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"type":"scatterternary","mode":"markers","a":[75,70,75],"b":[25,10,20],"c":[0,20,5],"name":"Team A","marker":{"color":"#1F77B4","size":8,"symbol":"circle","opacity":1,"line":{"color":"#000000","width":0}},"showlegend":true,"line":{"color":"rgba(31,119,180,1)"},"frame":null},{"type":"scatterternary","mode":"markers","a":[5,10,10],"b":[60,80,90],"c":[35,10,0],"name":"Team B","marker":{"color":"#FF7F0E","size":8,"symbol":"circle","opacity":1,"line":{"color":"#000000","width":0}},"showlegend":true,"line":{"color":"rgba(255,127,14,1)"},"frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
