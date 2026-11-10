# Apply the uniform styling inputs to a module's figure

The plot modules build their figures in two steps. The first draws the
plot itself from the data and every input that changes what is drawn;
that is the expensive part (a ggplot built and converted with
[`plotly::ggplotly()`](https://rdrr.io/pkg/plotly/man/ggplotly.html),
say), and it is cached. This function is the second step: it applies the
inputs that only style the figure – titles, fonts, ticks and their
notation, gridlines, the padding around the data, reference lines, the
modebar, the shape-drawing tool, and the legend – to the figure the
first step returned. Changing one of those inputs re-runs only this
step, which takes a few milliseconds rather than a full rebuild.

## Usage

``` r
apply_uniform_styling(
  fig,
  input,
  isolate_fn = isolate,
  facet.by = NULL,
  title_y = 0.95,
  include.modebar.buttons = TRUE,
  fig.fn = NULL,
  ggplot.axis.styling = TRUE,
  legend.position = NULL,
  padding.axes = c("x", "y")
)
```

## Arguments

- fig:

  A plotly figure: the module's plot, before styling.

- input:

  The module's Shiny `input`, holding the uniform inputs from
  [`uniform_axes_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_axes_inputs_ui.md),
  [`uniform_lines_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_lines_inputs_ui.md),
  [`uniform_plotly_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_plotly_inputs_ui.md),
  and
  [`uniform_legend_inputs_ui()`](https://j-andrews7.github.io/VizModules/reference/uniform_legend_inputs_ui.md).

- isolate_fn:

  The function from
  [`setup_auto_update_logic()`](https://j-andrews7.github.io/VizModules/reference/setup_auto_update_logic.md)
  that every input read goes through.

- facet.by:

  The facetting column(s), or `NULL`. A faceted figure has shared axis
  titles drawn as annotations, which are styled to match, and no main
  title (see
  [`add_plot_config()`](https://j-andrews7.github.io/VizModules/reference/add_plot_config.md)).

- title_y:

  Vertical position of the main title, in paper coordinates.

- include.modebar.buttons:

  Passed to
  [`add_plot_config()`](https://j-andrews7.github.io/VizModules/reference/add_plot_config.md).

- fig.fn:

  Optional `function(fig, input, isolate_fn)` returning the figure, run
  after the legend is styled and before the axis titles become draggable
  annotations, so any axis title text it sets is the one made draggable.
  Read inputs in it as `isolate_fn(input$key)`. It runs after any
  overlay panels are drawn, so anything it places on `"paper"`
  coordinates can land on them; use `xref = "x domain"` and
  `yref = "y domain"` to stay within the plot's panel.

- ggplot.axis.styling:

  Passed to
  [`create_axis_styles()`](https://j-andrews7.github.io/VizModules/reference/create_axis_styles.md).
  `TRUE` for a figure whose axis lines come from its ggplot theme (see
  [`create_ggplot_axis_style()`](https://j-andrews7.github.io/VizModules/reference/create_ggplot_axis_style.md));
  `FALSE` sets them from the Axes inputs here.

- legend.position:

  Passed to
  [`apply_legend_inputs()`](https://j-andrews7.github.io/VizModules/reference/apply_legend_inputs.md);
  `NULL` keeps the legend where it is.

- padding.axes:

  Which of the module's axes, `"x"` and `"y"`, take the
  `axis.padding.x`/`axis.padding.y` inputs (see
  [`apply_axis_padding()`](https://j-andrews7.github.io/VizModules/reference/apply_axis_padding.md)).
  Leave out an axis with its own limit inputs, so its limits stand. When
  `input$rotate` is `TRUE` the padding follows the variables onto the
  swapped axes.

## Value

The styled plotly figure.

## Details

The figure passed in is never modified (R copies on write), so each call
styles the cached figure afresh and nothing appended here (reference
lines, say) accumulates across calls.

Axes used only by overlay panels drawn alongside the plot (the scatter
plot's marginal distributions, see
[`add_marginal_plots()`](https://j-andrews7.github.io/VizModules/reference/add_marginal_plots.md))
keep their own styling and get no reference lines.

## See also

[`apply_title_layout()`](https://j-andrews7.github.io/VizModules/reference/apply_title_layout.md),
[`apply_subplot_axis_styling()`](https://j-andrews7.github.io/VizModules/reference/apply_subplot_axis_styling.md),
[`apply_tick_notation()`](https://j-andrews7.github.io/VizModules/reference/apply_tick_notation.md),
[`apply_axis_padding()`](https://j-andrews7.github.io/VizModules/reference/apply_axis_padding.md),
[`add_reference_lines()`](https://j-andrews7.github.io/VizModules/reference/add_reference_lines.md),
[`add_plot_config()`](https://j-andrews7.github.io/VizModules/reference/add_plot_config.md),
[`apply_plotly_newshape()`](https://j-andrews7.github.io/VizModules/reference/apply_plotly_newshape.md),
[`apply_legend_inputs()`](https://j-andrews7.github.io/VizModules/reference/apply_legend_inputs.md),
[`axis_titles_as_annotations()`](https://j-andrews7.github.io/VizModules/reference/axis_titles_as_annotations.md)

## Author

Jared Andrews

## Examples

``` r
fig <- plotly::plot_ly(mtcars, x = ~wt, y = ~mpg, type = "scatter", mode = "markers")
# The uniform inputs, as a module's `input` would hold them.
input <- list(
    title.font.size = 20, title.font.family = "Arial", title.font.color = "#000000",
    axis.title.horizontal.position = 0.5, axis.title.font.size = 16,
    axis.title.font.family = "Arial", axis.title.font.color = "#000000",
    axis.tickfont.size = 12, axis.tickfont.family = "Arial", axis.tickfont.color = "#000000",
    axis.tickangle.x = 0, axis.tickangle.y = 0, axis.ticks = "outside",
    axis.tickcolor = "#000000", axis.ticklen = 5, axis.tickwidth = 1,
    show.grid.x = TRUE, show.grid.y = FALSE, grid.color = "#CCCCCC",
    hline.intercepts = "20", hline.colors = "#D55E00",
    download.format = "svg", legend.text.size = 12, legend.title.size = 14
)
apply_uniform_styling(fig, input, isolate_fn = identity)

{"x":{"visdat":{"19211c808f4e":["function () ","plotlyVisDat"]},"cur_data":"19211c808f4e","attrs":{"19211c808f4e":{"x":{},"y":{},"mode":"markers","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":{"font":{"size":20,"family":"Arial","color":"#000000"},"x":0.5,"xanchor":"center","y":0.94999999999999996,"yanchor":"top"},"xaxis":{"domain":[0,1],"automargin":true,"title":{"font":{"size":16,"family":"Arial","color":"#000000"}},"tickfont":{"size":12,"color":"#000000","family":"Arial"},"tickangle":0,"ticks":"outside","tickcolor":"#000000","ticklen":5,"tickwidth":1,"showgrid":true,"gridcolor":"#CCCCCC"},"yaxis":{"domain":[0,1],"automargin":true,"title":{"font":{"size":16,"family":"Arial","color":"#000000"}},"tickfont":{"size":12,"color":"#000000","family":"Arial"},"tickangle":0,"ticks":"outside","tickcolor":"#000000","ticklen":5,"tickwidth":1,"showgrid":false,"gridcolor":"#CCCCCC"},"hovermode":"closest","showlegend":false,"shapes":[{"type":"line","x0":0,"x1":1,"xref":"x domain","y0":20,"y1":20,"yref":"y","line":{"color":"#D55E00","width":1,"dash":"solid"},"opacity":1}],"newshape":{"fillcolor":[],"line":{"color":[],"width":[],"dash":[]},"opacity":[]},"legend":{"font":{"size":12},"title":{"font":{"size":14}},"grouptitlefont":{"size":14}}},"source":"A","config":{"modeBarButtonsToAdd":["drawline","drawopenpath","drawclosedpath","drawcircle","drawrect","eraseshape","hoverclosest","hovercompare"],"showSendToCloud":false,"edits":{"axisTitleText":false,"titleText":true,"annotationText":true,"legendText":true,"legendPosition":true,"colorbarPosition":true,"colorbarTitleText":true,"annotationTail":true,"annotationPosition":true},"toImageButtonOptions":{"format":"svg","filename":"2026-11-10"},"displaylogo":false},"data":[{"x":[2.6200000000000001,2.875,2.3199999999999998,3.2149999999999999,3.4399999999999999,3.46,3.5699999999999998,3.1899999999999999,3.1499999999999999,3.4399999999999999,3.4399999999999999,4.0700000000000003,3.73,3.7799999999999998,5.25,5.4240000000000004,5.3449999999999998,2.2000000000000002,1.615,1.835,2.4649999999999999,3.52,3.4350000000000001,3.8399999999999999,3.8450000000000002,1.9350000000000001,2.1400000000000001,1.5129999999999999,3.1699999999999999,2.77,3.5699999999999998,2.7799999999999998],"y":[21,21,22.800000000000001,21.399999999999999,18.699999999999999,18.100000000000001,14.300000000000001,24.399999999999999,22.800000000000001,19.199999999999999,17.800000000000001,16.399999999999999,17.300000000000001,15.199999999999999,10.4,10.4,14.699999999999999,32.399999999999999,30.399999999999999,33.899999999999999,21.5,15.5,15.199999999999999,13.300000000000001,19.199999999999999,27.300000000000001,26,30.399999999999999,15.800000000000001,19.699999999999999,15,21.399999999999999],"mode":"markers","type":"scatter","marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly",".vizmodules_built":true},"evals":[],"jsHooks":[]}
```
