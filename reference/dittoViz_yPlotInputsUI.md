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

- `ylab` - Y-axis label (plotly allows interactive editing)

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

- `split.nrow` - Number of facet rows (UI: "Number of Rows", default: 4)

- `split.ncol` - Number of facet columns (UI: "Number of Columns",
  default: 4)

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

- `boxplot.show.outliers` - Show boxplot outliers (always TRUE in
  implementation)

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

- `vlnplot.width` - Violin width (calculated from boxgap)

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

- `legend.show` - Show legend (always TRUE in implementation)

## Parameters controlling additional functionality

The following parameters implementing new functionality or controlling
plotly-specific features are also available:

- `boxmode` - Boxplot mode grouping (calculated: "group" or "overlay"
  based on color.by)

- `boxgap` - Boxplot position dodge (UI: "Boxplot Position Dodge",
  default: 0.3)

- `boxgroupgap` - Boxplot group dodge (UI: "Boxplot Group Dodge",
  default: 0.2)

- `font.type` - Font family for plot text (UI: "Font", default: "Arial")

- `text.colour` - Color for title text (UI: "Label colour", default:
  "#000000")

- `axis.title.font.size` - Axis title font size (UI: "Axis font size",
  default: 18)

- `axis.title.font.color` - Axis title font color (UI: "Axis title font
  color", default: "#000000")

- `axis.title.font.family` - Axis title font family (UI: "Axis title
  font family", default: "Arial")

- `axis.showline` - Show axis border lines (UI: "Show axis lines",
  default: TRUE)

- `axis.mirror` - Mirror axis lines on opposite side (UI: "Mirror axis
  lines", default: TRUE)

- `show.grid.x` - Show X-axis major gridlines (UI: "Show X major
  gridlines", default: TRUE)

- `show.grid.y` - Show Y-axis major gridlines (UI: "Show Y major
  gridlines", default: TRUE)

- `axis.linecolor` - Color of axis lines (UI: "Axis line color",
  default: "black")

- `axis.linewidth` - Width of axis lines (UI: "Axis line width",
  default: 0.5)

- `axis.tickfont.size` - Size of tick labels (UI: "Tick label size",
  default: 12)

- `axis.tickfont.color` - Color of tick labels (UI: "Tick label color",
  default: "black")

- `axis.tickfont.family` - Font family for tick labels (UI: "Tick label
  font", default: "Arial")

- `axis.tickangle.x` - Rotation angle for X-axis tick labels (UI:
  "X-axis tick label angle", default: 0)

- `axis.tickangle.y` - Rotation angle for Y-axis tick labels (UI:
  "Y-axis tick label angle", default: 0)

- `axis.ticks` - Position of tick marks (UI: "Tick position", default:
  "outside")

- `axis.tickcolor` - Color of tick marks (UI: "Tick mark color",
  default: "black")

- `axis.ticklen` - Length of tick marks (UI: "Tick mark length",
  default: 5)

- `axis.tickwidth` - Width of tick marks (UI: "Tick mark width",
  default: 1)

- `hline.intercepts` - Y-coordinates for horizontal reference lines (UI:
  "Y-intercepts", default: "")

- `hline.colors` - Colors for horizontal lines (UI: "Colors", default:
  "#000000")

- `hline.widths` - Widths for horizontal lines (UI: "Widths", default:
  "1")

- `hline.linetypes` - Line types for horizontal lines (UI: "Line types",
  default: "dashed")

- `hline.opacities` - Opacities for horizontal lines (UI: "Opacities
  (0-1)", default: "1")

- `vline.intercepts` - X-coordinates for vertical reference lines (UI:
  "X-intercepts", default: "")

- `vline.colors` - Colors for vertical lines (UI: "Colors", default:
  "#000000")

- `vline.widths` - Widths for vertical lines (UI: "Widths", default:
  "1")

- `vline.linetypes` - Line types for vertical lines (UI: "Line types",
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

- `abline.linetypes` - Line types for diagonal lines (UI: "Line types",
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
#>   <ul class="nav nav-tabs shiny-tab-input" id="yPlot-yPlotTabsetPanel" data-tabsetid="4545">
#>     <li class="active">
#>       <a href="#tab-4545-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4545-2" data-toggle="tab" data-bs-toggle="tab" data-value="Plot Type">Plot Type</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4545-3" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4545-4" data-toggle="tab" data-bs-toggle="tab" data-value="Jitter">Jitter</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4545-5" data-toggle="tab" data-bs-toggle="tab" data-value="Box">Box</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4545-6" data-toggle="tab" data-bs-toggle="tab" data-value="Violin">Violin</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4545-7" data-toggle="tab" data-bs-toggle="tab" data-value="Ridge">Ridge</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4545-8" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4545-9" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-4545-10" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="4545">
#>     <div class="tab-pane active" data-value="Data" id="tab-4545-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify709648">
#>             <label class="control-label" id="yPlot-var-label" for="yPlot-var">Y data (var)</label>
#>             <div>
#>               <select id="yPlot-var" class="shiny-input-select"><option value=""></option>
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
#>               <script type="application/json" data-for="yPlot-var">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify709648', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a column of data_frame to be used as the primary, y-axis, data. Alternatively, a string vector naming multiple such columns of data to plot at once. See the input multivar.aes to understand or tweak how multiple var-data will be shown.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5268303">
#>             <label class="control-label" id="yPlot-group.by-label" for="yPlot-group.by">Group by</label>
#>             <div>
#>               <select id="yPlot-group.by" class="shiny-input-select"><option value=""></option></select>
#>               <script type="application/json" data-for="yPlot-group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5268303', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a column of data_frame containing discrete data to use for separating the data points into groups.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7634748">
#>             <label class="control-label" id="yPlot-color.by-label" for="yPlot-color.by">Color by</label>
#>             <div>
#>               <select id="yPlot-color.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="yPlot-color.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7634748', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a column of data_frame containing discrete data to use for setting data representation color fills. This data does not need to be the same as group.by, which is great for highlighting supersets or subgroups when wanted, but it defaults to group.by so the input can often be skipped.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4353866">
#>             <label class="control-label" id="yPlot-shape.by-label" for="yPlot-shape.by">Shape by</label>
#>             <div>
#>               <select id="yPlot-shape.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="yPlot-shape.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4353866', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single string representing the name of a column of data_frame containing discrete data to use for setting shapes of the jitter points. When not provided, all jitter points will be dots.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="yPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plot Type" id="tab-4545-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5524723">
#>             <label class="control-label" id="yPlot-plots-label" for="yPlot-plots">Plots to show:</label>
#>             <div>
#>               <select id="yPlot-plots" class="shiny-input-select" multiple="multiple"><option value="vlnplot">Violin</option>
#> <option value="boxplot" selected>Box</option>
#> <option value="jitter" selected>Jitter</option>
#> <option value="ridgeplot">Ridge</option></select>
#>               <script type="application/json" data-for="yPlot-plots">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5524723', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String vector which sets the types of plots to include: possibilities = "jitter", "boxplot", "vlnplot", "ridgeplot". Order matters: c("vlnplot", "boxplot", "jitter") will put a violin plot in the back, boxplot in the middle, and then individual dots in the front. See details section for more info.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <span class="help-block">Order not currently respected</span>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-4545-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2040307">
#>             <label class="control-label" id="yPlot-y.max-label" for="yPlot-y.max">Y Axis Max</label>
#>             <input id="yPlot-y.max" type="number" class="shiny-input-number form-control" value="37.629" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2040307', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify310261">
#>             <label class="control-label" id="yPlot-y.min-label" for="yPlot-y.min">Y Axis Min</label>
#>             <input id="yPlot-y.min" type="number" class="shiny-input-number form-control" value="10.4" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify310261', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9697070">
#>             <div class="material-switch">
#>               <label for="yPlot-do.raster" style="padding-right: 10px;">Rasterize Jitter</label>
#>               <input id="yPlot-do.raster" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="yPlot-do.raster"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9697070', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical. When set to TRUE, rasterizes the jitter plot layer, changing it from individually encoded points to a flattened set of pixels. This can be useful for editing in external programs (e.g. Illustrator) when there are many thousands of data points.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1786131">
#>             <label class="control-label" id="yPlot-raster.dpi-label" for="yPlot-raster.dpi">Raster DPI</label>
#>             <input id="yPlot-raster.dpi" type="number" class="shiny-input-number form-control" value="600" data-update-on="change" min="100" max="1200"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1786131', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Number indicating dots/pixels per inch (dpi) to use for rasterization. Default = 300.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Jitter" id="tab-4545-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7782928">
#>             <label class="control-label" id="yPlot-jitter.size-label" for="yPlot-jitter.size">Jitter Point Size</label>
#>             <input id="yPlot-jitter.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" max="10"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7782928', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the size of the jitter shapes.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8857108">
#>             <label class="control-label" id="yPlot-jitter.width-label" for="yPlot-jitter.width">Jitter Width</label>
#>             <input id="yPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8857108', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar that sets the width/spread of the jitter in the x direction. Ignored in ridgeplots. Note for when color.by is used to split x-axis groupings into additional bins: ggplot does not shrink jitter widths accordingly, so be sure to do so yourself! Ideally, needs to be 0.5/num_subgroups.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify8364462">
#>             <label class="control-label" for="yPlot-jitter.color">Jitter Point Color</label>
#>             <input id="yPlot-jitter.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8364462', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String which sets the color of the jitter shapes'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6053684">
#>             <label class="control-label" id="yPlot-jitter.shape.legend.size-label" for="yPlot-jitter.shape.legend.size">Shape Legend Size</label>
#>             <input id="yPlot-jitter.shape.legend.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" max="20"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6053684', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which changes the size of the shape key in the legend. If set to NA, jitter.size is used.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9068794">
#>             <div class="material-switch">
#>               <label for="yPlot-jitter.shape.legend.show" style="padding-right: 10px;">Show Shape Legend</label>
#>               <input id="yPlot-jitter.shape.legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="yPlot-jitter.shape.legend.show"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9068794', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical which sets whether the shapes legend will be shown when its shape is determined by shape.by.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Box" id="tab-4545-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify359099">
#>             <div class="material-switch">
#>               <label for="yPlot-show.outliers" style="padding-right: 10px;">Show Outliers</label>
#>               <input id="yPlot-show.outliers" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="yPlot-show.outliers"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify359099', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether outliers should by including in the boxplot. Default is FALSE when there is a jitter plotted, TRUE if there is no jitter.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour" id="tipify1314185">
#>             <label class="control-label" for="yPlot-boxplot.color">Boxplot Color</label>
#>             <input id="yPlot-boxplot.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1314185', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String which sets the color of the lines of the boxplot'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify940304">
#>             <div class="material-switch">
#>               <label for="yPlot-boxplot.fill" style="padding-right: 10px;">Fill Boxplot</label>
#>               <input id="yPlot-boxplot.fill" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="yPlot-boxplot.fill"></label>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify940304', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Logical, whether the boxplot should be filled in or not. Known bug: when boxplot fill is turned off, outliers do not render.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6965836">
#>             <label class="control-label" id="yPlot-boxplot.lineweight-label" for="yPlot-boxplot.lineweight">Boxplot Line Weight</label>
#>             <input id="yPlot-boxplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6965836', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which adjusts the thickness of boxplot lines.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4057287">
#>             <label class="control-label" id="yPlot-boxgap-label" for="yPlot-boxgap">Boxplot Position Dodge</label>
#>             <input id="yPlot-boxgap" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4057287', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the gap between boxplots within the same group, controlling how closely boxes are spaced'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify656367">
#>             <label class="control-label" id="yPlot-boxgroupgap-label" for="yPlot-boxgroupgap">Boxplot Group Dodge</label>
#>             <input id="yPlot-boxgroupgap" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify656367', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Set the gap between groups of boxplots when a color.by variable is used'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Violin" id="tab-4545-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1264927">
#>             <label class="control-label" id="yPlot-vlnplot.lineweight-label" for="yPlot-vlnplot.lineweight">Violin Line Weight</label>
#>             <input id="yPlot-vlnplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1264927', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the thickness of the line that outlines the violin plots.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify9373302">
#>             <label class="control-label" id="yPlot-vlnplot.scaling-label" for="yPlot-vlnplot.scaling">Violin Scaling</label>
#>             <div>
#>               <select id="yPlot-vlnplot.scaling" class="shiny-input-select"><option value="area" selected>area</option>
#> <option value="count">count</option>
#> <option value="width">width</option></select>
#>               <script type="application/json" data-for="yPlot-vlnplot.scaling" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify9373302', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'String which sets how the widths of the of violin plots are set in relation to each other. Options are "area", "count", and "width". If the default is not right for your data, I recommend trying "width". For an explanation of each, see geom_violin.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2163803">
#>             <label class="control-label" id="yPlot-vlnplot.quantiles-label" for="yPlot-vlnplot.quantiles">Violin Quantiles (0-1)</label>
#>             <input id="yPlot-vlnplot.quantiles" type="text" class="shiny-input-text form-control" value="" placeholder="e.g., 0.25, 0.5, 0.75" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2163803', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Single number or numeric vector of values in [0,1] naming quantiles at which to draw a horizontal line within each violin plot. Example: c(0.1, 0.5, 0.9)'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Ridge" id="tab-4545-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify6660920">
#>             <label class="control-label" id="yPlot-ridgeplot.lineweight-label" for="yPlot-ridgeplot.lineweight">Ridge Line Weight</label>
#>             <input id="yPlot-ridgeplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify6660920', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the thickness of the ridgeplot outline.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2039007">
#>             <label class="control-label" id="yPlot-ridgeplot.scale-label" for="yPlot-ridgeplot.scale">Ridge Scale (overlap)</label>
#>             <input id="yPlot-ridgeplot.scale" type="number" class="shiny-input-number form-control" value="1.25" data-update-on="change" min="0.5" max="3"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2039007', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which sets the distance/overlap between ridgeplots. A value of 1 means the tallest density curve just touches the baseline of the next higher one. Higher numbers lead to greater overlap. Default = 1.25'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify5485914">
#>             <label class="control-label" id="yPlot-ridgeplot.ymax.expansion-label" for="yPlot-ridgeplot.ymax.expansion">Ridge Y-max Expansion</label>
#>             <input id="yPlot-ridgeplot.ymax.expansion" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" max="1"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify5485914', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Scalar which adjusts the minimal space between the topmost grouping and the top of the plot in order to ensure the curve is not cut off by the plotting grid. The larger the value, the greater the space requested. When left as NA, dittoViz will attempt to determine an ideal value itself based on the number of groups & linear interpolation between these goal posts: #groups of 3 or fewer: 0.6; #groups=12: 0.1; #groups or 34 or greater: 0.05.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8275014">
#>             <label class="control-label" id="yPlot-ridgeplot.shape-label" for="yPlot-ridgeplot.shape">Ridge Shape</label>
#>             <div>
#>               <select id="yPlot-ridgeplot.shape" class="shiny-input-select"><option value="smooth" selected>smooth</option>
#> <option value="hist">hist</option></select>
#>               <script type="application/json" data-for="yPlot-ridgeplot.shape" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8275014', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Either "smooth" or "hist", sets whether ridges will be smoothed (the typical, and default) versus rectangular like a histogram. (Note: as of the time shape "hist" was added, combination of jittered points is not supported by the stat_binline that dittoViz relies on.)'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify1275577">
#>             <label class="control-label" id="yPlot-ridgeplot.bins-label" for="yPlot-ridgeplot.bins">Ridge Bins</label>
#>             <input id="yPlot-ridgeplot.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="5" max="100"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify1275577', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer which sets how many chunks to break the x-axis into when ridgeplot.shape = "hist". Overridden by ridgeplot.binwidth when that input is provided.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2611861">
#>             <label class="control-label" id="yPlot-ridgeplot.binwidth-label" for="yPlot-ridgeplot.binwidth">Ridge Binwidth</label>
#>             <input id="yPlot-ridgeplot.binwidth" type="number" class="shiny-input-number form-control" data-update-on="change" min="0"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2611861', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'Integer which sets the width of chunks to break the x-axis into when ridgeplot.shape = "hist". Takes precedence over ridgeplot.bins when provided.'})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-4545-8">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify2884170">
#>             <label class="control-label" id="yPlot-split.by-label" for="yPlot-split.by">Split by (facet)</label>
#>             <div>
#>               <select id="yPlot-split.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="yPlot-split.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify2884170', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': '1 or 2 strings denoting the name(s) of column(s) of data_frame containing discrete data to use for faceting / separating data points into separate plots. When 2 columns are named, c(row,col), the first is used as rows and the second is used for columns of the resulting facet grid. When 1 column is named, shape control can be achieved with split.nrow and split.ncol'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify147691">
#>             <label class="control-label" id="yPlot-split.adjust-label" for="yPlot-split.adjust">Facet Scaling</label>
#>             <div>
#>               <select id="yPlot-split.adjust" class="shiny-input-select"><option value="fixed">fixed</option>
#> <option value="free" selected>free</option>
#> <option value="free_y">free_y</option>
#> <option value="free_x">free_x</option></select>
#>               <script type="application/json" data-for="yPlot-split.adjust" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify147691', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'A named list which allows extra parameters to be pushed through to the faceting function call. List elements should be valid inputs to the faceting functions, e.g. `list(scales = "free")`. For options, when giving 1 column to split.by, see facet_wrap, OR when giving 2 columns to split.by, see facet_grid.'})}, 500)});</script>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify8537237">
#>             <label class="control-label" id="yPlot-split.ncol-label" for="yPlot-split.ncol">Number of Columns</label>
#>             <div>
#>               <select id="yPlot-split.ncol" class="shiny-input-select"><option value=""></option>
#> <option value="1">1</option>
#> <option value="2">2</option>
#> <option value="3">3</option>
#> <option value="4" selected>4</option>
#> <option value="5">5</option>
#> <option value="6">6</option>
#> <option value="7">7</option>
#> <option value="8">8</option>
#> <option value="9">9</option>
#> <option value="10">10</option></select>
#>               <script type="application/json" data-for="yPlot-split.ncol">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify8537237', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify4140478">
#>             <label class="control-label" id="yPlot-split.nrow-label" for="yPlot-split.nrow">Number of Rows</label>
#>             <div>
#>               <select id="yPlot-split.nrow" class="shiny-input-select"><option value=""></option>
#> <option value="1">1</option>
#> <option value="2">2</option>
#> <option value="3">3</option>
#> <option value="4" selected>4</option>
#> <option value="5">5</option>
#> <option value="6">6</option>
#> <option value="7">7</option>
#> <option value="8">8</option>
#> <option value="9">9</option>
#> <option value="10">10</option></select>
#>               <script type="application/json" data-for="yPlot-split.nrow">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify4140478', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': ''})}, 500)});</script>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-4545-9">
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6"></div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6"></div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-font.type-label" for="yPlot-font.type">Title Font</label>
#>             <div>
#>               <select id="yPlot-font.type" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="yPlot-font.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-text.colour">Title Color</label>
#>             <input id="yPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
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
#>               <select id="yPlot-axis.title.font.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="yPlot-axis.title.font.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
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
#>             <label class="control-label" for="yPlot-axis.linecolor">Axis Line Color</label>
#>             <input id="yPlot-axis.linecolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.linewidth-label" for="yPlot-axis.linewidth">Axis Line Width</label>
#>             <input id="yPlot-axis.linewidth" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickfont.size-label" for="yPlot-axis.tickfont.size">Tick Label Size</label>
#>             <input id="yPlot-axis.tickfont.size" type="number" class="shiny-input-number form-control" value="12" data-update-on="change" min="1" step="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-axis.tickfont.color">Tick Label Color</label>
#>             <input id="yPlot-axis.tickfont.color" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickfont.family-label" for="yPlot-axis.tickfont.family">Tick Label Font</label>
#>             <div>
#>               <select id="yPlot-axis.tickfont.family" class="shiny-input-select"><option value="Arial" selected>Arial</option>
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
#>               <script type="application/json" data-for="yPlot-axis.tickfont.family" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickangle.x-label" for="yPlot-axis.tickangle.x">X Tick Label Angle</label>
#>             <input id="yPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickangle.y-label" for="yPlot-axis.tickangle.y">Y Tick Label Angle</label>
#>             <input id="yPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.ticks-label" for="yPlot-axis.ticks">Tick Position</label>
#>             <div>
#>               <select id="yPlot-axis.ticks" class="shiny-input-select"><option value="outside" selected>Outside</option>
#> <option value="inside">Inside</option>
#> <option value="">None</option></select>
#>               <script type="application/json" data-for="yPlot-axis.ticks">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-axis.tickcolor">Tick Mark Color</label>
#>             <input id="yPlot-axis.tickcolor" type="text" class="form-control shiny-colour-input" data-init-value="black" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.ticklen-label" for="yPlot-axis.ticklen">Tick Mark Length</label>
#>             <input id="yPlot-axis.ticklen" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" step="1"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickwidth-label" for="yPlot-axis.tickwidth">Tick Mark Width</label>
#>             <input id="yPlot-axis.tickwidth" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0" step="0.1"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-4545-10">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7510138">
#>             <label class="control-label" id="yPlot-hline.intercepts-label" for="yPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="yPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7510138', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-hline.colors-label" for="yPlot-hline.colors">Colors</label>
#>             <input id="yPlot-hline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-hline.widths-label" for="yPlot-hline.widths">Widths</label>
#>             <input id="yPlot-hline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-hline.linetypes-label" for="yPlot-hline.linetypes">Line types</label>
#>             <input id="yPlot-hline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-hline.opacities-label" for="yPlot-hline.opacities">Opacities (0-1)</label>
#>             <input id="yPlot-hline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <br/>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" id="tipify7190139">
#>             <label class="control-label" id="yPlot-vline.intercepts-label" for="yPlot-vline.intercepts">X-intercepts</label>
#>             <input id="yPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" placeholder="e.g. 2, -2" data-update-on="change"/>
#>           </div>
#>           <script>$(document).ready(function() {setTimeout(function() {shinyBS.addTooltip('tipify7190139', 'tooltip', {'container': 'body', 'placement': 'top', 'trigger': 'hover', 'title': 'For categorical or factor axes, enter the index (position) of the category rather than its name. For example, if the axis categories are &#39;Audi&#39;, &#39;Mercedes&#39;, &#39;Bugatti&#39;, enter 2 to place a line at &#39;Mercedes&#39;.'})}, 500)});</script>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vline.colors-label" for="yPlot-vline.colors">Colors</label>
#>             <input id="yPlot-vline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vline.widths-label" for="yPlot-vline.widths">Widths</label>
#>             <input id="yPlot-vline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vline.linetypes-label" for="yPlot-vline.linetypes">Line types</label>
#>             <input id="yPlot-vline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vline.opacities-label" for="yPlot-vline.opacities">Opacities (0-1)</label>
#>             <input id="yPlot-vline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <br/>
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
#>         <input id="yPlot-auto.update" type="checkbox"/>
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
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <a aria-disabled="true" class="btn btn-default shiny-download-link disabled btn-secondary" download href="" id="yPlot-download.interactive" tabindex="-1" target="_blank" width="100%">
#>       <i class="fas fa-download" role="presentation" aria-label="download icon"></i>
#>       Save Interactive
#>     </a>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="yPlot-download.format-label" for="yPlot-download.format">Download Format</label>
#>       <div>
#>         <select id="yPlot-download.format" class="shiny-input-select"><option value="png">png</option>
#> <option value="svg" selected>svg</option></select>
#>         <script type="application/json" data-for="yPlot-download.format" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
