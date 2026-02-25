# Input UI components for the scatterPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.md)
and
[`dittoViz_scatterPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotOutputUI.md)
functions.

## Usage

``` r
dittoViz_scatterPlotInputsUI(
  id,
  data,
  defaults = NULL,
  title = NULL,
  columns = 2
)
```

## Arguments

- id:

  The ID for the Shiny module.

- data:

  The data frame used for plot generation.

- defaults:

  A named list of default values for the inputs.

- title:

  An optional title for the UI grid.

- columns:

  Number of columns for the UI grid.

## Value

A Shiny tagList containing the UI elements

## Details

The user inputs for this module are separated from the outputs to allow
for more flexible UI design.

The inputs will automatically be organized into a grid layout via the
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md)
function, with `columns` controlling the number of columns in the grid.

Defaults can be set for each input by providing a named list of values
to the `defaults` argument. Nearly all parameters for
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
can be set via these inputs, so see the help for that function for an
exhaustive list.

Note that some of the parameters may have input types that differ from
the actual function, e.g. `shape.panel` is a text input for
comma-separated integers, while the function expects a vector of
integers. The module will parse such inputs into the appropriate format
for
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
automatically.

## Plot parameters not implemented or with altered functionality

The following
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
parameters are not available via UI inputs or have been superseded:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (plotly allows interactive editing)

- `main` - Plot title (plotly allows interactive editing)

- `sub` - Plot subtitle (not supported in plotly)

- `theme` - ggplot2 theme (not applicable to plotly)

- `legend.title` - Legend title (managed by plotly interactively)

- `add.xline` - Use `vline.intercepts` instead for vertical lines with
  full styling options

- `add.yline` - Use `hline.intercepts` instead for horizontal lines with
  full styling options

- `xline.linetype` - Use `vline.linetypes` instead

- `xline.color` - Use `vline.colors` instead

- `yline.linetype` - Use `hline.linetypes` instead

- `yline.color` - Use `hline.colors` instead

- `do.letter` - Lettering subplots (not implemented for plotly)

- `do.label` - Labeling points interactively (not compatible with plotly
  hover)

The new Lines tab provides enhanced functionality including multiple
lines per type, individual line widths, opacities, and diagonal/ablines
with slope control.

## Plot parameters and defaults

The following
[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `x.by` - X-axis variable (UI: "X Data", default: 2nd column)

- `y.by` - Y-axis variable (UI: "Y Data", default: 3rd column)

- `color.by` - Coloring variable (UI: "Color By", default: "")

- `shape.by` - Shape variable (UI: "Shape By", default: "")

- `split.by` - Faceting variable (UI: "Split By", default: "")

- `rows.use` - Row filter expression (UI: "Rows Filter", default: "")

- `x.adjustment` - X-axis adjustment (UI: "X Adjustment", default: "")

- `y.adjustment` - Y-axis adjustment (UI: "Y Adjustment", default: "")

- `color.adjustment` - Color adjustment (UI: "Color Adjustment",
  default: "")

- `x.adj.fxn` - X adjustment function (UI: "X Adjustment Function",
  default: "")

- `y.adj.fxn` - Y adjustment function (UI: "Y Adjustment Function",
  default: "")

- `color.adj.fxn` - Color adjustment function (UI: "Color Adjustment
  Function", default: "")

- `size` - Point size (UI: "Point Size", default: 1)

- `opacity` - Point opacity (UI: "Point Opacity", default: 1)

- `show.others` - Show others (UI: "Show Others", default: TRUE)

- `split.show.all.others` - Show split others (UI: "Show Split Others",
  default: TRUE)

- `plot.order` - Plot order (UI: "Plot Order", default: "unordered")

- `shape.panel` - Shape panel values (UI: "Shape Panel", default: "16,
  15, 17, 23, 25, 8")

- `min.color` - Minimum color (UI: "Min Color", default: "#F0E442")

- `max.color` - Maximum color (UI: "Max Color", default: "#0072B2")

- `contour.color` - Contour color (UI: "Contour Color", default:
  "black")

- `contour.linetype` - Contour linetype (UI: "Contour Linetype",
  default: "solid")

- `color.panel` - Custom color values (UI: color.panel.ui, derived from
  palette)

- `split.nrow` - Number of split rows (UI: "Split Rows", default: NA)

- `split.ncol` - Number of split columns (UI: "Split Columns", default:
  NA)

- `multivar.split.dir` - Multivar split direction (UI: "Multivar Split
  Dir", default: "col")

- `split.adjust.scales` - Facet scales (UI: "Facet Scales", default:
  "fixed")

- `annotate.by` - Annotate by column (UI: "Annotate By", default: "")

- `highlight.points` - Points to highlight (UI: "Points to Highlight",
  default: "")

- `highlight.color` - Highlight fill (UI: "Highlight Fill", default:
  "#00FFF7")

- `highlight.size` - Highlight size (UI: "Highlight Size", default: 7)

- `highlight.border.color` - Highlight border color (UI: "Highlight
  Border Color", default: "#000000")

- `highlight.border.width` - Highlight border width (UI: "Highlight
  Border Width", default: 1)

- `highlight.auto.annotate` - Auto-annotate highlights (UI:
  "Auto-annotate Highlights", default: TRUE)

- `annotation.color` - Annotation color (UI: "Annotation Color",
  default: "black")

- `annotation.ax` - Annotation X offset (UI: "Annotation X Offset",
  default: 20)

- `annotation.ay` - Annotation Y offset (UI: "Annotation Y Offset",
  default: -20)

- `annotation.size` - Annotation size (UI: "Annotation Size", default:
  10)

- `annotation.showarrow` - Show arrow (UI: "Show Arrow", default: TRUE)

- `annotation.arrowcolor` - Arrow color (UI: "Arrow Color", default:
  "black")

- `annotation.arrowhead` - Arrowhead style (UI: "Arrowhead Style",
  default: 2)

- `annotation.arrowwidth` - Arrow linewidth (UI: "Arrow Linewidth",
  default: 1.5)

- `legend.show` - Show legend (UI: "Show Legend", default: TRUE)

- `legend.color.title` - Legend title (UI: "Legend Title", default:
  "make")

- `legend.color.size` - Legend color size (UI: "Legend Color Size",
  default: 5)

- `legend.shape.size` - Legend shape size (UI: "Legend Shape Size",
  default: 5)

- `legend.color.breaks` - Legend tick breaks (UI: "Legend Tick Breaks",
  default: "")

- `min.value` - Minimum value (UI: "Min Value", default: NA)

- `max.value` - Maximum value (UI: "Max Value", default: NA)

- `trajectory.group.by` - Trajectory group by (UI: "Trajectory Group
  By", default: "")

- `add.trajectory.by.groups` - Add trajectory by groups (UI: "Add
  Trajectory By Groups", default: "")

- `trajectory.arrow.size` - Trajectory arrow size (UI: "Trajectory Arrow
  Size", default: 0.15)

- `do.ellipse` - Enable ellipses (UI: "Enable Ellipses", default: FALSE)

- `do.contour` - Enable contour (UI: "Enable Contour", default: FALSE)

- `hover.data` - Hover data columns (UI: "Hover Data", default: "")

- `hover.round.digits` - Hover round digits (UI: "Hover Round Digits",
  default: 5)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `webgl` - Plot with webGL (UI: "Plot with webGL", default: TRUE)

- `shape.fill` - Shape fill color (UI: "Shape Fill", default: "rgba(0,
  0, 0, 0)")

- `shape.line.color` - Shape line color (UI: "Shape Line Color",
  default: "black")

- `shape.line.width` - Shape line width (UI: "Shape Line Width",
  default: 4)

- `shape.linetype` - Shape linetype (UI: "Shape Linetype", default:
  "solid")

- `shape.opacity` - Shape opacity (UI: "Shape Opacity", default: 1)

- `axis.title.font.size` - Axis title font size (UI: via
  .uniform_axes_inputs_ui)

- `axis.title.font.color` - Axis title font color (UI: via
  .uniform_axes_inputs_ui)

- `axis.title.font.family` - Axis title font family (UI: via
  .uniform_axes_inputs_ui)

- `axis.showline` - Show axis lines (UI: via .uniform_axes_inputs_ui)

- `axis.mirror` - Mirror axis lines (UI: via .uniform_axes_inputs_ui)

- `show.grid.x` - Show X gridlines (UI: via .uniform_axes_inputs_ui)

- `show.grid.y` - Show Y gridlines (UI: via .uniform_axes_inputs_ui)

- `axis.linecolor` - Axis line color (UI: via .uniform_axes_inputs_ui)

- `axis.linewidth` - Axis line width (UI: via .uniform_axes_inputs_ui)

- `axis.tickfont.size` - Tick label size (UI: via
  .uniform_axes_inputs_ui)

- `axis.tickfont.color` - Tick label color (UI: via
  .uniform_axes_inputs_ui)

- `axis.tickfont.family` - Tick label font (UI: via
  .uniform_axes_inputs_ui)

- `axis.tickangle.x` - X-axis tick angle (UI: via
  .uniform_axes_inputs_ui)

- `axis.tickangle.y` - Y-axis tick angle (UI: via
  .uniform_axes_inputs_ui)

- `axis.ticks` - Tick position (UI: via .uniform_axes_inputs_ui)

- `axis.tickcolor` - Tick mark color (UI: via .uniform_axes_inputs_ui)

- `axis.ticklen` - Tick mark length (UI: via .uniform_axes_inputs_ui)

- `axis.tickwidth` - Tick mark width (UI: via .uniform_axes_inputs_ui)

- `hline.intercepts` - Horizontal line Y-intercepts (UI: via
  .uniform_lines_inputs_ui)

- `hline.colors` - Horizontal line colors (UI: via
  .uniform_lines_inputs_ui)

- `hline.widths` - Horizontal line widths (UI: via
  .uniform_lines_inputs_ui)

- `hline.linetypes` - Horizontal line types (UI: via
  .uniform_lines_inputs_ui)

- `hline.opacities` - Horizontal line opacities (UI: via
  .uniform_lines_inputs_ui)

- `vline.intercepts` - Vertical line X-intercepts (UI: via
  .uniform_lines_inputs_ui)

- `vline.colors` - Vertical line colors (UI: via
  .uniform_lines_inputs_ui)

- `vline.widths` - Vertical line widths (UI: via
  .uniform_lines_inputs_ui)

- `vline.linetypes` - Vertical line types (UI: via
  .uniform_lines_inputs_ui)

- `vline.opacities` - Vertical line opacities (UI: via
  .uniform_lines_inputs_ui)

- `abline.slopes` - Diagonal line slopes (UI: via
  .uniform_lines_inputs_ui)

- `abline.intercepts` - Diagonal line Y-intercepts (UI: via
  .uniform_lines_inputs_ui)

- `abline.colors` - Diagonal line colors (UI: via
  .uniform_lines_inputs_ui)

- `abline.widths` - Diagonal line widths (UI: via
  .uniform_lines_inputs_ui)

- `abline.linetypes` - Diagonal line types (UI: via
  .uniform_lines_inputs_ui)

- `abline.opacities` - Diagonal line opacities (UI: via
  .uniform_lines_inputs_ui)

- `fit.line` - Fit line (UI: via .uniform_lines_inputs_ui)

- `fit.line.color` - Fit line color (UI: via .uniform_lines_inputs_ui)

- `fit.line.width` - Fit line width (UI: via .uniform_lines_inputs_ui)

- `fit.line.type` - Fit line type (UI: via .uniform_lines_inputs_ui)

## See also

[`dittoViz::scatterPlot()`](https://rdrr.io/pkg/dittoViz/man/scatterPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`dittoViz_scatterPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotOutputUI.md),
[`dittoViz_scatterPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotServer.md),
[`dittoViz_scatterPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_scatterPlotApp.md)

## Author

Jared Andrews

## Examples

``` r
library(VizModules)
data(mtcars)
dittoViz_scatterPlotInputsUI("scatterPlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="scatterPlot-scatterPlotTabsetPanel" data-tabsetid="2295">
#>     <li class="active">
#>       <a href="#tab-2295-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-2" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-3" data-toggle="tab" data-bs-toggle="tab" data-value="Points">Points</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-4" data-toggle="tab" data-bs-toggle="tab" data-value="Colors">Colors</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-5" data-toggle="tab" data-bs-toggle="tab" data-value="Facets">Facets</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-6" data-toggle="tab" data-bs-toggle="tab" data-value="Annotations">Annotations</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-7" data-toggle="tab" data-bs-toggle="tab" data-value="Legend/Scale">Legend/Scale</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-8" data-toggle="tab" data-bs-toggle="tab" data-value="Trajectory">Trajectory</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-9" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-10" data-toggle="tab" data-bs-toggle="tab" data-value="Extras">Extras</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-11" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>     <li>
#>       <a href="#tab-2295-12" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="2295">
#>     <div class="tab-pane active" data-value="Data" id="tab-2295-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-x.by-label" for="scatterPlot-x.by">X Data</label>
#>             <div>
#>               <select id="scatterPlot-x.by" class="shiny-input-select"><option value=""></option>
#> <option value="mpg" selected>mpg</option>
#> <option value="cyl">cyl</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="scatterPlot-x.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-y.by-label" for="scatterPlot-y.by">Y Data</label>
#>             <div>
#>               <select id="scatterPlot-y.by" class="shiny-input-select"><option value=""></option>
#> <option value="mpg">mpg</option>
#> <option value="cyl" selected>cyl</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="scatterPlot-y.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-color.by-label" for="scatterPlot-color.by">Color By</label>
#>             <div>
#>               <select id="scatterPlot-color.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="mpg">mpg</option>
#> <option value="cyl">cyl</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="scatterPlot-color.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-shape.by-label" for="scatterPlot-shape.by">Shape By</label>
#>             <div>
#>               <select id="scatterPlot-shape.by" class="shiny-input-select"><option value="" selected></option></select>
#>               <script type="application/json" data-for="scatterPlot-shape.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-split.by-label" for="scatterPlot-split.by">Split By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="scatterPlot-split.by" multiple="multiple"><option value="" selected></option></select>
#>               <script type="application/json" data-for="scatterPlot-split.by">{"maxItems":2,"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-rows.use-label" for="scatterPlot-rows.use">Rows Filter</label>
#>             <input id="scatterPlot-rows.use" type="text" class="shiny-input-text form-control" value="" placeholder="Filter expression, e.g. Sepal.Length &gt; 5" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-2295-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-x.adjustment-label" for="scatterPlot-x.adjustment">X Adjustment</label>
#>             <div>
#>               <select id="scatterPlot-x.adjustment" class="shiny-input-select"><option value="" selected></option>
#> <option value="z-score">z-score</option>
#> <option value="relative.to.max">relative.to.max</option></select>
#>               <script type="application/json" data-for="scatterPlot-x.adjustment">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-y.adjustment-label" for="scatterPlot-y.adjustment">Y Adjustment</label>
#>             <div>
#>               <select id="scatterPlot-y.adjustment" class="shiny-input-select"><option value="" selected></option>
#> <option value="z-score">z-score</option>
#> <option value="relative.to.max">relative.to.max</option></select>
#>               <script type="application/json" data-for="scatterPlot-y.adjustment">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-color.adjustment-label" for="scatterPlot-color.adjustment">Color Adjustment</label>
#>             <div>
#>               <select id="scatterPlot-color.adjustment" class="shiny-input-select"><option value="" selected></option>
#> <option value="z-score">z-score</option>
#> <option value="relative.to.max">relative.to.max</option></select>
#>               <script type="application/json" data-for="scatterPlot-color.adjustment">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-x.adj.fxn-label" for="scatterPlot-x.adj.fxn">X Adjustment Function</label>
#>             <div>
#>               <select id="scatterPlot-x.adj.fxn" class="shiny-input-select"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="as.factor">as.factor</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>               <script type="application/json" data-for="scatterPlot-x.adj.fxn">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-y.adj.fxn-label" for="scatterPlot-y.adj.fxn">Y Adjustment Function</label>
#>             <div>
#>               <select id="scatterPlot-y.adj.fxn" class="shiny-input-select"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="as.factor">as.factor</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>               <script type="application/json" data-for="scatterPlot-y.adj.fxn">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-color.adj.fxn-label" for="scatterPlot-color.adj.fxn">Color Adjustment Function</label>
#>             <div>
#>               <select id="scatterPlot-color.adj.fxn" class="shiny-input-select"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="as.factor">as.factor</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>               <script type="application/json" data-for="scatterPlot-color.adj.fxn">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Points" id="tab-2295-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-size-label" for="scatterPlot-size">Point Size</label>
#>             <input id="scatterPlot-size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-opacity-label" for="scatterPlot-opacity">Point Opacity</label>
#>             <input id="scatterPlot-opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-show.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Others</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-split.show.all.others" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Split Others</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-plot.order-label" for="scatterPlot-plot.order">Plot Order</label>
#>             <div>
#>               <select id="scatterPlot-plot.order" class="shiny-input-select"><option value="unordered" selected>unordered</option>
#> <option value="increasing">increasing</option>
#> <option value="decreasing">decreasing</option>
#> <option value="randomize">randomize</option></select>
#>               <script type="application/json" data-for="scatterPlot-plot.order" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-shape.panel-label" for="scatterPlot-shape.panel">Shape Panel</label>
#>             <input id="scatterPlot-shape.panel" type="text" class="shiny-input-text form-control" value="16, 15, 17, 23, 25, 8" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Colors" id="tab-2295-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-min.color">Min Color</label>
#>             <input id="scatterPlot-min.color" type="text" class="form-control shiny-colour-input" data-init-value="#F0E442" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-max.color">Max Color</label>
#>             <input id="scatterPlot-max.color" type="text" class="form-control shiny-colour-input" data-init-value="#0072B2" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-contour.color">Contour Color</label>
#>             <input id="scatterPlot-contour.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-contour.linetype-label" for="scatterPlot-contour.linetype">Contour Linetype</label>
#>             <div>
#>               <select id="scatterPlot-contour.linetype" class="shiny-input-select"><option value="solid" selected>solid</option>
#> <option value="dashed">dashed</option>
#> <option value="dotted">dotted</option>
#> <option value="dotdash">dotdash</option>
#> <option value="longdash">longdash</option>
#> <option value="twodash">twodash</option></select>
#>               <script type="application/json" data-for="scatterPlot-contour.linetype" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="scatterPlot-color.panel.ui" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facets" id="tab-2295-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-split.nrow-label" for="scatterPlot-split.nrow">Split Rows</label>
#>             <input id="scatterPlot-split.nrow" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-split.ncol-label" for="scatterPlot-split.ncol">Split Columns</label>
#>             <input id="scatterPlot-split.ncol" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-multivar.split.dir-label" for="scatterPlot-multivar.split.dir">Multivar Split Dir</label>
#>             <div>
#>               <select id="scatterPlot-multivar.split.dir" class="shiny-input-select"><option value="col" selected>col</option>
#> <option value="row">row</option></select>
#>               <script type="application/json" data-for="scatterPlot-multivar.split.dir" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-split.adjust.scales-label" for="scatterPlot-split.adjust.scales">Facet Scales</label>
#>             <div>
#>               <select id="scatterPlot-split.adjust.scales" class="shiny-input-select"><option value="fixed" selected>fixed</option>
#> <option value="free">free</option>
#> <option value="free_x">free_x</option>
#> <option value="free_y">free_y</option></select>
#>               <script type="application/json" data-for="scatterPlot-split.adjust.scales" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Annotations" id="tab-2295-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-annotate.by-label" for="scatterPlot-annotate.by">Annotate By</label>
#>             <div>
#>               <select id="scatterPlot-annotate.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="mpg">mpg</option>
#> <option value="cyl">cyl</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="scatterPlot-annotate.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="shiny-input-textarea form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-highlight.points-label" for="scatterPlot-highlight.points">Points to Highlight</label>
#>             <textarea id="scatterPlot-highlight.points" class="form-control" placeholder="Values from &#39;Annotate by&#39; column&#10;(comma, space, or newline delimited)" rows="3" data-update-on="change"></textarea>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-highlight.color">Highlight Fill</label>
#>             <input id="scatterPlot-highlight.color" type="text" class="form-control shiny-colour-input" data-init-value="#00FFF7" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-highlight.size-label" for="scatterPlot-highlight.size">Highlight Size</label>
#>             <input id="scatterPlot-highlight.size" type="number" class="shiny-input-number form-control" value="7" data-update-on="change" min="0.1" step="0.5"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-highlight.border.color">Highlight Border Color</label>
#>             <input id="scatterPlot-highlight.border.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-highlight.border.width-label" for="scatterPlot-highlight.border.width">Highlight Border Width</label>
#>             <input id="scatterPlot-highlight.border.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-highlight.auto.annotate" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Auto-annotate Highlights</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-annotation.color">Annotation Color</label>
#>             <input id="scatterPlot-annotation.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-annotation.ax-label" for="scatterPlot-annotation.ax">Annotation X Offset</label>
#>             <input id="scatterPlot-annotation.ax" type="number" class="shiny-input-number form-control" value="20" data-update-on="change" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-annotation.ay-label" for="scatterPlot-annotation.ay">Annotation Y Offset</label>
#>             <input id="scatterPlot-annotation.ay" type="number" class="shiny-input-number form-control" value="-20" data-update-on="change" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-annotation.size-label" for="scatterPlot-annotation.size">Annotation Size</label>
#>             <input id="scatterPlot-annotation.size" type="number" class="shiny-input-number form-control" value="10" data-update-on="change" min="1" step="0.5"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-annotation.showarrow" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Arrow</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-annotation.arrowcolor">Arrow Color</label>
#>             <input id="scatterPlot-annotation.arrowcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-annotation.arrowhead-label" for="scatterPlot-annotation.arrowhead">Arrowhead Style</label>
#>             <input id="scatterPlot-annotation.arrowhead" type="number" class="shiny-input-number form-control" value="2" data-update-on="change" min="0" max="7" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-annotation.arrowwidth-label" for="scatterPlot-annotation.arrowwidth">Arrow Linewidth</label>
#>             <input id="scatterPlot-annotation.arrowwidth" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0.1" step="0.25"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <button id="scatterPlot-annotation.clear" type="button" class="btn btn-default action-button"><span class="action-label">Clear Annotations</span></button>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend/Scale" id="tab-2295-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-legend.show" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Legend</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-legend.color.title-label" for="scatterPlot-legend.color.title">Legend Title</label>
#>             <input id="scatterPlot-legend.color.title" type="text" class="shiny-input-text form-control" value="make" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-legend.color.size-label" for="scatterPlot-legend.color.size">Legend Color Size</label>
#>             <input id="scatterPlot-legend.color.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-legend.shape.size-label" for="scatterPlot-legend.shape.size">Legend Shape Size</label>
#>             <input id="scatterPlot-legend.shape.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-legend.color.breaks-label" for="scatterPlot-legend.color.breaks">Legend Tick Breaks</label>
#>             <input id="scatterPlot-legend.color.breaks" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. -3, 0, 3" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-min.value-label" for="scatterPlot-min.value">Min Value</label>
#>             <input id="scatterPlot-min.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-max.value-label" for="scatterPlot-max.value">Max Value</label>
#>             <input id="scatterPlot-max.value" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Trajectory" id="tab-2295-8">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-trajectory.group.by-label" for="scatterPlot-trajectory.group.by">Trajectory Group By</label>
#>             <div>
#>               <select id="scatterPlot-trajectory.group.by" class="shiny-input-select"><option value="" selected></option></select>
#>               <script type="application/json" data-for="scatterPlot-trajectory.group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-add.trajectory.by.groups-label" for="scatterPlot-add.trajectory.by.groups">Add Trajectory By Groups</label>
#>             <input id="scatterPlot-add.trajectory.by.groups" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. [A,B],[C,D,E]" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-trajectory.arrow.size-label" for="scatterPlot-trajectory.arrow.size">Trajectory Arrow Size</label>
#>             <input id="scatterPlot-trajectory.arrow.size" type="number" class="shiny-input-number form-control" value="0.15" data-update-on="change" min="0" step="0.05"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-2295-9">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-webgl" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Plot with webGL</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-shape.fill">Shape Fill</label>
#>             <input id="scatterPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-shape.line.color">Shape Line Color</label>
#>             <input id="scatterPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-shape.line.width-label" for="scatterPlot-shape.line.width">Shape Line Width</label>
#>             <input id="scatterPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-shape.linetype-label" for="scatterPlot-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select id="scatterPlot-shape.linetype" class="shiny-input-select"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>               <script type="application/json" data-for="scatterPlot-shape.linetype" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-shape.opacity-label" for="scatterPlot-shape.opacity">Shape Opacity</label>
#>             <input id="scatterPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Extras" id="tab-2295-10">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-do.ellipse" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Ellipses</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-do.contour" type="checkbox" class="shiny-input-checkbox"/>
#>                 <span>Enable Contour</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-hover.data-label" for="scatterPlot-hover.data">Hover Data</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="scatterPlot-hover.data" multiple="multiple"><option value="" selected></option>
#> <option value="mpg">mpg</option>
#> <option value="cyl">cyl</option>
#> <option value="disp">disp</option>
#> <option value="hp">hp</option>
#> <option value="drat">drat</option>
#> <option value="wt">wt</option>
#> <option value="qsec">qsec</option>
#> <option value="vs">vs</option>
#> <option value="am">am</option>
#> <option value="gear">gear</option>
#> <option value="carb">carb</option></select>
#>               <script type="application/json" data-for="scatterPlot-hover.data">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-hover.round.digits-label" for="scatterPlot-hover.round.digits">Hover Round Digits</label>
#>             <input id="scatterPlot-hover.round.digits" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-2295-11">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-hline.intercepts-label" for="scatterPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="scatterPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-hline.colors-label" for="scatterPlot-hline.colors">Colors</label>
#>             <input id="scatterPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-hline.widths-label" for="scatterPlot-hline.widths">Widths</label>
#>             <input id="scatterPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-hline.linetypes-label" for="scatterPlot-hline.linetypes">Line types</label>
#>             <input id="scatterPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-hline.opacities-label" for="scatterPlot-hline.opacities">Opacities (0-1)</label>
#>             <input id="scatterPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <br/>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-vline.intercepts-label" for="scatterPlot-vline.intercepts">X-intercepts</label>
#>             <input id="scatterPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-vline.colors-label" for="scatterPlot-vline.colors">Colors</label>
#>             <input id="scatterPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-vline.widths-label" for="scatterPlot-vline.widths">Widths</label>
#>             <input id="scatterPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-vline.linetypes-label" for="scatterPlot-vline.linetypes">Line types</label>
#>             <input id="scatterPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-vline.opacities-label" for="scatterPlot-vline.opacities">Opacities (0-1)</label>
#>             <input id="scatterPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <br/>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-abline.slopes-label" for="scatterPlot-abline.slopes">Slopes</label>
#>             <input id="scatterPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="scatterPlot-best.fit" style="padding-right: 10px;">Line of best fit:</label>
#>               <input id="scatterPlot-best.fit" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="scatterPlot-best.fit"></label>
#>             </div>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-line.best.smoothness-label" for="scatterPlot-line.best.smoothness">Smoothness of line of best fit:</label>
#>             <input id="scatterPlot-line.best.smoothness" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="10000"/>
#>           </div>
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-line.best.colour">Line of best fit colour:</label>
#>             <input id="scatterPlot-line.best.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="scatterPlot-linear.model" style="padding-right: 10px;">Linear model line</label>
#>               <input id="scatterPlot-linear.model" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="scatterPlot-linear.model"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-2295-12">
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6"></div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-font.type-label" for="scatterPlot-font.type">Title Font</label>
#>             <div>
#>               <select id="scatterPlot-font.type" class="shiny-input-select"><option value="Arial" selected>Arial</option>
#> <option value="Balto">Balto</option>
#> <option value="Courier New">Courier New</option>
#> <option value="Droid Sans">Droid Sans</option>
#> <option value="Droid Serif">Droid Serif</option>
#> <option value="Droid Sans Mono">Droid Sans Mono</option>
#> <option value="Gravitas One">Gravitas One</option>
#> <option value="Old Standard TT">Old Standard TT</option>
#> <option value="Open Sans">Open Sans</option>
#> <option value="Overpass">Overpass</option>
#> <option value="PT Sans Narrow">PT Sans Narrow</option>
#> <option value="Raleway">Raleway</option>
#> <option value="Times New Roman">Times New Roman</option>
#> <option value="Verdana">Verdana</option>
#> <option value="sans-serif">sans-serif</option>
#> <option value="serif">serif</option>
#> <option value="monospace">monospace</option></select>
#>               <script type="application/json" data-for="scatterPlot-font.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-text.colour">Title Color</label>
#>             <input id="scatterPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-axis.title.font.size-label" for="scatterPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="scatterPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="scatterPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-axis.title.font.family-label" for="scatterPlot-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select id="scatterPlot-axis.title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
#> <option value="Balto">Balto</option>
#> <option value="Courier New">Courier New</option>
#> <option value="Droid Sans">Droid Sans</option>
#> <option value="Droid Serif">Droid Serif</option>
#> <option value="Droid Sans Mono">Droid Sans Mono</option>
#> <option value="Gravitas One">Gravitas One</option>
#> <option value="Old Standard TT">Old Standard TT</option>
#> <option value="Open Sans">Open Sans</option>
#> <option value="Overpass">Overpass</option>
#> <option value="PT Sans Narrow">PT Sans Narrow</option>
#> <option value="Raleway">Raleway</option>
#> <option value="Times New Roman">Times New Roman</option>
#> <option value="Verdana">Verdana</option>
#> <option value="sans-serif">sans-serif</option>
#> <option value="serif">serif</option>
#> <option value="monospace">monospace</option></select>
#>               <script type="application/json" data-for="scatterPlot-axis.title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="scatterPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="scatterPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-axis.linewidth-label" for="scatterPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="scatterPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-axis.tickfont.size-label" for="scatterPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="scatterPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="scatterPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-axis.tickfont.family-label" for="scatterPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select id="scatterPlot-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
#> <option value="Balto">Balto</option>
#> <option value="Courier New">Courier New</option>
#> <option value="Droid Sans">Droid Sans</option>
#> <option value="Droid Serif">Droid Serif</option>
#> <option value="Droid Sans Mono">Droid Sans Mono</option>
#> <option value="Gravitas One">Gravitas One</option>
#> <option value="Old Standard TT">Old Standard TT</option>
#> <option value="Open Sans">Open Sans</option>
#> <option value="Overpass">Overpass</option>
#> <option value="PT Sans Narrow">PT Sans Narrow</option>
#> <option value="Raleway">Raleway</option>
#> <option value="Times New Roman">Times New Roman</option>
#> <option value="Verdana">Verdana</option>
#> <option value="sans-serif">sans-serif</option>
#> <option value="serif">serif</option>
#> <option value="monospace">monospace</option></select>
#>               <script type="application/json" data-for="scatterPlot-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-axis.tickangle.x-label" for="scatterPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="scatterPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-axis.tickangle.y-label" for="scatterPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="scatterPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-axis.ticks-label" for="scatterPlot-axis.ticks">Tick Position</label>
#>             <div>
#>               <select id="scatterPlot-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="scatterPlot-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="scatterPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="scatterPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-axis.ticklen-label" for="scatterPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="scatterPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="scatterPlot-axis.tickwidth-label" for="scatterPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="scatterPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="scatterPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="scatterPlot-auto.update" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="scatterPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="scatterPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="scatterPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="scatterPlot-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="scatterPlot-download.format-label" for="scatterPlot-download.format">Download Format</label>
#>       <div>
#>         <select id="scatterPlot-download.format" class="shiny-input-select"><option value="png">png</option>
#> <option value="svg" selected>svg</option></select>
#>         <script type="application/json" data-for="scatterPlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
