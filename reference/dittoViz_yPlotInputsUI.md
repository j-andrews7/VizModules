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
#>   <ul class="nav nav-tabs shiny-tab-input" id="yPlot-yPlotTabsetPanel" data-tabsetid="5012">
#>     <li class="active">
#>       <a href="#tab-5012-1" data-toggle="tab" data-bs-toggle="tab" data-value="Data">Data</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5012-2" data-toggle="tab" data-bs-toggle="tab" data-value="Plot Type">Plot Type</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5012-3" data-toggle="tab" data-bs-toggle="tab" data-value="Adjustments">Adjustments</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5012-4" data-toggle="tab" data-bs-toggle="tab" data-value="Jitter">Jitter</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5012-5" data-toggle="tab" data-bs-toggle="tab" data-value="Box">Box</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5012-6" data-toggle="tab" data-bs-toggle="tab" data-value="Violin">Violin</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5012-7" data-toggle="tab" data-bs-toggle="tab" data-value="Ridge">Ridge</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5012-8" data-toggle="tab" data-bs-toggle="tab" data-value="Facet">Facet</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5012-9" data-toggle="tab" data-bs-toggle="tab" data-value="Axes">Axes</a>
#>     </li>
#>     <li>
#>       <a href="#tab-5012-10" data-toggle="tab" data-bs-toggle="tab" data-value="Lines">Lines</a>
#>     </li>
#>   </ul>
#>   <div class="tab-content" data-tabsetid="5012">
#>     <div class="tab-pane active" data-value="Data" id="tab-5012-1">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
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
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-group.by-label" for="yPlot-group.by">Group by</label>
#>             <div>
#>               <select id="yPlot-group.by" class="shiny-input-select"><option value=""></option></select>
#>               <script type="application/json" data-for="yPlot-group.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-color.by-label" for="yPlot-color.by">Color by</label>
#>             <div>
#>               <select id="yPlot-color.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="yPlot-color.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-shape.by-label" for="yPlot-shape.by">Shape by</label>
#>             <div>
#>               <select id="yPlot-shape.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="yPlot-shape.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div id="yPlot-palette.selection" class="shiny-html-output"></div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Plot Type" id="tab-5012-2">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-plots-label" for="yPlot-plots">Plots to show:</label>
#>             <div>
#>               <select id="yPlot-plots" class="shiny-input-select" multiple="multiple"><option value="vlnplot">Violin</option>
#> <option value="boxplot" selected>Box</option>
#> <option value="jitter" selected>Jitter</option>
#> <option value="ridgeplot">Ridge</option></select>
#>               <script type="application/json" data-for="yPlot-plots">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <span class="help-block">Order not currently respected</span>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Adjustments" id="tab-5012-3">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-y.max-label" for="yPlot-y.max">Y Axis Max</label>
#>             <input id="yPlot-y.max" type="number" class="shiny-input-number form-control" value="37.629" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-y.min-label" for="yPlot-y.min">Y Axis Min</label>
#>             <input id="yPlot-y.min" type="number" class="shiny-input-number form-control" value="10.4" data-update-on="change" min="-1000" max="1000"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="yPlot-do.raster" style="padding-right: 10px;">Rasterize Jitter</label>
#>               <input id="yPlot-do.raster" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="yPlot-do.raster"></label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-raster.dpi-label" for="yPlot-raster.dpi">Raster DPI</label>
#>             <input id="yPlot-raster.dpi" type="number" class="shiny-input-number form-control" value="600" data-update-on="change" min="100" max="1200"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Jitter" id="tab-5012-4">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-jitter.size-label" for="yPlot-jitter.size">Jitter Point Size</label>
#>             <input id="yPlot-jitter.size" type="number" class="shiny-input-number form-control" value="1" data-update-on="change" min="0.1" max="10"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-jitter.width-label" for="yPlot-jitter.width">Jitter Width</label>
#>             <input id="yPlot-jitter.width" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-jitter.color">Jitter Point Color</label>
#>             <input id="yPlot-jitter.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-jitter.shape.legend.size-label" for="yPlot-jitter.shape.legend.size">Shape Legend Size</label>
#>             <input id="yPlot-jitter.shape.legend.size" type="number" class="shiny-input-number form-control" value="5" data-update-on="change" min="0" max="20"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="yPlot-jitter.shape.legend.show" style="padding-right: 10px;">Show Shape Legend</label>
#>               <input id="yPlot-jitter.shape.legend.show" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="yPlot-jitter.shape.legend.show"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Box" id="tab-5012-5">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-boxplot.color">Boxplot Color</label>
#>             <input id="yPlot-boxplot.color" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="yPlot-boxplot.show.outliers" style="padding-right: 10px;">Show Outliers</label>
#>               <input id="yPlot-boxplot.show.outliers" type="checkbox"/>
#>               <label class="switch label-success bg-success" for="yPlot-boxplot.show.outliers"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-boxplot.outlier.size-label" for="yPlot-boxplot.outlier.size">Outlier Size</label>
#>             <input id="yPlot-boxplot.outlier.size" type="number" class="shiny-input-number form-control" value="1.5" data-update-on="change" min="0" max="10"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="material-switch">
#>               <label for="yPlot-boxplot.fill" style="padding-right: 10px;">Fill Boxplot</label>
#>               <input id="yPlot-boxplot.fill" type="checkbox" checked="checked"/>
#>               <label class="switch label-success bg-success" for="yPlot-boxplot.fill"></label>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-boxplot.lineweight-label" for="yPlot-boxplot.lineweight">Boxplot Line Weight</label>
#>             <input id="yPlot-boxplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-boxgap-label" for="yPlot-boxgap">Boxplot Position Dodge</label>
#>             <input id="yPlot-boxgap" type="number" class="shiny-input-number form-control" value="0.3" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-boxgroupgap-label" for="yPlot-boxgroupgap">Boxplot Group Dodge</label>
#>             <input id="yPlot-boxgroupgap" type="number" class="shiny-input-number form-control" value="0.2" data-update-on="change" min="0" max="1" step="0.05"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Violin" id="tab-5012-6">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vlnplot.lineweight-label" for="yPlot-vlnplot.lineweight">Violin Line Weight</label>
#>             <input id="yPlot-vlnplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vlnplot.scaling-label" for="yPlot-vlnplot.scaling">Violin Scaling</label>
#>             <div>
#>               <select id="yPlot-vlnplot.scaling" class="shiny-input-select"><option value="area" selected>area</option>
#> <option value="count">count</option>
#> <option value="width">width</option></select>
#>               <script type="application/json" data-for="yPlot-vlnplot.scaling" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vlnplot.quantiles-label" for="yPlot-vlnplot.quantiles">Violin Quantiles (0-1)</label>
#>             <input id="yPlot-vlnplot.quantiles" type="text" class="shiny-input-text form-control" value="" placeholder="e.g., 0.25, 0.5, 0.75" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Ridge" id="tab-5012-7">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.lineweight-label" for="yPlot-ridgeplot.lineweight">Ridge Line Weight</label>
#>             <input id="yPlot-ridgeplot.lineweight" type="number" class="shiny-input-number form-control" value="0.5" data-update-on="change" min="0" max="5" step="0.1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.scale-label" for="yPlot-ridgeplot.scale">Ridge Scale (overlap)</label>
#>             <input id="yPlot-ridgeplot.scale" type="number" class="shiny-input-number form-control" value="1.25" data-update-on="change" min="0.5" max="3"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.ymax.expansion-label" for="yPlot-ridgeplot.ymax.expansion">Ridge Y-max Expansion</label>
#>             <input id="yPlot-ridgeplot.ymax.expansion" type="number" class="shiny-input-number form-control" value="NA" data-update-on="change" min="0" max="1"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.shape-label" for="yPlot-ridgeplot.shape">Ridge Shape</label>
#>             <div>
#>               <select id="yPlot-ridgeplot.shape" class="shiny-input-select"><option value="smooth" selected>smooth</option>
#> <option value="hist">hist</option></select>
#>               <script type="application/json" data-for="yPlot-ridgeplot.shape" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.bins-label" for="yPlot-ridgeplot.bins">Ridge Bins</label>
#>             <input id="yPlot-ridgeplot.bins" type="number" class="shiny-input-number form-control" value="30" data-update-on="change" min="5" max="100"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-ridgeplot.binwidth-label" for="yPlot-ridgeplot.binwidth">Ridge Binwidth</label>
#>             <input id="yPlot-ridgeplot.binwidth" type="number" class="shiny-input-number form-control" data-update-on="change" min="0"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Facet" id="tab-5012-8">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-split.by-label" for="yPlot-split.by">Split by (facet)</label>
#>             <div>
#>               <select id="yPlot-split.by" class="shiny-input-select"><option value="" selected></option>
#> <option value="" selected></option></select>
#>               <script type="application/json" data-for="yPlot-split.by">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-split.adjust-label" for="yPlot-split.adjust">Facet Scaling</label>
#>             <div>
#>               <select id="yPlot-split.adjust" class="shiny-input-select"><option value="fixed">fixed</option>
#> <option value="free" selected>free</option>
#> <option value="free_y">free_y</option>
#> <option value="free_x">free_x</option></select>
#>               <script type="application/json" data-for="yPlot-split.adjust" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>             </div>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
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
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
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
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Axes" id="tab-5012-9">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-font.type-label" for="yPlot-font.type">Font Type</label>
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
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="yPlot-axis.showline" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Axis Lines</span>
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
#>                 <input id="yPlot-axis.mirror" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Mirror Axis Lines</span>
#>               </label>
#>             </div>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <div class="checkbox">
#>               <label>
#>                 <input id="yPlot-show.major.grid.x" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show X Gridlines</span>
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
#>                 <input id="yPlot-show.major.grid.y" type="checkbox" class="shiny-input-checkbox" checked="checked"/>
#>                 <span>Show Y Gridlines</span>
#>               </label>
#>             </div>
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
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickangle.x-label" for="yPlot-axis.tickangle.x">X-axis Tick Label Angle</label>
#>             <input id="yPlot-axis.tickangle.x" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-axis.tickangle.y-label" for="yPlot-axis.tickangle.y">Y-axis Tick Label Angle</label>
#>             <input id="yPlot-axis.tickangle.y" type="number" class="shiny-input-number form-control" value="0" data-update-on="change" min="-180" max="180" step="15"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
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
#>           <div class="form-group shiny-input-container" data-shiny-input-type="colour">
#>             <label class="control-label" for="yPlot-text.colour">Axis Title Colour</label>
#>             <input id="yPlot-text.colour" type="text" class="form-control shiny-colour-input" data-init-value="#000000" data-show-colour="both" data-palette="square"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>     <div class="tab-pane" data-value="Lines" id="tab-5012-10">
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-hline.intercepts-label" for="yPlot-hline.intercepts">Y-intercepts</label>
#>             <input id="yPlot-hline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
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
#>           <hr/>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-vline.intercepts-label" for="yPlot-vline.intercepts">X-intercepts</label>
#>             <input id="yPlot-vline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
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
#>           <hr/>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-abline.slopes-label" for="yPlot-abline.slopes">Slopes</label>
#>             <input id="yPlot-abline.slopes" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-abline.intercepts-label" for="yPlot-abline.intercepts">Y-intercepts</label>
#>             <input id="yPlot-abline.intercepts" type="text" class="shiny-input-text form-control" value="" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-abline.colors-label" for="yPlot-abline.colors">Colors</label>
#>             <input id="yPlot-abline.colors" type="text" class="shiny-input-text form-control" value="#000000" data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-abline.widths-label" for="yPlot-abline.widths">Widths</label>
#>             <input id="yPlot-abline.widths" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>       <div class="row">
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-abline.linetypes-label" for="yPlot-abline.linetypes">Line types</label>
#>             <input id="yPlot-abline.linetypes" type="text" class="shiny-input-text form-control" value="dashed" placeholder="solid, dashed, dotted, ..." data-update-on="change"/>
#>           </div>
#>         </div>
#>         <div class="col-sm-6">
#>           <div class="form-group shiny-input-container">
#>             <label class="control-label" id="yPlot-abline.opacities-label" for="yPlot-abline.opacities">Opacities (0-1)</label>
#>             <input id="yPlot-abline.opacities" type="text" class="shiny-input-text form-control" value="1" data-update-on="change"/>
#>           </div>
#>         </div>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <div class="row">
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <div class="form-group shiny-input-container">
#>       <div class="material-switch">
#>         <label for="yPlot-auto.update" style="padding-right: 10px;">Auto Update</label>
#>         <input id="yPlot-auto.update" type="checkbox"/>
#>         <label class="switch label-success bg-success" for="yPlot-auto.update"></label>
#>       </div>
#>     </div>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button id="yPlot-update" style="width:100%;" type="button" class="btn btn-default action-button">
#>       <span class="action-label">Update</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3" style="margin-top: 25px;">
#>     <button class="btn btn-default action-button btn-secondary" id="yPlot-reset" style="width:100%;" type="button">
#>       <span class="action-label">Reset</span>
#>     </button>
#>   </div>
#>   <div class="col-sm-3">
#>     <div class="form-group shiny-input-container" style="width:100%;">
#>       <label class="control-label" id="yPlot-download.type-label" for="yPlot-download.type">Download Format</label>
#>       <div>
#>         <select id="yPlot-download.type" class="shiny-input-select"><option value="png" selected>png</option>
#> <option value="svg">svg</option></select>
#>         <script type="application/json" data-for="yPlot-download.type" data-nonempty="">{"plugins":["selectize-plugin-a11y"]}</script>
#>       </div>
#>     </div>
#>   </div>
#> </div>
#> <br/>
```
