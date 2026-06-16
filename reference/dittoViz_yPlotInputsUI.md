# Input UI components for the yPlot module

This should be placed in the UI where the inputs should be shown, with
an `id` that matches the `id` used in the
[`dittoViz_yPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotServer.md)
and
[`dittoViz_yPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotOutputUI.md)
functions.

## Usage

``` r
dittoViz_yPlotInputsUI(id, data, defaults = NULL, title = NULL, columns = 2)
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
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html) can
be set via these inputs, so see the help for that function for an
exhaustive list.

## Plot parameters not implemented or with altered functionality

The following
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
parameters are not available via UI inputs:

- `xlab` - X-axis label (plotly allows interactive editing)

- `ylab` - Y-axis label (auto-generated to reflect any applied Y
  adjustment, e.g. `"log2(z-score(units))"`; plotly allows interactive
  editing)

- `main` - Plot title (plotly allows interactive editing)

- `sub` - Plot subtitle (not supported in plotly)

- `theme` - ggplot2 theme (not applicable to plotly)

- `legend.title` - Legend title (managed by plotly interactively)

- `add.line` - Use `hline.intercepts` instead for horizontal lines with
  full styling options

- `line.linetype` - Use `hline.linetypes` instead

- `line.color` - Use `hline.colors` instead

## Plot parameters and defaults

The following
[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html)
parameters can be accessed via UI inputs and/or the `defaults` argument:

- `var` - Y-axis variable (UI: "Y data (var)", default: 2nd numeric
  variable)

- `group.by` - Grouping variable for x-axis (UI: "Group by", default:
  2nd categorical variable)

- `color.by` - Coloring variable (UI: "Color by", default: "")

- `shape.by` - Shape variable (UI: "Shape by", default: "")

- `split.by` - Faceting variable (UI: "Split by (facet)", default: "")

- `plots` - Plot types to show (UI: "Plots to show", default:
  c("boxplot", "jitter"))

- `color.panel` - Custom color values (UI: palette picker, derived from
  palette)

- `min` - Y-axis minimum (UI: "Y Axis Min", auto-calculated)

- `max` - Y-axis maximum (UI: "Y Axis Max", auto-calculated)

- `var.adjustment` - Y-axis data adjustment (UI: "Y Adjustment",
  default: "")

- `var.adj.fxn` - Y-axis adjustment function (UI: "Y Adjustment
  Function", default: "")

- `split.nrow` - Number of facet rows (UI: "Rows", default: 4)

- `split.ncol` - Number of facet columns (UI: "Columns", default: 4)

- `split.adjust` - Facet scale behavior (UI: "Facet Scaling", default:
  "free")

- `do.raster` - Rasterize jitter points (UI: "Rasterize Jitter",
  default: FALSE)

- `raster.dpi` - DPI for rasterization (UI: "Raster DPI", default: 600)

- `jitter.size` - Jitter point size (UI: "Jitter Point Size", default:
  1)

- `jitter.width` - Jitter width (UI: "Jitter Width", default: 0.2)

- `jitter.color` - Jitter point color (UI: "Jitter Point Color",
  default: "#000000")

- `jitter.shape.legend.size` - Shape legend size (UI: "Shape Legend
  Size", default: 5)

- `jitter.shape.legend.show` - Show shape legend (UI: "Show Shape
  Legend", default: TRUE)

- `jitter.position.dodge` - Jitter position dodge (calculated from
  boxgap)

- `boxplot.show.outliers` - Show boxplot outliers

- `boxplot.color` - Boxplot outline color (UI: "Boxplot Color", default:
  "#000000")

- `boxplot.fill` - Fill boxplot (UI: "Fill Boxplot", default: TRUE)

- `boxplot.lineweight` - Boxplot line weight (UI: "Boxplot Line Weight",
  default: 0.5)

- `vlnplot.lineweight` - Violin line weight (UI: "Violin Line Weight",
  default: 0.5)

- `vlnplot.scaling` - Violin scaling method (UI: "Violin Scaling",
  default: "area")

- `vlnplot.quantiles` - Violin quantiles (UI: "Violin Quantiles (0-1)",
  default: "")

- `vlnplot.width` - Violin width (derived from `boxgap`; not directly
  settable)

- `ridgeplot.lineweight` - Ridge line weight (UI: "Ridge Line Weight",
  default: 0.5)

- `ridgeplot.scale` - Ridge overlap scale (UI: "Ridge Scale (overlap)",
  default: 1.25)

- `ridgeplot.ymax.expansion` - Ridge Y-max expansion (UI: "Ridge Y-max
  Expansion", default: NA)

- `ridgeplot.shape` - Ridge shape (UI: "Ridge Shape", default: "smooth")

- `ridgeplot.bins` - Ridge bins (UI: "Ridge Bins", default: 30)

- `ridgeplot.binwidth` - Ridge binwidth (UI: "Ridge Binwidth", default:
  NULL)

- `legend.show` - Show legend (always `TRUE`; not directly settable)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `boxmode` - Boxplot mode grouping (calculated: "group" or "overlay"
  based on color.by)

- `boxgap` - Boxplot position dodge (UI: "Boxplot Position Dodge",
  default: 0.3)

- `boxgroupgap` - Boxplot group dodge (UI: "Boxplot Group Dodge",
  default: 0.2)

- `title.font.size` - Plot title font size (UI: "Title Size", default:
  26)

- `title.font.family` - Font family for title text (UI: "Title Font",
  default: "Arial")

- `title.font.color` - Color for plot title (UI: "Title Color", default:
  "#000000")

- `axis.title.font.size` - Axis title font size (UI: "Axis Title Size",
  default: 18)

- `axis.title.font.color` - Axis title font color (UI: "Axis Title
  Color", default: "#000000")

- `axis.title.font.family` - Axis title font family (UI: "Axis Title
  Font", default: "Arial")

- `axis.showline` - Show axis border lines (UI: "Show Axis Lines",
  default: TRUE)

- `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror Axis
  Lines", default: TRUE)

- `show.grid.x` - Show X-axis major gridlines (UI: "Show X Major
  Gridlines", default: TRUE)

- `show.grid.y` - Show Y-axis major gridlines (UI: "Show Y Major
  Gridlines", default: TRUE)

- `axis.linecolor` - Color of axis lines (UI: "Axis Line Color",
  default: "black")

- `axis.linewidth` - Width of axis lines (UI: "Axis Line Width",
  default: 0.5)

- `axis.tickfont.size` - Size of tick labels (UI: "Tick Label Size",
  default: 12)

- `axis.tickfont.color` - Color of tick labels (UI: "Tick Label Color",
  default: "black")

- `axis.tickfont.family` - Font family for tick labels (UI: "Tick Label
  Font", default: "Arial")

- `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI:
  "X-axis Tick Label Angle", default: 0)

- `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI:
  "Y-axis Tick Label Angle", default: 0)

- `axis.ticks` - Position of tick marks (UI: "Tick Position", default:
  "outside")

- `axis.tickcolor` - Color of tick marks (UI: "Tick Mark Color",
  default: "black")

- `axis.ticklen` - Length of tick marks (UI: "Tick Mark Length",
  default: 5)

- `axis.tickwidth` - Width of tick marks (UI: "Tick Mark Width",
  default: 1)

- `hline.intercepts` - Y-coordinates for horizontal reference lines (UI:
  "Y-intercepts", default: "")

- `hline.colors` - Colors for horizontal lines (UI: "Colors", default:
  "#000000")

- `hline.widths` - Widths for horizontal lines (UI: "Widths", default:
  "1")

- `hline.linetypes` - Line types for horizontal lines (UI: "Line Types",
  default: "dashed")

- `hline.opacities` - Opacities for horizontal lines (UI: "Opacities
  (0-1)", default: "1")

- `vline.intercepts` - X-coordinates for vertical reference lines (UI:
  "X-intercepts", default: "")

- `vline.colors` - Colors for vertical lines (UI: "Colors", default:
  "#000000")

- `vline.widths` - Widths for vertical lines (UI: "Widths", default:
  "1")

- `vline.linetypes` - Line types for vertical lines (UI: "Line Types",
  default: "dashed")

- `vline.opacities` - Opacities for vertical lines (UI: "Opacities
  (0-1)", default: "1")

- `abline.slopes` - Slopes for diagonal reference lines (UI: "Slopes",
  default: "")

- `abline.intercepts` - Y-intercepts for diagonal lines (UI:
  "Y-intercepts", default: "")

- `abline.colors` - Colors for diagonal lines (UI: "Colors", default:
  "#000000")

- `abline.widths` - Widths for diagonal lines (UI: "Widths", default:
  "1")

- `abline.linetypes` - Line types for diagonal lines (UI: "Line Types",
  default: "dashed")

- `abline.opacities` - Opacities for diagonal lines (UI: "Opacities
  (0-1)", default: "1")

## See also

[`dittoViz::yPlot()`](https://rdrr.io/pkg/dittoViz/man/yPlot.html),
[`organize_inputs()`](https://j-andrews7.github.io/VizModules/reference/organize_inputs.md),
[`dittoViz_yPlotOutputUI()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotOutputUI.md),
[`dittoViz_yPlotServer()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotServer.md),
[`dittoViz_yPlotApp()`](https://j-andrews7.github.io/VizModules/reference/dittoViz_yPlotApp.md)

## Author

Jared Andrews, Jacob Martin

## Examples

``` r
library(VizModules)
data(mtcars)
dittoViz_yPlotInputsUI("yPlot", mtcars)
#> <div class="tabbable">
#>   <ul class="nav nav-tabs shiny-tab-input" id="yPlot-yPlotTabsetPanel" data-tabsetid="3354">
#>     <li class="active">
#>       <a href="#tab-3354-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-2" data-toggle="tab" data-bs-toggle="tab" data-value="Plot Type">Plot Type</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-3" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-4" data-toggle="tab" data-bs-toggle="tab" data-value="Jitter">Jitter</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-5" data-toggle="tab" data-bs-toggle="tab" data-value="Box">Box</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-6" data-toggle="tab" data-bs-toggle="tab" data-value="Violin">Violin</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-7" data-toggle="tab" data-bs-toggle="tab" data-value="Ridge">Ridge</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-8" data-toggle="tab" data-bs-toggle="tab" data-value="Stats">Stats</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-9" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-10" data-toggle="tab" data-bs-toggle="tab" data-value="Legend">Legend</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-11" data-toggle="tab" data-bs-toggle="tab" data-value="Plotly">Plotly</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-12" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-3354-13" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="3354">
#>     <div class="tab-pane active" data-value="Data" id="tab-3354-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify586142">
#>             <label class="control-label" id="yPlot-var-label" for="yPlot-var">Y Data</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-var"><option value=""></option>
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
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify586142', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a column of `data_frame` to be used as the primary, y-axis, data. Alternatively, a string vector naming multiple such columns of data to plot at once. See the input `multivar.aes` to understand or tweak how multiple var-data will be shown.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9970691">
#>             <label class="control-label" id="yPlot-group.by-label" for="yPlot-group.by">Group By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-group.by"><option value=""></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9970691', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a column of `data_frame` containing discrete data to use for separating the data points into groups.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1490355">
#>             <label class="control-label" id="yPlot-color.by-label" for="yPlot-color.by">Color By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-color.by"><option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1490355', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a column of `data_frame` containing discrete data to use for setting data representation color fills. This data does not need to be the same as `group.by`, which is great for highlighting supersets or subgroups when wanted, but it defaults to `group.by` so the input can often be skipped.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5185566">
#>             <label class="control-label" id="yPlot-shape.by-label" for="yPlot-shape.by">Shape By</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-shape.by"><option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5185566', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a column of `data_frame` containing discrete data to use for setting shapes of the jitter points. When not provided, all jitter points will be dots.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="yPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plot Type" id="tab-3354-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8461200">
#>             <label class="control-label" id="yPlot-plots-label" for="yPlot-plots">Plots</label>
#>             <div>
#>               <select id="yPlot-plots" class="shiny-input-select" multiple="multiple"><option value="vlnplot">Violin</option>
#> <option value="boxplot" selected>Box</option>
#> <option value="jitter" selected>Jitter</option>
#> <option value="ridgeplot">Ridge</option></select>
#>               <script type="application/json" data-for="yPlot-plots">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8461200', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector which sets the types of plots to include: possibilities = "jitter", "boxplot", "vlnplot", "ridgeplot".  Order matters: c("vlnplot", "boxplot", "jitter") will put a violin plot in the back, boxplot in the middle, and then individual dots in the front.  See details section for more info.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <span class="help-block">Order not currently respected</span>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-3354-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7182697">
#>             <label class="control-label" id="yPlot-var.adjustment-label" for="yPlot-var.adjustment">Y Adjustment</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-var.adjustment"><option value="" selected></option>
#> <option value="z-score">z-score</option>
#> <option value="relative.to.max">relative.to.max</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7182697', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A recognized string indicating whether numeric `var` data should be used directly (default) or should be adjusted to be itemize{ item{"z-score": scaled with the scale() function to produce a relative-to-mean z-score representation} item{"relative.to.max": divided by the maximum expression value to give percent of max values between [0,1]} }  Ignored if the `var` data is not numeric as these known adjustments target numeric data only.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2413140">
#>             <label class="control-label" id="yPlot-var.adj.fxn-label" for="yPlot-var.adj.fxn">Y Adjustment Function</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-var.adj.fxn"><option value="" selected></option>
#> <option value="log2">log2</option>
#> <option value="log">log</option>
#> <option value="log10">log10</option>
#> <option value="neg_log10">neg_log10</option>
#> <option value="log1p">log1p</option>
#> <option value="as.factor">as.factor</option>
#> <option value="abs">abs</option>
#> <option value="sqrt">sqrt</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2413140', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'If you wish to apply a function to edit the `var` data before use, in a way not possible with the `var.adjustment` input, this input can be given a function which takes in a vector of values as input and returns a vector of values of the same length as output.  For example, `function(x) {log2(x)`} or `as.factor`.  In order to leave the unedited data available for use in other features, the adjusted data are put in a new column and that new column is used for plotting.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5470434">
#>             <label class="control-label" id="yPlot-y.max-label" for="yPlot-y.max">Y Axis Max</label>
#>             <input id="yPlot-y.max" type="number" class="shiny-input-number form-control" value="37.629" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5470434', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalars which control the zoom on the continuous axis of the plot.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8348018">
#>             <label class="control-label" id="yPlot-y.min-label" for="yPlot-y.min">Y Axis Min</label>
#>             <input id="yPlot-y.min" type="number" class="shiny-input-number form-control" value="10.4" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8348018', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalars which control the zoom on the continuous axis of the plot.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify279561">
#>             <div class="material-switch">
#>               <label for="yPlot-do.raster" style="padding-right: 10px;">Rasterize Jitter</label>
#>               <input id="yPlot-do.raster" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="yPlot-do.raster"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify279561', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. When set to `TRUE`, rasterizes the jitter plot layer, changing it from individually encoded points to a flattened set of pixels. This can be useful for editing in external programs (e.g. Illustrator) when there are many thousands of data points.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4693843">
#>             <label class="control-label" id="yPlot-raster.dpi-label" for="yPlot-raster.dpi">Raster DPI</label>
#>             <input id="yPlot-raster.dpi" type="number" class="shiny-input-number form-control" value="600" data-update-on="change" min="100" max="1200"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4693843', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number indicating dots/pixels per inch (dpi) to use for rasterization. Default = 300.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Jitter" id="tab-3354-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8056800">
#>             <label class="control-label" id="yPlot-jitter.size-label" for="yPlot-jitter.size">Jitter Point Size</label>
#>             <input id="yPlot-jitter.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" max="10"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8056800', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the size of the jitter shapes.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8140513">
#>             <label class="control-label" id="yPlot-jitter.width-label" for="yPlot-jitter.width">Jitter Width</label>
#>             <input id="yPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8140513', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar that sets the width/spread of the jitter in the x direction. Ignored in ridgeplots.  Note for when `color.by` is used to split x-axis groupings into additional bins: ggplot does not shrink jitter widths accordingly, so be sure to do so yourself! Ideally, needs to be 0.5/num_subgroups.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify4039110">
#>             <label class="control-label" for="yPlot-jitter.color">Jitter Point Color</label>
#>             <input id="yPlot-jitter.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4039110', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String which sets the color of the jitter shapes'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2184310">
#>             <label class="control-label" id="yPlot-jitter.shape.legend.size-label" for="yPlot-jitter.shape.legend.size">Shape Legend Size</label>
#>             <input id="yPlot-jitter.shape.legend.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" max="20"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2184310', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which changes the size of the shape key in the legend. If set to `NA`, `jitter.size` is used.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4183614">
#>             <div class="material-switch">
#>               <label for="yPlot-jitter.shape.legend.show" style="padding-right: 10px;">Show Shape Legend</label>
#>               <input id="yPlot-jitter.shape.legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="yPlot-jitter.shape.legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4183614', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical which sets whether the shapes legend will be shown when its shape is determined by `shape.by`.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Box" id="tab-3354-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6688707">
#>             <div class="material-switch">
#>               <label for="yPlot-boxplot.show.outliers" style="padding-right: 10px;">Show Outliers</label>
#>               <input id="yPlot-boxplot.show.outliers" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="yPlot-boxplot.show.outliers"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6688707', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether outliers should by including in the boxplot. Default is `FALSE` when there is a jitter plotted, `TRUE` if there is no jitter.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify5076503">
#>             <label class="control-label" for="yPlot-boxplot.color">Boxplot Color</label>
#>             <input id="yPlot-boxplot.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5076503', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String which sets the color of the lines of the boxplot'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6603593">
#>             <div class="material-switch">
#>               <label for="yPlot-boxplot.fill" style="padding-right: 10px;">Fill Boxplot</label>
#>               <input id="yPlot-boxplot.fill" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="yPlot-boxplot.fill"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6603593', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether the boxplot should be filled in or not. Known bug: when boxplot fill is turned off, outliers do not render.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5117913">
#>             <label class="control-label" id="yPlot-boxplot.lineweight-label" for="yPlot-boxplot.lineweight">Boxplot Line Weight</label>
#>             <input id="yPlot-boxplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5117913', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which adjusts the thickness of boxplot lines.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8355524">
#>             <label class="control-label" id="yPlot-boxgap-label" for="yPlot-boxgap">Boxplot Position Dodge</label>
#>             <input id="yPlot-boxgap" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8355524', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the gap between boxplots within the same group, controlling how closely boxes are spaced'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7087811">
#>             <label class="control-label" id="yPlot-boxgroupgap-label" for="yPlot-boxgroupgap">Boxplot Group Dodge</label>
#>             <input id="yPlot-boxgroupgap" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7087811', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the gap between groups of boxplots when a color.by variable is used'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Violin" id="tab-3354-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8742059">
#>             <label class="control-label" id="yPlot-vlnplot.lineweight-label" for="yPlot-vlnplot.lineweight">Violin Line Weight</label>
#>             <input id="yPlot-vlnplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8742059', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the thickness of the line that outlines the violin plots.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify114796">
#>             <label class="control-label" id="yPlot-vlnplot.scaling-label" for="yPlot-vlnplot.scaling">Violin Scaling</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-vlnplot.scaling"><option value="area" selected>area</option>
#> <option value="count">count</option>
#> <option value="width">width</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify114796', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String which sets how the widths of the of violin plots are set in relation to each other. Options are "area", "count", and "width". If the default is not right for your data, I recommend trying "width". For an explanation of each, see `link[ggplot2]{geom_violin`}.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8882495">
#>             <label class="control-label" id="yPlot-vlnplot.quantiles-label" for="yPlot-vlnplot.quantiles">Violin Quantiles (0-1)</label>
#>             <input id="yPlot-vlnplot.quantiles" type="text" class="shiny-input-text form-control" value="" placeholder="e.g., 0.25, 0.5, 0.75" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8882495', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single number or numeric vector of values in [0,1] naming quantiles at which to draw a horizontal line within each violin plot. Example: `c(0.1, 0.5, 0.9)`'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Ridge" id="tab-3354-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9963469">
#>             <label class="control-label" id="yPlot-ridgeplot.lineweight-label" for="yPlot-ridgeplot.lineweight">Ridge Line Weight</label>
#>             <input id="yPlot-ridgeplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9963469', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the thickness of the ridgeplot outline.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5001915">
#>             <label class="control-label" id="yPlot-ridgeplot.scale-label" for="yPlot-ridgeplot.scale">Ridge Scale (overlap)</label>
#>             <input id="yPlot-ridgeplot.scale" type="number" class="shiny-input-number form-control" value="1.25" data-update-on="change" min="0.5" max="3"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5001915', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the distance/overlap between ridgeplots. A value of 1 means the tallest density curve just touches the baseline of the next higher one. Higher numbers lead to greater overlap.  Default = 1.25'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3589670">
#>             <label class="control-label" id="yPlot-ridgeplot.ymax.expansion-label" for="yPlot-ridgeplot.ymax.expansion">Ridge Y-max Expansion</label>
#>             <input id="yPlot-ridgeplot.ymax.expansion" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3589670', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which adjusts the minimal space between the topmost grouping and the top of the plot in order to ensure the curve is not cut off by the plotting grid. The larger the value, the greater the space requested. When left as NA, dittoViz will attempt to determine an ideal value itself based on the number of groups & linear interpolation between these goal posts: #groups of 3 or fewer: 0.6; #groups=12: 0.1; #groups or 34 or greater: 0.05.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7749130">
#>             <label class="control-label" id="yPlot-ridgeplot.shape-label" for="yPlot-ridgeplot.shape">Ridge Shape</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-ridgeplot.shape"><option value="smooth" selected>smooth</option>
#> <option value="hist">hist</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7749130', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Either "smooth" or "hist", sets whether ridges will be smoothed (the typical, and default) versus rectangular like a histogram. (Note: as of the time shape "hist" was added, combination of jittered points is not supported by the `link[ggridges]{stat_binline`} that dittoViz relies on.)'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5844752">
#>             <label class="control-label" id="yPlot-ridgeplot.bins-label" for="yPlot-ridgeplot.bins">Ridge Bins</label>
#>             <input id="yPlot-ridgeplot.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="5" max="100"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5844752', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer which sets how many chunks to break the x-axis into when `ridgeplot.shape = "hist"`. Overridden by `ridgeplot.binwidth` when that input is provided.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6339764">
#>             <label class="control-label" id="yPlot-ridgeplot.binwidth-label" for="yPlot-ridgeplot.binwidth">Ridge Binwidth</label>
#>             <input id="yPlot-ridgeplot.binwidth" type="number" class="shiny-input-number form-control" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6339764', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer which sets the width of chunks to break the x-axis into when `ridgeplot.shape = "hist"`. Takes precedence over `ridgeplot.bins` when provided.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Stats" id="tab-3354-8">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8586661">
#>             <div class="material-switch">
#>               <label for="yPlot-stats.enabled" style="padding-right: 10px;">Enable Stats</label>
#>               <input id="yPlot-stats.enabled" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="yPlot-stats.enabled"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8586661', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Toggle pairwise statistical testing with bracket annotations on the plot'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5668943">
#>             <label class="control-label" id="yPlot-stat.test-label" for="yPlot-stat.test">Test</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-stat.test"><option value="wilcox.test" selected>Wilcoxon</option>
#> <option value="t.test">t-test</option>
#> <option value="kruskal.test">Kruskal-Wallis</option>
#> <option value="anova">ANOVA</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5668943', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Statistical test for comparisons. Wilcoxon and t-test perform pairwise comparisons. Kruskal-Wallis and ANOVA perform omnibus tests.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2529970">
#>             <label class="control-label" id="yPlot-stat.p.adjust-label" for="yPlot-stat.p.adjust">P-value Adjustment</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-stat.p.adjust"><option value="holm" selected>holm</option>
#> <option value="hochberg">hochberg</option>
#> <option value="hommel">hommel</option>
#> <option value="bonferroni">bonferroni</option>
#> <option value="BH">BH</option>
#> <option value="BY">BY</option>
#> <option value="fdr">fdr</option>
#> <option value="none">none</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2529970', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Method for multiple testing correction applied to all p-values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9188032">
#>             <label class="control-label" id="yPlot-stat.display-label" for="yPlot-stat.display">Display</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-stat.display"><option value="p.adj" selected>Adjusted P-value</option>
#> <option value="p.value">P-value</option>
#> <option value="symbol">Symbols</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9188032', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'What to display on brackets: adjusted p-values, raw p-values, or significance symbols (*, **, ***, ****)'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8673502">
#>             <label class="control-label" id="yPlot-stat.sig.threshold-label" for="yPlot-stat.sig.threshold">Significance Threshold</label>
#>             <input id="yPlot-stat.sig.threshold" type="number" class="shiny-input-number form-control" value="0.05" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8673502', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '(Adjusted, if applied) P-values above this threshold are labeled &#39;ns&#39;. Also used as the boundary for the &#39;*&#39; significance symbol.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2485387">
#>             <div class="material-switch">
#>               <label for="yPlot-stat.hide.ns" style="padding-right: 10px;">Hide Non-Significant</label>
#>               <input id="yPlot-stat.hide.ns" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="yPlot-stat.hide.ns"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2485387', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Hide comparison brackets where the adjusted p-value exceeds the significance threshold'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4028812">
#>             <div class="material-switch">
#>               <label for="yPlot-stat.paired" style="padding-right: 10px;">Paired Test</label>
#>               <input id="yPlot-stat.paired" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="yPlot-stat.paired"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4028812', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Perform paired tests (Wilcoxon signed-rank or paired t-test). Each group must have the same number of observations in corresponding order. Data should be sorted so that paired samples align row-by-row within each group.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7696301">
#>             <label class="control-label" id="yPlot-stat.pairs-label" for="yPlot-stat.pairs">Comparisons</label>
#>             <div>
#>               <select id="yPlot-stat.pairs" class="shiny-input-select" multiple="multiple"></select>
#>               <script type="application/json" data-for="yPlot-stat.pairs">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7696301', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Select specific pairwise comparisons to display. If empty, all possible pairs are tested.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1194854">
#>             <label class="control-label" for="yPlot-stat.line.color">Line Color</label>
#>             <input id="yPlot-stat.line.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1194854', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color for bracket lines and annotation text'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1946950">
#>             <label class="control-label" id="yPlot-stat.line.width-label" for="yPlot-stat.line.width">Line Width</label>
#>             <input id="yPlot-stat.line.width" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="1" max="50" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1946950', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width of bracket lines in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1645693">
#>             <label class="control-label" id="yPlot-stat.bracket.style-label" for="yPlot-stat.bracket.style">Bracket Style</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-stat.bracket.style"><option value="capped" selected>Capped</option>
#> <option value="flat">Flat</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1645693', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Capped brackets have vertical ticks at each end; flat brackets are a single horizontal line'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6632066">
#>             <label class="control-label" id="yPlot-stat.step.increase-label" for="yPlot-stat.step.increase">Bracket Spacing</label>
#>             <input id="yPlot-stat.step.increase" type="number" class="shiny-input-number form-control" value="0.06" data-update-on="change" min="0.01" max="0.3" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6632066', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the y-axis range used as vertical spacing between successive bracket levels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8565750">
#>             <label class="control-label" id="yPlot-stat.text.bump-label" for="yPlot-stat.text.bump">Text Offset</label>
#>             <input id="yPlot-stat.text.bump" type="number" class="shiny-input-number form-control" value="0.04" data-update-on="change" min="0.005" max="0.2" step="0.005"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8565750', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fraction of the y-axis range for vertical distance between the bracket line and annotation text'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9265464">
#>             <label class="control-label" id="yPlot-stat.bracket.inset-label" for="yPlot-stat.bracket.inset">Bracket Inset</label>
#>             <input id="yPlot-stat.bracket.inset" type="number" class="shiny-input-number form-control" value="0.025" data-update-on="change" min="0" max="0.2" step="0.005"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9265464', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Fixed amount to inset bracket endpoints from group centers, preventing overlap of adjacent brackets'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5523776">
#>             <div class="material-switch">
#>               <label for="yPlot-stat.per.facet" style="padding-right: 10px;">Per Facet Panel</label>
#>               <input id="yPlot-stat.per.facet" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="yPlot-stat.per.facet"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5523776', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'When enabled, statistical tests run independently within each facet panel. When disabled, tests run on the full dataset.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-3354-9">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5770657">
#>             <label class="control-label" id="yPlot-split.by-label" for="yPlot-split.by">Split by (facet)</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-split.by"><option value="" selected></option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5770657', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '1 or 2 strings denoting the name(s) of column(s) of `data_frame` containing discrete data to use for faceting / separating data points into separate plots.  When 2 columns are named, c(row,col), the first is used as rows and the second is used for columns of the resulting facet grid.  When 1 column is named, shape control can be achieved with `split.nrow` and `split.ncol`'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6874477">
#>             <label class="control-label" id="yPlot-split.adjust-label" for="yPlot-split.adjust">Facet Scaling</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-split.adjust"><option value="fixed">fixed</option>
#> <option value="free" selected>free</option>
#> <option value="free_y">free_y</option>
#> <option value="free_x">free_x</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6874477', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A named list which allows extra parameters to be pushed through to the faceting function call. List elements should be valid inputs to the faceting functions, e.g. `list(scales = "free")`.  For options, when giving 1 column to `split.by`, see `link[ggplot2]{facet_wrap`}, OR when giving 2 columns to `split.by`, see `link[ggplot2]{facet_grid`}.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2447183">
#>             <label class="control-label" id="yPlot-split.ncol-label" for="yPlot-split.ncol">Columns</label>
#>             <input id="yPlot-split.ncol" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2447183', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify446172">
#>             <label class="control-label" id="yPlot-split.nrow-label" for="yPlot-split.nrow">Rows</label>
#>             <input id="yPlot-split.nrow" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify446172', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integers which set the dimensions of faceting/splitting when faceting by a single feature.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9098545">
#>             <label class="control-label" id="yPlot-subplot.margin.x-label" for="yPlot-subplot.margin.x">Subplot Spacing (Horizontal)</label>
#>             <input id="yPlot-subplot.margin.x" type="number" class="shiny-input-number form-control" value="0.03" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9098545', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Horizontal spacing between facet panel columns as a fraction of the plot area (e.g. 0.03). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify706813">
#>             <label class="control-label" id="yPlot-subplot.margin.y-label" for="yPlot-subplot.margin.y">Subplot Spacing (Vertical)</label>
#>             <input id="yPlot-subplot.margin.y" type="number" class="shiny-input-number form-control" value="0.1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify706813', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Vertical spacing between facet panel rows as a fraction of the plot area (e.g. 0.1). Only applies when faceting is active.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Legend" id="tab-3354-10">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9968914">
#>             <label class="control-label" id="yPlot-legend.title.size-label" for="yPlot-legend.title.size">Legend Title Size</label>
#>             <input id="yPlot-legend.title.size" type="number" class="shiny-input-number form-control" value="14" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9968914', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend title.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6118524">
#>             <label class="control-label" id="yPlot-legend.text.size-label" for="yPlot-legend.text.size">Legend Text Size</label>
#>             <input id="yPlot-legend.text.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="0" step="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6118524', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Font size of the legend entry labels.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plotly" id="tab-3354-11">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" style="width:100%;">
#>             <label class="control-label" id="yPlot-download.format-label" for="yPlot-download.format">Download Format</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-download.format"><option value="svg" selected>svg</option>
#> <option value="png">png</option>
#> <option value="jpeg">jpeg</option>
#> <option value="webp">webp</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1725589">
#>             <label class="control-label" id="yPlot-margin.t-label" for="yPlot-margin.t">Margin Top</label>
#>             <input id="yPlot-margin.t" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1725589', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Top margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9094409">
#>             <label class="control-label" id="yPlot-margin.b-label" for="yPlot-margin.b">Margin Bottom</label>
#>             <input id="yPlot-margin.b" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9094409', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Bottom margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify374512">
#>             <label class="control-label" id="yPlot-margin.l-label" for="yPlot-margin.l">Margin Left</label>
#>             <input id="yPlot-margin.l" type="number" class="shiny-input-number form-control" value="70" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify374512', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Left margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5935538">
#>             <label class="control-label" id="yPlot-margin.r-label" for="yPlot-margin.r">Margin Right</label>
#>             <input id="yPlot-margin.r" type="number" class="shiny-input-number form-control" value="90" data-update-on="change" min="0" step="5"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5935538', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Right margin of the plot in pixels'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify2369776">
#>             <label class="control-label" for="yPlot-shape.fill">Shape Fill</label>
#>             <input id="yPlot-shape.fill" type="text" class="form-control shiny-colour-input" data-init-value="rgba(0, 0, 0, 0)" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2369776', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Interior fill color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify9062972">
#>             <label class="control-label" for="yPlot-shape.line.color">Shape Line Color</label>
#>             <input id="yPlot-shape.line.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square" data-allow-alpha="true"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9062972', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline color for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8188730">
#>             <label class="control-label" id="yPlot-shape.line.width-label" for="yPlot-shape.line.width">Shape Line Width</label>
#>             <input id="yPlot-shape.line.width" type="number" class="shiny-input-number form-control" value="4" data-update-on="change" min="0" step="0.25"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8188730', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Outline width for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6998293">
#>             <label class="control-label" id="yPlot-shape.linetype-label" for="yPlot-shape.linetype">Shape Linetype</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-shape.linetype"><option value="solid" selected>solid</option>
#> <option value="dot">dot</option>
#> <option value="dash">dash</option>
#> <option value="longdash">longdash</option>
#> <option value="dashdot">dashdot</option>
#> <option value="longdashdot">longdashdot</option></select>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6998293', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line dash style for shapes drawn on the plot using Plotly&#39;s drawing tools'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2200004">
#>             <label class="control-label" id="yPlot-shape.opacity-label" for="yPlot-shape.opacity">Shape Opacity</label>
#>             <input id="yPlot-shape.opacity" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" max="1" step="0.01"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2200004', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of shapes drawn on the plot, where 0 is fully transparent and 1 is fully opaque'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-3354-12">
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6"></div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-title.font.family-label" for="yPlot-title.font.family">Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-title.font.family"><option value="Arial" selected>Arial</option>
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
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-title.font.color">Title Color</label>
#>             <input id="yPlot-title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-title.font.size-label" for="yPlot-title.font.size">Title Size</label>
#>             <input id="yPlot-title.font.size" type="number" class="shiny-input-number form-control" value="26" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.title.horizontal.position-label" for="yPlot-axis.title.horizontal.position">Title position</label>
#>             <input id="yPlot-axis.title.horizontal.position" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="1" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.title.font.size-label" for="yPlot-axis.title.font.size">Axis Title Size</label>
#>             <input id="yPlot-axis.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-axis.title.font.color">Axis Title Color</label>
#>             <input id="yPlot-axis.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.title.font.family-label" for="yPlot-axis.title.font.family">Axis Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-axis.title.font.family"><option value="Arial" selected>Arial</option>
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
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="yPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Borders</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="yPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
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
#>                 <input id="yPlot-show.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="yPlot-show.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-grid.color">Gridline Color</label>
#>             <input id="yPlot-grid.color" type="text" class="form-control shiny-colour-input" data-init-value="#CCCCCC" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="yPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.linewidth-label" for="yPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="yPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickfont.size-label" for="yPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="yPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="yPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickfont.family-label" for="yPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-axis.tickfont.family"><option value="Arial" selected>Arial</option>
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
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickangle.x-label" for="yPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="yPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickangle.y-label" for="yPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="yPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.ticks-label" for="yPlot-axis.ticks">Tick Position</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-axis.ticks"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="yPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.ticklen-label" for="yPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="yPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickwidth-label" for="yPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="yPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-facet.title.font.size-label" for="yPlot-facet.title.font.size">Facet Subplot Title Size</label>
#>             <input id="yPlot-facet.title.font.size" type="number" class="shiny-input-number form-control" value="18" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-facet.title.font.color">Facet Title Color</label>
#>             <input id="yPlot-facet.title.font.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-facet.title.font.family-label" for="yPlot-facet.title.font.family">Facet Title Font</label>
#>             <div>
#>               <select class="shiny-input-select form-control" id="yPlot-facet.title.font.family"><option value="Arial" selected>Arial</option>
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
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-3354-13">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7279909">
#>             <label class="control-label" id="yPlot-hline.intercepts-label" for="yPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="yPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7279909', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2170845">
#>             <label class="control-label" id="yPlot-hline.colors-label" for="yPlot-hline.colors">Y Colors</label>
#>             <input id="yPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2170845', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for horizontal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4562302">
#>             <label class="control-label" id="yPlot-hline.widths-label" for="yPlot-hline.widths">Y Widths</label>
#>             <input id="yPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4562302', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for horizontal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify3327998">
#>             <label class="control-label" id="yPlot-hline.linetypes-label" for="yPlot-hline.linetypes">Y Line Types</label>
#>             <input id="yPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify3327998', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for horizontal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5683527">
#>             <label class="control-label" id="yPlot-hline.opacities-label" for="yPlot-hline.opacities">Y Opacities (0-1)</label>
#>             <input id="yPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5683527', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of horizontal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2522057">
#>             <label class="control-label" id="yPlot-vline.intercepts-label" for="yPlot-vline.intercepts">X-intercepts</label>
#>             <input id="yPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2522057', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4640136">
#>             <label class="control-label" id="yPlot-vline.colors-label" for="yPlot-vline.colors">X Colors</label>
#>             <input id="yPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4640136', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for vertical reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9176605">
#>             <label class="control-label" id="yPlot-vline.widths-label" for="yPlot-vline.widths">X Widths</label>
#>             <input id="yPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9176605', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for vertical reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9728442">
#>             <label class="control-label" id="yPlot-vline.linetypes-label" for="yPlot-vline.linetypes">X Line Types</label>
#>             <input id="yPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9728442', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for vertical reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8190824">
#>             <label class="control-label" id="yPlot-vline.opacities-label" for="yPlot-vline.opacities">X Opacities (0-1)</label>
#>             <input id="yPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8190824', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of vertical reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9029238">
#>             <label class="control-label" id="yPlot-abline.slopes-label" for="yPlot-abline.slopes">Ab Slopes</label>
#>             <input id="yPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9029238', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Slope(s) of diagonal reference lines (rise/run), as comma-separated values'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5813660">
#>             <label class="control-label" id="yPlot-abline.intercepts-label" for="yPlot-abline.intercepts">Ab Y-intercepts</label>
#>             <input id="yPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5813660', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7730085">
#>             <label class="control-label" id="yPlot-abline.colors-label" for="yPlot-abline.colors">Ab Colors</label>
#>             <input id="yPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7730085', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Color(s) for diagonal reference lines, as comma-separated hex codes or color names'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9951230">
#>             <label class="control-label" id="yPlot-abline.widths-label" for="yPlot-abline.widths">Ab Widths</label>
#>             <input id="yPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9951230', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Width(s) for diagonal reference lines in pixels, as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7109712">
#>             <label class="control-label" id="yPlot-abline.linetypes-label" for="yPlot-abline.linetypes">Ab Line Types</label>
#>             <input id="yPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7109712', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Line style(s) for diagonal reference lines (solid, dashed, dotted, longdash, dashdot)'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2149426">
#>             <label class="control-label" id="yPlot-abline.opacities-label" for="yPlot-abline.opacities">Ab Opacities (0-1)</label>
#>             <input id="yPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2149426', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Opacity of diagonal reference lines between 0 (transparent) and 1 (opaque), as comma-separated values'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="yPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="yPlot-auto.update" type="checkbox" checked="checked"/>
#>         <label class="switch label-success bg-success" for="yPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button id="yPlot-update" style="width:100%;" type="button" class="btn btn-default action-button"><span class="action-label">Update</span></button>
#>   </div>
#>   <div class="col-sm-2" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="yPlot-reset" style="width:100%;" type="button"><span class="action-label">Reset</span></button>
#>   </div>
#>   <div class="col-sm-5" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="yPlot-download.source" tabindex="-1" target="_blank" width="100%">
#>       <i class="far fa-file-code" role="presentation" aria-label="file-code icon"></i>
#>       Source Download
#>     </a>
#>     <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('yPlot-download.source', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Download the plot as a self-contained HTML file, along with the plot source data and statistics (if applicable) as CSV files.'})}, 500)});</script>
#>   </div>
#> </div>
```
